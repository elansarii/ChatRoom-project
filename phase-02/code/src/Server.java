import java.net.*;
import java.io.*;
import java.util.*;
import java.util.Collections;

/**
 * The Server class represents a server that handles multiple client connections,
 * manages users, rooms, and tickets. It listens for incoming client connections
 * and starts a new thread for each connected client.
 */
public class Server {
    private static final int PORT = 13337; // The port number the server listens on
    private static Map<String, User> users = Collections.synchronizedMap(new HashMap<>()); // Map of users by their tickets
    static Map<String, Room> rooms = Collections.synchronizedMap(new HashMap<>()); // Map of rooms by their names
    static Map<String, String> tickets = Collections.synchronizedMap(new HashMap<>()); // Map of tickets by pseudonyms
    private static int ticketCounter = 1000; // Counter for generating unique tickets

    /**
     * Returns the next ticket counter value as a string.
     *
     * @return the next ticket counter value
     */
    public static synchronized String getCounter() {
        return String.valueOf(ticketCounter++);
    }

    /**
     * Finds the ticket associated with the given pseudonym.
     *
     * @param pseudonym the pseudonym to look up
     * @return the ticket associated with the pseudonym, or null if not found
     */
    public static String findTicket(String pseudonym) {
        return tickets.get(pseudonym);
    }

    /**
     * Adds a user to the server's user map.
     *
     * @param user the user to add
     */
    public static synchronized void addUser(User user) {
        users.put(user.getTicket(), user);
    }

    /**
     * Removes a user from the server's user map.
     *
     * @param user the user to remove
     */
    public static synchronized void removeUser(User user) {
        users.remove(user.getTicket());
    }

    /**
     * Retrieves a user by their ticket.
     *
     * @param ticket the ticket to look up
     * @return the user associated with the ticket, or null if not found
     */
    public static synchronized User getUserByTicket(String ticket) {
        return users.get(ticket);
    }

    /**
     * Retrieves a room by its name, creating it if it does not exist.
     *
     * @param roomName the name of the room
     * @return the room associated with the name
     */
    public static synchronized Room getRoom(String roomName) {
        return rooms.computeIfAbsent(roomName, Room::new);
    }

    /**
     * Returns the map of users.
     *
     * @return the map of users
     */
    public static Map<String, User> getUsers() {
        return users;
    }

    /**
     * Returns the map of rooms.
     *
     * @return the map of rooms
     */
    public static Map<String, Room> getRooms() {
        return rooms;
    }

    /**
     * Returns the map of tickets.
     *
     * @return the map of tickets
     */
    public static Map<String, String> getTickets() {
        return tickets;
    }

    /**
     * The main method to start the server. It listens for incoming client connections
     * and starts a new thread for each connected client.
     *
     * @param args command-line arguments (not used)
     * @throws IOException if an I/O error occurs when opening the socket
     * @throws InterruptedException if the thread is interrupted
     */
    public static void main(String[] args) throws IOException, InterruptedException {
        ServerSocket serverSocket = new ServerSocket(PORT);
        System.out.println("Server started on port " + PORT);

        while (true) {
            Socket clientSocket = serverSocket.accept();
            System.out.println("Client connected: " + clientSocket.getInetAddress());
            User user = new User(clientSocket);
            addUser(user);
            new Thread(user).start();
        }
    }
}