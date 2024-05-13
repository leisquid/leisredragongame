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
    if(login.getIsLoggedIn() == false) {
        isExceptionOccurs = true;
        exceptionInfo = "用户未登录，无法修改！";
    } else {
        int search = 0;
        try {
            search = Integer.parseInt(request.getParameter("search"));
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
        String querySqlById = "select * from " + tableName + " where reading_id = ?;";      // 按 Id 查词条。

        // 开始准备查询。
        try {
            preparedStatement = connection.prepareStatement(querySqlById);
            preparedStatement.setInt(1, search);

            // 结果集开始收集查询结果。
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                info.fastSet(
                        resultSet.getInt(1), resultSet.getInt(2), resultSet.getString(3),
                        resultSet.getInt(4), resultSet.getInt(5), resultSet.getString(6),
                        resultSet.getString(7), resultSet.getString(8), resultSet.getInt(9)
                );
            } else {
                isExceptionOccurs = true;
                exceptionInfo = exceptionInfo + "没有查到 " + search + " 的词条！<br />";
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
        <title><%= info.getReading() %> - 编辑词条</title>
    </head>
        <body>
            <%@ include file = "top.txt" %>

            <div align="center">
            <%
                if(isExceptionOccurs == true) {
                    out.println("<h2 style=\"color: red\">" + exceptionInfo + "</h2>");
                } else {
            %>
            <table width="1200" border="0" class="lookupTable">
                <tr><td><h2 style="text-align: left">修改【<%= info.getReadingId() %>】：“<%= info.getReading() %>”的词条</h2></td></tr>
                <tr>
                    <td>
                        <form action="editWordResult.jsp" method="post">
                            词条 ID：<input type="text" maxlength="20" name="readingId"
                                        value="<%= info.getReadingId() %>"
                            /><br />
                            图片 ID：<input type="text" maxlength="20" name="panelId"
                                        value="<%= info.getPanelId() %>"
                            /><br />
                            词条名称：<input type="text" maxlength="20" name="reading"
                                        value="<%= info.getReading() %>"
                            /><br />
                            读法类型：
                            <select name="readType">
                                <option value="1"
                                        <%
                                            if (info.getReadType() == 1) {
                                                out.print(" selected=\"selected\" ");
                                            }
                                        %>
                                />普通
                                <option value="2"
                                        <%
                                            if (info.getReadType() == 2) {
                                                out.print(" selected=\"selected\" ");
                                            }
                                        %>
                                />隐藏
                                <option value="3"
                                        <%
                                            if (info.getReadType() == 3) {
                                                out.print(" selected=\"selected\" ");
                                            }
                                        %>
                                />PCR
                            </select><br />
                            是否为角色词条：
                            <input type="radio" name="isCharacter" value="1"
                                   <%
                                       if (info.getIsCharacter() == 1) {
                                           out.print(" checked=\"checked\" ");
                                       }
                                   %>
                            />
                            是
                            <input type="radio" name="isCharacter" value="0"
                                   <%
                                       if (info.getIsCharacter() == 0) {
                                           out.print(" checked=\"checked\" ");
                                       }
                                   %>
                            />
                            否<br />
                            首字韵母：<input type="text" maxlength="20" name="headSymbol"
                                        value="<%= info.getHeadSymbol() %>"
                            /><br />
                            尾字韵母：<input type="text" maxlength="20" name="tailSymbol"
                                        value="<%= info.getTailSymbol() %>"
                            /><br />
                            描述文本：<br />
                            <textarea rows="5" cols="80" name="detailText"><%= info.getDetailText() %></textarea><br />
                            <input type="hidden" name="originalReadingId" value="<%= info.getReadingId() %>" />
                            <input type="submit" value="提交" />
                        </form>
                    </td>
                </tr>
            </table>
            <%
                }
            %>
        </div>

        <%@ include file="bottom.txt" %>
    </body>
</html>
