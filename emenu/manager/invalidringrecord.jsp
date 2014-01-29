<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="java.io.File"%>
<%@ page import="jxl.*"%>
<%@ page import="jxl.write.*"%>
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
    try {
        List arraylist = null;
        Map   map  = new HashMap();
        String    errmsg = "";
        boolean   flag =true;
	zxyw50.Purview purview = new zxyw50.Purview();
        //????????权限设置
        if (purviewList.get("4-26") == null  || (!purview.CheckOperatorRightAllSerno(session,"4-26"))) {
          errmsg = "You have no access to this function!";
          flag = false;
         }
       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system!
          flag = false;
       }
       if(flag){
          manStat  manstat = new manStat();
          String ringid = "";
          String startday = "";
          String endday = "";

          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          boolean checkflag = request.getParameter("checkTime") != null ? true : false;
          if(op.equals("search") || op.equals("bakdata")){
             ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
             startday = request.getParameter("start") == null ? "" : ((String)request.getParameter("start")).trim();
             endday = request.getParameter("end") == null ? "" : ((String)request.getParameter("end")).trim();
             map.put("ringid",ringid);
             map.put("startday",startday);
             map.put("endday",endday);
             arraylist = manstat.getInvalidRingRecords(map);

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
              Label label = new Label(0, 0, "SP name");
              sheet.addCell(label);
              label = new Label(1, 0, "Ringtone code");
              sheet.addCell(label);
              label = new Label(2, 0, "Ringtone name");
              sheet.addCell(label);
              label = new Label(3, 0, "Invalidity date");
              sheet.addCell(label);
              label = new Label(4, 0, "Delete date");
              sheet.addCell(label);
              for(int i=0;i<arraylist.size();i++){
               HashMap tmpMap = (HashMap) arraylist.get(i);
               label = new Label(0,i+1,(String)tmpMap.get("spname"));
               sheet.addCell(label);
               label = new Label(1,i+1,tmpMap.get("ringid").toString());
               sheet.addCell(label);
               label = new Label(2,i+1,tmpMap.get("ringname").toString());
               sheet.addCell(label);
               label = new Label(3,i+1,tmpMap.get("validdate").toString());//strTmp.getBytes("ISO8859_1"), "GBK")
               sheet.addCell(label);
               label = new Label(4,i+1,(String)tmpMap.get("deltime"));
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
        /////////
           if(op.equals("bakdata")){
    		response.setContentType("application/msexcel");
            String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "invalidRing", XlsNameGenerate.STATISTIC_DAY);
        response.setHeader("Content-disposition","inline; filename=" + file_name);
             	out.clear();
             	out.println("<table border='1'>");
    		out.println("<tr><td>SP name</td><td>Ringtone code</td><td>Ringtone name</td><td>Invalidity date</td><td>Delete date</td></tr>");
            	for (int i = 0; i <arraylist.size(); i++) {
			map = (HashMap)arraylist.get(i);
                  	out.println("<tr><td>"+map.get("spname").toString()+"</td><td>"+map.get("ringid").toString()+"</td><td>"+displayRingName(map.get("ringname").toString())+"</td><td>"+map.get("validdate").toString()+"</td><td>"+map.get("deltime").toString()+"</td></tr>");
               	}
               	out.println("</table>");
        	return;
      	  }
          int  records = 20;
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
<title>System tone expiration deletion record query</title>
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
      if (!checkstring('0123456789',trim(fm.ringid.value))){
          alert('Ringtone code input error. It should be digit only!');
         fm.ringid.focus();
         return  false;
      }
      if (fm.checkTime.checked) {
         if (trim(fm.startday.value) == '') {
            alert('Please input the start time!');//请输入起始时间!
            fm.startday.focus();
            return false;
         }
         if (! checkDate2(fm.startday.value)) {
            alert('Start time input error,\r\nplease input the start time in the YYYY.MM.DD format!');//起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!
            fm.startday.focus();
            return false;
         }
         if (! checktrue2(fm.startday.value)) {
            //alert('起始时间不能大于当前时间!');
            alert("Start time cannot be earlier than current time!");
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
            alert('End time input error,\r\nplease input the end time in the YYYY.MM.DD format!');
            fm.endday.focus();
            return false;
         }
         if (! checktrue2(fm.endday.value)) {
            //alert('结束时间不能大于当前时间!');
            alert("End time should be earlier than current time!");
            fm.endday.focus();
            return false;
         }
         if (! compareDate2(fm.startday.value,fm.endday.value)) {
            //alert('起始时间应该在结束时间之前!');
            alert("Start time should be earlier than end time!");
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
//     parent.location.href="downloadPic.jsp?filename=tmp_<//%=operID%>.xls&filepath=<//%=application.getRealPath("temp").replace('\\','/')+"/"%>";
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
<form name="inputForm" method="post" action="invalidringrecord.jsp">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="start" value="<%= startday + "" %>">
<input type="hidden" name="end" value="<%= endday + "" %>">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="750";
</script>
  <table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
          <td height="26"  align="center" class="text-title" background="image/n-9.gif">
             System ringtone expiration deletion record query</td>
   </tr>
   <tr>
   <td align="center">
     <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="98%">
     <tr>
     <td width="45%">
      Ringtone code&nbsp;
      <input type="text" name="ringid" value="<%= ringid %>"  maxlength="40" class="input-style0" style="width:120px">
     </td>
	 <td width="55%" >
         <input type="checkbox" name="checkTime" value="on"<%= checkflag ? " checked" : "" %>  onclick="onCheckTime()" >Time range(YYYY.MM.DD)
     </td>
     </tr>
     <tr>
     <td>
      Start time&nbsp;
      <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:120px">
     </td>
      <td>
      End time&nbsp;
      <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:120px">
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
         <td height="30" width="30">
              <div align="center"><span title="SP name">SP</span></div>
          </td>
           <td height="30" width="60">
              <div align="center"><span title="Ringtone Code">Code</span></div>
          </td>
          <td height="30" width="160">
              <div align="center"><span title="Ringtone name">Name</span></div>
          </td>
          <td height="30" width="80">
              <div align="center"><span title="Ringtone expire time">Expire time</span></div>
          </td>
          <td height="30" width="80">
              <div align="center"><span title="The time ringtone deleted by operator">Delete time</span></div>
          </td>
        </tr>

 <%
   			if(size==0){
			%>
			<tr><td align="center" colspan="10">No record matched the criteria!</td>
			</tr>
			<%
			}else if(size>0){
			if(i==(pagecount-1))
               record = size - (pagecount-1)*records;
            else
               record = records;
            for(int j=0;j<record;j++){
                String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                map = (HashMap)arraylist.get(i*records + j);
                out.print("<tr bgcolor=" +strcolor + " height=20 >");
                out.print("<td align=center>"+map.get("spname").toString()+"</td>");
                out.print("<td align=center>"+map.get("ringid").toString()+"</td>");
                out.print("<td align=center>"+displayRingName(map.get("ringname").toString())+"</td>");
                out.print("<td >"+map.get("validdate").toString()+"</td>");
                out.print("<td >"+map.get("deltime").toString()+"</td>");
                out.print("</td></tr>");
      }
    //  session.setAttribute("ResultSession",arraylist);
 %>
        <tr>
        <td width="100%" colspan="7">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td>&nbsp;Total:<%= arraylist.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s)&nbsp;&nbsp;Now on Page &nbsp;<%= i+1 %>&nbsp;</td>
              <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()"></td>
              <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>></td>
              <td><img src="button/nextpage.gif" <%= i * records + records >= arraylist.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %>></td>
              <td><img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage()"></td>
            </tr>
          </table>
        </td>
      </tr>
   </table>
<%}

        }
%>
      </td>
  </tr>
</table>
<!--
<script language="javascript">
   var sTmp = "<%=  ringid  %>";
   if(sTmp!='')
     document.forms[0].ringid.value = sTmp;
</script>
<-->
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
        sysInfo.add(sysTime + operName + "It is abnormal during the query of system tone expiration deletion record!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the query of system tone expiration deletion record!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="invalidringrecord.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
