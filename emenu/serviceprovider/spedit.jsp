<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%@page import="zte.zxyw50.util.JCalendar"%>
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
<%
   String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
    String issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice","0");
	String userday = CrbtUtil.getConfig("uservalidday","0");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
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
         alert('Please input Rongtone spell');
         fm.ringspell.focus();
         return;
      }
      if(!CheckInputChar1(fm.ringspell,'Ringtone Spell')){
      	fm.ringspell.focus();
      	return;
      }
      if (trim(fm.ringauthor.value) == '') {
         alert('Pleae input Singer name.');
         fm.ringauthor.focus();
         return;
      }
      <%if("1".equals(issupportmultipleprice)){%>
      var price = trim(fm.price.value);
      if(price==''){
         alert('Please input Monthly ringtone Price.');
         fm.price.focus();
         return;
      }
      var price2 = trim(fm.price2.value);
      if(price2==''){
         alert('Please input Daily ringtone Price.');
         fm.price2.focus();
         return;
      }
      <%}else {%>
      var price = trim(fm.price.value);
      if(price==''){
         alert('Please input  ringtone Price.');
         fm.price.focus();
         return;
      }
       <%}%>  
     <%if("1".equals(issupportmultipleprice)){%>
      if (! checkfee(price)) {
         alert('Invalid Monthly ringtone Price.');
         fm.price.focus();
         return;
      }
      if (! checkfee(price2)) {
          alert('Invalid Daily ringtone Price.');
          fm.price2.focus();
          return;
       }
      <%}else {%>
      if (! checkfee(price)) {
          alert('Invalid Monthly ringtone Price.');
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
            alert('Please input ringtone user validity.');
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
          alert('Please input ringtone copyright validity.');
          fm.validdate.focus();
          return ;
      }
      if(!checkDate2(validdate)){
          alert('Invalid ringtone copyright validity.Please input again.');
          fm.validdate.focus();
          return ;
      }
      /*if(checktrue2(validdate)){
          alert('The ringtone copyright validity can NOT sooner than today.Please input again.');
          fm.validdate.focus();
          return ;
      }*/
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
   ArrayList ls = null ;
   Hashtable tmp = null;
   String sysTime = "";
   Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
   String jName = (String)application.getAttribute("JNAME");
String spIndex = (String)session.getAttribute("SPINDEX");
    //String ringindex =  request.getParameter("ringindex") == null ? "" : ((String)request.getParameter("ringindex")).trim();
    String ringid =  request.getParameter("ringid") == null ? "" : ((String)request.getParameter("ringid")).trim();
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String ringLabel = request.getParameter("ringLabel") == null ? "" : transferString((String)request.getParameter("ringLabel"));
    String ringauthor = request.getParameter("ringauthor") == null ? "" : transferString((String)request.getParameter("ringauthor"));
    String price = request.getParameter("price") == null ? "0" : (String)request.getParameter("price");
    String price2 = request.getParameter("price2") == null ? "0" : (String)request.getParameter("price2");
    String validdate = request.getParameter("validdate") == null ? "" : (String)request.getParameter("validdate");
    String ringspell = request.getParameter("ringspell") == null ? "" : (String)request.getParameter("ringspell");
    String uservalidday = request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday");
    String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
    String optype = request.getParameter("optype") == null ? "" : (String)request.getParameter("optype");
    if(optype.trim().equalsIgnoreCase("0"))//删除操作传来
          op = "del";
     zxyw50.Purview purview = new zxyw50.Purview();
    try {
    SpManage sm = new SpManage();
    HashMap map = new HashMap();
        if(op.equals("del")){
           String mess = "";
           map.put("optype","2");
           map.put("ringid",ringid);
           ls = sm.spBackRingHand(map);
           for(int i=0;i<ls.size();i++)
           {
             tmp = (Hashtable)ls.get(i);
             if(!"0".equalsIgnoreCase(tmp.get("result").toString().trim()))
                  mess+=tmp.get("scp").toString().trim()+"-"+tmp.get("reason").toString().trim()+" ";
           }
           if(mess.trim().equalsIgnoreCase(""))
              mess = "Delete successfully";
           else
              mess = "SCP Delete Failure:"+mess;
             // 准备写操作员日志
             HashMap map1 = new HashMap();
             map1.put("OPERID",operID);
             map1.put("OPERNAME",operName);
             map1.put("OPERTYPE","1010");
             map1.put("RESULT","1");
             map1.put("PARA1",ringid);
             map1.put("PARA2",spIndex);
             map1.put("PARA3","Delete Failure");
             map1.put("PARA4","ip:"+request.getRemoteAddr());
             purview.writeLog(map1);

                %>
                <script language="JavaScript">
                 window.alert('<%=mess%>');
                window.returnValue = "yes";
                window.close();
                </script>
        <%}else if(op.equals("edit"))
        {
          String mess = "";
          if(checkLen(ringLabel,40))
          throw new Exception("The length of the Ringtone name is more than limit.Please input again.");
          if(checkLen(ringauthor,40))
          throw new Exception("The length of the Singer name is more than limit.Please input again.");
           map.put("optype","1");
           map.put("ringid",ringid);
           map.put("ringlabel",ringLabel);
           map.put("ringauthor",ringauthor);
           map.put("ringspell",ringspell);
           map.put("ringfee",price);
           map.put("ringfee2",price2);
           map.put("validdate",validdate);
           map.put("uservalidday",uservalidday);
           ls = sm.spBackRingHand(map);
           for(int i=0;i<ls.size();i++)
           {
             tmp = (Hashtable)ls.get(i);
             if(!"0".equalsIgnoreCase(tmp.get("result").toString().trim()))
                  mess+=tmp.get("scp").toString().trim()+"-"+tmp.get("reason").toString().trim()+" ";
           }
           if(mess.trim().equalsIgnoreCase(""))
              mess = "Edit Successfully";
           else
              mess = "SCP Edit Failure:"+mess;
             // 准备写操作员日志
             HashMap map1 = new HashMap();
             map1.put("OPERID",operID);
             map1.put("OPERNAME",operName);
             map1.put("OPERTYPE","1010");
             map1.put("RESULT","1");
             map1.put("PARA1",ringid);
             map1.put("PARA2",spIndex);
             map1.put("PARA3","Edit");
             purview.writeLog(map1);
        %>
                <script language="JavaScript">
                window.alert('<%=mess%>');
                window.returnValue = "yes";
                window.close();
                </script>
      <%
        }else{
%>
<form name="inputForm" method="post" action="spedit.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="optype" value="<%=optype%>">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
    <td>
      <br /> <br />
      <table  width="100%"  border="0">
      <tr>
          <td width="100%" align="center" valign="middle">
              <div id="hintContent" >
      <table border="0" align="center" class="table-style2">
         <tr>
          <td height="22" align="left" valign="center">Ringtone Code</td>
          <td height="22" valign="center"><input type="text" name="ringid"  value="<%=ringid%>" maxlength="20" class="input-style0"  readonly="readonly" ></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center">Ringtone Name</td>
          <td height="22" valign="center"><input type="text" name="ringLabel"  value="<%=displayRingName(ringLabel)%>"  maxlength="40" class="input-style0"></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center">Ringtone Spell</td>
          <td height="22" valign="center"><input type="text" name="ringspell"  value="<%=ringspell%>" maxlength="20" class="input-style0"></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center">Singer</td>
          <td height="22" valign="center"><input type="text" name="ringauthor" value="<%=displayRingAuthor(ringauthor)%>"  maxlength="40" class="input-style0"></td>
        </tr>
        <%if("1".equals(issupportmultipleprice)){%>
        <tr>
          <td height="22" align="left">Ringtone Daily Price(<%=minorcurrency%>)</td>
          <td height="22"><input type="text" name="price2"  maxlength="9" value="<%=price2%>"  class="input-style0"></td>
        </tr> <%} %>
        <tr>
          <td height="22" align="left">Ringtone <%if("1".equals(issupportmultipleprice)){%>Monthly <%}%>Price(<%=minorcurrency%>)</td>
          <td height="22"><input type="text" name="price"  maxlength="9" value="<%=price%>"  class="input-style0"></td>
        </tr>
        <% if(userday.equalsIgnoreCase("1"))
        {%>
        <tr>
          <td height="22" align="left">User Validity(Day)</td>
          <td height="22"><input type="text" name="uservalidday"  value="<%=uservalidday%>"  maxlength="4" class="input-style0"></td>
        </tr>
         <%}%>
            <tr>
          <td height="22" align="left">Copyright Validity(yyyy.mm.dd)</td>
          <td height="22"><input type="text" name="validdate"  value="<%=jcalendar(validdate)%>"  maxlength="10" class="input-style0"></td>
        </tr>

      </table>
              </div>
          </td>
      </tr>
      <tr>
          <td width="100%" align="center" height="16" align="center">
            <br>
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
<%}
    }
    catch(Exception e) {
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Edit ringtone " + ringid + " Error!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Edit Ringtone Error!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
   <%String str= e.getMessage();
     str = str.replaceAll("\n","<br>"); %>
   alert("Edit Ringtone <%= ringid%> Error:<%=str %>");
   window.close();
</script>
<%
    }
%>
</body>
</html>
