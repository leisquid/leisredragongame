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
        <title>删除词条 - 编辑模式</title>
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
                    <td><h2 style="text-align: left">删除词条</h2></td>
                </tr>
                <tr>
                    <td>
                        <form action="deleteConfirm.jsp" method="post">
                            请输入词条 ID：<input type="text" maxlength="20" name="readingId" /><br/>
                            <input type="submit" value="删除"/>
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
