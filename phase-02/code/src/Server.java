import java.net.*;
import java.io.*;
import java.util.*;
import java.util.Collections;

public class Server {
    private static final int PORT = 13337;
    private static Map<String, User> users = Collections.synchronizedMap(new HashMap<>());
    static Map<String, Room> rooms = Collections.synchronizedMap(new HashMap<>());
    static Map<String, String> tickets = Collections.synchronizedMap(new HashMap<>());
    private static int ticketCounter = 1000;

    public static synchronized String getCounter() {
        return String.valueOf(ticketCounter++);
    }
    public static synchronized void loadTickets() {
        try (BufferedReader br = new BufferedReader(new FileReader(User.TICKET_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(" ");
                if (parts.length == 2) {
                    tickets.put(parts[0], parts[1]);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    public static String findTicket(String pseudonym) {
        return tickets.get(pseudonym);
    }

    public static synchronized void addUser(User user) {
        users.put(user.getTicket(), user);
    }

    public static synchronized void removeUser(User user) {
        users.remove(user.getTicket());
    }

    public static synchronized User getUserByTicket(String ticket) {
        return users.get(ticket);
    }

    public static synchronized Room getRoom(String roomName) {
        return rooms.computeIfAbsent(roomName, Room::new);
    }



    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(PORT);
        System.out.println("Server started on port " + PORT);
        loadTickets();

        while (true) {
            Socket clientSocket = serverSocket.accept();
            System.out.println("Client connected: " + clientSocket.getInetAddress());
            User user = new User(clientSocket);
            addUser(user);
            new Thread(user).start();
        }
    }
}