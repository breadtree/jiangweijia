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
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ringlibid = request.getParameter("ringlibid") == null ? "503" : (String)request.getParameter("ringlibid");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String currencySmall = zxyw50.CrbtUtil.getConfig("minorcurrency","paise");

    String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");

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
                hash.put("usernumber",request.getParameter("ringlibcode") == null ? null : (String)request.getParameter("ringlibcode"));
                hash.put("ringtype","1");
                String ringlabel = request.getParameter("ringname") == null ? "" : transferString((String)request.getParameter("ringname"));
                if(checkLen(ringlabel,40))
                	throw new Exception("The length of the ringtone name you entered has exceeded the limit. Please re-enter!");//您输入的铃音名称长度超出限制，请重新输入！
                if(ringlabel.length()==0)ringlabel="None";
                hash.put("ringlabel",ringlabel);
                hash.put("filename",operName + "_mix.wav");
                String auther = request.getParameter("ringauthor") == null ? "" : transferString((String)request.getParameter("ringauthor"));
                if(checkLen(auther,40))
                	throw new Exception("The length of the artist name you entered has exceeded the limit. Please re-enter!");//您输入的歌手名称长度超过限制，请重新输入！
                if(auther.length()==0)auther="None";
                hash.put("auther",auther);
                String supplier = request.getParameter("ringsource") == null ? "" : transferString((String)request.getParameter("ringsource"));
                if(checkLen(supplier,40))
                	throw new Exception("The length of the ringtone provider name you entered has exceeded the limit. Please re-enter!");//您输入的铃音提供商名称长度超出限制，请重新输入！
                if(supplier.length()==0)
                  supplier="None";
                hash.put("supplier",supplier);
                hash.put("price",request.getParameter("price") == null ? "0" : (String)request.getParameter("price"));
                hash.put("ringspell",request.getParameter("ringpell") == null ? " " : transferString((String)request.getParameter("ringpell")));
                hash.put("validdate",request.getParameter("validdate") == null ? "2059.01.01" : transferString((String)request.getParameter("validdate")));
                hash.put("opmode","1");
                hash.put("ipaddr",request.getRemoteAddr());
                hash.put("ringid","");
                hash.put("spcode","000");
                hash.put("uservalidday","0");
                hash.put("isfreewill","00");

                hash.put("preflag", "0");
                hash.put("prefilename", "");
               //System.out.println("11hash="+hash);
                String ringid = sysring.ringUpload(pool,hash);
                sysInfo.add(sysTime + operName + "System ringtone uploaded successfully!");//上传系统铃音成功
                Hashtable tt = new Hashtable();
                tt.put("ringid",ringid);
                tt.put("mixflag","1");
                new userAdm().setRingMix(tt);
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
                map.put("OPERTYPE","228");
                map.put("RESULT","1");
                map.put("PARA1",ringlabel);
                map.put("PARA2",ringlibid);
                map.put("PARA3",auther);
                map.put("PARA4",(String)request.getParameter("validdate"));
                map.put("PARA5",(String)request.getParameter("price"));
                purview.writeLog(map);
            }
            String Pos = "Default " + zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" library";
            String ringlibcode = "503";
            Hashtable hLib=  sysring.getRingLibraryNode(ringlibid);
            if(hLib!=null && hLib.size()>0){
                Pos = (String)hLib.get("ringliblabel");
                ringlibcode = (String)hLib.get("ringlibcode");
            }

%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
      if (trim(fm.ringlibid.value) == '') {
         alert('Please select a ringtone library!');
         return;
      }
      if (trim(fm.ringname.value) == '') {
         alert('Please enter a ringtone name!');//请输入铃音名称
         fm.ringname.focus();
         return;
      }
      if (!CheckInputStr(fm.ringname,'Ringtone name')){
         fm.ringname.focus();
         return;
      }
      if (trim(fm.ringpell.value) == '') {
         alert('Please enter the spelling of a ringtone name');//请输入铃音拼音
         fm.ringpell.focus();
         return;
      }
      if(!CheckInputChar1(fm.ringpell,"Ringtong name's spelling")){
      	fm.ringpell.focus();
      	return;
      }
      if (trim(fm.ringauthor.value) == '') {
         alert('Please enter an artist name');//请输入歌手名称
         fm.ringauthor.focus();
         return;
      }
      if (!CheckInputStr(fm.ringauthor,'artist name')){
         fm.ringauthor.focus();
         return;
      }
      if (!CheckInputStr(fm.ringsource,'Provider')){
         fm.ringsource.focus();
         return;
      }

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
          alert('The expiration date entered is incorrect. Please re-enter!');//铃音有效期输入不正确，请重新输入
          fm.validdate.focus();
          return ;
      }
      if(checktrue2(validdate)){
          alert('The expiration date cannot be earlier than the current time. Please re-enter!');//铃音有效期不能低于当前时间，请重新输入
          fm.validdate.focus();
          return ;
      }
       //add by gequanmin 2005.06.30
        if(checktrueyear(validdate,'<%=expireTime%>')){
         alert('The expiration date cannot be latter than <%=expireTime%>, please re-enter!');
          fm.validdate.focus();
          return ;
      }
      fm.ringlibcode.disabled = false;
      fm.price.disabled = false;
      fm.op.value = 'upload';
      fm.submit();
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
      fm.ringname.value = label.substring(0,label.length - 4);
   }
</script>

<form name="inputForm" method="post" action="ringUploadMix.jsp">
<input type="hidden" name="ringfile" value="">
<input type="hidden" name="ringlibid" value="<%= ringlibid %>">
<input type="hidden" name="op" value="">
  <table width="336"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
    <tr>
    <td><img src="image/004.gif" width="346" height="15"></td>
  </tr>
  <tr >
    <td background="image/006.gif">
    <table width="336" border="0" align="center" cellpadding="0" cellspacing="0">
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
          <td align="right">Ringtone name</td>
          <td><input type="text" name="ringname" value="" maxlength="40" class="input-style1"></td>
        </tr>
         <tr>
          <td align="right">Spelling of ringtone</td>
          <td><input type="text" name="ringpell" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Artist name</td>
          <td><input type="text" name="ringauthor" value="" maxlength="40" class="input-style1"></td>
        </tr>
        <tr  style="display:none" >
          <td align="right">Ringtone provider</td>
          <td><input type="text" name="ringsource" value="" maxlength="40" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Ringtone price (<%=currencySmall%>)</td>
          <td><input type="text" name="price" value="" maxlength="5" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Period of Validity<br>(yyyy.mm.dd)</td>
          <td><input type="text" name="validdate" value="" maxlength="10" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2" align="center">
            <img src="../image/ring03.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()">
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
                    alert( "Please log in to the system first!");//请先登录系统
                    parent.document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//对不起，您没有权限操作该功能！
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in uploading the ringtone!");//铃音上载过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in uploading the ringtone!");//铃音上载过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="mixtune.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
