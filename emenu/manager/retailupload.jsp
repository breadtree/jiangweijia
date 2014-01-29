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
<title>Retaillist batch add</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String operID = (String)session.getAttribute("OPERID");
    if (operID != null) {
    	int	isMobitel = zte.zxyw50.util.CrbtUtil.getConfig("isMobitel",0);
%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
      fm.submit();
   }
</script>
<form name="inputForm" enctype="multipart/form-data" method="post" action="retailuploadend.jsp">
<input type="hidden" name="op" value="">
<table border="0" cellspacing="0" cellpadding="0" height="100%" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title">Retailer list batch add</td>
        </tr>
        <tr>
          <td colspan="2"><input type="file" name="blackFile"></td>
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
    <td>Pay attention to batch Retailer List file upload :</td>
  </tr>
  <tr style="color: #0000FF">
    <td>1.The file must be a .txt file</td>
  </tr>
  <tr style="color: #0000FF">
    <td>2. the directory file first line must be with batch_open_retailer,and then every line must be a subscriber number <%if(isMobitel == 0){%> and retailer discount fee separated by "|" symbol.</td>
  </tr>
    <tr style="color: #0000FF">
    <td>3. If you not given the retailer discount fee it will be considered as 0.<%}%></td>
  </tr>
  <tr style="color: #0000FF">
      <td>4.Please don't use the function of upload in the busy time,thank for your support.</td>
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
