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
<title>Add Video Zone Ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<script language="javascript">
   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.ringid.value);
      if(value==''){
         alert("Please input ringtone code!");
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('Ringone code must be in digit format!');
         fm.ringid.focus();
         return flag;
      }
      var value = trim(fm.rsubindex.value);
      if(value==''){
         alert("Please input ringtone number!");
         fm.rsubindex.focus();
         return flag;
      }
    /*  if(parseInt(value)<=0){
         alert("Ringtone number must be greater than 0!");
         fm.rsubindex.focus();
         return flag;
      }  */

      if (!checkstring('0123456789',value)) {
         alert('Ringtone number must be a digit!');
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
      window.opener.setRingInfo(fm.ringid.value, fm.rsubindex.value);
      window.close();
   }
   function queryInfo() {
     var result =  window.showModalDialog('ringSearch.jsp?mediatype=2&hidemediatype=1',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
       document.inputForm.ringid.value=result;
     }
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
               <font class="font"><b><img src="../../image/n-8.gif" width="8" height="8">Add Video Zone Ringtone</b></font>
              </td>
            </tr>
           <input type="hidden" name="rsubindex" value="0" maxlength="6" class="input-style1" readonly />
           <tr>
             <td align=right height=30>&nbsp;&nbsp;Ringtone code</td>
             <td><input type="text" name="ringid" value="" maxlength="20" class="input-style1"><img  height="15" src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo()">
             </td>
            </tr>
            <tr id="button" style="display" height=50>
              <td colspan="2" align="center">
                <table width="85%" border="0" cellpadding="2" cellspacing="1" class="table-style2">
                  <tr>
                    <td align="center"> <img src="button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:doSure()">
                      <img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()">
                      <img src="button/close.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:window.close();">
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
