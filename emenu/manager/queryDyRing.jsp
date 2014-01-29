<%@ page import="java.util.*" %>
<%@ page import="java.io.File"%>
<%@ page import="jxl.*"%>
<%@ page import="jxl.write.*"%>
<%@ page import="zxyw50.manStat" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ringid = "";
    String  optSCP = "";
          String startday = "";
          String endday = "";
          String    errmsg = "";
   try {
        ArrayList arraylist = null;
        HashMap   map  = new HashMap();

        boolean   flag =true;
       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
       }
      if (purviewList.get("4-23") == null) {
            errmsg = "Sorry,you have no access to this function!";//You have no access to this function!
            flag = false;
          }
       if(flag){
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
           String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
          manStat  manstat = new manStat();
             ArrayList scplist = manstat.getScpList();
            for (int i = 0; i < scplist.size(); i++) {
            if(i==0 && scp.equals(""))
               scp = (String)scplist.get(i);
               optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
         }
          if(op.equals("search") || op.equals("bakdata")){
          ringid = request.getParameter("ringid") == null ? "" : ((String)request.getParameter("ringid")).trim();
           startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
             endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
             map.put("ringid",ringid);
             map.put("startday",startday);
             map.put("endday",endday);
         if(!scp.equals("")){
           map.put("scp",scp);
             arraylist = manstat.queryActiveRing(map);
            //write Excel File, the temp file use the same file,here wo think concurrent is a little probability
            /*try{
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
              Label label = new Label(0, 0, "Ringtone name");
              sheet.addCell(label);
              label = new Label(1, 0, "Operation time");
              sheet.addCell(label);
              label = new Label(2, 0, "Subscriber number");
              sheet.addCell(label);

              for(int i=0;i<arraylist.size();i++){
               HashMap tmpMap = (HashMap) arraylist.get(i);
               label = new Label(0,i+1,(String)tmpMap.get("ringname"));
               sheet.addCell(label);
               label = new Label(1,i+1,tmpMap.get("opertime").toString());
               sheet.addCell(label);
               label = new Label(2,i+1,tmpMap.get("usernumber").toString());
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
          }
           if(op.equals("bakdata")){
    		response.setContentType("application/msexcel");
					//response.setHeader("Content-disposition","attachment; filename=test.xls");
					String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "activityRing", XlsNameGenerate.STATISTIC_DAY);
        response.setHeader("Content-disposition","inline; filename=" + file_name);
             	out.clear();

             	out.println("<table border='1'>");
                out.println("<tr><td>Ringtone name</td><td >Operation time</td><td>Subscriber number</td></tr>");
    	//	out.println("<tr><td>Ringtone name</td><td >Operation time</td><td>User number</td></tr>");
         		for (int i = 0; i <arraylist.size(); i++)
         		{
			map = (HashMap)arraylist.get(i);


           			out.println("<tr><td>"+(String)map.get("ringname")+"</td><td>"+(String)map.get("opertime")+"</td><td>"
            			+"Mobile phone"+((String)map.get("usernumber"))+"</td></tr>");

               	}
               	out.println("</table>");
        	return;
      	    }
      	  int thepage = 0 ;
          int records = 20;
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
<title>Subscriber ringtone activity Stat.</title>
<!--<title>tatistic of user tone activities</title>-->
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<body background="background.gif" class="body-style1" onload="firstPage();" >

<script language="javascript">
   function checkInfo () {
      var fm = document.inputForm;
      if(trim(fm.ringid.value)=='')
      {
           alert('Please input the ringtone ID for Stat.');//请输入要统计的铃音ID!
           fm.ringid.focus();
            return false;
      }
      if(!checkstring('0123456789',trim(fm.ringid.value)))
      {
        alert('Ringtone ID can only be a digital number!');//铃音ID只能是数字!
        fm.ringid.focus();
        return false;
      }
               if (trim(fm.startday.value) == '') {
            alert('Please input the start date!');//请输入起始时间!
            fm.startday.focus();
            return false;
         }
         if (! checkDate2(fm.startday.value)) {
            //alert('起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!');
            alert("Start date input error,\r\n please input the start date in YYYY.MM.DD format!");
            fm.startday.focus();
            return false;
         }
         if (! checktrue2(fm.startday.value)) {
            alert('Start date cannot be later than current date!');
           // alert('起始时间不能大于当前时间!');
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            //alert('请输入结束时间!');
            alert("Please input the end date!");
            fm.endday.focus();
            return false;
         }
         if (! checkDate2(fm.endday.value)) {
            alert("End date input error,\r\n please input the end date in YYYY.MM.DD format!");
          //  alert('结束时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!');
            fm.endday.focus();
            return false;
         }
        if (! checktrue2(fm.endday.value)) {
           // alert('结束时间不能大于当前时间!');
            alert("End date cannot be later than current date!");
            fm.endday.focus();
            return false;
         }
         if (! compareDate2(fm.startday.value,fm.endday.value)) {
            //alert('起始时间应该在结束时间之前!');
            alert("Start date should be prior to the end date!");
            fm.startday.focus();
            return false;
         }
         fm.startday.value = tmp = trim(fm.startday.value);
         fm.endday.value = trim(fm.endday.value);
         var month1=trim(fm.startday.value);var month2=trim(fm.endday.value);
         month1 = month1.substring(month1.indexOf('.')+1,month1.lastIndexOf('.'));
         month2 = month2.substring(month2.indexOf('.')+1,month2.lastIndexOf('.'));
         var y1=trim(fm.startday.value);var y2=trim(fm.endday.value);
         y1 = y1.substring(0,y1.indexOf('.'));
         y2 = y2.substring(0,y2.indexOf('.'));
         if(eval(y2+'-'+y1)==0)
         {
           if(eval(month2+'-'+month1)>=3)
           {
            // alert('对不起,您只能查询三个月内的铃音活动统计信息!');
             alert("Sorry,you can only query the ringtone activity Stat.in 3 months!");
             return false;
           }
         }else{
           month1=eval('12-'+month1)
           month2=eval('12-(12-'+month2+')')
           if(eval(month2+'+'+month1)>=3)
           {
             //alert('对不起,您只能查询三个月内的铃音活动统计信息!');
             alert("Sorry,you can only query the ringtone activity Stat.in three months!");
             return false;
           }
         }
      return true;
   }

   function searchInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value ="search";
      fm.target="_self";
      fm.submit();
   }

    function WriteDataInExcel(){
 //   parent.location.href="downloadPic.jsp?filename=tmp_<//%=operID%>.xls&filepath=<//%=application.getRealPath("temp").replace('\\','/')+"/"%>";
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
<form name="inputForm" method="post" action="queryDyRing.jsp">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="900";
</script>
  <table border="0" width="98%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
          <td height="26"  align="center" class="text-title"  background="image/n-9.gif">Statistic of user tone activities
		  </td>
   </tr>
   <tr>
   <td width="100%">
      <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="100%" >
      <tr>
      <td width="40%" >
       Ringtone ID&nbsp;<input type="text" name="ringid" class="input-style0"  value="<%=ringid%>">
       </td>
        <td >
              &nbsp;SCP&nbsp; <select name="scplist" size="1"  class="input-style1" style="width:120px">
              <% out.print(optSCP); %>
             </select>
         </td>
      </tr>
      <tr>
     <tr>
     <td width="50%">
      Start date&nbsp;
      <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" >
      </td>
      <td>
      End date
      <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:120px"></td>
    <td width="13%" align="right"><img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()"></td>
     </tr>
     </table>
  </td>
  </tr>
  <tr>
  <td width="100%">
   <%
        int  record = 0;
        for (int i = 0; i < pagecount; i++) {
          String pageid = "page_"+Integer.toString(i+1);
  %>

     <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
         <tr class="table-title1">
          <td height="30" width="33%">
              <div align="center">Ringtone name</div>
          </td>
          <td height="30" width="33%">
              <div align="center">Operation time</div>
          </td>
          <td height="30" width="33%">
              <div align="center">Subscriber number</div>
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
               record = size ;
            else
               record = (i+1)*records;
            //System.out.println("record:"+record);
            for(int j=i*records;j<record;j++){
                String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                map = (HashMap)arraylist.get(j);
                out.print("<tr bgcolor=" +strcolor + " height=20>");
                out.print("<td >&nbsp;&nbsp;"+(String)map.get("ringname")+"</td>");
                out.print("<td>&nbsp;&nbsp;"+(String)map.get("opertime")+"</td>");
                out.print("<td >&nbsp;&nbsp;"+(String)map.get("usernumber")+"</td>");
                out.print("</tr>");
      	    }
      //		session.setAttribute("ResultSession",arraylist);
 %>
        <tr>
        <td width="100%" colspan="7">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td>&nbsp;Total:<%= arraylist.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s),&nbsp;&nbsp;Now on Page&nbsp;<%= i+1 %>&nbsp;</td>
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
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occourred in the Stat.of subscriber ringtone activity!");// 用户铃音活动统计操作查询过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        //vet.add("用户铃音活动统计操作查询过程出现错误!");
        vet.add("Error occourred in the Stat.of subscriber ringtone activity!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="queryDyRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
