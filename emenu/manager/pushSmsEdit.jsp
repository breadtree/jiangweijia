<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%

    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
%>
<html>
<head>
<title>Edit Sms</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script language="JavaScript">
String.prototype.ReplaceAll = stringReplaceAll;

function  stringReplaceAll(AFindText,ARepText){
  raRegExp = new RegExp(AFindText,"g");
  return this.replace(raRegExp,ARepText)
}
function CheckStrHaveComma(Sender,strName)
  {
  	var i = 0;
	var sValue = Sender.value;
	for( i = 0; i < sValue.length;  i++)
	{
		var sChar = sValue.charAt(i);
		if (sChar==',')
                         {
			alert(strName +" cannot include the character ','!");//should not contain illegal character
			//Sender.select();
			Sender.focus();
			return false;
		}
	}
	return true;
  }
   function edit () {

      var fm = document.inputForm;
      var content1 = fm.const1.value.ReplaceAll("\r\n","");

      if (trim(content1) == ''&&((fm.var1.value=="-1")||(fm.var1.value)=="0")) {
         alert('If fixed content1 is empty, variable content1 can not to be set none.');
         fm.var1.focus();
         return false;
      }
       <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.const1.value,1024)){
            alert("Fixed content1 may not be more than 1024 characters");
            fm.const1.focus();
            return;
          }
        <%
        }
        else{
        %>
         if((fm.const1.value).length>1024)
     {
         alert("Fixed content1 may not be more than 1024 characters");
         fm.const1.focus();
         return false;
    }
 <%}%>
 if(!CheckStrHaveComma(fm.const1, 'Fixed content1'))
    {
     return false;
    }
    <%
    if(ifuseutf8 == 1){
      %>
      if(!checkUTFLength(fm.const2.value,255)){
        alert("Fixed content2 may not be more than 255 characters");
        fm.const2.focus();
        return;
      }
      <%
    }
    else{
      %>
      if((fm.const2.value).length>255)
      {
        alert("Fixed content2 may not be more than 255 characters");
        fm.const2.focus();
        return false;
      }
      <%}%>

    if(!CheckStrHaveComma(fm.const2, 'Fixed content2'))
    {
     return false;
    }
    <%
    if(ifuseutf8 == 1){
      %>
      if(!checkUTFLength(fm.const3.value,255)){
        alert("Fixed content3 may not be more than 255 characters");
        fm.const3.focus();
        return;
      }
      <%
    }
    else{
      %>
      if((fm.const3.value).length>255)
      {
        alert("Fixed content3 may not be more than 255 characters");
        fm.const3.focus();
        return false;
      }
      <%}%>

    if(!CheckStrHaveComma(fm.const3, 'Fixed content3'))
    {
     return false;
    }
    <%
    if(ifuseutf8 == 1){
      %>
      if(!checkUTFLength(fm.const4.value,255)){
        alert("Fixed content4 may not be more than 255 characters");
        fm.const4.focus();
        return;
      }
      <%
    }
    else{
      %>
      if((fm.const4.value).length>255)
      {
        alert("Fixed content4 may not be more than 255 characters");
        fm.const4.focus();
        return false;
      }
      <%}%>


    if(!CheckStrHaveComma(fm.const4, 'Fixed content4'))
    {
     return false;
    }
 <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.const5.value,255)){
            alert("Fixed content5 may not be more than 255 characters");
            fm.const5.focus();
            return;
          }
          <%
        }
        else{
          %>
          if((fm.const5.value).length>255)
          {
            alert("Fixed content5 may not be more than 255 characters");
            fm.const5.focus();
            return false;
          }
          <%}%>


    if(!CheckStrHaveComma(fm.const5, 'Fixed content5'))
    {
     return false;
    }
 <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.const6.value,255)){
            alert("Fixed content6 may not be more than 255 characters");
            fm.const6.focus();
            return;
          }
        <%
        }
        else{
        %>
        if((fm.const6.value).length>255)
        {
         alert("Fixed content6 may not be more than 255 characters");
         fm.const6.focus();
         return false;
       }
    <%}%>


    if(!CheckStrHaveComma(fm.const6, 'Fixed content6'))
    {
     return false;
    }

   <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.const1.value+fm.const2.value+fm.const3.value+fm.const4.value+fm.const5.value+fm.const6.value,1024)){
            alert("Total fixed content may not be more than 1024 characters");
            fm.const1.focus();
            return;
          }
        <%
        }
        else{
        %>
        if((fm.const1.value+fm.const2.value+fm.const3.value+fm.const4.value+fm.const5.value+fm.const6.value).length>1024)
        {
         alert("Total fixed content may not be more than 1024 characters");
         fm.const1.focus();
         return false;
       }
    <%}%>

      fm.party[0].disabled = false;
      fm.party[1].disabled = false;

      fm.op.value = 'edit';
      fm.submit();
   }

function cancel(){
  window.returnValue = "no";
  window.close();
}
</script>
</head>
<base target="_self">
<body topmargin="0" leftmargin="0" class="body-style1"  background="background.gif" >
<%

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String smsno = request.getParameter("smsno") == null ? "" : ((String)request.getParameter("smsno")).trim();
    String party = request.getParameter("party") == null ? "" : ((String)request.getParameter("party")).trim();
	String retcode = request.getParameter("retcode") == null ? "" : ((String)request.getParameter("retcode")).trim();
	String langno = request.getParameter("langno") == null ? "2" : ((String)request.getParameter("langno")).trim();
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
    if(operName == null ||"".equals(operName)||session.getAttribute("SPCODE")!=null)
               //throw new Exception("您无权使用此功能或你的登陆信息已过期!");
                 throw new Exception("You have no access to the system or your login info have expired!");
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
		manSysPara syspara = new manSysPara();
		String isSuprtMultiLangSms = syspara.getParaValue(20223);
        if(op.equals("edit")){
        String isvalid = request.getParameter("valid") == null ? "1" : transferString((String)request.getParameter("valid"));
        String var1 = request.getParameter("var1") == null ? "-1" : transferString((String)request.getParameter("var1"));
        String var2 = request.getParameter("var2") == null ? "-1" : transferString((String)request.getParameter("var2"));
        String var3 = request.getParameter("var3") == null ? "-1" : transferString((String)request.getParameter("var3"));
        String var4 = request.getParameter("var4") == null ? "-1" : transferString((String)request.getParameter("var4"));
        String var5 = request.getParameter("var5") == null ? "-1" : transferString((String)request.getParameter("var5"));
        String var6 = request.getParameter("var6") == null ? "-1" : transferString((String)request.getParameter("var6"));

        String const1 = request.getParameter("const1") == null ? "" : transferString((String)request.getParameter("const1"));
        const1=const1.replaceAll("\r\n", "");
        if(checkLen(const1,1024))
               throw new Exception("The length of the Fixed content1 you entered has exceeded the limit. Please re-enter!");
        String const2 = request.getParameter("const2") == null ? "" : transferString((String)request.getParameter("const2"));
        const2=const2.replaceAll("\r\n", "");
        if(checkLen(const2,255))
        	throw new Exception("The length of the Fixed content2 you entered has exceeded the limit. Please re-enter!");
        String const3 = request.getParameter("const3") == null ? "" : transferString((String)request.getParameter("const3"));
        const3=const3.replaceAll("\r\n", "");
        if(checkLen(const3,255))
        	throw new Exception("The length of the Fixed content3 you entered has exceeded the limit. Please re-enter!");
        String const4 = request.getParameter("const4") == null ? "" : transferString((String)request.getParameter("const4"));
        const4=const4.replaceAll("\r\n", "");
        if(checkLen(const4,255))
        	throw new Exception("The length of the Fixed content4 you entered has exceeded the limit. Please re-enter!");
        String const5 = request.getParameter("const5") == null ? "" : transferString((String)request.getParameter("const5"));
        const5=const5.replaceAll("\r\n", "");
        if(checkLen(const5,255))
        	throw new Exception("The length of the Fixed content5 you entered has exceeded the limit. Please re-enter!");
        String const6 = request.getParameter("const6") == null ? "" : transferString((String)request.getParameter("const6"));
        const6=const6.replaceAll("\r\n", "");
        if(checkLen(const6,255))
        	throw new Exception("The length of the Fixed content6 you entered has exceeded the limit. Please re-enter!");

                manSysRing manring = new manSysRing();
                ArrayList rList = null;
                Hashtable hash = new Hashtable();
                hash.put("optype","3");
                hash.put("smsno",smsno);
                hash.put("isvalid",isvalid);
                hash.put("party",party);
                hash.put("const1",const1);
                hash.put("var1",var1);
                hash.put("const2",const2);
                hash.put("var2",var2);
                hash.put("const3",const3);
                hash.put("var3",var3);
                hash.put("const4",const4);
                hash.put("var4",var4);
                hash.put("const5",const5);
                hash.put("var5",var5);
                hash.put("const6",const6);
                hash.put("var6",var6);
				hash.put("retcode",retcode);
                hash.put("langno",langno);
                if(isSuprtMultiLangSms.equals("1")){
                rList = syspara.editPushSmsLang(hash);
                }else
                rList = syspara.editPushSms(hash);
                sysInfo.add(sysTime + operName + " push sms modified successfully!");//修改成功
                String msg = JspUtil.generateResultList(rList);
                if(!msg.equals("")){
                   msg = msg.replace('\n',' ');
                   throw new Exception(msg);
                }
                // 准备写操作员日志
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("SERVICEKEY",manring.getSerkey());
                map.put("OPERTYPE","335");
                map.put("RESULT","1");
                map.put("PARA1",smsno);
                map.put("PARA2",isvalid);
                map.put("PARA3",party);
                map.put("PARA4","");
                map.put("PARA5",var1);
                map.put("DESCRIPTION","Modify "+"Push Sms:"+smsno);
                purview.writeLog(map);

                %>
                <script language="JavaScript">
                window.returnValue = "yes";
                window.close();
                </script>
        <%}else{
          if(smsno.trim().length()==0||party.trim().length()==0)
          {
           throw new Exception("Please choose the sms record.");
          }
        // 查询sms信息
		Map hash = null;
         if(isSuprtMultiLangSms.equals("1")){
		  hash = (Map)syspara.getPushSmsCfgFromLangID(Integer.parseInt(smsno),Integer.parseInt(party),retcode,langno);
        }else{
	      hash = (Map)syspara.getPushSmsCfgFromID(Integer.parseInt(smsno),Integer.parseInt(party),retcode);
        }
        if(hash==null||hash.size()<=0)
        	throw new Exception("sms record does not exist!");//记录已不存在
		System.out.println("FIXED CONTENT2 in JSP::"+(String)hash.get("const2"));

%>
<form name="inputForm" method="post" action="pushSmsEdit.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="langno" value="<%= langno %>">
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
          <td height="22" align="right" width="35%">Sms No.&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" ><input type="text" name="smsno"  value="<%=(String)hash.get("smsno")%>" maxlength="20" class="input-style0"  readonly="readonly" ></td>
        </tr>
        <tr>
          <td height="22" align="right" >Description&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" ><textarea name="descrip" readonly="readonly"  cols="40" rows="2" style="border: 1px solid #E6ECFF;font-size: 13px"><%=(String)hash.get("descrip")%></textarea>
          </td>
        </tr>
        <tr>
           <td height="22" align="right" valign="center">Valid&nbsp;&nbsp;&nbsp;&nbsp;</td>
           <td  align="left"><input type="radio" name="valid" value="1"
             <%String valid = (String)hash.get("isvalid");
             if(valid.equals("1")){ %>
             checked="checked"
             <%}%>
             >yes &nbsp;&nbsp;
            <input type="radio" name="valid" value="0"
              <%if(valid.equals("0")){ %>
             checked="checked"
             <%}%>
            >no</td>
        </tr>
        <tr>
           <td height="22" align="right">Party&nbsp;&nbsp;&nbsp;&nbsp;</td>
           <td  align="left"><input type="radio" disabled="disabled" name="party" value="1"
             <%if(party.equals("1")){ %>
             checked="checked"
             <%}%>
             >calling &nbsp;&nbsp;
            <input type="radio" name="party" disabled="disabled" value="2"
              <%if(party.equals("2")){ %>
             checked="checked"
             <%}%>
            >called</td>
        </tr>


      <tr>
          <td height="22" align="right" >Fixed content1&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" ><textarea name="const1"  cols="40" rows="4" style="border: 1px solid #E6ECFF;font-size: 13px"><%=(String)hash.get("const1")%></textarea>
          </td>
      </tr>
      <tr>
          <td height="22" align="right" >Variable content1&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" >
      <%
      int var1 =Integer.parseInt ((String)hash.get("var1"));
      %>
     <select name="var1" class="input-style1">
       <option value="-1" <%if(var1==-1){%>
         selected="selected"
       <%}%>
       >No Set</option>
       <option value="1" <%if(var1==1){%>
       selected="selected"
       <%}%>
       >Calling number</option>
       <option value="2" <%if(var1==2){%>
       selected="selected"
       <%}%>
       >Called number</option>
       <option value="3" <%if(var1==3){%>
       selected="selected"
       <%}%>
       >User password</option>
       <option value="100" <%if(var1==100){%>
       selected="selected"
       <%}%>
       >Rent start date</option>
        <option value="101" <%if(var1==101){%>
       selected="selected"
       <%}%>
       >Maturity date</option>
       <!--
       <option value="200" <%if(var1==200){%>
       selected="selected"
       <%}%>
       >Month fee</option>
       -->
       <option value="300" <%if(var1==300){%>
       selected="selected"
       <%}%>
       >Group Id</option>
       <option value="301" <%if(var1==301){%>
       selected="selected"
       <%}%>
       >Group name</option>
       <option value="400" <%if(var1==400){%>
       selected="selected"
       <%}%>
       >Ring Id</option>
       <option value="401" <%if(var1==401){%>
       selected="selected"
       <%}%>
       >Ring price</option>
       <option value="402" <%if(var1==402){%>
       selected="selected"
       <%}%>
       >Ring name</option>
       <option value="403" <%if(var1==403){%>
       selected="selected"
       <%}%>
       >Ring validdate</option>
       <option value="404" <%if(var1==404){%>
       selected="selected"
       <%}%>
       >Singer</option>
       <option value="500" <%if(var1==500){%>
       selected="selected"
       <%}%>
       >Ringgroup Id</option>
       <option value="501" <%if(var1==501){%>
       selected="selected"
       <%}%>
       >Ringgroup price</option>
       <option value="502" <%if(var1==502){%>
       selected="selected"
       <%}%>
       >Ringgroup name</option>
       <option value="503" <%if(var1==503){%>
       selected="selected"
       <%}%>
       >Ringgroup validdate</option>

         </select>
       </td>
      </tr>

       <tr>
          <td height="22" align="right" >Fixed content2&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" ><textarea name="const2"  cols="40" rows="3" style="border: 1px solid #E6ECFF;font-size: 13px"><%=(String)hash.get("const2")%></textarea>
          </td>
      </tr>
      <tr>
          <td height="22" align="right" >Variable content2&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" >
      <%
      int var2 =Integer.parseInt ((String)hash.get("var2"));
      %>
     <select name="var2" class="input-style1">
       <option value="-1" <%if(var2==-1){%>
         selected="selected"
       <%}%>
       >No Set</option>
       <option value="1" <%if(var2==1){%>
       selected="selected"
       <%}%>
       >Calling number</option>
       <option value="2" <%if(var2==2){%>
       selected="selected"
       <%}%>
       >Called number</option>
       <option value="3" <%if(var2==3){%>
       selected="selected"
       <%}%>
       >User password</option>
       <option value="100" <%if(var2==100){%>
       selected="selected"
       <%}%>
       >Rent start date</option>
        <option value="101" <%if(var2==101){%>
       selected="selected"
       <%}%>
       >Maturity date</option>
       <!--
       <option value="200" <%if(var2==200){%>
       selected="selected"
       <%}%>
       >Month fee</option>
       -->
       <option value="300" <%if(var2==300){%>
       selected="selected"
       <%}%>
       >Group Id</option>
       <option value="301" <%if(var2==301){%>
       selected="selected"
       <%}%>
       >Group name</option>
       <option value="400" <%if(var2==400){%>
       selected="selected"
       <%}%>
       >Ring Id</option>
       <option value="401" <%if(var2==401){%>
       selected="selected"
       <%}%>
       >Ring price</option>
       <option value="402" <%if(var2==402){%>
       selected="selected"
       <%}%>
       >Ring name</option>
       <option value="403" <%if(var2==403){%>
       selected="selected"
       <%}%>
       >Ring validdate</option>
       <option value="404" <%if(var2==404){%>
       selected="selected"
       <%}%>
       >Singer</option>
       <option value="500" <%if(var2==500){%>
       selected="selected"
       <%}%>
       >Ringgroup Id</option>
       <option value="501" <%if(var2==501){%>
       selected="selected"
       <%}%>
       >Ringgroup price</option>
       <option value="502" <%if(var2==502){%>
       selected="selected"
       <%}%>
       >Ringgroup name</option>
       <option value="503" <%if(var2==503){%>
       selected="selected"
       <%}%>
       >Ringgroup validdate</option>

         </select>
       </td>
      </tr>

       <tr>
          <td height="22" align="right" >Fixed content3&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" ><textarea name="const3"  cols="40" rows="3" style="border: 1px solid #E6ECFF;font-size: 13px"><%=(String)hash.get("const3")%></textarea>
          </td>
      </tr>
      <tr>
          <td height="22" align="right" >Variable content3&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" >
      <%
      int var3 =Integer.parseInt ((String)hash.get("var3"));
      %>
     <select name="var3" class="input-style1">
       <option value="-1" <%if(var3==-1){%>
         selected="selected"
       <%}%>
       >No Set</option>
       <option value="1" <%if(var3==1){%>
       selected="selected"
       <%}%>
       >Calling number</option>
       <option value="2" <%if(var3==2){%>
       selected="selected"
       <%}%>
       >Called number</option>
       <option value="3" <%if(var3==3){%>
       selected="selected"
       <%}%>
       >User password</option>
       <option value="100" <%if(var3==100){%>
       selected="selected"
       <%}%>
       >Rent start date</option>
        <option value="101" <%if(var3==101){%>
       selected="selected"
       <%}%>
       >Maturity date</option>
       <!--
       <option value="200" <%if(var3==200){%>
       selected="selected"
       <%}%>
       >Month fee</option>
       -->
       <option value="300" <%if(var3==300){%>
       selected="selected"
       <%}%>
       >Group Id</option>
       <option value="301" <%if(var3==301){%>
       selected="selected"
       <%}%>
       >Group name</option>
       <option value="400" <%if(var3==400){%>
       selected="selected"
       <%}%>
       >Ring Id</option>
       <option value="401" <%if(var3==401){%>
       selected="selected"
       <%}%>
       >Ring price</option>
       <option value="402" <%if(var3==402){%>
       selected="selected"
       <%}%>
       >Ring name</option>
       <option value="403" <%if(var3==403){%>
       selected="selected"
       <%}%>
       >Ring validdate</option>
       <option value="404" <%if(var3==404){%>
       selected="selected"
       <%}%>
       >Singer</option>
       <option value="500" <%if(var3==500){%>
       selected="selected"
       <%}%>
       >Ringgroup Id</option>
       <option value="501" <%if(var3==501){%>
       selected="selected"
       <%}%>
       >Ringgroup price</option>
       <option value="502" <%if(var3==502){%>
       selected="selected"
       <%}%>
       >Ringgroup name</option>
       <option value="503" <%if(var3==503){%>
       selected="selected"
       <%}%>
       >Ringgroup validdate</option>

         </select>
       </td>
      </tr>

       <tr>
          <td height="22" align="right" >Fixed content4&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" ><textarea name="const4"  cols="40" rows="3" style="border: 1px solid #E6ECFF;font-size: 13px"><%=(String)hash.get("const4")%></textarea>
          </td>
      </tr>
      <tr>
          <td height="22" align="right" >Variable content4&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" >
      <%
      int var4 =Integer.parseInt ((String)hash.get("var4"));
      %>
     <select name="var4" class="input-style1">
       <option value="-1" <%if(var4==-1){%>
         selected="selected"
       <%}%>
       >No Set</option>
       <option value="1" <%if(var4==1){%>
       selected="selected"
       <%}%>
       >Calling number</option>
       <option value="2" <%if(var4==2){%>
       selected="selected"
       <%}%>
       >Called number</option>
       <option value="3" <%if(var4==3){%>
       selected="selected"
       <%}%>
       >User password</option>
       <option value="100" <%if(var4==100){%>
       selected="selected"
       <%}%>
       >Rent start date</option>
        <option value="101" <%if(var4==101){%>
       selected="selected"
       <%}%>
       >Maturity date</option>
       <!--
       <option value="200" <%if(var4==200){%>
       selected="selected"
       <%}%>
       >Month fee</option>
       -->
       <option value="300" <%if(var4==300){%>
       selected="selected"
       <%}%>
       >Group Id</option>
       <option value="301" <%if(var4==301){%>
       selected="selected"
       <%}%>
       >Group name</option>
       <option value="400" <%if(var4==400){%>
       selected="selected"
       <%}%>
       >Ring Id</option>
       <option value="401" <%if(var4==401){%>
       selected="selected"
       <%}%>
       >Ring price</option>
       <option value="402" <%if(var4==402){%>
       selected="selected"
       <%}%>
       >Ring name</option>
       <option value="403" <%if(var4==403){%>
       selected="selected"
       <%}%>
       >Ring validdate</option>
       <option value="404" <%if(var4==404){%>
       selected="selected"
       <%}%>
       >Singer</option>
       <option value="500" <%if(var4==500){%>
       selected="selected"
       <%}%>
       >Ringgroup Id</option>
       <option value="501" <%if(var4==501){%>
       selected="selected"
       <%}%>
       >Ringgroup price</option>
       <option value="502" <%if(var4==502){%>
       selected="selected"
       <%}%>
       >Ringgroup name</option>
       <option value="503" <%if(var4==503){%>
       selected="selected"
       <%}%>
       >Ringgroup validdate</option>

         </select>
       </td>
      </tr>

       <tr>
          <td height="22" align="right" >Fixed content5&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" ><textarea name="const5"  cols="40" rows="3" style="border: 1px solid #E6ECFF;font-size: 13px"><%=(String)hash.get("const5")%></textarea>
          </td>
      </tr>
      <tr>
          <td height="22" align="right" >Variable content5&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" >
      <%
      int var5 =Integer.parseInt ((String)hash.get("var5"));
      %>
     <select name="var5" class="input-style1">
       <option value="-1" <%if(var5==-1){%>
         selected="selected"
       <%}%>
       >No Set</option>
       <option value="1" <%if(var5==1){%>
       selected="selected"
       <%}%>
       >Calling number</option>
       <option value="2" <%if(var5==2){%>
       selected="selected"
       <%}%>
       >Called number</option>
       <option value="3" <%if(var5==3){%>
       selected="selected"
       <%}%>
       >User password</option>
       <option value="100" <%if(var5==100){%>
       selected="selected"
       <%}%>
       >Rent start date</option>
        <option value="101" <%if(var5==101){%>
       selected="selected"
       <%}%>
       >Maturity date</option>
       <!--
       <option value="200" <%if(var5==200){%>
       selected="selected"
       <%}%>
       >Month fee</option>
       -->
       <option value="300" <%if(var5==300){%>
       selected="selected"
       <%}%>
       >Group Id</option>
       <option value="301" <%if(var5==301){%>
       selected="selected"
       <%}%>
       >Group name</option>
       <option value="400" <%if(var5==400){%>
       selected="selected"
       <%}%>
       >Ring Id</option>
       <option value="401" <%if(var5==401){%>
       selected="selected"
       <%}%>
       >Ring price</option>
       <option value="402" <%if(var5==402){%>
       selected="selected"
       <%}%>
       >Ring name</option>
       <option value="403" <%if(var5==403){%>
       selected="selected"
       <%}%>
       >Ring validdate</option>
       <option value="404" <%if(var5==404){%>
       selected="selected"
       <%}%>
       >Singer</option>
       <option value="500" <%if(var5==500){%>
       selected="selected"
       <%}%>
       >Ringgroup Id</option>
       <option value="501" <%if(var5==501){%>
       selected="selected"
       <%}%>
       >Ringgroup price</option>
       <option value="502" <%if(var5==502){%>
       selected="selected"
       <%}%>
       >Ringgroup name</option>
       <option value="503" <%if(var5==503){%>
       selected="selected"
       <%}%>
       >Ringgroup validdate</option>

         </select>
       </td>
      </tr>

       <tr>
          <td height="22" align="right" >Fixed content6&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" ><textarea name="const6"  cols="40" rows="3" style="border: 1px solid #E6ECFF;font-size: 13px"><%=(String)hash.get("const6")%></textarea>
          </td>
      </tr>
      <tr>
          <td height="22" align="right" >Variable content6&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td height="22" >
      <%
      int var6 =Integer.parseInt ((String)hash.get("var6"));
      %>
     <select name="var6" class="input-style1">
       <option value="-1" <%if(var6==-1){%>
         selected="selected"
       <%}%>
       >No Set</option>
       <option value="1" <%if(var6==1){%>
       selected="selected"
       <%}%>
       >Calling number</option>
       <option value="2" <%if(var6==2){%>
       selected="selected"
       <%}%>
       >Called number</option>
       <option value="3" <%if(var6==3){%>
       selected="selected"
       <%}%>
       >User password</option>
       <option value="100" <%if(var6==100){%>
       selected="selected"
       <%}%>
       >Rent start date</option>
        <option value="101" <%if(var6==101){%>
       selected="selected"
       <%}%>
       >Maturity date</option>
       <!--
       <option value="200" <%if(var6==200){%>
       selected="selected"
       <%}%>
       >Month fee</option>
       -->
       <option value="300" <%if(var6==300){%>
       selected="selected"
       <%}%>
       >Group Id</option>
       <option value="301" <%if(var6==301){%>
       selected="selected"
       <%}%>
       >Group name</option>
       <option value="400" <%if(var6==400){%>
       selected="selected"
       <%}%>
       >Ring Id</option>
       <option value="401" <%if(var6==401){%>
       selected="selected"
       <%}%>
       >Ring price</option>
       <option value="402" <%if(var6==402){%>
       selected="selected"
       <%}%>
       >Ring name</option>
       <option value="403" <%if(var6==403){%>
       selected="selected"
       <%}%>
       >Ring validdate</option>
       <option value="404" <%if(var6==404){%>
       selected="selected"
       <%}%>
       >Singer</option>
       <option value="500" <%if(var6==500){%>
       selected="selected"
       <%}%>
       >Ringgroup Id</option>
       <option value="501" <%if(var6==501){%>
       selected="selected"
       <%}%>
       >Ringgroup price</option>
       <option value="502" <%if(var6==502){%>
       selected="selected"
       <%}%>
       >Ringgroup name</option>
       <option value="503" <%if(var6==503){%>
       selected="selected"
       <%}%>
       >Ringgroup validdate</option>

         </select>
       </td>
      </tr>
	  <tr>
		  <td height="22" align="right" >Return code&nbsp;&nbsp;&nbsp;&nbsp;</td>
		  <td height="22" >
			  <input type="text" name="retcode"  value="<%=(String)hash.get("retcode")%>" maxlength="10" class="input-style0"  readonly="readonly" >
		  </td>
	  </tr>
      </table>
              </div>
          </td>
      </tr>
      <tr>
          <td width="100%" align="center" height="16" align="center">
              <img src="button/sure.gif" alt="OK" onmouseover="this.style.cursor='hand'" onclick="javascript:edit()" >
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
        sysInfo.add(sysTime + operName + " Exception occurred in editing Sms " + smsno + "!");//Edit出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error in editing this Sms!");//Edit错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
   alert("Exception occurred in editing Sms <%= smsno%> :<%= e.getMessage() %>");//Edit  出现异常
   window.close();
</script>
<%
    }
%>
</body>
</html>
