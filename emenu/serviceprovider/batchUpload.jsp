<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    zxyw50.Purview purview = new zxyw50.Purview();
    Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();

%>
<html>
<head>
<title>Batch uploading ringtone</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
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
          <td colspan="2" align="center" class="text-title">Batch uploading <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
        </tr>
        <tr>
          <td colspan="2"><input type="file" name="ringFile"></td>
        </tr>
        <tr>
          <td colspan="2" align="center"><img src="../manager/button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr style="color: #FF0000">
    <td>Note:</td>
  </tr>
  <%if(sysfunction.get("2-66-0")== null ){%>
  <tr style="color: #0000FF">
    <td>1.	The file must be in .list format;</td>
  </tr>
<%}else{%>
  <tr style="color: #0000FF">
    <td>1.	The file must be in .lst format;</td>
  </tr>
<%}%>
  <tr style="color: #0000FF">
    <td>2.	The SP code must be in the first line of the file;</td>
  </tr>
  <tr style="color: #0000FF">
    <td>3.  The max size in every line is 239 charachters;</td>
  </tr>
  <tr style="color: #0000FF">
    <td>4.	Do NOT use this function during peak hours.</td>
  </tr>
</table>
</form>
<%
    }
    else {
%>
<script language="javascript">
   alert("Please log in first!");
   document.URL = 'enter.jsp';
</script>
<%
    }
%>
</body>
</html>
