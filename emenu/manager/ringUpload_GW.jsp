<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
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
	//String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
 	String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");

     //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
     String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","ringtone producer");
    ringsourcename=transferString(ringsourcename);
    //add end
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
     //modify by gequanmin 2005-07-05
    String ringlibid="";
     if("1".equals(usedefaultringlib)){
        ringlibid = request.getParameter("ringlibid") == null ? "503" : (String)request.getParameter("ringlibid");
    }else{
       ringlibid = request.getParameter("ringlibid") == null ? "" : (String)request.getParameter("ringlibid");
    }
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
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
                hash.put("ringid",request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid"));
                hash.put("usernumber",request.getParameter("ringlibcode") == null ? null : (String)request.getParameter("ringlibcode"));
                hash.put("ringtype","1");
                String ringlabel = request.getParameter("ringname") == null ? null : transferString((String)request.getParameter("ringname"));
                if(checkLen(ringlabel,40))
                	throw new Exception("The length of the ringtone name you entered has exceeded the limit. Please re-enter!");//您输入的Ringtone name长度超出限制,请重新输入!
                hash.put("ringlabel",ringlabel);
                hash.put("filename",request.getParameter("ringfile") == null ? null : transferString((String)request.getParameter("ringfile")));
                String auther = request.getParameter("ringauthor") == null ? null : transferString((String)request.getParameter("ringauthor"));
                if(checkLen(auther,40))
                	throw new Exception("The length of the singer name you entered has exceeded the limit. Please re-enter!");//您输入的singer name长度超过限制,请重新输入!
                hash.put("auther",auther);
                String supplier = request.getParameter("ringsource") == null ? null : transferString((String)request.getParameter("ringsource"));
                if(checkLen(supplier,40))
                	throw new Exception("The length of the ringtone provider name you entered has exceeded the limit. Please re-enter!");//您输入的铃音提供商名称长度超出限制,请重新输入!
                hash.put("supplier",supplier);
                hash.put("price",request.getParameter("price") == null ? null : (String)request.getParameter("price"));
                hash.put("ringspell",request.getParameter("ringpell") == null ? null : transferString((String)request.getParameter("ringpell")));
                hash.put("validdate",request.getParameter("validdate") == null ? null : transferString((String)request.getParameter("validdate")));
                hash.put("opmode","1");
			    hash.put("ipaddr",request.getRemoteAddr());
               //System.out.println("11hash="+hash);
                sysring.ringUpload_GW(pool,hash);
                sysInfo.add(sysTime + operName + " upload system ringtone successfully!");
%>
<script language="javascript">
   alert('Ringtone uploaded successfully!');//铃音上传成功
</script>
<%
                // 准备写操作员日志
                zxyw50.Purview purview = new zxyw50.Purview();
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
                map.put("PARA6","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
            }
            //modify by gequanmin 2005-07-05
            String Pos="";
            String ringlibcode="";
            if("1".equals(usedefaultringlib)){
               Pos= "Default ringtone library";
               ringlibcode = "503";
            }
            if((ringlibid!=null) &&(!ringlibid.equals(""))){
            Hashtable hLib=  sysring.getRingLibraryNode(ringlibid);
            if(hLib!=null && hLib.size()>0){
                Pos = (String)hLib.get("ringliblabel");
                ringlibcode = (String)hLib.get("ringlibcode");
            }
            }

%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
      if (trim(fm.filename.value) == '') {
         alert('Please select a ringtone file first!');//请先选择铃音文件
         fm.ringname.focus();
         return;
      }
      if (trim(fm.ringlibid.value) == '') {
         alert('Please select a ringtone library!');
         return;
      }
      if (trim(fm.ringname.value) == '') {
         alert('Please enter a ringtone name!');//请输入Ringtone name
         fm.ringname.focus();
         return;
      }
      if (!CheckInputStr(fm.ringname,'Ringtone name')){
         fm.ringname.focus();
         return;
      }
      if (trim(fm.ringid.value) == '') {
         alert("Please enter the ID of ringtone");
         fm.ringpell.focus();
         return;
      }
      if (trim(fm.ringpell.value) == '') {
         alert('Please enter the spelling of a ringtone name');//请输入铃音拼音
         fm.ringpell.focus();
         return;
      }
      if(!CheckInputChar1(fm.ringpell,'spelling of ringtone')){
      	fm.ringpell.focus();
      	return;
      }
      if (trim(fm.ringauthor.value) == '') {
         alert('Please enter an singer name');//请输入Singer name
         fm.ringauthor.focus();
         return;
      }
      if (!CheckInputStr(fm.ringauthor,'Singer name')){
         fm.ringauthor.focus();
         return;
      }
       //modify by ge quanmin 2005-07-07
      <%if(useringsource.equals("1")){%>
       if (trim(fm.ringsource.value) == '') {
         alert('Please input ringtone producer name!');//请输入ringtone producer名称!
         fm.ringsource.focus();
         return;
      }
      if (!CheckInputStr(fm.ringsource,'ringtone producer')){
         fm.ringsource.focus();
         return;
      }
     <%}%>

      var tmp = trim(fm.price.value);
      if ( tmp == '') {
         alert('Please enter a price');//请输入铃音价格
         fm.price.focus();
         return ;
      }
      if (!checkstring('0123456789',tmp)) {
         alert('Ringtone price can only be a digital number!');//铃音价格只能为数字
         fm.price.focus();
         return ;
      }
      var validdate = trim(fm.validdate.value);
      if(validdate==''){
          alert('Please enter an expiration date');//请输入铃音有效期
          fm.validdate.focus();
          return ;
      }
      if(!checkDate2(validdate)){
          alert('The expiration date entered is incorrect. Please re-enter!');//铃音有效期输入不正确,请重新输入
          fm.validdate.focus();
          return ;
      }
      if(checktrue2(validdate)){
          alert('The expiration date cannot be earlier than the current time. Please re-enter!');//铃音有效期不能低于当前时间,请重新输入
          fm.validdate.focus();
          return ;
      }

      if(checktrueyear(validdate,'<%=expireTime%>')){
         alert('The expiration date cannot be later than the <%=expireTime%>. Please re-enter!');//铃音有效期不能大于2099.12.31,请重新输入
          fm.validdate.focus();
          return ;
      }
      fm.ringlibcode.disabled = false;
      fm.filename.disabled = false;
      fm.price.disabled = false;
      fm.op.value = 'upload';
      fm.submit();
   }

   function selectFile () {
      var fm = document.inputForm;
      var uploadURL = 'upload.jsp?ringlibid=' + fm.ringlibid.value;
      uploadRing = window.open(uploadURL,'upload','width=400, height=200');
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

   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.ringfile.value = name;
      fm.filename.value = label;
      fm.ringname.value = label.substring(0,label.length - 4);
   }
</script>

<form name="inputForm" method="post" action="ringUpload.jsp">
<input type="hidden" name="ringfile" value="">
<input type="hidden" name="ringlibid" value="<%= ringlibid %>">
<input type="hidden" name="op" value="">
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
       <tr valign="top">
          <td align="right">Ringtone library</td>
          <td>
           <input type="text" name="ringlibname" value="<%= Pos %>" maxlength="40" class="input-style1" disabled>
          </td>
        </tr>
        <tr>
          <td align="right">Category code</td>
          <td><input type="text" name="ringlibcode" value="<%= ringlibcode %>" disabled class="input-style1" ></td>
        </tr>
        <tr>
          <td align="right">Filename</td>
          <td><input type="text" name="filename" value="" disabled class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Ringtone ID</td>
          <td><input type="text" name="ringid" value="" maxlength="40" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Ringtone name</td>
          <td><input type="text" name="ringname" value="" maxlength="40" class="input-style1"></td>
        </tr>
         <tr>
          <td align="right">Spelling of ringtone</td>
          <td><input type="text" name="ringpell" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Singer name</td>
          <td><input type="text" name="ringauthor" value="" maxlength="40" class="input-style1"></td>
        </tr>
         <%if(useringsource.equals("1")){//modify by ge quanmin 2005-07-07%%>
         <tr>
           <td align="right">Ringtone provider</td>
           <td><input type="text" name="ringsource" value="" maxlength="40" class="input-style1"></td>
         </tr>
        <%}%>
        <tr>
          <td align="right">Ringtone price (<%=minorcurrency%>)</td>
          <td><input type="text" name="price" value="" maxlength="5" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Period of Validity(yyyy.mm.dd)</td>
          <td><input type="text" name="validdate" value="" maxlength="10" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="right"><img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"> &nbsp;&nbsp;</td>
                <td width="50%" >&nbsp;&nbsp;&nbsp;&nbsp;<img src="button/upload.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()"></td>
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
   selectLib();
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
        sysInfo.add(sysTime + operName + "Exception occurred in uploading the ringtone!");//铃音上载过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in uploading the ringtone!");//铃音上载过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="ringUpload.html">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
