<%@include file="/base/i18n.jsp"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import ="zxyw50.JspUtil" %>
<%@ page import="zte.zxyw50.colorring.util.RingViewHelper"%>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Pre-listen ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" class="framed" background="../image/popBackground.gif">
<%
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String sysTime = "";
    String ringName = request.getParameter("ringname")==null?"":transferString((String)request.getParameter("ringname"));
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");

        manSysRing sysring = new manSysRing(RingViewHelper.getZteLocale(request));
        sysTime = sysring.getSysTime() + "--";
        String ringURL = request.getParameter("ringpath")==null?"":request.getParameter("ringpath").toString().trim();
        String realUrl   =  JspUtil.appendPath(JspUtil.getCurrentPath(request),ringURL);
%>
<div align="center">
  <table width="400" border="0" cellspacing="0" cellpadding="0" align="center" height="200">
    <tr><td colspan="3" background="../image/popBackgroundTop.gif" >
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
	   <tr>
		<td width="125" rowspan="2" valign="top"><img src="../image/clear.gif" width="125" height="85" border="0"></td>
		<td colspan="2"><img src="../image/clear.gif" width="125" height="55" border="0"></td>
	   </tr>
	   <tr>
		<td valign="top"><b>Pre Listen</b></td>
		<td width="25"><img src="../image/clear.gif" width="25" height="30" border="0"></td>
	   </tr>
	</table>
      </td>
    </tr>
    <tr>
      <td width="9"><img src="../image/clear.gif" width="9" height="15"></td>
      <td height="121" bgcolor="E1F2FF" align="center">
       <table border="0" width= "450" align="center"  class="table-style2">
           <tr valign = "top" >
             <td width="31%" height="15"  valign="top" align="right" >Ringtone name:</td>
             <td width="69%" height="15"   valign="top" align="left" >My mix-tune</td>
           </tr>
           <tr>
             <td colspan="2" height="10">&nbsp;</td>
           </tr>
           <tr>
              <td align="center"  height="71"  valign="top" colspan=2  >
                <object classid=CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95
                     codebase="http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701"
                     width="100%" height="70" align="middle" id="mediaplayer">
                  <param name="FileName" value="<%=realUrl%>">
                  <param name="AutoStart" value="true">
                  <param name="AutoRewind" value="-1">
                  <param name="ShowControls" value="true">
                  <param name="ClickToPlay" value="false">
                  <param name="EnableContextMenu" value="false">
                  <param name="EnablePositionControls" value="true">
                  <param name="Balance" value="0">
                  <param name="ShowStatusBar" value="true">
                  <param name="AutoSize" value="1">
                </object>
              </td>
          </tr>
        </table>
      </td>
      <td width="11"><img src="../image/clear.gif" width="11" height="15"></td>
    </tr>
  <tr>
    <td width="9"><img src="../image/clear.gif" width="9" height="15"></td>
    <td><img src="../image/popBackgroundBottom.gif" width="480" height="15"></td>
    <td width="11"><img src="../image/clear.gif" width="11" height="15"></td>
  </tr>
  </table>
  </div>
<Script language="JavaScript">
  window.resizeTo(508,300);
</Script>
<%
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime  + ",Exception occurred in pre-listening to the ring back tone!");//试听  过程出现异常
        sysInfo.add(e.toString());
        vet.add("Failed to pre-listen to the ringtone!");//
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
