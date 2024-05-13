package bigWork.beans;

public class Login {
    String username = new String();
    boolean isLoggedIn = false;

    public String getUsername() {
        return this.username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public boolean getIsLoggedIn() {
        return this.isLoggedIn;
    }

    public void setIsLoggedIn(boolean isloggedIn) {
        isLoggedIn = isloggedIn;
    }

    public void login(String username) {
        this.username = username;
        this.isLoggedIn = true;
    }

    public String logout() {
        String logoutName = this.username;
        this.username = "";
        this.isLoggedIn = false;
        return logoutName;
    }
}
