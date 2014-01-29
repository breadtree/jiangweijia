<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>

<%@page import="zxyw50.CrbtUtil"%>


<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
	String indexpage = request.getParameter("indexpage") == null ? "0" : (String)request.getParameter("indexpage");
%>
<jsp:useBean id="db" class="zxyw50.Purview" scope="page" />
<jsp:setProperty name="db" property="*" />

<html>
<head>
<title>Modify password</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = new Vector();
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
     Hashtable hash = null;
    String spIndex = (String)session.getAttribute("SPINDEX");
    try {
        sysTime = CrbtUtil.getSysTime() + "--";
        if (operID != null) {
            String oldpwd = (String)request.getParameter("oldcardpass");
            String newpwd = (String)request.getParameter("newcardpass");
			hash = new Hashtable();
            hash.put("operid",operID);
            hash.put("opername",operName);
            hash.put("oldpass",oldpwd);
            hash.put("newpass",newpwd);
			db.editSpPassword(hash);
            sysInfo.add(sysTime +operName+ " have successfully changed  password!");//修改密码成功
			// 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("HOSTNAME",request.getRemoteAddr());
            map.put("SERVICEKEY","pstn51");
            map.put("OPERTYPE","1");
            map.put("RESULT","1");
            map.put("PARA1","ip:"+request.getRemoteAddr());
            map.put("DESCRIPTION",operName + "modify password");
            purview.writeLog(map);
%>
<script language="javascript">
   alert("You have successfully changed your password!");//密码修改成功
  
<%
	HashMap map1 = null;
	map1 = new HashMap();
	map1 = purview.getOperInformation(operID);
    if(indexpage.equals("0"))
    {
%>
     window.document.URL = 'spchangePassword.jsp';
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

    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + ",Error occurred in changing the password!");//修改密码过程出现错误
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + ",Error occurred in changing the password!");//修改密码过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="spchangePassword.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
