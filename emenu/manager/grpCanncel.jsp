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
<%@ page import="zxyw50.manSysRing" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<html>
<head>
<title>Subscriber account cancellation</title>
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
	String sEnablePairNumber = CrbtUtil.getConfig("isEnablePairNumber","0");
	int isEnablePairNumber=Integer.parseInt(sEnablePairNumber);
    String  craccount = "";
    try {
	  if (operID != null && purviewList.get("11-3") != null) {
	    sysTime = ManGroup.getSysTime() + "--";
	    String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
	    if(op.equals("del")){
              ColorRing colorRing = new ColorRing();
              craccount = (String)request.getParameter("craccount");
			  if(isEnablePairNumber==1) {
				manSysRing sysring = new manSysRing();
				craccount=sysring.getPairUserNumber(craccount);
			  }

              String groupid = colorRing.getGroupId(craccount);
            manUser manuser = new manUser();
            String type  = manuser.getUserCardinfo(craccount);
            if(type == null)
               throw new Exception("Subscriber does not exits!");
            else if("".equals(type))
              // throw new Exception("用户不是集团用户!");
                throw new Exception(" Subscriber is not the group user!");   
            //鉴权
                Purview pview = new Purview();
                if (!pview.checkGroupOperateRight(session, "11-3", groupid))
                {
                    //throw new Exception("对不起,您对" + craccount + "集团用户没有操作权限!");
                      throw new Exception("You're not authorized to operate the group user " + craccount );
                }
              SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
              Hashtable hash = new Hashtable();
              hash.put("opcode","01010519");
              hash.put("craccount",craccount);
              hash.put("strreserve1","1");
              hash.put("strreserve2",request.getRemoteAddr());
              Hashtable result = SocketPortocol.send(pool,hash);
              sysInfo.add(sysTime +" administrator"+ operName +" has removed Subscriber "+ craccount + " from the group successfully!");


            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","603");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            map.put("PARA2","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
%>
<script language="javascript">
   var str = "<%= craccount %>"+" removed from the group successfully"//退出集团成功
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
         alert('Please input '+ colorname +' number!');//请输入 号码!
         fm.craccount.focus();
         return;
      }
      if (value.length<6|| value.length>20) {
         alert('The '+colorname +' number entered is not correct');//号码输入不正确
         fm.craccount.focus();
         return;
      }
      if (!checkstring('0123456789',fm.craccount.value)) {
         alert('This '+colorname +' number should be digital!');//号码应为数字!
         fm.craccount.focus();
         return;
      }
      var str = "Are you sure Subscriber "+fm.craccount.value+" should be removed from Group " + colorname + "?"//您确信用户  退出集团  吗？
      if(!confirm(str))
        return;
      fm.op.value = 'del';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="grpCanncel.jsp">
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" width="300" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2" width="100%">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Group user exits</td>
        </tr>
         <tr >
          <td height="10" colspan="2" align="center"  >&nbsp;</td>
        </tr>
        <tr>
          <td align="right" width="35%"><%= colorName %> number</td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2" height=30>
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="center"><img src="button/exit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:cardErase()"></td>
                <td width="50%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
         <tr>
          <td align="right" colspan=2>&nbsp;</td>
        </tr>
        <tr>
          <td colspan=2>
          <table border="0" width="100%" class="table-style2">
            <tr>
                <td class="table-styleshow" background="image/n-9.gif" height="26">
                  Notes:</td>
            </tr>
             <tr>
                <td style="color: #FF0000">1. After exit the group, subscriber will not be able to access the services provided by Group <%= colorName %>.</td>
             </tr>
            <%  if(areacode.equals("3")){
            %>
              <tr>
                <td style="color: #FF0000">2.Format of PHS Subscriber Number: 0+area code+actual number.</td>
              </tr>
             <% } else {%>
              <tr>
                <td style="color: #FF0000">2.<%= colorName %>&nbsp;number: Mobile phone number.</td>
              </tr>
            <% } %>


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
                   alert( "You have no access to this function!");
              </script>
            <%

        }
    }
 }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount +",Exception occurred in exitting from group!");
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add(craccount + ",Error occurred in exitting from group!");//集团用户退出过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
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
