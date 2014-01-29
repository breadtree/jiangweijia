<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.io.*" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
     String opcodearray[]={"5","6","904","905"};
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        String  errmsg = "";
        boolean flag =true;
        zxyw50.Purview purview = new zxyw50.Purview();

       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
      }
      else if (purviewList.get("4-30") == null  || (!purview.CheckOperatorRightAllSerno(session,"4-30"))) {
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
          HashMap   map   = new HashMap();
	  String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();

        manSysPara  syspara = new manSysPara();
	    String    startday = "";
	    String    endday   = "";
	    String    checkflag  = "";
            String    opermode ="";
            Vector arraylist=new Vector();

        checkflag = request.getParameter("checkflag") == null ? "1" : ((String)request.getParameter("checkflag")).trim();
        opermode = request.getParameter("opermode") == null ? "1" : ((String)request.getParameter("opermode")).trim();
        startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
        endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
        int rownum=3;
        if(!startday.equals("")&&!endday.equals("")){
          if(checkflag.equals("1"))
          rownum=Integer.parseInt(endday.substring(5,7))-Integer.parseInt(startday.substring(5,7))+1;
          else
           rownum=Integer.parseInt(endday.substring(5,7))-Integer.parseInt(startday.substring(5,7));
        }
        String optSCP = "";
        if(startday.equals("")){
           Date today  =  new Date();
           int  year  = today.getYear()+1900;
           int  month  = today.getMonth() + 1;
           String strMonth = Integer.toString(month);
           if(month<10)
              strMonth = "0"  + strMonth;
           endday = Integer.toString(year) + "." + strMonth;
           if(month-2<=0)
              year = year -1;
           month = (month -2 +12)%12;
           if(month==0)
             month = 12;
           strMonth = Integer.toString(month);
           if(month<10)
              strMonth = "0"  + strMonth;
           startday   = Integer.toString(year) + "." + strMonth;
        }
        map.put("opermode",opermode);
        map.put("startday",startday);
        map.put("endday",endday);
        map.put("opcode1","5");  //集团个人彩铃用户开户
        map.put("opcode2","6");  //集团个人彩铃用户销户
        map.put("opcode3","904");//集团彩铃用户开户
        map.put("opcode4","905");//集团彩铃用户销户
        manStat   manstat   = new manStat();
        arraylist = manstat.getGrpUserOpenTypeLog(map);

        if(op.equals("bakdata")){
          int rowcount=Integer.parseInt(session.getAttribute("rownum").toString());
          response.setContentType("application/msexcel");
          short stat_type = XlsNameGenerate.STATISTIC_NONE;
          if(checkflag.equals("0")) {
            stat_type = XlsNameGenerate.STATISTIC_DAY;// by day
          } else if(checkflag.equals("1")) {
            stat_type = XlsNameGenerate.STATISTIC_MONTH;// by month
          }
          String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "grpOpenCancel", stat_type);
          response.setHeader("Content-disposition","inline; filename=" + file_name);
          out.clear();
          out.println("<table border='1'>");
          out.println("<tr><td>Group or person ringtone opening amount</td><td>Group or person ringtone cancellation amount</td><td>Group ringtone opening amount</td><td>Group ringtone cancellation amount</td></tr>");
          out.println("<table>");
          for(int m=0;m<rowcount;m++){
            out.println("<tr>");
            for(int j=0;j<4;j++){
              Vector map1 = (Vector)arraylist.get(j);
              out.print("<td align=center>"+map1.elementAt(m)+"</td>");
            }
            out.println("</tr>");
          }
          out.println("</table>");
          return;
        }

        int thepage = 0 ;
        int pagecount = 0;
        int records = 15;
        int size=0;
        if(arraylist==null)
           size =-1;
        else
           size = arraylist.size();
        pagecount = size/records;
        if(size%records>0)
           pagecount = pagecount + 1;
        if(pagecount==0)
            pagecount = 1;
%>
<html>
<head>
<title>Query of group subscriber  registration and deregistration mode!</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body class="body-style1" onload="initform(document.forms[0])" >

<script language="javascript">
   function initform(pform){
      var value = "<%= checkflag %>"
      pform.checkflag[value].checked = true;
   }

   function checkInfo () {
      var fm = document.InputForm;
      var tmp = '';
      if (fm.checkflag[1].checked) {
         if (trim(fm.startday.value) == '') {
           // alert('请输入起始时间!');
            alert("Please input start time!");
            fm.startday.focus();
            return false;
         }
         if (! checkDate1(fm.startday.value)) {
            //alert('起始时间输入错误,\r\n请按YYYY.MM输入起始时间!');
            alert("Start time input error,please input start time with the format of YYYY.MM!");
            fm.startday.focus();
            return false;
         }
         if (! checktrue1(fm.startday.value)) {
           // alert('起始时间不能大于当前时间!');
           alert("Start time cannot be later than current time!");
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            //alert('请输入结束时间!');
            alert("Please input the end time!");
            fm.endday.focus();
            return false;
         }
         if (! checkDate1(fm.endday.value)) {
            //alert('结束时间输入错误,\r\n请按YYYY.MM输入起始时间!');
            alert("End time input error,please input end time with the format of YYYY.MM!");
            fm.endday.focus();
            return false;
         }
         if (! checktrue1(fm.endday.value)) {
            //alert('结束时间不能大于当前时间!');
            alert("End time cannot be later than current time!");
            fm.endday.focus();
            return false;
         }
         if (! compareDate1(fm.startday.value,fm.endday.value)) {
            //alert('起始时间应该在结束时间之前!');
            alert("Start time should be earlier than end time!");
            fm.startday.focus();
            return false;
         }
          var  value = trim(fm.startday.value);
         var sStartDate = getMonthPriorDate(2).substring(0,7);
         var tmp1 = sStartDate.substring(0,4) + sStartDate.substring(5,7) + sStartDate.substring(8,10);
         var tmp2 = value.substring(0,4) + value.substring(5,7) + value.substring(8,10);
         if(tmp1 > tmp2 ){
           // alert('对不起,您只能查到日期 ' + sStartDate + ' 以后的记录,请重新输入起始日期!' );
           alert('Sorry,you can only query the record after the date of  ' + sStartDate + ', please re-enter the start date!' );
            fm.startday.focus();
            return false;
         }
      }
	  else {
	      if (trim(fm.startday.value) == '') {
            //alert('请输入起始时间!');
            alert("Please input the start time! ");
            fm.startday.focus();
            return false;
         }
         if (! checkDate2(fm.startday.value)) {
           // alert('起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!');
           alert("Start time input error,please re-enter start time with the format of YYYY.MM.DD");
            fm.startday.focus();
            return false;
         }
         if (! checktrue2(fm.startday.value)) {
            //alert('起始时间不能大于当前时间!');
            alert("Start time cannot be later than current time!");
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            //alert('请输入结束时间!');
            alert("Please input the end time!");
            fm.endday.focus();
            return false;
         }
         if (! checkDate2(fm.endday.value)) {
           // alert('结束时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!');
            alert("End time input error,please input the end time with the format of YYYY.MM.DD");
            fm.endday.focus();
            return false;
         }
         if (! checktrue2(fm.endday.value)) {
            //alert('结束时间不能大于当前时间!');
            alert("End time cannot be later than current time!");
            fm.endday.focus();
            return false;
         }
         if (! compareDate2(fm.startday.value,fm.endday.value)) {
           // alert('起始时间应该在结束时间之前!');
            alert("Start time should be earlier than end time!");
            fm.startday.focus();
            return false;
         }
         var  value = trim(fm.startday.value);
         var sStartDate = getMonthPriorDate(2);
         var tmp1 = sStartDate.substring(0,4) + sStartDate.substring(5,7) + sStartDate.substring(8,10);
         var tmp2 = value.substring(0,4) + value.substring(5,7) + value.substring(8,10);
         if(tmp1 > tmp2 )      {
            //alert('对不起,您只能查到日期 ' + sStartDate + ' 以后的记录,请重新输入起始日期!' );
            alert("Sorry,you can only query record after the date of "+sStartDate+",please re-enter the start date!");
            fm.startday.focus();
            return false;
         }
	  }
	  return true;
   }

   function searchInfo () {
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
 function onCheckTime(){
	var fm = document.InputForm;
	if(fm.checkflag[0].checked){
       var today  = new Date();
       var year = today.getYear();
       var month = today.getMonth() + 1;
       var day = today.getDate();
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
       var month1 = (month-2 + 12)%12;
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
     }
	 else {
       var today  = new Date();
       var year = today.getYear();
       var month = today.getMonth() + 1;
       var strMonth = "";
       if(month<10)
          strMonth = "0" + month;
       else
          strMonth = month;
       fm.endday.value = year + "." + strMonth;
       var month1 = (month-2 + 12)%12;
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
     }
  }
</script>
<form name="InputForm" method="post" action="grpmemberopentype.jsp">
<input type="hidden" name="op" value="<%= op%>">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height=600;
</script>
<table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2" height=hei>
  <tr>
    <td valign="top" height="35">
	    <table class="table-style2" width="100%">
	    <tr>
          <td height="26" colspan=4 align="center" class="text-title"  background="image/n-9.gif">Group subscriber open and cancellation mode query</td>
        </tr>
        <tr>
             <td width="50%">Account open or cancellation mode
            <select name="opermode" class="input-style1" >
              <%if(opermode.equals("1")){%>
              <option value ="1"  selected="selected">----97----</option>
              <option value ="2" >----WEB-----</option>
             <% }else{%>
               <option value ="1" >----97----</option>
              <option value ="2"  selected="selected">----WEB-----</option>
            <% }%>
	     </select>
	    </td>
             <td width="15%" >&nbsp;&nbsp;Query type:</td>
             <td width="15%" > <input type="radio" name="checkflag" value="0" onclick="onCheckTime()">by day
             <td width="20%"> <input type="radio" name="checkflag" value="1" onClick="onCheckTime()">by month</td>
         </tr>
        </table>
   </td>
   </tr>
   <tr>
   <td>
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
		  <td width="11%" align="right"><img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
  <td align="center" >
     <table width="100%" border="0" cellspacing="1" cellpadding="2"  class="table-style2" >
       <tr class="table-title1">
          <td width="25%"  align="center"><span title="Group personal CRBT opening amount">Personal opening</span></td>
          <td width="25%"  align="center"><span title="Group personal CRBT cancellation amount">Personal cancellation</span></td>
          <td width="25%"  align="center"><span title="Group CRBT opening amount">Opening</span></td>
          <td width="25%"  align="center"><span title="Group CRBT cancellation amount">cancellation</span></td>
         </tr>

         <%if(size==0){
			%>
			<tr><td class="table-style2" align="center" colspan="10">There are records meeting!</td>
			</tr>
			<%}else if(size>0){
          for(int m=0;m<rownum;m++){
            %>
          <tr>
          <% for(int j=0;j<4;j++){
                Vector map1 = (Vector)arraylist.get(j);
                out.print("<td align=center>"+map1.elementAt(m)+"</td>");
      }%>
</tr>
<%} }
  session.setAttribute("rownum",rownum+"");
%>
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
        sysInfo.add(sysTime + operName + "Exception the query of group user registration and deregistration mode!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(" Error  the query of group user registration and deregistration mode!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpmemberopentype.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>
