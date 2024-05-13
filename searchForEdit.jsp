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

<jsp:useBean id="words" class="bigWork.beans.WordsSet" scope="page" />
<jsp:useBean id="login" class="bigWork.beans.Login" scope="session" />

<%
    boolean isExceptionOccurs = false;
    String exceptionInfo = new String();
%>

<!DOCTYPE html>
<meta charset="UTF-8" />

<%
    String backWord = new String();

    if(login.getIsLoggedIn() == false) {
        isExceptionOccurs = true;
        exceptionInfo = "用户未登录，无法修改！";
    } else {
        String searchMethod = request.getParameter("searchMethod");
        String searchContent = request.getParameter("searchContent");

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


        // 如果搜索内容为空或者未初始化，那么不执行查询。
        if (isExceptionOccurs != true) {
            if(searchContent == null || searchContent.length() == 0) {
                backWord = "请输入要查询的内容。";
            } else {
                backWord = "“" + searchContent + "”的";
                switch (searchMethod) {
                    case "num":
                        backWord = backWord + "序号";
                        break;
                    case "reading":
                        backWord = backWord + "名称";
                        break;
                    case "readingId":
                        backWord = backWord + " ID ";
                        break;
                    case "panelId":
                        backWord = backWord + "图片 ID ";
                        break;
                    case "headSymbol":
                        backWord = backWord + "首字韵母";
                        break;
                    case "tailSymbol":
                        backWord = backWord + "尾字韵母";
                        break;
                    default:
                        break;
                }
                backWord = backWord + "查询结果";

                String additionalSqlText1 = new String();
                String additionalSqlText2 = new String();
                switch (searchMethod) {
                    case "num":
                        additionalSqlText1 = "num = ";
                        additionalSqlText2 = "";
                        break;
                    case "reading":
                        additionalSqlText1 = "reading like \'%";
                        additionalSqlText2 = "%\'";
                        break;
                    case "readingId":
                        additionalSqlText1 = "reading_id = ";
                        additionalSqlText2 = "";
                        break;
                    case "panelId":
                        additionalSqlText1 = "panel_id = ";
                        additionalSqlText2 = "";
                        break;
                    case "headSymbol":
                        additionalSqlText1 = "head_symbol like \'";
                        additionalSqlText2 = "\'";
                        break;
                    case "tailSymbol":
                        additionalSqlText1 = "tail_symbol like \'";
                        additionalSqlText2 = "\'";
                        break;
                    default:
                        additionalSqlText1 = "reading like \'%";
                        additionalSqlText2 = "%\' ";
                        break;
                }

                String querySqlForCount = "select count(*) from " + tableName + " where "
                        + additionalSqlText1 + searchContent + additionalSqlText2 + ";";
                String querySqlForSearch = "select reading_id, reading, read_type, panel_id from "
                        + tableName + " where " + additionalSqlText1 + searchContent + additionalSqlText2 + ";";

                try {
                    preparedStatement = connection.prepareStatement(querySqlForCount);
                    resultSet = preparedStatement.executeQuery();
                    if(resultSet.next()) {
                        words.init(resultSet.getInt(1));
                    } else {
                        words.init(0);
                        isExceptionOccurs = true;
                        exceptionInfo = exceptionInfo + "没有查到词条数量！<br />";
                    }
                } catch (SQLException exception) {
                    isExceptionOccurs = true;
                    exceptionInfo = exceptionInfo + "不能在查询序号或 ID 的时候输入数字以外的字符！<br />";
                }

                try {
                    preparedStatement = connection.prepareStatement(querySqlForSearch);
                    resultSet = preparedStatement.executeQuery();
                    int allWordIndex = 0;
                    while(resultSet.next()) {
                        allWordIndex ++;
                        words.setReadingIdByIndex(allWordIndex, resultSet.getInt(1));
                        words.setReadingByIndex(allWordIndex, resultSet.getString(2));
                        words.setReadTypeByIndex(allWordIndex, resultSet.getInt(3));
                        words.setPanelIdByIndex(allWordIndex, resultSet.getInt(4));
                    }
                    if(allWordIndex == 0) {
                        backWord = backWord + "为空！";
                    } else {
                        backWord = backWord + "（" + allWordIndex + " 个词条）";
                    }
                } catch (SQLException exception) {
                    isExceptionOccurs = true;
                    exceptionInfo = exceptionInfo + "所以，查询词条失败力！<br />";
                }
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
        <title>搜索 - 编辑词条</title>
    </head>
    <body>
        <%@ include file="top.txt" %>

        <div align="center">
            <table width="1200" border="0" class="lookupTable">
                <tr><td colspan="10"><h2>搜索 - 编辑词条</h2></td></tr>
                <tr>
                    <td colspan="10">
                        <form action="searchForEdit.jsp" method="post">
                            输入要查询的内容：<br />
                            <input type="text" name="searchContent" />
                            <select name="searchMethod">
                                <option value="num" />查序号
                                <option value="reading" />查名称
                                <option value="readingId" />查 ID
                                <option value="panelId" />查图片 ID
                                <option value="headSymbol" />查首字韵母
                                <option value="tailSymbol" />查尾字韵母
                            </select>
                            <input type="submit" name="submit" value="查询" />
                        </form>
                    </td>
                </tr>

                <tr>
                    <td colspan="10">
                        为了方便搜索，查找韵母时请用“v”代替“ü”。或者<a href="listAllForEdit.jsp">点我查看所有词条</a>？
                    </td>
                </tr>

                <tr><td colspan="10">
                <%
                    if (isExceptionOccurs == true) {
                %>
                <h2 style="color: red"><%= exceptionInfo %></h2>
                <%
                    } else {
                %>
                <h2><%= backWord %></h2>
                <%
                    }
                %>
                </td></tr>
                <%
                    int picCounter = 0;
                    int textCounter = 0;
                %>

                <%
                    while (textCounter < words.getTotal()) {
                        out.println("<tr>");

                        do {
                            picCounter ++;
                            out.println("<td align=\"center\">");
                            out.println("<a href=\"editWordInfo.jsp?search=" + words.getReadingIdByIndex(picCounter) + "\">");
                            out.println("<img src=\"images/" + words.getPanelIdByIndex(picCounter) + ".png\" height=\"100\" />");
                            out.println("</a>");
                            out.println("</td>");
                        } while ((picCounter < words.getTotal()) && (picCounter % 10 != 0));

                        out.println("</tr>");

                        out.println("<tr>");
                        do {
                            textCounter ++;
                            out.println("<td align=\"center\">");
                            out.print("<a href=\"editWordInfo.jsp?search=" + words.getReadingIdByIndex(textCounter)
                                    +"\" class=");
                            String textColorClass = new String();
                            switch (words.getReadTypeByIndex(textCounter)) {
                                case 1:
                                    textColorClass = "normalColor";
                                    break;
                                case 2:
                                    textColorClass = "hiddenColor";
                                    break;
                                case 3:
                                    textColorClass = "pcrColor";
                                    break;
                                default:
                                    textColorClass = "";
                                    break;
                            }
                            out.print("\"" + textColorClass + "\">" + words.getReadingByIndex(textCounter) + "</a>");
                            out.println("</td>");
                        } while ((textCounter < words.getTotal()) && (textCounter % 10 != 0));
                        out.println("</tr>");
                    }
                %>
            </table>
        </div>

        <%@ include file="bottom.txt" %>
    </body>
</html>
