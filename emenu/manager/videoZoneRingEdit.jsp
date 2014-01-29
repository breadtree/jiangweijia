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
<title>Edit Video Zone Ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String ringlabel = request.getParameter("ringlabel") == null ? "" : transferString((String)request.getParameter("ringlabel"));
    String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
    String rsubindex = request.getParameter("rsubindex") == null ? "" : transferString((String)request.getParameter("rsubindex")).trim();
%>
<script language="javascript">
   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.newringid.value);
      if(value==''){
         alert("Please input new ringtone code!");
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The ringtone code must be in digit format!');
         fm.newringid.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function doSure () {
      var fm = document.inputForm;
      if(!checkInfo())
        return;
      if(fm.ringid.value == fm.newringid.value){
         alert("The new ringtone code is the same as the old one, please input it again!");
         fm.newringid.focus();
         return;
      }
      window.opener.getEditInfo(fm.ringid.value,fm.newringid.value,fm.rsubindex.value);
      window.close();
   }
   
   function queryInfo() {
     var result =  window.showModalDialog('ringSearch.jsp?mediatype=2&hidemediatype=1',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
       document.inputForm.newringid.value=result;
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
              <td align="center" colspan=2  height=40>
               <font class="font"><b><img src="../../image/n-8.gif" width="8" height="8">Edit Video Zone Ringtone</b></font>
              </td>
            </tr>
            <tr style="display:none">
             <td  align=right height=25 >&nbsp;&nbsp;Sequence number</td>
             <td><input type="text" name="rsubindex"  maxlength="6"  value="<%= rsubindex %>"  class="input-style1" disabled ></td>
            </tr>
            <tr>
             <td align=right height=25>&nbsp;&nbsp;Old ringtone code</td>
             <td><input type="text" name="ringid"  maxlength="20"  value="<%= ringid %>" class="input-style1" disabled ></td>
            </tr>
            <tr>
             <td align=right height=25>&nbsp;&nbsp;Old ringtone name</td>
             <td><input type="text" name="ringlabel" maxlength="20" class="input-style1" value="<%= ringlabel %>" disabled ></td>
            </tr>
            <tr>
             <td align=right height=25>&nbsp;&nbsp;New ringtone code</td>
             <td><input type="text" name="newringid"  maxlength="20" class="input-style1" ><img  height="15" src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo()"></td>
            </tr>
            <tr id="button" style="display" height=40>
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
      <td> </td>
  </tr>
</table>
</form>
</body>
</html>
