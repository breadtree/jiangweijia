<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>The latest ringtone sp ringtone number management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1"  >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-28") != null) {
            Hashtable hash = new Hashtable();
			String  optSCP = "";
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String maxspringnum = request.getParameter("maxspringnum") == null ? "" : ((String)request.getParameter("maxspringnum")).trim();
            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","328");
            map.put("RESULT","1");
            map.put("PARA1",maxspringnum);
            map.put("PARA2","ip:"+request.getRemoteAddr());
            if (op.equals("edit")) {
                syspara.editnewRingspnum(Integer.parseInt(maxspringnum));
                sysInfo.add(sysTime + operName + " succeeded in editing the newest ringtone of each sp tone quantity!");//Edit最新铃音每sp铃音数量成功!
                purview.writeLog(map);
            }
            String ret = syspara.getnewRingspnum();
%>
<script language="javascript">

    function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.maxspringnum.value) == '') {
         //alert('请输入最新铃音每sp铃音数量!');
         alert('Please input the newest ringtone of the ringtone quantity of each sp!');
         fm.maxspringnum.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.maxspringnum.value))) {
         //alert('最新铃音每sp铃音数量只能为数字!');
         alert('The quantity of each sp ringtone must be a digit only!');
         fm.maxspringnum.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function doSure () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="editSpRingnum.jsp">
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr background="image/n-9.gif">
          <td height="26" colspan="2" align="center" class="text-title"background="image/n-9.gif">The newest ringtone of each sp ringtone quantity management</td>
        </tr>
        <tr >
          <td height="15" colspan="2" align="center" >&nbsp;</td>
        </tr>
        <tr>
          <td align=right height=30 >The newest ringtone of each sp ringtone quantity</td>
          <td height="22"><input type="text" name="maxspringnum" value="<%= ret %>" maxlength="6" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="center"><img src="button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:doSure()"></td>
                <td width="50%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr height="20">
          <td colspan="2"></td>
        </tr>
        <tr>
          <td colspan="2" style="color: #FF0000">Please input the number with the follow rule:</td>
        </tr>
        <tr>
          <td colspan="2" style="color: #FF0000">1.The input cannot be less than 0.</td>
        </tr>
        <tr>
          <td colspan="2" style="color: #FF0000">2.If the input is zero, means no limit.</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%
        }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "You have no access to this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occurred in  the latest ringtone of each sp ringtone management!");//最新铃音每sp铃音数量管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in  the latest ringtone of each sp ringtone management!");//最新铃音每sp铃音数量管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="editSpRingnum.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
