<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Add special name list in batches</title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String operID = (String)session.getAttribute("OPERID");
    if (operID != null) {
%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
      fm.submit();
   }
</script>
<form name="inputForm" enctype="multipart/form-data" method="post" action="specialuploadEnd.jsp">
<input type="hidden" name="op" value="">
<table border="0" cellspacing="0" cellpadding="0" height="100%" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title">Add special name list in batches</td>
        </tr>
        <tr>
          <td colspan="2"><input type="file" name="blackFile"></td>
        </tr>
        <tr>
          <td colspan="2" align="center"><img src="../button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr style="color: #FF0000">
    <td>Notes:</td>
  </tr>
  <tr style="color: #0000FF">
    <td>1.The list file must be .txt text file.</td>
  </tr>
  <tr style="color: #0000FF">
    <td>2.The format of file content:the first line must be 'batch_open_specialer',then following,every line be 'User number|limit times|limit type'.</td>
  </tr>
  <tr style="color: #0000FF">
    <td>3.Limit type 1 is the limit of download times,2 is the limit of gift times.</td>
  </tr>
  <tr style="color: #0000FF">
      <td>4.Don't user this function in busy time,thanks!</td>
  </tr>
</table>
</form>
<%
    }
    else {
%>
<script language="javascript">
   alert('Please log in to the system!');
   document.URL = 'enter.jsp';
</script>
<%
    }
%>
</body>
</html>
