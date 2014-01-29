<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
   public String transferString(String str) throws Exception {
     return str;
    }
%>
<%
   String url = request.getParameter("historyURL") == null ? "" : transferString((String)request.getParameter("historyURL"));
   String title = request.getParameter("title") == null ? "" : transferString((String)request.getParameter("title"));
   ArrayList rList = (ArrayList)session.getAttribute("rList");
   Hashtable hash = new Hashtable();

%>
<html>
<head>
<title>Operation result</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" >
  <tr>
    <td width="100%"><img src="../image/pop013.gif" width="400" height="60"></td>
  </tr>
  <tr>
    <td><img src="../image/pop02.gif" width="400" height="26"></td>
  </tr>
  <tr>
    <td height=40  align=center background="../image/pop03.gif" class="font-man" ><B><%= title  %></B></td>
  </tr>
  <tr>
    <td background="../image/pop03.gif"  width="80%" > <div align="center">
        <table width="80%" cellspacing="1" cellpadding="2" border="1" class="table-style2" align="center">
		<tr>
		<td align=center width="20%">SCP</td>
		<td align=center width="30%">Operation result </td>
        <td align=center width="50%">Failure cause </td>
        </tr>
		 <%
           for (int i = 0; i < rList.size(); i++) {
		     hash = (Hashtable)rList.get(i);
		     %>
		    <tr>
			<td align="center" width="20%" > <%= (String)hash.get("scp") %> </td>
			<td align="center" width="30%" > <%= ((String)hash.get("result")).equals("0")?"Success":"Failure" %> </td>
			<td width="50%" >&nbsp; <%= (String)hash.get("reason") %> </td>
		    </tr>
		<%
		   }
         %>
        </table></div>
	  </td>
     </tr>
	  <tr >
         <td align="center" background="../image/pop03.gif" height=40> <a href="<%= url %>" > -- Return -- </a></td>
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
</body>
</html>
