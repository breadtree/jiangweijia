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
<title>Ringtone present</title>
<link rel="stylesheet" type="text/css" href="style.css">
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
<form name="inputForm" enctype="multipart/form-data" method="post" action="largessEnd.jsp">
<input type="hidden" name="op" value="">
<table border="0" cellspacing="0" cellpadding="0" height="100%" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title">Ringtone present</td>
        </tr>
        <tr>
          <td colspan="2"><input type="file" name="ringFile"></td>
        </tr>
        <tr>
          <td colspan="2" align="center"><img src="button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr style="color: #FF0000">
    <td>Precautions in the case of uploading number directory file:</td>
  </tr>
  <tr style="color: #0000FF">
    <td>1.The directory file must be in .txt format;</td>
  </tr>
  <tr style="color: #0000FF">
    <td>2.Each line of the directory file is a user number;</td>
  </tr>
  <tr style="color: #0000FF">
      <td>3.Please do not use the batch uploading function in the busy hour. Thank you.</td>
  </tr>
</table>
</form>
<%
    }
    else {
%>
<script language="javascript">
   alert('Please log in to the system first!');
   document.URL = 'enter.jsp';
</script>
<%
    }
%>
</body>
</html>
