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

<html>
    <head>
        <title>用户登录 - 编辑模式</title>
    </head>
    <body>
        <%@ include file = "top.txt" %>

        <%
            if (login.getIsLoggedIn() == true) {
        %>
        <h2 style="text-align: center; color: red">用户<%= login.getUsername() %>已经登录力！</h2>
        <%
            } else {
        %>
        <div align="center">
            <table width="1200" border="0" class="lookupTable">
                <tr><td><h2 style="text-align: left">用户登录</h2></td></tr>

                <tr>
                    <td>
                        <form action="userLoginResult.jsp" method="post" style="text-align: left;">
                            用户名称：
                            <input type="text" maxlength="20" name="userName" />
                            <br />
                            用户密码：
                            <input type="password" maxlength="20" name="password" />
                            <br />
                            <input type="submit" value="登录" />
                        </form>
                    </td>
                </tr>
            </table>
        </div>
        <%
            }
        %>

        <%@ include file = "bottom.txt" %>
    </body>
</html>
