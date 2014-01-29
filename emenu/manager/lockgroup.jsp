<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="zxyw50.Purview"%>
<%@page import="zxyw50.manSysPara"%>

<%@include file="../pubfun/JavaFun.jsp"%>
<%
  response.addHeader("Cache-Control", "no-cache");
  response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Add group user</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT></head>
<body background="background.gif" class="body-style1">
<%
  String sysTime = "";
  int optype = 0;
  String desc = null;
  String title = null;
  ArrayList rList = null;
  manSysPara man = new manSysPara();
  Vector sysInfo = (Vector) application.getAttribute("SYSINFO");
  String operID = (String) session.getAttribute("OPERID");
  String operName = (String) session.getAttribute("OPERNAME");
  Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable) session.getAttribute("PURVIEW");
  String colorName = (String) application.getAttribute("COLORNAME") == null ? "" : (String) application.getAttribute("COLORNAME");
  String areacode = (String) application.getAttribute("AREACODE") == null ? "1" : (String) application.getAttribute("AREACODE");
  String grouplen = (String) session.getAttribute("GROUPIDLEN") == null ? "10" : (String) session.getAttribute("GROUPIDLEN");
  String craccount = "";
  try {
    if (operID != null && purviewList.get("11-20") != null) {
      sysTime = man.getSysTime() + "--";
      String op = request.getParameter("op") == null ? "" : transferString((String) request.getParameter("op")).trim();
      String groupid = (String) request.getParameter("groupid");
      if (op.equals("lock")) {
        optype = 1;
        desc = operName + " lock group";
        title = "Lock group";
      }
      else if (op.equals("unlock")) {
        optype = 2;
        desc = operName + " unlock group";
        title = "Unlock group";
      }
      if (optype > 0) {
        //鉴权
        Purview pview = new Purview();
        if (!pview.checkGroupOperateRight(session, "11-20", groupid)) {
          throw new Exception("Sorry," + craccount + "Group user does not have the operation right!");
        }
        if (optype == 1) {
          rList = man.lockgrp(groupid, 1);
        }
        else if (optype == 2) {
          rList = man.lockgrp(groupid, 0);
        }
        sysInfo.add(sysTime + desc);
        // 准备写操作员日志
        if (getResultFlag(rList)) {
          zxyw50.Purview purview = new zxyw50.Purview();
          HashMap map = new HashMap();
          map.put("OPERID", operID);
          map.put("OPERNAME", operName);
          map.put("OPERTYPE", "613");
          map.put("RESULT", "1");
          map.put("PARA1", groupid);
          map.put("PARA2","ip:"+request.getRemoteAddr());
          purview.writeLog(map);
        }
      }
      if (rList != null && rList.size() > 0) {
        session.setAttribute("rList", rList);
%>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="lockgroup.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script></form>
<%}%>
<script language="javascript">
 var grouplen = <%= grouplen %>;
   function check () {
      var fm = document.inputForm;
      var value = trim(fm.groupid.value);
      if (value == '') {
         alert('Please input the group code!');
         fm.groupid.focus();
         return false;
      }
       if(!checkstring('0123456789',value)){
          alert('The group code is the digit character string only!');
          fm.groupid.focus();
          return false ;
      }
      if(value.length < grouplen){
          alert('The length of the group code should not exceed 15 digit, and should not be less than '+grouplen + ', please input it again!');
          fm.groupid.focus();
          return false;
      }
      return true;
   }

function lockgrp(){
     var fm = document.inputForm;
    if(!check())
       return ;
    fm.op.value = 'lock';
    fm.submit();
}

function unlockgrp(){
    var fm = document.inputForm;
    if(!check())
       return ;
    fm.op.value = 'unlock';
    fm.submit();
}
</script><script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script><form name="inputForm" method="post" action="lockgroup.jsp">
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" class="table-style2" width="60%">
    <tr valign="center">
        <td>
            <table border="0" align="center" class="table-style2" width="100%">
                <tr>
                    <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Group lock/unlock</td>
                </tr>
                <tr>
                    <td height="15" colspan="2" align="center" class="text-title">&nbsp;</td>
                </tr>
                <tr>
                    <td align="right" width="35%" height="30">Group code</td>
                    <td>
                        <input type="text" name="groupid" value="" maxlength="15" class="input-style1">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table border="0" width="100%" class="table-style2">
                            <tr>
                                <td width="50%" align="center">                                    &nbsp;&nbsp;
                                    <img src="button/icon_fs.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:lockgrp()">
                                </td>
                                <td width="50%" align="center">
                                    <img src="button/icon_js.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:unlockgrp()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height="26" colspan="3">
                        <table border="0" width="100%" class="table-style2">
                            <tr>
                                <td>Notes:</td>
                            </tr>
                            <tr>
                                <td> &nbsp; 1. The group code should be the digit only. The length should be not more than 15 and not less than <%=grouplen %>.
											</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right" colspan=2>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<%
  } else {
    if (operID == null) {
%>
<script language="javascript">
                    alert( "Please log in to the system!");
                    document.URL = 'enter.jsp';
              </script><%} else {%>
<script language="javascript">
                   alert( "Sorry, you are not allowed to perform this function!");
              </script><%
  }
  }
  } catch (Exception e) {
    Vector vet = new Vector();
    sysInfo.add(sysTime + craccount + " error occurs during the group locking/unlocking");
    sysInfo.add(sysTime + craccount + e.toString());
    vet.add(craccount + " error occurs during the group locking/unlocking");
    vet.add(e.getMessage());
    session.setAttribute("ERRORMESSAGE", vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="lockgroup.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script><%}%>
</body>
</html>
