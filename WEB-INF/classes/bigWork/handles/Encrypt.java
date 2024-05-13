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
