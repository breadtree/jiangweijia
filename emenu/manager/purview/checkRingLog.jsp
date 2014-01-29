<%@ page import="java.util.*" %>

<%@ include file="../../pubfun/JavaFun.jsp" %>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Search log of verification ringtone's result</title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
<body class="body-style1" onload="loadPage();" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
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
        HashMap   map  = new HashMap();
        String    errmsg = "";
        String    queryType = "";
        int       queryMode = 0;
        boolean   flag =true;
        String searchvalue = request.getParameter("searchvalue") == null ? "-1" : transferString((String)request.getParameter("searchvalue"));
        String searchkey = request.getParameter("searchkey") == null ? "" : (String)request.getParameter("searchkey");
        if (purviewList.get("6-8") == null) {
          errmsg = "You have no right to access this function!";
          flag = false;
       }
       if (operID  == null){
          errmsg = "Please log in first!";
          flag = false;
       }
       if(flag){
          manStat  manstat = new manStat();
          String   opertype = "";
          String   operresult = "";
          String   startday = "";
          String   endday = "";
          String   opcode = "";
          String   opmode = "";
          String   scp = "";
          String   op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          String   operator = request.getParameter("operator") == null ? "" : transferString((String)request.getParameter("operator"));
          if(operator.equals(""))
             operator = operID;
          if(op.equals("search")){
             operresult  =  request.getParameter("operresult") == null ? "" : ((String)request.getParameter("operresult")).trim();
             opertype = request.getParameter("opertype") == null ? "" : ((String)request.getParameter("opertype")).trim();
             startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
             endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();

             map.put("operator",operator);
             map.put("opertype",opertype);
             map.put("starttime",startday);
             map.put("endtime",endday);
             map.put("operator",operator);
             map.put("operresult",operresult);
             map.put("searchvalue",searchvalue);
             map.put("searchkey",searchkey);
             arraylist = purview.getCheckRingLog(map);
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
          //查询该操作员的所有子操作员
          ArrayList operList = null;
          operList = purview.sortChildOperators(operID);
          HashMap paraMap = null;
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
     var operresult = "<%= operresult %>";
     fm.operresult.value = operresult;
     var  startday = "<%= startday %>";
     if(startday=='')
        startday = sStartDate;
     fm.startday.value = startday;
     var  endday = "<%= endday %>";
     if(endday=='')
        endday = getCurrentDate();
      fm.endday.value = endday;
     if ('<%= searchkey %>' != '-1')
      fm.searchkey.value = '<%= searchkey %>';
      }

   function searchInfo () {
      var fm = document.forms[0];
      if (! checkInfo())
         return;
      fm.op.value = 'search';
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
         alert("Please select the operator to search!");
         return false;
      }
      var value = trim(fm.startday.value);
      if(value==''){
          alert("Please enter the start date which is format by yyyy.mm.dd!");
          fm.startday.focus();
          return false;
      }
      if (! checkDate2(value)) {
           alert("Please enter the correct start time.\r\nThe correct format is YYYY.MM.DD");
           fm.startday.focus();
           return false;
      }
      var sStartDate = getMonthPriorDate(2);
      var tmp1 = sStartDate.substring(0,4) + sStartDate.substring(5,7) + sStartDate.substring(8,10);
      var tmp2 = value.substring(0,4) + value.substring(5,7) + value.substring(8,10);
      if(tmp1 > tmp2 )
      {
         alert("Sorry, you only can search the result after the day of " + sStartDate + ", please re-enter!" );
         fm.startday.focus();
         return false;
      }
      value = trim(fm.endday.value);
      if(value==''){
           alert("Please enter the end date which is format by yyyy.mm.dd!");
           fm.endday.focus();
           return false;
       }
       if (! checkDate2(value)) {
           alert("Please enter the correct end time.\r\nThe correct format is YYYY.MM.DD");
           fm.endday.focus();
           return false;
       }
       if(!checktrue2(value)){
           alert("The end date cannot be earlier than the present date!");//结束日期不能小于当前日期
           fm.endday.focus();
           return false;
       }
       if (! compareDate2(fm.startday.value,fm.endday.value)) {
            alert("The start date cannot be later than the end date!");//起始日期不能比结束日期晚
            fm.endday.focus();
            return false;
       }

       return true;
   }
</script>
<form name="inputForm" method="post" action="checkRingLog.jsp">
<input type="hidden" name="operflag" value="<%= operflag %>">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="880";
</script>
  <table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
          <td height="50"  align="center" class="text-title">Search log of verification <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>'s result</td>
   </tr>
   <tr>
   <td align="center">
     <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="98%">
     <tr>
     <td  height=30 colspan=2 >
        Operator&nbsp;
        <select name="operator" style="width:120px" class="input-style0" >
        <%
          if(operName.trim().equalsIgnoreCase("super"))
          {%>
        out.println("<option value="-1" >--All Operators--</option>");
        <%}
         for (int i = 0; i < operList.size(); i++) {
            map = (HashMap)operList.get(i);
            out.println("<option value=" + (String)map.get("OPERID") + " >" + (String)map.get("OPERNAME") + "</option>");
        }
        %>
        </select>
     </td>
     <tr>
        <td width="50%" height=30> Type of verification&nbsp;<br/>
              <select name="opertype" style="width:250px" class="input-style0">
                <option value="" >All type of verification <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></option>
                <option value="1" >System verification <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></option>
                <option value="2" >System batch verification <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></option>
               <% if(ismanualsvc.equals("1")) { %>  <option value="3" >Personal verification <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></option> <% } %>
               <% if(isgroup.equals("1")) { %>  <option value="4" >Group verification <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></option> <% } %>
              </select>
          </td>
         <td width="50%" height=30> Result&nbsp;
              <select name="operresult" style="width:150px" class="input-style0">
                <option value="" >Pass/Refuse</option>
                <option value="1" >Pass</option>
                <option value="2" >Refuse</option>
         </select>
        </td>
      </tr>
     <tr>
        <td height=30 width="30%">Query condition&nbsp;
          <select name="searchkey" style="width:150px" class="input-style0">
                <option value="para3" >Name of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></option>
                <option value="para4" >Content Provider</option>
          </select>
        </td>
        <td>
          Keyword<input type="text" name="searchvalue" <%if(!"-1".equals(searchvalue)){%>value="<%=(searchkey.equals("sp")?"":searchvalue)%>"<%}%>>
        </td>
      </tr>
     <tr>
     <td width="40%" height=30>
      Start date&nbsp;
      <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:120px">
     </td>
	 <td width="60%" >
      End date&nbsp;
      <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:150px">
      &nbsp;<img border="0" src="../button/search.gif" onmouseover="this.style.cursor='pointer'" onclick="javascript:searchInfo()">
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
           <td height="30" width="60">
              <div align="center">Operation time</div>
          </td>
          <td height="30" width="80">
              <div align="center">Verification type</div>
          </td>
          <td height="30" width="80">
              <div align="center">Result</div>
          </td>
          <td height="30" width="60">
              <div align="center">Code of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></div>
          <td height="30" width="80">
              <div align="center"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%> of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></div>
          </td>
          <td height="30" width="80">
              <div align="center">Content Provider</div>
          </td>
          <td height="30" width="120">
              <div align="center">Reason of refuse</div>
          </td>
        </tr>

 <%
   			if(size==0){
			%>
			<tr><td class="table-style2" align="center" colspan="10">No log match the contdition!</td>
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
                out.print("<td align=center  >"+(String)map.get("opertime")+"</td>");
                out.print("<td align=center>"+(String)map.get("opertypename")+"</td>");
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
              <td>Total:&nbsp;<%= arraylist.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;Page(s),&nbsp;&nbsp;Now on page&nbsp;<%= i+1 %>&nbsp;</td>
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
                    alert( "Please log in first!");
                    document.location.href = '../enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no right to access this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in searching log of verification's result!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Errors occurred in searching log of verification's result!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="purview/checkRingLog.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
