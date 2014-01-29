<%@ page import="java.util.HashMap" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.ywaccess" %>


<%@ include file="../pubfun/JavaFun.jsp" %>

<%!
//转换单引号和反斜杠,注意javascript中\要转换为\\，而java中用\\表示\。
//javascript中的单引号要转换为\'。
public String transferDYH (String str){
    if(str==null)
        return "";
    else
        return str.replaceAll("\\\\","\\\\\\\\").replaceAll("'","\\\\'");
}
%>


<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>SP Management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    ywaccess ywAcc = new ywaccess();
    int startTime = ywAcc.getParameter(15);
    int endTime   = ywAcc.getParameter(16);
    String sysTime = "";
     //add by gequanmin 2005-08-11 for version 3.19.01
     int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
    String usediscount = CrbtUtil.getConfig("usediscount","0");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String SPCODE_LEN = session.getAttribute("SPCODELEN")==null?"3":(String)session.getAttribute("SPCODELEN");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    int rightsize=19;
    int leftsize=28;
    if("1".equals(usediscount)){
      rightsize=20;
      leftsize=32;
    }
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
      int stopDate = Integer.parseInt(sysTime.substring(11,13));
        if (operID != null && purviewList.get("3-3") != null) {
            ArrayList vet = new ArrayList();
            Hashtable hash = new Hashtable();
            ArrayList rList  = new ArrayList();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String spcode = request.getParameter("spcode") == null ? "" : transferString((String)request.getParameter("spcode")).trim();
            String maxnumber = request.getParameter("maxnumber") == null ? "" : transferString((String)request.getParameter("maxnumber")).trim();
            String spname = request.getParameter("spname") == null ? "" : transferString((String)request.getParameter("spname")).trim();
            if(checkLen(spname,36))
            	throw new Exception("The length of the SP name you entered has exceeded the limit. Please re-enter!");
            String ischeck = request.getParameter("ischeck") == null ? "" : transferString((String)request.getParameter("ischeck")).trim();
            String spcent = request.getParameter("spcent") == null ? "0" : transferString((String)request.getParameter("spcent")).trim();
            String spindex = request.getParameter("spindex") == null ? "" : transferString((String)request.getParameter("spindex")).trim();
            String url = request.getParameter("url") == null ? "" : transferString((String)request.getParameter("url")).trim();
            if(checkLen(url,100))
            	throw new Exception("The length of the website address you entered has exceeded the limit. Please re-enter!");

String corpname = request.getParameter("corpname") == null ? "" : transferString((String)request.getParameter("corpname")).trim();
String faxnumber = request.getParameter("faxnumber") == null ? "" : transferString((String)request.getParameter("faxnumber")).trim();
String phonenumber = request.getParameter("phonenumber") == null ? "" : transferString((String)request.getParameter("phonenumber")).trim();
String postno = request.getParameter("postno") == null ? "" : transferString((String)request.getParameter("postno")).trim();
String linkman = request.getParameter("linkman") == null ? "" : transferString((String)request.getParameter("linkman")).trim();
String customer = request.getParameter("customer") == null ? "" : transferString((String)request.getParameter("customer")).trim();
String corpaddress = request.getParameter("corpaddress") == null ? "" : transferString((String)request.getParameter("corpaddress")).trim();
String isopcheck = request.getParameter("isopcheck") == null ? "" : transferString((String)request.getParameter("isopcheck")).trim();
String ifextra = request.getParameter("ifextra") == null ? "0" : transferString((String)request.getParameter("ifextra")).trim();
if(ifextra.trim().equalsIgnoreCase(""))
   ifextra = "0";
String extraspcode = request.getParameter("extraspcode") == null ? "" : transferString((String)request.getParameter("extraspcode")).trim();
String spstate = request.getParameter("spstate") == null ? "" : transferString((String)request.getParameter("spstate")).trim();
String discountcheck = request.getParameter("discountcheck") == null ? "" : transferString((String)request.getParameter("discountcheck")).trim();
String discountopercheck = request.getParameter("discountopercheck") == null ? "" : transferString((String)request.getParameter("discountopercheck")).trim();
String accesscode = request.getParameter("accesscode") == null ? "" : transferString((String)request.getParameter("accesscode")).trim();

            int optype = 0;
            String  sTmp = "";
            String  title = "";
            HashMap map = new HashMap();
            String  sDesc = "";
            if (op.equals("add")) {
                optype = 1;
                spindex = "";
                sTmp = sysTime + operName + "add SP";
                title = "add SP " + spname;
                sDesc = "add";
             }
            else if (op.equals("edit")) {
                optype = 3;
                sTmp = sysTime + operName + " edit SP";
                title = "edit SP " + spname;
                sDesc = "edit";
            }
            else if (op.equals("del")) {
                optype = 2;
                sTmp = sysTime + operName + " delete SP";
                title = "delete SP " + spname;
                sDesc = "delete";
            }
            else if (op.equals("revert")) {
                optype = 2;
                sTmp = sysTime + operName + "restore SP";
                title = "Restore SP " + spname;
                sDesc = "Restore";
            }if (op.equals("hide")) {
                optype = 1;
                sTmp = sysTime + operName + "hide SP";
                title = "Hide SP " + spname;
                sDesc = "Hide";
            }
            if(!op.equals("")){
              if(op.equals("add") || op.equals("edit") || op.equals("del")){
                hash.put("optype",optype+"");
                hash.put("spcode",spcode);
                hash.put("maxnumber",maxnumber);
                hash.put("spname",spname);
                hash.put("ischeck",ischeck);
                hash.put("spcent",spcent);
                hash.put("url",url);
                hash.put("spindex",spindex);
                hash.put("isopcheck",isopcheck);
                hash.put("corpname",corpname);
                hash.put("faxnumber",faxnumber);
                hash.put("phonenumber",phonenumber);
                hash.put("postno",postno);
                hash.put("linkman",linkman);
                hash.put("customer",customer);
                hash.put("corpaddress",corpaddress);
                hash.put("ifextra",ifextra);
                hash.put("extraspcode",extraspcode);
                hash.put("discountcheck",discountcheck);
                hash.put("discountopercheck",discountopercheck);
				hash.put("accesscode",accesscode);
                rList = syspara.setSP(hash);
              }
              if(op.equals("hide") || op.equals("revert")){
                hash.put("optype",optype+"");
                hash.put("spcode",spcode);
                rList = syspara.setSPState(hash);
              }
                // 准备写操作员日志
                if(getResultFlag(rList)){
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","306");
                  map.put("RESULT","1");
                  map.put("PARA1",spindex);
                  map.put("PARA2",spcode);
                  map.put("PARA3",spname);
                  map.put("PARA4",maxnumber);
                  map.put("PARA5",ischeck);
                  map.put("PARA6",spcent);
                  map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                  zxyw50.Purview purview = new zxyw50.Purview();
                  purview.writeLog(map);
                }
                sysInfo.add(sTmp);
                if(rList.size()>0){
                session.setAttribute("rList",rList);
                %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="sp.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
              <%
                }

            }

            vet = syspara.getSPInfo();
%>
<script language="javascript">
   var v_spindex = new Array(<%= vet.size() + "" %>);
   var v_spcode = new Array(<%= vet.size() + "" %>);
   var v_curnumber = new Array(<%= vet.size() + "" %>);
   var v_maxnumber = new Array(<%= vet.size() + "" %>);
   var v_spname =  new Array(<%= vet.size() + "" %>);
   var v_ischeck = new Array(<%= vet.size() + "" %>);
   var v_spcent = new Array(<%= vet.size() + "" %>);
   var v_url = new Array(<%= vet.size() + "" %>);
   var v_corpname = new Array(<%= vet.size() + "" %>);
   var v_faxnumber = new Array(<%= vet.size() + "" %>);
   var v_phonenumber = new Array(<%= vet.size() + "" %>);
   var v_postno = new Array(<%= vet.size() + "" %>);
   var v_linkman = new Array(<%= vet.size() + "" %>);
   var v_customer = new Array(<%= vet.size() + "" %>);
   var v_corpaddress = new Array(<%= vet.size() + "" %>);
   var v_isopcheck = new Array(<%= vet.size() + "" %>);
   var v_ifextra = new Array(<%= vet.size() + "" %>);
   var v_extraspcode = new Array(<%= vet.size() + "" %>);
   var v_spstate = new Array(<%= vet.size() + "" %>);
   var v_discountcheck = new Array(<%= vet.size() + "" %>);
   var v_discountopercheck = new Array(<%= vet.size() + "" %>);
   var v_accesscode = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                map = (HashMap)vet.get(i);
%>
   v_spindex[<%= i + "" %>] = '<%= (String)map.get("spindex") %>';
   v_spcode[<%= i + "" %>] = '<%= (String)map.get("spcode") %>';
   v_curnumber[<%= i + "" %>] = '<%= (String)map.get("curnumber") %>';
   v_maxnumber[<%= i + "" %>] = '<%= (String)map.get("maxnumber") %>';
   v_spname[<%= i + "" %>] = '<%= (String)map.get("spname") %>';
   v_ischeck[<%= i + "" %>] = '<%= (String)map.get("ischeck") %>';
   v_spcent[<%= i + "" %>] = '<%= (String)map.get("spcent") %>';
   v_url[<%= i + "" %>] = '<%= transferDYH(map.get("url")+"") %>';
   v_corpname[<%= i + "" %>] = '<%= transferDYH(map.get("corpname")+"")  %>';
   v_faxnumber[<%= i + "" %>] = '<%= transferDYH(map.get("faxnumber")+"")%>';
   v_phonenumber[<%= i + "" %>] = '<%= transferDYH (map.get("phonenumber")+"")  %>';
   v_postno[<%= i + "" %>] = '<%= transferDYH(map.get("postno")+"") %>';
   v_linkman[<%= i + "" %>] = '<%= transferDYH(map.get("linkman")+"") %>';
   v_customer[<%= i + "" %>] = '<%= transferDYH(map.get("customer")+"") %>';
   v_corpaddress[<%= i + "" %>] = '<%= transferDYH(map.get("corpaddress")+"")  %>';
   v_isopcheck[<%= i + "" %>] = '<%= (String)map.get("isopcheck") %>';
   v_ifextra[<%= i + "" %>] = '<%= (String)map.get("ifextra") %>';
   v_extraspcode[<%= i + "" %>] = '<%= (String)map.get("extraspcode") %>';
   v_spstate[<%= i + "" %>] = '<%= (String)map.get("ishide") %>';
   v_discountcheck[<%= i + "" %>] = '<%= (String)map.get("discountcheck") %>';
   v_discountopercheck[<%= i + "" %>] = '<%= (String)map.get("discountopercheck") %>';
   v_accesscode[<%= i + "" %>] = '<%= (String)map.get("accesscode") %>';
<%
            }
%>

   var SPCODE_LEN = <%= SPCODE_LEN %>;
   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '') {
         fm.spcode.focus();
         return;
      }
      fm.oldspcode.value = v_spcode[index];
      fm.spcode.value = v_spcode[index];
      fm.curnumber.value = v_curnumber[index];
      fm.maxnumber.value = v_maxnumber[index];
      fm.spname.value = v_spname[index];
      fm.spcent.value = v_spcent[index];
      fm.spindex.value = v_spindex[index];
      fm.ischeck[v_ischeck[index]].checked = true;
      fm.url.value = v_url[index];
       fm.corpname.value = v_corpname[index]=="null"?"":v_corpname[index];
      fm.faxnumber.value = v_faxnumber[index]=="null"?"":v_faxnumber[index];
      fm.phonenumber.value = v_phonenumber[index]=="null"?"": v_phonenumber[index];
      fm.postno.value = v_postno[index]=="null"?"":v_postno[index];
      fm.linkman.value = v_linkman[index]=="null"?"":v_linkman[index];
      fm.customer.value = v_customer[index]=="null"?"":v_customer[index];
      fm.corpaddress.value = v_corpaddress[index]=="null"?"":v_corpaddress[index];
      fm.isopcheck[v_isopcheck[index]].checked = true;
      fm.ifextra.value = v_ifextra[index];
      window.ifextralabel.innerText = v_ifextra[index]=='1'?'Yes':'No';
      fm.extraspcode.value = v_extraspcode[index]=='null'?'':v_extraspcode[index];
      fm.spstate.value = v_spstate[index]=='1'?'Hidden':'Normal';
	  fm.accesscode.value = v_accesscode[index];
      fm.discountcheck[v_discountcheck[index]].checked = true;
      fm.discountopercheck[v_discountopercheck[index]].checked = true;
     fm.spcode.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if ((trim(fm.spcode.value)).length != SPCODE_LEN) {
         alert('The SP code can only be composed of ' + SPCODE_LEN + ' digits!');
         fm.spcode.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.spcode.value))) {
         alert(' the SP code can only be a  be a digital number!');
         fm.spcode.focus();
         return flag;
      }
      var strTmp = trim(fm.spcode.value);
      if(strTmp.length>2)
         strTmp = strTmp.substring(0,2);
      if (strTmp == '99') {
         alert('99 is a system ringtone prefix,please re-enter a sp code!');//为系统铃音组前缀,请重新输入SP code!
         fm.spcode.focus();
         return flag;
      }
      if (trim(fm.spname.value) == '') {
         alert('Please enter the SP name');
         fm.spname.focus();
         return flag;
      }
      if (!CheckInputStr(fm.spname,'SP name')){
         fm.spname.focus();
         return flag;
      }
      <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.spname.value,36)){
          alert("The sp name should not exceed 36 bytes!");
          fm.spname.focus();
          return;
        }
        if(!checkUTFLength(fm.corpname.value,50)){
          alert("The Corp name should not exceed 50 bytes!");
          fm.corpname.focus();
          return;
        }
        if(!checkUTFLength(fm.url.value,100)){
          alert("The url should not exceed 100 bytes!");
          fm.ipname.focus();
          return;
        }
        if(!checkUTFLength(fm.postno.value,10)){
          alert("The Postman name should not exceed 10 bytes!");
          fm.postno.focus();
          return;
        }
         if(!checkUTFLength(fm.linkman.value,20)){
            alert("The Linkman name should not exceed 20 bytes!");
            fm.linkman.focus();
            return;
          }
           if(!checkUTFLength(fm.customer.value,20)){
            alert("The customer name should not exceed 20 bytes!");
            fm.customer.focus();
            return;
          }
           if(!checkUTFLength(fm.corpaddress.value,60)){
            alert("The corpaddress name should not exceed 60 bytes!");
            fm.corpaddress.focus();
            return;
          }
        <%
        }
        %>
      /*
      if (!CheckInputStr(fm.corpname,'company name')){
         fm.corpname.focus();
         return flag;
      }
      
      if (!CheckInputStr(fm.url,'URL')){
         fm.url.focus();
         return flag;
      }
      
      if (!CheckInputStr(fm.phonenumber,'phone number')){
         fm.phonenumber.focus();
         return flag;
      }
      
      if (!CheckInputStr(fm.faxnumber,'fax number')){
         fm.faxnumber.focus();
         return flag;
      }
      
      
      if (!CheckInputStr(fm.postno,'post no')){
         fm.postno.focus();
         return flag;
      }  
         
      if (!CheckInputStr(fm.linkman,'linkman')){
         fm.linkman.focus();
         return flag;
      }        
      
      if (!CheckInputStr(fm.customer,'customer')){
         fm.customer.focus();
         return flag;
      }          
      
      if (!CheckInputStr(fm.corpaddress,'company address')){
         fm.corpaddress.focus();
         return flag;
      }
      */
      

      if (trim(fm.maxnumber.value) == '') {
         alert('Please enter the maximum number of ringtones!');//请输入最大铃音数量!
         fm.maxnumber.focus();
         return flag;
      }
     if (!checkstring('0123456789',trim(fm.maxnumber.value))) {
         alert('The maximum number of ringtones can only be a digital number!');//最大铃音数量只能为数字
         fm.maxnumber.focus();
         return flag;
      }
      if (trim(fm.spcent.value) == '') {
         alert('Please enter the settlement proportion!');//请输入结算比例
         fm.spcent.focus();
         return flag;
      }

      if (!checkstring('0123456789',trim(fm.spcent.value))) {
         alert('The settlement proportion can only be a digital number!');//结算比例只能为数字
         fm.spcent.focus();
         return flag;
      }
      var scale = parseInt(fm.spcent.value);
      if(scale<0 || scale >100){
        alert('The range of proportion is between 0~100');//结算比例的范围为0~100!
        fm.spcent.focus();
        return flag;
      }
      flag = true;
      return flag;
   }

   function checkCode (index) {
      var fm = document.inputForm;
      var code = trim(fm.spcode.value);
      for (i = 0; i < v_spcode.length; i++)
         if (code == v_spcode[i] && v_spindex[i] != index)
            return true;
      return false;
   }

   function addInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      if (checkCode(-1)) {
         alert('This SP code has been used and cannot be added!');//该SP code已经在使用,不能添加!
         fm.spcode.focus();
         return;
      }
//	  if(!checkAccesscode())
//		  return;
      checkUrl();
      fm.op.value = 'add';
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      if (fm.infoList.length == 0) {
         alert('Sorry. No SP can be changed!');//对不起,没有可供更改的SP!
         return;
      }
      if (fm.infoList.selectedIndex == -1) {
         alert('Please select the SP to be changed!');//请先选择您要更改的SP!
         return;
      }
      if (! checkInfo())
         return;
//	  if(!checkAccesscode())
//		  return;
      checkUrl();
      fm.spcode.value = fm.oldspcode.value;
      fm.op.value = 'edit';
      fm.submit();
   }

   function hideInfo (){
     var fm = document.inputForm;
      if (fm.infoList.length == 0) {
        // alert('对不起,没有可供隐藏的SP!');
         alert("Sorry,there is no  SP for hidden!");
         return;
      }
      if (fm.infoList.selectedIndex == -1) {
        // alert('请先选择您要隐藏的SP!');
        alert("Please select the SP for hidden!");
         return;
      }
      if(fm.spstate.value == "Hidden"){
      //  alert("该SP已经是隐藏状态!");
        alert("The sp has in hidden state!");
        return;
      }
      if (checkTime()){
        fm.spcode.value = fm.oldspcode.value;
        fm.op.value = 'hide';
        fm.submit();
      }
   }

   function revertInfo () {
      var fm = document.inputForm;
      if (fm.infoList.length == 0) {
         alert('Sorry,there is no  SP for restoring!');
         return;
      }
      if (fm.infoList.selectedIndex == -1) {
        // alert('请先选择您要恢复的SP!');
          alert("Please select the SP you want to restore!");
         return;
      }
      if(fm.spstate.value == "natural"){
        alert("The SP has always in the right status!");
        return;
      }
      if (checkTime()){
        fm.spcode.value = fm.oldspcode.value;
        fm.op.value = 'revert';
        fm.submit();
      }
   }

   function checkTime () {
     if(<%= startTime%>><%= stopDate%> || <%= endTime%><<%= stopDate%>){
       return true;
     }
     else{
       //alert( "对不起,该time segment操作SP隐藏或者恢复,会导致系统不稳定,请在<%=startTime%>:00至<%=endTime%>:59以外的时间操作!");
        alert("Sorry,the time range operate SP hidden or restoring  will make the system unsteadiness,pelase don't  operate it in the time range from <%=startTime%>:00 to <%=endTime%>:59");
       return false;
     }
     return true;
   }

   function checkUrl () {
      var fm = document.inputForm;
      var value = trim(fm.url.value);
      if(value!=''){
         if(value.substring(0,7)=='http://'){
            var len = value.length;
            value = value.substring(7,len);
            fm.url.value = value;
         }
      }
   }
   function checkAccesscode()
   {
	   var fm = document.inputForm;
	   if (!checkstring('0123456789',trim(fm.accesscode.value))) {
		 alert('The access number can only be a digital number!');//结算比例只能为数字
		 fm.accesscode.focus();
		 return false;
	  }
	  return true;
   }

   function delInfo () {
      var fm = document.inputForm;
      if (fm.infoList.length == 0) {
         alert('Sorry. No SP can be deleted!');//对不起,没有可供删除的SP!
         return;
      }
      if (fm.infoList.selectedIndex == -1) {
         alert('Please select the SP to be deleted!');//请先选择您要删除的SP
         return;
      }
      fm.spcode.value = fm.oldspcode.value;
      fm.op.value = 'del';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		 parent.document.all.main.style.height="750";
</script>
<form name="inputForm" method="post" action="sp.jsp">
<input type="hidden" name="oldspcode" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="spindex" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">SP Management</td>
        </tr>
        <tr>
          <td valign="top" rowspan="<%=rightsize%>">
            <select name="infoList" size="<%=leftsize%>" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                    map = (HashMap)vet.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)map.get("spcode") + "---" + (String)map.get("spname") %></option>
<%
            }
%>
            </select>
          </td>
          <td align="right">SP code</td>
          <td><input type="text" name="spcode" value="" maxlength="3" class="input-style1"></td>
        </tr>
         <tr>
          <td align="right">SP name</td>
          <td><input type="text" name="spname" value="" maxlength="36" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Number of available<br>ringtones</td>
          <td><input type="text" name="curnumber" value="" disabled  maxlength="6" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Maximum number<br>of ringtones</td>
          <td><input type="text" name="maxnumber" value="" maxlength="5" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Verify ringtone or not</td>
          <td>
            <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td width="50%"><input type="radio"  name="ischeck" value="0">No</td>
                <td width="50%"><input type="radio" checked name="ischeck" value="1">Yes</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td align="right">Verify operation or not</td>
          <td>
            <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td width="50%"><input type="radio" checked name="isopcheck" value="0">No</td>
                <td width="50%"><input type="radio" name="isopcheck" value="1">Yes</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td align="right">Settlement<br>proportion (%)</td>
          <td><input type="text" name="spcent" value="" maxlength="3" class="input-style1"></td>
       </tr>
       <tr>
          <td align="right">Corporation name</td>
          <td><input type="text" name="corpname" value="" maxlength="50" class="input-style1"></td>
       </tr>
       <tr>
          <td align="right">Website address</td>
          <td><input type="text" name="url" value="" maxlength="100" class="input-style1"></td>
       </tr>
        <tr>
          <td align="right">Fax</td>
          <td><input type="text" name="faxnumber" value="" maxlength="20" class="input-style1"></td>
       </tr>
        <tr>
          <td align="right">Phone</td>
          <td><input type="text" name="phonenumber" value="" maxlength="20" class="input-style1"></td>
       </tr>
        <tr>
          <td align="right">Postman</td>
          <td><input type="text" name="postno" value="" maxlength="10" class="input-style1"></td>
       </tr>
        <tr>
          <td align="right">Linkman</td>
          <td><input type="text" name="linkman" value="" maxlength="20" class="input-style1"></td>
       </tr>
               <tr>
          <td align="right">Customer</td>
          <td><input type="text" name="customer" value="" maxlength="20" class="input-style1"></td>
       </tr>
                <tr>
          <td align="right">Corpaddress</td>
          <td><input type="text" name="corpaddress" value="" maxlength="60" class="input-style1"></td>
       </tr>
               <tr>
          <td align="right">Outer SP or not</td>
          <td>
            <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td align="left" width="50%"><input align="left" type="hidden" name="ifextra" value=""><span align="left" id="ifextralabel"></span></td>

              </tr>
            </table>
          </td>
        </tr>
                    <tr>
          <td align="right">Out SP code</td>
          <td><input type="text" name="extraspcode"  readonly value="" maxlength="20" class="input-style1"></td>
       </tr>
       <tr>
          <td align="right">SP state</td>
          <td><input type="text" name="spstate"  readonly value="" maxlength="20" class="input-style1"></td>
       </tr>
	   <tr style="display:none">
		   <td align="right">Access Mumber</td>
		  <td><input type="text" name="accesscode" value="" maxlength="10" class="input-style1"></td>
	   </tr>
           <% String typeDisplay = "none";
         if("1".equals(usediscount))
           typeDisplay = "";
        %>
         <tr style="display:<%= typeDisplay %>">
          <td align="right">Package audit or not</td>
          <td>
            <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td width="50%"><input type="radio" checked name="discountcheck" value="0">No</td>
                <td width="50%"><input type="radio" name="discountcheck" value="1">Yes</td>
              </tr>
            </table>
          </td>
        </tr>
          <tr style="display:<%= typeDisplay %>">
          <td align="right">Package operation audit or no</td>
          <td>
            <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td width="50%"><input type="radio" checked name="discountopercheck" value="0">Not audit</td>
                <td width="50%"><input type="radio" name="discountopercheck" value="1">Audit</td>
              </tr>
            </table>
          </td>
        </tr>

        <tr>
          <td></td>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="17%" align="center"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="16%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                <td width="16%" align="center"><img src="button/hide.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:hideInfo()"></td>
                <td width="16%" align="center"><img src="button/revert.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:revertInfo()"></td>
                <td width="16%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                <td width="17%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr >
          <td height="26" colspan="3" >
           <table border="0" width="100%" class="table-style2">
              <tr>
               <td>Notes:</td>
              </tr>
              <tr>
              <!-- <td >&nbsp;&nbsp;&nbsp;1. 当SP已有铃音时,SP code不允许修改,SP code长度必须为<%= SPCODE_LEN %>位；</td> -->
               <td>&nbsp;&nbsp;&nbsp;1. SP codes cannot be modified when SP have the ringtone,SP code's length must be <%= SPCODE_LEN %>. </td>
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;2. The settlement proportion must be an integer!</td>
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;3. Website address is used to provide links to SP homepage. The maximum length of address is 100 bytes, in a format such as "www.zte.com.cn" or "10.40.57.212/colorring/index.jsp".</td>
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

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime + operName + " Exception occurred in managing SPs!");//SP管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing SPs!");//SP管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="sp.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
