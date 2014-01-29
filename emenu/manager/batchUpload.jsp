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
<%
 zxyw50.Purview purview = new zxyw50.Purview();
 Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
%>
<html>
<head>
<title>Batch ringtone upload</title>
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
<form name="inputForm" enctype="multipart/form-data" method="post" action="batchEnd.jsp">
<input type="hidden" name="op" value="">
<table border="0" cellspacing="0" cellpadding="0" height="100%" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title">Batch ringtone upload</td>
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
    <td>The following should be noted when uploading the ringtone list file:</td>
  </tr>
  <%if(sysfunction.get("2-66-0")== null ){%>
  <tr style="color: #0000FF">
    <td>1. The list file must be a .list file.</td>
  </tr>
  <%}else
  {%>
  <tr style="color: #0000FF">
    <td>1. The list file must be a .lst file.</td>
  </tr>
  <%}%>
  <tr style="color: #0000FF">
    <td>2. The first line of the list file should be SP codes.</td>
  </tr>
  <tr style="color: #0000FF">
      <td>3. Each line of an identified ringtone in the list file contains 280 bytes.</td>
  </tr>
  <tr style="color: #0000FF">
      <td>4. Please don't use the batch upload function in service busy hours. Thanks for your support.</td>
  </tr>
</table>
</form>
<%
    }
    else {
%>
<script language="javascript">
   alert('Please log in to the system first!');//Please log in to the system first!
   document.URL = 'enter.jsp';
</script>
<%
    }
%>
</body>
</html>
