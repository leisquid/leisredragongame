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
<%@ page import = "bigWork.handles.Encrypt" %>

<jsp:useBean id="login" class="bigWork.beans.Login" scope="session" />

<%
    boolean isExceptionOccurs = false;
    String exceptionInfo = new String();
%>

<!DOCTYPE html>
<meta charset="UTF-8" />

<%
    String userName = new String();
    String password = new String();
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


    if (login.getIsLoggedIn() == false) {
        userName = request.getParameter("userName");
        password = request.getParameter("password");
        boolean boo = ((userName.length() > 0) && (password.length() > 0));
        if (boo == false) {
            backInfo = "未输入用户名或密码！";
        } else {
            encryptedPassword = Encrypt.encrypt(password, "yuijsp");
        }
        if((isExceptionOccurs == false) && (boo == true)) {
            String querySql = "select * from " + tableName + " where username = \'" + userName
                    + "\' and password = \'" + encryptedPassword + "\';";
            try {
                preparedStatement = connection.prepareStatement(querySql);
                resultSet = preparedStatement.executeQuery();
                if (resultSet.next() == true) {
                    login.login(userName);
                    backInfo = login.getUsername() + "，登录成功！";
                } else {
                    backInfo = "用户名或密码有误！";
                }
            } catch (SQLException exception) {
                isExceptionOccurs = true;
                exceptionInfo = exceptionInfo + "登录出错了！<br />" + exception.toString() + "<br />";
            }
        }
    } else {
        backInfo = "已经有用户" + login.getUsername() + "登录了，不能重复登录！";
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
        <title>用户登录结果 - 编辑模式</title>
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
