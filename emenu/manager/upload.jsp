<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String isimage=zte.zxyw50.util.CrbtUtil.getConfig("isimage","0");
    String isBackground = request.getParameter("isBackground") == null ? "0" : (String)request.getParameter("isBackground");
    int isMCCI = zte.zxyw50.util.CrbtUtil.getConfig("isMCCI", 0); 
%>
<html>
<head>
<title>Upload <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></title>
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
<form name="inputForm" enctype="multipart/form-data" method="post" action="uploadEnd.jsp">
<input type="hidden" name="op" value="">
<table width="300" height="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
        <%if(isBackground.equals("0")){%>
          <td colspan="2" align="center" class="text-title">Upload <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
        <%} else { %>
          <td colspan="2" align="center" class="text-title">Upload Background Music</td>
        <%} %>
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
      <td height="26" background="image/n-9.gif"><span class="style1"> &nbsp;&nbsp;Notes:</span></td>
  </tr>
  <tr style="color: #0000FF">
   <td>1. The size of the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> file to be uploaded should be between 8~500Kb.</td>
  </tr>
  <tr style="color: #0000FF">
 <td >2.Only these types of file could be uploaded : wav
 <%  if(isMCCI==1){
 %>
	 and amr
	 <%}%>
 </td>
  </tr>
  <tr style="color: #0000FF">
   <td>3. The wav file should be in the CCITT A_Law format without being compressed.</td>
 </tr>
 <tr style="color: #0000FF">
   <td>4. No space is allowed under <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> filename.</td>
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
