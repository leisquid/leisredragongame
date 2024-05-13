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

<%
    boolean isExceptionOccurs = false;
    String exceptionInfo = new String();
%>

<!DOCTYPE html>
<meta charset="UTF-8" />

<%
    isExceptionOccurs = false;
    exceptionInfo = "";

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

    // 查询所有词条的总数。
    if(isExceptionOccurs != true) {
        String querySqlForAllWordCount = "select count(*) from " + tableName + ";";
        try {
            preparedStatement = connection.prepareStatement(querySqlForAllWordCount);
            resultSet = preparedStatement.executeQuery();
            if(resultSet.next()) {
                words.init(resultSet.getInt(1));
            } else {
                isExceptionOccurs = true;
                exceptionInfo = exceptionInfo + "没有查到所有词条的总数！<br />";
            }
        } catch (SQLException exception) {
            isExceptionOccurs = true;
            exceptionInfo = exceptionInfo + "无法查询所有词条的总数！<br />" + exception.toString() + "<br />";
        }

        // 查询所有词条。
        String querySqlForAllWord = "select reading_id, reading, read_type, panel_id, tail_symbol from "
                + tableName + ";";
        try {
            preparedStatement = connection.prepareStatement(querySqlForAllWord);
            resultSet = preparedStatement.executeQuery();
            int allWordIndex = 0;
            while(resultSet.next()) {
                allWordIndex ++;
                words.setReadingIdByIndex(allWordIndex, resultSet.getInt(1));
                words.setReadingByIndex(allWordIndex, resultSet.getString(2));
                words.setReadTypeByIndex(allWordIndex, resultSet.getInt(3));
                words.setPanelIdByIndex(allWordIndex, resultSet.getInt(4));
                words.setTailSymbolByIndex(allWordIndex, resultSet.getString(5));
            }
        } catch (Exception exception) {
            isExceptionOccurs = true;
            exceptionInfo = exceptionInfo + "查询所有词条出错了！<br />" + exception.toString() + "<br />";
        }
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
        <title>游戏模式 - 词语接龙小工具</title>
    </head>
    <body>
    	<%@ include file = "top.txt" %>

        <div align="center">
            <table width="1200" class="lookupTable">

                <tr>
                    <td colspan="10">
                        <%
                            if(isExceptionOccurs == true) {
                                out.println("<h2 style=\"color: red\">" + exceptionInfo + "</h2>");
                            } else {
                        %>

                        <h2>请点击目标卡牌</h2>
                        <%
                            }
                        %>
                    </td>
                </tr>
                <%@ include file="symbolList.txt" %>

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
                            out.println("<a href=\"gameContinue.jsp?symbol=" + words.getTailSymbolByIndex(picCounter) + "\">");
                            out.println("<img src=\"images/" + words.getPanelIdByIndex(picCounter) + ".png\" height=\"100\" />");
                            out.println("</a>");
                            out.println("</td>");
                        } while ((picCounter < words.getTotal()) && (picCounter % 10 != 0));

                        out.println("</tr>");

                        out.println("<tr>");
                        do {
                            textCounter ++;
                            out.println("<td align=\"center\">");
                            out.print("<a href=\"gameContinue.jsp?symbol=" + words.getTailSymbolByIndex(textCounter)
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
                            out.print("\"" + textColorClass + "\">" + words.getReadingByIndex(textCounter) + words.getTailSymbolByIndex(textCounter) + "</a>");
                            out.println("</td>");
                        } while ((textCounter < words.getTotal()) && (textCounter % 10 != 0));
                        out.println("</tr>");
                    }
                %>
            </table>
        </div>

		<%@ include file = "bottom.txt" %>
 	</body>
</html>