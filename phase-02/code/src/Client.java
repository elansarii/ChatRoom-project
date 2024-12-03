import java.io.*;
import java.net.*;
import java.time.*;
import java.time.format.*;

public class Client {
    private static final String SERVER_IP = "127.0.0.1";
    private static final int SERVER_PORT = 13337;
    private Socket socket;
    private PrintWriter out;
    private BufferedReader in;

    public static String timestamp() {
        return LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }

    public static void main(String[] args) {
        try {
            Client client = new Client();
            client.start();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void start() throws IOException {
        socket = new Socket(SERVER_IP, SERVER_PORT);
        out = new PrintWriter(socket.getOutputStream(), true);
        in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

        new Thread(new Runnable() {
            public void run() {
                try {
                    String serverMessage;
                    while ((serverMessage = in.readLine()) != null) {
                        System.out.println("[" + timestamp() + "yuup] " + serverMessage);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }).start();

        BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in));
        while (true) {
            String command = userInput.readLine();
            out.println(command);
        }
    }
}
