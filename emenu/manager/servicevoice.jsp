<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="com.zte.zxywpub.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="zxyw50.SpManage" scope="page" />
<jsp:setProperty name="db" property="*" />
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<title>Service ringtone maintenance</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
String sysTime = "";
Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
String operID = (String)session.getAttribute("OPERID");
String operName = (String)session.getAttribute("OPERNAME");
Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
String ivrservicekey=CrbtUtil.getConfig("ivrservicekey","51");
try {
  manSysRing sysring = new manSysRing();
  sysTime = sysring.getSysTime() + "--";
  String op = request.getParameter("op") == null ? null : (String)request.getParameter("op");
  int flag = 0;
  String errMsg="";
  boolean alertflag=false;
  if (purviewList.get("2-26") == null)  {
    errMsg = "You have no access to this function!";//无权访问此功能!
    alertflag=true;
  }
  else if (operID != null) {
    Vector vet = new Vector();
    Hashtable hash = new Hashtable();
    if (op != null) {
      SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
      String filename = request.getParameter("ringfile") == null ? "" : transferString((String)request.getParameter("ringfile"));
      String crid = request.getParameter("crid") == null ? "" : transferString((String)request.getParameter("crid"));
      //业务键
      String sServicekey=request.getParameter("servicekeytext") == null ? "" : transferString((String)request.getParameter("servicekeytext"));
      hash.put("servicekey",sServicekey);
      hash.put("crid",crid);
      hash.put("ringindex","");
      hash.put("filename",filename);
      sysring.voiceReplace(pool,hash);
      sysInfo.add(sysTime + operName + " replace the service tone" + crid + " successfully!");
%>
<script language="javascript">
   alert('The service tone is replaced successfully!');
</script>
<%
// 准备写操作员日志
zxyw50.Purview purview = new zxyw50.Purview();
HashMap map = new HashMap();
map.put("OPERID",operID);
map.put("OPERNAME",operName);
map.put("OPERTYPE","226");
map.put("RESULT","1");
map.put("PARA1",crid);
map.put("PARA2",filename);
map.put("PARA3",sServicekey);
map.put("PARA4","ip:"+request.getRemoteAddr());
purview.writeLog(map);
}
%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
        if(fm.ischeck[0].checked){
          fm.servicekeytext.value = fm.opertype.value;
      } else {
          var value = trim(fm.servicekey.value);
          if(value == ''){
              alert("Please input the service key!");
              fm.servicekey.focus();
              return false;
          }
        if(!checkstring('0123456789',value)){
             alert('The service key must be in the digit format');
             fm.servicekey.focus();
             return false;
        }
          if(strlength(value)>3){
              alert("he service key should not exceed three bytes. Please re-enter!");
              fm.servicekey.focus();
              return false;
          }
          fm.servicekeytext.value = fm.servicekey.value;
      }

      if(trim(fm.crid.value) == ''){
         alert('Please input the service ringtone ID to be replaced!');
         fm.crid.focus();
         return;
      }
        var value = trim(fm.crid.value);
        if (!checkstring('0123456789',value)) {
         alert('The service ringtone ID must be a digit!');//业务语音号必须是数字!
         fm.crid.focus();
         return;
      }
      var temp =trim(fm.opertype.value);
      if(temp=='51'||temp=='52'){
        if(value>=2000){
         alert('The standard IVR service ringtone ID should not exceed 2000!');//标准IVR业务语音号不能大于2000!
         return;
        }
      }
       if (trim(fm.filename.value) == '') {
         alert('Please select the tone file to be replaced!');
         return;
      }

    if (! confirm('This operation is used to directly replace the content of the service voice number. Please confirm that the selected service key and ringtone ID are correct completely!'))//该操作直接更换业务语音号的内容,所以请确认你选择的业务键和音号完全正确!
         return;
      fm.op.value = 'replace';
      fm.submit();
   }

   function selectFile () {
      var fm = document.inputForm;
      var uploadURL = 'voiceupload.jsp';
      uploadRing = window.open(uploadURL,'upload','width=400, height=200');
   }

     function OnRadioCheck(){
      var fm = document.inputForm;
      if(fm.ischeck[0].checked){
          id_text.style.display = 'none';
          id_select.style.display = 'block';
      }
      else{
          id_text.style.display = 'block';
          id_select.style.display = 'none';
      }
   }

     function getRingName (name, label) {
      var fm = document.inputForm;
      fm.ringfile.value = name;
      fm.filename.value = label;
   }
</script>
<form name="inputForm" method="post" action="servicevoice.jsp">
<input type="hidden" name="ringfile" value="">
<input type="hidden" name="servicekeytext" value="">

<input type="hidden" name="op" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Service ringtone maintenance </td>
        </tr>
        <tr></tr>
         <tr></tr>
          <tr></tr>
        <tr>
             <td width="30%" align=right>Service key:</td>
               <td width="35%">
                <input type="radio" checked name="ischeck" value="0" onclick="OnRadioCheck()" checked >Select from the list
                <input type="radio" name="ischeck" value="1" onclick="OnRadioCheck()" >Manually input
              </td>
         <td width="20%" style='display:block' id="id_select" >
              <select name="opertype" size="1"  class="input-style1">
             <%
             out.println("<option value=194 >Fast order service</option>");
             out.println("<option value="+ivrservicekey+">Standard IVR servic</option>");
             %>
           </select>
             </td>
             <td width="20%" style="display:none" id="id_text" ><input type="text" name="servicekey" maxlength="4" value="" style="input-style1" ></td>
            </tr>
        <tr>
          <td></td>
          <td align="right">Replacement voice number</td>
          <td><input type="text" name="crid" value="" maxlength="10" class="input-style0" ></td>
        </tr>
         <tr>
          <td></td>
          <td align="right">Replacement voice file</td>
          <td><input type="text" name="filename" value="" disabled class="input-style0"></td>
        </tr>
         <tr>
         <tr>
         <td></td>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="right"><img src="../button/file.gif" width="45" height="19" onclick="javascript:selectFile()" onmouseover="this.style.cursor='hand'"> &nbsp;&nbsp;</td>
                <td width="50%" >&nbsp;&nbsp;&nbsp;&nbsp;<img src="../button/replace.gif" width="45" height="19" onclick="javascript:upload()" onmouseover="this.style.cursor='hand'"></td>
              </tr>
            </table>
          </td>
        </tr>
               <tr >
          <td height="26" colspan="3" >
           <table border="0" width="100%" class="table-style2">
              <tr>
               <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Notes:</td>
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.The service key of the IVR voice is determined according to the actual service of the service voice script. If you have any question, please ask relevant personnel.</td>
              </tr>
               <tr>
               <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.Before the replacement, please confirm the correctness of the tone number and the content in the IVR flow. If you have any question, please ask relevant personnel.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
       </table>
    </td>
    </tr>
    </table>
</form>
<%
        }
        else {
        errMsg = "Please log in to the system first!";
        alertflag=true;
        }if(alertflag==true){
%>
<script language="javascript">
   var errorMsg = '<%= operID!=null?errMsg:"Please log in to the system first!"%>';
   alert(errorMsg);
   parent.document.URL = 'enter.jsp';
</script>
<%  }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "It is abnormal during the service tone replacement!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the service tone replacement!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="servicevoice.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
