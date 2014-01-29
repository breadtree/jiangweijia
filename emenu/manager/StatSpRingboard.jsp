<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara"%>
<%@ page import="zxyw50.manStat"%>
<%@ page import="zxyw50.SpManage"%>
<%@ page import="zxyw50.StatServerQuery"%>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%@ include file="../pubfun/JavaFun.jsp" %>

<script src="../pubfun/JsFun.js"></script>

<%!

    private String getSpcode(String sp, ArrayList spInfo){
      String spcode ="";
      for (int i = 0; i < spInfo.size(); i++) {
        HashMap map1 = (HashMap)spInfo.get(i);
        String spindex = (String)map1.get("spindex");
        if (sp.equals(spindex))
        {
          spcode= (String)map1.get("spcode");
        }
      }
     return spcode;
    }
%>
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
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);


    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        String  errmsg = "";
        boolean flag =true;
        zxyw50.Purview purview = new zxyw50.Purview();

       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
       }
      else if (purviewList.get("4-9003") == null  || (!purview.CheckOperatorRightAllSerno(session,"4-5"))) {
         errmsg = "You have no access to this function!";//You have no access to this function
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
	       // String start = "";
	       // String end = "";
	   	String  checkflag = "";
		ArrayList list = new ArrayList();
          	if(op.equals("search") || op.equals("bakdata")){
                	startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
                 	endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
         	}

		if(request.getParameter("checkflag") != null )

   		checkflag = request.getParameter("checkflag");
		if(startday.length()!=0 && endday.length()!=0 && checkflag.length()!=0 ){
        		hash.put("startday",startday);
	         	hash.put("endday",endday);
			hash.put("checkflag",checkflag);
			//if(!(sp.equals("*")) && spcode.length()!=0 ){
		 		hash.put("spcode",spcode);
			 	hash.put("spindex",sp);
			 //	SpManage spman = new SpManage();
                                StatServerQuery statServer = new StatServerQuery();
				list = statServer.statSPRingboard(hash);

                if(op.equals("bakdata")){
                  response.setContentType("application/msexcel");
                  short stat_type = XlsNameGenerate.STATISTIC_NONE;
                  if(checkflag != null && !checkflag.trim().equals("")) {
                    if(checkflag.equals("1")) {
                      stat_type = XlsNameGenerate.STATISTIC_MONTH;
                    } else if(checkflag.equals("2")) {
                      stat_type = XlsNameGenerate.STATISTIC_DAY;
                    }
                  }
                  String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "springboard", stat_type);
                  response.setHeader("Content-disposition","inline; filename=" + file_name);
                  out.clear();
                  out.println("<table border='1'>");
                  out.println("<tr><td>Date</td><td>SP code</td>");
                  out.println("<td>Ordertimes of Ringboard1</td>");
                  out.println("<td>Ordertimes of Ringboard2</td>");
                  out.println("<td>Ordertimes of Ringboard3</td>");
                  out.println("<td>Ordertimes of Ringboard4</td>");
                  out.println("<td>Ordertimes of Ringboard5</td>");
                  out.println("<td>Ordertimes of Ringboard6</td>");
                  out.println("<td>Ordertimes of Ringboard7</td>");
                  out.println("<td>Ordertimes of Ringboard8</td>");
                  out.println("<td>Ordertimes of Ringboard9</td>");
                  out.println("<td>Ordertimes of Ringboard10</td></tr>");

                  String strfee=null;
                  float fee;
                  String tdInformat = "<td align='center' style='mso-number-format:\"\\@\"'>";
                  long num1=0,num2=0,num3=0,num4=0,num5=0,num6=0,num7=0,num8=0,num9=0,num10=0;
                  for (int i = 0; i <list.size(); i++) {
                    map = (HashMap)list.get(i);
                    String spindex = (String)map.get("spindex");
                    manSysPara  sys = new manSysPara();
                    ArrayList cpInfo = sys.getSPInfo();
                    String cpcode = getSpcode(spindex, cpInfo);
                    String ordertimes1 = map.get("ordertimes1").toString();

                    int intordertimes1 = Integer.parseInt(ordertimes1);
                    String ordertimes2 = map.get("ordertimes2").toString();
                    int intordertimes2 = Integer.parseInt(ordertimes2);
                    String ordertimes3 = map.get("ordertimes3").toString();
                    int intordertimes3 = Integer.parseInt(ordertimes3);
                    String ordertimes4 = map.get("ordertimes4").toString();
                    int intordertimes4 = Integer.parseInt(ordertimes4);
                    String ordertimes5 = map.get("ordertimes5").toString();
                    int intordertimes5 = Integer.parseInt(ordertimes5);
                    String ordertimes6 = map.get("ordertimes6").toString();
                    int intordertimes6 = Integer.parseInt(ordertimes6);
                    String ordertimes7 = map.get("ordertimes7").toString();
                    int intordertimes7 = Integer.parseInt(ordertimes7);
                    String ordertimes8 = map.get("ordertimes8").toString();
                    int intordertimes8 = Integer.parseInt(ordertimes8);
                    String ordertimes9 = map.get("ordertimes9").toString();
                    int intordertimes9 = Integer.parseInt(ordertimes9);
                    String ordertimes10 = map.get("ordertimes10").toString();
                    int intordertimes10 = Integer.parseInt(ordertimes10);

                    out.println("<tr><td>"+(String)map.get("statdate")+"</td>"+tdInformat+cpcode+"</td>");
                    out.println("<td align=center>"+(String)map.get("ordertimes1")+"</td>");
                    out.println("<td align=center>"+(String)map.get("ordertimes2")+"</td>");
                    out.println("<td align=center>"+(String)map.get("ordertimes3")+"</td>");
                    out.println("<td align=center>"+(String)map.get("ordertimes4")+"</td>");
                    out.println("<td align=center>"+(String)map.get("ordertimes5")+"</td>");
                    out.println("<td align=center>"+(String)map.get("ordertimes6")+"</td>");
                    out.println("<td align=center>"+(String)map.get("ordertimes7")+"</td>");
                    out.println("<td align=center>"+(String)map.get("ordertimes8")+"</td>");
                    out.println("<td align=center>"+(String)map.get("ordertimes9")+"</td>");
                    out.println("<td align=center>"+(String)map.get("ordertimes10")+"</td>");
                    out.println("</tr>");

                    num1+=intordertimes1;
                    num2+=intordertimes2;
                    num3+=intordertimes3;
                    num4+=intordertimes4;
                    num5+=intordertimes5;
                    num6+=intordertimes6;
                    num7+=intordertimes7;
                    num8+=intordertimes8;
                    num9+=intordertimes9;
                    num10+=intordertimes10;
                  }

                  if(!sp.equals("*"))
                  {
                    out.println("<tr>");
                    out.println("<td align=center colspan='2'>Total:</td>");
                    out.println("<td align=center >"+num1+"</td>");
                    out.println("<td align=center >"+num2+"</td>");
                    out.println("<td align=center >"+num3+"</td>");
                    out.println("<td align=center >"+num4+"</td>");
                    out.println("<td align=center >"+num5+"</td>");
                    out.println("<td align=center >"+num6+"</td>");
                    out.println("<td align=center >"+num7+"</td>");
                    out.println("<td align=center >"+num8+"</td>");
                    out.println("<td align=center >"+num9+"</td>");
                    out.println("<td align=center >"+num10+"</td>");
                    out.println("</tr>");
                  }
                  out.println("</table>");
                  return;
                }//export end.
//			}else{
//			    	manStat manstat = new manStat();
//				list = manstat.spScribStatAll(hash);
//			}
		}
//		  String optSCP = "";
//		  ArrayList scplist = syspara.getScpList();
//          for (int i = 0; i < scplist.size(); i++)
//              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";

%>
<html>
<head>
<title>Service development statistics</title>
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
            alert('Please enter the start time!');//请输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checkDate1(fm.startday.value)) {
            alert('Invalid start time entered. \r\n Please enter the start time in the YYYY.MM format');//起始时间输入错误,\r\n请按YYYY.MM输入起始时间!
            fm.startday.focus();
            return false;
         }
         if (! checktrue1(fm.startday.value)) {
            alert('Start time cannot be later than the current time!');//起始时间不能大于当前时间
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            alert('Please enter the end time!');//请输入结束时间
            fm.endday.focus();
            return false;
         }
         if (! checkDate1(fm.endday.value)) {
            alert('Invalid end time entered. \r\n Please enter the end time in the YYYY.MM format');//结束时间输入错误,\r\n请按YYYY.MM输入起始时间!
            fm.endday.focus();
            return false;
         }
         if (! checktrue1(fm.endday.value)) {
            alert('End time should be later than the current time!');//结束时间不能大于当前时间
            fm.endday.focus();
            return false;
         }
         if (! compareDate1(fm.startday.value,fm.endday.value)) {
            alert('Start time should be prior to the end time!');//起始时间应该在结束时间之前
            fm.startday.focus();
            return false;
         }
          if (! checktrue5(fm.startday.value,fm.endday.value)) {
            alert('The period between start time and end time can not be more than one year!');//结束时间不能超过起始时间一年以上
            fm.startday.focus();
            return false;
         }

      }
	  else if(fm.checkflag[1].checked)
          {
	      if (trim(fm.startday.value) == '') {
            alert('Please enter the start time!');//请输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checkDate2(fm.startday.value)) {
            alert('Invalid start time entered. \r\n Please enter the start time in the YYYY.MM.DD format');//起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!
            fm.startday.focus();
            return false;
         }
         if (! checktrue2(fm.startday.value)) {
            alert('Start time cannot be later than the current time!');//起始时间不能大于当前时间
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            alert('Please enter the end time!');//请输入结束时间
            fm.endday.focus();
            return false;
         }
         if (! checkDate2(fm.endday.value)) {
            alert('Invalid end time entered. \r\n Please enter the end time in the YYYY.MM.DD format!');//结束时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!
            fm.endday.focus();
            return false;
         }
         if (! checktrue2(fm.endday.value)) {
            alert('End time should be later than the current time!');//结束时间不能大于当前时间
            fm.endday.focus();
            return false;
         }
         if (! compareDate2(fm.startday.value,fm.endday.value)) {
            alert('Start time should be prior to the end time!');//起始时间应该在结束时间之前
            fm.startday.focus();
            return false;
         }
         if(!ifinsamemonth(fm.startday.value,fm.endday.value))
          {
            alert('Start time and end time should be in the same month');//起始时间应该和结束时间在同一月内
            fm.startday.focus();
            return false;
           }
	  }
          /*
          else if(fm.checkflag.value=='3'){
	     if (trim(fm.startday.value) == '') {
            alert('Please enter the start time!');//请输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checkDate3(fm.startday.value)) {
            alert('Invalid start time entered. Please enter the start time in the YYYY.MM.DD.HH format!');//起始时间输入错误,\r\n请按YYYY.MM.DD.HH输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checktrue3(fm.startday.value)) {
            alert('Start time cannot be later than the current time!');//起始时间不能大于当前时间
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            alert('Please enter the end time!');//请输入结束时间
            fm.endday.focus();
            return false;
         }
         if (! checkDate3(fm.endday.value)) {
            alert('Invalid end time entered. \r\n Please enter the end time in the YYYY.MM.DD.HH format');//结束时间输入错误,\r\n请按YYYY.MM.DD.HH输入起始时间
            fm.endday.focus();
            return false;
         }
         if (! checktrue3(fm.endday.value)) {
            alert('End time should be later than the current time!');//结束时间不能大于当前时间
            fm.endday.focus();
            return false;
         }
         if (! compareDate3(fm.startday.value,fm.endday.value)) {
            alert('Start time should be prior to the end time!');//起始时间应该在结束时间之前
            fm.startday.focus();
            return false;
         }
	  }

	 if(fm.checkflag.value==''){
			alert('You must select a query criterion!');//您必须选择一个查询条件
			return false;
		}
        */
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
      if (! checkInfo()){
        return;
      }
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

	if(count>1){
	   alert('You can only select one statistical criterion!');//您只能选中一种统计条件
	   fm.month.checked=false;
	   fm.day.checked =false;

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
          /*
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
           */
          fm.startday.value = year + "." + strMonth+".01";

       // fm.day.value ="1";
     }
	 else if(fm.checkflag[0].checked){

	//   fm.checkflag.value = 1;
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

       // fm.month.value ="1";
     }

	 else {
       fm.startday.value = "";
       fm.endday.value = "";
       fm.endday.disabled = true;
       fm.startday.disabled = true;
	   fm.checkflag.value = '';
    }

  }

   function ifinsamemonth(str1,str2){

  	var str1mon  = str1.substring(0,7);
  	var str2mon  = str2.substring(0,7);

      if(str1mon == str2mon)
      {
      return true;
      }

      return false;
  }

    function  initform(fm){
     var value = '<%=checkflag%>';
     if(value=='1')
        fm.checkflag[0].checked = true;
     else if(value=='2')
       fm.checkflag[1].checked = true;

     else
       fm.checkflag[0].checked = true;
     <%if(checkflag.length()==0){%>
       onCheckTime();
    <%}%>
    }


</script>
<form name="InputForm" method="post" action="StatSpRingboard.jsp">
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
          <td height="30" colspan=5 align="center" class="text-title" background="image/n-9.gif" >Query SP Ringboard orders</td>
   </tr>

   <tr>
     <td>
   <input type="radio" name="checkflag" value="1" onclick="onCheckTime()">Statistic by month</input></td>
   <td><input type="radio" name="checkflag" value="2" onClick="onCheckTime()">by day</input></td>

   <td   align="right">SP List&nbsp;
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
          <td width="10%" height="24" align="center" ><span class="style1">Date</span></td>
          <td width="5%" height="24" align="center"><span class="style1">SP code</span></td>
          <td width="10%" height="24" align="center"><span class="style1">times of<br>board1</span></td>
          <td width="10%" height="24" align="center"><span class="style1">times of<br>board2</span></td>
          <td width="10%" height="24" align="center"><span class="style1">times of<br>board3</span></td>
          <td width="10%" height="24" align="center"><span class="style1">times of<br>board4</span></td>
          <td width="10%" height="24" align="center"><span class="style1">times of<br>board5</span></td>
          <td width="10%" height="24" align="center"><span class="style1">times of<br>board6</span></td>
          <td width="10%" height="24" align="center"><span class="style1">times of<br>board7</span></td>
          <td width="10%" height="24" align="center"><span class="style1">times of<br>board8</span></td>
          <td width="10%" height="24" align="center"><span class="style1">times of<br>board9</span></td>
          <td width="10%" height="24" align="center"><span class="style1">times<br> of<br>board10</span></td>
        </tr>
<%
        if(list!=null){
          long num1=0,num2=0,num3=0,num4=0,num5=0,num6=0,num7=0,num8=0,num9=0,num10=0;String tVAL="";
		 	int countm = list.size() == 0 ? 15 : 0;
		 for (int i = thepage*15; i < thepage*15+15 && i<list.size(); i++) {
                   map = (HashMap)list.get(i);
                   countm++;
                   String  bgcl = i % 2 == 0 ? "#f5fbff" : "" ;
                   String ordertimes1 = map.get("ordertimes1").toString();
                   int intordertimes1 = Integer.parseInt(ordertimes1);
                   String ordertimes2 = map.get("ordertimes2").toString();
                   int intordertimes2 = Integer.parseInt(ordertimes2);
                   String ordertimes3 = map.get("ordertimes3").toString();
                   int intordertimes3 = Integer.parseInt(ordertimes3);
                   String ordertimes4 = map.get("ordertimes4").toString();
                   int intordertimes4 = Integer.parseInt(ordertimes4);
                   String ordertimes5 = map.get("ordertimes5").toString();
                   int intordertimes5 = Integer.parseInt(ordertimes5);
                   String ordertimes6 = map.get("ordertimes6").toString();
                   int intordertimes6 = Integer.parseInt(ordertimes6);
                   String ordertimes7 = map.get("ordertimes7").toString();
                   int intordertimes7 = Integer.parseInt(ordertimes7);
                   String ordertimes8 = map.get("ordertimes8").toString();
                   int intordertimes8 = Integer.parseInt(ordertimes8);
                   String ordertimes9 = map.get("ordertimes9").toString();
                   int intordertimes9 = Integer.parseInt(ordertimes9);
                   String ordertimes10 = map.get("ordertimes10").toString();
                   int intordertimes10 = Integer.parseInt(ordertimes10);

                  String spindex = map.get("spindex").toString();
                  String cpcode = getSpcode(spindex, spInfo);

                    out.println("<tr bgcolor="+bgcl + ">");
				out.println("<td align=center>"+(String)map.get("statdate")+"</td>");
				out.println("<td align=center>"+cpcode+"</td>");
				out.println("<td align=center>" + ordertimes1 + "</td>");
                                num1+=intordertimes1;
          			out.println("<td align=center>" + ordertimes2 + "</td>");
                                num2+=intordertimes2;
                                out.println("<td align=center>" + ordertimes3 + "</td>");
                                num3+=intordertimes3;
                                out.println("<td align=center>" + ordertimes4 + "</td>");
                                num4+=intordertimes4;
                                out.println("<td align=center>" + ordertimes5 + "</td>");
                                num5+=intordertimes5;
                                out.println("<td align=center>" + ordertimes6 + "</td>");
                                num6+=intordertimes6;
                                out.println("<td align=center>" + ordertimes7 + "</td>");
                                num7+=intordertimes7;
                                out.println("<td align=center>" + ordertimes8 + "</td>");
                                num8+=intordertimes8;
                                out.println("<td align=center>" + ordertimes9 + "</td>");
                                num9+=intordertimes9;
				out.println("<td align=center>" + ordertimes10 + "</td>");
                                num10+=intordertimes10;
          		out.println("</tr>");
		  }
                  if(!sp.equals("*")&&list.size()>0)
                  {
                    out.println("<tr>");
                    out.println("<td align=center colspan='2'>Total:</td>");
                    out.println("<td align=center >"+num1+"</td>");
                    out.println("<td align=center >"+num2+"</td>");
                    out.println("<td align=center >"+num3+"</td>");
                    out.println("<td align=center >"+num4+"</td>");
                    out.println("<td align=center >"+num5+"</td>");
                    out.println("<td align=center >"+num6+"</td>");
                    out.println("<td align=center >"+num7+"</td>");
                    out.println("<td align=center >"+num8+"</td>");
                    out.println("<td align=center >"+num9+"</td>");
                    out.println("<td align=center >"+num10+"</td>");

                    out.println("</tr>");
                  }

		  %>
		  <%
        if (list.size() > 15) {
%>
  <tr>
    <td width="100%" colspan="5">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;Total:<%= list.size() %>,&nbsp;<%= list.size()/15+1 %>page(s),&nbsp;&nbsp;Now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 15 + 15 >= list.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (list.size() - 1) / 15 %>)"></td>
        </tr>
      </table>
    </td>
  </tr>
<%
        }else if(list.size()==0&& checkflag.length()!=0){
        %>
<tr>
	<td width="50%" align="center" colspan="12">
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
        sysInfo.add(sysTime + operName + " Exception occurred in querying this order!");//铃音订购查询过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in querying this order!");//铃音订购查询过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="StatSpRingboard.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>
