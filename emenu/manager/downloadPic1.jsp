<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="java.util.Vector" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%   //String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    //String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");

%>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Download File</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<%
try{
	String filename = request.getParameter("filename");
	String filepath = request.getParameter("filepath");
	//
	SmartUpload su = new SmartUpload();
	//
	su.initialize(pageContext);
	//
	su.setContentDisposition(null);
	 //
	if(filename!=null&&filepath!=null&&filename.trim().length()>0&&filepath.trim().length()>0)
	 su.downloadFile("/"+filepath+filename);
}
catch(Exception e)
{
        Vector vet = new Vector();
        sysInfo.add(sysTime + "Exception occourred in the management of Web Skin!");//
        sysInfo.add(sysTime + e.toString());
       //
        vet.add("Error occourred in the management of Web Skin!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
 %>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="webSkinEdit.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>