<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.phoneAdm" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
	public String display(String callingNum, String ringLabel) {
        String str = "";
        int len = callingNum.length();
        if(!(len>9) && callingNum.substring(0,1).equals("0")){//vpn用户
        	callingNum = callingNum.substring(1,len);
        }

        for (int i = 0; i < 20 - len; i++)
            str = str + "-";
        return callingNum + str + ringLabel;
    }
%>
<html>
<head>
<title>Calling number group member management info</title>
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
        ArrayList lstGroupPhone = null;
        HashMap map = null;
        Hashtable result = null;
        if (operID != null) {

               phoneAdm phoneadm = new phoneAdm();
               sysTime = phoneadm.getSysTime() + "--";
               String phonegroup = request.getParameter("phonegroup") == null ? "" : ((String)request.getParameter("phonegroup")).trim();
			   String phonelabel = request.getParameter("phonelabel") == null ? "" : transferString(((String)request.getParameter("phonelabel")).trim());
			   hash.put("usernumber",craccount);
               hash.put("phonegroup",phonegroup );
               lstGroupPhone = phoneadm.getPhoneFromGroup(hash);
               groupInfo = phoneadm.getCallingGroupInfo(craccount,phonegroup);
           %>

        <tr>
			  <td align="center">Calling number list of Calling Number Group &nbsp;"<%= (String)groupInfo.get("grouplabel") %>"</td>
              </tr>
		<tr>
         <td align="center">
                <select name="phonelist" size="10" <%= lstGroupPhone.size() == 0 ? "disabled " : "" %>  class="select-style3">
                <%
                if(lstGroupPhone.size()>0)
                    out.println("<option value=0> &nbsp;&nbsp;Calling number&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; Caller name</option>");

                for (int i = 0; i < lstGroupPhone.size(); i++) {
                    map = (HashMap)lstGroupPhone.get(i);
%>
                    <option value="<%= String.valueOf(i+1) %>"><%= display((String)map.get("callingnum"),(String)map.get("cnumlabel")) %></option>
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
        sysInfo.add(sysTime + operName + "Exception occurred in querying calling number group members "+ craccount + "!");//查询用户  主叫号码组成员过程出现异常
        sysInfo.add(sysTime + e.toString());
        vet.add(operName +  "Exception occurred in querying calling number group members "+ craccount + "!");//查询用户  主叫号码组成员过程出现异常
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
