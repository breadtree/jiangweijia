<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.ringAdm" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@page import="zte.zxyw50.util.JCalendar"%>

<%!
int isfarsicalendar = zte.zxyw50.util.CrbtUtil.getConfig("isfarsicalendar", 0);
JCalendar cal = new JCalendar();
public String jcalendar(String str){
	if(isfarsicalendar == 1){
		str = cal.gregorianToPersian(str); 
	}	
	return str;
}
%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
	String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
	int largessflag = 0;
	if(disLargess.equals("1"))
		largessflag = 1;
%>
<html>
<head>
<title>Ring Info</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%!
    public String formatFee (String str) {
       zte.zxyw50.render.RingfeeCellRender  r = new zte.zxyw50.render.RingfeeCellRender();
       return r.render(str,null,null,null).toString();

    }
%>
<%
String issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice","0");
    String sysTime = "";
    String craccount = (String)session.getAttribute("USERNUMBER");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String ringid = request.getParameter("ringid") == null ? "" : ((String)request.getParameter("ringid")).trim();
    String usernumber = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
	if(ringdisplay.equals(""))  ringdisplay = "ringtone";
        // 3.14.04 用户有效期
    String majorcurrency = " "+zxyw50.CrbtUtil.getConfig("majorcurrency","$");
    String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");    
    String uservalidday = CrbtUtil.getConfig("uservalidday","0") == null ? "0" : CrbtUtil.getConfig("uservalidday","0");
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        Hashtable hash = new Hashtable();
        hash.put("usernumber",usernumber);
        hash.put("ringid",ringid);
		//System.out.println(ringid);
        Hashtable ringInfo = new Hashtable();
        ringAdm ringadm = new ringAdm();
        // 查询铃音信息
        ringInfo = (Hashtable)ringadm.getRingInfo(hash);
%>
<form name="inputForm" method="post" action="ringInfo.jsp">
<input type="hidden" name="usernumber" value="<%= usernumber %>">
<input type="hidden" name="ringid" value="<%= ringid %>">
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" height="200">
  <tr>
    <td><img src="../image/pop013.gif" width="400" height="60"></td>
  </tr>
  <tr>
    <td><img src="../image/pop02.gif" width="400" height="26"></td>
  </tr>
  <tr>
    <td background="../image/pop03.gif" height="91"> <div align="center">
        <table width="100%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
          <tr>
            <td align="right" width="50%">
              <div align="center"><b><font class="font"><img src="image/n-8.gif" width="8" height="8">
                <%=  ringdisplay  %> Info</font></b></div>
            </td>
            <td width="50%">&nbsp;</td>
          </tr>
          <tr>
            <td align="right" width="50%"><%=  ringdisplay  %> Code:&nbsp;</td>
            <td width="50%">&nbsp;<%= (String)ringInfo.get("ringid") %></td>
          </tr>
          <tr>
            <td align="right"><%=  ringdisplay  %> Name:&nbsp;</td>
            <td>&nbsp;<%= (String)ringInfo.get("ringlabel") %></td>
          </tr>
          <tr>
            <td align="right">Singer:&nbsp;</td>
            <td>&nbsp;<%= (String)ringInfo.get("ringauthor") %></td>
          </tr>
          <tr>
            <td align="right"><%=  ringdisplay  %> Provider:&nbsp;</td>
            <td>&nbsp;<%= (String)ringInfo.get("ringsource") %></td>
          </tr>
          <%if("1".equals(issupportmultipleprice)){%>
          <tr>
            <td align="right"><%=  ringdisplay  %> Daily Price (<%=minorcurrency%>) :&nbsp;</td>
	    <td>&nbsp;<%= ringInfo.get("ringfee2") %></td>
          </tr><%} %>
          <tr>
            <td align="right"><%=  ringdisplay%><%if("1".equals(issupportmultipleprice)){%> Monthly<%}%> Price (<%=minorcurrency%>):</td>
	    <td>&nbsp;<%= ringInfo.get("ringfee") %></td>
          </tr>
              <%
                if(("1").equals(uservalidday)){
                %>
                <tr><td align="right">User Validity:&nbsp;</td><td>&nbsp;<%= ((String)ringInfo.get("uservalidday")) %>&nbsp;days</td>
                </tr>
               <%}%>
               <tr><td align="right">Validate:&nbsp;</td><td>&nbsp;<%=jcalendar((String)ringInfo.get("validate")) %>&nbsp;</td>
                 </tr>
          <%
        if (usernumber.length() == 0) {
%>
          <tr>
            <td align="right">Buy Times:&nbsp;</td>
            <td>&nbsp;<%= (String)ringInfo.get("buytimes") %></td>
          </tr>
     <% if(largessflag!=1){%>
          <tr>
            <td align="right">Gift Times:&nbsp;</td>
            <td>&nbsp;<%= (String)ringInfo.get("largesstimes") %></td>
          </tr>
     <%}%>
          <tr>
            <td align="right">Time to Lib.:&nbsp;</td>
            <td>&nbsp;<%= jcalendar((String)ringInfo.get("uploadtime")) %></td>
          </tr>

          <%
        }
        else {
%>
          <tr>
            <td align="right">Upload time:&nbsp;</td>
            <td>&nbsp;<%= ((String)ringInfo.get("uploadtime")) %></td>
          </tr>
      <% if(largessflag!=1){%>
          <tr>
            <td align="right">Present number:&nbsp;</td>
            <td>&nbsp;<%= (String)ringInfo.get("largessnumber") %></td>
          </tr>
      <%}
        }
%>
          <tr>
            <td colspan="2" align="center"><br>
              <img src="../button/close.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:window.close()"></td>
          </tr>
        </table>
      </div></td>
  </tr>
  <tr>
    <td><img src="../image/pop04.gif" width="400" height="23"></td>
  </tr>
</table>
<%
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + usernumber + " view " + ringdisplay + ringid + " error!");
        sysInfo.add(sysTime + usernumber + e.toString());
        vet.add("Error in view " + ringdisplay +"!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="ringInfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
