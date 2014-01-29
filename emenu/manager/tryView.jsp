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
<title>Try View</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String sysTime = "";
    String ringID = request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid");
    String usernumber = request.getParameter("usernumber") == null ? "" : (String)request.getParameter("usernumber");
    String mediatype = request.getParameter("mediatype") == null ? "" : (String)request.getParameter("mediatype");
    String ringName = request.getParameter("ringname")==null?"":transferString((String)request.getParameter("ringname"));
    String ringAuthor = request.getParameter("ringauthor")==null?"":transferString((String)request.getParameter("ringauthor"));
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
	if(ringdisplay.equals(""))  ringdisplay = "Photo";
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        String spCode = "";
        if (ringID.length() == 0)
            throw new Exception ("Can't try listen this ringtone because of loss parameters!");
        spCode = ringID.substring(0,2);
        if (spCode.equals("99"))
            throw new Exception ("Can't try listen " + ringdisplay + " group!");
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        String ringIndex =  sysring.getRingIndex(usernumber,ringID);
        String ringURL   =  sysring.tryView(pool,ringIndex,usernumber);
        int pos = ringURL.lastIndexOf(".");
        String subfix = ringURL.substring(pos);

        String realUrl   =  JspUtil.appendPath(JspUtil.getCurrentPath(request),ringURL);
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
      <td width="31%" height="15"  valign="top" align="right" >Photo Name:</td>
      <td width="69%" height="15"   valign="top" align="left" ><%=ringName %></td>
    </tr>
    <tr valign = "top">
      <td align="right"  height="15"  valign="top"  >Photo author:</td>
      <td   align="left"  height="15"  valign="top"><%=ringAuthor%></td>
     </tr>
    <tr>
   <td align="center"  height="<%=height%>"  valign="top" colspan=2  >
     <%if(subfix.toLowerCase().equals(".txt")){ %>
     <iframe src="<%=realUrl%>" FRAMEBORDER=1 SCROLLING=NO width="350" height="280" ></iframe>
      <% }else{%>
      <img src="<%=realUrl%>" width="350" height="300">
      <%} %>
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
        sysInfo.add(sysTime + " try view  " +  ringdisplay + "£¬ID£º" + ringID);
    }
    catch(Exception e) {
        e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + ringID + " try view  " +  ringdisplay + " Exception occurred in try listening");
        sysInfo.add(e.toString());
        vet.add(" try view  " +  ringdisplay + " failed!");
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
