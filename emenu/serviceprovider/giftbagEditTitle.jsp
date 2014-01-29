
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

	 String grouplabel=(String)session.getAttribute("GROUPLABEL");
%>

<html>
<head>
<title>Manage gift bag</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body background="background.gif" class="body-style1">
<table  border="0" align="center" class="table-style2" height="100%" width="80%">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Add ringtone to gift bag:<%=grouplabel%></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
