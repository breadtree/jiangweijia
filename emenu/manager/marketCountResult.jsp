<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="zxyw50.manSysRing" %>
<%
	String op = request.getParameter("op");
	String hdlist = request.getParameter("hdlist");
	String scplist = request.getParameter("scplist");
 	String subservice    = request.getParameter("subservice");
	String usertype    = request.getParameter("usertype");


	manSysRing sysring = new manSysRing();
	int count=0;
	if("querycount".equals(op))
	{

		count= sysring.getHdUsernumberCount(hdlist,scplist,subservice,usertype);
		out.clear();
		out.print(count);
	}


%>


