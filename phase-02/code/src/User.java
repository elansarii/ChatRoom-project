import java.io.*;
import java.net.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.*;
import java.time.format.*;
import java.util.*;

/**
 * The User class represents a client connected to the server.
 * It handles user interactions, commands, and message broadcasting.
 */
public class User implements Runnable {
    public static final String TICKET_FILE = "ticket.txt";
    private static final long RATE_LIMIT = 250; // 250 ms
    private Socket socket;
    private PrintWriter out;
    private BufferedReader in;
    private String ticket;
    private String pseudonym;
    private Room room;
    private long lastRequestTime = 0;

    /**
     * Constructs a User with the given socket.
     *
     * @param socket the socket for connecting to the server
     */
    public User(Socket socket) {
        this.socket = socket;
    }

    /**
     * Returns the user's ticket.
     *
     * @return the ticket
     */
    public String getTicket() {
        return ticket;
    }

    /**
     * Returns the user's pseudonym.
     *
     * @return the pseudonym
     */
    public String getPseudonym() {
        return pseudonym;
    }

    /**
     * Returns the room the user is in.
     *
     * @return the room
     */
    public Room getRoom() {
        return room;
    }

    /**
     * Sends a message to the user.
     *
     * @param message the message to send
     */
    void sendMessage(String message) {
        out.println(message);
    }

    /**
     * Saves the user's ticket to a file.
     *
     * @param pseudonym the user's pseudonym
     * @param ticket the user's ticket
     */
    private void saveTicket(String pseudonym, String ticket) {
        try {
            PrintWriter writer = new PrintWriter(TICKET_FILE, "UTF-8");
            writer.println(pseudonym + "," + ticket);
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Prints the menu of connected users and available rooms.
     */
    private void printMenu() {
        StringBuilder menu = new StringBuilder("info Connected users:\n");
        for (User user : Server.getUsers().values()) {
            menu.append(user.getPseudonym()).append("\n");
        }
        menu.append("Available rooms:\n");
        for (String roomName : Server.rooms.keySet()) {
            menu.append(roomName).append("\n");
        }
        sendMessage(menu.toString());
    }

    /**
     * Lists the users in the current room.
     */
    private void listUsers() {
        StringBuilder users = new StringBuilder("info Connected users:\n");
        for (User user : room.getUsers()) {
            users.append(user.getPseudonym()).append("\n");
        }
        sendMessage(users.toString());
    }

    /**
     * Handles incoming requests from the user.
     *
     * @throws IOException if an I/O error occurs
     */
    private void handleRequests() throws IOException {
        String request;
        while ((request = in.readLine()) != null) {
            long currentTime = System.currentTimeMillis();
            if (currentTime - lastRequestTime < RATE_LIMIT) {
                sendMessage("[" + timestamp() + "] " + "error Rate limit exceeded. Please wait before sending another request.");
                continue;
            }
            lastRequestTime = currentTime;

            String[] parts = request.split(" ");
            if (parts.length == 0) {
                continue;
            }
            String command = parts[0];
            switch (command) {
                case "pseudo":
                    pseudonym = parts[1];
                    ticket = generate(Server.getCounter());
                    Server.tickets.put(ticket, pseudonym);
                    saveTicket(pseudonym, ticket);
                    sendMessage("[" + timestamp() + "] " + "Welcome to the chat server " + pseudonym);
                    printMenu();
                    break;

                case "ticket":
                    ticket = parts[1];
                    pseudonym = Server.findTicket(ticket);
                    if (pseudonym != null) {
                        Server.tickets.put(pseudonym, ticket);
                        sendMessage("[" + timestamp() + "] " + "Welcome back, " + pseudonym);
                    } else {
                        sendMessage("[" + timestamp() + "] " + "Invalid ticket.");
                    }
                    printMenu();
                    break;

                case "join":
                    if (parts.length == 2) {
                        String roomName = parts[1];
                        Room room = Server.getRoom(roomName);
                        room.addUser(this);
                        this.room = room;
                        room.broadcast("[" + timestamp() + "] " + "info " + this + " has joined the room.");
                        listUsers();
                    }
                    break;

                case "leave":
                    if (parts.length == 2) {
                        String roomName = parts[1];
                        Room room = Server.getRoom(roomName);
                        room.removeUser(this);
                        room.broadcast("[" + timestamp() + "] " + "info " + this + " has left " + roomName);
                    }
                    break;

                case "kick":
                    if (parts.length == 4) {
                        String roomName = parts[1];
                        String userToKick = parts[2];
                        String reason = parts[3];
                        Room room = Server.getRoom(roomName);
                        if (room != null && room.getModerator().equals(this)) {
                            room.kickUser(userToKick, reason);
                            room.broadcast("[" + timestamp() + "] " + "info " + userToKick + " has been kicked by " + room.getModerator() + " from the room for " + reason);
                        } else {
                            sendMessage("error You are not the moderator or the room does not exist.");
                        }
                    }
                    break;

                case "send":
                    if (parts.length >= 3) {
                        String roomName = parts[1];
                        String message = request.substring(request.indexOf(parts[2]));
                        Room room = Server.getRoom(roomName);
                        if (room != null) {
                            room.broadcast("[" + timestamp() + "] " + pseudonym + ": " + message);
                        }
                    }
                    break;

                case "direct":
                    if (parts.length >= 3) {
                        String pseudonym = parts[1];
                        String message = request.substring(request.indexOf(parts[2]));
                        User user = Server.getUserByTicket(Server.findTicket(pseudonym));
                        if (user != null) {
                            user.sendMessage("[" + timestamp() + "] " + this.pseudonym + ": " + message);
                        }
                    }
                    break;

                case "quit":
                    if (room != null) {
                        room.removeUser(this);
                    }
                    Server.removeUser(this);
                    sendMessage("[" + timestamp() + "] " + "info Goodbye!");
                    closeConnection();
                    System.exit(0);
                    return;

                default:
                    sendMessage("[" + timestamp() + "] " + "info Unknown command: " + command);
            }
        }
    }

    /**
     * Closes the user's connection.
     */
    private void closeConnection() {
        try {
            if (in != null) {
                in.close();
            }
            if (out != null) {
                out.close();
            }
            if (socket != null) {
                socket.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Runs the user thread to handle requests.
     */
    @Override
    public void run() {
        try {
            out = new PrintWriter(socket.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

            handleRequests();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (socket != null) {
                    socket.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Generates a unique ticket based on the given sequence.
     *
     * @param seq the sequence to base the ticket on
     * @return the generated ticket
     */
    static String generate(String seq) {
        byte[] hash = String.format("%32s", seq).getBytes();
        try {
            for (int i = 0; i < Math.random() * 64 + 1; ++i) {
                hash = MessageDigest.getInstance("SHA-256").digest(hash);
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return HexFormat.ofDelimiter(":").formatHex(hash).toString().substring(78);
    }

    /**
     * Returns the current timestamp in ISO_LOCAL_DATE_TIME format.
     *
     * @return the current timestamp as a String
     */
    public static String timestamp() {
        return LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }
}