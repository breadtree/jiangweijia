<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<%
    String sysTime = "";
    Vector vet = (Vector)application.getAttribute("SYSINFO");
    if (vet == null) {
        vet = new Vector();
        application.setAttribute("SYSINFO",vet);
    }
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
    ColorRing colorRing = new ColorRing();
    sysTime = SocketPortocol.getSysTime() + "--";
    if (operID != null && purviewList.get("8-1") != null) {
%>
<html>
<head>
<title>System log</title>
<meta http-equiv="refresh" content="30" url="operLog.jsp">
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body class="body-style1">
<table width="100%" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>     
	 <table border="0" bordercolorlight="#000000" bordercolordark="#ffffff" cellspacing="2" cellpadding="2" width="100%" align="center" class="table-style2">
        <tr>
          <td height="26" colspan="4" align="center" class="text-title" >System log</td>
        </tr>
		</table>
		<table border="1" cellspacing="2" cellpadding="2" width="100%" align="center" class="table-style2">
       
        <%
	int count=0;		
    for (int i = vet.size() - 1; i >= 0; i--) {
		count++;
%>
        <tr bgcolor="<%= count%2==0? "FFFFFF" : "f5fbff" %>">
          <td><%= (String)vet.get(i) %></td>
        </tr>
        <%
    }
%>
      </table>
    <p>&nbsp;</p></td>
  </tr>
</table>
<p>&nbsp;</p>
<script language="javascript">
</script>
<%
        }
        else {
         
          if(operID== null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = 'index.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
              </script>
              <%        
                      
                   }
    }
%>
</body>
</html>
