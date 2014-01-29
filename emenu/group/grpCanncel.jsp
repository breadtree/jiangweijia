<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.ManGroup" %>
<%@ page import="zxyw50.manUser" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="zxyw50.Purview"%>
<%@ page import="zxyw50.group.dataobj.*" %>
<%@ page import="zxyw50.group.context.*" %> 

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<html>
<head>
<title>User Account Cancellation</title>
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
    String  craccount = "";
     String groupid=(String)session.getAttribute("GROUPID");
     String groupindex = (String)session.getAttribute("GROUPINDEX");
     String groupname =  (String)session.getAttribute("GROUPNAME");
    try {
	  if (operID != null && purviewList.get("12-17") != null) {
            if(groupid != null && groupindex != null){
            Group grp = new Group();
            grp.setGroupIndex(groupindex);
            grp.setGroupId(groupid);
	    sysTime = ManGroup.getSysTime() + "--";
	    String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
	    if(op.equals("del")){
              ColorRing colorRing = new ColorRing();
              craccount = (String)request.getParameter("craccount");
            manUser manuser = new manUser();
            String type  = manuser.getUserCardinfo(craccount);
            if(type == null)
               throw new Exception("User does not exist!");
            else if("".equals(type))
               throw new Exception("The user is not a group user!");
            if(!grp.getGroupContext().isUserInGroup(craccount))
                throw new Exception("The user are not belong to the group!");//用户不属于该集团
               //还需要加入是否是该集团用户的判断
              SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
              Hashtable hash = new Hashtable();
              hash.put("opcode","01010519");
              hash.put("craccount",craccount);
              hash.put("strreserve1","1");
              hash.put("strreserve2",request.getRemoteAddr());
              Hashtable result = SocketPortocol.send(pool,hash);
            sysInfo.add(sysTime +" administrator "+ operName +"logs "+ craccount + "the user out of the group!");

            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","2006");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            map.put("PARA2","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
%>
<script language="javascript">
   var str = "<%= craccount %>"+" exit group successfully!"
   alert(str);
</script>
<%
        }

%>
<script language="javascript">
  var  colorname = "<%= colorName %>"
   function cardErase () {
      var fm = document.inputForm;
      var value = trim(fm.craccount.value);
      if (value == '') {
         alert('Please input the '+ colorname +' number!');
         fm.craccount.focus();
         return;
      }
      if (value.length<6|| value.length>20) {
         alert(colorname +' number input incorrect!');
         fm.craccount.focus();
         return;
      }
      if (!checkstring('0123456789',fm.craccount.value)) {
         alert(colorname +' number input is incorrect!');
         fm.craccount.focus();
         return;
      }
      var str = "Are you sure to exist the user "+fm.craccount.value+" from the group " + colorname + "?";
      if(!confirm(str))
        return;
      fm.op.value = 'del';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="grpCanncel.jsp">
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
                    <b><font class="font"> Group user logout</font></b></font></td>
                  <td width="12"><img src="../image/home_r14_c5.gif" width="12" height="31"></td>
                </tr>
              </table>
			<table align="center" border="0" cellPadding="2" cellSpacing="2" class="table-style2" width="95%" id="table6">
				<tr vAlign="top">
					<td width="100%">
					<table border="0" cellPadding="2" cellSpacing="1" class="table-style3" width="100%" id="table7">
						<tr>
							<td align="right">Group numbe&nbsp;</td>
							<td><%=groupid %></td>
						</tr>

						 <tr>
          <td align="right" width="35%" height="30"><%= colorName %> Number</td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
						<tr>
							<td colSpan="2">
							<table border="0" class="table-style2" width="100%" id="table8">
								<tr>
									<td align="right" width="50%">
 <img onclick="javascript:cardErase()" onmouseover="this.style.cursor='hand'" src="../manager/button/exit.gif" style="CURSOR: hand">
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
              <tr>
                  <td>1.  After the user logs out the group, he will not enjoy the group <%= colorName %> services;</td>
              </tr>
              <%  if(areacode.equals("3")){%>
                <tr>
                <td>2.  The format of PHS number: 0 + area code + actual number;</td>
                </tr>
              <%}else{%>
              <tr>
                <td>2.  <%= colorName %> Number: Mobile phone number;</td>
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
                   alert( "Sorry,you have no access to this function!");
              </script>
            <%

        }
    }
 }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount +" error occurs in the procedure of the group user logout!");
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add(craccount + " Error occurs in the procedure of the group user logout!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="POST" action="error.jsp">
<input type="hidden" name="historyURL" value="grpCanncel.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
