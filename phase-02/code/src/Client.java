import java.io.*;
import java.net.*;
import java.time.*;
import java.time.format.*;

/**
 * The Client class represents a client that connects to a server, sends commands, and receives messages.
 * It establishes a connection to the server, handles input/output streams, and manages user interactions.
 */
public class Client {
    private static String SERVER_IP;  // The IP address of the server
    private static int SERVER_PORT;   // The port number of the server
    private Socket socket;            // The socket for connecting to the server
    private PrintWriter out;          // The output stream for sending messages to the server
    private BufferedReader in;        // The input stream for receiving messages from the server

    /**
     * Returns the current timestamp in ISO_LOCAL_DATE_TIME format.
     *
     * @return the current timestamp as a String
     */
    public static String timestamp() {
        return LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }

    /**
     * The main method to start the client.
     *
     * @param args command-line arguments (not used)
     */
    public static void main(String[] args) {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(System.in))) {
            System.out.print("Enter server IP: ");
            SERVER_IP = reader.readLine().trim();

            System.out.print("Enter server port: ");
            SERVER_PORT = Integer.parseInt(reader.readLine().trim());

            Client client = new Client();
            client.start();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Starts the client by establishing a connection to the server and handling input/output streams.
     *
     * @throws IOException if an I/O error occurs when creating the socket or streams
     */
    public void start() throws IOException {
        socket = new Socket(SERVER_IP, SERVER_PORT);
        out = new PrintWriter(socket.getOutputStream(), true);
        in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

        // Thread to handle incoming messages from the server
        new Thread(() -> {
            try {
                String serverMessage;
                while ((serverMessage = in.readLine()) != null) {
                    System.out.println("[" + timestamp() + "] " + serverMessage);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();

        // Thread to handle user input and send commands to the server
        new Thread(() -> {
            try (BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in))) {
                String command;
                while ((command = userInput.readLine()) != null) {
                    out.println(command);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();
    }
}
