<%@page import="java.lang.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Hashtable"%>
<%@page import="zxyw50.SocketPortocol"%>
<%@page import="zxyw50.bulletin.*"%>
<%@page import="zxyw50.JspUtil"%>
<%@page import="zxyw50.databasePump.DBUtil"%>
<%@page import="com.zte.socket.imp.pool.SocketPool"%>
<%@include file="../pubfun/JavaFun.jsp"%>

<jsp:useBean id="db" class="zxyw50.SpManage" scope="page"/>
<jsp:setProperty name="db" property="*"/>
<%
  response.addHeader("Cache-Control", "no-cache");
  response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>SP Management</title>
<style>
<!--
.f24 {font-size:24px;}

td {font-size:12px}
.l17 {line-height:170%;}
.f14 {font-size:14px}
-->
</style>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT></head>
<body background="background.gif" class="body-style1">
<%
  String sysTime = "";
  Vector sysInfo = (Vector) application.getAttribute("SYSINFO");
  String operID = (String) session.getAttribute("OPERID");
  String operName = (String) session.getAttribute("OPERNAME");
  String spIndex = (String) session.getAttribute("SPINDEX");
  Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable) session.getAttribute("PURVIEW");
  try {
    String errMsg = "";
    boolean alertflag = false;
    if (spIndex == null || spIndex.equals("-1")) {
      errMsg = "Sorry, you are not an SP administrator!";//Sorry,you are not the SP administrator
      alertflag = true;
    }
    else if (operID != null) {
        String index = JspUtil.getParameter(request.getParameter("bindex"));
        DefaultBulletinContext context = new DefaultBulletinContext();
        BulletinObj obj =  context.loadBulletin(index);
        if(obj==null||(!obj.getReadercode().equals("0")&&!obj.getReadercode().equals(spIndex)))
           throw new Exception("View SP announcement error: The announcement does not exist!");//查看SP公告信息出错:该公告不存在
        String date = obj.getRecorddate();
        String year = date.substring(0,4);
        String month = date.substring(5,7);
        String day = date.substring(8,10);
        date = year+"-"+month+"-"+day+"";//年  月  日
      %>
<table border="0" cellPadding="0" cellSpacing="0" width="560" class="table-style2">
	<tr>
		<th colspan="2" class="f24"><p> </p><p>
                    <font color="#05006c"><%=DBUtil.filterFromDB(obj.getTitle())%> </font></th>
	</tr>
	<tr>
		<td colspan="2" style="font-size: 12px"><hr SIZE="1" bgcolor="#d9d9d9"></td>
	</tr>
	<tr>
		<td  colspan="2" align="middle" height="20" style="font-size: 12px"><%=date %></td>
	</tr>
	<tr>
		<td  colspan="2" height="15" style="font-size: 12px"></td>
	</tr>
	<tr>
            <td width="30">&nbsp;</td>
		<td><font class="f14" id="zoom"><%= DBUtil.filterFromDB(obj.getContent()) %></font></td>
	</tr>
</table>

    <%}
    else {
      errMsg = "Please log in to the system first!";
      alertflag = true;
    }
    if (alertflag == true) {
%>
<script language="javascript">
   var errorMsg = '<%= operID!=null?errMsg:"Please log in to the system first!"%>';
   alert(errorMsg);
   parent.document.URL = 'enter.jsp';
</script><%
  }
  } catch (Exception e) {
    Vector vet = new Vector();
    sysInfo.add(sysTime + operName + ",Exception occurred in viewing SP announcement!");//查看SP公告信息过程出现异常!
    sysInfo.add(sysTime + operName + e.toString());
    vet.add(operName + ",View SP announcement!");//查看SP公告信息!
    vet.add(e.getMessage());
    session.setAttribute("ERRORMESSAGE", vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="viewbulletin.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script><%}%>
</body>
</html>
