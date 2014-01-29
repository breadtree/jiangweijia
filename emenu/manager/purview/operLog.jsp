<%@ page import="java.util.*" %>
<%@ include file="../../pubfun/JavaFun.jsp" %>
<%@ page import="zte.zxyw50.util.CrbtUtil" %>
<%@page import="zte.zxyw50.util.JCalendar"%>
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
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String sEdit=request.getParameter("isedit")==null?"":(String)request.getParameter("isedit");
%>
<html>
<head>
<title>Operator log</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<link href="../../css/start/jquery-ui-1.7.3.custom.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../js/jquery.min.js"></script>
<script type="text/javascript" src="../../js/jquery-ui.min.js"></script>
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../../base/JsFun.js"></SCRIPT>
<%if(isfarsicalendar == 1){ %>
<script type="text/javascript" src="../../js/jalaliCalendar.js"></script>
<script type="text/javascript" src="../../js/ui.datepicker-fa.js"></script>
<script type="text/javascript" src="../../js/jalali.js"></script>
<%} %>
<script type="text/javascript">
var isfarsicalendar = '<%=isfarsicalendar%>';
 $(function(){
	if(isfarsicalendar == "1"){
		 $.datepicker.setDefaults($.datepicker.regional['fa']) ;	
	}else{
	$.datepicker.setDefaults($.datepicker.regional['']) ;	
	}
	
	var dates = $('.datefrom, .dateto').datepicker({
		changeMonth: true,
		changeYear: true,
		numberOfMonths: 1,
		dateFormat: 'yy.mm.dd',
		firstDay: '0',
		maxDate:'today',
		minDate: '-3m',
		showAnim:'fadeIn',
		onSelect: function(selectedDate) {
			var option = this.className == "datefrom hasDatepicker" ? "minDate" : "maxDate";
			var instance = $(this).data("datepicker");
			var date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
			dates.not(this).datepicker("option", option, date);
		}
	});
	});
</script>
</head>
<body class="body-style1" onload="loadPage();" >
<%
    String sysTime = "";
    Vector sysInfo = new Vector();
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String isgroup = (String)application.getAttribute("ISGROUP")==null?"0":(String)application.getAttribute("ISGROUP");
    String ismanualsvc = (String)application.getAttribute("ISMANUALSVC")==null?"0":(String)application.getAttribute("ISMANUALSVC");
    //operflag: 管理员类型( 0: 系统管理员 1: SP管理员 2:集团管理员 3:开销户系统管理员)
    String operflag = request.getParameter("operflag") == null ? "0" : ((String)request.getParameter("operflag")).trim();
    try {
        ArrayList arraylist = null;
        ArrayList opcodelist = null;
        HashMap  map  = new HashMap();
        String    errmsg = "";
        String    queryType = "";
        int       queryMode = 0;
        boolean   flag =true;
        if("2".equals(operflag)){
          if (purviewList.get("12-5") == null){
            errmsg = "You have no right to access this function!";
            flag = false;
          }
        }
        else if("1".equals(operflag)){
          if (purviewList.get("9-6") == null){
            errmsg = "You have no right to access this function!";
            flag = false;
          }
        }
     // Added for ccs module
	else if("5".equals(operflag)){
          if (purviewList.get("16-20") == null){
            errmsg = "You have no right to access this function!";
            flag = false;
          }
        }
        else if (purviewList.get("5-5") == null) {
          errmsg = "You have no right to access this function!";
          flag = false;
       }
       if (operID  == null){
          errmsg = "Please log in first!";
          flag = false;
       }
       if(flag){
          
          String   opertype = "";
          String   startDay = "";
          String   endDay = "";
          String   opcode = "";
          String   opmode = "";
          String   scp = "";
          String   op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          boolean  checkflag = request.getParameter("checkTime") != null ? true : false;
          String   operator = request.getParameter("operator") == null ? "" : transferString((String)request.getParameter("operator"));
          opertype = request.getParameter("opertype") == null ? "" : ((String)request.getParameter("opertype")).trim();
          startDay = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
          endDay = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
          HashMap  newmap  = new HashMap();
          newmap.put("operflag",operflag);
          newmap.put("manualflag",ismanualsvc);
          newmap.put("groupflag",isgroup);
      // Added for ccs module
	  if("5".equals(operflag))
	    {
          opcodelist = purview.getOperTypeForCCS(newmap);
	    }
	 else
	 {
          opcodelist = purview.getOperType(newmap);
	 }
          //查询该操作员的所有子操作员
          ArrayList operList = null;
          operList = purview.sortChildOperators(operID);

           HashMap paraMap = null;
          if(!opertype.equals(""))
             paraMap = purview.getOperTypePara(Integer.parseInt(opertype));

          if(operator.equals(""))
             operator = operID;

          if(op.equals("search")||op.equals("bakdata")){

             map  = new HashMap();
             map.put("operator",operator);
             map.put("opertype",opertype);
             map.put("starttime",ParsiToEng(startDay));
             map.put("endtime",ParsiToEng(endDay));
             map.put("operator",operator);
             map.put("operflag",operflag);
             map.put("manualflag",ismanualsvc);
             map.put("groupflag",isgroup);
		 // Added for ccs module
	    if("5".equals(operflag))
		{
             arraylist = purview.getOperLogForCCS(map);
		}
	     else
	       {
             arraylist = purview.getOperLog(map);
          }

          if(op.equals("bakdata")){

                  String opertypename = "";

                  if(opertype.equals(""))
                  {
                  opertypename="All operations";
                  }
                  else
                  {
                  for(int i =0; i<opcodelist.size();i++)
                  {
                   HashMap opermap = new HashMap();
                   opermap = (HashMap) opcodelist.get(i);
                   if(opermap.get("opertype").equals(opertype))
                   {
                   opertypename = (String)opermap.get("opertypename");
                   break;
                   }
                  }
                  }

                  String opername ="";
                  for(int i =0; i<operList.size();i++)
                  {
                   HashMap opermap = new HashMap();
                   opermap = (HashMap) operList.get(i);
                   if(opermap.get("OPERID").equals(operator))
                   {
                   opername = (String)opermap.get("OPERNAME");
                   break;
                   }
                  }

                  if(opername.startsWith("*"))
                  {
                   opername=opername.substring(1);
                  }
                  String file_name = opername+"_"+opertypename+"_"+startDay+"_"+endDay+".xls";
                  response.setContentType("application/msexcel");
                  response.setHeader("Content-disposition","inline; filename=" + file_name);
                  out.clear();
                  out.println("<table border='1'>");
                  out.println("<tr><td>Operation time</td><td>Operation type</td><td>Result</td>");
                  if(opertype.equals(""))
                  {
                  out.println("<td >Param1</td>");
                  out.println("<td >Param2</td>");
                  out.println("<td >Param3</td>");
                  out.println("<td >Param4</td>");
                  }
                  else
                  {
                   out.println("<td >"+(String)paraMap.get("para1name")+"</td>");
                   out.println("<td >"+(String)paraMap.get("para2name")+"</td>");
                   out.println("<td >"+(String)paraMap.get("para3name")+"</td>");
                   out.println("<td >"+(String)paraMap.get("para4name")+"</td>");
                  }
                  out.println("<td>Remark</td></tr>");

                  String tdInformat = "<td align='center' style='mso-number-format:\"\\@\"'>";
                  for (int i = 0; i <arraylist.size(); i++) {
                    map = (HashMap)arraylist.get(i);
                out.print("<tr><td align=center>"+jcalendar((String)map.get("opertime"))+"</td>");
                out.print("<td align=center>"+(String)map.get("opertypename")+"</td>");
                out.print("<td align=center>"+(String)map.get("result")+"</td>");
                out.print("<td >"+(String)map.get("para1")+"</td>");
                out.print("<td >"+(String)map.get("para2")+"</td>");
                out.print("<td >"+(String)map.get("para3")+"</td>");
                out.print("<td >"+(String)map.get("para4")+"</td>");
                out.print("<td >"+(String)map.get("desc")+"</td>");
                out.println("</tr>");
                  }
                  out.println("</table>");
                  return;
                }

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

<script language="javascript">

   function loadPage(){
     var sStartDate = getMonthPriorDate(2);
     var fm = document.forms[0];
     firstPage();
     var sTmp = "<%=  operator  %>";
     if(sTmp!='')
         document.forms[0].operator.value = sTmp;
     var opertype = "<%= opertype %>";
     fm.opertype.value = opertype;
     var  startday = "<%= startDay %>";
     fm.startday.value = startday;
     var  endday = "<%= endDay %>";
      fm.endday.value = endday;
   }

   function onCheckTime(){
	      var fm = document.inputForm;
	      if (fm.checkTime.checked) {
	        $('.datefrom').attr('disabled','');   
	        $('.dateto').attr('disabled',''); 
	        fm.endday.value = getCurrentDate();
	        fm.startday.value = getMonthPriorDate(2);
	      }
	      else{
	         fm.start.value = "0";
	         fm.end.value = "0";
	         fm.startday.value = "";
	         fm.endday.value = "";
	         $('.datefrom').attr('disabled','disabled');   
	         $('.dateto').attr('disabled','disabled');
	      }
	      return;
   }

   function searchInfo () {
      var fm = document.forms[0];
      if (! checkInfo())
         return;
      fm.op.value = 'search';
      fm.target="_self";
      fm.submit();
   }

  function WriteDataInExcel(){
    if (!checkInfo())
      return;

      var fm = document.forms[0];
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

  function checkInfo () {
      var fm = document.forms[0];
      // 检查起始时间
      if (fm.operator.selectedIndex == -1 ) {
         alert("Please select the operator who you want to query!");
         return false;
      }
      var value = trim(fm.startday.value);
      if(value==''){
          alert("Please enter the begin date. ");
          fm.startday.focus();
          return false;
      }
      if (! checkDate2(value)) {
           alert("Please enter the correct date time. \r\nThe correct date format is YYYY.MM.DD");
           fm.startday.focus();
           return false;
      }

      value = trim(fm.endday.value);
      if(value==''){
           alert("Please enter the end date");
           fm.endday.focus();
           return false;
       }
       if (! checkDate2(value)) {
           alert("Please enter the correct end date");
           fm.endday.focus();
           return false;
       }
       if(!checktrue2(value)){
           alert("End date should not be later than current date! ");
           fm.endday.focus();
           return false;
       }
       if (! compareDate2(fm.startday.value,fm.endday.value)) {
            alert("Start date should be prior to the end date!");//起始时间应在结束时间之前
            fm.endday.focus();
            return false;
       }

       return true;
   }


</script>
<form name="inputForm" method="post" action="operLog.jsp">
<input type="hidden" name="operflag" value="<%= operflag %>">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="1280";
</script>
  <table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
          <td height="50"  align="center" class="text-title">Query log of operator</td>
   </tr>
   <tr>
   <td align="center">
     <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="100%">
     <tr>
     <td width="40%" height=30>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Operator
        <select name="operator" style="width:120px" class="input-style0" >
        <%
         for (int i = 0; i < operList.size(); i++) {
            map = (HashMap)operList.get(i);
            out.println("<option value=" + (String)map.get("OPERID") + " >" + (String)map.get("OPERNAME") + "</option>");
        }
        %>
        </select>
     </td>
	        <td width="60%" height=30> Operation&nbsp;
              <select name="opertype" style="width:270px" class="input-style0">
                <option value="">All operations</option>
      <%
	     for(int j=0; j<opcodelist.size();j++){
	       map = (HashMap)opcodelist.get(j);
	       out.println("<option value="+(String)map.get("opertype") + " >" + (String)map.get("opertypename") + "</option>");
	     }
	  %>
              </select>
            </td>
      </tr>
     <tr>
     <td width="40%" height=30>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Begin date&nbsp;
       <input type="text" size="11" name="startday" value="<%=startDay%>" maxlength="10" class="datefrom"  readonly >
     </td>
	 <td width="60%" >
      End date&nbsp;&nbsp;&nbsp;
      <input type="text" size="11" name="endday" value="<%=endDay%>" maxlength="10" class="dateto"  readonly >
      &nbsp;<img border="0" src="../button/search.gif" onmouseover="this.style.cursor='pointer'" onclick="javascript:searchInfo()">
        <img border="0" src="../button/daochu.gif" onmouseover="this.style.cursor='pointer'" onclick="javascript:WriteDataInExcel()">
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

     <table width="95%" border="0" cellspacing="1" cellpadding="1" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
         <tr class="table-title1">
           <td height="30" width="12%">
              <div align="center">Operation time</div>
          </td>
          <td height="30" width="15%">
              <div align="center">Operation type</div>
          </td>
          <td height="30" width="10%">
              <div align="center">Result</div>
          </td>
          <td height="30" width="12%" >
              <div align="center"><%= opertype.equals("")?"Param1":(String)paraMap.get("para1name") %></div>
          </td>
          <td height="30" width="12%">
              <div align="center"><%= opertype.equals("")?"Param2":(String)paraMap.get("para2name") %></div>
           <td height="30" width="12%">
              <div align="center"><%= opertype.equals("")?"Param3":(String)paraMap.get("para3name") %></div>
          </td>
		   <td height="30" width="12%">
              <div align="center"><%= opertype.equals("")?"Param4":(String)paraMap.get("para4name") %></div>
          </td>
          <td height="30" width="15%">
              <div align="center">Remark</div>
          </td>
        </tr>

 <%
   			if(size==0){
			%>
			<tr><td align="center" colspan="10">Sorry, no records match the search criteria!</td>
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
                out.print("<tr bgcolor=" +strcolor + " height=23 >");
                out.print("<td align=center  >"+jcalendar((String)map.get("opertime"))+"</td>");
                out.print("<td align=center>"+(String)map.get("opertypename")+"</td>");
                out.print("<td align=center>"+(String)map.get("result")+"</td>");
                out.print("<td >"+(String)map.get("para1")+"</td>");
                out.print("<td >"+(String)map.get("para2")+"</td>");
                out.print("<td >"+(String)map.get("para3")+"</td>");
                out.print("<td >"+(String)map.get("para4")+"</td>");
                out.print("<td >"+(String)map.get("desc")+"</td>");
                out.print("</td></tr>");
      }
 %>
        <tr>
        <td width="100%" colspan="8">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td>&nbsp;Total:<%= arraylist.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s),&nbsp;&nbsp;Now on page &nbsp;<%= i+1 %>&nbsp;</td>
              <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='pointer'" onclick="javascript:firstPage()"></td>
              <td><img src="../button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='pointer'\" onclick=\"javascript:toPage(-1)\"" %>></td>
              <td><img src="../button/nextpage.gif" <%= i * records + records >= arraylist.size() ? "" : " onmouseover=\"this.style.cursor='pointer'\" onclick=\"javascript:toPage(1)\"" %>></td>
              <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='pointer'" onclick="javascript:endPage()"></td>
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
             if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.location.href = '../enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in searching log of operator!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Errors occurred in searching log of operator!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="purview/operLog.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
