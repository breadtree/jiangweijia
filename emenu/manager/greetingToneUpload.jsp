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
<title>Upload greeting tone</title>
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


 String userday = CrbtUtil.getConfig("uservalidday","0");
 //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","ringtone producer");
    ringsourcename=transferString(ringsourcename);
    //add end
String useeditringid = CrbtUtil.getConfig("useeditringid","0");

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");

    String ringlibid="501"; // Shut-down Ring depot lib as greeting tone lib

    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysRing sysring = new manSysRing();
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = sysring.getSysTime() + "--";
        String op = request.getParameter("op") == null ? null : (String)request.getParameter("op");
        int flag = 0;
        if (operID != null && purviewList.get("2-30") != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            vet = sysring.getRingLib();
            if (op != null) {
                // 上传铃音
                SocketPortocol portocol = new SocketPortocol();
                hash.put("usernumber",request.getParameter("ringlibcode") == null ? null : (String)request.getParameter("ringlibcode"));
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
                hash.put("price",request.getParameter("price") == null ? null : (String)request.getParameter("price"));
                hash.put("ringspell",request.getParameter("ringpell") == null ? null : transferString((String)request.getParameter("ringpell")));
                //begin add 用户有效期
                hash.put("uservalidday",request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday"));
                //end
                hash.put("ringid",request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid"));
                hash.put("validdate",request.getParameter("validdate") == null ? null : transferString((String)request.getParameter("validdate")));
                hash.put("opmode","1");
                hash.put("ipaddr",request.getRemoteAddr());
                hash.put("isfreewill","00");

               //System.out.println("11hash="+hash);
                hash.put("greetingTone" ,"1");

               hash.put("preflag", "0");
               hash.put("prefilename", "");

                sysring.ringUpload(pool,hash);
                sysInfo.add(sysTime + operName + "Greeting Tone uploaded successfully!");//上传问候音铃音成功
%>
<script language="javascript">
   alert('Greeting Tone uploaded successfully!');//铃音上传成功
</script>
<%
                // 准备写操作员日志
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","231");
                map.put("RESULT","1");
                map.put("PARA1",ringlabel);
                map.put("PARA2",ringlibid);
                map.put("PARA3",auther);
                map.put("PARA4",(String)request.getParameter("validdate"));
                map.put("PARA5",(String)request.getParameter("price"));
                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
            }
            //Greeting Tone lib
            String Pos="Greeting Tone Lib";
            String ringlibcode="501";


%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;

      if (trim(fm.filename.value) == '') {
         alert('Please select a Greeting Tone file first!');//请先选择铃音文件
         fm.ringname.focus();
         return;
      }
      if (trim(fm.ringlibid.value) == '') {
         alert('Please select a Greeting Tone library!');
         return;
      }
      if (trim(fm.ringname.value) == '') {
         alert('Please enter a Greeting Tone name!');//请输入Ringtone name
         fm.ringname.focus();
         return;
      }
      if (!CheckInputStr(fm.ringname,'Greeting Tone name')){
         fm.ringname.focus();
         return;
      }
      if (trim(fm.ringpell.value) == '') {
         alert('Please enter the spelling of a Greeting Tone name');//请输入铃音拼音
         fm.ringpell.focus();
         return;
      }
      if(!CheckInputChar1(fm.ringpell,"Greeting Tone name's spelling")){
      	fm.ringpell.focus();
      	return;
      }
      if (trim(fm.ringauthor.value) == '') {
         alert('Please enter an singer name');//请输入Singer name
         fm.ringauthor.focus();
         return;
      }
      if (!CheckInputStr(fm.ringauthor,'singer name')){
         fm.ringauthor.focus();
         return;
      }

      var tmp = trim(fm.price.value);
      if ( tmp == '') {
         alert('Please enter a price');//请输入铃音价格
         fm.price.focus();
         return ;
      }
      if (!checkstring('0123456789',tmp)) {
         alert('Greeting Tone price can only be a digital number!');//铃音价格只能为数字
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
      	 alert('The expiration date cannot be later than <%=expireTime%>,please re-enter!');
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
      var uploadURL = 'uploadTone.jsp?ringlibid=' + fm.ringlibid.value;
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

<form name="inputForm" method="post" action="greetingToneUpload.jsp">
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
                <%if(useeditringid.equalsIgnoreCase("1")){%>
                <tr>
          <td align="right">Ringtone ID</td>
          <td>
           <input type="text" name="ringid" value="" maxlength="20" class="input-style1" >
          </td>
        </tr>
        <%}%>
       <tr valign="top">
          <td align="right">Greeting Tone library</td>
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
          <td align="right">Greeting Tone name</td>
          <td><input type="text" name="ringname" value="" maxlength="40" class="input-style1"></td>
        </tr>
         <tr>
          <td align="right">Spelling of Greeting Tone</td>
          <td><input type="text" name="ringpell" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Singer name</td>
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
          <td align="right">Greeting Tone price (<%=minorcurrency%>)</td>
          <td><input type="text" name="price" value="" maxlength="4" class="input-style1"></td>
        </tr>
        <%//begin add 用户有效期
        if(userday.equalsIgnoreCase("1")){
        %>
        <tr>
          <td align="right">Period of Validity(day)</td>
          <td><input type="text" name="uservalidday" value="0" maxlength="4" class="input-style1"></td>
        </tr>
        <%}//end%>
        <tr>
          <td align="right">Copyright Period of Validity(yyyy.mm.dd)</td>
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
        sysInfo.add(sysTime + operName + "Exception occurred in uploading the Greeting Tone!");//铃音上载过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in uploading the Greeting Tone!");//铃音上载过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="greetingToneUpload.html">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
