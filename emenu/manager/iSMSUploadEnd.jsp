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
<title>iSMS File upload</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    try {
        //ColorRing colorRing = new ColorRing();
        sysTime = SocketPortocol.getSysTime() + "--";
        if (operID != null) {
            // 文件上传
            SmartUpload fileLoader = new SmartUpload();
            String ringName = "";
            String fileName = (new java.util.Date()).getTime() + ".txt";
            fileLoader.initialize(pageContext);
            fileLoader.setAllowedFilesList("TXT,txt,TXt,TxT,Txt,tXT,tXt,txT,,");
            fileLoader.setTotalMaxFileSize(500 * 1024);
            fileLoader.upload();
            // 取文件
            com.zte.jspsmart.upload.File ringFile = fileLoader.getFiles().getFile(0);
           SocketPortocol portocol = new SocketPortocol();
                ringName = ringFile.getFileName();
                ringFile.saveAs(portocol.getWavDir() + "/tmp/"+ fileName,ringFile.SAVEAS_PHYSICAL);
%>
<script language="javascript">
    window.opener.getRingName('<%= fileName %>', '<%= ringName %>');
    window.close();
</script>
<%
        }
        else {
%>
<script language="javascript">
   alert('Please log in to the system first!');
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occourred in the batch acount open file upload!");//批量开户文件上载过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occourred in the batch acount open file upload!");//批量文件上载过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="iSMSUpload.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
