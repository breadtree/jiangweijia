<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.ManGroup" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Add a group user</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String areacode = (String)application.getAttribute("AREACODE")==null?"1":(String)application.getAttribute("AREACODE");
    String grouplen = (String)session.getAttribute("GROUPIDLEN")==null?"10":(String)session.getAttribute("GROUPIDLEN");
    String  craccount = "";
    String groupid=(String)session.getAttribute("GROUPID");
    try {
	   if (operID != null && purviewList.get("12-16") != null) {
	    sysTime = ManGroup.getSysTime() + "--";
	    String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
	    if(op.equals("add")){
	        craccount = (String)request.getParameter("craccount");

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
            SocketPortocol.send(pool,hash);
            sysInfo.add(sysTime +" operator "+ operName +" add user "+ craccount + " to a group " + groupid + " successfully!");

            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","2005");
            map.put("RESULT","1");
            map.put("PARA1",groupid);
            map.put("PARA2",craccount);
            map.put("PARA3","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
%>
<script language="javascript">
   var str = "<%= craccount %>"+" add to group " + "<%= groupid %>" + " successfully!"
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
      value = trim(fm.craccount.value);
      if (value == '') {
         alert('Please input '+ colorname +' number!');
         fm.craccount.focus();
         return;
      }
      if (value.length<6|| value.length>20) {
         alert(colorname +' number input incorrect!');
         fm.craccount.focus();
         return;
      }
      if (!checkstring('0123456789',fm.craccount.value)) {
         alert(colorname +' number should be a digital number!');
         fm.craccount.focus();
         return;
      }
      fm.op.value = 'add';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="grpAccount.jsp">
<input type="hidden" name="op" value="">
  <table align="center" border="0" cellPadding="0" cellSpacing="0" height="530" width="100%" id="table1">
		<tr>
			<td bgColor="#ffffff" vAlign="top">
			<table border="0" cellPadding="0" cellSpacing="0" width="100%" id="table2">
				<tr>
					<td>
					<table border="0" cellPadding="0" cellSpacing="0" width="100%" id="table3">
						<tr>
							<td>
							<table border="0" cellPadding="0" cellSpacing="0" width="100%" id="table4">
								<tr>
									<td> </td>
								</tr>
							</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
		   <table width="95%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
                <tr>
                  <td width="28"><img src="../image/home_r14_c3.gif" width="28" height="31"></td>
                  <td background="../image/home_r14_c5bg.gif"><font color="#006600"><b></b>
                    <b><font class="font"> Add a group user</font></b></font></td>
                  <td width="12"><img src="../image/home_r14_c5.gif" width="12" height="31"></td>
                </tr>
              </table>
			<table align="center" border="0" cellPadding="2" cellSpacing="2" class="table-style2" width="95%" id="table6">
				<tr vAlign="top">
					<td width="100%">
					<table border="0" cellPadding="2" cellSpacing="1" class="table-style3" width="100%" id="table7">
						<tr>
							<td align="right">Group number&nbsp;</td>
							<td><%=groupid %></td>
						</tr>

						 <tr>
          <td align="right" width="35%" height="30"><%= colorName %> number</td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
						<tr>
							<td colSpan="2">
							<table border="0" class="table-style2" width="100%" id="table8">
								<tr>
									<td align="right" width="50%">
 <img onclick="javascript:changePwd()" onmouseover="this.style.cursor='hand'" src="../manager/button/addgrp.gif" style="CURSOR: hand">
                        </td>
									<td width="50%">
									  <img onclick="javascript:document.inputForm.reset()" onmouseover="this.style.cursor='hand'" src="../manager/button/again.gif" style="CURSOR: hand">
                        </td>
								</tr>
							</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				        <tr valign="top">
          <td width="100%"> <table width="98%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
              <tr >
                <td class="table-styleshow" background="../image/n-9.gif" height="26" bgcolor="#FFFFFF">
                  Help information:</td>
              </tr>
		  <%  if(areacode.equals("3")){%>
                <tr>
                <td>1.  PHS number format:  0 + area code + actual number;</td>
                </tr>
              <%}else{%>
              <tr>
                <td>1.  <%= colorName %> number:  Mobile phone number;</td>
              </tr>
              <%}%>
					</table>
					</td>
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
                   alert( "Sorry, you are not allowed to perform this function!");
              </script>
            <%

        }
      }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount +" error occurs in the adding of group user!");
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add(craccount + " Error occurs in the adding of group user");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value=grpAccount.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>
