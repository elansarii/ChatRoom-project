import java.io.*;
import java.net.*;
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

    private void saveTicket(String ticket) {
        try {
            PrintWriter writer = new PrintWriter(TICKET_FILE, "UTF-8");
            writer.println(ticket);

            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void handleIdentification() throws IOException {
        sendMessage("Please enter your ticket or pseudonym:");

        String input = in.readLine();

        if (Server.findTicket(input) == null) {
            String currentTicket = generate(Server.getCounter());
            Server.tickets.put(input, currentTicket);
            Server.addUser(this);
            saveTicket(ticket);
            sendMessage("Ticket generated: " + ticket + " and associated with pseudonym: " + pseudonym);

        } else {
            pseudonym = Server.getUserByTicket(ticket).getPseudonym();
            sendMessage("Welcome back, " + pseudonym);

        }
    }


    @Override
    public void run() {
        try {
            out = new PrintWriter(socket.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

            handleIdentification();
            //handleRequests();
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
