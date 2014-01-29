<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="zte.zxyw50.util.CrbtUtil" %>
<%@page import="zte.zxyw50.util.JCalendar"%>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%!
int isfarsicalendar = CrbtUtil.getConfig("isfarsicalendar", 0);
JCalendar cal = new JCalendar();
public String jcalendar(String str){
	if(isfarsicalendar == 1){
		str = cal.gregorianToPersian(str); 
	}	
	return str;
}
public String ParsiToEng(String str){
	if(isfarsicalendar == 1){
		str = cal.persianToGregorian(str);
	}
	return str;
}
%>
<%
   String issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice","0");
   int isCombodia =  zte.zxyw50.util.CrbtUtil.getConfig("isCombodia",0);
   String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
	String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");

String userday = CrbtUtil.getConfig("uservalidday","0");
String springfee = CrbtUtil.getConfig("springfee","0");
String spuservalidday = CrbtUtil.getConfig("spuservalidday","0");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    ywaccess oYwAccess = new ywaccess();
    int cmpval = oYwAccess.getParameter(52);
%>
<html>
<head>
<title>Ringtone Edit</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
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
         alert('Please input Ringtone name');
         fm.ringLabel.focus();
         return;
      }
      if (!CheckInputStr(fm.ringLabel,'Ringtone name')){
         fm.ringLabel.focus();
         return;
      }
      if (trim(fm.ringspell.value) == '') {
         alert('Please input ringtone spell.');
         fm.ringspell.focus();
         return;
      }
     <%if(isCombodia==0){%>
      if(!CheckInputChar1(fm.ringspell,' ringtone spell')){
      	fm.ringspell.focus();
      	return;
      }
     <%}%>
      if (trim(fm.ringauthor.value) == '') {
         alert('Please input singer name');
         fm.ringauthor.focus();
         return;
      }
      <%if("1".equals(issupportmultipleprice)){%>
      var price = trim(fm.price.value);
      if(price==''){
         alert('Please input Monthly ringtone price.');
         fm.price.focus();
         return;
      }
      var price2 = trim(fm.price2.value);
        if(price2==''){
         alert('Please input Daily ringtone price.');
         fm.price2.focus();
         return;
      }
        <%} else {%>
        var price = trim(fm.price.value);
        if(price==''){
           alert('Please input  ringtone price.');
           fm.price.focus();
           return;
        }
      <%}%>
      <%if("1".equals(issupportmultipleprice)){%>
      if (! checkfee(price)) {
         alert('Invalid Monthly ringtone price.');
         fm.price.focus();
         return;
      }
      if (! checkfee(price2)) {
          alert('Invalid Daily ringtone price.');
          fm.price2.focus();
          return;
       }
     <%} else {%>
     if (! checkfee(price)) {
         alert('Invalid  ringtone price.');
         fm.price.focus();
         return;
      }
      <%}%>
   <%//begin add 用户有效期
        if(userday.equalsIgnoreCase("1")){
          %>
          //begin add 用户有效期
          var tmp1 = trim(fm.uservalidday.value);
          if ( tmp1 == '') {
            alert('Please input ringtone user validity!');
            fm.uservalidday.focus();
            return ;
          }
          if (!checkstring('0123456789',tmp1)) {
            alert('Ringtone user validity must be digits.');
            fm.uservalidday.focus();
            return ;
          }
      //end
      <%}%>
      var validdate = trim(fm.validdate.value);
      if(validdate==''){
          alert('Please input ringtone copyright validity!');
          fm.validdate.focus();
          return ;
      }
      if(!checkDate2(validdate)){
          alert('Invalid ringtone copyright validity,please input again!');
          fm.validdate.focus();
          return ;
      }
      /*if(checktrue2(validdate)){
          alert('The ringtone copyright validity time can NOT be sooner than today.Please input again.');
          fm.validdate.focus();
          return ;
      }*/
      if(checktrueyear(validdate,'<%=expireTime%>')){
         alert("The validate can not earlier than <%=expireTime%>, please re-enter!");
          fm.validdate.focus();
          return ;
      }
      
      <%if("1".equals(issupportmultipleprice)){%>
      fm.price.disabled = false;
      fm.price2.disabled = false;
      <%}else{%>
      fm.price.disabled = false;
      <%}%>
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
</script>
</head>
<base target="_self">
<body topmargin="0" leftmargin="0" class="body-style1"  background="background.gif" >
<%
String spIndex = (String)session.getAttribute("SPINDEX");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String ringid = request.getParameter("ringid") == null ? "" : ((String)request.getParameter("ringid")).trim();
    String libid =  request.getParameter("libid") == null ? "503" : ((String)request.getParameter("libid")).trim();
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    HashMap opmap = new HashMap();
    try {
     if (operID == null || purviewList.get("10-2") == null)
          throw new Exception("No this function or your session invalidate!");
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        if(op.equals("edit")){
            String crid = request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid");
            String craccount = libid;
            String ringLabel = request.getParameter("ringLabel") == null ? "" : transferString((String)request.getParameter("ringLabel"));
            if(checkLen(ringLabel,40))
               throw new Exception("The length of Ringtone name is more than limit,please input again.");
            String ringauthor = request.getParameter("ringauthor") == null ? "" : transferString((String)request.getParameter("ringauthor"));
          if(checkLen(ringauthor,40))
        	throw new Exception("The length of Singer name is more than limit,please input again!");
         String ringsource = request.getParameter("ringsource") == null ? "" : transferString((String)request.getParameter("ringsource"));
         if(checkLen(ringsource,40))
        	throw new Exception("The length of ringtone Provider name is more than limit.Please input again.");
          String price = request.getParameter("price") == null ? "0" : (String)request.getParameter("price");
          String price2 = request.getParameter("price2") == null ? "0" : (String)request.getParameter("price2");
          String validdate = request.getParameter("validdate") == null ? "" : (String)request.getParameter("validdate");
          String ringspell = request.getParameter("ringspell") == null ? "" : (String)request.getParameter("ringspell");
      String uservalidday = request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday");
           int ischeckop = 0 ;
           String msg = "",mess="";
           SpManage sm = new SpManage();
           ischeckop = sm.getSpOperischeck(spIndex);
  
           manSysRing manring = new manSysRing();
           if(ischeckop==0)
           {
                ArrayList rList = null;
                Hashtable hash = new Hashtable();
                String iffree = "-1";
                hash.put("usernumber",craccount);
                hash.put("ringid",crid);
                hash.put("ringlabel",ringLabel);
                hash.put("ringfee",price);
                hash.put("ringfee2",price2);
                hash.put("ringauthor",ringauthor);
                hash.put("ringsource",ringsource);
                hash.put("validdate",ParsiToEng(validdate));

                hash.put("uservalidday",uservalidday);

                hash.put("ringspell",ringspell);
                hash.put("iffree",iffree);
                rList = manring.editSysRingLabel(hash);
                mess = "Modify Ringtone Info success.";
                sysInfo.add(sysTime + operName + " modify ringtone info successfully");
                msg = JspUtil.generateResultList(rList);
                if(!msg.equals("")){
                   msg = msg.replace('\n',' ');
                   throw new Exception(msg);
                }
                // 准备写操作员日志
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("SERVICEKEY",manring.getSerkey());
                map.put("OPERTYPE","203");
                map.put("RESULT","1");
                map.put("PARA1",crid);
                map.put("PARA2",ringLabel);
                map.put("PARA3",price);
                map.put("PARA4",price2);
                map.put("PARA5",ParsiToEng(validdate));
                map.put("PARA6","ip:"+request.getRemoteAddr());
                map.put("DESCRIPTION","Modify" );
                purview.writeLog(map);
           }else
           {
              ArrayList ls = null;
              Hashtable tmp = null;
             opmap.put("operid",spIndex);
             opmap.put("opername",operName);
             opmap.put("opertype","0");
             opmap.put("status","0");
             opmap.put("ringid",crid);
             opmap.put("operdesc","");
             opmap.put("refusecomment","");
             opmap.put("ringfee",price);
             opmap.put("ringfee2",price2);
             opmap.put("ringlabel",ringLabel);
             opmap.put("singgername",ringauthor);
             opmap.put("validdate",ParsiToEng(validdate));
             opmap.put("ringspell",ringspell);
             opmap.put("uservalidday",uservalidday);
             ls = manring.addoperCheck(opmap);
           for(int i=0;i<ls.size();i++)
           {
             tmp = (Hashtable)ls.get(i);
             if(!"0".equalsIgnoreCase(tmp.get("result").toString().trim()))
                  mess+=tmp.get("scp").toString().trim()+"-"+tmp.get("reason").toString().trim()+" ";
           }
           if(mess.trim().equalsIgnoreCase(""))
              mess = "Insert check Data successfully.";
           else
              mess = "Insert check Data,SCP failure:("+mess+")";
           }
                %>
                <script language="JavaScript">
               <%if(!mess.trim().equalsIgnoreCase("")){%>
                window.alert('<%=mess%>');
                <%}%>
                window.returnValue = "yes";
                window.close();
                </script>
        <%}else{
        ColorRing colorRing = new ColorRing();
        // 查询铃音信息
        Map hash = (Map)colorRing.getRingInfo(ringid);
        if(hash==null||hash.size()<=0)
        	throw new Exception("Ringtone Record NOT exist!");

%>
<form name="inputForm" method="post" action="editRingInfo.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="libid" value="<%=libid%>">
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
          <td height="22" align="left" valign="center">Ringtone Code</td>
          <td height="22" valign="center"><input type="text" name="ringid"  value="<%=(String)hash.get("ringid")%>" maxlength="20" class="input-style0"  readonly="readonly" ></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center">Ringtone Name</td>
          <td height="22" valign="center"><input type="text" name="ringLabel"  value="<%=(String)hash.get("ringlabel")%>"  maxlength="40" class="input-style0"></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center">Ringtone Spell</td>
          <td height="22" valign="center"><input type="text" name="ringspell"  value="<%=(String)hash.get("ringspell")%>" maxlength="20" class="input-style0"></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center">Singer</td>
          <td height="22" valign="center"><input type="text" name="ringauthor" value="<%=displayRingAuthor((String)hash.get("ringauthor"))%>"  maxlength="40" class="input-style0"></td>
        </tr>
        <tr style="display:none">
          <td height="22" align="left" style="display:none" >Ringtone Provider</td>
          <td height="22" valign="center"><input type="hidden" name="ringsource"  value="<%=(String)hash.get("ringsource")%>"  maxlength="40" class="input-style0"></td>
        </tr>
        <tr style="display:none">
           <td height="22" align="left" valign="center">Free Ringtone</td>
           <td  align="center"><input type="radio" name="iffree" value="0" onclick="onIffreeCheck()">No &nbsp;&nbsp;
            <input type="radio" name="iffree" value="1" onClick="onIffreeCheck()">Yes</td>
        </tr>
        <%if("1".equals(issupportmultipleprice)){%>
        <tr>
          <td height="22" align="left">Daily Ringtone Price(<%=minorcurrency%>)</td>
          <td height="22"><input type="text" name="price2"   <%=springfee.equalsIgnoreCase("0")?"readonly":""%>    maxlength="9" value="<%=(String)hash.get("ringfee2")%>"  class="input-style0"></td>
        </tr>
        <%} %>
        <tr>
          <td height="22" align="left"><%if("1".equals(issupportmultipleprice)){%>Monthly <%}%>Ringtone Price(<%=minorcurrency%>)</td>
          <td height="22"><input type="text" name="price"   <%=springfee.equalsIgnoreCase("0")?"readonly":""%>    maxlength="9" value="<%=(String)hash.get("ringfee")%>"  class="input-style0"></td>
        </tr>
        <% if(userday.equalsIgnoreCase("1"))
        {%>
        <tr>
          <td height="22" align="left">User Validity(Day)</td>
          <td height="22"><input type="text" name="uservalidday"   <%=spuservalidday.equalsIgnoreCase("0")?"readonly":""%>   value="<%=(String)hash.get("uservalidday")%>"  maxlength="4" class="input-style0"></td>
        </tr>
         <%}%>
            <tr>
          <td height="22" align="left">Copyright Validity(yyyy.mm.dd)</td>
          <td height="22"><input type="text" name="validdate"  value="<%=jcalendar((String)hash.get("validtime"))%>"  maxlength="10" class="input-style0"></td>
        </tr>

      </table>
              </div>
          </td>
      </tr>
      <tr>
          <td width="100%" align="center" height="16" align="center">
              <img src="../manager/button/sure.gif" alt="Commit" onmouseover="this.style.cursor='hand'" onclick="javascript:ok()" >
                  &nbsp;&nbsp;
              <img src="../manager/button/cancel.gif" alt="Cancel" onmouseover="this.style.cursor='hand'" onclick="javascript:cancel()" >
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
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Edit ringtone" + ringid + " Error!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Edit Ringtone Error!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
   alert("Edit Ringtone <%= ringid%> Error:<%= e.getMessage() %>");
   window.close();
</script>
<%
    }
%>
</body>
</html>
