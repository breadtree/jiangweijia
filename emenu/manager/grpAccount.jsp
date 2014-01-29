<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.ManGroup" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="zxyw50.manSysRing" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Group user participation</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String areacode = (String)application.getAttribute("AREACODE")==null?"1":(String)application.getAttribute("AREACODE");
    String grouplen = (String)session.getAttribute("GROUPIDLEN")==null?"10":(String)session.getAttribute("GROUPIDLEN");
    String  craccount = "";
	
	String sEnablePairNumber = CrbtUtil.getConfig("isEnablePairNumber","0");
	int isEnablePairNumber=Integer.parseInt(sEnablePairNumber);
	
    try {
	   if (operID != null && purviewList.get("11-2") != null) {
	    sysTime = ManGroup.getSysTime() + "--";
	    String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
	    if(op.equals("add")){
	        craccount = (String)request.getParameter("craccount");
			String sUserNumber = "";
			if(isEnablePairNumber==1) {
				manSysRing sysring = new manSysRing();
				sUserNumber=sysring.getPairUserNumber(craccount);
			}
			if(!sUserNumber.equals(""))
			{
			       craccount = sUserNumber;
			}
			
            String groupid = (String)request.getParameter("groupid");
            ManGroup mangroup = new ManGroup();
            Hashtable hash = new Hashtable();
             SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
             sysTime = SocketPortocol.getSysTime() + "--";
             hash.put("opcode","01010948");
            hash.put("usernumber",craccount);
            hash.put("groupid",groupid);
            //6表示人工台,1表示web
              hash.put("opmode","1");
              hash.put("ipaddr",operName);
//            hash.put("operator",operName);
//            hash.put("ipaddr",request.getRemoteAddr());
//            mangroup.accountGrpUser(hash);
            SocketPortocol.send(pool,hash);
            sysInfo.add(sysTime +":Administrator "+ operName +"  has added Subscriber "+ craccount + " to Group " + groupid + " successfully!");

            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","602");
            map.put("RESULT","1");
            map.put("PARA1",groupid);
            map.put("PARA2",craccount);
            map.put("PARA3","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
%>
<script language="javascript">
   var str = "<%= craccount %>"+" Added to Group " + "<%= groupid %>" + " successfully!"
   alert(str);
</script>
<%
        }

%>
<script language="javascript">
 var  colorname = "<%= colorName %>"
 var grouplen = <%= grouplen %>;
   function changePwd () {
      var fm = document.inputForm;
      var value = trim(fm.groupid.value);
      if (value == '') {
         alert('Please enter the group code to which the subscriber will be added!');//请输入用户要加入的集团 code
         fm.groupid.focus();
         return;
      }
       if(!checkstring('0123456789',value)){
          alert('The group code can only be a digital string!');//集团 code只能是数字字符串
          fm.groupid.focus();
          return ;
      }
      if(value.length < grouplen){
         // alert('集团 code长度最大不得超过15位,最短不得小于'+grouplen + '位,请重新输入!');
          alert('The group code length cannot be larger than 15 bytes,cannot be less than '+grouplen+'bytes,please re-enter');
          fm.groupid.focus();
          return ;
      }
      value = trim(fm.craccount.value);
      if (value == '') {
         alert('Please input the '+ colorname +' number!');// 请输入 号码
         fm.craccount.focus();
         return;
      }
      if (value.length<6|| value.length>20) {
         alert('The '+colorname+' number entered is not correct');//号码输入不正确
         fm.craccount.focus();
         return;
      }
      if (!checkstring('0123456789',fm.craccount.value)) {
         alert('The '+colorname +' number should be digital!');//号码应为数字
         fm.craccount.focus();
         return;
      }
      fm.op.value = 'add';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="grpAccount.jsp">
<input type="hidden" name="op" value="">
  <table border="0" align="center" height="400"  class="table-style2" width="60%" >
    <tr valign="center">
    <td>
        <table border="0" align="center" class="table-style2" width="100%">
          <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Group user participation</td>
        </tr>
		 <tr >
          <td height="15" colspan="2" align="center" class="text-title" >&nbsp;</td>
        </tr>
        <tr>
          <td align="right" width="35%" height="30">Group code</td>
          <td><input type="text" name="groupid" value=""  maxlength="15"   class="input-style1"></td>
        </tr>
		<tr>
          <td align="right" width="35%" height="30"><%= colorName %> number</td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="center">&nbsp;&nbsp;<img src="button/addgrp.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:changePwd()"></td>
                <td width="50%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr >
          <td height="26" colspan="3" >
           <table border="0" width="100%" class="table-style2">
              <tr>
               <td>Notes:</td>
              </tr>
              <tr>
               <td >&nbsp;1. Group code can only contain digital string,and the length cannot be larger than 15 bytes, and cannot be less than <%=grouplen %> bytes. </td>
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
        sysInfo.add(sysTime + craccount +" Error occurred in adding the group user");//集团用户加入过程出现错误
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add(craccount + " Error occurred in adding the group user");//集团用户加入过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpAccount.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>
