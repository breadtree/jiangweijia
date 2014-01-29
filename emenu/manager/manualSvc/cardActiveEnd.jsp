<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Activate/deactivate subscriber via Manual Operator Position</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
</head>
<body class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String  craccount = "";
	try {

	   String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
	   craccount = request.getParameter("craccount") == null ? "" : request.getParameter("craccount");
	   String opDesc = "";
           String userringtype = request.getParameter("userringtype") == null ? "0" : (String)request.getParameter("userringtype");
	   if (operID != null && purviewList.get("13-3") != null) {
             manSysPara msp = new manSysPara();
            if(!msp.isAdUser(craccount)){
	     String  opmode = "";
	     zxyw50.Purview purview = new zxyw50.Purview();
             if(!purview.CheckOperatorRight(session,"13-3",craccount)){
            	throw new Exception("You have no right to manage this service area!");
             }
             if(op.equals("active")){
	         opmode = request.getParameter("opmode") == null ? "1" : request.getParameter("opmode");
             if(opmode.equals("1")) opDesc = "Activate service";//激活业务
             else if(opmode.equals("2")) opDesc = "Suspend service";//暂停业务
             SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
             sysTime = SocketPortocol.getSysTime() + "--";
             Hashtable hash = new Hashtable();
             hash.put("opcode","01010701");
             hash.put("craccount",craccount);
             hash.put("passwd","");
             hash.put("op",opmode);
             hash.put("opmode","6");
             hash.put("ipaddr",operName);
             hash.put("userringtype",userringtype);
             Hashtable result = SocketPortocol.send(pool,hash);
             // 准备写操作员日志
            // zxyw50.Purview purview = new zxyw50.Purview();
             HashMap map = new HashMap();
             map.put("OPERID",operID);
             map.put("OPERNAME",operName);
             map.put("OPERTYPE",Integer.toString(502+Integer.parseInt(opmode)));
             map.put("RESULT","1");
             map.put("PARA1",craccount);
             map.put("PARA2","ip:"+request.getRemoteAddr());
             purview.writeLog(map);
        %>
            <script language="javascript">
              var str = "'<%= craccount %>' Subscriber  <%= opDesc %> successfully!"//用户 成功
              alert(str);
              document.URL = 'cardActive.jsp';
            </script>
            <%
         }
         userAdm  useradm = new userAdm();
         Hashtable userInfo = new Hashtable();
         userInfo  = useradm.getUserInfo(craccount);
         int lockid = -1;
         if(userringtype.equalsIgnoreCase("0"))
         lockid = Integer.parseInt((String)userInfo.get("lockid"));
         if(userringtype.equalsIgnoreCase("1"))
         lockid = Integer.parseInt((String)userInfo.get("lockid1"));

         String[] userStatus = {"Normal","Suspended","Cancel Account","Deactivate forcibly","Deactivate forcibly","Unknown"};
         if(lockid<0 || lockid>4) lockid = 5;
    %>
<script language="javascript">
   function onPause(){
       var fm = document.inputForm;
       fm.opmode.value = 2;
       fm.op.value = 'active';
       fm.submit();
   }
   function onRevert(){
       var fm = document.inputForm;
       fm.opmode.value = 1;
       fm.op.value = 'active';
       fm.submit();
   }
   function onBack(){
      document.location.href = "cardActive.jsp";
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="cardActiveEnd.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="opmode" value="">
<input type="hidden" name="craccount" value="<%= craccount %>">
<input type="hidden" name="userringtype" value="<%=userringtype%>">
<table border="0" align="center" height="400" width="400" class="table-style2" >
<tr valign="center">
<td>
      <table border="0" align="center" class="table-style2" width="100%">
        <tr >
          <td height="26" align="center" class="text-title" background="../image/n-9.gif">Activate/deactivate subscriber via Manual Operator Position</td>
        </tr>
        <tr >
          <td height="30" align="center" class="text-title" >&nbsp;</td>
        </tr>
        <tr>
	<td>
           <table border="1" width="80%" align=center cellspacing="0" cellpadding="0" class="table-style2" bordercolorlight="#000000" bordercolordark="#FFFFFF">
           <tr>
           <td class="table-title1" colspan=2 align=center height=26 >
                          User information
           </td>
           </tr>
           <%
            if(userInfo.size()>0){
             out.println("<tr height=23 >");
               out.println("<td width='40%' >The subscriber number :</td>");
               out.println("<td width='60%' >&nbsp;" + craccount + "</td>");
             out.println("</tr>");
             out.println("<tr height=23>");
               out.println("<td>User Name:</td>");
               out.println("<td >&nbsp;" + (String)userInfo.get("username") +"</td>");
             out.println("</tr>");
             out.println("<tr height=23>");
               out.println("<td>ID card No.:</td>");
               out.println("<td >&nbsp;" + (String)userInfo.get("postid") + "</td>");
             out.println("</tr>");
             out.println("<tr height=23>");
               out.println("<td>Current status</td>");
               out.println("<td class='font' >&nbsp;" + userStatus[lockid] + "</td>");
             out.println("</tr>");
           }
          %>
          </table>
       </td>
      </tr>
      <tr>
          <td align="center" height=50 >
            <table border="0" width="60%" class="table-style2">
              <tr>
               <% if(lockid==0) {%>
                <td width="50%" align="center"><img src="../button/pause.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onPause()"></td>
                <% } else if(lockid==1) {%>
                 <td width="50%" align="center"><img src="../button/active.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onRevert()"></td>
               <% } %>
                 <td width="50%" align="center"><img src="../button/back.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onBack()"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
</td>
</tr>
</table>
</form>
<%
      } else {
%>
             <script language="javascript">
                   var str = 'Sorry,the number '+<%= craccount %>+' you enter is ad ringtone subscriber, can not user the system!';
                   alert(str);
                   document.URL = 'cardActive.jsp';
             </script>
<%
      }
    }
    else {
        if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = '../enter.jsp';
              </script>
        <%
         }
         else{
         %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
              </script>
            <%

        }
    }
  }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + ",An error occurred while restoring/suspending user " + craccount+ " via Manual Operator Position!");//人工台恢复/暂停用户  出现错误
        sysInfo.add(sysTime +  e.toString());
        vet.add(operName + ",An error occurred while restoring/suspending user " + craccount+ " via Manual Operator Position!");//人工台恢复/暂停用户  出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/cardActive.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>
