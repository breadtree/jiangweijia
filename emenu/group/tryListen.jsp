<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import ="zxyw50.JspUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Try listen ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">

</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String sysTime = "";
    String ringID = request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid");
    String usernumber = request.getParameter("usernumber") == null ? "" : (String)request.getParameter("usernumber");
    String ringName = request.getParameter("ringname")==null?"":transferString((String)request.getParameter("ringname"));
    String ringAuthor = request.getParameter("ringauthor")==null?"":transferString((String)request.getParameter("ringauthor"));
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
	if(ringdisplay.equals(""))  ringdisplay = "ringtone";
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        String spCode = "";
        if (ringID.length() == 0)
            throw new Exception ("Lack of a parameter, the audition is not allowed!");
        spCode = ringID.substring(0,2);
        if (spCode.equals("99"))
            throw new Exception ("You cannot listen to " + ringdisplay + " group!");
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        String ringIndex =  sysring.getRingIndex(usernumber,ringID);
        String ringURL   =  sysring.tryListen(pool,ringIndex,usernumber);
        String realUrl   =  JspUtil.appendPath(JspUtil.getCurrentPath(request),ringURL);
        String mediatype = request.getParameter("mediatype") == null ? "" : (String)request.getParameter("mediatype");
        int isMCCI = zte.zxyw50.util.CrbtUtil.getConfig("isMCCI",0);
        String height ="";
        if (mediatype.equals("1"))
        height = "90";
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
      <td width="31%" height="15"  valign="top" align="right" ><%=ringdisplay%> name:</td>
      <td width="69%" height="15"   valign="top" align="left" ><%=ringName %></td>
    </tr>
    <tr valign = "top">
      <td align="right"  height="15"  valign="top"  ><%=ringdisplay%> author:</td>
      <td   align="left"  height="15"  valign="top"><%=ringAuthor%></td>
     </tr>
    <tr>
   <td align="center"  height="<%=height%>"  valign="top" colspan=2  >
     <%if (isMCCI == 1 || mediatype.equals("2")){  //Modified to support amr --- filetype:128 and mediatype:1
     %>
     <object classid=CLSID:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B
     codebase=http://www.apple.com/qtactivex/qtplugin.cab
     width="100%" height="100%" align="middle" id="quicktime">
      <param name="src" value="<%=realUrl%>"> // realUrl为视听文件的地址
      <param name="loop" value="true">
      <param name="autoplay" value="true">
      <param name="controller" value="true">
      <EMBED SRC="<%=realUrl%>" WIDTH=100% HEIGHT = 100% AUTOPLAY=true CONTROLLER=true LOOP=false PLUGINSPAGE="http://www.apple.com/quicktime" />
    </object>
    <%}
    else if (mediatype.equals("1")){%>
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
   <% }%>
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
        sysInfo.add(sysTime + " try listen " +  ringdisplay + ",ID:" + ringID);
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + ringID + " try listen " +  ringdisplay + " procedure is abnormal!");
        sysInfo.add(e.toString());
        vet.add("Try listen " +  ringdisplay + "fail!");
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
<script>
window.resizeTo(document.body.scrollWidth+15,document.body.scrollHeight + 15);
</script>
</html>
