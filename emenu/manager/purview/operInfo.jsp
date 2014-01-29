<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<jsp:useBean id="syspara" class="zxyw50.manSysPara" scope="page" />

<%
    try {
        String grouplen = (String)session.getAttribute("GROUPIDLEN")==null?"10":(String)session.getAttribute("GROUPIDLEN");
        String isgroup = (String)application.getAttribute("ISGROUP")==null?"1":(String)application.getAttribute("ISGROUP");
        String operID = (String)request.getParameter("operID");
        String serflag2 = (String)request.getParameter("serflag");
        String opername = (String)request.getParameter("name");
        String opertype = (String)request.getParameter("operType");
        String pid = (String)request.getParameter("pid");
        String stat = request.getParameter("stat")==null?"":request.getParameter("stat");;


		  String strMinlength  = zxyw50.CrbtUtil.getConfig("managerminpassword","1");
		  int managerminlength =1;
		  try{
		  		managerminlength = Integer.parseInt(strMinlength);
		  }catch(Exception e)
		  {
		  	  System.out.println("Invalid managerminpassword:"+strMinlength);
		  	  managerminlength = 1;
		  }
		  
		  

        HashMap map = null;
        ArrayList list = new ArrayList();
        HashMap ipMap = new HashMap();
        String flagString = "";
        boolean flag = true;
        int  serflag = 0;
        int  serindex = 0;
        if (operID == null)
            flagString = "add";
        else {
            flagString = "update";
            flag = false;
            map = purview.getOperInformation(operID);
            serflag = Integer.parseInt((String)map.get("SERFLAG"));
            serindex= Integer.parseInt((String)map.get("SERINDEX"));
            list = (ArrayList)map.get("IPLIST");
        }
        String strOption = "";
        String groupid   = "";
        ArrayList vet = new ArrayList();
        HashMap  map11 = new HashMap();
        vet = syspara.getSPInfo();
        for(int i=0; i<vet.size(); i++) {
          map11 = (HashMap)vet.get(i);
          int  sp = Integer.parseInt((String)map11.get("spindex"));
          if(serflag == 1 && sp == serindex)
              strOption = strOption + "<option value=" + (String)map11.get("spindex")+" selected >"+(String)map11.get("spname")+"</option>";
          else
             strOption = strOption + "<option value=" + (String)map11.get("spindex")+" >"+(String)map11.get("spname")+"</option>";
        }
        if(serflag ==2 && serindex>0)
           if(isgroup.equals("1") )
              //groupid = mangroup.getGrpByindex(String.valueOf(serindex));
        	   groupid="1";
           else                
             serflag = 0;

%>
<html>
<head>
<title><%= flag ? "Add" : "Modify" %>&nbsp;Operator</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
<script language="javascript">
   var grouplen = <%= grouplen %>;
   function initform(pform){
      var serflag = <%= serflag %>;
      pform.serflag[serflag].checked = true;
      onSerFlag();
      pwdchg1();
      pwdchg2();
   }
   // 关闭前向父窗口回写关闭标志
   function unLoad () {
      window.opener.focus();
   }

   // 下次登录时须更改密码,选择这个复选框的控制
   function changeUseDays () {
      if (document.view.maxNoUseDays.checked) {
         document.view.noUseDays.disabled = false;
         document.view.noUseDays.focus();
      }
      else
         document.view.noUseDays.disabled = true;
   }

   // 用户不得更改密码,选择这个复选框的控制
   function changeWrongTimes () {
      if (document.view.maxWrongTimes.checked) {
         document.view.wrongTimes.disabled = false;
         document.view.wrongTimes.focus();
      }
      else
         document.view.wrongTimes.disabled = true;
   }

   // 密码有效期限制,选择这个复选框的控制
 /*  function changePasswordChange () {
      if (document.view.pwdMustChange1.checked) {
         document.view.passwordChange.disabled = false;
         document.view.passwordChange.focus();
      }
      else
         document.view.passwordChange.disabled = true;
   }*/

   function pwdchg1()
   	{
       if(document.view.nextUpdPwd.checked ==true ||  document.view.pwdMustChange1.checked ==true  )
		{
		if(document.view.pwdMustChange1.checked ==true)
		{
		 document.view.passwordChange.disabled = false;	
	     }
		else if(document.view.pwdMustChange1.checked == false) 
		{
		 document.view.passwordChange.disabled = true;
   }
		 document.view.pwdNeverUpd.checked = false;
         document.view.pwdMustChange.checked = false;
   	}
		else 
		{
		 document.view.passwordChange.disabled = true;
   }
   	}

	 function pwdchg2()
   	{
		 
		 if(document.view.pwdNeverUpd.checked ==true ||  document.view.pwdMustChange.checked ==true  )
		{
		 document.view.passwordChange.disabled = true;	
	     document.view.nextUpdPwd.checked = false;
         document.view.pwdMustChange1.checked = false;
		}
		//document.view.pwdMustChange.checked = true;

   }

   // 帐号有效期限制,选择这个复选框的控制
   function changeUserDate () {
      if (document.view.useDate.checked) {
         document.view.endDate.disabled = false;
         document.view.endDate.focus();
      }
      else
         document.view.endDate.disabled = true;
   }

   // 密码永远有效,选择这个复选框的控制
   function changePwdMustChange () {
      if (document.view.pwdMustChange.checked)
         document.view.pwdMustChange1.disabled = true;
      else
         document.view.pwdMustChange1.disabled = false;
   }

   // 选择登录时间控制单选钮事件
   function changeLimit () {
      if (document.view.onLimit[0].checked) {
         document.view.sunday.disabled = true;
         document.view.monday.disabled = true;
         document.view.tuesday.disabled = true;
         document.view.wednesday.disabled = true;
         document.view.thursday.disabled = true;
         document.view.friday.disabled = true;
         document.view.saturday.disabled = true;
         document.view.beginTime.disabled = true;
         document.view.endTime.disabled = true;
      }
      else {
         document.view.sunday.disabled = false;
         document.view.monday.disabled = false;
         document.view.tuesday.disabled = false;
         document.view.wednesday.disabled = false;
         document.view.thursday.disabled = false;
         document.view.friday.disabled = false;
         document.view.saturday.disabled = false;
         document.view.beginTime.disabled = false;
         document.view.endTime.disabled = false;
         document.view.beginTime.focus();
      }
   }

   // 不限制登录的IP地址,选择这个复选框的控制
   function changeIP () {
      if (document.view.noIP.checked) {
         document.view.ipAddress.disabled = true;
         document.view.addAllowIP.disabled = true;
         document.view.delAllowIP.disabled = true;
         document.view.addForbidIP.disabled = true;
         document.view.delForbidIP.disabled = true;
         document.view.allowedIP.disabled = true;
         document.view.forbidedIP.disabled = true;
      }
      else {
         document.view.ipAddress.disabled = false;
         document.view.addAllowIP.disabled = false;
         document.view.delAllowIP.disabled = false;
         document.view.addForbidIP.disabled = false;
         document.view.delForbidIP.disabled = false;
         document.view.allowedIP.disabled = false;
         document.view.forbidedIP.disabled = false;
         document.view.ipAddress.focus();
      }
   }


   // 检查输入的IP地址的准确性
   function checkIP () {
      var tmp = document.view.ipAddress.value;
      var index = tmp.indexOf('.');
      var ip;
      // 验证列表中是否已经存在该IP
      for (i = 0; i < document.view.allowedIP.options.length; i++)
         if (tmp == document.view.allowedIP.options[i].value) {
            alert("This IP already exists on the list!");//该IP已经存在于列表中
            document.view.allowedIP.selectedIndex = i;
            document.view.ipAddress.focus();
            return false;
         }
      for (i = 0; i < document.view.forbidedIP.options.length; i++)
         if (tmp == document.view.forbidedIP.options[i].value) {
            alert("This IP already exists on the list!");//该IP已经存在于列表中
            document.view.forbidedIP.selectedIndex = i;
            document.view.ipAddress.focus();
            return false;
         }
      // 检查IP地址第一段
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 1 || ip > 255) {
         alert("The IP address entered is incorrect!");//IP地址输入错误
         document.view.ipAddress.focus();
         return false;
      }
      // 检查IP地址第二段
      tmp = tmp.substring(index + 1,tmp.length);
      index = tmp.indexOf('.');
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
         alert("The IP address entered is incorrect!");//IP地址输入错误
         document.view.ipAddress.focus();
         return false;
      }
      // 检查IP地址第三段
      tmp = tmp.substring(index + 1,tmp.length);
      index = tmp.indexOf('.');
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
         alert("The IP address entered is incorrect!");//IP地址输入错误
         document.view.ipAddress.focus();
         return false;
      }
      // 检查IP地址第四段
      ip = tmp.substring(index + 1,tmp.length);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
         alert("The IP address entered is incorrect!");//IP地址输入错误
         document.view.ipAddress.focus();
         return false;
      }
      return true;
   }

   // 增加列表中的IP地址
   function addIP (selectObject) {
      if (checkIP()) {
         allowIP = new Option(document.view.ipAddress.value,document.view.ipAddress.value,false,true);
         selectObject.options[selectObject.options.length] = allowIP;
      }
   }

   // 删除列表中的IP地址
   function delIP (selectObject) {
      if (selectObject.options.length == 0)
         return;
      if (selectObject.selectedIndex < 0) {
         alert("Please select the IP address to be deleted!");//请先选择要删除的IP地址!
         return;
      }
      document.view.ipAddress.value = selectObject.options[selectObject.selectedIndex].value;
      selectObject.options[selectObject.selectedIndex] = null;
      document.view.ipAddress.focus();
   }
   
   function isContainDot(password) {
   	 if(password == null || password.length <= 0) {
   	 	return false;
   	 }
   	 for(var i = 0; i < password.length; i++) {
   	 	var c = password.charAt(i);
   	 	if(c == '.') {
   	 		return true;
   	 	}
   	 }
   	 return false;
   }
   
   // 页面提交
   function onSubmit () {
      var fm = document.view;
      
      //检查password长度
      if(strlength(fm.operPwd.value)<<%=managerminlength%>){
      	alert("Sorry,the password should be at least <%=managerminlength%> characters. Please input again.");
      	fm.operPwd.focus();
      	return;
      }
      if(strlength(fm.operConfirm.value)<<%=managerminlength%>){
      	alert("Sorry,the confirm password should be at least <%=managerminlength%> characters. Please input again.");
      	fm.operConfirm.focus();
      	return;
      	
      }
      
      var operPassword1 = fm.operPwd.value;
      var operPassword2 = fm.operConfirm.value;
      
      if(isContainDot(operPassword1)) {
      	alert("Sorry,the password should not contain dot character.");
      	fm.operPwd.focus();
      	return;
      }
      if(isContainDot(operPassword2)) {
      	alert("Sorry,the confirm password should not contain dot character.");
      	fm.operConfirm.focus();
      	return;
      }
      
      fm.operName.value = trim(fm.operName.value);
      fm.operPwd.value = trim(fm.operPwd.value);
      fm.operConfirm.value = trim(fm.operConfirm.value);
      var allowIP = '';
      var noAllowIP = '';
		var begtime = trim(fm.beginTime.value);
      var endtime = trim(fm.endTime.value);
      if (fm.operName.value == '') {
         alert("Please enter the operator name!");
         fm.operName.focus();
         return;
      }
      if(strlength(fm.operName.value)>20){
         alert("The length of the operator name has exceeded 20 bytes!");//操作员名称长度已超过20字节!
         fm.operName.focus();
         return;
      }
      if (!CheckInputStr(fm.operName,"name of operator")){
         fm.operName.focus();
         return ;
      }
      if(fm.operAllName.value !='' && strlength(fm.operAllName.value)>40){
         alert("The length of the full name has exceeded 40 bytes!");//全称长度已超过40字节!
         fm.operAllName.focus();
         return;
      }
     if (!CheckInputStr(fm.operAllName,"full name")){
         fm.operAllName.focus();
         return  ;
      }
      if(fm.operDescription.value !='' && strlength(fm.operDescription.value)>40){
         alert("The length of the description has exceeded 40 bytes!");//描述长度已超过40字节!
         fm.operDescription.focus();
         return;
      }
      if (!CheckInputStr(fm.operDescription,"description")){
         fm.operDescription.focus();
         return  ;
      }
      if (fm.operPwd.value == '') {
         alert("Please enter the password!");//请输入密码
         fm.operPwd.focus();
         return;
      }
      if (fm.operPwd.value != fm.operConfirm.value) {
         alert("Password authentication error!");//密码校验错误
         fm.operPwd.value = '';
         fm.operConfirm.value = '';
         fm.operPwd.focus();
         return;
      }
      if(fm.serflag[2].checked){
         var value = trim(fm.groupid.value);
         if(value==''){
            alert("Please enter the group code of the group operator!");//请输入该集团操作员的集团 code
            return;
         }
         if(isNaN(value)){
          alert("The group code can only be a digital string!");//集团 code只能是数字字符串
          fm.groupid.focus();
          return;
         }
         if(value.length < grouplen || value.length>15){
           alert("The group code length must be "+grouplen + "-byte. Please re-enter!");
           fm.groupid.focus();
           return ;
         }
      }
      if (! document.view.noIP.checked) {
         for (i = 0; i < document.view.allowedIP.options.length; i++)
            allowIP = allowIP + document.view.allowedIP.options[i].value + ';'
         document.view.allowIP.value = allowIP;
         for (i = 0; i < document.view.forbidedIP.options.length; i++)
            noAllowIP = noAllowIP + document.view.forbidedIP.options[i].value + ';'
         document.view.noAllowIP.value = noAllowIP;
      }

if(checkTime(begtime,endtime)==false){
        return;
      }

      fm.submit();
   }

function checkTime(begtime,endtime){
     var fm = document.view;
     if(begtime.length!=8||endtime.length!=8){
       alert("The time format is incorrect!");
       fm.beginTime.focus();
       return false;
     }

     if((begtime.substring(2,3))!=":"||(begtime.substring(5,6))!=":"){
       alert("The start time format is incorrect!");
       fm.beginTime.focus();
       return false;
     }
     if((endtime.substring(2,3))!=":"||(endtime.substring(5,6))!=":"){
       alert("The format of end time is incorrect!");
       fm.endTime.focus();
       return false;
     }
    if(!isNaN(begtime.substring(0,2))&&!isNaN(begtime.substring(3,5))&&!isNaN(begtime.substring(6,8))&&
       !isNaN(endtime.substring(0,2))&&!isNaN(endtime.substring(3,5))&&!isNaN(endtime.substring(6,8))){

      if((parseInt(begtime.substring(0,2))>23||parseInt(begtime.substring(0,2))<0)||
             (parseInt(endtime.substring(0,2))>23||parseInt(endtime.substring(0,2))<0)){
              alert("Hour is incorrect!");
              fm.beginTime.focus();
              return false;
          }

          if((parseInt(begtime.substring(3,5))>59||parseInt(begtime.substring(3,5))<0)||
          (parseInt(endtime.substring(3,5))>59||parseInt(endtime.substring(3,5))<0)){
            alert("Minute is incorrect!");
            fm.beginTime.focus();
            return false;
          }
          if((parseInt(begtime.substring(6,8))>59||parseInt(begtime.substring(6,8))<0)||
          (parseInt(endtime.substring(6,8))>59||parseInt(endtime.substring(6,8))<0)){
            alert("Second  is incorrect!");
            fm.beginTime.focus();
            return false;
          }
          if(parseInt(begtime.substring(0,2))>parseInt(endtime.substring(0,2))){
            alert("The start time must be earlier than end time!");
            fm.beginTime.focus();
            return false;
          }
          if(parseInt(begtime.substring(0,2))==parseInt(endtime.substring(0,2))){
            if(parseInt(begtime.substring(3,5))>parseInt(endtime.substring(3,5))){
              alert("The start time must be earlier than end time!");
              fm.beginTime.focus();
              return false;
            }
          }

          if(parseInt(begtime.substring(0,2))==parseInt(endtime.substring(0,2))){
            if(parseInt(begtime.substring(3,5))==parseInt(endtime.substring(3,5))){
              if(parseInt(begtime.substring(6,8))>=parseInt(endtime.substring(6,8))){
                alert("The start time must be earlier than end time!");
                fm.beginTime.focus();
                return false;
              }
            }
          }
        } else {
          alert("Time must be digital!");
          fm.beginTime.focus();
          return false;
        }
   }

   function onSerFlag(){
       var fm = document.view;
       if(fm.serflag[0].checked){
          document.all('id_sp').style.display="none";
          document.all('id_group').style.display="none";
       } else if(fm.serflag[1].checked){
          var len = fm.spindex.length;
          if(len==0){
             alert("No SP has been configured in the system! \n Please enter SP Management under System Data Management to add an SP and then add operators to this SP!");//系统没有配置SP!\n请现进入系统数据管理中的‘SP管理’,增加SP后再为该SP增加操作员!
             fm.serflag[0].checked = true;
             document.all('id_sp').style.display="none";
             document.all('id_group').style.display="none";
             return;
          }
          document.all('id_sp').style.display="block";
          document.all('id_group').style.display="none";
      }else if(fm.serflag[2].checked){
          document.all('id_sp').style.display="none";
          document.all('id_group').style.display="block";
      }
	  // Added for ccs module
	  else if(fm.serflag[3].checked){
          document.all('id_sp').style.display="none";
          document.all('id_group').style.display="none";
      }
   }

   function closeWin(){
     window.close();
   }
</script>
</head>
<body class="body-style1" onunload="javascript:unLoad()" onload="initform(document.forms[0])">
<form name="view" method="post" action="operInfoEnd.jsp">
<input type="hidden" name="flag" value="<%= flagString %>">
<input type="hidden" name="allowIP" value="">
<input type="hidden" name="noAllowIP" value="">
<input type="hidden" name="serflag2" value="<%=serflag2%>">
<input type="hidden" name="opername" value="<%=opername%>">
<input type="hidden" name="operType" value="<%= opertype %>">
<input type="hidden" name="pid" value="<%= pid %>">
<input type="hidden" name="stat" value="<%= stat %>">

<%
        if (! flag) {
%>
<input type="hidden" name="operID" value="<%= operID %>">
<%
        }
%>
<table border="0" width="650" class="text-default">
  <tr>
    <td colspan="2">
      <table border="1" bordercolorlight="#000000" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
       <tr class="tr-ring">
          <td width="105" height="22" align="right">Operator Name</td>
          <td width="120" height="22"><input type="text" name="operName" value="<%= flag ? "" : (String)map.get("OPERNAME") %>" maxlength="20"  size ="15"></td>
          <td align="left" width="160" height="22"><input type="checkbox" name="nextUpdPwd" <%= flag || ((String)map.get("NEXTUPDPWD")).equals("1") ? "checked" : "" %> onClick="pwdchg1()">The password should be changed in the next login</td>
          <td align="left" height="22"><input type="checkbox" name="maxWrongTimes" onclick="javascript:changeWrongTimes()" <%= flag || ((String)map.get("MAXWRGLOG")).equals("0") ? "" : "checked" %>>Limit of invalid login attempts</td>
<%
        if (flag || ((String)map.get("MAXWRGLOG")).equals("0")) {
%>
          <td height="22"><input type="text" name="wrongTimes" value="30" disabled size ="13"></td>
<%
        }
        else {
%>
          <td height="22"><input type="text" name="wrongTimes" value="<%= (String)map.get("MAXWRGLOG") %>" size ="13"></td>
<%
        }
%>

        </tr>
        <tr class="tr-ring">
          <td height="22" align="right">Full name</td>
          <td height="22"><input type="text" name="operAllName" value="<%= flag ? "" : (String)map.get("OPERALLNAME") %>" maxlength="40" size ="15"></td>
          <td align="left" height="22"><input type="checkbox" name="pwdNeverUpd" onClick="pwdchg2()"  <%= flag || ((String)map.get("PWDNEVERUPD")).equals("0") ? "" : "checked" %>>Subscribers are not allowed to change passwords</td>
          <td align="left" height="22"><input type="checkbox" name="pwdMustChange1" onclick="javascript:pwdchg1()" <%= flag || ((String)map.get("PWDMUSTCHANGE")).equals("0") ? "" : "checked" %>>Limit of password validity period</td>
<%
        if (flag || ((String)map.get("PWDMUSTCHANGE")).equals("0")) {
%>
          <td height="22"><input type="text" name="passwordChange" value="30" disabled size ="13"></td>
<%
        }
        else {
%>
          <td height="22"><input type="text" name="passwordChange" value="<%= (String)map.get("PWDMUSTCHANGE") %>" size ="13"></td>
<%
        }
%>
        </tr>
        <tr class="tr-ring">
          <td height="22" align="right">Description</td>
          <td height="22"><input type="text" name="operDescription" value="<%= flag ? "" : (String)map.get("OPERDESCRIPTION") %>" maxlength="40" size ="15"></td>
          <td align="left" height="22"><input type="checkbox" name="pwdMustChange" <%= (! flag) && ((String)map.get("PWDMUSTCHANGE")).equals("0") ? "checked" : "" %> onclick="javascript:pwdchg2()">Password never expired</td>
          <td align="left" height="22"><input type="checkbox" name="useDate" onclick="javascript:changeUserDate()" <%= flag || ((String)map.get("USEDATE")).equals("999") ? "" : "checked" %>>Limit of account validity period</td>
<%
        if (flag || ((String)map.get("USEDATE")).equals("999")) {
%>
          <td height="22"><input type="text" name="endDate" value="<%= (purview.nowString()).substring(0,11) %>" disabled size ="13"></td>
<%
        }
        else {
%>
          <td height="22"><input type="text" name="endDate" value="<%= (String)map.get("USEDATE") %>" size ="13"></td>
<%
        }
%>
        </tr>
        <tr class="tr-ring">
          <td height="22" align="right" >Password</td>
          <td height="22"><input type="password" name="operPwd" value="<%= flag ? "" : (String)map.get("OPERPWD") %>" maxlength="20" size ="15"  minlength="8" ></td>
          <td align="left" height="22"><input type="checkbox" name="userForbid" <%= (! flag) && (((String)map.get("OPERSTATUS")).equals("3") || ((String)map.get("OPERSTATUS")).equals("4")) ? "checked" : "" %> <%= (! flag) && ((String)map.get("OPERSTATUS")).equals("10") ? "disabled" : "" %>>Disable account</td>
          <td align="left" width="160" height="22"><input type="checkbox" name="maxNoUseDays" onclick="javascript:changeUseDays()" <%= flag || ((String)map.get("MAXNOUSEDAYS")).equals("0") ? "" : "checked" %>>Limit of maximum idle time of account</td>
<%
        if (flag || ((String)map.get("MAXNOUSEDAYS")).equals("0")) {
%>
          <td width="75" height="22"><input type="text" name="noUseDays" value="90" disabled size ="13"></td>
<%
        }
        else {
%>
          <td width="75" height="22"><input type="text" name="noUseDays" value="<%= (String)map.get("MAXNOUSEDAYS") %>" size ="13"></td>
<%
        }
%>
        </tr>
        <tr class="tr-ring">
          <td height="22" align="right">Confirm password</td>
          <td height="22"><input type="password" name="operConfirm" value="<%= flag ? "" : (String)map.get("OPERPWD") %>" maxlength="20" size ="15"></td>
          <td align="left" height="22"><input type="checkbox" name="userLocked" <%= (! flag) && (((String)map.get("OPERSTATUS")).equals("1") || ((String)map.get("OPERSTATUS")).equals("4")) ? "checked" : "" %> <%= (! flag) && ((String)map.get("OPERSTATUS")).equals("10") ? "disabled" : "" %>>Lock account</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>


        <tr class="tr-ring" >
		    <td align="right" >Operator type</td>
            <td colspan=4>
              <table cellspacing="0" cellpadding="0" class="table-style5" border="0">
               <tr class="tr-ring">
                 <td width=100 align=center ><input type="radio" checked name="serflag" value="0" onclick="onSerFlag()">System administrator</td>
                <td width=100 align=center> <input type="radio" name="serflag" value="1" onclick="onSerFlag()" >SP Administrator</td>
                <td width=100 align=center style=<%= isgroup.equals("1")?"display:block":"display:none" %> >  <input type="radio" name="serflag" value="2" onclick="onSerFlag()" >Group administrator</td>
			<!-- Added for ccs module -->
	        <td width=100 align=center ><input type="radio" checked name="serflag" value="3" onclick="onSerFlag()">CCS administrator</td>
              </tr>
              </table>
            </td>
		</tr>
		<tbody id="id_sp" style="DISPLAY: none">
        <tr class="tr-ring" >
		    <td  align="right">Please select SP</td>
            <td colspan=4 >&nbsp;&nbsp;
              <select name="spindex" style="width:150px" >
              <%  out.print(strOption); %>
              </select>
            </td>
		</tr>

		</tbody>
		<tbody id="id_group" style="DISPLAY: none">
		<tr class="tr-ring" >
		    <td align="right">Please enter a group code</td>
            <td colspan=4>&nbsp;&nbsp;
              <input type="text" name="groupid" value="<%= groupid %>"  maxlength="15" size =20 ></td>
            </td>
		</tr>
        </tbody>
      </table>
    </td>
  </tr>

  <tr>
    <td width="50%" valign="top">
      <table width="100%" border="1" bordercolorlight="#000000" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
        <tr class="table-title1">
          <td height="24" colspan="2">Login time</td>
        </tr>
<%
        String workDay = "";
        if (flag || ((String)map.get("WORKDAY")).equals("1111111"))
            workDay = "1111111";
        else
            workDay = (String)map.get("WORKDAY");
        String begintime = (flag||(String)map.get("BEGINTIME")==null||"999".equals((String)map.get("BEGINTIME")))?"00:00:00":(String)map.get("BEGINTIME");
        String endtime = (flag||(String)map.get("ENDTIME")==null)?"23:59:59":(String)map.get("ENDTIME");
%>
        <tr class="tr-ring">
          <td width="50%" height="22"><input type="radio" name="onLimit" value="0" <%= workDay.equals("1111111") ? "checked" : "" %> onclick="javascript:changeLimit()">Login is allowed at any time</td>
          <td width="50%" height="22"><input type="radio" name="onLimit" value="1" <%= workDay.equals("1111111") ? "" : "checked" %> onclick="javascript:changeLimit()">Login is allowed only in the following time periods</td>
        </tr>
        <tr class="tr-ring">
          <td height="22" align="left">&nbsp;&nbsp;<input type="checkbox" name="sunday"  <%= workDay.equals("1111111") ? "disabled" : "" %> <%= (workDay.substring(0,1)).equals("1") ? "" : "checked" %>>Sunday</td>
          <td height="22" align="left">&nbsp;&nbsp;<input type="checkbox" name="monday"   <%= workDay.equals("1111111") ? "disabled" : "" %> <%= (workDay.substring(1,2)).equals("1") ? "checked" : "" %>>Monday</td>
        </tr>
        <tr class="tr-ring">
          <td height="22" align="left" >&nbsp;&nbsp;<input type="checkbox" name="tuesday"   <%= workDay.equals("1111111") ? "disabled" : "" %> <%= (workDay.substring(2,3)).equals("1") ? "checked" : "" %>>Tuesday</td>
          <td height="22" align="left" >&nbsp;&nbsp;<input type="checkbox" name="wednesday"  <%= workDay.equals("1111111") ? "disabled" : "" %> <%= (workDay.substring(3,4)).equals("1") ? "checked" : "" %>>Wednesday</td>
        </tr>
        <tr  class="tr-ring">
          <td height="22" align="left" >&nbsp;&nbsp;<input type="checkbox" name="thursday"  <%= workDay.equals("1111111") ? "disabled" : "" %> <%= (workDay.substring(4,5)).equals("1") ? "checked" : "" %>>Thursday</td>
          <td height="22" align="left" >&nbsp;&nbsp;<input type="checkbox" name="friday"    <%= workDay.equals("1111111") ? "disabled" : "" %> <%= (workDay.substring(5,6)).equals("1") ? "checked" : "" %>>Friday</td>
        </tr>
        <tr  class="tr-ring">
          <td height="22" align="left" >&nbsp;&nbsp;<input type="checkbox" name="saturday"   <%= workDay.equals("1111111") ? "disabled" : "" %> <%= (workDay.substring(6,7)).equals("1") ? "" : "checked" %>>Saturday</td>
          <td height="22">&nbsp;</td>
        </tr>
        <tr align="center" class="tr-ring">
          <td height="22" colspan="2">From
            <input type="text" name="beginTime" value="<%=begintime%>" <%= workDay.equals("1111111") ? "disabled" : "" %>  class="input-style2">To<input type="text" name="endTime" value="<%=endtime%>" <%= workDay.equals("1111111") ? "disabled" : "" %>  class="input-style2"></td>
        </tr>
      </table>
    </td>
<%
        // 取登录机器IP并分列
        ArrayList allowIP = new ArrayList();
        ArrayList noAllowIP = new ArrayList();
        for (int i = 0; i < list.size(); i++) {
            ipMap = (HashMap)list.get(i);
            if (((String)ipMap.get("ALLOWFLAG")).equals("1"))
                allowIP.add((String)ipMap.get("IPADDR"));
            else
                noAllowIP.add((String)ipMap.get("IPADDR"));
        }
%>
    <td width="50%" valign="top">
      <table width="100%" border="1" bordercolorlight="#000000" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
        <tr class="table-title1">
          <td height="24" colspan="2">Logging machine</td>
        </tr>
        <tr class="tr-ring">
          <td height="22" colspan="2" align="left"><input type="checkbox" name="noIP" onclick="javascript:changeIP()" <%= list.size() > 0 ? "" : "checked" %>>No limit to the logging IP addresses</td>
        </tr>
        <tr class="tr-ring">
          <td height="22" colspan="2">IP address:
            <input type="text" name="ipAddress" disabled class="input-style1"></td>
        </tr>
        <tr align="center" class="tr-ring">
          <td width="50%" height="22" >
            <table width="100%" border="0" class="table-style1">
              <tr align="center" class="tr-ring">
                <td width="50%"><input type="button" name="addAllowIP" value="+" class="button-style3" onclick="javascript:addIP(document.view.allowedIP)"></td>
                <td width="50%"><input type="button" name="delAllowIP" value="-" class="button-style3" onclick="javascript:delIP(document.view.allowedIP)"></td>
              </tr>
            </table>          </td>
          <td width="50%" height="22">
            <table width="100%" border="0" class="table-style1">
              <tr align="center" class="tr-ring">
                <td width="50%"><input type="button" name="addForbidIP" value="+" class="button-style3" onclick="javascript:addIP(document.view.forbidedIP)"></td>
                <td width="50%"><input type="button" name="delForbidIP" value="-" class="button-style3" onclick="javascript:delIP(document.view.forbidedIP)"></td>
              </tr>
            </table>          </td>
        </tr>
        <tr  class="table-title1">
          <td height="22">Enable login</td>
          <td height="22">Disable login</td>
        </tr>
        <tr  class="tr-ring">
          <td height="22">
            <select size="4" name="allowedIP" class="input-style1">
<%
        for (int i = 0; i < allowIP.size(); i++) {
%>
              <option value="<%= (String)allowIP.get(i) %>"><%= (String)allowIP.get(i) %></option>
<%
        }
%>
            </select>          </td>
          <td height="22">
            <select size="4" name="forbidedIP" class="input-style1">
<%
        for (int i = 0; i < noAllowIP.size(); i++) {
%>
              <option value="<%= (String)noAllowIP.get(i) %>"><%= (String)noAllowIP.get(i) %></option>
<%
        }
%>
            </select>          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr align="center">
    <td><input type="button" name="sure" value="OK" class="button-style4" onclick="javascript:onSubmit()"></td>
    <td><input type="button" name="quit" value="Cancel" class="button-style4" onclick="javascript:closeWin()"></td>
  </tr>
</table>
</form>
<script language="javascript">
  // changePwdMustChange();
   changeIP();
</script>
</body>
</html>
<%
    }
    catch (Exception e) {
%>
<html>
<body>
<table border="1" width="100%" bordercolorlight="#000000" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
  <tr>
    <td colspan="2">Error:<%= e.toString() %></td>
  </tr>
</table>
</body>
</html>
<%
    }
%>
