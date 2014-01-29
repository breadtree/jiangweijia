
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.ywaccess" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    
    int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
    String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
%>
<%!
    public String formatFee (String str,String majorcurrency) {

       zte.zxyw50.render.RingfeeCellRender  r = new zte.zxyw50.render.RingfeeCellRender();
       return r.render(str,null,null,null).toString()+majorcurrency;

    }
%>
<html>
<head>
<title>Verify ringtone info</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">

<%
//是否支持随意铃功能开关
ywaccess yes=new ywaccess();
String suiyi=yes.getPara(145);
String uservalidday = CrbtUtil.getConfig("uservalidday","0") == null ? "0" : CrbtUtil.getConfig("uservalidday","0");
    String sysTime = "";
    String craccount = (String)session.getAttribute("USERNUMBER");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String ringid = request.getParameter("ringid") == null ? "" : ((String)request.getParameter("ringid")).trim();
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
	if(ringdisplay.equals(""))  ringdisplay = "ringtone";//铃音
	
	
	 
	
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        HashMap ringInfo = new HashMap();
        manSysRing sysring = new manSysRing();
        ringInfo = (HashMap)sysring.getCheckRingInfo(ringid);

%>
<form name="inputForm" method="post" action="ringInfo.jsp">
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
                <%=  ringdisplay  %>Info</font></b></div>
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
            <td align="right">Verify status:&nbsp;</td>
            <td>&nbsp;<%= (String)ringInfo.get("ischeck") %></td>
          </tr>
          <tr>
            <td align="right">Singer:&nbsp;</td>
            <td>&nbsp;<%= (String)ringInfo.get("ringauthor") %></td>
          </tr>
          <tr>
            <td align="right"><%=  ringdisplay  %> Provider:&nbsp;</td>
            <td>&nbsp;<%= (String)ringInfo.get("ringsource") %></td>
          </tr>
          <%if(issupportmultipleprice == 1){%>
          <tr>
            <td align="right" height="23"><%=  ringdisplay  %> Daily Price:&nbsp;</td>
            <td height="23">&nbsp;<%= formatFee((String)ringInfo.get("ringfee2"),majorcurrency) %></td>
          </tr>
          <%}%>
		  <tr>
            <td align="right" height="23"><%=  ringdisplay  %><%if(issupportmultipleprice == 1){%> Monthly <%}%>Price:&nbsp;</td>
            <td height="23">&nbsp;<%= formatFee((String)ringInfo.get("ringfee"),majorcurrency) %></td>
          </tr>
          <tr>
            <td align="right">Period of Validity:&nbsp;</td>
            <td>&nbsp;
                          <%
                if(("1").equals(uservalidday)){
                  if("0".equals((String)ringInfo.get("uservalidday"))){
              %>
                     <%= ((String)ringInfo.get("validate")) %>
                  <%}else{%>
                      <%= ((String)ringInfo.get("uservalidday")) %>&nbsp;days
                  <%}%>
              <%}else {%>
                <%= ((String)ringInfo.get("validate")) %>
              <%}%>
            </td>
          </tr>
          <tr>
            <td align="right">Upload time:&nbsp;</td>
            <td>&nbsp;<%= ((String)ringInfo.get("uploadtime")) %></td>
          </tr>
          <%if("1".equals(suiyi))
          {
          String typeDisplay = "none";
             String ringlongDisplay="none";
                           if("1".equals(suiyi))
               typeDisplay = "";
          String iswillring=(String)ringInfo.get("isfreewill");

            if("1".equals(suiyi)&&iswillring.equals("1"))
               ringlongDisplay="";
               %>
            <tr style="display:<%= typeDisplay%>">
            <td align="right">Whether random ringtone &nbsp;</td>
            <td>&nbsp;<input type="hidden" name="isfreewillstat" value="<%=((String)ringInfo.get("isfreewill"))%>"><%=((String)ringInfo.get("isfreewill")).equals("1")?"Yes":"No"%> </td>
          </tr>
            <tr style="display:<%= ringlongDisplay %>">
            <td align="right">Ringtone time range &nbsp;</td>
            <td>&nbsp;<%= ((String)ringInfo.get("ringlong")) %>&nbsp;Second</td>
          </tr>
          <%}%>
          <tr>
            <td colspan="2" align="center"><br>
              <img src="button/close.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:window.close()"></td>
          </tr>
        </table>
      </div></td>
  </tr>
  <tr>
    <td><img src="../image/pop04.gif" width="400" height="23"></td>
  </tr>
</table>
</form>
<%
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + " Exception occurred in viewing " + ringdisplay + ringid + "!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Error occurred in viewing " + ringdisplay +"!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="checkRingInfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
