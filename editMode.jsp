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

<jsp:useBean id="login" class="bigWork.beans.Login" scope="session" />

<!DOCTYPE html>
<meta charset="UTF-8" />

<%
    String backInfo = new String();

    if (login.getIsLoggedIn() == true) {
        backInfo = "当前登录用户：" + login.getUsername();
    } else {
        backInfo = "当前用户未登录，您无法对词库进行操作";
    }
%>

<html>
    <head>
        <title>编辑模式 - 词语接龙小工具</title>
    </head>
    <body>
        <%@ include file = "top.txt" %>

        <br /><br />
        <table align="center">
            <%
                if (login.getIsLoggedIn() == true) {
            %>
            <tr><td><h1><a href="insertWord.jsp" style="font-family: serif;">添加词条</a></h1></td></tr>
            <tr><td><h1><a href="searchForEdit.jsp" style="font-family: serif;">编辑词条</a></h1></td></tr>
            <tr><td><h1><a href="deleteWord.jsp" style="font-family: serif;">删除词条</a></h1></td></tr>
            <%
            } else {
            %>
            <tr><td><h1><del style="font-family: serif;">添加词条</del></h1></td></tr>
            <tr><td><h1><del style="font-family: serif;">编辑词条</del></h1></td></tr>
            <tr><td><h1><del style="font-family: serif;">删除词条</del></h1></td></tr>
            <%
                }
            %>

            <tr><td><h1>
                <%
                    if (login.getIsLoggedIn() == true) {
                %>
                <a href="userLogout.jsp" style="font-family: serif;">用户登出</a>
                <%
                    } else {
                %>
                <a href="userLogin.jsp" style="font-family: serif;">用户登录</a>
                <%
                    }
                %>
            </h1></td></tr>
        </table>
        <br />
        <h2 style="text-align: center"><%= backInfo %></h2>
        <%@ include file = "bottom.txt" %>
    </body>
</html>
