<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@page import="zte.zxyw50.util.JCalendar"%>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
	int isfarsicalendar = zte.zxyw50.util.CrbtUtil.getConfig("isfarsicalendar", 0);
String userday = CrbtUtil.getConfig("uservalidday","0");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    ywaccess oYwAccess = new ywaccess();
    int cmpval = oYwAccess.getParameter(52);
	zxyw50.Purview purview = new zxyw50.Purview();
    Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
    String ringablealias1 = CrbtUtil.getConfig("ringablealias1","0");
	String ringablealias2 = CrbtUtil.getConfig("ringablealias2","0");
	String sLangLabel1 = CrbtUtil.getConfig("langlabel1","Arabic");
	String sLangLabel2 = CrbtUtil.getConfig("langlabel2","French");
	int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
       int isCombodia =  zte.zxyw50.util.CrbtUtil.getConfig("isCombodia",0);
	String isSmartPriceFlag = CrbtUtil.getConfig("isSmartPriceFlag","0");

    //String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

	String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");
%>
<html>
<head>
<title>Edit ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script language="JavaScript">
   function checkfee (fee) {
      var tmp = '';
      for (i = 0; i < fee.length; i++) {
         tmp = fee.substring(i, i + 1);
         if (tmp < '0' || tmp > '9')
            return false;
      }
      return true;
   }

   function edit () {
      var fm = document.inputForm;
      if (trim(fm.ringLabel.value) == '') {
         alert('Please enter a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+ " "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%>!');//请输入Ringtone name
         fm.ringLabel.focus();
         return;
      }
      if (!CheckInputStr(fm.ringLabel,'<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+ " "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%>')){
         fm.ringLabel.focus();
         return;
      }
      if (trim(fm.ringspell.value) == '') {
         alert('Please enter the spelling of a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+ " "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%>');//请输入铃音拼音
         fm.ringspell.focus();
         return;
      }
      <%if(isCombodia==0){%>
      if(!CheckInputChar1(fm.ringspell,'<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> spelling')){
      	fm.ringspell.focus();
      	return;
      }
     <%}%>
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
      if(!isSmartPriceFlag.equalsIgnoreCase("1")){
    	%>  
     var monthlyprice =trim(fm.monthlyprice.value);
      if(monthlyprice==''){
         alert('Please enter Monthly price');//请输入铃音价格
         fm.monthlyprice.focus();
         return;
      }
      if (! checkfee(monthlyprice)) {
         alert('Invalid price');//铃音价格错误
         fm.monthlyprice.focus();
         return;
      }	  
      <%
      }
      %>
      if(<%=issupportmultipleprice%> == 1){	  
      var dailyprice = trim(fm.dailyprice.value);
      if(dailyprice==''){
         alert('Please enter Daily price');//请输入铃音价格
         fm.dailyprice.focus();
         return;
      }
      if (! checkfee(dailyprice)) {
         alert('Invalid price');//铃音价格错误
         fm.dailyprice.focus();
         return;
      }

	  dailyprice = parseInt(dailyprice,10);
	  monthlyprice = parseInt(monthlyprice,10);
	  if(monthlyprice <= dailyprice){
	  alert("Monthly price should be greater than Daily price");
	  fm.dailyprice.focus();
	  return;
	  }
      }
	  
     
   <%//begin add 用户有效期
        if(userday.equalsIgnoreCase("1")){
          %>
          //begin add 用户有效期
          var tmp1 = trim(fm.uservalidday.value);
          if ( tmp1 == '') {
            //alert('请输入铃音用户有效期!');
             alert("Please input <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> validity date!");
            fm.uservalidday.focus();
            return ;
          }
          if (!checkstring('0123456789',tmp1)) {
           // alert('铃音用户有效期只能为数字!');
             alert("The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> validity date can only be a digital number!");
            fm.uservalidday.focus();
            return ;
          }
      //end
      <%}
	  if (sysfunction.get("2-66-0")== null ) { // ring additional information
	  %>
	 var hiderecoverdate = trim(fm.hidetime.value);
	//  if(hiderecoverdate==''){
     //     alert('Please enter hide or recover date');//请输入铃音有效期
     //     fm.hidetime.focus();
    //      return ;
    //  }
	if(hiderecoverdate != ''){
      if(!checkDate2(hiderecoverdate)){
          alert('The hide or recover date entered is incorrect. Please re-enter!');//铃音有效期输入不正确,请重新输入
          fm.hidetime.focus();
          return ;
      }
      if(checktrue2(hiderecoverdate)){
          alert('The hide or recover date cannot be earlier than the current time. Please re-enter!');//铃音有效期不能低于当前时间,请重新输入
          fm.hidetime.focus();
          return ;
      }

      if(checktrueyear(hiderecoverdate,'<%=expireTime%>')){
         alert("The hide or recover date cannot be latter than '<%=expireTime%>'. Please re-enter!");
          fm.hidetime.focus();
          return ;
      }  
	}

	  if(fm.mediatype.value == ''){
		alert("Please enter ringtone mediatype in digits!");
		return;
	  }

	  if(fm.filetype.value == ''){
	  	alert("Please enter ringtone filetype in digits!");
		return;
	  }
	 if (fm.lang.value != '' ){
	   if(!CheckInputStr(fm.lang,'language')){
         fm.lang.focus();
         return;
        }	
	  }
	  <% } if(ringablealias1.equalsIgnoreCase("1")){
          %>
		// if(fm.ringalias1.value == ''){
		//	alert("Please enter ringtone alias1 !");
		//	return;
		 // }
     <%} if(ringablealias2.equalsIgnoreCase("1")){ %>
		//if(fm.ringalias2.value == ''){
		//	alert("Please enter ringtone alias2 !");
	//		return;
		//  }
      <%}%>
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
      /*if(checktrue2(validdate)){
          alert('The expiration date cannot be earlier than the current time. Please re-enter!');//铃音有效期不能低于当前时间,请重新输入
          fm.validdate.focus();
          return ;
      }*/

      if(checktrueyear(validdate,'<%=expireTime%>')){
         alert("The expiration date cannot be latter than '<%=expireTime%>'. Please re-enter!");
          fm.validdate.focus();
          return ;
      }
      if(<%=issupportmultipleprice%> == 1){
      fm.dailyprice.disabled = false;
      }
      <%
      if(!isSmartPriceFlag.equalsIgnoreCase("1")){
    	%>  
      fm.monthlyprice.disabled = false;
      <%
      }
      %>
      fm.op.value = 'edit';
      fm.submit();
   }

function ok(){
  edit();
}
function cancel(){
  window.returnValue = "no";
  window.close();
}

 function queryInfo(type) {
//	 alert(type); // to-do remove this 
     var result =  window.showModalDialog('albumMovie.jsp?type='+type,window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
//		 alert(" result -- > "+result); // to-do remove this
		 var res = result.split("#");
//		 alert(" res[] ------- "+res);
		 if(type ==1) {
		     document.inputForm.albumid.value=res[0];
			 document.inputForm.album.value=res[1];
		 } else {
		     document.inputForm.movieid.value=res[0];
	 	     document.inputForm.movie.value=res[1];
		 }
	 }
   }
</script>
<base target="_self" />
</head>
<%!
int isfarsicalendar = zte.zxyw50.util.CrbtUtil.getConfig("isfarsicalendar", 0);
JCalendar cal = new JCalendar();
public String jcalendar(String str){
	if(isfarsicalendar == 1){
		str = cal.gregorianToPersian(str); 
	}	
	return str;
}
%>
<body topmargin="0" leftmargin="0" class="body-style1"  background="background.gif" >
<%

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String ringid = request.getParameter("ringid") == null ? "" : ((String)request.getParameter("ringid")).trim();
    String libid =  request.getParameter("libid") == null ? "503" : ((String)request.getParameter("libid")).trim();
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
    if(operName == null ||"".equals(operName)||session.getAttribute("SPCODE")!=null)
               //throw new Exception("您无权使用此功能或你的登陆信息已过期!");
                 throw new Exception("You have no access to the system or your login info have expired!");
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        ColorRing colorRing = new ColorRing();
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        if(op.equals("edit")){
            String crid = request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid");
            String craccount = libid;
            String ringLabel = request.getParameter("ringLabel") == null ? "" : transferString((String)request.getParameter("ringLabel"));
            if(checkLen(ringLabel,40))
               throw new Exception("The length of the ringtone name you entered has exceeded the limit. Please re-enter!");//您输入的Ringtone name长度超出限制,请重新输入!
            String ringauthor = request.getParameter("ringauthor") == null ? "" : transferString((String)request.getParameter("ringauthor"));
          if(checkLen(ringauthor,40))
        	throw new Exception("The length of the singer name you entered has exceeded the limit. Please re-enter!");//您输入的Singer name长度超出限制,请重新输入!
         String ringsource = request.getParameter("ringsource") == null ? "" : transferString((String)request.getParameter("ringsource"));
         if(checkLen(ringsource,40))
        	throw new Exception("The length of the ringtone provider name you entered has exceeded the limit. Please re-enter!");//您输入的铃音提供商名称长度超出限制,请重新输入!
          String dailyprice = request.getParameter("dailyprice") == null ? "0" : (String)request.getParameter("dailyprice");
		  String monthlyprice = request.getParameter("monthlyprice") == null ? "0" : (String)request.getParameter("monthlyprice");
          String validdate = request.getParameter("validdate") == null ? "" : (String)request.getParameter("validdate");
          if(isfarsicalendar == 1){
          	JCalendar cal = new JCalendar();
          	validdate = cal.persianToGregorian(validdate); 
     		}          
          String ringspell = request.getParameter("ringspell") == null ? "" : (String)request.getParameter("ringspell");
           String uservalidday = request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday");
           manSysRing manring = new manSysRing();
                ArrayList rList = null;
                Hashtable hash = new Hashtable();
                String iffree = "-1";
                hash.put("usernumber",craccount);
                hash.put("extraringid",crid);
                hash.put("ringid",crid);
                hash.put("ringlabel",ringLabel);
                hash.put("ringfee",monthlyprice);
			    hash.put("ringfee2",dailyprice);
                hash.put("ringauthor",ringauthor);
                hash.put("ringsource",ringsource);
                hash.put("validdate",validdate);
                hash.put("uservalidday",uservalidday);
                hash.put("ringspell",ringspell);
                hash.put("iffree",iffree);
                rList = manring.editSysRingLabel(hash);
                sysInfo.add(sysTime + operName + "Ringtone info modified successfully!");//修改铃音信息成功
                String msg = JspUtil.generateResultList(rList);
                if(!msg.equals("")){
                   msg = msg.replace('\n',' ');
                   throw new Exception(msg);
                }
                // 准备写操作员日志
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("SERVICEKEY",manring.getSerkey());
                map.put("OPERTYPE","203");
                map.put("RESULT","1");
                map.put("PARA1",crid);
                map.put("PARA2",ringLabel);
                map.put("PARA3",monthlyprice);
		//map.put("PARA5",dailyprice);
                map.put("PARA4",validdate);
                map.put("DESCRIPTION","Modify "+"ip:"+request.getRemoteAddr() );
                purview.writeLog(map);
				
				//Extra Ring Information 
				if(ringablealias1.equalsIgnoreCase("1") || ringablealias2.equalsIgnoreCase("1") || sysfunction.get("2-66-0")== null ) {  

					hash.put("extraRingOpcode", request.getParameter("opcode") == null ? "" : transferString((String)request.getParameter("opcode"))); // 1 - add, 2 - delete, 3 - modify, opCode
					hash.put("opflag", "3"); // opFlag
					hash.put("language", request.getParameter("lang") == null ? "" : transferString((String)request.getParameter("lang"))); //para1
					hash.put("alias1", request.getParameter("ringalias1") == null ? "" : transferString((String)request.getParameter("ringalias1"))); // para2
					hash.put("alias2", request.getParameter("ringalias2") == null ? "" : transferString((String)request.getParameter("ringalias2"))); // para3
					hash.put("albumid", request.getParameter("albumid") == null ? "" : transferString((String)request.getParameter("albumid"))); //  para8
					hash.put("movieid", request.getParameter("movieid") == null ? "" : transferString((String)request.getParameter("movieid"))); //  para9
					hash.put("hiderecovertime", request.getParameter("hidetime") == null ? "" : transferString((String)request.getParameter("hidetime"))); //  para7
					hash.put("mediatype",  request.getParameter("mediatype") == null ? "" : transferString((String)request.getParameter("mediatype"))); //??? 
					hash.put("filetype",  request.getParameter("filetype") == null ? "" : transferString((String)request.getParameter("filetype"))); // ???
 					rList = colorRing.updateExtraRingInformation(hash);
					sysInfo.add(sysTime + operName + "Extra ringtone information modified successfully!");
					msg = "";
					msg = JspUtil.generateResultList(rList);
			        if(!msg.equals("")){
				       msg = msg.replace('\n',' ');
					   throw new Exception(msg);
					}
				 }
                %>
                <script language="JavaScript">
                window.returnValue = "yes";
                window.close();
                </script>
        <%}else{
		String opcode = "3"; // default modify
        // 查询铃音信息
        Map hash = (Map)colorRing.getRingInfo(ringid);
        if(hash==null||hash.size()<=0) {
        	throw new Exception(zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+ " record does not exist!");//铃音记录已不存在
		}
		 Map xtraHash = new HashMap();
            if(ringablealias1.equalsIgnoreCase("1") || ringablealias2.equalsIgnoreCase("1") || sysfunction.get("2-66-0")== null  ){
		Hashtable paramHash = new Hashtable();
		paramHash.put("ringid", ringid);
		paramHash.put("functype", "3"); // 3 - Ring
		ArrayList retAL = (ArrayList) colorRing.getExtraRingFuncInfo(paramHash);

        if(retAL == null || retAL.size()<=0) { 
			opcode = "1";
		} else {
			xtraHash = (HashMap) retAL.get(0);
		}
}

%>
<form name="inputForm" method="post" action="ringInfo.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="libid" value="<%=libid%>">
<input type="hidden" name="albumid" value="<%= xtraHash.get("albumid") == null ? "" : (String)xtraHash.get("albumid")%> ">
<input type="hidden" name="movieid" value="<%= xtraHash.get("albumid") == null ? "" : (String)xtraHash.get("movieid")%>">
<input type="hidden" name="opcode" value="<%=opcode%>">


<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
    <td>
      <br />
      <table  width="100%"  border="0">
      <tr>
          <td width="100%" align="center" valign="middle">
              <div id="hintContent" >
      <table border="0" align="center" class="table-style2">
         <tr>
          <td height="22" align="left" valign="center"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
          <td height="22" valign="center"><input type="text" name="ringid"  value="<%=(String)hash.get("ringid")%>" maxlength="20" class="input-style0"  readonly="readonly" ></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+ " "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
          <td height="22" valign="center"><input type="text" name="ringLabel"  value="<%=(String)hash.get("ringlabel")%>"  maxlength="40" class="input-style0"></td>
        </tr>
   
		<%if(ringablealias1.equalsIgnoreCase("1")) { %>
		 <tr>
          <td height="22" align="left"><%=sLangLabel1+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+ " "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
          <td height="22"><input type="text" name="ringalias1"  value="<%= xtraHash.get("alias1") == null ? "" : (String)xtraHash.get("alias1")%>"  maxlength="40" class="input-style0"></td>
        </tr>
		<% }
		 if(ringablealias2.equalsIgnoreCase("1")) { 
		%>
		<tr>
          <td height="22" align="left"><%=sLangLabel2+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+ " "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
          <td height="22"><input type="text" name="ringalias2"  value="<%= xtraHash.get("alias2") == null ? "" : (String)xtraHash.get("alias2")%>"  maxlength="40" class="input-style0"></td>
        </tr>
		<% }%>
        <tr>
          <td height="22" align="left" valign="center">Spelling of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
          <td height="22" valign="center"><input type="text" name="ringspell"  value="<%=(String)hash.get("ringspell")%>" maxlength="20" class="input-style0"></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name</td>
          <td height="22" valign="center"><input type="text" name="ringauthor" value="<%=(String)hash.get("ringauthor")%>"  maxlength="40" class="input-style0"></td>
        </tr>
        <tr style="display:none">
          <td height="22" align="left" style="display:none" >Ringtone provider</td>
          <td height="22" valign="center"><input type="hidden" name="ringsource"  value="<%=(String)hash.get("ringsource")%>"  maxlength="40" class="input-style0"></td>
        </tr>
        <tr style="display:none">
           <td height="22" align="left" valign="center">Free trial of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
           <td  align="center"><input type="radio" name="iffree" value="0" onclick="onIffreeCheck()">No &nbsp;&nbsp;
            <input type="radio" name="iffree" value="1" onClick="onIffreeCheck()">Yes</td>
        </tr>
       <%if(issupportmultipleprice == 1){%>
        <tr>
          <td height="22" align="left"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Daily price (<%=minorcurrency%>)</td>
          <td height="22"><input type="text" name="dailyprice" maxlength="9" value="<%=(String)hash.get("ringfee2")%>"  class="input-style0"></td>
        </tr>
        <%}
        if(!isSmartPriceFlag.equalsIgnoreCase("1"))
        {%>
		 <tr>
          <td height="22" align="left"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> <%if(issupportmultipleprice == 1){%>Monthly <%}%>price (<%=minorcurrency%>)</td>
          <td height="22"><input type="text" name="monthlyprice" maxlength="9" value="<%=(String)hash.get("ringfee")%>"  class="input-style0"></td>
        </tr>
       <%}%>
        <% if(userday.equalsIgnoreCase("1"))
        {%>
        <tr>
          <td height="22" align="left">Period of Validity</td>
          <td height="22"><input type="text" name="uservalidday"  value="<%=(String)hash.get("uservalidday")%>"  maxlength="4" class="input-style0"></td>
        </tr>
         <%}%>
            <tr>
          <td height="22" align="left">Period of copyright(yyyy.mm.dd)</td>
          
          <td height="22"><input type="text" name="validdate"  value="<%=jcalendar((String)hash.get("validtime"))%>"  maxlength="10" class="input-style0"></td>
        </tr>

		<% if(sysfunction.get("2-66-0")== null ) { %>
		<tr>
          <td height="26" align="left"  class="text-title" > Extra Ring Information </td>
        </tr>
  		<%	  String sFileType=(String)xtraHash.get("filetype");
			  String sMediaType=(String)xtraHash.get("mediatype");
			  String sMediaName="";
			  String sFileTypeName="";
			  if(!sMediaType.equals("") && sMediaType.equals("1")) {
				  sMediaName="Audio";
              }else if(!sMediaType.equals("") && sMediaType.equals("2")) {
				  sMediaName="Video";
			  }else if(!sMediaType.equals("") && sMediaType.equals("4")) {
				  sMediaName="Image";
			  }

			   if(!sFileType.equals("") && sFileType.equals("1")) {
				  sFileTypeName="Wav";
              }else if(!sFileType.equals("") && sFileType.equals("2")) {
				  sFileTypeName="Mov";
			  }else if(!sFileType.equals("") && sFileType.equals("4")) {
				  sFileTypeName="Gif";
			  }else if(!sFileType.equals("") && sFileType.equals("8")) {
				  sFileTypeName="Jpg";
			  }else if(!sFileType.equals("") && sFileType.equals("16")) {
				  sFileTypeName="Bmp";
			  }else if(!sFileType.equals("") && sFileType.equals("32")) {
				  sFileTypeName="Txt";
			  }else if(!sFileType.equals("") && sFileType.equals("64")) {
				  sFileTypeName="3GP";
			  }

		  %>
		<tr>
          <td height="22" align="left">Media Type</td>
          <td height="22"><input type="number" name="mediatype"  value="<%=sMediaName%>" readonly maxlength="10" class="input-style0"></td>
        </tr>
		<tr>
          <td height="22" align="left">File Type</td>
          <td height="22"><input type="number" name="filetype"  value="<%=sFileTypeName%>" readonly maxlength="10" class="input-style0"></td>
        </tr>
		<tr>
          <td height="22" align="left">Album</td>
          <td height="22"><input type="text" name="album"  value="<%= xtraHash.get("albumname") == null ? "" : (String)xtraHash.get("albumname")%>"  maxlength="40" class="input-style0" readonly><img  height="15" src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo(1)"></td>
        </tr>
		<tr>
          <td height="22" align="left">Movie</td>
          <td height="22" ><input type="text" name="movie"  value="<%= xtraHash.get("moviename") == null ? "" : (String)xtraHash.get("moviename")%>"  maxlength="40" class="input-style0" readonly><img  height="15" src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo(2)"></td>
        </tr>
		<tr>
          <td height="22" align="left">Hide or Recover Time (yyyy.mm.dd)</td>
          <td height="22"><input type="text" name="hidetime"  value="<%= xtraHash.get("hiderecovertime") == null ? "" : (String)xtraHash.get("hiderecovertime")%>"  maxlength="10" class="input-style0"></td>
        </tr>
		<tr>
          <td height="22" align="left">Language</td>
          <td height="22"><input type="text" name="lang"  value="<%= xtraHash.get("language") == null ? "" : (String)xtraHash.get("language")%>"  maxlength="40" class="input-style0"></td>
        </tr>
		<% } %>
      </table>
              </div>
          </td>
      </tr>
      <tr>
          <td width="100%" align="center" height="16" align="center">
              <img src="button/sure.gif" alt="OK" onmouseover="this.style.cursor='hand'" onclick="javascript:ok()" >
                  &nbsp;&nbsp;
              <img src="button/cancel.gif" alt="Cancel" onmouseover="this.style.cursor='hand'" onclick="javascript:cancel()" >
        </td>
          </tr>
        </table>

    </td>
  </tr>
</table>
</form>
<%
}
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in editing Ringtone " + ringid + "!");//Edit铃音  出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error in editing this ringtone!");//Edit铃音错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
   alert("Exception occurred in editing <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> <%= ringid%> :<%= e.getMessage() %>");//Edit铃音  出现异常
   window.close();
</script>
<%
    }
%>
</body>
</html>
