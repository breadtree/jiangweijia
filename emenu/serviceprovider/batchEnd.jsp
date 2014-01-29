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
<title>Batch ringtone uploda</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	 zxyw50.Purview purview = new zxyw50.Purview();
	Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
    try {
        ColorRing colorRing = new ColorRing();
        sysTime = SocketPortocol.getSysTime() + "--";
        if (operID != null) {
            // 目录文件上传
            SmartUpload fileLoader = new SmartUpload();
            String listName = "";
             //String fileName = (new java.util.Date()).getTime() + ".lst";
            String fileName ="";
            fileLoader.initialize(pageContext);
            if(sysfunction.get("2-66-0")== null){
				fileLoader.setAllowedFilesList("list,,");
			}else{
            fileLoader.setAllowedFilesList("lst,list,,");
			}
            fileLoader.setTotalMaxFileSize(5000 * 1024);
            fileLoader.upload();
            // 取目录文件
            com.zte.jspsmart.upload.File listFile = fileLoader.getFiles().getFile(0);
            SocketPortocol portocol = new SocketPortocol();
            listName = listFile.getFileName();
            if(listName.endsWith(".list"))
              fileName=(new java.util.Date()).getTime() + ".list";
            else
              fileName=(new java.util.Date()).getTime() + ".lst";
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
   alert("Please log in first!");
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in batch uploading ringtone!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Errors occurred in batch uploading ringtone!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="batchUpload.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
