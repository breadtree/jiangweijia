<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Batch account open result</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String operID = (String)session.getAttribute("OPERID");
    int totalcnt=0;
    int curcnt = 0;
    List arrayResult = (ArrayList)session.getAttribute("rList");
    if(session.getAttribute("totalcnt")!=null)
	  totalcnt = ((Integer)session.getAttribute("totalcnt")).intValue();
    if(session.getAttribute("curcnt")!=null)
	  curcnt = ((Integer)session.getAttribute("curcnt")).intValue();
    if (operID != null) {
    int width=(int)((float)curcnt/totalcnt*300f);
%>

<form name="fm1" method="POST" action="processbar.jsp">
    <table>
  <tr>
	  <td height="50">&nbsp;</td>
  </tr>
  <tr>
	  <td ><table><tr><td width="<%=width%>" bgcolor="#56ef45"></td><td>&nbsp;</td></tr></table></td>
  </tr>
  <tr>
	  <td height="50">&nbsp;</td>
  </tr>
  <tr>
	  <td><%=width==300?"Operation success!":"Please waitting ..."%></td>
  </tr>
</table>
<table width="98%" border="1" align="center" cellpadding="1" cellspacing="1" class="table-style2" >
<tr class="tr-ringlist">
        <td width="30%" align="center">Account number</td>
        <td width="70%" align="center">Result</td>
  </tr>
<%
  Map maptemp = null;
  for (int k = 0; k < arrayResult.size(); k++) {
    maptemp = (Hashtable) arrayResult.get(k);
    out.println("<tr bgcolor='" + (k % 2 == 0 ? "E6ECFF" : "#FFFFFF") + "'>");
    out.println("<td>" + maptemp.get("acctnum") + "</td>");
    out.println("<td>" + maptemp.get("result") + "</td>");
    out.println("</tr>");
  }
%>
</table>

</form>
<script language="JavaScript1.2">

function f_time(){
	document.fm1.submit();
}
id=setTimeout('f_time()',300);
<%=width==300?"clearTimeout(id);":""%>
</script>
<%
    }
    else {
%>
<script language="javascript">
   alert('Please log in to the system!');//Please log in to the system!
   document.URL = 'enter.jsp';
</script>
<%
    }
%>
</body>
</html>
