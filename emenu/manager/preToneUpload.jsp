<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Upload preTone</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
   String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","ringtone producer");
    ringsourcename=transferString(ringsourcename);

    String ringID = request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid");
    String ringIndex = request.getParameter("ringindex") == null ? "" : (String)request.getParameter("ringindex");
    String ringName = request.getParameter("ringname")==null?"":transferString((String)request.getParameter("ringname"));
    String ringAuthor = request.getParameter("ringauthor")==null?"":transferString((String)request.getParameter("ringauthor"));
    String thepage = request.getParameter("page")==null?"0":(String)request.getParameter("page");

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    //modify by gequanmin 2005-07-05

    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        if (ringID.length() == 0)
            throw new Exception ("Please choose the ringtone which you want to add pretone!");
        manSysRing sysring = new manSysRing();
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = sysring.getSysTime() + "--";
        String op = request.getParameter("op") == null ? null : (String)request.getParameter("op");
        int flag = 0;
        if (operID != null && purviewList.get("2-2") != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            vet = sysring.getRingLib();
            if (op != null) {
                // 上传铃音
                SocketPortocol portocol = new SocketPortocol();
                hash.put("ringtype","1");
                hash.put("filename",request.getParameter("ringfile") == null ? null : transferString((String)request.getParameter("ringfile")));
                hash.put("ringid",request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid"));
                hash.put("ringindex",request.getParameter("ringindex") == null ? "" : (String)request.getParameter("ringindex"));
                hash.put("ipaddr",request.getRemoteAddr());
                sysring.preToneUpload(pool,hash);
                sysInfo.add(sysTime + operName + " preTone uploaded successfully!");//上传前导音成功
%>
<script language="javascript">
   alert('Pretone of ' + '<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ' + '<%=ringName%>' +' uploaded successfully!');//铃音上传成功
</script>
<%
                // 准备写操作员日志
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","233");
                map.put("RESULT","1");
                map.put("PARA1",ringID);
                map.put("PARA2",ringName);

                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
            }

%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;

      if (trim(fm.filename.value) == '') {
         alert('Please select a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> file first!');//请先选择铃音文件
         fm.ringname.focus();
         return;
      }

      fm.filename.disabled = false;
      fm.op.value = 'upload';
      fm.submit();
   }

   function selectFile () {
      var fm = document.inputForm;
      var uploadURL = 'uploadPreTone.jsp';
      uploadRing = window.open(uploadURL,'uploadpre','width=400, height=230');
   }

   function backto () {
      window.location.href='preToneManage.jsp?page=<%=thepage%>';
   }

   function selectLib () {
      var fm = document.inputForm;
      var lib = fm.ringlibid.value;
      if (lib == 501 || lib == 502 || lib == 503) {
         fm.price.value = '0';
         fm.price.disabled = true;
      }
      else
         fm.price.disabled = false;
   }

   function getPreRingName (name, label) {
      var fm = document.inputForm;
      fm.ringfile.value = name;
      fm.filename.value = label;
     // fm.ringname.value = label.substring(0,label.length - 4);
   }
</script>

<form name="inputForm" method="post" action="preToneUpload.jsp">
<input type="hidden" name="ringfile" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="page" value="<%=thepage%>">
<input type="hidden" name="ringindex" value="<%=ringIndex%>">
   <table width="346" border="0" align="center" class="table-style2">
		<tr>
                  <td height="16" >&nbsp;</td>
		</tr>
		<tr>
                 <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Upload PreTone</td>
		</tr>
                <tr>
                  <td height="16" >&nbsp;</td>
		</tr>
  </table>
  <table width="346"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
    <tr>
    <td><img src="image/004.gif" width="346" height="15"></td>
  </tr>
  <tr >
    <td background="image/006.gif">
    <table width="340" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
    <td>
      <table  border="0" align="center" class="table-style2">

                <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</td>
          <td>
           <input type="text" name="ringid" value="<%=ringID%>" maxlength="20" readonly="readonly" class="input-style1" >
          </td>
        </tr>

        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</td>
          <td><input type="text" name="ringname" value="<%=ringName%>" maxlength="40"  readonly="readonly" class="input-style1"></td>
        </tr>

        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name</td>
          <td><input type="text" name="ringauthor" value="<%=ringAuthor%>" maxlength="40" readonly="readonly" class="input-style1"></td>
        </tr>

        <tr>
          <td align="right">pretone filename</td>
          <td><input type="text" name="filename" value="" disabled class="input-style1"></td>
        </tr>

        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="30%" align="right"><img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"> &nbsp;&nbsp;</td>
                <td width="30%" >&nbsp;&nbsp;&nbsp;&nbsp;<img src="button/upload.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()"></td>
                <td width="30%" align="right"><img src="button/back.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:backto()"> &nbsp;&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      </td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td><img src="image/005.gif" width="346" height="15"></td>
  </tr>
  </table>
</form>

<%
        }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    parent.document.URL = 'enter.jsp';
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
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in uploading the pretone!");//铃音上载过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in uploading the pretone!");//铃音上载过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="preToneUpload.jsp?ringid=<%=ringID%>&ringname=<%=ringName%>&ringauthor=<%=ringAuthor%>&page=<%=thepage%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
