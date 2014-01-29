
<%@ page import="zxyw50.manPrint" %>
<%@ page import="java.util.*" %>
<html>
<head>
<title>
¥Ú”°
</title>
</head>
<body bgcolor="#ffffff">
<%
try
{
  String pagering = request.getParameter("ringinfo");
  manPrint pt= (manPrint)session.getAttribute("printobj");
  String key = "",usernumber = "",opid="";
  String [] fd = null;
  HashMap map = null;
  if(pagering!=null)
  {
    key = (String)session.getAttribute("filedkey");
    opid = (String)session.getAttribute("OPERNAME");
    fd = (String[])session.getAttribute("fileds");
    usernumber = (String)session.getAttribute("usernumber");
    map = new HashMap();
    map = (HashMap)session.getAttribute("map");
  }
%>
<%=pagering==null?pt.printData():pt.printCustomerData(key,fd,map,usernumber,opid)%>
<% }
catch(Exception e)
{
  e.printStackTrace();
}%>
</body>
</html>
