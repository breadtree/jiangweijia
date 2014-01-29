<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="zxyw50.ywaccess" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Upload ringtone</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<style type="text/css">
<!--
.style1 {color: #663333}
-->
</style>
</head>
<body background="background.gif" class="body-style1">
<%
    String operID = (String)session.getAttribute("OPERID");
    String  suiyi="";
    //是否支持随意铃功能开关
    try{
      ywaccess yes=new ywaccess();
      suiyi=yes.getPara(145);
    }catch(Exception es){
      es.printStackTrace();
    }
    if (operID != null) {
%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
      fm.submit();
   }
</script>
<form name="inputForm" enctype="multipart/form-data" method="post" action="spuploadEnd.jsp">
<input type="hidden" name="op" value="">
<table width="300" height="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title">Upload ringtone</td>
        </tr>
        <tr>
          <td colspan="2" align="center"><input type="file" name="ringFile"></td>
        </tr>
        <tr>
          <td colspan="2" align="center"><img src="../button/sure.gif"  onclick="javascript:upload()" onmouseover="this.style.cursor='hand'"></td>
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
 <%if("1".equals(suiyi)){%>
    <td>1.	The size of the ringtone file should be between 8~500kb.(The max size of at-will ringtone file is 4000Kb);</td>
   <% }else{%>
      <td>1. The size of the ringtone file should be between 8~500kb.</td>
  <% }%>
  </tr>
  <tr style="color: #0000FF">
    <td>2.	The ringtone file should be in CCITT A_Law format without being compressed.</td>
  </tr>
  <tr style="color: #0000FF">
    <td>3.	The filename must not contain spaces.</td>
  </tr>
  <tr style="color: #0000FF">
    <td>&nbsp;</td>
  </tr>
</table>
</form>
<%
    }
    else {
%>
<script language="javascript">
   alert('Your login has been invalid. Please re-log in!');//您本次的登录权限已经失效,请退出后重新登录系统
   window.close();
</script>
<%
    }
%>
</body>
</html>
