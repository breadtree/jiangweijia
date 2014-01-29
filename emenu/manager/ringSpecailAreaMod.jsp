<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    //是否将特别专区铃音显示为无线排行榜　1:显示为无线排行榜 0:保持不变 默认:0
    String showWireless = CrbtUtil.getConfig("showWireless","0");
%>

<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<title><%=showWireless.equals("1") ? "Edit wireless ringtones board" : "Edit ringtones in Ringboard"%></title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String ringlabel = request.getParameter("ringlabel") == null ? "" : transferString((String)request.getParameter("ringlabel"));
    String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
    String rsubindex = request.getParameter("rsubindex") == null ? "" : transferString((String)request.getParameter("rsubindex")).trim();
   System.out.println("ringid="+ringid);
%>
<script language="javascript">
   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.newringid.value);
      if(value==''){
         alert("Please enter the new code of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>!");
         fm.newringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert("The new <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code must be a digital number!");//新Ringtone code必须是数字!
         fm.newringid.focus();
         return flag;
      }
      flag = true;
      return flag;
   }
   function queryInfo() {
	     var result =  window.showModalDialog('ringSearch.jsp',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
	     if(result){
	       document.inputForm.newringid.value=result;
	     }
 }

   function doSure () {
      var fm = document.inputForm;
      if(!checkInfo())
        return;
      if(fm.ringid.value == fm.newringid.value){
         alert("The new <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code is same sa the old one,please re-enter!");//新Ringtone code同原Ringtone code相同,请重新输入!
         fm.newringid.focus();
         return;
      }
      window.opener.setEditInfo(fm.newringid.value,fm.rsubindex.value);
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
              <td align="center" colspan=2  height=40>
               <font class="font"><b><img src="../../image/n-8.gif" width="8" height="8">
                 <%=showWireless.equals("1") ? "Edit wireless ringtones board" : "Edit ringtones in Ringboard"%></b></font>
              </td>
            </tr>
            <tr>
             <td  align=right height=25 >&nbsp;&nbsp;Index of array</td>
             <td><input type="text" name="rsubindex"  maxlength="6"  value="<%= rsubindex %>"  class="input-style1" disabled ></td>
            </tr>
            <tr>
             <td align=right height=25>&nbsp;&nbsp;Old <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
             <td><input type="text" name="ringid"  maxlength="20"  value="<%= ringid %>" class="input-style1" disabled ></td>
            </tr>
            <tr>
             <td align=right height=25>&nbsp;&nbsp;Old <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
             <td><input type="text" name="ringlabel" maxlength="20" class="input-style1" value="<%= ringlabel %>" disabled ></td>
            </tr>
            <tr>
             <td align=right height=25>&nbsp;&nbsp;New <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
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
      <td>&nbsp;</td>
  </tr>
</table>
</form>
</body>
</html>
