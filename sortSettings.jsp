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

<jsp:useBean id="sorting" class="bigWork.beans.SortingMethod" scope="session" />

<!DOCTYPE html>
<meta charset="UTF-8" />

<%
    String methodStr = request.getParameter("method");
    String sequenceStr = request.getParameter("sequence");

    String[] methodSet = new String[4];
    String[] sequenceSet = new String[2];

    if (! ((methodStr == null || methodStr.length() == 0) || (sequenceStr == null || sequenceStr.length() == 0))) {
        switch (methodStr) {
            case "1":
                sorting.setMethod(1);
                methodSet[1] = "checked=\"checked\"";
                break;
            case "2":
                sorting.setMethod(2);
                methodSet[2] = "checked=\"checked\"";
                break;
            case "3":
                sorting.setMethod(3);
                methodSet[3] = "checked=\"checked\"";
                break;
            default:
                sorting.setMethod(0);
                methodSet[0] = "checked=\"checked\"";
                break;
        }
        switch (sequenceStr) {
            case "1":
                sorting.setEnableDesc(true);
                sequenceSet[1] = "checked=\"checked\"";
                break;
            default:
                sorting.setEnableDesc(false);
                sequenceSet[0] = "checked=\"checked\"";
                break;
        }
    } else {
        switch (sorting.getMethod()) {
            case 1:
                methodSet[1] = "checked=\"checked\"";
                break;
            case 2:
                methodSet[2] = "checked=\"checked\"";
                break;
            case 3:
                methodSet[3] = "checked=\"checked\"";
                break;
            default:
                methodSet[0] = "checked=\"checked\"";
                break;
        }
        if(sorting.getEnableDesc() == true) {
            sequenceSet[1] = "checked=\"checked\"";
        } else {
            sequenceSet[0] = "checked=\"checked\"";
        }
    }
%>

<html>
    <head>
        <title>排序设置 - 游戏模式</title>
    </head>
    <body>
        <%@ include file="top.txt" %>

        <div align="center">
            <table width="1200" border="0">
                <tr><td><h2 style="text-align: left">排序方法设置</h2></td></tr>

                <tr>
                    <td>
                        <form action="sortSettings.jsp" method="post" style="text-align: left">
                            <h3>排序方式：</h3><br />
                            <input type="radio" name="method" value="0"
                                    <%= methodSet[0] %>
                            />按 ID<br />
                            <input type="radio" name="method" value="1"
                                    <%= methodSet[1] %>
                            />按词条拼音<br />
                            <input type="radio" name="method" value="2"
                                    <%= methodSet[2] %>
                            />按尾字韵母 + ID<br />
                            <input type="radio" name="method" value="3"
                                    <%= methodSet[3] %>
                            />按尾字韵母 + 词条拼音<br />

                            <h3>排序方向：</h3><br />
                            <input type="radio" name="sequence" value="0"
                                    <%= sequenceSet[0] %>
                            />正向<br />
                            <input type="radio" name="sequence" value="1"
                                    <%= sequenceSet[1] %>
                            />逆向<br />
                            <br />
                            <input type="submit" value="确定" />
                        </form>
                        <h3><a href="gameStart.jsp" style="text-align: left">返回游戏</a></h3>
                    </td>
                </tr>
            </table>
        </div>

        <%@ include file="bottom.txt" %>
    </body>
</html>
