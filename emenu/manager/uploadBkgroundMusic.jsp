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
<title>Upload system ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
   String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");
   int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); 
   String userday = CrbtUtil.getConfig("uservalidday","0");
    String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","ringtone producer");
    ringsourcename=transferString(ringsourcename);
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ringlibid="";
    // For Karaoke Background Music ringlibid=504
     ringlibid = request.getParameter("ringlibid") == null ? "504" : (String)request.getParameter("ringlibid");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysRing sysring = new manSysRing();
	    zxyw50.Purview purview = new zxyw50.Purview();
        ColorRing colorRing = new ColorRing();
	    Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
        ArrayList rList = null;
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = sysring.getSysTime() + "--";
        String op = request.getParameter("op") == null ? null : (String)request.getParameter("op");
        int flag = 0;
        if (operID != null && purviewList.get("2-74") != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            if (op != null) {
                SocketPortocol portocol = new SocketPortocol();
                hash.put("usernumber",request.getParameter("ringlibcode") == null ? "504" : (String)request.getParameter("ringlibcode"));
                hash.put("ringtype","1");
                String ringlabel = request.getParameter("ringname") == null ? null : transferString((String)request.getParameter("ringname"));
                if(checkLen(ringlabel,40))
                	throw new Exception("The length of the ringtone name you entered has exceeded the limit. Please re-enter!");//您输入的Ringtone name长度超出限制,请重新输入!
                hash.put("ringlabel",ringlabel);
                hash.put("filename",request.getParameter("ringfile") == null ? null : transferString((String)request.getParameter("ringfile")));
                String auther = request.getParameter("ringauthor") == null ? null : transferString((String)request.getParameter("ringauthor"));
                if(checkLen(auther,40))
                	throw new Exception("The length of the singer name you entered has exceeded the limit. Please re-enter!");//您输入的Singer name长度超过限制,请重新输入!
                hash.put("auther",auther);
                String supplier = request.getParameter("ringsource") == null ? null : transferString((String)request.getParameter("ringsource"));
                if(checkLen(supplier,40))
                	throw new Exception("The length of the ringtone provider name you entered has exceeded the limit. Please re-enter!");//您输入的铃音提供商名称长度超出限制,请重新输入!
                hash.put("supplier",supplier);
                // No Price for Karaoke Background Music
			    hash.put("price","0000");
                hash.put("ringspell",request.getParameter("ringpell") == null ? null : transferString((String)request.getParameter("ringpell")));
                //begin add 用户有效期
                hash.put("uservalidday",request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday"));
                //end
                hash.put("ringid",request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid"));
                hash.put("validdate",request.getParameter("validdate") == null ? null : transferString((String)request.getParameter("validdate")));
                hash.put("opmode","1");
                hash.put("ipaddr",request.getRemoteAddr());
                hash.put("isfreewill","00");

                String preflag = "0";
                String prefilename = request.getParameter("preringfile")==null? "":request.getParameter("preringfile").trim();
                if(prefilename.length()>0)
                {
                preflag ="1";
                }
                hash.put("preflag", preflag);
                hash.put("prefilename", prefilename);
                hash.put("price2", request.getParameter("price2") == null ? "0" : (String)request.getParameter("price2"));
                String resRingID = sysring.ringUpload(pool,hash);
                sysInfo.add(sysTime + operName + "System ringtone uploaded successfully!");//上传系统铃音成功
%>
<script language="javascript">
   alert('<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> uploaded successfully!');//铃音上传成功
</script>
<%
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","202");
                map.put("RESULT","1");
                map.put("PARA1",ringlabel);
                map.put("PARA2",ringlibid);
                map.put("PARA3",auther);
                map.put("PARA4",(String)request.getParameter("validdate"));
                map.put("PARA5",(String)request.getParameter("price"));
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
      if (trim(fm.ringlibid.value) == '') {
         alert('Please select a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> library!');
         return;
      }
      if (trim(fm.ringname.value) == '') {
         alert('Please enter a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name!');//请输入Ringtone name
         fm.ringname.focus();
         return;
      }
      if (!CheckInputStr(fm.ringname,'<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name')){
         fm.ringname.focus();
         return;
      }
      if (trim(fm.ringpell.value) == '') {
         alert('Please enter the spelling of a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name');//请输入铃音拼音
         fm.ringpell.focus();
         return;
      }
      if(!CheckInputChar1(fm.ringpell,"Ringtong name's spelling")){
      	fm.ringpell.focus();
      	return;
      }
      if (trim(fm.ringauthor.value) == '') {
         alert('Please enter an <%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name');//请输入Singer name
         fm.ringauthor.focus();
         return;
      }
      if (!CheckInputStr(fm.ringauthor,'<%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name')){
         fm.ringauthor.focus();
         return;
      }
       <%
        if(ifuseutf8 == 1){
          %>
          if(!checkUTFLength(fm.ringname.value,40)){
            alert("The ringtone name should not exceed 40 bytes! ");
            fm.ringname.focus();
            return;
          }
          if(!checkUTFLength(fm.ringpell.value,20)){
            alert("The Spelling should not exceed 20 bytes! ");
            fm.ringpell.focus();
            return;
          }
          if(!checkUTFLength(fm.ringauthor.value,40)){
            alert("The Singer name should not exceed 40 bytes! ");
            fm.ringauthor.focus();
            return;
          }
        <%}%>
      var validdate = trim(fm.validdate.value);
      if(validdate==''){
          alert('Please enter an expiration date');
          fm.validdate.focus();
          return ;
      }
      if(!checkDate2(validdate)){
          alert('The expiration date entered is incorrect. Please re-enter!');
          fm.validdate.focus();
          return ;
      }
      if(checktrue2(validdate)){
          alert('The expiration date cannot be earlier than the current time. Please re-enter!');
          fm.validdate.focus();
          return ;
      }


      if(checktrueyear(validdate,'<%=expireTime%>')){
      	 alert('The expiration date cannot be later than <%=expireTime%>,please re-enter!');
          fm.validdate.focus();
          return ;
      }

    
      fm.filename.disabled = false;
      fm.op.value = 'upload';
      fm.submit();
   }

   function selectFile () {
      var fm = document.inputForm;
      var uploadURL = 'upload.jsp?isBackground=1 &ringlibid=' + fm.ringlibid.value;
      uploadRing = window.open(uploadURL,'upload','width=400, height=230');
   }

   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.ringfile.value = name;
      fm.filename.value = label;
      fm.ringname.value = label.substring(0,label.length - 4);
   }

</script>

<form name="inputForm" method="post" action="uploadBkgroundMusic.jsp">
<input type="hidden" name="ringfile" value="">
<input type="hidden" name="preringfile" value="">
<input type="hidden" name="ringlibid" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="albumid" value="">

  <table width="346"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
  <br/>
  <br/>
    <tr>
    <td valign="top" bgcolor="#FFFFFF">
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Upload BackGround Music</td>
        </tr>
      </table>
      </td>
   </tr>
   <tr>
    <td width="100%" class="table-style2">&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
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
          <td align="right">Filename</td>
          <td><input type="text" name="filename" value="" disabled class="input-style1"></td>
        </tr>
        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</td>
          <td><input type="text" name="ringname" value="" maxlength="40" class="input-style1"></td>
        </tr>
         <tr>
          <td align="right">Spelling of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
          <td><input type="text" name="ringpell" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name</td>
          <td><input type="text" name="ringauthor" value="" maxlength="40" class="input-style1"></td>
        </tr>
        <%
          String typeDisplay = "none";
        if(useringsource.equals("1"))
           typeDisplay="";
        %>
        <tr style="display:<%= typeDisplay %>">
          <td align="right"><%=ringsourcename%></td>
          <td><input type="text" name="ringsource" value="" maxlength="40" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Copyright Period of Validity(yyyy.mm.dd)</td>
          <td><input type="text" name="validdate" value="" maxlength="10" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="3">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td align="right"><img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"> &nbsp;&nbsp;</td>
                <td >&nbsp;&nbsp;&nbsp;&nbsp;<img src="button/upload.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()"></td>
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
<script language="javascript">
   document.inputForm.ringlibid.value = '<%= ringlibid %>';
</script>
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
        sysInfo.add(sysTime + operName + "Exception occurred in uploading background music!");//铃音上载过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in uploading background music!");//铃音上载过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_self">
<input type="hidden" name="historyURL" value="uploadBkgroundMusic.jsp">

</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
