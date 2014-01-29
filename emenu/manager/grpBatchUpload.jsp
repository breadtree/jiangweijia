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
<title>Group user open/cancel an account file upload</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String operID = (String)session.getAttribute("OPERID");
    String msg = CrbtUtil.getConfig("mobileMsg","\"13\",\"15\"");
    if (operID != null) {
%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
      fm.submit();
   }
</script>
<form name="inputForm" enctype="multipart/form-data" method="post" action="grpBatchEnd.jsp">
<input type="hidden" name="op" value="">
<table border="0" cellspacing="0" cellpadding="0" height="100%" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title">Group user open/cancel an account file upload</td>
        </tr>
        <tr>
          <td colspan="2" ><input type="file" name="ringFile" style="width:400px"></td>
        </tr>
        <tr>
          <td colspan="2" align="middle"><img src="button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()"></td>
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
    <td>1.The file must be .txt format;</td>
  </tr>
  <tr style="color: #0000FF">
    <td>2.The first line should be 'zxin_crbt_group_account' in group batch account,the first line should be 'zxin_crbt_group_delete' in group batch cancel;</td>
  </tr>
  <tr style="color: #0000FF">
      <td>3.The second line should be group code in group batch account file,the second line should be subscriber number in group batch cancel account file;</td>
  </tr>
  <tr style="color: #0000FF">
      <td>4.mobile phone number must be start with<%=msg%>,phs and fixed line must be format with :'0+area code+ actual number'</td>
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
