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

<jsp:useBean id="info" class="bigWork.beans.InfoSet" scope="page" />
<jsp:useBean id="login" class="bigWork.beans.Login" scope="session" />

<%
    boolean isExceptionOccurs = false;
    String exceptionInfo = new String();
%>

<!DOCTYPE html>
<meta charset="UTF-8" />

<%
    int readingId = 0;
    String reading = new String();

    if(login.getIsLoggedIn() == false) {
        isExceptionOccurs = true;
        exceptionInfo = "用户未登录，无法修改！";
    } else {
        try {
            readingId = Integer.parseInt(request.getParameter("readingId"));
        } catch (Exception exception) {
            isExceptionOccurs = true;
            exceptionInfo = "没有指定值！<br />" + exception.toString() + "<br />";
        }

        // 建立连接。
        String tableName = "dragongame";
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

        // 准备查询目标词条。
        // 定义查询语句。
        String querySql = "select reading from " + tableName + " where reading_id = " + readingId + ";";

        // 开始准备查询。
        try {
            preparedStatement = connection.prepareStatement(querySql);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                reading = resultSet.getString(1);

            } else {
                isExceptionOccurs = true;
                exceptionInfo = exceptionInfo + "没有查到 " + readingId + " 的词条！<br />";
            }
        } catch (SQLException exception) {
            isExceptionOccurs = true;
            exceptionInfo = exceptionInfo + "查询出错了！<br />" + exception.toString() + "<br />";
        }

        try {
            connection.close();
        } catch (SQLException exception) {
            isExceptionOccurs = true;
            exceptionInfo = exceptionInfo + "关闭连接出错了！<br />" + exception.toString() + "<br />";
        }

    }
%>

<html>
    <head>
        <title>删除词条确认 - 编辑模式</title>
    </head>
    <body>
        <%@ include file="top.txt" %>
        <div align="center">
            <%
                if(isExceptionOccurs == true) {
                    out.println("<h2 style=\"color: red\">" + exceptionInfo + "</h2>");
                } else {
            %>
            <h2 style="text-align: center">确定要删除：【<%= readingId %>】“<%= reading %>”的词条吗？</h2>
            <form action="deleteResult.jsp" method="post">
                <input type="hidden" name="readingId" value="<%= readingId %>" />
                <input type="submit" value="确定" />
            </form>
            <%
                }
            %>
        <%@ include file="bottom.txt" %>
    </body>
</html>
