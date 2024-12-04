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
            user.sendMessage("info " +" have joined room: " + roomName);
        }
    }

    public void removeUser(User user) {
        synchronized (users) {
            users.remove(user);
            if (users.isEmpty()) {
                Server.rooms.remove(roomName);
            } else if (user.equals(moderator)) {
                Iterator<User> it = users.iterator();
                if (it.hasNext()) {
                    moderator = it.next();
                    moderator.sendMessage("info You are now the moderator of this room.");
                }
            }
        }
    }

    public void broadcast(String message) {
        synchronized (users) {
            for (User user : users) {
                user.sendMessage(message);
            }
        }
    }
    public void kickUser(String pseudonym, String reason) {
        synchronized (users) {
            for (User user : users) {
                if (user.getPseudonym().equals(pseudonym)) {
                    users.remove(user);
                    user.sendMessage("info You have been kicked from the room: " + roomName + " Reason: " + reason);
                    break;
                }
            }
        }
    }



}
