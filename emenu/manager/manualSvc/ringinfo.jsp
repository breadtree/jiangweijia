<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.ringAdm" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.RingQuery" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Activate/deactivate subscriber via Manual Operator Position</title>
<link rel="stylesheet" type="text/css" href="../../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">

<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="">
<input type="hidden" name="op" value="">
<%
String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");   
String ringgroup = request.getParameter("ringid");
RingQuery rq = new RingQuery();
Hashtable ht = rq.querySysRingGroupInfo(ringgroup);
%>
<table border="0" align="center" height="330" width="400" class="table-style2" >
	<tr height=22><td></td></tr>
  <tr valign='top'>
    <td bgcolor="E1F2FF">
      <table border="0" align="center" class="table-style2" width=100% >
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="../image/n-9.gif"><%=musicbox%> Information</td>
        </tr>
           <tr>
          <td width="50%" align="right" height=22 ><%=musicbox%> Name:</td>
          <td><%=ht.get("grouplabel").toString()%></td>
        </tr>
          <tr>
          <td align="right" height=22 >Buytimes:</td>
          <td><%=ht.get("buytimes").toString()%></td>
        </tr>
          <tr>
          <td align="right" height=22 >Ringtone Numbers: </td>
          <td><%=ht.get("curcnt").toString()%></td>
        </tr>
          <tr>
          <td align="right" height=22 > Description:</td>
          <td><%=ht.get("description").toString()%></td>
        </tr>
          <tr align="center" >
          <td height=22 colspan=2> 
          <img src="../button/close.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:window.close()">
          </td>	
          </tr>
        
      </table>
    </td>
  </tr>
</table>
</form>

</body>
</html>
