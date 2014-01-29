<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Ringtone replacement</title>
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
<form name="inputForm" enctype="multipart/form-data" method="post" action="ringReplaceEnd.jsp">
<input type="hidden" name="op" value="">
<table width="300" height="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title">Ringtone replacement</td>
        </tr>
        <tr>
          <td colspan="2" align="center"><input type="file" name="ringFile"></td>
        </tr>
        <tr>
          <td colspan="2" align="center"><img src="button/sure.gif" width="45" height="19" onclick="javascript:upload()" onmouseover="this.style.cursor='hand'"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr style="color: #FF0000">
      <td height="26" background="image/n-9.gif"><span class="style1"> &nbsp;&nbsp;Precautions in case of tone replacement:</span></td>
  </tr>
  <tr style="color: #0000FF">
    <!--<td>1.�û������ļ���СӦ��8KB��500KB֮�䣻</td>-->
    <td>1.The size of the replacement tone file must range from 8KB to 500KB;</td>
  </tr>
  <tr style="color: #0000FF">
    <!--<td>2.�����ļ�������CCITT A_Law��ʽ��,��û�б�ѹ����</td>-->
      <td>2.The ringtone file must be in the format of CCITT A_Law, without the compression;</td>
  </tr>
  <tr style="color: #0000FF">
    <!--<td>3.�����ļ����в�������ո�</td>-->
     <td>3.The name of ringtone file should not contain a space.</td>
 </tr>
</table>
</form>
<%
    }
    else {
%>
<script language="javascript">
  // alert('�����εĵ�¼Ȩ���Ѿ�ʧЧ,���˳������µ�¼ϵͳ!');
    alert("Your login right is invalid, please logout and log in the system again!");
   window.close();
</script>
<%
    }
%>
</body>
</html>
