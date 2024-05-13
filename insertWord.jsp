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
<%@ page contentType="text/html" %>
<%@ page pageEncoding="UTF-8" %>

<jsp:useBean id="login" class="bigWork.beans.Login" scope="session"/>

<%
    boolean isExceptionOccurs = false;
    String exceptionInfo = new String();
%>

<!DOCTYPE html>
<meta charset="UTF-8"/>

<%
    if (login.getIsLoggedIn() == false) {
        isExceptionOccurs = true;
        exceptionInfo = "用户未登录，无法修改！";
    }
%>

<html>
    <head>
        <title>添加词条 - 编辑模式</title>
    </head>
    <body>
    <%@ include file="top.txt" %>

    <div align="center">
        <%
            if (isExceptionOccurs == true) {
                out.println("<h2 style=\"color: red\">" + exceptionInfo + "</h2>");
            } else {
        %>
        <table width="1200" border="0" class="lookupTable">
            <tr>
                <td><h2 style="text-align: left">添加新词条</h2></td>
            </tr>
            <tr>
                <td>
                    <form action="insertWordResult.jsp" method="post">
                        词条 ID：<input type="text" maxlength="20" name="readingId" /><br/>
                        图片 ID：<input type="text" maxlength="20" name="panelId" /><br/>
                        词条名称：<input type="text" maxlength="20" name="reading" /><br/>
                        读法类型：
                        <select name="readType">
                            <option value="1" />普通
                            <option value="2" />隐藏
                            <option value="3" />PCR
                        </select><br/>
                        是否为角色词条：
                        <input type="radio" name="isCharacter" value="1" />是
                        <input type="radio" name="isCharacter" value="0" />否
                        <br/>
                        首字韵母：<input type="text" maxlength="20" name="headSymbol" /><br/>
                        尾字韵母：<input type="text" maxlength="20" name="tailSymbol" /><br/>
                        描述文本：<br/>
                        <textarea rows="5" cols="80" name="detailText"></textarea><br/>
                        <input type="submit" value="添加"/>
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
