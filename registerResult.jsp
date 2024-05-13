<%--
  ***: a JSP file of Leisredragongame

  Leisredragongame is free software licensed under the GNU Affero General Public
  License version 3 published by the Free Software Foundation and without any
  warranty for liability or particular purpose.

  You can modify and/or redistribute it under the GNU Affero General Public
  License version 3 or any later version you want.

  License file can be found in this repository; if not, please see
  <https://www.gnu.org/licenses/agpl-3.0.txt>.
--%>
<%@ page contentType = "text/html" %>
<%@ page pageEncoding = "UTF-8" %>

<%@ page import = "java.sql.*" %>
<%@ page import = "javax.sql.DataSource" %>
<%@ page import = "javax.naming.Context" %>
<%@ page import = "javax.naming.InitialContext" %>

<%
    boolean isExceptionOccurs = false;
    String exceptionInfo = new String();
%>

<!DOCTYPE html>
<meta charset="UTF-8" />

<%
    String userName = request.getParameter("userName");
    String password = request.getParameter("password");
    String passwordAgain = request.getParameter("passwordAgain");
    String encryptedPassword = new String();

    String backInfo = new String();

    // 建立连接。
    String tableName = "users";
    request.setCharacterEncoding("utf-8");

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet;
    Context context = new InitialContext();
    Context contextNeeded = (Context) context.lookup("java:comp/env");
    DataSource dataSource = (DataSource) contextNeeded.lookup("bigWorkConnection");
    try {
        connection = dataSource.getConnection();
    } catch(Exception exception) {
        isExceptionOccurs = true;
        exceptionInfo = "尝试连接数据库失败！<br />" + exception.toString() + "<br />";
    }

    // 到此，如果没有抛 Exception，那么连接成功了。


    boolean boo = ((userName != null) && (userName.length() > 0) && (password != null) && (password.length() > 0));
    if (boo == false) {
        backInfo = "未输入用户名或密码！";
    } else if ((password.equals(passwordAgain)) == false) {
        backInfo = "两次输入的密码不一致！";
        boo = false;
    } else {
        encryptedPassword = Encrypt.encrypt(password, "yuijsp");
    }
    if((isExceptionOccurs == false) && (boo == true)) {
        try {
            String querySql = "insert into users values (?, ?);";
            preparedStatement = connection.prepareStatement(querySql);
            preparedStatement.setString(1, userName);
            preparedStatement.setString(2, encryptedPassword);
            int returnedValue = preparedStatement.executeUpdate();
            if (returnedValue != 0) {
                backInfo = userName + "：注册成功！请前往【编辑模式】-【用户登录/注册】界面登录。" + password + passwordAgain
                 + password.equals(passwordAgain);
            } else {
                backInfo = "注册失败！SQL 返回值：" + returnedValue;
            }

        } catch (SQLException exception) {
            isExceptionOccurs = true;
            exceptionInfo = exceptionInfo + "该会员名已被使用，请换一个名字。<br />";
        }
    } else {
        backInfo = backInfo + "注册失败！";
    }

    try {
        connection.close();
    } catch (SQLException exception) {
        isExceptionOccurs = true;
        exceptionInfo = exceptionInfo + "关闭连接出错了！<br />" + exception.toString() + "<br />";
    }
%>

<html>
    <head>
        <title>用户注册结果 - 内部页面</title>
    </head>
    <body>
        <%@ include file = "top.txt" %>
        <div align="center">
            <%
                if (isExceptionOccurs == true) {
                    out.println("<h2 style=\"color: red\">" + exceptionInfo + "</h2>");
                } else {
            %>
            <h2><%= backInfo %></h2>
            <%
                }
            %>
        </div>
        <%@ include file = "bottom.txt" %>
    </body>
</html>
