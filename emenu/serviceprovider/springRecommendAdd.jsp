<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<title>Add SP commend ringtone</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<script language="javascript">
   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.ringid.value);
      if(value==''){
         alert("Please enter the code of ringtone!");
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert("The code of ringtone must be a digital number!");
         fm.ringid.focus();
         return flag;
      }
      var value = trim(fm.rsubindex.value);
      if(value==''){
         alert("Please enter the index of ringtone!");
         fm.rsubindex.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert("The index of ringtone must be a digital number!");
         fm.rsubindex.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function doSure () {
      var fm = document.inputForm;
      if(!checkInfo())
        return;
      window.opener.getAddInfo(fm.ringid.value,fm.rsubindex.value);
      window.close();
   }
</script>
<form name="inputForm" method="post" >
<input type="hidden" name="op" value="add" >
  <table width="400" border="0" cellspacing="0" cellpadding="0" align="center" height="200">
    <tr>
      <td><img src="../image/pop013.gif" width="400" height="60"></td>
    </tr>
    <tr>
      <td><img src="../image/pop02.gif" width="400" height="26"></td>
    </tr>
    <tr>
      <td background="../image/pop03.gif" height="91"> <div align="center">
          <table width="85%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
            <tr>
              <td align="center" colspan=2  height=50>
               <font class="font"><b><img src="../image/n-8.gif" width="8" height="8">
                 Add SP commend ringtone</b></font>
              </td>
            </tr>
            <tr>
             <td  align=right height=30 >&nbsp;&nbsp;Index of sort</td>
             <td><input type="text" name="rsubindex" value="" maxlength="6" class="input-style1" ></td>
            </tr>
            <tr>
             <td align=right height=30>&nbsp;&nbsp;Code of ringtone</td>
             <td><input type="text" name="ringid" value="" maxlength="20" class="input-style1"  ></td>
            </tr>
            <tr id="button" style="display" height=50>
              <td colspan="2" align="center">
                <table width="85%" border="0" cellpadding="2" cellspacing="1" class="table-style2">
                  <tr>
                    <td align="center"> <img src="../button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:doSure()">
                      <img src="../button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()">
                      <img src="../button/close.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:window.close();">
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </div></td>
    </tr>
	    <tr>
      <td><img src="../image/pop04.gif" width="400" height="23"></td>
    </tr>
  </table>
  <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
    <tr>
      <td>&nbsp;</td>
  </tr>
</table>
</form>
</body>
</html>
