<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String filecode = request.getParameter("filecode");
    String filepath = request.getParameter("filepath");
    // 获取原后缀名
    String extName = filecode.substring(filecode.lastIndexOf(".")+1);
%>
<html>
<head>
<title>Replace File</title>
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
     if(confirm("Do you want to replace the file?"))
     {
       var fm = document.inputForm;

       fm.submit();}

       else
       {
       return false;
       }
   }
</script>
<form name="inputForm" enctype="multipart/form-data" method="post" action="uploadPicEnd.jsp">
<input type="hidden" name="op" value="add">
<input type="hidden" name="filecode" value="<%=filecode%>">
<input type="hidden" name="filepath" value="<%=filepath%>">
<input type="hidden" name="extName" value="<%=extName%>">
<table width="350" height="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title">Replace file <%= filecode %></td>
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
      <td height="26" background="image/n-9.gif"><span class="style1"> &nbsp;&nbsp;The following should be noted when uploading:</span></td>
  </tr>

  <tr style="color: #0000FF">
    <td>1. The replace file should be the same extend file name.</td>
  </tr>
  <tr style="color: #0000FF">
    <td>1. The replace file should be the same width and length as the file to be replaced.</td>
  </tr>
  <tr style="color: #0000FF">
    <td>2. Space is not allowed in the replace filename.</td>
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
