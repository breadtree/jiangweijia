<%@ page import="zxyw50.require.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.io.File"%>
<%@ page import="jxl.*"%>
<%@ page import="jxl.write.*"%>
<%@ page import="java.util.*"%>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    List arraylist = null;
    try {
        String    errmsg = "";
        boolean   flag =true;
	zxyw50.Purview purview = new zxyw50.Purview();
        if (purviewList.get("4-17") == null  || (!purview.CheckOperatorRightAllSerno(session,"4-17"))) {
          errmsg = "You have no access to this function!";
          flag = false;
         }
       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
       }
       if(flag){
          String startday = "";
          String endday = "";
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          boolean checkflag = request.getParameter("checkTime") != null ? true : false;
          if(op.equals("search") || op.equals("bakdata")){
             startday = request.getParameter("start") == null ? "" : ((String)request.getParameter("start")).trim();
             endday = request.getParameter("end") == null ? "" : ((String)request.getParameter("end")).trim();
//             if(startday.equals("")&&endday.endsWith("")){
//                 arraylist = RequireRingCached.getInstance().load();
//             }else{
                 arraylist = new DefaultRequireContext().loadSortedRingRequire(startday,endday);
//             }
            //write Excel File, the temp file use the same file,here wo think concurrent is a little probability
           /* try{
              String filename = application.getRealPath("temp")+"/tmp_"+operID+".xls";
              WritableWorkbook workbook = Workbook.createWorkbook(new File(filename));
              WritableSheet sheet = workbook.createSheet("First Sheet", 0);
              sheet.setColumnView(0,20);
              sheet.setColumnView(1,30);
              sheet.setColumnView(2,18);
              sheet.setColumnView(3,20);
              sheet.setColumnView(4,12);
              sheet.setColumnView(5,12);
              sheet.setColumnView(6,12);
              //sheet.setRowView(0,10);
              Label label = new Label(0, 0, "Ringtone Name");
              sheet.addCell(label);
              label = new Label(1, 0, "Singer");
              sheet.addCell(label);
              label = new Label(2, 0, "Count of requirements");
              sheet.addCell(label);
              String[] obj=null;
              for (int i = 0; i < arraylist.size(); i++) {
                 obj = (String[])arraylist.get(i);
                 label = new Label(0,i+1,obj[0]);
                 sheet.addCell(label);
                 label = new Label(1,i+1,obj[1]);
                 sheet.addCell(label);
                 label = new Label(2,i+1,obj[2]);
                 sheet.addCell(label);
              }
//////////
              workbook.write();
              workbook.close();
            }catch(Exception e1){
              e1.printStackTrace();
              System.out.println("11111111="+application.getRealPath("temp"));
              System.out.println("eeeeeeeeeeeeee  ="+e1.getMessage());
            }*/
         }
         if(op.equals("bakdata")){


    		response.setContentType("application/msexcel");
		String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "totalRequireRing", XlsNameGenerate.STATISTIC_DAY);
        response.setHeader("Content-disposition","inline; filename=" + file_name);
             	out.clear();
             	out.println("<table border='1'>");
    		out.println("<tr><td>Ringtone Name</td><td>Singer</td><td>Count of requirements</td></tr>");
            	String[] obj=null;
            	for (int i = 0; i < arraylist.size(); i++) {
            	        obj = (String[])arraylist.get(i);
                       	out.println("<tr><td>"+obj[0]+"</td><td>"+obj[1]+"</td><td>"+obj[2]+"</td></tr>");
               	}
                out.println("</table>");

        	return;
      	  }
          int  records = 10;
          int thepage = 0 ;
          int pagecount = 0;
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
<title>Query the subscriber's ringtone requirements</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<body background="background.gif" class="body-style1" onload="loadPage();" >

<script language="javascript">

   function loadPage(){
     firstPage();
   }

   function onCheckTime(){
      var fm = document.inputForm;
      if (fm.checkTime.checked) {
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
        var month1 = (month-1 + 12)%12;
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
      else{
         fm.start.value = "0";
         fm.end.value = "0";
         fm.startday.value = "";
         fm.endday.value = "";
         fm.endday.disabled = true;
         fm.startday.disabled = true;
      }
      return;
   }

   function checkInfo () {
      var fm = document.inputForm;
      if (fm.checkTime.checked) {
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
            alert('End time should not be later than the current time!');//结束时间不能大于当前时间
            fm.endday.focus();
            return false;
         }
         if (! compareDate2(fm.startday.value,fm.endday.value)) {
            alert('Start time should be prior to the end time!');//起始时间应该在结束时间之前
            fm.startday.focus();
            return false;
         }
         fm.start.value = tmp = trim(fm.startday.value);
         fm.end.value = trim(fm.endday.value);
      }
      else{
          fm.start.value = "";
          fm.end.value = "";
      }

      return true;
   }

   function searchInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'search';
      fm.target="_self";
      fm.submit();
   }

 function WriteDataInExcel(){
 //parent.location.href="downloadPic.jsp?filename=tmp_<%//=operID%>.xls&filepath=<%//=application.getRealPath("temp").replace('\\','/')+"/"%>";
 if (! checkInfo())
         return;

      var fm = document.inputForm;
      fm.op.value = 'bakdata';
      fm.target="top";
      fm.submit();
   }
   function offpage(num){
  	var obj  = eval("page_" + num);
  	obj.style.display="none";
  }

  function onpage(num){
      var obj  = eval("page_" + num);
  	  obj.style.display="block";
  	  document.forms[0].thepage.value = num;
  }

  function firstPage(){
	if(parseInt(document.forms[0].pagecount.value)==0)
	   return;
	var thePage = document.forms[0].thepage.value;
	offpage(thePage);
	onpage(1);
	return true;
  }

  function toPage(value){
	var thePage = parseInt(document.forms[0].thepage.value);
	var pageCount = parseInt(document.forms[0].pagecount.value);
	var index = thePage+value;
	if(index > pageCount || index<0)
	   return;
	if(index!=thePage){
	   offpage(thePage);
	   onpage(index);
     }
	return true;
  }

  function endPage(){
	var thePage = document.forms[0].thepage.value;
	var pageCount = parseInt(document.forms[0].pagecount.value);
	offpage(thePage);
	onpage(pageCount)
	return true;
  }

</script>
<form name="inputForm" method="post" action="queryRequireRingTotal.jsp">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="start" value="<%= startday + "" %>">
<input type="hidden" name="end" value="<%= endday + "" %>">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="700";
</script>
  <table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
          <td height="40"  align="center" class="text-title" background="image/n-9.gif">Statistics on the subscriber's<br>ringtone requirements</td>
   </tr>
   <tr>
   <td align="center">
     <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="98%">
     <tr>
     <td >
         <input type="checkbox" name="checkTime" value="on"<%= checkflag ? " checked" : "" %>  onclick="onCheckTime()" >Start and end date(YYYY.MM.DD)<br>
      Start&nbsp;
      <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:100px">
      End&nbsp;
      <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:100px">
      &nbsp;<img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
     </td>
     </tr>
     </table>
  </td>
  </tr>
  <tr>
  <td>
   <%
        int  record = 0;
        for (int i = 0; i < pagecount; i++) {
          String pageid = "page_"+Integer.toString(i+1);
  %>

     <table width="100%" border="0" cellspacing="1" cellpadding="1" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
         <tr class="table-title1">
          <td height="30" width="150">
              <div align="center">Ringtone</div>
          </td>
          <td height="30" width="100">
              <div align="center">Singer</div>
          </td>
          <td height="30" width="150">
              <div align="center">Count of requirements</div>
          </td>
        </tr>

 <%
   			if(size==0){
			%>
			<tr><td align="center" colspan="10">No record matched the criteria</td>
			</tr>
			<%
			}else if(size>0){
			if(i==(pagecount-1))
               record = size - (pagecount-1)*records;
            else
               record = records;
            for(int j=0;j<record;j++){
                String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                String[] obj = (String[])arraylist.get(i*records + j);
                out.print("<tr bgcolor=" +strcolor + " height=20 >");
                out.print("<td align=center>"+obj[0]+"</td>");
                out.print("<td align=center>"+obj[1]+"</td>");
                out.print("<td align=center>"+obj[2]+" times</td>");
                out.print("</td></tr>");
      }
   //   session.setAttribute("ResultSession",arraylist);
 %>

 <%
         if (arraylist.size() > records) {
%>
        <tr>
        <td width="100%" colspan="7">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td>Total:<%= arraylist.size() %>&nbsp;,&nbsp;<%= pagecount %>&nbsp;page(s)&nbsp;&nbsp;now on Page &nbsp;<%= i+1 %>&nbsp;</td>
              <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()"></td>
              <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>></td>
              <td><img src="button/nextpage.gif" <%= i * records + records >= arraylist.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %>></td>
              <td><img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage()"></td>
            </tr>
          </table>
        </td>
      </tr>
   </table>
<%
										}
	}

        }
%>
      </td>
  </tr>
</table>
</form>
<%
        }
        else {
%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in the statistics on ringtone requirements!");//用户铃音需求统计过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in the statistics on ringtone requirements!");//用户铃音需求统计过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="queryRequireRingTotal.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
