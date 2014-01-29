<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<jsp:useBean id="purview" class="zxyw50.Purview" scope="page"/>

<html>
<head>
<title>Add group</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<base target="_self">
<body topmargin="0" leftmargin="0" class="body-style1"  background="background.gif" >
<%
	//String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
    int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13

    String sysTime = "";
   //add by ge quanmin 3.19
    String usegrpmode = CrbtUtil.getConfig("usegrpmode","0");
    String grouplen = (String)session.getAttribute("GROUPIDLEN")==null?"10":(String)session.getAttribute("GROUPIDLEN");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String ringid = request.getParameter("ringid") == null ? "" : ((String)request.getParameter("ringid")).trim();
    String libid =  request.getParameter("libid") == null ? "503" : ((String)request.getParameter("libid")).trim();
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    //add by wxq 2005.06.08 for version 3.16.01
    String enablegrphallno = CrbtUtil.getConfig("enablegrphallno","1");
    //end
    String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
    String disabled = "";
    String v_groupindex = request.getParameter("groupindex") == null ? "0" :  (String)request.getParameter("groupindex");
    String v_groupid = request.getParameter("groupid") == null ? "" : transferString((String)request.getParameter("groupid")).trim();
    String v_groupname = request.getParameter("groupname") == null ? "" : transferString((String)request.getParameter("groupname")).trim();
    String v_groupphone = request.getParameter("groupphone") == null ? "" : transferString((String)request.getParameter("groupphone")).trim();
    String v_groupaccount = request.getParameter("groupaccount") == null ? "" : transferString((String)request.getParameter("groupaccount")).trim();
    String v_maxtimes = request.getParameter("maxtimes") == null ? "" : transferString((String)request.getParameter("maxtimes")).trim();
    String v_maxrings = request.getParameter("maxrings") == null ? "" : transferString((String)request.getParameter("maxrings")).trim();
    String v_payflag = request.getParameter("payflag") == null ? "" : transferString((String)request.getParameter("payflag")).trim();
    String v_rentfee = request.getParameter("rentfee") == null ? "" : transferString((String)request.getParameter("rentfee")).trim();
    String v_extrafee = request.getParameter("extrafee") == null ? "" : transferString((String)request.getParameter("extrafee")).trim();
    String v_ischeck = request.getParameter("ischeck") == null ? "" : transferString((String)request.getParameter("ischeck")).trim();
    String v_opendate = request.getParameter("opendate") == null ? "" : transferString((String)request.getParameter("opendate")).trim();
    String v_maxmembers = request.getParameter("maxmembers") == null ? "" : transferString((String)request.getParameter("maxmembers")).trim();
    
    //add by wxq 2005.06.08 for version 3.16.01
    String v_serareano = request.getParameter("serareano") == null ? "" : transferString((String)request.getParameter("serareano")).trim();
    String v_hallno = request.getParameter("hallno") == null ? "" : transferString((String)request.getParameter("hallno")).trim();
    String nrentfee = request.getParameter("nrentfee") == null ? "" : request.getParameter("nrentfee");
    //add by ge quanmin 2005.08.10 for version 3.19.01
    String v_managerphone = request.getParameter("managerphone") == null ? "" : transferString((String)request.getParameter("managerphone")).trim();
    String v_exitgrp = request.getParameter("exitgrp") == null ? "1" : transferString((String)request.getParameter("exitgrp")).trim();
    String v_grpmode = request.getParameter("grpmode") == null ? "2" : transferString((String)request.getParameter("grpmode")).trim();



    String showdxinfo =  CrbtUtil.getConfig("showdxinfo","0");
    String msgs = CrbtUtil.getConfig("mobileMsg","\"13\",\"15\"");
    try {
        sysTime = ManGroup.getSysTime() + "--";
         HashMap map = new HashMap();
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String groupindex = request.getParameter("groupindex") == null ? "0" :  (String)request.getParameter("groupindex");
        String newgroupid = request.getParameter("groupid") == null ? "" : transferString((String)request.getParameter("groupid")).trim();
        String groupid = request.getParameter("oldgroupid") == null ? "" : transferString((String)request.getParameter("oldgroupid")).trim();
        String groupname = request.getParameter("groupname") == null ? "" : transferString((String)request.getParameter("groupname")).trim();
        String groupphone = request.getParameter("groupphone") == null ? "" : transferString((String)request.getParameter("groupphone")).trim();
        String groupaccount = request.getParameter("groupaccount") == null ? "" : transferString((String)request.getParameter("groupaccount")).trim();
        String maxtimes = request.getParameter("maxtimes") == null ? "5" : transferString((String)request.getParameter("maxtimes")).trim();
        String maxrings = request.getParameter("maxrings") == null ? "5" : transferString((String)request.getParameter("maxrings")).trim();
        String payflag = request.getParameter("payflag") == null ? "0" : transferString((String)request.getParameter("payflag")).trim();
        String rentfee = request.getParameter("rentfee") == null ? "0" : transferString((String)request.getParameter("rentfee")).trim();
        String extrafee = request.getParameter("extrafee") == null ? "0" : transferString((String)request.getParameter("extrafee")).trim();
        String ischeck = request.getParameter("ischeck") == null ? "0" : transferString((String)request.getParameter("ischeck")).trim();
        String opendate = request.getParameter("opendate") == null ? "" : transferString((String)request.getParameter("opendate")).trim();
        String maxmembers = request.getParameter("maxmembers") == null ? "" : transferString((String)request.getParameter("maxmembers")).trim();
        //add by ge quanmin 2005.08.10 for version 3.19.01
        String managerphone = request.getParameter("managerphone") == null ? "" : transferString((String)request.getParameter("managerphone")).trim();
        String exitgrp = request.getParameter("exitgrp") == null ? "1" : transferString((String)request.getParameter("exitgrp")).trim();
        String grpmode = request.getParameter("grpmode") == null ? "2" : transferString((String)request.getParameter("grpmode")).trim();
        String isSmart = CrbtUtil.getConfig("isSmart", "0");
        String isMobitel = CrbtUtil.getConfig("isMobitel", "0"); 
        Hashtable hash = new Hashtable();
        ArrayList rList  = new ArrayList();
        ManGroup mangroup = new ManGroup();
        if (mode.equals("query")){
          boolean bl_result = purview.checkGroupOperateRight(session,"11-1",v_groupid);
          if (!bl_result){
%>
<script language="javascript">
  //alert('抱歉,您没有权限访问此集团信息!');
  alert('Sorry,you have no access to this group information!');
  window.close();
</script>
<%
          }
          disabled = "disabled";
        }
        if (mode.equals("edit")){
          boolean bl_result = purview.checkGroupOperateRight(session,"11-1",v_groupid);
          if(!bl_result){
%>
<script language="javascript">
  //alert('抱歉,您没有权限访问此集团信息!');
  alert('Sorry,you have no access to this group information!');
  window.close();
</script>
<%
          }
        }
        //        //add by wxq  2005.06.08 for version 3.16.01
//        String serviceKey = (String)session.getAttribute("SERVICEKEY");
//        ArrayList serviceList = purview.getServiceList(serviceKey);
//        String selectedServiceKey = (String)((HashMap)serviceList.get(0)).get("SERVICEKEY");
//        ArrayList paramList = purview.getServiceParamList(selectedServiceKey);   // 权限范围列表
//        map = (HashMap)paramList.get(0);   //业务区查询参数
//        ArrayList paramInfoList = purview.getServiceParamInfo(map);
//        map = new HashMap();
//        map.put("SWHERE","");
//        map.put("PVALUEFIELD","hallno");
//        map.put("PTABLENAME","zxinsys.dbo.ser_pstn51_hall");
//        map.put("PARAMORDER","1");
//        map.put("PCFIELDNAME","营业厅");
//        //返回serareano与hallname字段,用‘@’进行拼接,以方便以后拆分数组时使用
//        map.put("PFIELDNAME"," convert(varchar,serareano)+'@'+hallname");
//        ArrayList hallInfoList = purview.getServiceParamInfo(map);
//        //end
        if(op.equals("add")){
            //            //add by wxq 2005.06.08 for version 3.16.01
//            String serareano = request.getParameter("serareano") == null ? "-1" : transferString((String)request.getParameter("serareano")).trim();
//            String hallno = request.getParameter("hallno") == null ? "-1" : transferString((String)request.getParameter("hallno")).trim();
//            //end

            int optype = 0;
            String  sTmp = "";
            String  title = "";
            map = new HashMap();
            hash.put("groupid",newgroupid);
            hash.put("groupname",groupname);
            hash.put("groupphone",groupphone);
            System.out.println("================>add phone: "+groupphone);
            hash.put("groupaccount",groupaccount);
            hash.put("maxtimes",maxtimes);
            hash.put("maxrings",maxrings);
            hash.put("payflag",payflag);
            hash.put("rentfee",rentfee);
            hash.put("extrafee",extrafee);
            hash.put("ischeck",ischeck);
            //add by ge quanmin 2005.08.10 for version 3.19.01
            hash.put("managerphone",managerphone);
            hash.put("grpmode",grpmode);
            hash.put("exitgrp",exitgrp);
            
            hash.put("maxmembers",maxmembers);
            

           //            //add by wxq 2005.06.08 for version 3.16.01
//            hash.put("serareano",serareano);
//            hash.put("hallno",hallno);
//            //end
            rList = mangroup.addGroup(hash);

            sTmp = sysTime + operName + " add group";
            title = "Add group " + groupname;
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","601");
            map.put("RESULT","1");
            map.put("PARA1",groupindex);
            map.put("PARA2",newgroupid);
            map.put("PARA3",groupname);
            map.put("PARA4",groupaccount);
            map.put("PARA5",rentfee);
            map.put("PARA6",extrafee);
            map.put("DESCRIPTION","Add Group. ip:"+request.getRemoteAddr());
            purview = new zxyw50.Purview();
            purview.writeLog(map);
            sysInfo.add(sTmp);
            String msg = JspUtil.generateResultList(rList);
            if(!msg.equals("")){
                msg = msg.replace('\n',' ');
                throw new Exception(msg);
            }
            %>
            <script language="JavaScript">
                window.returnValue = "yes";
                window.close();
            </script>
        <%
          }
          if (op.equals("edit")){
            hash.put("newgroupid",newgroupid);
            hash.put("groupid",groupid);
            hash.put("groupname",groupname);
            hash.put("groupphone",groupphone);
            hash.put("groupaccount",groupaccount);
            hash.put("maxtimes",maxtimes);
            hash.put("maxrings",maxrings);
            hash.put("payflag",payflag);
            hash.put("rentfee",nrentfee);
            hash.put("extrafee",extrafee);
            hash.put("ischeck",ischeck);
            //add by ge quanmin 2005.08.10 for version 3.19.01
            hash.put("managerphone",managerphone);
            hash.put("grpmode",grpmode);
            hash.put("exitgrp",exitgrp);
            
            hash.put("maxmembers",maxmembers);
            rList = mangroup.editGroup(hash);
            //写操作员日志
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","601");
            map.put("RESULT","1");
            map.put("PARA1",groupindex);
            map.put("PARA2",newgroupid);
            map.put("PARA3",groupname);
            map.put("PARA4",groupaccount);
            map.put("PARA5",rentfee);
            map.put("PARA6",extrafee);
            map.put("DESCRIPTION","Edit Group. ip:"+request.getRemoteAddr());
            purview = new zxyw50.Purview();
            purview.writeLog(map);
            sysInfo.add("Edit group "+groupname+" information success");
            String msg = JspUtil.generateResultList(rList);
            if(!msg.equals("")){
                msg = msg.replace('\n',' ');
                throw new Exception(msg);
            }
%>
<script language="JavaScript">
window.returnValue = "yes";
window.close();
</script>
<%
          }

%>
<script language="JavaScript">
var grouplen = <%= grouplen %>;
   function addInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'add';
      fm.submit();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var  value = "";
      value = trim(fm.groupid.value);
      if (value=='') {
         alert('Please enter a group code!');//请输入集团 code
         fm.groupid.focus();
         return flag;
      }
      if(!checkstring('0123456789',value)){
          alert('The group code can only be a digital string!');//集团 code只能是数字字符串
          fm.groupid.focus();
          return flag;
      }
      if(value.length < grouplen){
          alert('The group code length cannot be larger than 15 bytes and cannot be less than '+grouplen + '-byte. Please re-enter!');
          //alert('集团 code长度最大不得超过15位,最短不得小于'+grouplen + '位,请重新输入!');
          fm.groupid.focus();
          return ;
      }
      value = trim(fm.groupname.value);
      if (value == '') {
         alert('Please enter a group name!');
         fm.groupname.focus();
         return flag;
      }
      if (!CheckInputStr(fm.groupname,'Group name')){
         fm.groupname.focus();
         return  flag;
      }
       <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.groupname.value,40)){
            alert('The group name cannot be more than 40 bytes');//集团名称不得超过40个字节!
            fm.groupname.focus();
            return flag;
          }
        <%
        }
        else{
        %>
         if(strlength(value)>40){
         alert('The group name cannot be more than 40 bytes');//集团名称不得超过40个字节!
         fm.groupname.focus();
         return flag;
      }
 <%}%>

      value = trim(fm.groupphone.value);
      if (!checkstring('0123456789',value)) {
         alert('The contact phone number can only be a digital number');//联系电话只能为数字
         fm.groupphone.focus();
         return flag;
      }
      value = trim(fm.groupaccount.value);
      if (value == '') {
        // alert('请输入集团收费帐号!');
         alert('Please enter the group charge account');
         fm.groupaccount.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The group charge account can only be a digital number');//集团收费帐号只能为数字!
         fm.groupaccount.focus();
         return flag;
      }
      if (value.length <= 7) {
         alert('The group charge account entered is incorrect. Please re-enter!');//集团收费帐号输入不正确,请重新输入!
         fm.groupaccount.focus();
         return flag;
      }
      
/*      
		//海外版本不再检查电话的有效性
      if(!chckPhone(value)){
        // alert('收费帐号即为集团收费电话号码,如果是固定电话则为: 0+区号+电话号码, 请重新输入!');
         alert('The charge acount is a group charge telphone number, if it is a fixed phone ,it should be: 0+ area code+ actual number ,please re-enter!');
         fm.groupaccount.focus();
         return flag;
      }
*/      
          value = trim(fm.rentfee.value);
      if (value == '') {
         alert('Please enter the rental');//请输入月租费用
         fm.rentfee.focus();
         return flag;
      }
     if (!checkstring('0123456789',value)) {
         alert('The rental can only be a digital number');//月租费用只能为数字!
         fm.rentfee.focus();
         return flag;
      }
     <%if (!mode.equals("")){%>
     value = trim(fm.nrentfee.value);
     if (value == '') {
        alert('Please enter the rental for next month');//请输入月租费用
        fm.nrentfee.focus();
        return flag;
     }
    if (!checkstring('0123456789',value)) {
        alert('The rental for next month can only be a digital number');//月租费用只能为数字!
        fm.nrentfee.focus();
        return flag;
     }
    <%}%>
      value = trim(fm.extrafee.value);
      if (value == '') {
         alert('Please enter the additional fee');//请输入附加费!
         fm.extrafee.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The additional fee can only be a digital number');//附加费只能为数字!
         fm.extrafee.focus();
         return flag;
      }
      value = trim(fm.maxtimes.value);
      if (value == '') {
         alert('Please enter the maximum number of time periods');//请输入最大time segment数!
         fm.maxtimes.focus();
         return flag;
      }
     if (!checkstring('0123456789',value)) {
         alert('The maximum number of time periods can only be a digital number');//最大time segment数只能为数字!
         fm.maxtimes.focus();
         return flag;
      }
      value = trim(fm.maxrings.value);
      if (value == '') {
         alert('Please enter the maximum number of ringtones');//请输入最大铃音数量
         fm.maxrings.focus();
         return flag;
      }
     if (!checkstring('0123456789',value)) {
         alert('The maximum number of ringtones can only be a digital number');//最大铃音数量只能为数字
         fm.maxrings.focus();
         return flag;
      }
      value= trim(fm.managerphone.value);
      if (!checkstring('0123456789',value)) {
         alert('the manager phone can only be a digit!');//管理员电话只能为数字!
         fm.managerphone.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   //检查电话号码输入是否正确 (固定电话必须要有0)
   function chckPhone (value) {
      var fm = document.inputForm;
      var phone = trim(value);
      var c;
      var d;
      d = phone.substring(0,1);
      c = phone.substring(0,2);
      var f = isMobile(phone);
      if( f=='true' && d!='0' )
         return false;
      return true;
   }
function ok(){
  addInfo();
}
function edit(){
  var fm = document.inputForm;
  if (! checkInfo()){
    return;
  }
  fm.op.value = 'edit';
  fm.submit();
}
function cancel(){
  window.returnValue = "no";
  window.close();
}
</script>

<form name="inputForm" method="post" action="grpInfoAdd.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldgroupid" value="<%=v_groupid%>"/>
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
    <td>
      <br><br>
      <table  width="100%"  border="0">
      <tr>
          <td width="100%" align="center" valign="middle">
              <div id="hintContent" >
      <table border="0" align="center" class="table-style2">
         <tr>
          <td height="22" align="left" valign="middle" width="35%" >Group code</td>
          <td height="22" valign="middle" width="65%" ><input <%=disabled%> type="text" name="groupid" value="" maxlength="<%=grouplen%>" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="middle">Group name</td>
          <td height="22" valign="middle"><input <%=disabled%> type="text" name="groupname" value="" maxlength="40" class="input-style1"></td>
        </tr>
<%if (mode.equals("edit") || mode.equals("query")){%>
        <tr>
          <td height="22" align="left" valign="middle">Open account date</td>
          <td><input type="text" name="opendate" value=""  maxlength="10" class="input-style1" disabled ></td>
        </tr>

<%}%>
<%if (mode.equals("query")){ %>
        <tr>
          <td height="22" align="left" valign="middle">Service area code</td>
          <td height="22" valign="middle"><input <%=disabled%> type="text" name="serareano" value="" maxlength="40" class="input-style1"></td>
        </tr>
        <tr <%= enablegrphallno.equals("1") ? "" : "style=\"display:none\"" %>>
          <td height="22" align="left" valign="middle">Business hall no</td>
          <td height="22" valign="middle"><input <%=disabled%> type="text" name="hallno" value="" maxlength="40" class="input-style1"></td>
        </tr>
<%} %>
        <tr>
          <td height="22" align="left" valign="middle">Contact number</td>
          <td height="22" valign="middle"><input <%=disabled%> type="text" name="groupphone" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr >
          <td height="22" align="left"  valign="middle" >Charge account</td>
          <td height="22" valign="middle"><input <%=disabled%> type="text" name="groupaccount"   value="" maxlength="20" class="input-style1"  ></td>
        </tr>
        <tr>
            <td align="left"  height="22" >Payment mode</td>
            <td >
            <table border="0" width="70%" class="table-style2">
             <%
            if(isMobitel.equals("1"))
              {
               %>

              <tr align="left">
                <td width="50%"><input <%=disabled%> type="radio" checked name="payflag" value="0">Allow user to modify properties payed by User</td>
              </tr>
              <tr>  
                <td width="50%"><input <%=disabled%> type="radio" name="payflag" value="1">Not allow user to modify properties payed by Group</td>
              </tr>
             <%
              }
             else
             {
              %>
                   <tr align="left">
                <td width="50%"><input <%=disabled%> type="radio" checked name="payflag" value="0">Personal charge</td>
              </tr>
              <tr>  
                <td width="50%"><input <%=disabled%> type="radio" name="payflag" value="1">Group charge</td>
              </tr>
            <%
             }
            if(isSmart.equals("1"))
            {
            %>
             	  <tr>
			      <td width="50%"><input <%=disabled%> type="radio" name="payflag" value="2">Group fixed rent</td>
	         </tr>
           <%
            }
            %>
            </table>
          </td>
        </tr>
        <tr>
           <td align="left"  height="22" >Monthly rental(<%=minorcurrency%>)</td>
          <td><input <% if(!mode.equals("")){%>disabled<% }else{%>""<%}%> type="text" name="rentfee" value="" maxlength="9" class="input-style1"  ></td>
        </tr>
        <%if (!mode.equals("")){%>
        <tr>
           <td align="left">rental for the next month (<%=minorcurrency%>)</td>
          <td><input type="text" name="nrentfee" value="" maxlength="9" class="input-style1" <%=disabled%> ></td>
        </tr>
        <%}%>
        <tr>
           <td align="left"  height="22" >Additional fee (<%=minorcurrency%>)</td>
          <td><input <%=disabled%> type="text" name="extrafee" value="" maxlength="9" class="input-style1"></td>
        </tr>
        <tr>
            <td align="left"  height="22" >Maximum number of<br>time periods</td>
           <td><input <%=disabled%> type="text" name="maxtimes" value="" maxlength="2" class="input-style1"></td>
        </tr>
        <tr>
            <td align="left"  height="22" >Maximum number of<br>members</td>
           <td><input <%=disabled%> type="text" name="maxmembers" value="" maxlength="5" class="input-style1"></td>
        </tr>
		<tr>
            <td align="left"  height="22" >Maximum number<br>of ringtones</td>
           <td><input <%=disabled%> type="text" name="maxrings" value="" maxlength="2" class="input-style1"></td>
        </tr>
        <tr>
          <td align="left"  height="22" >Verify ringtone or not</td>
          <td>
            <table border="0" width="70%" class="table-style2">
              <tr align="left">
                <td width="50%"><input <%=disabled%> type="radio" checked name="ischeck" value="0">No</td>
                <td width="50%"><input <%=disabled%> type="radio" name="ischeck" value="1">Yes</td>
              </tr>
            </table>
          </td>
        </tr>
         <tr>
          <td height="22" align="left" valign="middle">Manager phone</td>
          <td height="22" valign="middle"><input <%=disabled%> type="text" name="managerphone" value="" maxlength="20" class="input-style1"></td>
        </tr>
         <tr>
          <td align="left"  height="22" >Permit person exit group</td>
          <td>
            <table border="0" width="70%" class="table-style2">
              <tr align="left">
                <td width="50%"><input <%=disabled%> type="radio" checked name="exitgrp" value="0">No</td>
                <td width="50%"><input <%=disabled%> type="radio" name="exitgrp" value="1">Yes</td>
              </tr>
            </table>
          </td>
        </tr>
        <% String typeDisplay = "none";
         if("1".equals(usegrpmode))
           typeDisplay = "";
        %>
          <tr style="display:<%= typeDisplay %>">
          <td align="left"  height="22" >Group mode</td>
          <td>
            <table border="0" width="70%" class="table-style2">
              <tr align="left">
                <td width="50%"><input <%=disabled%> type="radio" name="grpmode" value="1">"a" Mode</td>
                <td width="50%"><input <%=disabled%> type="radio" checked name="grpmode" value="2">"b" Mode</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
              </div>
          </td>
      </tr>
<%if(!mode.equals("query")){ %>
      <tr>
          <td width="100%" align="center" height="16" >
            <%if(mode.equals("edit")){%>
              <img src="button/edit.gif" alt="Edit" onmouseover="this.style.cursor='hand'" onclick="javascript:edit()" >
            <%}else{ %>
              <img src="button/sure.gif" alt="Confirm" onmouseover="this.style.cursor='hand'" onclick="javascript:ok()" >
            <%} %>
                &nbsp;&nbsp;
              <img src="button/cancel.gif" alt="Cancel" onmouseover="this.style.cursor='hand'" onclick="javascript:cancel()" >
        </td>
          </tr>
      <tr >
          <td>
           <table border="0" width="90%" class="table-style2" align="center">
              <tr>
               <td>Notes:</td>
              </tr>
              <%if("1".equals(showdxinfo)){%>
              <tr>
               <td >&nbsp;1. The group code can only be a digital string with a length of <%=grouplen%>-byte;</td>
              </tr>
              <tr>
               <td >&nbsp;2. The group code be 1+area code+group code with the length of six;</td>
              </tr>
              <tr>
               <td >&nbsp;3. Charge account is invalid in this system.</td>
              </tr>
              <tr>
               <td >&nbsp;4. The fee's modification will take effect in  next month;</td>
              </tr>
              <tr>
               <td >&nbsp;5.You can modify next month rent by modify rental.</td>
              </tr>
        <%}else{%>
              <tr>
               <td >&nbsp;1.The group code can only be a digital number,it cannot be more than 15 bytes,and cannot be less than  <%=grouplen %>-byte</td>
              </tr>
              <tr>
               <td >&nbsp;2.The charge account refers to a charge telephone number of group.For the fixed phone,it should be 0+area code+phone number.</td>
              </tr>
              <tr>
               <td >&nbsp;3. The fee's modification will take effect in  next month; </td>
              </tr>
              <tr>
               <td >&nbsp;4. You can modify next month rent by modify rental.</td>
              </tr>
        <%}%>
       </table>
   </td>
  </tr>
<%}else{ %>
  <tr>
    <td width="100%" align="center" height="16" >
      <img src="button/back.gif" alt="Back" onmouseover="this.style.cursor='hand'" onclick="javascript:window.close();" >
    </td>
  </tr>
<%} %>
</table>
</form>
<%if (mode.equals("query") || mode.equals("edit")){ %>
<script language="JavaScript">
  var fm = document.inputForm;
  fm.groupid.value = '<%=v_groupid%>';
  fm.groupname.value = '<%=v_groupname%>';
  fm.opendate.value = '<%=v_opendate%>';
  <%if (mode.equals("query")){%>
  var ss = '<%=v_serareano%>';
  var hh = '<%=v_hallno%>';
  if (ss == -1){
    ss = 'No divide';
  }
  if (hh == -1){
    hh = 'No divide';
  }
  fm.serareano.value = ss;
  fm.hallno.value = hh;
  <%}%>
  fm.groupphone.value = '<%=v_groupphone%>';
  fm.groupaccount.value = '<%=v_groupaccount%>';

  fm.payflag['<%=v_payflag%>'].checked = true;
  fm.rentfee.value = '<%=v_rentfee%>';
  fm.nrentfee.value = '<%=nrentfee%>';
  fm.extrafee.value = '<%=v_extrafee%>';
  fm.maxtimes.value = '<%=v_maxtimes%>';
  fm.maxrings.value = '<%=v_maxrings%>';
  
  fm.maxmembers.value = '<%=v_maxmembers%>';
  
  fm.ischeck['<%=v_ischeck%>'].checked = true;
  fm.managerphone.value = '<%=v_managerphone%>';
  fm.exitgrp['<%=v_exitgrp%>'].checked = true;
  fm.grpmode['<%=Integer.parseInt(v_grpmode) - 1%>'].checked = true;

</script>
<%} %>
<%
    }
    catch(Exception e) {

        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in adding group!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in editting ringtone!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
   alert("Exception occurred in editting ringtone <%= ringid%> :<%= e.getMessage() %>");
   window.close();
</script>
<%
    }
%>
</body>
</html>
