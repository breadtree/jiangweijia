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
<title>Upload ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">

<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");

    String realpath = application.getRealPath("/");
    try {

        sysTime = SocketPortocol.getSysTime() + "--";
        if (operID != null) {
            // ͼƬ�ϴ�
             SmartUpload fileLoader = new SmartUpload();
             fileLoader.initialize(pageContext);

            // �����ļ��ϴ���׺��
            // fileLoader.setAllowedFilesList(extName);

            fileLoader.upload();
             String extName = fileLoader.getRequest().getParameter("extName");
             String filecode = fileLoader.getRequest().getParameter("filecode");
             String filepath = fileLoader.getRequest().getParameter("filepath");


            String newfile = (new java.util.Date()).getTime() + "."+extName;

            // ȡͼƬ�ļ�
            com.zte.jspsmart.upload.File picFile = fileLoader.getFiles().getFile(0);

            String tmpExt=picFile.getFileExt();

            if(!tmpExt.toLowerCase().equals(extName))
            {
            throw new Exception("The extension of the file is not allowed to be uploaded!");
            }

            SocketPortocol portocol = new SocketPortocol();
            // �����ϴ��ļ�
            picFile.saveAs(portocol.getTmpDir() + newfile,picFile.SAVEAS_PHYSICAL);

            // �õ�ԭ�ļ�
            java.io.File file = new java.io.File(realpath + filepath + filecode);
            // �豸�ݵ���ʱ�ļ�
            java.io.File bakfile = new java.io.File(realpath + filepath + filecode+".bak");

            // �ϴ�����ʱ�ļ�
            java.io.File tmpfile = new java.io.File(portocol.getTmpDir() + newfile);
            // ����ԭ�ļ�

            // ɾ��ԭ�����ļ�
            if(bakfile.exists())
            {
             bakfile.delete();
            }
           if(file.renameTo(bakfile))
           {
            // ����ʱ�ļ��滻ԭ�ļ�
             if(tmpfile.renameTo(file))
             {}
             else{
             throw new Exception("Wrong when replace file!");
             }
           }
           else
           {

                throw new Exception("Wrong when bak the file to be repalced!");
           }

  // д��־
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
             map.put("OPERID",operID);
             map.put("OPERNAME",operName);
             map.put("OPERTYPE","330");
             map.put("RESULT","1");
             map.put("PARA1",filecode);
             map.put("PARA2",filepath);
             map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
              purview.writeLog(map);



%>
<script language="javascript">
   alert("Replace file successfully, the file which haved been replaced was backup to a new file added the '.bak' extend file name ");
   window.close();
</script>
<%
        }
        else {
%>
<script language="javascript">
   alert('Please log in to the system first!');//Please log in to the system!
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in replacing the file " );//�������ع��̳����쳣
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in replacing the file " );//�������ع��̳��ִ���
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
