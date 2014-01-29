<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Upload file of batch add number</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    try {
        ColorRing colorRing = new ColorRing();
        sysTime = SocketPortocol.getSysTime() + "--";
        if (operID != null) {
            // 目录文件上传
            SmartUpload fileLoader = new SmartUpload();
            String listName = "";
            String fileName = (new java.util.Date()).getTime() + ".txt";
            fileLoader.initialize(pageContext);
            fileLoader.setAllowedFilesList("txt,");
            fileLoader.setTotalMaxFileSize(5000 * 1024);
            fileLoader.upload();
            // 取目录文件
            com.zte.jspsmart.upload.File listFile = fileLoader.getFiles().getFile(0);
            SocketPortocol portocol = new SocketPortocol();
            listName = listFile.getFileName();
            listFile.saveAs(portocol.getTmpDir() + fileName,listFile.SAVEAS_VIRTUAL);
%>
<script language="javascript">
    window.opener.getListName('<%= fileName %>', '<%= listName %>');
    window.close();
</script>
<%
        }
        else {
%>
<script language="javascript">
   alert('Please log in first!');
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in upload file of batch add number!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Exception occurred in upload file of batch add number!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="hlrBatchUpload.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
