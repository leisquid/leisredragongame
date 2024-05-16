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

package bigWork.handles;

public class Encrypt {
    public static String encrypt(String sourceString, String password) {
        char[] p = password.toCharArray();
        int n = p.length;
        char[] c = sourceString.toCharArray();
        int m = c.length;
        for (int k = 0; k < m; k++) {
            int pwd = c[k] + p[k % n];   //加密算法。
            c[k] = (char) pwd;
        }
        return new String(c);    //返回密文。
    }
}
