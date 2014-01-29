<%@ page import="java.util.Vector" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="com.zte.socket.imp.manager.PoolManager" %>
<%@ page import="zte.zxyw50.util.WebUtils" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="com.zte.tao.util.*" %>
<%@ page import="com.zte.tao.config.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.ywaccess" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body class="body-style1" background="image/bac.gif" >
<%
    String langcfg[] =TaoUtil.getLangPool();
    //if(request.getSession().getAttribute("ZteCrbtLocale")==null){
    Locale locale=new Locale("en","");

	WebUtils.setCookie( response,"ZteCrbtLocale",locale.toString());
	WebUtils.setLocale((HttpServletRequest) request, (HttpServletResponse) response, locale);
    //}
    String operID = (String)session.getAttribute("OPERID")==null?"":(String)session.getAttribute("OPERID");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	Purview purview = new Purview();
    //Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
	Hashtable sysfunction = new Hashtable();
   	String managertype = (String)session.getAttribute("OPERATORTYPE");
   	if(!"manager".equals(managertype) )
   	{
   		purviewList.clear();
   		session.invalidate();
   		operID = "";
   	}

        // usertypecharge 08.02.20 4.12.02
        boolean userTypeCharge = false;
        String chargemode ="1";
        if(chargemode!=null&&chargemode.trim().equals("1"))
        {
         userTypeCharge =true;
        }

%>

<script language="javascript">

function isshow(aa)
{
	for (var i=1;i<=7;i++)
   	{
    	if( ("content"+i)!=aa)
	   	{
        	document.getElementById("content"+i).style.display="none";
	   	}
   	}

	if (document.getElementById(aa).style.display=='none')
    {
        document.getElementById(aa).style.display='';
    }
	else
    {
       document.getElementById(aa).style.display='none';
    }
}

   function refresh () {
      document.location.href = 'menu.jsp';
   }

   var currentid="";
   var lastid="";
   function f_changeColor(id){
     lastid=currentid;
     currentid=id;

     var objC  = eval("" + currentid);
     objC.style.color="red";


 	 if(lastid!=currentid)
 	 {
 	 	if(lastid=="")
 	 		return;
     	var objL = eval("" + lastid);
     	objL.style.color="gray";
	 }
   }

</script>
<form name="inputForm" method="get" action="">
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="182"><img src="../image/home_r1_c1.gif" width="182" height="102"></td>
    <td background="../image/home_r1_cm.gif" width="576"><img src="../image/home_r1_cm.gif" width="576" height="102"></td>
  </tr>
</table>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td background="image/home_r2_c1.gif" width="8"><img src="image/home_r2_c1.gif" width="8" height="38"></td>
    <td valign="top" width="170" background="image/home_r10_c2bg.gif">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
          <td background="image/ab.gif" height="24" valign="bottom">
            <div align="left">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2" onClick="<%= operID.length()==0?"":"javascript:isshow('content1')" %>" onMouseOver="this.style.cursor='pointer'">
                <tr>
                  <td width="0"></td>
                  <td height="20" valign="bottom"><font class="font-man"><b><%//=colorName %>&nbsp;&nbsp;&nbsp;&nbsp;Subscriber Management</b></font>
                  </td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
              <table id='content1' width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" background="image/home_r6_c2.gif" style="DISPLAY:none">
<%
		if (purviewList.get("1-4") != null ||  purviewList.get("1-5") != null || purviewList.get("1-1") != null || purviewList.get("1-2") != null||purviewList.get("1-3") != null) {
%>
				<tr>
                  <td width="100%"><img src="image/ac.gif" width="170" height="14"></td>
                </tr>
<%
        }
		if (purviewList.get("1-4") != null ) {
%>
                      <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  	<a href="cardUse.jsp" target="main" ><font class="font" onclick="f_changeColor('td0104')" id="td0104"><img src="image/n-8.gif" width="8" height="8" border="0"><span title=" Open account">&nbsp;Open account</span></font></a></td>
                </tr>
                      <%
        }
        if (purviewList.get("1-5") != null) {
%>
               <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
           				<a href="cardErase.jsp" target="main"><font class="font" onclick="f_changeColor('td0105')" id="td0105"><img src="image/n-8.gif" width="8" height="8" border="0"><span title=" close account">&nbsp;Close account</span></font></a></td>
                </tr>
           <%
        }
        if (purviewList.get("1-1") != null) {
%>
                      <tr>
                        <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                        <a href="changePassword.jsp" target="main"><font class="font"  onclick="f_changeColor('td0101')" id="td0101"><img src="image/n-8.gif" width="8" height="8" border="0"><span title="modify subscriber's password">&nbsp;Modify Password</span></font></a></td>
                      </tr>
                      <%
        }
        if (purviewList.get("1-2") != null) {
%>
                      <tr>
                        <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                        <a href="userRing.jsp" target="main" title="listen subscriber's ringtone"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0102')" id="td0102">&nbsp;Subscriber ringtone</font></a></td>
                      </tr>
                      <%
        }if(purviewList.get("1-3") !=null){
%>
					<tr>
                        <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                        <a href="UserInfo.jsp" target="main" title="modify subscriber's profile"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0103')" id="td0103">&nbsp;Modify profile</font></a></td>
                      </tr>
<%
         //add 3.23
         }if(purviewList.get("1-15") !=null){
%>
                    <tr>
                        <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                        <a href="UserPointsInfo.jsp" target="main" title="query subscriber's points"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0115')" id="td0115">&nbsp;Query points</font></a></td>
                    </tr>
<%
}if(purviewList.get("1-6") !=null){
%>
					<tr>
                        <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                        <a href="userRingConf.jsp" target="main" title="query user-set ringtone"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0106')" id="td0106">&nbsp;Query User-set</font></a></td>
                      </tr>
<%
}
if(purviewList.get("1-7") !=null){
%>
					<tr>
                        <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                        <a href="userBroadcast.jsp" target="main" title="Operation AD broadcast"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0107')" id="td0107">&nbsp;Advertisement</font></a></td>
                      </tr>
<%
}
if(purviewList.get("1-8") !=null ){
%>
					<tr>
                        <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                        <a href="userBlack.jsp" target="main" title="relieve the user from blacklist"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0108')" id="td0108">&nbsp;Relieve blacklist</font></a></td>
                      </tr>
<%
}
if(purviewList.get("1-9") != null){
%>
<tr>
                        <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                        <a href="openblacklist.jsp" target="main" title="Blacklist management"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0109')" id="td0109">&nbsp;Open Blacklist</font></a></td>
 </tr>
<%
}
if(purviewList.get("1-14") != null){
%>
<tr>
<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
<a href="speciallist.jsp" target="main" title="management of special list"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0114')" id="td0114">&nbsp;Special list manager</font></a></td>
 </tr>
<%
}
if(purviewList.get("1-10") != null){
%>
<tr>
<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
<a href="batchopenaccount.jsp?op=first" target="main" title="batch account opening"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0110')" id="td0110">&nbsp;Batch open account</font></a></td>
 </tr>
<%
}
if(purviewList.get("1-11") != null){
%>
<tr>
<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
<a href="batchcloseaccount.jsp?op=first" target="main" title="Batch account close"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0111')" id="td0111">&nbsp;Batch close account </font></a></td>
 </tr>
<%
}
if(purviewList.get("1-13") !=null ){
%>
					<tr>
                        <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                        <a href="cardActive.jsp" target="main" title="Subscriber activate/suspend"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0113')" id="td0113">&nbsp;Activate / Suspend</font></a></td>
                      </tr>
<%
}if(purviewList.get("1-16") !=null ){
%>
					<tr>
                        <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                        <a href="marketCount.jsp" target="main" title="Short Message marketing activity"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0116')" id="td0116">&nbsp;SMS sale activity</font></a></td>
                      </tr>
<%
}if(purviewList.get("1-17") !=null ){////Batch donating service
%>
		<tr>
                   <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                   <a href="batchDonateService.jsp?op=first" target="main" title="Batch gift service"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0117')" id="td0117">&nbsp;Batch gift service</font></a></td>
                </tr>
<%
}if(purviewList.get("1-18") !=null ){////Gift period management
%>
		<tr>
                   <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                   <a href="editPresentDay.jsp" target="main" title="Donation period  management"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0118')" id="td0118">&nbsp;Gift Duration</font></a></td>
                </tr>
<%
}if(purviewList.get("1-19") !=null ){//Batch Open or Cancel account forcely
%>
		<tr>
                   <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                   <a href="batchOpenForce.jsp?op=first" target="main" title="Gift period management"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0119')" id="td0119">&nbsp;Batch Open or Cancel<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;account forcely</font></a></td>
                </tr>
<%}%>

<%
if(purviewList.get("1-20") !=null){//Special User
%>
		<tr>
                   <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                   <a href="specialUser.jsp" target="main" title="Specail User"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0120')" id="td0120">&nbsp;Special User</font></a></td>
                </tr>
<%}
if(purviewList.get("1-51") != null){%>
	<tr>
       <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
       <a href="retailerlist.jsp" target="main" title="Retail List Management"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0149')" id="td0149">&nbsp;Retailer list</font></a></td>
 </tr>
<%}
if(purviewList.get("1-54") !=null){//Feed Back
%>
		<tr>
                   <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                   <a href="FeedbackInfo.jsp" target="main" title="Feedback"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0154')" id="td0154">&nbsp;Feed Back</font></a></td>
                </tr>
<%}%>
	<% if(purviewList.get("1-55") !=null ){ //OBD Feature%>	
		 <tr>
			<td width="100%">
				<img src="folder/line.gif"><img src="folder/lastblk.gif">
				<a href="OBDManage.jsp" target="main" title="Ring On Demand Conf">
					<img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0155')" id="td0155">&nbsp;OBD Manage</font>
				</a>
			</td>
                </tr>
<%}%>

                <tr>
                  <td width="100%"><img src="image/ad.gif" width="170" height="7"></td>
                </tr>
               </table>
              <img src="image/ae.gif" width="170" height="13"></div>
          </td>
        </tr>
      </table>

	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2">
        <tr>
          <td background="image/ab.gif" height="24" valign="bottom">
            <div align="left">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2" onClick="<%= operID.length()==0?"":"javascript:isshow('content2')" %>" onMouseOver="this.style.cursor='hand'">
                <tr>
                  <td width="20">&nbsp;</td>
                  <td height="20" valign="bottom"><font class="font-man"><b>Manual service</b></font>
                  </td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
              <table id='content2' width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" background="image/home_r6_c2.gif" style="DISPLAY:none">
<%
		if (purviewList.get("13-1") != null ||  purviewList.get("13-2") != null || purviewList.get("13-3") != null || purviewList.get("13-4") != null||purviewList.get("13-5") != null||purviewList.get("13-6") != null||purviewList.get("13-7") != null||purviewList.get("13-8") != null) {
%>
		   <tr>
         	<td width="100%"><img src="image/ac.gif" width="170" height="14"></td>
         </tr>
<%
        }
		if (purviewList.get("13-1") != null) {
%>
         <tr>
           	<td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif"><img src="image/n-8.gif" width="8" height="8" border="0">
           	<a href="manualSvc/cardOpen.jsp" target="main" title="open an account by operator"><font class="font" onclick="f_changeColor('td1301')" id="td1301">&nbsp;Account opening</font></a></td>
         </tr>
                      <%
        }
        if (purviewList.get("13-2") != null) {
%>
         <tr>
         	<td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif"><img src="image/n-8.gif" width="8" height="8" border="0">
         	<a href="manualSvc/cardErase.jsp" target="main" title="close an account by operator"><font class="font" onclick="f_changeColor('td1302')" id="td1302">&nbsp;Account cancellation</font></a></td>
         </tr>
           <%
        }
        if (purviewList.get("13-3") != null) {
%>
         <tr>
            <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
            <a href="manualSvc/cardActive.jsp" target="main" title="Activate/Deactivate subscriber"><font class="font" onclick="f_changeColor('td1303')" id="td1303"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Activate/Deactivate</font></a></td>
         </tr>
                      <%
        }
        //3.23
        if(purviewList.get("13-18") !=null){
%>
        <tr>
        		<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
        		<a href="manualSvc/UserPointsInfo.jsp" target="main" title="query user's usage"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1318')" id="td1318">&nbsp;User usage query</font></a></td>
        </tr>
<%
        }
        if(purviewList.get("13-8") !=null){
%>
			<tr>
         	<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
         	<a href="manualSvc/collectRing.jsp" target="main" title="user order ringtones by operator"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1308')" id="td1308">&nbsp;Order ringtones
					</font></a></td>
         </tr>
<%
}if((purviewList.get("13-15") !=null)){
%>
			<tr>
             <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
             <a href="manualSvc/sysringgroup.jsp?grouptype=1" target="main" title="user order musicbox by operator"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1315')" id="td1315">&nbsp;Order
					</font></a></td>
         </tr>
<%
}if((purviewList.get("13-15") !=null)){
%>
			<tr>
             <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
             <a href="manualSvc/sysringgroup.jsp?grouptype=2" target="main" title="user order by operator"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1395')" id="td1395">&nbsp;Order GiftBag
					</font></a></td>
         </tr>
<%
}        if(purviewList.get("13-9") !=null){
%>
			<tr>
         	<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
         	<a href="manualSvc/userRing.jsp" target="main" title="manage user's ringtone library"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1309')" id="td1309">&nbsp;ringtone library
					</font></a></td>
         </tr>
<%
}
if(purviewList.get("13-10") !=null){
%>
			<tr>
            <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
            <a href="manualSvc/ringGroup.jsp" target="main" title="manage user's ringtone group"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1310')" id="td1310">&nbsp;ringtone group
					</font></a></td>
         </tr>
<%
}if(purviewList.get("13-14") !=null){
%>
			<tr>
         	<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
         	<a href="manualSvc/ringConfig.jsp" target="main" title="manager user's personal setting"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1314')" id="td1314">&nbsp;Personal setting
					</font></a></td>
         </tr>
<%
}if(purviewList.get("13-4") !=null){
%>
  			<tr>
            <td width="100%" height="19"><img src="folder/line.gif"><img src="folder/lastblk.gif">
            <a href="manualSvc/defaultRing.jsp" target="main" title="manage user's default ringtone setting"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1304')" id="td1304">&nbsp;Default setting</font></a></td>
         </tr>
<%
}if(purviewList.get("13-5") !=null){
%>
			<tr>
            <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
            <a href="manualSvc/timeRing.jsp" target="main" title="manager user's time period  setting"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1305')" id="td1305">&nbsp;Time period </font></a></td>
         </tr>
<%
}if(purviewList.get("13-6") !=null){
%>
			<tr>
            <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
            <a href="manualSvc/dateRing.jsp" target="main" title="manager user's commemoration day setting"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1306')" id="td1306">&nbsp;Commemoration day</font></a></td>
         </tr>
<%
}if(purviewList.get("13-11") !=null){
%>
			<tr>
            <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
            <a href="manualSvc/phoneGroup.jsp" target="main" title="manager user's number group setting"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1311')" id="td1311">&nbsp;Numbers group</font></a></td>
         </tr>
<%
}if(purviewList.get("13-12") !=null ){
%>
			<tr>
            <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
            <a href="manualSvc/monthRing.jsp" target="main" title="manager user's month ringtone setting"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1312')" id="td1312">&nbsp;Month ringtone</font></a></td>
         </tr>
<%
}if(purviewList.get("13-13") !=null){
%>
			<tr>
            <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
            <a href="manualSvc/weekRing.jsp" target="main" title="manager user's week ringtone setting"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1313')" id="td1313">&nbsp;Week ringtone</font></a></td>
         </tr>
<%
}
if(purviewList.get("13-19") != null){
%>
<tr>
<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
<a href="manualSvc/speciallist.jsp" target="main" title="special list management"><img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td1319')" id="td1319">&nbsp;Special list manager</font></a></td>
 </tr>
<%
}
%>
<%if(purviewList.get("13-16") !=null){%>
                                      <tr>
                  <td width=100%><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="quryUserOpera.jsp?type=1" target="main" title="Subscriber ringtone operation query"><font class="font" onclick="f_changeColor('td1316')" id="td1316"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;ringtone operation</font></a></td>
                </tr>
 <%}%>
 <%if(purviewList.get("13-17") !=null && sysfunction.get("13-17-0")== null){%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="quryUserAction.jsp?type=1" target="main" title="Subscriber state operation query"><font class="font" onclick="f_changeColor('td1317')" id="td1317"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;State operation</font></a></td>
                </tr>
                <%}%>

                <tr>
                  <td width="100%"><img src="image/ad.gif" width="170" height="7"></td>
                </tr>
               </table>
              <img src="image/ae.gif" width="170" height="13"></div>
          </td>
        </tr>
      </table>

     <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
          <td background="image/ab.gif" height="24" valign="bottom">
            <div align="left">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2" onClick="<%= operID.length()==0?"":"javascript:isshow('content3')" %>" onMouseOver="this.style.cursor='pointer'">
                <tr>
                  <td width="5">&nbsp;</td>
                  <td valign="bottom" height="20"><font class="font-man"><b>ringtones management</b></font>
                    </td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
       
        <tr>
          <td>
            <div align="center">
              <table id='content3' width="100%" cellspacing="0" cellpadding="0" class="table-style2" background="image/home_r6_c2.gif" style="DISPLAY:none">
<%
if (purviewList.get("3-9") != null || purviewList.get("3-1") != null || purviewList.get("3-2") != null ||purviewList.get("3-3") != null ||purviewList.get("3-4") != null ||purviewList.get("3-5") != null ||purviewList.get("3-6") != null ||purviewList.get("3-7") != null ||purviewList.get("3-8") != null || purviewList.get("3-10") != null || purviewList.get("3-11") != null || purviewList.get("3-15") != null)  {
%>
				<tr>
                  <td width="100%"><img src="image/ac.gif" width="170" height="14"></td>
                </tr>
                <%}
        if (purviewList.get("3-9") != null && sysfunction.get("3-9-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="IpInfo.jsp" target="main" title="IP management">
                  <font class="font" onclick="f_changeColor('td0309')" id="td0309"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;IP</font></a></td>
                </tr>
                <%
        }if (purviewList.get("3-33") != null && sysfunction.get("3-33-0")== null) {%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
				  <a href="msinfo.jsp" target="main" title="Ms management">
				  <font class="font" onclick="f_changeColor('td0333')" id="td0333"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;MS</font></a></td>
                </tr>
        <%}
 if (purviewList.get("3-21") != null && sysfunction.get("3-21-0")== null){
%>
                <!--add by wxq 2005.06.09 for version 3.16.01-->
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="hallInfo.jsp" target="main" title="business hall management">
                  <font class="font" onclick="f_changeColor('td0321')" id="td0321"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Business hall </font></a></td>
                </tr>
                <!--add end-->
<%
        }
        if (purviewList.get("3-1") != null && sysfunction.get("3-1-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="mrb.jsp" target="main" title="MRB management">
                  <font class="font" onclick="f_changeColor('td0301')" id="td0301"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;MRB</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("3-2") != null && sysfunction.get("3-2-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="hlr.jsp" target="main" title=" prefix management">
                  <font class="font"	onclick="f_changeColor('td0302')" id="td0302"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Prefix</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("3-15") != null && sysfunction.get("3-15-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="serviceArea.jsp" target="main" title="manage service areas">
                  <font class="font" onclick="f_changeColor('td0315')" id="td0315"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Service areas</font></a></td>
                </tr>

<%
        }
        if (purviewList.get("3-16") != null && sysfunction.get("3-16-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="areaHlr.jsp" target="main" title="service area number prefix management">
                  <font class="font" onclick="f_changeColor('td0316')" id="td0316"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Servicearea no. prefix</font></a></td>
                </tr>

<%
        }
        if (purviewList.get("3-3") != null && sysfunction.get("3-3-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="sp.jsp" target="main" title="SP management">
                  <font class="font" onclick="f_changeColor('td0303')" id="td0303"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("3-49") != null && sysfunction.get("3-49-0")== null) {
        	%>
        	                <tr>
        	                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
        	                  <a href="spPhoneNum.jsp" target="main" title="SP phone numbers management">
        	                  <font class="font" onclick="f_changeColor('td0349')" id="td0349"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP phone management</font></a></td>
        	                </tr>
        	                <%
        	        }
        if (purviewList.get("3-4") != null && sysfunction.get("3-4-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="area.jsp" target="main" title="calling service area management">
                  <font class="font" onclick="f_changeColor('td0304')" id="td0304"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Calling service area</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("3-5") != null && sysfunction.get("3-5-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="userType.jsp" target="main" title="manage user types">
                  <font class="font" onclick="f_changeColor('td0305')" id="td0305"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User types</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("3-38") != null&& userTypeCharge && sysfunction.get("3-38-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="userTypeCharge.jsp" target="main" title="manage user charge types">
                  <font class="font" onclick="f_changeColor('td0338')" id="td0338"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User charge types</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("3-6") != null && sysfunction.get("3-6-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="editDayCapacity.jsp" target="main" title="number of daily distributed numbers">
                  <font class="font" onclick="f_changeColor('td0306')" id="td0306"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Daily distributed</font></a></td>
                </tr>
                <%
        }
         if (purviewList.get("3-28") != null && sysfunction.get("3-28-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="editSpRingnum.jsp" target="main" title="newest ringtone quantity of each SP ringtone">
                  <font class="font" onclick="f_changeColor('td0328')" id="td0328"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP newest quantity</font></a></td>
                </tr>

<%}
        if (purviewList.get("3-7") != null && sysfunction.get("3-7-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="addTime.jsp" target="main" title="account opening time constraints">
                  <font class="font" onclick="f_changeColor('td0307')" id="td0307"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Open time</font></a></td>
                </tr>
              <%
       }
        if (purviewList.get("3-8") != null && sysfunction.get("3-8-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="ringCensor.jsp" target="main" title="manage ringtone verification criteria">
                  <font class="font" onclick="f_changeColor('td0308')" id="td0308"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;ringtone audit</font></a></td>
                </tr>
  <%}if (purviewList.get("3-23") != null && sysfunction.get("3-23-0")== null) {%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="musicParaSet.jsp" target="main" title="parameter of system ringtone group">
                  <font class="font" onclick="f_changeColor('td0323')" id="td0323"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Ringgroup param.</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("3-10") != null && sysfunction.get("3-10-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="callPrefix.jsp" target="main" title="call prefix management">
                  <font class="font" onclick="f_changeColor('td0310')" id="td0310"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Call prefix</font></a></td>
                </tr>

                <%
        }
        if (purviewList.get("3-11") != null && sysfunction.get("3-11-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="gtConfig.jsp" target="main" title="MSC GT contraints management">
                  <font class="font"	onclick="f_changeColor('td0311')" id="td0311"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;MSC GT contraints</font></a></td>
                </tr>

<%
        }
        if (purviewList.get("3-12") != null && sysfunction.get("3-12-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="attendant.jsp" target="main" title="operator management">
				  <font class="font" onclick="f_changeColor('td0312')" id="td0312"><img src="image/n-8.gif" width="8" height="8" border="0">Operator management</font></a></td>
                </tr>

<%
        }
         if (purviewList.get("3-13") != null && sysfunction.get("3-13-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="areaprefix.jsp" target="main" title="incoming/outgoing prefix management">
                  <font class="font"	onclick="f_changeColor('td0313')" id="td0313"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Incoming/outgoing</font></a></td>
                </tr>

<%
        }
        if (purviewList.get("3-14") != null && sysfunction.get("3-14-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="calledarea.jsp" target="main" title="Called service area management">
                  <font class="font"	onclick="f_changeColor('td0314')" id="td0314"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Called service area</font></a></td>
                </tr>

<%
        }
        if (purviewList.get("3-17") != null && sysfunction.get("3-17-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="setFuncFee.jsp" target="main" title="Configure paid items">
                  <font class="font"	onclick="f_changeColor('td0317')" id="td0317"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Configure paid items</font></a></td>
                </tr>

<%
        }
        if (purviewList.get("3-18") != null && sysfunction.get("3-18-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="spbulletin.jsp" target="main" title="manage bulletin info">
                  <font class="font" onclick="f_changeColor('td0318')" id="td0318"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Bulletin info</font></a></td>
                </tr>

<%
        }
        if (purviewList.get("3-19") != null && sysfunction.get("3-19-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="ringIDPrefix.jsp" target="main" title="manage ringtone ID prefix">
                  <font class="font"	onclick="f_changeColor('td0319')" id="td0319"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;ringtone ID prefix</font></a></td>
                </tr>
<%
        }
        if (purviewList.get("3-22") != null && sysfunction.get("3-22-0")== null){
%>                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="grpRingIDPrefix.jsp" target="main" title="group ringtone prefix management">
                  <font class="font"	onclick="f_changeColor('td0322')" id="td0322"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Group  prefix</font></a></td>
                </tr>
     <%} if(purviewList.get("3-24") != null && sysfunction.get("3-24-0")== null){%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="ringgrpPrefix.jsp" target="main" title="system ringtone group prefix management">
                  <font class="font"	onclick="f_changeColor('td0324')" id="td0324"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Prefix of <%=zte.zxyw50.util.CrbtUtil.getConfig("shortdisplay","ring")%>group</font></a></td>
                </tr>
<%
        }
 if (purviewList.get("3-20") != null && sysfunction.get("3-20-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="wantedGrpPrefix.jsp" target="main" title="Management of group service application">
                  <font class="font"	onclick="f_changeColor('td0320')" id="td0320"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Group service</font></a></td>
                </tr>

<%
        }if (purviewList.get("3-25") != null && sysfunction.get("3-25-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="mobphoneLib.html" target="main" title="Color shake mobile phone information">
                  <font class="font"	onclick="f_changeColor('td0325')" id="td0325"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Shake mobile phone</font></a></td>
                </tr>
<%}if (purviewList.get("3-26") != null && sysfunction.get("3-26-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="alterRingIDPrefix.jsp" target="main" title="Color shake ringtone prefix management">
                  <font class="font"	onclick="f_changeColor('td0326')" id="td0326"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Shake prefix</font></a></td>
                </tr>
<%}if (purviewList.get("3-27") != null && sysfunction.get("3-27-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="alterringsvc.jsp" target="main" title="Color shake SP order service parameter">
                  <font class="font"	onclick="f_changeColor('td0327')" id="td0327"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Shake SP order</font></a></td>
                </tr>
<%}if (purviewList.get("3-29") != null && sysfunction.get("3-29-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="productCode.jsp" target="main" title="Product Code management">
                  <font class="font"	onclick="f_changeColor('td0329')" id="td0329"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Product Code</font></a></td>
                </tr>
  <%  } if( purviewList.get("3-31") != null && sysfunction.get("3-31-0")== null){
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="webSkinEdit.jsp" target="main" title="Edit Web Skin">
                <img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0331')" id="td0331">&nbsp;Web skin</font></a></td>
                </tr>
    <%  } if( purviewList.get("3-32") != null && sysfunction.get("3-32-0")== null){
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="taxRateCfg.jsp" target="main" title="config Ring Tax Rate">
                <img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0332')" id="td0332">&nbsp;Ring price tax rate</font></a></td>
                </tr>
<%}if (purviewList.get("3-34") != null && sysfunction.get("3-34-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
				  <a href="httpsvrinfo.jsp" target="main" title="Photo http service management">
				<img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0334')" id="td0334">&nbsp;Photo http service</font></a></td>
                </tr>
<%}if (purviewList.get("3-35") != null && sysfunction.get("3-35-0")== null) {
%>
   <tr>
      <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
	<a href="pushSmsCfg.jsp" target="main" title="Push Sms Config">
	<img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0335')" id="td0335">&nbsp;Push Sms Cfg</font></a>
     </td>
  </tr>
<%}if (purviewList.get("3-36") != null && sysfunction.get("3-36-0")== null) {
%>
   <tr>
      <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
	<a href="systemdata.jsp" target="main" title="System Parameter">
	<img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0336')" id="td0336">&nbsp;System Parameter</font></a>
     </td>
  </tr>
<%}if (purviewList.get("3-37") != null && sysfunction.get("3-37-0")== null) {%>
                <tr>
			<td width="100%">
				<img src="folder/line.gif"><img src="folder/lastblk.gif">
				<a href="spRingBoard.jsp" target="main" title="SP Ring Board">
					<img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0337')" id="td0337">&nbsp;SP RingBoard</font>
				</a>
			</td>
		</tr>
<%} if(purviewList.get("3-48") !=null  &&  sysfunction.get("3-48-0")== null){ //Trial User list Manage%>		
    <tr> 
			<td width="100%">
				<img src="folder/line.gif"><img src="folder/lastblk.gif">
				<a href="batchtrialuseraccount.jsp" target="main" title="Batch Trial Operation">
					<img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0348')" id="td0340">&nbsp;Batch Trial Operation</font>
				</a>
			</td>
		</tr>
<%} %>
<%if(purviewList.get("3-41") !=null  &&  sysfunction.get("3-41-0")== null ){ %>

          <tr>
			<td width="100%">
				<img src="folder/line.gif"><img src="folder/lastblk.gif">
				<a href="spManageInfo.jsp" target="main" title="Manager Info ">
					<img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0341')" id="td0341">&nbsp;Manager Info</font>
				</a>
			</td>
		</tr>
<%} if(purviewList.get("3-42") !=null  &&  sysfunction.get("3-42-0")== null ){ %>

          <tr>
			<td width="100%">
				<img src="folder/line.gif"><img src="folder/lastblk.gif">
				<a href="specialIVRManage.jsp" target="main" title="Special IVR management ">
					<img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0342')" id="td0342">&nbsp;Special IVR &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;management</font>
				</a>
			</td>
		</tr>
<%} %>
<% if(purviewList.get("1-55") !=null  &&  sysfunction.get("1-55-0")== null){ //OBD Feature for ring demand config%>		
    <tr> 
			<td width="100%">
				<img src="folder/line.gif"><img src="folder/lastblk.gif">
				<a href="RingDemandConfig.jsp" target="main" title="Ring On Demand Conf">
					<img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0340')" id="td0340">&nbsp;RingOnDemand Cfg</font>
				</a>
			</td>
		</tr>
	<%} %>
<!-- Added for MontnegroV5.09.02 by Srinivas-->
<%if (purviewList.get("3-44") != null &&  sysfunction.get("3-44-0")== null) {%>
		<tr>
			<td width="100%">
				<img src="folder/line.gif"><img src="folder/lastblk.gif">
				<a href="RBTBlackPrefix.jsp" target="main" title="RBT Black Prefix">
					<img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0344')" id="td0344">&nbsp;RBT Black Prefix</font>
				</a>
			</td>
		</tr>
<%} %>
<!-- End of added -->
<%
 if (purviewList.get("3-47") != null && sysfunction.get("3-47-0") == null) { %>
        <tr>
			<td width="100%">
				<img src="folder/line.gif" width="16" height="16"><img src="folder/lastblk.gif" width="16" height="16">
				<a href="syncUser.jsp" target="main" title="Synchronize User">
					<img src="image/n-8.gif" width="8" height="8" border="0"><font class="font" onclick="f_changeColor('td0347')" id="td0347">&nbsp;Synchronize User </font>
				</a>
			</td>
		</tr>
<% } %>
		<tr>
                  <td width="100%"><img src="image/ad.gif" width="170" height="7"></td>
                </tr>
              </table>
              <img src="image/ae.gif" width="170" height="13"></div>
          </td>
        </tr>
      </table>

       <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2"  >
        <tr>
          <td background="image/ab.gif" height="24" valign="bottom">
            <div align="left">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2" onClick="<%= operID.length()==0?"":"javascript:isshow('content4')" %>" onMouseOver="this.style.cursor='pointer'">
                <tr>
                  <td width="20">&nbsp;</td>
                  <td valign="bottom" height="20"><font class="font-man"><b>Group management</b></font>
                    </td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
                <table id='content4' width="99%" cellspacing="0" cellpadding="0" class="table-style2" background="image/home_r6_c2.gif" style="DISPLAY:none">
                  <%
	if (purviewList.get("11-1") != null || purviewList.get("11-2") != null || purviewList.get("11-3") != null  ) {
%>
                  <tr>
                  <td width="100%"><img src="image/ac.gif" width="170" height="14"></td>
                </tr>
<%
					  }
        if (purviewList.get("11-1") != null && sysfunction.get("11-1-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpInfo.jsp" target="main" title="Group info. management">
                  <font class="font"	onclick="f_changeColor('td1101')" id="td1101"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Group info.</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("11-2") != null && sysfunction.get("11-2-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpAccount.jsp" target="main" title="Group user participation">
                  <font class="font"	onclick="f_changeColor('td1102')" id="td1102"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User participation</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("11-3") != null && sysfunction.get("11-3-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpCanncel.jsp" target="main" title="Group user exit">
                  <font class="font"	onclick="f_changeColor('td1103')" id="td1103"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User exit</font></a></td>
                </tr>
       <%if (purviewList.get("11-21") != null && sysfunction.get("11-21-0")== null) {
         //3.23版本临时增加待确认
         %>
              <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpChoice.jsp?title=Group user Active/Deactive&target=useractive.jsp&purview=11-3" target="main" title="Group subscriber activate/deactivate" >
                  <font class="font"	onclick="f_changeColor('td1121')" id="td1121"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Activate/deactivate</font></a></td>
                </tr>
       <%}
        }
        if ((purviewList.get("11-2") != null) && sysfunction.get("11-2-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpBatchAccount.jsp" target="main" title="Group user batch add">
                  <font class="font"	onclick="f_changeColor('td1192')" id="td1192"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User batch add</font></a></td>
                </tr>
                <%
        }
        if ((purviewList.get("11-3") != null) && sysfunction.get("11-3-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpBatchCancel.jsp" target="main" title="Group user batch exit">
                  <font class="font"	onclick="f_changeColor('td1193')" id="td1193"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User batch exit</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("11-20") != null && sysfunction.get("11-20-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="lockgroup.jsp" target="main" title="Group lock/unlock">
                  <font class="font"	onclick="f_changeColor('td1120')" id="td1120"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Group lock/unlock </font></a></td>
                </tr>
            <%
        }
        if (purviewList.get("11-4") != null && sysfunction.get("11-4-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpSysStat.jsp" target="main" title="Query number of real-time users">
                  <font class="font"	onclick="f_changeColor('td1104')" id="td1104"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Real-time users</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("11-5") != null && sysfunction.get("11-5-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpStat.jsp" target="main" title="Statistics on the total number of group">
                  <font class="font"	onclick="f_changeColor('td1105')" id="td1105"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Total number</font></a></td>
                </tr>
                <%
        }

        if (purviewList.get("11-6") != null && sysfunction.get("11-6-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpUserStat.jsp" target="main" title="Guery group user person-time">
                  <font class="font"	onclick="f_changeColor('td1106')" id="td1106"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Person-time</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("11-7") != null && sysfunction.get("11-7-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpDetailStat.jsp" target="main" title="Group details query and statistics">
                  <font class="font"	onclick="f_changeColor('td1107')" id="td1107"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Group details</font></a></td>
                </tr>
                <%
        }
 if (purviewList.get("11-8") != null && sysfunction.get("11-8-0")== null){
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="groupInHall.jsp" target="main" title="Group prefix management">
                  <font class="font"	onclick="f_changeColor('td1108')" id="td1108"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Group prefix</font></a></td>
                </tr>
<%
        }
        if (purviewList.get("11-9") != null && sysfunction.get("11-9-0")== null){
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpChoice.jsp?title=Group ringtone upload&amp;target=ringUpload.jsp&amp;purview=11-9" target="main" title="Group ringtone upload">
                  <font class="font"	onclick="f_changeColor('td1109')" id="td1109"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;ringtone upload</font></a></td>
                </tr>
<%
        }
        if (purviewList.get("11-10") != null && sysfunction.get("11-10-0")== null){
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpChoice.jsp?title=Group ringtone management&amp;target=editRing.jsp&amp;purview=11-10" target="main" title="Group ringtone management">
                  <font class="font"	onclick="f_changeColor('td1110')" id="td1110"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Group ringtone</font></a></td>
                </tr>
<%
        }
        if (purviewList.get("11-18") != null && sysfunction.get("11-18-0")== null){
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpChoice.jsp?title=Group guidance ringtone setting&amp;target=preRing.jsp&amp;purview=11-18" target="main" title="Group guidance ringtone setting">
                  <font class="font"	onclick="f_changeColor('td1118')" id="td1118"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Guidance ringtone</font></a></td>
                </tr>
<%
        }
        if (purviewList.get("11-11") != null && sysfunction.get("11-11-0")== null){
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpChoice.jsp?title=Group time segment ringtone setting&amp;target=callingTime.jsp&amp;purview=11-11" target="main" title="Group time segment ringtone setting">
                  <font class="font"	onclick="f_changeColor('td1111')" id="td1111"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Time ringtone</font></a></td>
                </tr>
<%
        }
        if (purviewList.get("11-12") != null && sysfunction.get("11-12-0")== null){
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpChoice.jsp?title=Group week time segment ringtone setting&amp;target=weekCallingTime.jsp&amp;purview=11-12" target="main" title="Group week time segment ringtone setting">
                  <font class="font"	onclick="f_changeColor('td1112')" id="td1112"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Week time ringtone</font></a></td>
                </tr>
<%
        }
        if (purviewList.get("11-13") != null && sysfunction.get("11-13-0")== null){
%>
                <tr>
          			<td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
          			<a href="grpChoice.jsp?title=Group month time segment ringtone setting&amp;target=monthCallingTime.jsp&amp;purview=11-13" target="main" title="Group month time segment ringtone setting">
          			<font class="font"	onclick="f_changeColor('td1113')" id="td1113"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Month time ringtone</font></a></td>
                </tr>
<%
        }
        if (purviewList.get("11-14") != null && sysfunction.get("11-14-0")== null){
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpChoice.jsp?title=Group grouping management &amp;target=grpGrouping.jsp&amp;purview=11-14" target="main" title="Group grouping management">
                  <font class="font"	onclick="f_changeColor('td1114')" id="td1114"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Group grouping</font></a></td>
                </tr>
<%
        }
        if (purviewList.get("11-16") != null && sysfunction.get("11-16-0")== null){
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  	<a href="grpChoice.jsp?title=Group member detail query statistic&amp;target=grpMemberDetailStat.jsp&amp;purview=11-16" target="main" title="Group member detail query statistic">
                  	<font class="font"	onclick="f_changeColor('td1116')" id="td1116"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Member details</font></a></td>
                </tr>
<%
        }
        if (purviewList.get("11-17") != null && sysfunction.get("11-17-0")== null){
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpQuryAction.jsp" target="main" title="Query of group ringtone operation">
                  <font class="font"	onclick="f_changeColor('td1117')" id="td1117"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;ringtone operation</font></a></td>
                </tr>
<%
        }if(purviewList.get("11-19") != null && sysfunction.get("11-19-0")== null){
%>
                 <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="grpChoice.jsp?title=Group ringtone group management&amp;target=grpringgroup.jsp&amp;purview=11-14" target="main" title="Group ringtone group management">
                  <font class="font"	onclick="f_changeColor('td1119')" id="td1119"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;ringtone group</font></a></td>
                </tr>
        <%}%>
                <tr>
                  <td width="100%"><img src="image/ad.gif" width="170" height="7"></td>
                </tr>
              </table>
              <img src="image/ae.gif" width="170" height="13"></div>
          </td>
        </tr>
      </table>




	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
          <td background="image/ab.gif" height="24">
            <div align="center">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2" onClick="<%= operID.length()==0?"":"javascript:isshow('content5')" %>" onMouseOver="this.style.cursor='pointer'">
                <tr>
                  <td width="0"></td>
                  <td height="20" valign="bottom" align="center"><font class="font-man"><b>Query and statistics</b></font></td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
              <table id='content5' width="100%" cellspacing="0" cellpadding="0" class="table-style2" background="image/home_r6_c2.gif" style="DISPLAY:none">
<%
if (purviewList.get("4-1") != null ||purviewList.get("4-2") != null ||purviewList.get("4-3") != null ||purviewList.get("4-4") != null) {
%>
				<tr>
                  <td width="100%"><img src="image/ac.gif" width="170" height="14"></td>
                </tr>
                <%}
        if (purviewList.get("4-2") != null && sysfunction.get("4-2-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="querySvcUsage.jsp" target="main" title="service development statistics" >
                  <font class="font"	onclick="f_changeColor('td0402')" id="td0402"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Service development</font></a></td>
                </tr>
                <%
        }

        if (purviewList.get("4-3") != null && sysfunction.get("4-3-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="feeStat.jsp" target="main" title="service profit statistics">
                  <font class="font"	onclick="f_changeColor('td0403')" id="td0403"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Service profit</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("4-19") != null && sysfunction.get("4-19-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="monthFeeStat.jsp" target="main" title="month service profit statistics">
                  <font class="font"	onclick="f_changeColor('td0419')" id="td0419"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Month charge</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("4-4") != null && sysfunction.get("4-4-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="quryUserOpera.jsp" target="main" title="query subscriber operating ringtone">
                  <font class="font"	onclick="f_changeColor('td0404')" id="td0404"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;ringtone operations</font></a></td>
                </tr>

   <%
        }
        if (purviewList.get("4-15") != null && sysfunction.get("4-15-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="quryUserAction.jsp" target="main" title="query subscriber status operations">
                  <font class="font"	onclick="f_changeColor('td0415')" id="td0415"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Status operations</font></a></td>
                </tr>

   <%
        }
        if (purviewList.get("4-5") != null && sysfunction.get("4-5-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="spScribStat.jsp" target="main" title="query SP ringtone orders">
                  <font class="font"	onclick="f_changeColor('td0405')" id="td0405"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP ringtone order</font></a></td>
                </tr>
                <%} if ((purviewList.get("4-24") != null) && sysfunction.get("4-24-0")== null){%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="spmusicStat.jsp" target="main" title="SP RingGroup Order Query">
                  <font class="font"	onclick="f_changeColor('td0424')" id="td0424"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP ringgroup order</font></a></td>
                </tr>
                <%} if ((purviewList.get("4-36") != null) && sysfunction.get("4-36-0")== null){%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="spOrderingStat.jsp" target="main" title="SP ringtone statistics">
                  <font class="font"	onclick="f_changeColor('td0436')" id="td0436"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP ringtone statistics</font></a></td>
                </tr>
                 <%}if ((purviewList.get("4-25") != null) && sysfunction.get("4-25-0")== null){ %>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="qryMusic.jsp" target="main" title="query SP RingGroup">
                  <font class="font"	onclick="f_changeColor('td0425')" id="td0425"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP ringgroup query</font></a></td>
                </tr>
                <%
        } if (purviewList.get("4-27") != null && sysfunction.get("4-27-0")== null) {%>
                   <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="viewdiscount.jsp" target="main" title="SP Discount query">
                  <font class="font"	onclick="f_changeColor('td0427')" id="td0427"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP discount query</font></a></td>
                </tr>

        <%}
        if (purviewList.get("4-6") != null && sysfunction.get("4-6-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="spSysStat.jsp" target="main" title="SP system statistics">
                  <font class="font"	onclick="f_changeColor('td0406')" id="td0406"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP system</font></a></td>
                </tr>

   <%
        }
        if (purviewList.get("4-7") != null && sysfunction.get("4-7-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="areaUserStat.jsp" target="main" title="statistics on subscribers in service areas">
                  <font class="font"	onclick="f_changeColor('td0407')" id="td0407"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Service area users</font></a></td>
                </tr>
   <%
        }

        if (purviewList.get("4-8") != null && sysfunction.get("4-8-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="sysUserStat.jsp" target="main" title="statistics on the number of subscriber in the system">
                  <font class="font"	onclick="f_changeColor('td0408')" id="td0408"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User number</font></a></td>
                </tr>
   <%
        }
        if (purviewList.get("4-9") != null && sysfunction.get("4-9-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="curUserStat.jsp" target="main" title="Query current number of subscribers in the system">
                  <font class="font"	onclick="f_changeColor('td0409')" id="td0409"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Current user number</font></a></td>
                </tr>
            <%
        }
        if (purviewList.get("4-10") != null && sysfunction.get("4-10-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="curOpUserStat.jsp" target="main" title="system person-time statistics">
                  <font class="font"	onclick="f_changeColor('td0410')" id="td0410"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;System Person-time</font></a></td>
                </tr>
      <%}
 if ((purviewList.get("4-62") != null) && (sysfunction.get("4-62-0")== null )) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="rrbtCurOpUserStat.jsp" target="main" title="Caller RBT system person-time statistics">
                  <font class="font"	onclick="f_changeColor('td0462')" id="td0462"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;RRBT System &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Person-Time</font></a></td>
                </tr>
      <%}if(purviewList.get("4-28") != null && sysfunction.get("4-28-0")== null){%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="curAreaUserStat.jsp" target="main" title="statistic of person/times in service area">
                  <font class="font"	onclick="f_changeColor('td0428')" id="td0428"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Person-time</font></a></td>
                </tr>
    <%}if(purviewList.get("4-30") != null && sysfunction.get("4-30-0")== null){%>
                  <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="grpmemberopentype.jsp" target="main" title="group subscriber open and cancellation mode">
                  <font class="font"	onclick="f_changeColor('td0430')" id="td0430"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Group subscriber</font></a></td>
                </tr>
   <%
        }
        if (purviewList.get("4-11") != null && sysfunction.get("4-11-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="cataStat.html" target="main" title="statistics on ringtones in category libraries">
                  <font class="font"	onclick="f_changeColor('td0411')" id="td0411"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;ringtone in libraries</font></a></td>
                </tr>
   <%
        }


        if (purviewList.get("4-13") != null && sysfunction.get("4-13-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="webRingStat.jsp" target="main" title="statistics on the ringtone ordering modes">
                  <font class="font"	onclick="f_changeColor('td0413')" id="td0413"><img src="image/n-8.gif" width="8" height="8" border="0">ringtone order mode</font></a></td>
                </tr>
   <%
        }
        if (purviewList.get("4-12") != null && sysfunction.get("4-12-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="webUserStat.jsp" target="main" title="statistics on account opening modes">
                  <font class="font"	onclick="f_changeColor('td0412')" id="td0412"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Account open mode</font></a></td>
                </tr>
   <%
        }if (purviewList.get("4-14") != null && sysfunction.get("4-14-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="loginStat.jsp" target="main" title="statistics on the subscriber's login to the website">
                  <font class="font"	onclick="f_changeColor('td0414')" id="td0414"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Number of login</font></a></td>
                </tr>
   <%
        }if (purviewList.get("4-16") != null && sysfunction.get("4-16-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="queryRequireRing.jsp" target="main" title="query the subscriber's ringtone requirements">
                  <font class="font"	onclick="f_changeColor('td0416')" id="td0416"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User's requirements</font></a></td>
                </tr>
   <%
        }if (purviewList.get("4-17") != null && sysfunction.get("4-3-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="queryRequireRingTotal.jsp" target="main" title="statistics on the subscriber's ringtone requirements">
                  <font class="font"	onclick="f_changeColor('td0417')" id="td0417"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Total requirements</font></a></td>
                </tr>
   <%
        }
        if (purviewList.get("4-18") != null && sysfunction.get("4-18-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="orderTimes.jsp" target="main" title="query the number of ringtone orders">
                  <font class="font"	onclick="f_changeColor('td0418')" id="td0418"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Order number</font></a></td>
                </tr>
                <%
        }
 if (purviewList.get("4-20") != null && sysfunction.get("4-20-0")== null) {
   %>
                <!--add by ge quanmin 2005.06.14-->
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="ringSearch.jsp?searchvalue=&sortby=uploadtime&searchkey=sp&oper=manager" target="main" title="query SP ringtone">
                  <font class="font"	onclick="f_changeColor('td0420')" id="td0420"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP ringtone</font></a></td>
                </tr>
            <%
          }
           if (purviewList.get("4-26") != null && sysfunction.get("4-26-0")== null){
               %>
               <tr>
                 <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                 <a href="invalidringrecord.jsp" target="main" title="system ringtone expiration deletion record query">
                 <font class="font"	onclick="f_changeColor('td0426')" id="td0426"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Out-date deletion</font></a></td>
                 </tr>
                 <%
                 }
             if (purviewList.get("4-21") != null && sysfunction.get("4-21-0")== null){
               %>
               <tr>
                 <td width="100%">
<img src="folder/line.gif"><img src="folder/lastblk.gif">
                 <a href="mringcatasearch.jsp?oper=manager&tellfriend=false&buy=false&showlargess=false&tabletitle=none&titleCss=tr-ring" target="main" title="query by ringtone category">
                 <font class="font"	onclick="f_changeColor('td0421')" id="td0421"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Query by category</font></a></td>
                 </tr>
                 <%
                 }
              if (purviewList.get("4-22") != null && sysfunction.get("4-22-0")== null){
   %>
              <tr>
                <td width="100%">
                <img src="folder/line.gif"><img src="folder/lastblk.gif">
                <a href="mringboard.jsp?searchvalue=0&oper=manager&tellfriend=false&buy=false&showlargess=false&tabletitle=none&titleCss=tr-ring" target="main" title="query by ringtone board">
                <font class="font"	onclick="f_changeColor('td0422')" id="td0422"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Query by board</font></a></td>
                </tr>
               <% }
if (purviewList.get("4-23") != null && sysfunction.get("4-23-0")== null){
   %>
                <tr>
                <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                <a href="queryDyRing.jsp" target="main" title="statistic of activity ringtone">
                <font class="font"	onclick="f_changeColor('td0423')" id="td0423"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Activity ringtone</font></a></td>
                </tr>
                <%}
if (purviewList.get("4-31") != null && sysfunction.get("4-31-0")== null){
               %>
                <tr>
                <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                <a href="contentStat.jsp" target="main" title="Content statistic">
                <font class="font"	onclick="f_changeColor('td0431')" id="td0431"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Content statistic</font></a></td>
                </tr>
                <%}
if (purviewList.get("4-32") != null && sysfunction.get("4-32-0")== null){
               %>
                <tr>
                <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                <a href="userStat.jsp" target="main" title="User change statistic">
                <font class="font"	onclick="f_changeColor('td0432')" id="td0432"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User change statistic</font></a></td>
                </tr>
                <%}
if (purviewList.get("4-33") != null && sysfunction.get("4-33-0")== null){
               %>
                <tr>
                <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                <a href="userNumberStat.jsp" target="main" title="User number statistic">
                <font class="font"	onclick="f_changeColor('td0433')" id="td0433"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User number statistic</font></a></td>
                </tr>
<%}
if (purviewList.get("4-34") != null && sysfunction.get("4-34-0")== null){
               %>
                <tr>
                <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                <a href="artistOrderStat.jsp" target="main" title="The artist's order statistic">
                <font class="font"	onclick="f_changeColor('td0434')" id="td0434"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Artist's orders statistic</font></a></td>
                </tr>
<%}
if (purviewList.get("4-35") != null && sysfunction.get("4-35-0")== null){
               %>
                <tr>
                <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                <a href="tendencyStat.jsp" target="main" title="Tendency statistic">
                <font class="font"	onclick="f_changeColor('td0435')" id="td0435"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Tendency statistic</font></a></td>
                </tr>
<%}
if (purviewList.get("4-37") != null && sysfunction.get("4-37-0")== null){
%>
<tr>
	<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
		<a href="StatArtistOrder.jsp" target="main" title="The artist's order statistic">
			<font class="font"	onclick="f_changeColor('td0437')" id="td0437"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Singer order Stat.</font></a></td>
</tr>
<%
}
if (purviewList.get("4-38") != null && sysfunction.get("4-38-0")== null){
%>
<tr>
	<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
		<a href="StatDeactiveUsers.jsp" target="main" title="Deactive users">
			<font class="font"	onclick="f_changeColor('td0438')" id="td0438"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Deactive users</font></a></td>
</tr>
<%
}
if (purviewList.get("4-39") != null && sysfunction.get("4-39-0")== null){
%>
<tr>
	<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
		<a href="StatUser.jsp" target="main" title="User Stat">
			<font class="font"	onclick="f_changeColor('td0439')" id="td0439"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User Stat.</font></a></td>
</tr>
<%
}
if (purviewList.get("4-40") != null && sysfunction.get("4-40-0")== null){
%>
<tr>
    <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
        <a href="UserOperStat.jsp" target="main" title="User Oper Stat">
            <font class="font"	onclick="f_changeColor('td0440')" id="td0440"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User Oper Stat.</font></a></td>
</tr>
<%
}if (purviewList.get("4-41") != null && sysfunction.get("4-41-0")== null){
%>
<tr>
    <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
        <a href="StatUserCaller.jsp" target="main" title="User Caller Stat">
            <font class="font"	onclick="f_changeColor('td0441')" id="td0441"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;User Caller Stat.</font></a></td>
</tr>
<%
}
if(purviewList.get("4-42") != null&& sysfunction.get("4-42-0")== null){
%>
<tr>
    <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
        <a href="grpUserChangeStat.jsp" target="main" title="Group User Stat">
            <font class="font"	onclick="f_changeColor('td0442')" id="td0442"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Group User Stat.</font></a></td>
</tr>
<%
}if (purviewList.get("4-75") != null && sysfunction.get("4-75-0")== null){
%>
<tr>
	<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
		<a href="spOrderAndButTimesStat.jsp" target="main" title="SP Ringtone Order and Gift Monthly Stat.">
			<font class="font"	onclick="f_changeColor('td0475')" id="td0475"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP ringtone Order &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; and Gift Monthly Stat.</font></a></td>
</tr>
<%
}
if (purviewList.get("4-9001") != null && sysfunction.get("4-9001-0")== null){
%>
<tr>
	<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
		<a href="StatSubscribersProfile.jsp" target="main" title="Subscribers profile">
			<font class="font"	onclick="f_changeColor('td049001')" id="td049001"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Subscribers profile</font></a></td>
</tr>
<%
}
if (purviewList.get("4-9002") != null && sysfunction.get("4-9002-0")== null){
%>
<tr>
	<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
		<a href="StatRingtoneUse.jsp" target="main" title="Ringtone Use Stat.">
			<font class="font"	onclick="f_changeColor('td049002')" id="td049002"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;ringtone Use Stat.</font></a></td>
</tr>
<%
}if (purviewList.get("4-9003") != null && sysfunction.get("4-9003-0")== null){
%>
<tr>
	<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
		<a href="StatSpRingboard.jsp" target="main" title="SP Ringboard Stat.">
			<font class="font"	onclick="f_changeColor('td049003')" id="td049003"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP Ringboard Stat.</font></a></td>
</tr>
<%
}if (purviewList.get("4-9004") != null && sysfunction.get("4-9004-0")== null){
%>
<tr>
	<td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
		<a href="StatSpRingtone.jsp" target="main" title="SP Ringtone Stat.">
			<font class="font"	onclick="f_changeColor('td049004')" id="td049004"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;SP ringtone Stat.</font></a></td>
</tr>
<%
}
%>
           <tr>
                  <td width="100%"><img src="image/ad.gif" width="170" height="7"></td>
                </tr>
              </table>
              <img src="image/ae.gif" width="170" height="13"></div>
          </td>
        </tr>
      </table>

      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
          <td background="image/ab.gif" height="24">
            <div align="center">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2" onClick="<%= operID.length()==0?"":"javascript:isshow('content6')" %>" onMouseOver="this.style.cursor='pointer'">
                <tr>
                  <td width="20">&nbsp;</td>
                  <td height="20" valign="bottom"><font class="font-man"><b>Operator Management</b></font></td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
              <table id='content6' width="100%" cellspacing="0" cellpadding="0" class="table-style2" background="image/home_r6_c2.gif" style="DISPLAY:none">

<%
        if (purviewList.get("5-1") != null ||purviewList.get("5-2") != null ||purviewList.get("5-3") != null ||purviewList.get("5-4") != null ||purviewList.get("5-5") != null) {
%>				<tr>
                  <td width="100%"><img src="image/ac.gif" width="170" height="14"></td>
                </tr>
                <%
}
        if (purviewList.get("5-1") != null ) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="purview/operManage.html" target="main" title="operator management">
                  <font class="font"	onclick="f_changeColor('td0501')" id="td0501"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Operator</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("5-2") != null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="purview/operRights.html" target="main" title="operator rights configuration">
                  <font class="font"	onclick="f_changeColor('td0502')" id="td0502"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Operator rights</font></a></td>
                </tr>
                <%
        }

        if (purviewList.get("5-3") != null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="purview/operGrpManage.jsp" target="main" title="operator group management">
                  <font class="font"	onclick="f_changeColor('td0503')" id="td0503"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Operator group</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("5-4") != null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="purview/operGrpRight.jsp" target="main" title="operator group rights">
                  <font class="font"	onclick="f_changeColor('td0504')" id="td0504"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Group rights</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("5-5") != null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/lastblk.gif">
                  <a href="purview/operLog.jsp" target="main" title="operator log">
                  <font class="font"	onclick="f_changeColor('td0505')" id="td0505"><img src="image/n-8.gif" width="8" height="8" border="0">&nbsp;Operator log</font></a></td>
                </tr>
                <tr>
                  <td width="100%"><img src="image/ad.gif" width="170" height="7"></td>
                </tr>
                <%
        }
%>
              </table>
              <img src="image/ae.gif" width="170" height="13"></div>
          </td>
        </tr>
      </table>

	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
          <td background="image/ab.gif" height="24" valign="bottom">
            <div align="left">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2" onClick="<%= operID.length()==0?"":"javascript:isshow('content7')" %>" onMouseOver="this.style.cursor='pointer'">
                <tr>
                  <td width="20">&nbsp;</td>
                  <td valign="bottom" height="20"><font class="font-man"><b>ringtone audit</b></font>
                    </td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        
        <tr>
          <td>
            <div align="center">
                <table id='content7' width="99%" cellspacing="0" cellpadding="0" class="table-style2" background="image/home_r6_c2.gif" style="DISPLAY:none">
                  <%
	if (purviewList.get("15-1") != null || purviewList.get("15-2") != null || purviewList.get("15-3") != null || purviewList.get("15-4") != null || purviewList.get("15-5") != null ) {
%>
                  <tr>
                  <td width="100%"><img src="image/ac.gif" width="170" height="14"></td>
                </tr>
<%
	}
        if (purviewList.get("15-1") != null && sysfunction.get("15-1-0")== null ) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="crbt.jsp" target="main"><img src="image/n-8.gif" width="8" height="8" border="0">
                  <font class="font"	onclick="f_changeColor('td1501')" id="td1501">CRBT center management</font></a></td>
                </tr>

        <%
		 }
		if (purviewList.get("15-2") != null && sysfunction.get("15-2-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="crbthlr.jsp" target="main"><img src="image/n-8.gif" width="8" height="8" border="0">
                  <font class="font"	onclick="f_changeColor('td1502')" id="td1502">CRBT center HLR management</font></a></td>
                </tr>

        <% }
        if (purviewList.get("15-5") != null && sysfunction.get("15-5-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="synccrbt.jsp" target="blank"><img src="image/n-8.gif" width="8" height="8" border="0">
                  <font class="font"	onclick="f_changeColor('td1505')" id="td1505">Operation by synchronize the manually</font></a></td>
                </tr>

        <%
		 }
			if (purviewList.get("15-4") != null && sysfunction.get("15-4-0")== null) {
%>
                <tr>
                  <td width="100%"><img src="folder/line.gif"><img src="folder/midblk.gif">
                  <a href="synchisstatus.jsp" target="blank"><img src="image/n-8.gif" width="8" height="8" border="0">
                  <font class="font"	onclick="f_changeColor('td1504')" id="td1504">CRBT center history synchronization operation status query</font></a></td>
                </tr>

        <% }         %>

                <tr>
                  <td width="100%"><img src="image/ad.gif" width="170" height="7"></td>
                </tr>
              </table>
              <img src="image/ae.gif" width="170" height="13"></div>
          </td>
        </tr>
      </table>
 <%
    if(operID.length() != 0 && purviewList.get("7-1") != null && sysfunction.get("7-1-0")== null ){
%>
      <table width="165" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
        <tr>
          <td width="28"><img src="image/home_r14_c3.gif" width="28" height="31"></td>
          <td width="120" background="image/home_r14_c5bg.gif">
            <div align="center"><a href="batchRing.jsp" target="main"><font class="font-man"><b>Batch upload</b></font></a></div>
          </td>
          <td width="24"><img src="image/home_r14_c5.gif" width="12" height="31"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
        <tr>
          <td><img src="image/home_r10_c2bg.gif" width="170" height="8"></td>
        </tr>
      </table><%
      }
	 if(false){//operID.length() != 0 && purviewList.get("8-1") != null && sysfunction.get("8-1-0")== null
     %>
     <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
      </table>
      <table width="165" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
        <tr>
          <td width="28"><img src="image/home_r14_c3.gif" width="28" height="31"></td>
          <td width="119" background="image/home_r14_c5bg.gif">
            <div align="center"><a href="operLog.jsp" target="blank"><font class="font-man"><b>System log</b></font></a></div>
          </td>
          <td width="25"><img src="image/home_r14_c5.gif" width="12" height="31"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
        <tr>
          <td><img src="image/home_r10_c2bg.gif" width="170" height="8"></td>
        </tr>
      </table>
  <%
	}
    if(operID.length() != 0 ){
   %>
   <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
      </table>
      <table width="165" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
        <tr>
          <td width="28"><img src="image/home_r14_c3.gif" width="28" height="31"></td>
          <td width="122" background="image/home_r14_c5bg.gif">
            <div align="center"><a href="operPwdChange.jsp" target="main" title="operator password modification"><font class="font-man"><b>Modify Password</b></font></a></div>
          </td>
          <td width="22"><img src="image/home_r14_c5.gif" width="12" height="31"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
        <tr>
          <td><img src="image/home_r10_c2bg.gif" width="170" height="8"></td>
        </tr>
      </table>
<%
	}
%>

      <table width="165" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
        <tr>
          <td width="28"><img src="image/home_r14_c3.gif" width="28" height="31"></td>
          <td width="121" background="image/home_r14_c5bg.gif">
            <div align="center"><a href="<%= operID.length() == 0 ? "enter" : "logout" %>.jsp" target="main"><font class="font-man"><b><%= operID.length() == 0 ? "" : "Exit " %>Login</b></font></a></div>
          </td>
          <td width="23"><img src="image/home_r14_c5.gif" width="12" height="31"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
        <tr>
          <td><img src="image/home_r10_c2bg.gif" width="170" height="8"></td>
        </tr>
      </table>
      <p>&nbsp;</p>
    </td>
    <td width="11" valign="top" background="image/home_r4_c3bg.gif"><img src="image/home_r2_c3.gif" width="11" height="28"></td>
    <td bgcolor="#FFFFFF" valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="image/home_r2_c5.gif" width="551" height="19"></td>
        </tr>
      </table>
      <iframe height="600" width="551" scrolling=yes frameborder=0 src='<%= operID.length()==0?"enter.jsp":"../intro.html" %>' name="main"></iframe>
    </td>
    <td valign="top" background="image/home_r5_c6bg.gif" width="9"><img src="image/home_r2_c6.gif" width="9" height="31"></td>
    <td valign="top" background="image/home_r2_c7.gif" width="9"><img src="image/home_r2_c7.gif" width="9" height="31"></td>
  </tr>
</table>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td><img src="image/home_r16_c1.gif" width="758" height="17"></td>
  </tr>
</table>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center" background="image/home_r15_c1.gif">
  <tr>
    <td>
      <table width="758" border="0" cellspacing="0" cellpadding="0" align="center" background="image/home_r15_c1.gif">
    <tr>
     <td width="100%" > <iframe width="741" scrolling=no frameborder=0 src='bottom.html' name="bottom"></iframe>
     </td>
     </tr>
     <tr height=0>
     <td width="100%" > <iframe scrolling=no frameborder=0 height=0 src='popedom.jsp' name="popedom"></iframe>
     </td>
     </tr>
  </table>
    </td>
  </tr>
</table>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td><img src="image/home_r19_c1.gif" width="758" height="17"></td>
  </tr>
</table>
</form>
</body>
</html>
