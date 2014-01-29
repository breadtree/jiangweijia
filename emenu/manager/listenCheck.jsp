<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import ="zxyw50.JspUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
     public String transferString(String str) throws Exception {
       return str;
    }
%>
<html>
<head>
<title>Pre-listen ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String sysTime = "";
    String ringindex = request.getParameter("ringindex") == null ? "" : (String)request.getParameter("ringindex");
    String usernumber = request.getParameter("usernumber") == null ? "" : (String)request.getParameter("usernumber");
    String ringName = request.getParameter("ringname")==null?"":transferString((String)request.getParameter("ringname"));

    int isMCCI = zte.zxyw50.util.CrbtUtil.getConfig("isMCCI", 0);
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        String ringURL = sysring.listenCheckRing2(pool,Integer.parseInt(ringindex),usernumber);
        String realUrl   =  JspUtil.appendPath(JspUtil.getCurrentPath(request),ringURL);
        String mediatype = request.getParameter("mediatype") == null ? "" : (String)request.getParameter("mediatype");
        String height ="";
    if (mediatype.equals("1"))
       height = "71";
    else
       height = "300";
%>
<div align="center">
  <table width="400" border="0" cellspacing="0" cellpadding="0" align="center" height="200">
    <tr>
      <td><img src="../image/pop013.gif" width="400" height="60"></td>
    </tr>
    <tr>
      <td><img src="../image/pop02.gif" width="400" height="6"></td>
    </tr>
    <tr>
   <td background="../image/pop03.gif" height="121">
 <div align="center" >
          <table border="0" width= "350" align="center"  class="table-style2">
    <tr valign = "top" >
      <td width="31%" height="15"  valign="top" align="right" >Ringtone name:</td>
      <td width="69%" height="15"   valign="top" align="left" ><%=ringName %></td>
    </tr>
    <tr>
   <td align="center"  height="<%=height%>"  valign="top" colspan=2  >
      <%
     //Modified to support amr filetype:128 and mediatype:1
      if(isMCCI == 1 || mediatype.equals("2")){%>
        <object classid=CLSID:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B
     codebase=http://www.apple.com/qtactivex/qtplugin.cab
     width="100%" height="100%" align="middle" id="quicktime">
      <param name="src" value="<%=realUrl%>"> // realUrl
      <param name="loop" value="true">
      <param name="autoplay" value="true">
      <param name="controller" value="true">
       <EMBED SRC="<%=realUrl%>" WIDTH=100% HEIGHT = 100% AUTOPLAY=true CONTROLLER=true LOOP=false PLUGINSPAGE="http://www.apple.com/quicktime" />
    </object>
    <%}else if(mediatype.equals("1")){ %>
    <object classid=CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95
    codebase=http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701
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
    <%}
 %>
   </td>
    </tr>
          </table>
        </div>
    </td>
    </tr>
    <tr>
      <td><img src="../image/pop04.gif" width="400" height="23"></td>
    </tr>
  </table>
  </div>
<%
        sysInfo.add(sysTime + "Pre-listen verified ringtone:" + ringindex);
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + ringindex + "Exception occurred in pre-listening the verified ringtone!");//试听审核铃音过程出现异常
        sysInfo.add(e.toString());
        vet.add("Failed to pre-listen this verified ringtone!");//试听审核铃音失败!
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
