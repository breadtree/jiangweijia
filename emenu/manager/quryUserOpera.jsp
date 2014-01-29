<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="java.io.File"%>
<%@ page import="jxl.*"%>
<%@ page import="jxl.write.*"%>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    String sysTime = "";
    String Mon = CrbtUtil.getConfig("iMon","3");
    int iMon = Integer.parseInt(Mon.trim());
    String isCombodia = CrbtUtil.getConfig("isCombodia","0");
    String isSmart = CrbtUtil.getConfig("isSmart", "0");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	zxyw50.Purview purview = new zxyw50.Purview();
    String type = request.getParameter("type") == null ? "" : transferString((String)request.getParameter("type"));
    String allowUp = (String)application.getAttribute("ALLOWUP")==null?"0":(String)application.getAttribute("ALLOWUP");
    try {
        ArrayList arraylist = null;
        HashMap   map  = new HashMap();
        String    errmsg = "";
        String    queryType = "";
        int       queryMode = 0;
        boolean   flag =true;
        if(request.getParameter("type")==null||request.getParameter("type").trim().equals(""))
        {
          if (purviewList.get("4-4") == null) {
            errmsg = "You have no access to this function!";
            flag = false;
          }
        }else{//人工台
           if (purviewList.get("13-16") == null) {
            errmsg = "You have no access to this function!";
            flag = false;
          }
        }
       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
       }
       if(flag){
          String usernumber = "";
          String startday = "";
          String endday = "";
          String opmode = "";
          String scp = "";
          String operator = "";
          String qrymode ="";
		  String usecalling = zte.zxyw50.util.CrbtUtil.getConfig("usecalling","1");
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          boolean checkflag = request.getParameter("checkTime") != null ? true : false;
          qrymode = request.getParameter("qrymode") == null ? "0" : ((String)request.getParameter("qrymode")).trim();
          manStat  manstat = new manStat();
          if(op.equals("search") || op.equals("bakdata")){
             usernumber = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();
             boolean flags = false;
             if("1".equals(type)&&"0".equals(qrymode)) {
               manSysPara msp = new manSysPara();
               flags = msp.isAdUser(usernumber);
             }
             if(!flags){
             operator = request.getParameter("operator") == null ? "" : transferString((String)request.getParameter("operator"));

             scp = request.getParameter("scp") == null ? "" : ((String)request.getParameter("scp")).trim();
             if(!usernumber.equals("")){
               if(!purview.CheckOperatorRight(session,"4-4",usernumber)){
            	  throw new Exception("You have no right to manage this subscriber");
          	}
             }
             opmode = request.getParameter("opmode") == null ? "" : ((String)request.getParameter("opmode")).trim();
             startday = request.getParameter("start") == null ? "" : ((String)request.getParameter("start")).trim();
             endday = request.getParameter("end") == null ? "" : ((String)request.getParameter("end")).trim();
             map.put("usernumber",usernumber);
             map.put("opmode",opmode);
             map.put("startday",startday);
             map.put("endday",endday);
             map.put("operator",operator);
             map.put("scp",scp);
             arraylist = manstat.qryUserOperation(map);
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
              Label label = new Label(0, 0, "Ringtone code");
              sheet.addCell(label);
              label = new Label(1, 0, "Ringtone name");
              sheet.addCell(label);
              label = new Label(2, 0, "Price");
              sheet.addCell(label);
              label = new Label(3, 0, "Operation type");
              sheet.addCell(label);
              label = new Label(4, 0, "Operation time");
              sheet.addCell(label);
              label = new Label(5, 0, "Multilateral interface");
              sheet.addCell(label);
              label = new Label(6, 0, "Subscriber number");
              sheet.addCell(label);
              label = new Label(7, 0, "Operation source");
              sheet.addCell(label);
              label = new Label(8, 0, "Operation description");
              sheet.addCell(label);
              String strTmp;
              for(int i=0;i<arraylist.size();i++){
               HashMap tmpMap = (HashMap) arraylist.get(i);
               label = new Label(0,i+1,(String)tmpMap.get("ringid"));
               sheet.addCell(label);
               label = new Label(1,i+1,tmpMap.get("ringname").toString());
               sheet.addCell(label);
               label = new Label(2,i+1,tmpMap.get("ringfee").toString());
               sheet.addCell(label);
               label = new Label(3,i+1,tmpMap.get("opertype").toString());//strTmp.getBytes("ISO8859_1"), "GBK")
               sheet.addCell(label);
               label = new Label(4,i+1,(String)tmpMap.get("opertime"));
               sheet.addCell(label);
               label = new Label(5,i+1,(String)tmpMap.get("opermode"));
               sheet.addCell(label);
               label = new Label(6,i+1,(String)tmpMap.get("usernumber"));
               sheet.addCell(label);
               label = new Label(7,i+1,(String)tmpMap.get("opersource"));
               sheet.addCell(label);
               label = new Label(8,i+1,(String)tmpMap.get("description"));
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

             } else {
%>
                 <script language="javascript">
                   var str = 'sorry the input username '+<%= usernumber %>+' is a user of advertisement ringtone ,it cannot use in this system!';
                   alert(str);
                   document.URL = 'quryUserOpera.jsp?type=1';
                </script>
<%
             }
          }
          if(op.equals("bakdata")){
            response.setContentType("application/msexcel");
            short stat_type = XlsNameGenerate.STATISTIC_NONE;
            if(checkflag) {
              stat_type = XlsNameGenerate.STATISTIC_DAY;
            }
            String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "userRingOper", stat_type);
            response.setHeader("Content-disposition","inline; filename=" + file_name);
            out.clear();
            out.println("<table border='1'>");
            out.println("<tr><td>Ringtone code</td><td>Ringtone name</td><td>Fee</td><td>Operation Type</td><td >Operation Time</td><td >Multilateral Interface</td><td >Operation Source</td><td >Operation Description</td></tr>");

            for (int i = 0; i <arraylist.size(); i++) {
              map = (HashMap)arraylist.get(i);
              out.println("<tr><td>&lrm;"+(String)map.get("ringid")+"</td><td>&nbsp;"+(String)map.get("ringname")+"</td><td>&lrm;"+(String)map.get("ringfee")+"</td><td>"+(String)map.get("opertype")+"</td><td>&nbsp;"+(String)map.get("opertime")+"</td><td>"+(String)map.get("opermode")+"</td><td>"+(String)map.get("opersource")+"</td><td>"+(String)map.get("description")+"</td></tr>");
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

          String optSCP = "";
		  ArrayList scplist = manstat.getScpList();
          for (int i = 0; i < scplist.size(); i++)
              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
%>

<html>
<head>
<title>Query subscriber ringtone operations</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<SCRIPT language="JavaScript" src="../base/JsFun.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<body background="background.gif" class="body-style1" onload="loadPage();" >
<script language="javascript">
   function onCheckTime(){
      var fm = document.inputForm;
      if (fm.checkTime.checked) {
         var iMon=<%=iMon%>;
        fm.endday.disabled = false;
        fm.startday.disabled = false;
        fm.endday.value = getCurrentDate();
        fm.startday.value = getMonthPriorDate(iMon-1);
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
      var tmp = '';
      var  qrymode = fm.qrymode.value;
      var value = trim(fm.usernumber.value);
      if(qrymode==0){
         if(!isUserNumber(value,'The subscriber number ')){
            fm.usernumber.focus();
            return;
         }
     }
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
        var  value = trim(fm.startday.value);
		 var iMon=<%=iMon%>;
        var sStartDate = getMonthPriorDate(iMon-1);
        var tmp1 = sStartDate.substring(0,4) + sStartDate.substring(5,7) + sStartDate.substring(8,10);
        var tmp2 = value.substring(0,4) + value.substring(5,7) + value.substring(8,10);
        if(tmp1 > tmp2 )      {
            alert('Sorry,the search date should be after ' + sStartDate + ', please re-enter !' );
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
          fm.end.value = '';
          fm.start.value = '';
      }
      return true;
   }

   function searchInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value ="search";
      fm.target="_self";
      fm.operator.value=fm.dispoperator.value;
      fm.submit();
   }

   function WriteDataInExcel(){
     if (! checkInfo())
     return;
     // parent.location.href="downloadPic.jsp?filename=tmp_<//%=operID%>.xls&filepath=<//%=application.getRealPath("temp").replace('\\','/')+"/"%>";
     var fm = document.inputForm;
     fm.op.value = 'bakdata';
     fm.target="top";
	 fm.operator.value=fm.dispoperator.value;
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

  function loadPage(){
     var fm = document.inputForm;
     var sTmp = "<%=  opmode  %>";
     if(sTmp!='')
        fm.opmode.value = sTmp;
     firstPage();
     var qrymode = "<%= qrymode %>";
     if(qrymode!=1)
        qrymode = 0;
     fm.qrymode.value = qrymode;
     var scp = "<%= scp %>";
     if(scp!='')
        fm.scp.value = scp;
     onOpmode();
     if (fm.checkTime.checked) {
          fm.endday.disabled = false;
          fm.startday.disabled = false;
      }
      else{
         fm.endday.disabled = true;
         fm.startday.disabled = true;
      }
   }
   function onOpmode(){
     var fm = document.inputForm;
     if(fm.qrymode.value==0){
        document.inputForm.operator.value = '';
        document.inputForm.dispoperator.value = '';
        document.all('id_usernumber').style.display= 'block';
        document.all('id_operator').style.display= 'none';
     }
     else {
        document.inputForm.usernumber.value = '';
       <%if(purview.CheckOperatorRightAllSerno(session,"4-4")){%>
                document.inputForm.dispoperator.value = "<%=operator %>";
        <%}else{%>
        	document.inputForm.dispoperator.value="<%=operName%>";
        	document.inputForm.dispoperator.disabled=true;
        <%}%>
        document.all('id_usernumber').style.display= 'none';
        document.all('id_operator').style.display= 'block';
     }
   }

</script>
<form name="inputForm" method="post" action="quryUserOpera.jsp">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="start" value="<%= startday + "" %>">
<input type="hidden" name="end" value="<%= endday + "" %>">
<input type="hidden" name="op" value="">
<input type="hidden" name="type" value="<%=type%>">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="900";
</script>
  <table border="0" width="98%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
          <td height="50"  align="center" class="text-title" >Query subscriber operating ringtone
		  </td>
   </tr>
   <tr>
   <td width="100%">
      <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="100%" >
      <tr>
      <td width="40%" height=30>
        Type of query<br>
        <select name="qrymode" style="width:180px" class="input-style0" onchange="onOpmode()">
        <option value=0 selected >Query by subscriber</option>
        <option value=1>Query by operator</option>
        </select>
      </td>
      <td id="id_operator" style="display:none" width="60%">
      Operator name&nbsp;<input type="hidden" name="operator">
      <input type="text" name="dispoperator" value="<%= operator %>"  maxlength="20" class="input-style0" style="width:100px">
       &nbsp;SCP <select name="scp" size="1" class="input-style1" style="width:80px">
             <% out.print(optSCP); %>
      </td>
      <td id="id_usernumber" style="display:none" width="60%">
       The subscriber number &nbsp;
       <input type="text" name="usernumber" value="<%= usernumber %>"  maxlength="20" class="input-style0" style="width:120px">
      </td>
      </tr>

      <tr>
	  <td width="40%" height=30>
	  Operation type:<br>
	  <select name="opmode" style="width:180px" class="input-style0">
	  <option value="">All operations</option>
	  <option value="1">Order</option>
	  <% if(allowUp.equals("1")) { %>
	  <option value="2">Upload</option>
	  <option value="3">subscriber-record</option>
	  <% } %>
	  <option value="4">Presents</option>
	  <option value="5">Delete personal ringtone</option>
	  <option value="6">Delete ringtone to be verified</option>
      <option value="101">Set default ringtone</option>
      <option value="102">Set calling number</option>
      <option value="103">Remember ringtone</option>
      <option value="104">Time ringtone</option>
      <% if(isCombodia == "1"){%>
	  <option value="51">USSD</option>
      <%} 
      if(isSmart == "1"){%>
	  <option value="52">Modify password</option>
      <%}
      if(usecalling.equals("1"))
       {%>
	  <option value="105">RRBT Default Ring</option>
	  <option value="106">RRBT Others Ringtone</option>
	  <%}%>
	  </select></td>
       <td><input type="checkbox" name="checkTime" value="on"<%= checkflag ? " checked" : "" %>  onclick="onCheckTime()" >Period of time YYYY.MM.DD
     </td>
     </tr>
     <tr>
     <td width="40%"height=30 >
      Start time&nbsp;
      <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:120px">
     </td>
	 <td width="60%" >
      End time&nbsp;
      <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:120px">
      &nbsp;<img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
     </td>
     </tr>
     </table>
  </td>
  </tr>
  <tr>

   <%
        int  record = 0;
        for (int i = 0; i < pagecount; i++) {
          String pageid = "page_"+Integer.toString(i+1);
  %>

     <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
         <tr class="tr-ring">
          <td height="30" width="60">
              <div align="center">Ringtone code</div>
          </td>
          <td height="30" width="60">
              <div align="center">Ringtone name</div>
          </td>
          <td height="30" width="50">
              <div align="center">Price</div>
          </td>
          <td height="30" width="80">
              <div align="center">Operation type</div>
          </td>
          <td height="30" width="60">
              <div align="center">Operation time</div>
          </td>
           <td height="30" width="60">
              <div align="center">Multilateral interface</div>
          </td>
          <td height="30" width="60">
              <div align="center">Subscriber number</div>
          </td>
          <td height="30" width="60">
              <div align="center">Operation source</div>
          </td>
           <td height="30" width="150">
              <div align="center">Operation description</div>
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
               record = size ;
            else
               record = (i+1)*records;
            //System.out.println("record:"+record);
            for(int j=i*records;j<record;j++){
                String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                map = (HashMap)arraylist.get(j);
                out.print("<tr bgcolor=" +strcolor + " height=20>");
                out.print("<td >"+(String)map.get("ringid")+"</td>");
                out.print("<td >"+(String)map.get("ringname")+"</td>");
                out.print("<td align=right>"+(String)map.get("ringfee")+"</td>");
                out.print("<td align=center>"+(String)map.get("opertype")+"</td>");
                out.print("<td align=center>"+(String)map.get("opertime")+"</td>");
                out.print("<td align=center>"+(String)map.get("opermode")+"</td>");
                out.print("<td >"+(String)map.get("usernumber")+"</td>");
                out.print("<td >"+(String)map.get("opersource")+"</td>");
                out.print("<td >"+(String)map.get("description")+"</td>");
                out.print("</td></tr>");
      	    }
     // 	session.setAttribute("ResultSession",arraylist);
 %>
        <tr>
        <td width="100%" colspan="7">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td>Total:<%= arraylist.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s),&nbsp;&nbsp;Now on Page &nbsp;<%= i+1 %>&nbsp;</td>
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
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in querying ringtone!");//用户铃音操作查询过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in querying ringtone!");//用户铃音操作查询过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="quryUserOpera.jsp?type=<%=type%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
