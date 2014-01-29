<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html;charset=ISO8859_1" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
String img_path = "intl/"+ getZteLocale(request)+"/"; //add by chenxi 2007-03-01
%>
<html>
<head>
<title>Error message</title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" height="200">
  <tr>
    <td width="100%"><img src="../<%=img_path%>image/pop013.gif" width="400" height="60"></td>
  </tr>
  <tr>
    <td><img src="../image/pop02.gif" width="400" height="26"></td>
  </tr>
  <tr>
    <td background="../image/pop03.gif" height="91"> <div align="center">
        <table width="80%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
          <%
    String url = request.getParameter("historyURL") == null ? "" : (String)request.getParameter("historyURL");
    boolean flag = true;
    if ((url.trim()).length() == 0)
        flag = false;
    try {
        Vector vet = (Vector)session.getAttribute("ERRORMESSAGE");
        if (vet == null) {
            vet = new Vector();
            vet.add("Unknow error message!");
        }
        else
            session.removeAttribute("ERRORMESSAGE");
        for (int i = 0; i < vet.size(); i++) {
%>
          <tr>
            <td><%= (String)vet.get(i) %></td>
          </tr>
          <%
        }
    }
    catch (Exception e) {
%>
          <tr>
            <td>System appears unknow error message</td>
          </tr>
          <%
    }
%>
          <%
    if (flag) {
%>
          <tr>
            <td align="center"><br>
              ¡¾<%= flag ? "<a href=\"" + url + "\">" : "" %>Back<%= flag ? "</a>" : "" %>¡¿</td>
          </tr>
          <%
    }
%>
        </table>
      </div></td>
  </tr>
  <tr>
    <td><img src="../image/pop04.gif" width="400" height="23"></td>
  </tr>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
    <td>&nbsp; </td>
  </tr>
  <tr>
    <td>&nbsp; </td>
  </tr>
</table>
</table>
</body>
</html>
