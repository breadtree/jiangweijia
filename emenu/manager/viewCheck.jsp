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
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        String ringURL = sysring.listenCheckRing2(pool,Integer.parseInt(ringindex),usernumber);
        String realUrl   =  JspUtil.appendPath(JspUtil.getCurrentPath(request),ringURL);
        int pos = ringURL.lastIndexOf(".");
        String subfix = ringURL.substring(pos);
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
      <td width="31%" height="15"  valign="top" align="right" >Photo name:</td>
      <td width="69%" height="15"   valign="top" align="left" ><%=ringName %></td>
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
        sysInfo.add(sysTime + "Pre-listen verified ringtone:" + ringindex);
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + ringindex + "Exception occurred in pre-listening the verified ringtone!");//ÊÔÌýÉóºËÁåÒô¹ý³Ì³öÏÖÒì³£
        sysInfo.add(e.toString());
        vet.add("Failed to pre-listen this verified ringtone!");//ÊÔ¿´ÉóºËÍ¼Æ¬Ê§°Ü!
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
