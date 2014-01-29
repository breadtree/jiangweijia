<%@ page import="java.lang.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysPara"%>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<jsp:useBean id="db" class="zxyw50.SpManage" scope="page" />
<jsp:setProperty name="db" property="*" />
<%
	String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
	int largessflag = 0;
	if(disLargess.equals("1"))
		largessflag = 1;
%>
<script src="../pubfun/JsFun.js"></script>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

   String sysTime = "";
   Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
   String operID = (String)session.getAttribute("OPERID");
   String operName = (String)session.getAttribute("OPERNAME");
   String spIndex = (String)session.getAttribute("SPINDEX");
	String spName  = (String)session.getAttribute("SPNAME");
	String spcode  = (String)session.getAttribute("SPCODE");
	int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));

   Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

   String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);


    try {
        String  errmsg = "";
        boolean flag =true;
       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
       }
       else if (spIndex  == null || spIndex.equals("-1")){
          errmsg = "Sorry, you are not an SP administrator!";//Sorry,you are not the SP administrator
          flag = false;
       }
       else if (purviewList.get("9-1") == null) {
         errmsg = "You have no access to this function!";//You have no access to this function
         flag = false;
       }
	   if(!flag){
%>
<script language="javascript">
   var errmsg = '<%= operID!=null?errmsg:"Please log in to the system first!"%>';
   alert(errmsg);
   document.URL = 'enter.jsp';
</script>
<%
        }
	else{
          Hashtable tmph = new Hashtable();
		  String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
          Hashtable hash = new Hashtable();
          HashMap   map = new HashMap();
          String startday = "";
          String endday = "";
          String start = "";
          String end = "";
          String  checkflag = "";
		  ArrayList list = new ArrayList();
          if(op.equals("search")){
                 startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
                 endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
          }
		 	if(request.getParameter("checkflag") != null)
   				checkflag = request.getParameter("checkflag");
				hash.put("spindex",spIndex);
         		String start1="";
         		String end1 = "";

				if(startday.length()!=0 && endday.length()!=0 && checkflag.length()!=0 && spcode.length()!=0 ){
        		if(checkflag.equals("1") && startday.length()!=7 && endday.length()!=7)
					throw new Exception("Please enter the year and month in the format of YYYY.MM!");//请按照****.**的格式输入年月
				if((checkflag.equals("2") || checkflag.equals("4")) && startday.length()!=10 && endday.length()!=10)
					throw new Exception("Please enter the date in the format of YYYY.MM.DD!");//请按照****.**.**的格式输入年月日
				if(checkflag.equals("3") && startday.length()!=13 && endday.length()!=13)
					throw new Exception("Please enter the time in the format of YYYY.MM.DD.HH!");//请按照****.**.**.**的格式输入年月日时!
				hash.put("startday",startday);
         		hash.put("endday",endday);
		 		hash.put("checkflag",checkflag);
		 		hash.put("spcode",spcode);
		 		hash.put("scp",scp);
		 		list = db.spScribStat(hash);
		  }
		  String optSCP = "";
		  manSysPara  syspara = new manSysPara();
		  ArrayList scplist = syspara.getScpList();
          for (int i = 0; i < scplist.size(); i++)
              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";


%>
<html>
<head>
<title>Service development statistics</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body background="background.gif" class="body-style1"  onload="initform(document.forms[0])" >

<script language="javascript">

   function toPage (page) {
      document.InputForm.page.value = page;

      document.InputForm.submit();
   }

   function checkInfo () {
      var fm = document.InputForm;
      var tmp = '';
      if (fm.checkflag.value=='1') {
         if (trim(fm.startday.value) == '') {
            alert("Please enter the start time!");//请输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checkDate1(fm.startday.value)) {
            alert("Invalid start time entered. \r\n Please enter the start time in the YYYY.MM format!");//起始时间输入错误,\r\n请按YYYY.MM输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checktrue1(fm.startday.value)) {
            alert("Start time cannot be later than the current time!");//起始时间不能大于当前时间
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            alert("Please enter the end time.!");//请输入结束时间
            fm.endday.focus();
            return false;
         }
         if (! checkDate1(fm.endday.value)) {
            alert("Invalid end time entered. \r\n Please enter the end time in the YYYY.MM format!");//结束时间输入错误,\r\n请按YYYY.MM输入起始时间
            fm.endday.focus();
            return false;
         }
         if (! checktrue1(fm.endday.value)) {
            alert("End time cannot be later than the current time!");//结束时间不能大于当前时间
            fm.endday.focus();
            return false;
         }
         if (! compareDate1(fm.startday.value,fm.endday.value)) {
            alert("Start time must be prior to the end time!");//起始时间应该在结束时间之前
            fm.startday.focus();
            return false;
         }
      }
	  else if(fm.checkflag.value=='2'||fm.checkflag.value=='4'){
	      if (trim(fm.startday.value) == '') {
            alert("Please enter the start time!");//请输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checkDate2(fm.startday.value)) {
            alert("Incorrect Start Time. \r\n Please enter the Start Time in the format of YYYY.MM.DD.");//起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checktrue2(fm.startday.value)) {
            alert("Start time cannot be later than the current time!");//起始时间不能大于当前时间
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            alert("Please enter the end time.!");//请输入结束时间
            fm.endday.focus();
            return false;
         }
         if (! checkDate2(fm.endday.value)) {
            alert("Incorrect End Time. \r\n Please enter the End Time in the format of YYYY.MM.DD.!");//结束时间输入错误,\r\n请按YYYY.MM.DD输入起始时间
            fm.endday.focus();
            return false;
         }
	  if(!checktrue2(fm.endday.value)){
            alert("End time cannot be later than the current time!");//结束时间不能大于当前时间
            fm.endday.focus();
            return false;
         }
         if (! compareDate2(fm.startday.value,fm.endday.value)) {
            alert("Start time must be prior to the end time!");//起始时间应该在结束时间之前
            fm.startday.focus();
            return false;
         }
	  }else if(fm.checkflag.value=='3'){
	     if (trim(fm.startday.value) == '') {
            alert("Please enter the start time!");//请输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checkDate3(fm.startday.value)) {
            alert("Invalid start time entered. Please enter the start time in the YYYY.MM.DD.HH format!");//起始时间输入错误,\r\n请按YYYY.MM.DD.HH输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checktrue3(fm.startday.value)) {
            alert("Start time cannot be later than the current time!");//起始时间不能大于当前时间
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            alert("Please enter the end time.!");//请输入结束时间
            fm.endday.focus();
            return false;
         }
         if (! checkDate3(fm.endday.value)) {
            alert("Invalid end time entered. \r\n Please enter the end time in the YYYY.MM.DD.HH format");//结束时间输入错误,\r\n请按YYYY.MM.DD.HH输入起始时间
            fm.endday.focus();
            return false;
         }
         if (! checktrue3(fm.endday.value)) {
            alert("End time cannot be later than the current time!");//结束时间不能大于当前时间
            fm.endday.focus();
            return false;
         }
         if (! compareDate3(fm.startday.value,fm.endday.value)) {
            alert("Start time must be prior to the end time!");//起始时间应该在结束时间之前
            fm.startday.focus();
            return false;
         }
	  }
	 if(fm.checkflag.value==''){
			alert("You must select a query criterion!");//您必须选择一个查询条件
			return false;
		}
	  return true;
   }

   function searchInfo () {
      document.InputForm.page.value = 0;
	  var fm = document.InputForm;
      if (! checkInfo()){

		 return;
		 }
      fm.op.value = 'search';
      fm.submit();
   }

  function onlyonecheck(){
	var count=0;
	var fm = document.InputForm;
	if(fm.month.checked)
		count++;
	if(fm.day.checked)
	    count++;
	if(fm.hour.checked)
	    count++;
	if(fm.week.checked)
		count++;
	if(count>1){
	   alert("You can only select one statistical criterion!");//您只能选中一种统计条件
	   fm.month.checked=false;
	   fm.day.checked =false;
	   fm.hour.checked=false;
	   fm.week.checked=false;
	   fm.checkflag.value='';
	   fm.startday.value='';
	   fm.endday.value='';
	   return false;
	   }

	   return true;
}

function onCheckTime(){
	if(!onlyonecheck()){
		return;
	}
	var fm = document.InputForm;
	if(fm.day.checked){

	   fm.checkflag.value = 2;
       var today  = new Date();
       var year = today.getYear();
       var month = today.getMonth() + 1;
       var day = today.getDate();
       fm.endday.disabled = false;
       fm.startday.disabled = false;
       var strMonth = "";
       var strDay = "";

          if(month<10)
             strMonth = "0" + month;
          else
             strMonth = month;
          if(day<10)
             strDay = "0" + day ;
          else
             strDay = day;
          fm.endday.value = year + "." + strMonth+"."+strDay;
          var month1 = (month-3 + 12)%12;
          if(month1==0)
             month1 = 12;
          var year1 = year;
          if(month1>month)
             year1 = year1 - 1;
          if(month1<10)
             strMonth = "0" + month1;
          else
             strMonth = month1;
          var days = getMonthDays(year1,month1)
          if(day>days)
            day = days;
          if(day<10)
             strDay = "0" + day ;
          else
             strDay = day;
          fm.startday.value = year1 + "." + strMonth+"." + strDay ;

        fm.day.value ="1";
     }
	 else if(fm.month.checked){

	   fm.checkflag.value = 1;
       var today  = new Date();
       var year = today.getYear();
       var month = today.getMonth() + 1;
       fm.endday.disabled = false;
       fm.startday.disabled = false;
       var strMonth = "";

          if(month<10)
             strMonth = "0" + month;
          else
             strMonth = month;
          fm.endday.value = year + "." + strMonth;
          var month1 = (month-3 + 12)%12;
          if(month1==0)
             month1 = 12;
          var year1 = year;
          if(month1>month)
             year1 = year1 - 1;
          if(month1<10)
             strMonth = "0" + month1;
          else
             strMonth = month1;
          fm.startday.value = year1 + "." + strMonth ;

        fm.month.value ="1";
     }
     else if(fm.hour.checked){

	   fm.checkflag.value = 3;
       var today  = new Date();
       var year = today.getYear();
       var month = today.getMonth() + 1;
       var day = today.getDate();
	   var hour = today.getHours();
       fm.endday.disabled = false;
       fm.startday.disabled = false;
       var strMonth = "";
       var strDay = "";
	   var strhour = "";

          if(month<10)
             strMonth = "0" + month;
          else
             strMonth = month;
          if(day<10)
             strDay = "0" + day ;
          else
             strDay = day;
		  if(hour<10)
		     strhour =  "0"+hour;
		  else
		  	 strhour = hour;
          fm.endday.value = year + "." + strMonth+"."+strDay+"."+strhour;
          var month1 = (month-3 + 12)%12;
          if(month1==0)
             month1 = 12;
          var year1 = year;
          if(month1>month)
             year1 = year1 - 1;
          if(month1<10)
             strMonth = "0" + month1;
          else
             strMonth = month1;
          var days = getMonthDays(year1,month1)
          if(day>days)
            day = days;
          if(day<10)
             strDay = "0" + day ;
          else
             strDay = day;
          fm.startday.value = year1 + "." + strMonth+"." + strDay+"."+strhour ;

        fm.hour.value ="1";
     } else if(fm.week.checked){ //周

	   fm.checkflag.value = 4;
       var today  = new Date();
       var year = today.getYear();
       var month = today.getMonth() + 1;
       var day = today.getDate();
	   fm.endday.disabled = false;
       fm.startday.disabled = false;
       var strMonth = "";
       var strDay = "";
	      if(month<10)
             strMonth = "0" + month;
          else
             strMonth = month;
          if(day<10)
             strDay = "0" + day ;
          else
             strDay = day;
		   fm.endday.value = year + "." + strMonth+"."+strDay;
          var month1 = (month-3 + 12)%12;
          if(month1==0)
             month1 = 12;
          var year1 = year;
          if(month1>month)
             year1 = year1 - 1;
          if(month1<10)
             strMonth = "0" + month1;
          else
             strMonth = month1;
          var days = getMonthDays(year1,month1)
          if(day>days)
            day = days;
          if(day<10)
             strDay = "0" + day ;
          else
             strDay = day;
          fm.startday.value = year1 + "." + strMonth+"." + strDay;

        fm.week.value ="1";
     }
	 else {
       fm.startday.value = "";
       fm.endday.value = "";
       fm.endday.disabled = true;
       fm.startday.disabled = true;
	   fm.checkflag.value = '';
    }

  }

    function  initform(fm){
     var value = fm.checkflag.value;
     if(value==1)
        fm.month.checked = true;
     else if(value==2)
       fm.day.checked = true;
     else if(value==3)
       fm.hour.checked = true;
     else if(value==4)
       fm.week.checked = true;
    }


    function  initform(fm){
      var temp = "<%= scp %>";
      for(var i=0; i<fm.scplist.length; i++){
        if(fm.scplist.options[i].value == temp){
           fm.scplist.selectedIndex = i;
           break;
        }
     }
    }


</script>
<form name="InputForm" method="post" action="spScribStat.jsp">
<input type="hidden" name="op" value="<%= op%>">
<input type="hidden" name="checkflag" value="<%= checkflag%>">
<input type="hidden" name="page" value="<%= thepage %>">


<script language="JavaScript">

	if(parent.frames.length>0)

			parent.document.all.main.style.height=650;


</script>

<table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2" height="600" align="center">
  <tr>
    <td valign="top" height="35">
	<table class="table-style2" width="100%">
   <tr >
   	<td  colspan="4" class="text-title" align="center">SP(<%= spName %>) query <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> orders</td>
   </tr>
   <tr >
     <td height="26" colspan=5 >Please select SCP&nbsp; <select name="scplist" size="1" class="input-style1">
         <% out.print(optSCP); %>
      </select></td>
   </tr>
   <tr>
   <td>
   <input type="checkbox" name="month" value="0" onclick="onCheckTime()">statistics by month</input></td>
   <td><input type="checkbox" name="day" value="0" onClick="onCheckTime()">statistics by day</input></td>
   <td><input type="checkbox" name="week" value="0" onClick="onCheckTime()">statistics by week</input></td>
   <td><input type="checkbox" name="hour" value="0" onClick="onCheckTime()">statistics by hour</input></td>
   </tr>
   </table>
      <table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2">
       <td width="80">
				&nbsp;&nbsp;Start time
				</td>
			<td ><input type="text" name="startday" value="<%= startday %>" maxlength="20" size="20">
				</td>
			<td width="80">&nbsp;&nbsp;End time
				</td>
				<td ><input type="text" name="endday" value="<%= endday %>" maxlength="20" size="20">
				</td>

		  <td width="11%" align="right"><img src="../button/search.gif" border="0" onclick="javascript:searchInfo()" onmouseover="this.style.cursor='hand'"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align="center" valign="top">
      <table border="0" width="100%" cellspacing="1" cellpadding="1" class="table-style2" >
        <tr  class="tr-ring">
          <td width="20%" height="24" align="center"><span title="Date">Date</span></td>
          <td width="30%" height="24" align="center"><span title="Number of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> downloads">Downloads</span></td>
         <% if(largessflag!=1){%>
          <td width="30%" height="24" align="center"><span title="Number of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> presents">Presents</span></td>
         <%}%>
		  <td width="20%" height="24" align="center"><span title="Total cost (<%=majorcurrency%>)">Total cost (<%=majorcurrency%>)</span></td>
        </tr>
 <%
        if(list!=null){
		 	int countm = list.size() == 0 ? 15 : 0;
		 for (int i = thepage*15; i < thepage*15+15 && i<list.size(); i++) {
            	    map = (HashMap)list.get(i);
                    countm++;
                    String  bgcl = i % 2 == 0 ? "#f5fbff" : "" ;
                    String strbuytimes = map.get("buytimes").toString();
                    String strprestimes = map.get("prestimes").toString();
                    int intbuytimes = Integer.parseInt(strbuytimes) - Integer.parseInt(strprestimes);
                    out.println("<tr bgcolor="+bgcl + ">");
                    out.println("<td align=center>"+(String)map.get("statdate")+"</td>");
                    out.println("<td align=center>" + intbuytimes + "</td>");
		    if(largessflag!=1)
                      out.println("<td align=center>"+(String)map.get("prestimes")+"</td>");
                    String strfee = (String)map.get("buyfee");
                    if(strfee.length()==0)
                      out.println("<td align=center>"+strfee+"</td>");
                    else{
                      //float fee = Float.parseFloat((String)map.get("buyfee"));
                      out.println("<td align=center>"+displayFee(strfee)+"</td>");
                    }
                    out.println("</tr>");
		  }
		  %>
		  <%
        if (list.size() > 15) {
%>
  <tr>
    <td width="100%" colspan="4">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;<%= list.size() %> entries in <%= list.size()%15==0?list.size()/15:list.size()/15+1 %> pages,&nbsp;&nbsp;You are now on Page &nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 15 + 15 >= list.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (list.size() - 1) / 15 %>)"></td>
        </tr>
      </table>
    </td>
  </tr>
<%
        }
        if(list.size()==0 && !scp.equals("")){
        %>
<tr>
	<td width="50%" align="center" colspan="7">
	No record matched the criteria!
	</td>
</tr>
<%

        }

		  }
%>
</table></td></tr>

</table>
</form>
<%
      }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in querying this order!");//铃音订购查询过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in querying this order!");//铃音订购查询过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="spScribStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
