<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="zxyw50.Purview" scope="page" />
<jsp:setProperty name="db" property="*" />

<html>
<head>
<title>Modify password</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = new Vector();
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	String indexpage = request.getParameter("indexpage") == null ? "0" : (String)request.getParameter("indexpage");
    HashMap map = null;
    try {
        //SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");        
        sysTime = CrbtUtil.getSysTime() + "--";
		
        if (operID != null) {
            String oldpwd = (String)request.getParameter("oldcardpass");
            String newpwd = (String)request.getParameter("newcardpass");
			
            map = new HashMap();
            map.put("operid",operID);
            map.put("opername",operName);
            map.put("oldpass",oldpwd);
            map.put("newpass",newpwd);
			db.editOperPassword(map);
            sysInfo.add(sysTime +operName+ " Password modified successfully!");//修改密码成功
			
			
            if(map.size()>0)
                  map.clear();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("HOSTNAME",request.getRemoteAddr());
            map.put("SERVICEKEY","pstn51");
            map.put("OPERTYPE","1");
            map.put("RESULT","1");
            map.put("PARA1","ip:"+request.getRemoteAddr());
            map.put("DESCRIPTION",operName + "modify password");
            db.writeLog(map);
%>
<script language="javascript">
   alert('Password modified successfully!');//密码修改成功!
  // document.location.href = 'operPwdChange.jsp';
  <% HashMap map1 = null;
	map1 = new HashMap();
	map1 = purview.getOperInformation(operID);
	if(indexpage.equals("0"))
    {
 %>
	 window.document.URL = 'operPwdChange.jsp';
<%
	}
   else
	{
	   map1.put("NEXTUPDPWD","0");
	   map1.put("OPERID",operID);
	   purview.updateOper(map1);
%>
    parent.document.URL = 'index.jsp';
<%  }
%>
</script>
<%
        }
        else {
%>
<script language="javascript">
   alert('Please log in to the system first!');//Please log in to the system!
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Error occurred in modifying the password!");//修改密码过程出现错误!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + " Error occurred in modifying the password!");//修改密码过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="operPwdChange.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
