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
<jsp:useBean id="tailWords" class="bigWork.beans.WordsSet" scope="page" />
<jsp:useBean id="headWords" class="bigWork.beans.WordsSet" scope="page" />

<%
    boolean isExceptionOccurs = false;
    String exceptionInfo = new String();
%>

<!DOCTYPE html>
<meta charset="utf-8" />

<%
    // 要从 url 中获得信息查询模式和搜索内容。形式：showInfo.jsp?infoMode=1&search=2000200
    // 设置查询模式，值为 0 时，按 num 搜索；值为 1 时，按 reading_id 搜索，其他值报错。
    int infoMode = -1;
    int search = 0;
    try {
        infoMode = Integer.parseInt(request.getParameter("infoMode"));
        search = Integer.parseInt(request.getParameter("search"));
    } catch (Exception exception) {
        isExceptionOccurs = true;
        exceptionInfo = "没有指定值！<br />" + exception.toString() + "<br />";
    }

    if(infoMode != 0 && infoMode != 1) {
        isExceptionOccurs = true;
        exceptionInfo = exceptionInfo + "搜索模式指定值出错！<br />";
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

    // 准备查询词条总数。
    int totalCount = 0;
    String querySqlForTotalCount = "select count(*) from " + tableName + ";";

    try {
        preparedStatement = connection.prepareStatement(querySqlForTotalCount);
        resultSet = preparedStatement.executeQuery();
        if(resultSet.next()) {
            totalCount = resultSet.getInt(1);
        } else {
            isExceptionOccurs = true;
            exceptionInfo = exceptionInfo + "没有查到词条总数！<br />";
        }
    } catch (SQLException exception) {
        isExceptionOccurs = true;
        exceptionInfo = exceptionInfo + "无法查询词条总数！<br />" + exception.toString() + "<br />";
    }

    // 准备查询目标词条。
    // 定义查询语句。
    String querySqlByNum = "select * from " + tableName + " where num = ?;";            // 按序号查词条。
    String querySqlById = "select * from " + tableName + " where reading_id = ?;";      // 按 Id 查词条。

    // 用于查询到结果后将读法类型整数转为对应的实际读法和对应的样式类。
    String kind = new String();
    String colorClass = new String();

    String querySql = new String();

    // 开始查询当前词条信息。
    try {
        if(infoMode == 0) {
            if(search < 1) {
                search = totalCount;
            } else if(search > totalCount) {
                search = 1;
            }
            querySql = querySqlByNum;
        } else {
            querySql = querySqlById;
        }

        // 准备查询。
        preparedStatement = connection.prepareStatement(querySql);
        preparedStatement.setInt(1, search);

        // 结果集开始收集查询结果。
        resultSet = preparedStatement.executeQuery();

        if(resultSet.next()) {
            info.fastSet(
                    resultSet.getInt(1), resultSet.getInt(2), resultSet.getString(3),
                    resultSet.getInt(4), resultSet.getInt(5), resultSet.getString(6),
                    resultSet.getString(7), resultSet.getString(8), resultSet.getInt(9)
            );

            // 把读法类型转换为对应汉字和样式类。
            switch (info.getReadType()) {
                case 1:
                    kind = "普通";
                    colorClass = "normalColor";
                    break;
                case 2:
                    kind = "隐藏";
                    colorClass = "hiddenColor";
                    break;
                case 3:
                    kind = "公主连结";
                    colorClass = "pcrColor";
                    break;
                default:
                    kind = "未知";
                    colorClass = "";
                    break;
            }
        } else {
            isExceptionOccurs = true;
            exceptionInfo = exceptionInfo + "没有查到 " + search + " 的词条！<br />";
        }

    } catch (SQLException exception) {
        isExceptionOccurs = true;
        exceptionInfo = exceptionInfo + "查询出错了！<br />" + exception.toString() + "<br />";
    }

    // 准备查询所有尾字韵母匹配的词条。
    if(isExceptionOccurs != true) {
        // 查询所有尾字韵母匹配的词条的数量。
        String querySqlForTotalTailWord = "select count(*) from " + tableName + " where tail_symbol like ?;";
        try {
            preparedStatement = connection.prepareStatement(querySqlForTotalTailWord);
            preparedStatement.setString(1, info.getHeadSymbol());
            resultSet = preparedStatement.executeQuery();
            if(resultSet.next()) {
                tailWords.init(resultSet.getInt(1));
            } else {
                tailWords.init(0);
            }
        } catch (SQLException exception) {
            isExceptionOccurs = true;
            exceptionInfo = exceptionInfo + "无法查询尾字韵母匹配的词条总数！<br />" + exception.toString() + "<br />";
        }

        // 查询所有尾字韵母匹配的词条。
        String querySqlForTailWord = "select reading_id, reading, read_type, panel_id, head_symbol, tail_symbol " +
                "from " + tableName + " where tail_symbol like ?;";
        try {
            preparedStatement = connection.prepareStatement(querySqlForTailWord);
            preparedStatement.setString(1, info.getHeadSymbol());
            resultSet = preparedStatement.executeQuery();
            int tailIndex = 0;
            while (resultSet.next()) {
                tailIndex ++;
                tailWords.setReadingIdByIndex(tailIndex, resultSet.getInt(1));
                tailWords.setReadingByIndex(tailIndex, resultSet.getString(2));
                tailWords.setReadTypeByIndex(tailIndex, resultSet.getInt(3));
                tailWords.setPanelIdByIndex(tailIndex, resultSet.getInt(4));
                tailWords.setHeadSymbolByIndex(tailIndex, resultSet.getString(5));
                tailWords.setTailSymbolByIndex(tailIndex, resultSet.getString(6));
            }
        } catch (Exception exception) {
            isExceptionOccurs = true;
            exceptionInfo = exceptionInfo + "查询尾字韵母出错了！<br />" + exception.toString() + "<br />";
        }

    }


    // 准备查询所有首字韵母匹配的词条。
    if(isExceptionOccurs != true) {
        // 查询所有首字韵母匹配的词条的数量。
        String querySqlForTotalHeadWord = "select count(*) from " + tableName + " where head_symbol like ?;";
        try {
            preparedStatement = connection.prepareStatement(querySqlForTotalHeadWord);
            preparedStatement.setString(1, info.getTailSymbol());
            resultSet = preparedStatement.executeQuery();
            if(resultSet.next()) {
                headWords.init(resultSet.getInt(1));
            } else {
                headWords.init(0);
            }
        } catch (SQLException exception) {
            isExceptionOccurs = true;
            exceptionInfo = exceptionInfo + "无法查询首字韵母匹配的词条总数！<br />" + exception.toString() + "<br />";
        }

        // 查询所有首字韵母匹配的词条。
        String querySqlForHeadWord = "select reading_id, reading, read_type, panel_id, head_symbol, tail_symbol " +
                "from " + tableName + " where head_symbol like ?;";
        try {
            preparedStatement = connection.prepareStatement(querySqlForHeadWord);
            preparedStatement.setString(1, info.getTailSymbol());
            resultSet = preparedStatement.executeQuery();
            int headIndex = 0;
            while (resultSet.next()) {
                headIndex ++;
                headWords.setReadingIdByIndex(headIndex, resultSet.getInt(1));
                headWords.setReadingByIndex(headIndex, resultSet.getString(2));
                headWords.setReadTypeByIndex(headIndex, resultSet.getInt(3));
                headWords.setPanelIdByIndex(headIndex, resultSet.getInt(4));
                headWords.setHeadSymbolByIndex(headIndex, resultSet.getString(5));
                headWords.setTailSymbolByIndex(headIndex, resultSet.getString(6));
            }
        } catch (Exception exception) {
            isExceptionOccurs = true;
            exceptionInfo = exceptionInfo + "查询首字韵母出错了！<br />" + exception.toString() + "<br />";
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
        <title><%= info.getReading() %> - 词条信息</title>
    </head>
    <body>
        <%@ include file = "top.txt" %>

        <h3 style="text-align: center;">
            <!-- 要从 url 中获得信息查询模式和搜索内容。形式：showInfo.jsp?infoMode=1&search=search=2000200 -->
            <a href="showInfo.jsp?infoMode=0&search=<%= info.getNum() - 1 %>">上个词条</a>
            <a href="showInfo.jsp?infoMode=0&search=<%= info.getNum() + 1 %>">下个词条</a>
            <a href="listAll.jsp">栞栞所有词条</a>
            <a href="searching.jsp">返回查询</a>
        </h3>

        <div align="center">
            <%
                if(isExceptionOccurs == true) {
                    out.println("<h2 style=\"color: red\">" + exceptionInfo + "</h2>");
                } else {
            %>
            <table width="1200" border="1" bordercolor="#66ccff">
                <tr>
                    <td colspan="3">
                        <h2 class="<%= colorClass %>">【<%= info.getNum() %>】<%= info.getReading() %></h2>
                    </td>
                </tr>
                <tr>
                    <td width="320" rowspan="7" align="center">
                        <img src="images/<%= info.getPanelId() %>.png" height="300" />
                    </td>
                    <td width="120"><b>词条 ID:</b></td>
                    <td><%= info.getReadingId() %></td>
                </tr>
                <tr>
                    <td><b>图片 ID:</b></td>
                    <td><%= info.getPanelId() %></td>
                </tr>
                <tr>
                    <td><b>名称:</b></td>
                    <td><%= info.getReading() %></td>
                </tr>
                <tr>
                    <td><b>读法类型:</b></td>
                    <td><%= kind %></td>
                </tr>
                <tr>
                    <td><b>首字韵母:</b></td>
                    <td><%= info.getHeadSymbol() %></td>
                </tr>
                <tr>
                    <td><b>尾字韵母:</b></td>
                    <td><%= info.getTailSymbol() %></td>
                </tr>
                <tr>
                    <td><b>描述:</b></td>
                    <td><%= info.getDetailText() %></td>
                </tr>
            </table>
            <%
                }
            %>


            <table width="1200" border="0" class="lookupTable">
                <tr><td colspan="10">
                    <%
                        if (isExceptionOccurs != true) {
                    %>
                    <h2>该词条前可能跟的词条（韵母以 <%= info.getHeadSymbol() %> 结尾，<%= tailWords.getTotal() %> 个词条）</h2>
                    <%
                        }
                    %>
                </td></tr>

                <%
                    int picCounter = 0;
                    int textCounter = 0;
                %>

                <%
                    while (textCounter < tailWords.getTotal()) {
                        out.println("<tr>");

                        do {
                            picCounter ++;
                            out.println("<td align=\"center\">");
                            out.println("<a href=\"showInfo.jsp?infoMode=1&search=" + tailWords.getReadingIdByIndex(picCounter) + "\">");
                            out.println("<img src=\"images/" + tailWords.getPanelIdByIndex(picCounter) + ".png\" height=\"100\" />");
                            out.println("</a>");
                            out.println("</td>");
                        } while ((picCounter < tailWords.getTotal()) && (picCounter % 10 != 0));

                        out.println("</tr>");

                        out.println("<tr>");
                        do {
                            textCounter ++;
                            out.println("<td align=\"center\">");
                            out.print("<a href=\"showInfo.jsp?infoMode=1&search=" + tailWords.getReadingIdByIndex(textCounter)
                                    +"\" class=");
                            String textColorClass = new String();
                            switch (tailWords.getReadTypeByIndex(textCounter)) {
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
                            out.print("\"" + textColorClass + "\">" + tailWords.getReadingByIndex(textCounter) + "</a>");
                            out.println("</td>");
                        } while ((textCounter < tailWords.getTotal()) && (textCounter % 10 != 0));
                        out.println("</tr>");
                    }
                %>

            </table>

            <table width="1200" border="0" class="lookupTable">
                <tr><td colspan="10">
                    <%
                        if (isExceptionOccurs != true) {
                    %>
                    <h2>该词条后可以接的词条（韵母以 <%= info.getTailSymbol() %> 开头，<%= headWords.getTotal() %> 个词条）</h2>
                    <%
                        }
                    %>
                </td></tr>

                <%
                    picCounter = 0;
                    textCounter = 0;
                %>

                <%
                    while (textCounter < headWords.getTotal()) {
                        out.println("<tr>");

                        do {
                            picCounter ++;
                            out.println("<td align=\"center\">");
                            out.println("<a href=\"showInfo.jsp?infoMode=1&search=" + headWords.getReadingIdByIndex(picCounter) + "\">");
                            out.println("<img src=\"images/" + headWords.getPanelIdByIndex(picCounter) + ".png\" height=\"100\" />");
                            out.println("</a>");
                            out.println("</td>");
                        } while ((picCounter < headWords.getTotal()) && (picCounter % 10 != 0));

                        out.println("</tr>");

                        out.println("<tr>");
                        do {
                            textCounter ++;
                            out.println("<td align=\"center\">");
                            out.print("<a href=\"showInfo.jsp?infoMode=1&search=" + headWords.getReadingIdByIndex(textCounter)
                                    +"\" class=");
                            String textColorClass = new String();
                            switch (headWords.getReadTypeByIndex(textCounter)) {
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
                            out.print("\"" + textColorClass + "\">" + headWords.getReadingByIndex(textCounter) + "</a>");
                            out.println("</td>");
                        } while ((textCounter < headWords.getTotal()) && (textCounter % 10 != 0));
                        out.println("</tr>");
                    }
                %>
            </table>


            <%
                if(info.getIsCharacter() == 1) {
            %>
            <!-- 只有字段 is_character == 1 才会输出这些内容，否则不会。 -->
            <table width="1200" border="1" bordercolor="#66ccff">
                <tr><td>
                    <h2 align="center">角色美图欣赏</h2>
                </td></tr>
                <tr><td align="center">
                        <img src="character/<%= info.getPanelId() %>.png" width="1024" />
                        <!-- 腾祥沁圆简幻电-W3 -->
                        <div class="<%= colorClass %>" style="font-family: 腾祥沁圆简幻电-W3; font-weight: normal; font-size: 48px; text-align: center;">#<%= info.getNum() %> <%= info.getReading() %></div>
                        <div style="font-weight: bold; font-size: 28px; text-align: center;"><%= info.getDetailText() %></div>
                </td></tr>
            </table>
            <%
                }
            %>
        </div>

        <h3 style="text-align: center;">
            <!-- 要从 url 中获得信息查询模式和搜索内容。形式：showInfo.jsp?infoMode=1&search=search=2000200 -->
            <a href="showInfo.jsp?infoMode=0&search=<%= info.getNum() - 1 %>">上个词条</a>
            <a href="showInfo.jsp?infoMode=0&search=<%= info.getNum() + 1 %>">下个词条</a>
        </h3>

        <%@ include file = "bottom.txt" %>
    </body>
</html>
