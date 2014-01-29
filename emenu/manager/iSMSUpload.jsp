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
<title>iSMS File upload</title>
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
<form name="inputForm" enctype="multipart/form-data" method="post" action="iSMSUploadEnd.jsp">
<input type="hidden" name="op" value="">
<table border="0" cellspacing="0" cellpadding="0" height="100%" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title">Manage iSMS Broadcast file upload</td>
        </tr>
        <tr>
          <td colspan="2"><input type="file" name="ringFile"></td>
        </tr>
        <tr>
          <td colspan="2" align="center"><img src="button/sure.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:upload()"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
  <td>
     <table align="center" width="100%" class = "Notes">
  <tr >
    <td  class="NotesHeader">Note:</td>
  </tr>
  <tr >
    <td>1.The file must be a .txt file.</td>
  </tr> 
  <tr>
      <td>2.Each line of the file contains Non-CRBT <%=zte.zxyw50.util.CrbtUtil.getConfig("userNumber","User Number")%>.</td>
  </tr>
  <tr>
      <td>3.Please don't use batch upload function in service busy time,thanks for your support.</td>
  </tr>
</table>
  </td>
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
