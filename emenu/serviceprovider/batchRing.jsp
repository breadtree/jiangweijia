<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.zxywpub.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Batch uploading ringtone</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body background="background.gif" class="body-style1">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String spcode = (String)session.getAttribute("SPCODE");
    String spIndex = (String)session.getAttribute("SPINDEX");
    String operName = (String)session.getAttribute("OPERNAME");
    String listfile = request.getParameter("listfile") == null ? "" : (String)request.getParameter("listfile");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        ColorRing colorRing = new ColorRing();
        ArrayList rList = null;
        UploadRing uploadRing = new UploadRing();
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        int order = request.getParameter("order") == null ? -1 : Integer.parseInt((String)request.getParameter("order"));
        int flag = 0;
        if (operID != null && purviewList.get("9-8")!= null) {
            if(spcode == null || spcode.equals("")) {
               throw new Exception("Sorry, you are not manager!");
			}

            zxyw50.Purview purview = new zxyw50.Purview();
            Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
	        String ringablealias1 = CrbtUtil.getConfig("ringablealias1","0");
    	    String ringablealias2 = CrbtUtil.getConfig("ringablealias2","0");
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            // 第一次打开批量上传界面
            if (order == -1) {
%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
      if ((fm.listfile.value).length == '') {
         alert("Please select the file first!");
         return;
      }
      fm.order.value = '0';
      fm.submit();
   }

   function selectFile () {
      var fm = document.inputForm;
      var uploadURL = 'batchUpload.jsp';
      uploadRing = window.open(uploadURL,'upload','width=400, height=200');
   }

   function getListName (name, label) {
      var fm = document.inputForm;
      fm.listfile.value = name;
      fm.filename.value = label;
   }
</script>

<form name="inputForm" method="post" action="batchRing.jsp">
<input type="hidden" name="listfile" value="">
<input type="hidden" name="order" value="0">
<table border="0" height="400" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr background="../manager/image/n-9.gif">
          <td height="26" colspan="2" align="center" class="text-title"background="../manager/image/n-9.gif">Batch uploading <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
        </tr>
        <tr>
          <td height="22" align="right">Filename:</td>
          <td height="22"><input type="text" name="filename" value="" disabled class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="center"><img src="../manager/button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"></td>
                <td width="50%" align="center"><img src="../manager/button/upload.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()"></td>
              </tr>
            </table>          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%
            }
            // 第一次上传
            else if (order == 0) {
                if (listfile.length() > 0)
                     if(listfile.endsWith(".lst")){
                    vet = uploadRing.analyseList(listfile,request.getRemoteAddr(),spcode,spIndex);
                    }else{
                      vet = uploadRing.analyseListbySeparator(listfile,request.getRemoteAddr(),spcode,spIndex);
                    }

                java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
                String fileName = formatter.format(new java.util.Date()) + ".log";
                //SocketPool poolt = new SocketPool();
                //System.out.println("启动批量上传池……");
                SocketPortocol poto = new SocketPortocol();
                //poto.init(poolt);
                session.setAttribute("RINGINFO",vet);
                session.setAttribute("LOGFILE",fileName);
                session.setAttribute("BATCHPOOL",pool);
%>

<form name="inputForm" method="post" action="batchRing.jsp">
<input type="hidden" name="order" value="<%= (order + 1) + "" %>">
<table border="0" height="100%" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td align="center" class="text-title">Now is uploading the <%= (order + 1) + "" %> ringtone......</td>
        </tr>
        <tr>
          <td align="center" class="text-title">Name of list file is <%= fileName %></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<script language="javascript">
   document.inputForm.submit();
</script>
<%
            }
            else {
                String fileName = (String)session.getAttribute("LOGFILE");
                vet = (Vector)session.getAttribute("RINGINFO");
                SocketPool poolt = (SocketPool)session.getAttribute("BATCHPOOL");
                if (order <= vet.size()) {
                 //System.out.println("order:"+order);
 %>
<form name="inputForm" method="post" action="batchRing.jsp">
<input type="hidden" name="order" value="<%= (order + 1) + "" %>">
<table border="0" height="100%" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td align="center" class="text-title">Now is uploading the <%= order + "" %> ringtone......</td>
        </tr>
        <tr>
          <td align="center" class="text-title">Name of list file is <%= fileName %></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%
                    hash = (Hashtable)vet.get(order - 1);
					//System.out.println("HASH VALUES-------------->"+hash);
					String sTotalCnt=hash.get("totalcnt")==null?"0":(String)hash.get("totalcnt");
					//System.out.println("sTotalCnt------------->"+sTotalCnt);
					int iTotalCnt=0;
					iTotalCnt=Integer.parseInt(sTotalCnt);
                                        Hashtable receive = null;
				if(iTotalCnt!=16) {					
                    try {
                          receive = SocketPortocol.send(poolt,hash);
                        hash.put("result","Upload ringtone finished!");
                        hash.put("resultcode","1");
                    }
                    catch (Exception e) {
                        hash.put("result",e.getMessage());
                        hash.put("resultcode","0");
                    }
                    uploadRing.writeLog(fileName,hash);

		if(sysfunction.get("2-66-0")== null ) {
		         try
                    {
					    String resRingID =  receive.get("crid")==null ? "" : receive.get("crid").toString().trim();
						//System.out.println("resRingID====in SP batchRing.jsp================> "+resRingID); // to-do remove
						if(resRingID.equals("")) { 
							throw new Exception(" Error:additional ringtone information not updted for this ringid");
					   }
						hash.put("extraringid",resRingID);
					    hash.put("extraRingOpcode", "1"); // 1 - add - opCode
						hash.put("opflag", "3"); // opFlag
						hash.put("ringlabel", hash.get("ringname")==null?"":(String)hash.get("ringname"));

						rList = colorRing.updateExtraRingInformation(hash);
					    sysInfo.add(sysTime + operName + "Extra ringtone information modified successfully!");
					    String msg = JspUtil.generateResultList(rList);
					    if(!msg.equals("")){
					      msg = msg.replace('\n',' ');
					      throw new Exception(msg);
					    }
                    }
                    catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
		}
	  }else if(sysfunction.get("2-66-0")== null && iTotalCnt == 16 ){
		try {
			String sRingID=(String)hash.get("ringid");
			hash.put("extraringid",sRingID);
			hash.put("extraRingOpcode", "3"); // 1 - edit - opCode
			hash.put("opflag", "3"); // opFlag
			hash.put("ringlabel", hash.get("ringname")==null?"":(String)hash.get("ringname"));
			rList = colorRing.updateExtraRingInformation(hash);
			Hashtable aHash=(Hashtable)rList.get(0);
			//System.out.println("aHash values----------->"+aHash);
			String sResult="";
			if(aHash!=null) {
				sResult=(String)aHash.get("result");
			}
			//System.out.println("sResult--->"+sResult);
            if(getResultFlag(rList)) {
				hash.put("result","Ringtone updated sucessfully");
				hash.put("resultcode",sResult);
			}else{
				hash.put("result",sResult);
				hash.put("resultcode",sResult);
			}
			try {    
               uploadRing.writeRingUpdateLog(fileName,hash);
            } catch (Exception e) {
               hash.put("result",e.getMessage());
               hash.put("resultcode","1");
            }  
			sysInfo.add(sysTime + operName + "Extra ringtone information modified successfully!");
			String msg = JspUtil.generateResultList(rList);
			if(!msg.equals("")){
				msg = msg.replace('\n',' ');
				throw new Exception(msg);
			}
		  }catch (Exception e) {
            System.out.println(e.getMessage());
          }
	  }

%>
<script language="javascript">
   document.inputForm.submit();
</script>
<%
                }
                else {
                    session.removeAttribute("RINGINFO");
                    session.removeAttribute("LOGFILE");
                    session.removeAttribute("BATCHPOOL");
%>
<form name="inputForm" method="post" action="batchRing.jsp">
<input type="hidden" name="order" value="-1">
<table border="0" height="100%" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td align="center" class="text-title">Batch upload ringtone finished</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<script language="javascript">
   document.inputForm.submit();
</script>
<%
                }
            }
        }
        else {
             if(operID== null){
              %>
              <script language="javascript">
                    alert( "Please log in first!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no right to access this function!");
              </script>
              <%

                   }
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in uploading ringtone!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Errors occurred in uploading ringtone!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="batchRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
