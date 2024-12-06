import java.util.*;

/**
 * The Room class represents a chat room where users can join, leave, and communicate with each other.
 * Each room has a name, a set of users, and a moderator.
 */
public class Room {
    private String roomName; // The name of the room
    private Set<User> users = Collections.synchronizedSet(new HashSet<>()); // The set of users in the room
    private User moderator; // The moderator of the room

    /**
     * Constructs a Room with the specified name.
     *
     * @param roomName the name of the room
     */
    public Room(String roomName) {
        this.roomName = roomName;
    }

    /**
     * Returns the name of the room.
     *
     * @return the name of the room
     */
    public String getRoomName() {
        return roomName;
    }

    /**
     * Returns the moderator of the room.
     *
     * @return the moderator of the room
     */
    public User getModerator() {
        return moderator;
    }

    /**
     * Returns the set of users in the room.
     *
     * @return the set of users in the room
     */
    public Set<User> getUsers() {
        return users;
    }

    /**
     * Adds a user to the room. If the room is empty, the user becomes the moderator.
     *
     * @param user the user to add to the room
     */
    public void addUser(User user) {
        synchronized (users) {
            if (users.isEmpty()) {
                moderator = user;
                user.sendMessage("info You are the moderator of this room.");
            }
            users.add(user);
            user.sendMessage("info You have joined room: " + roomName);
        }
    }

    /**
     * Removes a user from the room. If the user is the moderator, a new moderator is assigned.
     * If the room becomes empty, it is removed from the server.
     *
     * @param user the user to remove from the room
     */
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

    /**
     * Broadcasts a message to all users in the room.
     *
     * @param message the message to broadcast
     */
    public void broadcast(String message) {
        synchronized (users) {
            for (User user : users) {
                user.sendMessage(message);
            }
        }
    }

    /**
     * Kicks a user from the room by their pseudonym and sends them a reason for the kick.
     *
     * @param pseudonym the pseudonym of the user to kick
     * @param reason the reason for kicking the user
     */
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