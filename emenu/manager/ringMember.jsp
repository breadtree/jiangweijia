<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.ringAdm" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Query the ringtones of ringtones group</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">

<script language="javascript">

   function  myclose () {
     window.close();
   }
</script>

<form name="inputForm" method="post" action="phoneMember.jsp">
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" height="200">
  <tr>
    <td width="100%"><img src="../image/pop013.gif" width="400" height="60"></td>
  </tr>
  <tr>
    <td><img src="../image/pop02.gif" width="400" height="26"></td>
  </tr>
  <tr>
    <td background="../image/pop03.gif" height="91"> <div align="center">
        <table width="80%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String craccount = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();
    try {
        Hashtable hash = new Hashtable();
        Hashtable groupInfo = new Hashtable();
        Vector vetGroupRing = new Vector();
        if (operID != null) {
               ringAdm ringadm = new ringAdm();
               sysTime = ringadm.getSysTime() + "--";
               String ringgroup = request.getParameter("ringgroup") == null ? "" : ((String)request.getParameter("ringgroup")).trim();
			   String phonelabel = request.getParameter("phonelabel") == null ? "" : transferString(((String)request.getParameter("phonelabel")).trim());
			   hash.put("usernumber",craccount);
               hash.put("ringgroup",ringgroup);
			   vetGroupRing = (Vector)ringadm.getRingFromGroup(hash);
			   hash.put("ringid",ringgroup);
               groupInfo = ringadm.getRingInfo(hash);

               if((String)groupInfo.get("ringlabel")==null)
                 throw new Exception("This ringtone group no longer exists!");//该铃音组已不存在
           %>

        <tr>
			  <td align="center">List of ringtones in Ringtone Group&nbsp;"<%= (String)groupInfo.get("ringlabel") %>"</td>
              </tr>
		<tr>
         <td align="center">
                <select name="phonelist" size="10" <%= vetGroupRing.size() == 0 ? "disabled " : "" %>  class="select-style3">
                <%
                if(vetGroupRing.size()>0)
                    out.println("<option value=0> &nbsp;Ringtone code&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; Ringtone name</option>");
                for (int i = 0; i < vetGroupRing.size(); i++) {
                    hash = (Hashtable)vetGroupRing.get(i);
%>
                    <option value="<%= String.valueOf(i+1) %>"><%= (String)hash.get("ringid") + "-----------" + (String)hash.get("ringlabel") %></option>
                    <%
              }
%>
                  </select>
		</td>
        </tr>
<%
         }
         else
             throw new Exception("Please re-log in to the system!");//请重新登录系统
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception ocurred in querying group ringtones of Subscriber "+ craccount + "!");//查询用户  铃音组铃音过程出现异常
        sysInfo.add(sysTime + e.toString());
        vet.add(operName +  " Exception ocurred in querying group ringtones of Subscriber "+ craccount + "!");//查询用户  铃音组铃音过程出现异常
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
        out.println("<tr> <td>" +  e.getMessage() + "</td></tr>");
    }
%>


		 <tr>
                <td align="center"> <img src="button/close.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:myclose()"></td>
          </tr>
        </table>
      </div></td>
  </tr>
  <tr>
    <td><img src="../image/pop04.gif" width="400" height="23"></td>
  </tr>
</table>
</form>
</body>
</html>
