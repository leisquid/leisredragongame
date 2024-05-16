/**
 * ***.java: a Java file of Leisredragongame
 *
 * Leisredragongame is free software licensed under the GNU Affero General
 * Public License version 3 published by the Free Software Foundation and
 * without any warranty for liability or particular purpose.
 *
 * You can modify and/or redistribute it under the GNU Affero General Public
 * License version 3 or any later version you want.
 *
 * License file can be found in this repository; if not, please see
 * <https://www.gnu.org/licenses/agpl-3.0.txt>.
 */

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
