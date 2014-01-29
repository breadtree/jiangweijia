<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.tao.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="com.zte.tao.config.TaoUtil" %>

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
    try {
        ColorRing colorRing = new ColorRing();
        sysTime = SocketPortocol.getSysTime() + "--";
        if (operID != null) {
            // 铃音上传
            SmartUpload fileLoader = new SmartUpload();
            String ringName = "";
//            String fileName = (new java.util.Date()).getTime() + ".wav";
            fileLoader.initialize(pageContext);
            fileLoader.setAllowedFilesList("amr,AMR,aMr,Amr,aMR,AmR,amR,AMr,wav,waV,wAv,wAV,Wav,WaV,WAv,WAV,mov,moV,mOv,mOV,Mov,MoV,MOv,MOV,jpg,jpG,jPg,jPG,Jpg,JpG,JPg,JPG,gif,giF,gIf,gIF,Gif,GiF,GIf,GIF,bmp,bmP,bMp,bMP,Bmp,BmP,BMp,BMP,txt,txT,tXt,tXT,Txt,TxT,TXt,TXT,jpeg,jpeG,jpEg,jpEG,jPeg,jPeG,jPEg,jPEG,Jpeg,JpeG,JpEg,JpEG,JPeg,JPeG,JPEg,JPEG,3gp,3GP,,");
            fileLoader.setTotalMaxFileSize(10240 * 1024);
            fileLoader.upload();
            // 取铃音文件
            String uploadfilesize =zte.zxyw50.util.CrbtUtil.getConfig("uploadfilesize ","8|10240|8|10240|0|1024");
//            String [] sFileSize = uploadfilesize.split("|");   //从配置中读取各种文件类型大小
             String [] sFileSize = com.zte.tao.util.StringUtil.split(uploadfilesize,"|");
            com.zte.jspsmart.upload.File ringFile = fileLoader.getFiles().getFile(0);
            String tmpExt=ringFile.getFileExt();
            String sFileType = "ringtone";  //文件类型  ringtone|vedio|photo ,用于抛出异常说明是哪一中文件超出大小范围

            int iMinFileSize = 0;
            int iMaxFileSize = 0;
            try
            {
              if(tmpExt.toLowerCase().equals("wav") || tmpExt.toLowerCase().equals("amr"))
              {
                sFileType = "ringtone";
                 iMinFileSize = Integer.parseInt(sFileSize[0]);
                 iMaxFileSize = Integer.parseInt(sFileSize[1]);
              }
              else if(tmpExt.toLowerCase().equals("mov"))
              {
                if("0".equals(zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia","0")))  //判断是否支持视频文件上传
                {
                  throw new Exception("Invalid file type!");
                }
                sFileType = "video";
                 iMinFileSize = Integer.parseInt(sFileSize[2]);
                 iMaxFileSize = Integer.parseInt(sFileSize[3]);
              }
              else if(tmpExt.toLowerCase().equals("jpg") || tmpExt.toLowerCase().equals("gif") || tmpExt.toLowerCase().equals("bmp")|| tmpExt.toLowerCase().equals("txt"))
              {
                if("0".equals(zte.zxyw50.util.CrbtUtil.getConfig("imageup","0")))   //判断是否支持图像文件上传
                {
                  throw new Exception("Invalid file type!");
                }
                sFileType = "photo";
                 iMinFileSize = Integer.parseInt(sFileSize[4]);
                 iMaxFileSize = Integer.parseInt(sFileSize[5]);
              } else if(tmpExt.toLowerCase().equals("3gp"))
              {
                if("0".equals(zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia","0")))  //判断是否支持视频文件上传
                {
                  throw new Exception("Invalid file type1!");
                }
                sFileType = "video";
                 iMinFileSize = Integer.parseInt(sFileSize[2]);
                 iMaxFileSize = Integer.parseInt(sFileSize[3]);
              }
              else
              {
                throw new Exception("Invalid file type!");
              }
            }
            catch(java.lang.NumberFormatException nex)
            {
              throw new Exception("The file which of name is db.properties have setted errors!");//db配置文件设置有误
            }
            catch(Exception ex)
            {
              throw new Exception(ex.getMessage());
            }

            if(ringFile.getSize()<iMinFileSize*1024)
            {
              throw new Exception("The "+sFileType+" file should be greater than "+iMinFileSize+"KB!");//铃音文件必须大于8KB
            }
            else if(ringFile.getSize()>iMaxFileSize*1024)  //1kb=1024b;1m=1024kb;1g=1024m;
            {
              throw new Exception("The "+sFileType+" file should be not greater than "+iMaxFileSize+"KB!");//铃音文件必须小于10MB
            }

                SocketPortocol portocol = new SocketPortocol();
                ringName = ringFile.getFileName();
                ringName = new String(ringName.getBytes(),TaoUtil.getCharset("UTF-8"));
                String fileName = (new java.util.Date()).getTime() + "." + tmpExt.toLowerCase();
                System.out.println(portocol.getTmpDir());
                System.out.println(fileName);
                System.out.println(ringFile.SAVEAS_PHYSICAL);
                ringFile.saveAs(portocol.getTmpDir() + fileName,ringFile.SAVEAS_PHYSICAL);
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
   alert('Please log in to the system first!');//Please log in to the system!
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in uploading the ringtone!");//铃音上载过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in uploading the ringtone!");//铃音上载过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="upload.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
