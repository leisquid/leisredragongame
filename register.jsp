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

<!DOCTYPE html>
<meta charset="UTF-8" />

<html>
    <head>
        <title>用户注册 - 内部页面</title>
    </head>
    <body>
        <%@ include file = "top.txt" %>

        <div align="center">
            <table width="1200" border="0" class="lookupTable">
                <tr><td><h2 style="text-align: left">【内部页面】用户注册</h2></td></tr>

                <tr>
                    <td>
                        <form action="registerResult.jsp" method="post" style="text-align: left;">
                            用户名称：
                            <input type="text" maxlength="20" name="userName" />
                            <br />
                            用户密码：
                            <input type="password" maxlength="20" name="password" />
                            <br />
                            确认密码：
                            <input type="password" maxlength="20" name="passwordAgain" />
                            <br />
                            <input type="submit" value="注册" />
                        </form>
                    </td>
                </tr>

            </table>
        </div>

        <%@ include file = "bottom.txt" %>
    </body>
</html>
