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
    int originalReadingId = 0;
    String backInfo = new String();

    if(login.getIsLoggedIn() == false) {
        isExceptionOccurs = true;
        exceptionInfo = "用户未登录，无法添加！";
    } else {
        try {
            info.setReadingId(Integer.parseInt(request.getParameter("readingId")));
            info.setPanelId(Integer.parseInt(request.getParameter("panelId")));
            info.setReading(request.getParameter("reading"));
            info.setHeadSymbol(request.getParameter("headSymbol"));
            info.setTailSymbol(request.getParameter("tailSymbol"));
            info.setDetailText(request.getParameter("detailText"));
            info.setReadType(Integer.parseInt(request.getParameter("readType")));
            info.setIsCharacter(Integer.parseInt(request.getParameter("isCharacter")));
        } catch (Exception exception) {
            isExceptionOccurs = true;
            exceptionInfo = "传入参数有误！<br />" + exception + "<br />";
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

        String querySql = new String();
        if((isExceptionOccurs == false) && (info.getReadingId() > 0)) {
            try {
                querySql = "insert into " + tableName +
                        " values (0, " + info.getReadingId() +
                        ", \'" + info.getReading() +
                        "\', " + info.getReadType() +
                        ", " + info.getPanelId() +
                        ", \'" + info.getDetailText() +
                        "\', \'" + info.getHeadSymbol() +
                        "\', \'" + info.getTailSymbol() +
                        "\', " + info.getIsCharacter() +
                        ");";
                preparedStatement = connection.prepareStatement(querySql);
                int returnedValue = preparedStatement.executeUpdate();
                if (returnedValue != 0) {
                    backInfo = info.getReadingId() + "：“" + info.getReading() + "”添加成功！<br />" +
                            "可以<a href=\"showInfo.jsp?infoMode=1&search=" + info.getReadingId() + "\">" +
                            "点我查看新增词条的详情</a>。";
                } else {
                    backInfo = "词条添加失败！SQL 返回值：" + returnedValue;
                }
            } catch (SQLException exception) {
                isExceptionOccurs = true;
                exceptionInfo = exceptionInfo + "该词条 ID 可能与其他词条 ID 雷同，添加失败！<br />"
                        + exception.toString() + "<br />";
            }
        }

        String querySqlForUpdatingNum = new String();
        if(isExceptionOccurs == false) {
            try {
                querySqlForUpdatingNum = "UPDATE dragongame, (SELECT @id := 0) dm\n" +
                        "SET num = (@id := @id + 1);";
                preparedStatement = connection.prepareStatement(querySqlForUpdatingNum);
                int returnedValue = preparedStatement.executeUpdate();
                if(returnedValue == 0) {
                    backInfo = backInfo + "但是词条顺序失败了，SQL 返回值：" + returnedValue;
                }
            } catch (SQLException exception) {
                isExceptionOccurs = true;
                exceptionInfo = exceptionInfo + "更新词条顺序失败力！<br />" + exception.toString() + "<br />";
            }
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
    <title>词条添加结果 - 编辑词条</title>
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
