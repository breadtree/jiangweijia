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
<title>Upload Greeting Tone</title>
<link rel="stylesheet" type="text/css" href="style.css">
<style type="text/css">
<!--
.style1 {color: #663333}
-->
</style>
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
<form name="inputForm" enctype="multipart/form-data" method="post" action="uploadToneEnd.jsp">
<input type="hidden" name="op" value="">
<table width="300" height="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title">Upload Greeting Tone</td>
        </tr>
        <tr>
          <td colspan="2" align="center"><input type="file" name="ringFile"></td>
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
      <td height="26" background="image/n-9.gif"><span class="style1"> &nbsp;&nbsp;The following should be noted when uploading ringtones:</span></td>
  </tr>
  <tr style="color: #0000FF">
    <td>1. The size of the Greeting Tone file to be uploaded should be between 8~100Kb.</td>
  </tr>
  <tr style="color: #0000FF">
    <td>2. The Greeting Tone file should be in the CCITT A_Law format without being compressed.</td>
  </tr>
  <tr style="color: #0000FF">
    <td>3. Space is not allowed in the ringtone filename.</td>
  </tr>
</table>
</form>
<%
    }
    else {
%>
<script language="javascript">
   alert('Please log in to the system first!');//Please log in to the system!
   document.URL = 'enter.jsp';
</script>
<%
    }
%>
</body>
</html>
