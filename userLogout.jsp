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

<html>
    <head>
        <title>Logging out...</title>
    </head>
    <body>

    </body>
</html>

<%
    if (login.getIsLoggedIn() == true) {
        login.logout();
    }
    response.sendRedirect("editMode.jsp");
%>
