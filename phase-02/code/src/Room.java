import java.util.*;

public class Room {
    private String roomName;
    private Set<User> users = Collections.synchronizedSet(new HashSet<>());
    private User moderator;

    public Room(String roomName) {
        this.roomName = roomName;
    }

    public String getRoomName() {
        return roomName;
    }

    public User getModerator() {
        return moderator;
    }

    public Set<User> getUsers() {
        return users;
    }

    public void addUser(User user) {
        synchronized (users) {
            if (users.isEmpty()) {
                moderator = user;
                user.sendMessage("info You are the moderator of this room.");
            }
            users.add(user);
        }
    }

}
