<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara"%>
<%@ page import="zxyw50.manStat"%>
<%@ page import="zxyw50.SpManage"%>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%@ include file="../pubfun/JavaFun.jsp" %>

<script src="../pubfun/JsFun.js"></script>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
	String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String sp = (String)request.getParameter("sp")==null?"*":(String)request.getParameter("sp");
	String spName  = "";
	int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
    String spcode ="";

	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");
	String giftbag   = CrbtUtil.getConfig("giftname","giftbag");


    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        String  errmsg = "";
        boolean flag =true;
        zxyw50.Purview purview = new zxyw50.Purview();

       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
       }
      else if (purviewList.get("4-24") == null  || (!purview.CheckOperatorRightAllSerno(session,"4-24"))) {
         errmsg = "You have no access to this function!";
         flag = false;
       }
	   if(!flag){
%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   document.URL = 'enter.jsp';
</script>
<%
        }
	else{
      String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
      HashMap   map = new HashMap();

      manSysPara  syspara = new manSysPara();
      if(!(sp.equals("*"))){
        Hashtable tmph = new Hashtable();
        tmph = syspara.getSPCode(sp);
        spcode = (String)tmph.get("spcode");
        spName = (String)tmph.get("spname");
      }
      ArrayList spInfo = syspara.getSPInfo();
      String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
      Hashtable hash = new Hashtable();
      String startday = "";
      String endday = "";
      String start = "";
      String end = "";
      String  checkflag = "";
      ArrayList list = new ArrayList();
      if(op.equals("search") || op.equals("bakdata")){
        startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
        endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
      }

      if(request.getParameter("checkflag") != null && !scp.equals(""))
      {
        hash.put("scp",scp);
        checkflag = request.getParameter("checkflag");
      }
      if(startday.length()!=0 && endday.length()!=0 && checkflag.length()!=0 ){
        hash.put("startday",startday);
        hash.put("endday",endday);
        hash.put("checkflag",checkflag);
        hash.put("pagetype","spmusicStat");
        if(!(sp.equals("*")) && spcode.length()!=0 ){
          hash.put("spcode",spcode);
          hash.put("spindex",sp);
          SpManage spman = new SpManage();
          list = spman.spMusicStat(hash);
        }else{
          manStat manstat = new manStat();
          list = manstat.spScribStatAll(hash);
        }
      }
      if(op.equals("bakdata")){
        response.setContentType("application/msexcel");
        short stat_type = XlsNameGenerate.STATISTIC_NONE;
        if(checkflag != null && !checkflag.trim().equals("")) {
          if(checkflag.equals("1")) {
            stat_type = XlsNameGenerate.STATISTIC_MONTH;
          } else if(checkflag.equals("2")) {
            stat_type = XlsNameGenerate.STATISTIC_DAY;
          } else if(checkflag.equals("3")) {
            stat_type = XlsNameGenerate.STATISTIC_HOUR;
          } else if(checkflag.equals("4")) {
            stat_type = XlsNameGenerate.STATISTIC_WEEK;
          }
        }
        String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "spRingGroupOrder", stat_type);
        response.setHeader("Content-disposition","inline; filename=" + file_name);
        out.clear();
        out.println("<table border='1'>");
        out.println("<tr><td>Date</td><td>SP Code</td><td>" + musicbox +" order times</td><td>" + giftbag + " order times</td>");

        for (int i = 0; i <list.size(); i++) {
          map = (HashMap)list.get(i);
          out.println("<tr><td>&nbsp;"+(String)map.get("statdate")+"</td><td>"+(String)map.get("spcode")+"</td><td>"+(String)map.get("buytimes1")+"</td><td>" + (String)map.get("buytimes2") + "</td></tr>");
        }
        out.println("</table>");
        return;
      }
      String optSCP = "";
      ArrayList scplist = syspara.getScpList();
      for (int i = 0; i < scplist.size(); i++)
      optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";

%>
<html>
<head>
<title>Service development statistic</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1" onload="initform(document.forms[0])">

<script language="javascript">

   function toPage (page) {
      document.InputForm.page.value = page;
      document.InputForm.op.value="search";
      document.InputForm.target="_self";
      document.InputForm.submit();
   }

   function checkInfo () {
      var fm = document.InputForm;
      var tmp = '';
       if (fm.checkflag[0].checked) {
         if (trim(fm.startday.value) == '') {
            alert('Please input start time!');
            fm.startday.focus();
            return false;
         }
         if (! checkDate1(fm.startday.value)) {
            alert('Error occurs in the input of start time,\r\nPlease input start time in the format of YYYY.MM!');
            fm.startday.focus();
            return false;
         }
         if (! checktrue1(fm.startday.value)) {
            alert('The start time should not be later than current time!');
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            alert('Please input end time!');
            fm.endday.focus();
            return false;
         }
         if (! checkDate1(fm.endday.value)) {
            alert('Error occurs in the input of end time,\r\nPlease input start time in the format of YYYY.MM!');
            fm.endday.focus();
            return false;
         }
         if (! checktrue1(fm.endday.value)) {
            alert('The end time should be earlier than current time!');
            fm.endday.focus();
            return false;
         }
         if (! compareDate1(fm.startday.value,fm.endday.value)) {
            alert('The start time should be earlier than end time!');
            fm.startday.focus();
            return false;
         }
      }
       else if(fm.checkflag[1].checked||fm.checkflag[3].checked){
	      if (trim(fm.startday.value) == '') {
            alert('Please input the start time!');
            fm.startday.focus();
            return false;
         }
         if (! checkDate2(fm.startday.value)) {
            alert('Error occurs in the input of end time,\r\nPlease input start time in the format of YYYY.MM.DD!');
            fm.startday.focus();
            return false;
         }
         if (! checktrue2(fm.startday.value)) {
            alert('The end time should be earlier than current time!');
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            alert('Please input end time!');
            fm.endday.focus();
            return false;
         }
         if (! checkDate2(fm.endday.value)) {
            alert('Error occurs in the input of end time,\r\nPlease input start date in the format of YYYY.MM.DD!');
            fm.endday.focus();
            return false;
         }
         if (! checktrue2(fm.endday.value)) {
            alert('The end time should not be later than current time!');
            fm.endday.focus();
            return false;
         }
         if (! compareDate2(fm.startday.value,fm.endday.value)) {
            alert('The start time should be earlier than end time!');
            fm.startday.focus();
            return false;
         }
        }else if(fm.checkflag[2].checked){
	     if (trim(fm.startday.value) == '') {
            alert('Please input start time!');
            fm.startday.focus();
            return false;
         }
         if (! checkDate3(fm.startday.value)) {
            alert('Error occurs in the input of start time,\r\nPlease input start time in the format of YYYY.MM.DD.HH!');
            fm.startday.focus();
            return false;
         }
         if (! checktrue3(fm.startday.value)) {
            alert('The start time should not be later than current time!');
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            alert('Please input end time!');
            fm.endday.focus();
            return false;
         }
         if (! checkDate3(fm.endday.value)) {
            alert('Error occurs in the input of end time,\r\nPlease input end time in the format of YYYY.MM.DD.HH!');
            fm.endday.focus();
            return false;
         }
         if (! checktrue3(fm.endday.value)) {
            alert('The end time should not be later than current time!');
            fm.endday.focus();
            return false;
         }
         if (! compareDate3(fm.startday.value,fm.endday.value)) {
            alert('The start time should be earlier than end time!');
            fm.startday.focus();
            return false;
         }
	  }
//	 if(fm.checkflag.value==''){
//			alert('You must select a query condition!');
//			return false;
//		}
	  return true;
   }

   function searchInfo () {
      document.InputForm.page.value = 0;
	  var fm = document.InputForm;
      if (! checkInfo()){

		 return;
		 }
      fm.op.value = 'search';
      fm.target="_self";
      fm.submit();
   }

    function WriteDataInExcel(){
      if (! checkInfo())
      return;

      var fm = document.InputForm;
      fm.op.value = 'bakdata';
      fm.target="top";
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
	   alert('You can only select a statistic condition!');
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
//	if(!onlyonecheck()){
//		return;
//	}
	var fm = document.InputForm;
      if(fm.checkflag[1].checked){


	//   fm.checkflag.value = 2;
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

      //  fm.day.value ="1";
     }
      else if(fm.checkflag[0].checked){

        // fm.checkflag.value = 1;
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

     //   fm.month.value ="1";
     }
      else if(fm.checkflag[2].checked){ // hour

	//   fm.checkflag.value = 3;
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

     //   fm.hour.value ="1";
      }
      else if(fm.checkflag[3].checked){//ÖÜ

    //   fm.checkflag.value = 4;
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

    //    fm.week.value ="1";
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
    var value = '<%=checkflag%>';
     if(value=='1')
        fm.checkflag[0].checked = true;
     else if(value=='2')
       fm.checkflag[1].checked = true;
     else if(value=='3')
       fm.checkflag[2].checked = true;
     else if(value=='4')
       fm.checkflag[3].checked = true;
     else
       fm.checkflag[0].checked = true;

    <%if(checkflag.length()==0){%>
       onCheckTime();
    <%}%>


      var temp = "<%= scp %>";
      for(var i=0; i<fm.scplist.length; i++){
        if(fm.scplist.options[i].value == temp){
           fm.scplist.selectedIndex = i;
           break;
        }
     }
    }

</script>
<form name="InputForm" method="post" action="spmusicStat.jsp">
<input type="hidden" name="op" value="<%= op%>">
<input type="hidden" name="page" value="<%= thepage %>">
<script language="JavaScript">

	if(parent.frames.length>0)
			parent.document.all.main.style.height=600;


</script>

<table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2" height=500 align="center">
  <tr>
    <td valign="top" height="35">
	<table class="table-style2" width="100%">
	<tr >
          <td height="30" colspan=5 align="center" class="text-title"  background="image/n-9.gif">SP RingGroup Order Query</td>
   </tr>
   <tr >
          <td height="26" colspan=5 >Please select SCP&nbsp; <select name="scplist" size="1" class="input-style1">
              <% out.print(optSCP); %>
             </select></td>
   </tr>
   <tr>
   <td>
       <input type="radio" name="checkflag" value="1" onclick="onCheckTime()">Statistic by month</input></td>
        <td><input type="radio" name="checkflag" value="2" onClick="onCheckTime()">by day</input></td>
        <td><input type="radio" name="checkflag" value="3" onClick="onCheckTime()">by hour</input></td>
        <td><input type="radio" name="checkflag" value="4" onClick="onCheckTime()">by week</input></td>

   <td   align="right">SP List
<select name="sp" class="select-style1"  >
<option value="*">-All SP-</option>
<%
          	    for (int i = 0; i < spInfo.size(); i++) {
                HashMap map1 = (HashMap)spInfo.get(i);
				String spindex = (String)map1.get("spindex");
				if (sp.equals(spindex)){
%>
             				 <option value="<%= (String)map1.get("spindex") %>" selected><%= (String)map1.get("spname") %></option>
<%
            }else{
%>
							<option value="<%= (String)map1.get("spindex") %>" ><%= (String)map1.get("spname") %></option>
<%
}
}
%>
</select>
</td>

   </tr>
   </table>
      <table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2">
       <td width="80">
				&nbsp;&nbsp;Start time
				</td>
			<td ><input type="text" name="startday" value="<%= startday %>" maxlength="20" size="20">
				</td>
			<td width="80">End time
				</td>
				<td ><input type="text" name="endday" value="<%= endday %>" maxlength="20" size="20">
				</td>

		  <td width="11%" align="right"><img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align="center" valign="top">
      <table border="0" width="100%" cellspacing="1" cellpadding="1" class="table-style2" >
        <tr  class="tr-ring">
          <td width="30%" height="24" align="center" ><span class="style1">Date</span></td>
          <td width="10%" height="24" align="center"><span class="style1">SP Code</span></td>
		  <td width="20%" height="24" align="center"><span class="style1"><%=musicbox%> order times</span></td>
		  <td width="20%" height="24" align="center"><span class="style1"><%=giftbag%> order times</span></td>
        </tr>
<%
        if(list!=null){
          float num1=0,num2=0;
		 	int countm = list.size() == 0 ? 15 : 0;
		 for (int i = thepage*15; i < thepage*15+15 && i<list.size(); i++) {
            	map = (HashMap)list.get(i);
				countm++;
          		String  bgcl = i % 2 == 0 ? "#f5fbff" : "" ;
          		out.println("<tr bgcolor="+bgcl + ">");
				out.println("<td align=center>"+(String)map.get("statdate")+"</td>");
				out.println("<td align=center>"+(String)map.get("spcode")+"</td>");

                                if(map.get("buytimes1")==null||((String)map.get("buytimes1")).trim().equalsIgnoreCase(""))
                                {
                                  out.println("<td align=center>0</td>");
                                  num1+=0;
                                }
                                else
                                {
                                  out.println("<td align=center>"+(String)map.get("buytimes1")+"</td>");
                                  num1+=Float.parseFloat((String)map.get("buytimes1"));
                                }

                                if(map.get("buytimes2")==null||((String)map.get("buytimes2")).trim().equalsIgnoreCase(""))
                                {
                                  out.println("<td align=center>0</td>");
                                  num2+=0;
                                }
                                else
                                {
                                  out.println("<td align=center>"+(String)map.get("buytimes2")+"</td>");
                                  num2+=Float.parseFloat((String)map.get("buytimes2"));
                                }
				String strfee = (String)map.get("buyfee");
          		out.println("</tr>");
		  }
                  out.println("<tr>");
                  out.println("<td align=center colspan='2'>Total:</td>");
                  out.println("<td align=center >"+num1+"</td>");
                  out.println("<td align=center >"+num2+"</td>");
                  out.println("</tr>");


		  %>
		  <%
        if (list.size() > 15) {
%>
  <tr>
    <td width="100%" colspan="5">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;Total:<%= list.size() %>,&nbsp;<%= list.size()/15+1 %>&nbsp;page(s),&nbsp;Now on page <%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 15 + 15 >= list.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (list.size() - 1) / 15 %>)"></td>
        </tr>
      </table>
    </td>
  </tr>
<%
        }else if(list.size()==0 && !scp.equals("")){
        %>
<tr>
	<td width="50%" align="center" colspan="7">
	There are no records that can meet the condition!
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
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "It is abnormal during the query of ringgroup order!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the query of ringgroup order!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="spmusicStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>
