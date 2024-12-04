import java.io.*;
import java.net.*;
import java.nio.Buffer;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.time.*;
import java.time.format.*;

public class User implements Runnable {
    //private static final long RATE_LIMIT = 250; // 250 ms
    public static final String TICKET_FILE = "ticket.txt";
    private Socket socket;
    private PrintWriter out;
    private BufferedReader in;
    private String ticket;
    private String pseudonym;
    private Room room;

    public User(Socket socket) {
        this.socket = socket;
    }

    public String getTicket() {
        return ticket;
    }

    public String getPseudonym() {
        return pseudonym;
    }

    public Room getRoom() {
        return room;
    }

    void sendMessage(String message) {
        out.println(message);
    }

    private void saveTicket(String pseudonym, String ticket) {
        try {
            PrintWriter writer = new PrintWriter(TICKET_FILE, "UTF-8");
            writer.println(pseudonym + "," + ticket);
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void handleRequests() throws IOException {
        String request;
        while ((request = in.readLine()) != null) {
            String[] parts = request.split(" ");
            if (parts.length == 0) {
                continue;
            }
            String command = parts[0];
            switch (command) {
                case "pseudo":
                    pseudonym = parts[1];
                    ticket = generate(Server.getCounter());
                    Server.tickets.put(ticket,pseudonym);
                    saveTicket(pseudonym, ticket);
                    sendMessage("Ticket generated: " + ticket + " and associated with pseudonym: " + pseudonym);
                    break;

                case "ticket":
                    ticket = parts[1];
                    pseudonym = Server.findTicket(ticket);
                    if (pseudonym != null) {
                        Server.tickets.put(pseudonym, ticket);
                        sendMessage("Welcome back, " + pseudonym);
                    } else {
                        sendMessage("Invalid ticket.");
                    }
                    break;

                case "join":
                    if (parts.length == 2) {
                        String roomName = parts[1];
                        Room room = Server.getRoom(roomName);
                        room.addUser(this);
                        this.room = room;
                    }
                    break;

                case "leave":
                    if (room != null) {
                        room.removeUser(this);
                        room.broadcast("info "+this+" has left the room.");
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
                    sendMessage("info Goodbye!");
                    socket.close();
                    return;
                default:
                    sendMessage("info Unknown command: " + command);
            }
        }
    }


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

    public static String timestamp() {
        return LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }
}
