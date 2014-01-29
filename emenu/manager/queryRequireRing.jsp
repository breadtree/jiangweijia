<%@page import="java.util.*"%>
<%@page import="zxyw50.manStat"%>
<%@page import="zxyw50.Purview"%>
<%@page import="zxyw50.require.RingRequireObj"%>
<%@page import="zxyw50.require.DefaultRequireContext"%>
<%@ page import="zxyw50.manSysPara"%>
<%@ page import="java.io.File"%>
<%@ page import="jxl.*"%>
<%@ page import="jxl.write.*"%>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%@include file="../pubfun/JavaFun.jsp"%>
<%
  response.addHeader("Cache-Control", "no-cache");
  response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
  String sysTime = "";
  String op=null;
  ArrayList result = null;
  Vector sysInfo = (Vector) application.getAttribute("SYSINFO");
  String operID = (String) session.getAttribute("OPERID");
  String operName = (String) session.getAttribute("OPERNAME");
  Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable) session.getAttribute("PURVIEW");
  
  //Added by Srinivas Rao K for Telenar 5.11.x
  int isMotenegro = zte.zxyw50.util.CrbtUtil.getConfig("isMotenegro",0);
  String display = "display:none";
  if( isMotenegro == 1)
	display = "display:block";
  //end of added
	
  try {
    ArrayList arraylist = null;
    HashMap map = new HashMap();
    String errmsg = "";
    boolean flag = true;
    zxyw50.Purview purview = new zxyw50.Purview();
    if (purviewList.get("4-16") == null || (!purview.CheckOperatorRightAllSerno(session, "4-16"))) {
          errmsg = "You have no right to access this function!";//You have no access to this function!
      flag = false;
    }
    if (operID == null) {
          errmsg = "Please log in first!";
      flag = false;
    }
    if (flag) {
      manStat manstat = new manStat();
      String ringlabel = "";
      String startday = "";
      String endday = "";
      String singername = "";
      String usenumber = null;
      String optSCP = "";
      op = request.getParameter("op") == null ? "" : ((String) request.getParameter("op")).trim();
      String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
      boolean checkflag = request.getParameter("checkTime") != null ? true : false;
      ringlabel = request.getParameter("ringlabel") == null ? "" : transferString((String) request.getParameter("ringlabel")).trim();
      singername = request.getParameter("singername") == null ? "" : transferString((String) request.getParameter("singername")).trim();
      String hringlabel = request.getParameter("hringlabel") == null ? "" : transferString((String) request.getParameter("hringlabel")).trim();
      String hsingername = request.getParameter("hsingername") == null ? "" : transferString((String) request.getParameter("hsingername")).trim();
      startday = request.getParameter("start") == null ? "" : ((String) request.getParameter("start")).trim();
      usenumber = request.getParameter("usenumber") == null ? "" : ((String) request.getParameter("usenumber")).trim();
      endday = request.getParameter("end") == null ? "" : ((String) request.getParameter("end")).trim();
      if (op.equals("search") || op.equals("bakdata")) {
        map.put("ringlabel", ringlabel);
        map.put("singername", singername);
        map.put("startday", startday);
        map.put("endday", endday);
         if(!scp.equals("")){
           map.put("scp",scp);
        arraylist = manstat.getReqRing(map);
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
              Label label = new Label(0, 0, "Registration date");
              sheet.addCell(label);
              label = new Label(1, 0, "Subscriber number");
              sheet.addCell(label);
              label = new Label(2, 0, "Song name");
              sheet.addCell(label);
              label = new Label(3, 0, "Singer name");
              sheet.addCell(label);
              label = new Label(4, 0, "Notes");
              sheet.addCell(label);
              for(int i=0;i<arraylist.size();i++){
               HashMap tmpMap = (HashMap) arraylist.get(i);
               label = new Label(0,i+1,(String)tmpMap.get("statdate"));
               sheet.addCell(label);
               label = new Label(1,i+1,tmpMap.get("usernumber").toString());
               sheet.addCell(label);
               label = new Label(2,i+1,tmpMap.get("ringlabel").toString());
               sheet.addCell(label);
               label = new Label(3,i+1,tmpMap.get("singername").toString());//strTmp.getBytes("ISO8859_1"), "GBK")
               sheet.addCell(label);
               label = new Label(4,i+1,(String)tmpMap.get("note"));
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
      //modified by zhengh 2005.07.11
      if(op.equals("del")){
          RingRequireObj obj = new RingRequireObj("",usenumber,hringlabel,hsingername,"Delete the duplicate user requirement");
          DefaultRequireContext drc = new DefaultRequireContext();
//          obj.setUsernumber(usenumber);
//          obj.setRingname(ringlabel);
//          obj.setRingauthor(singername);
//          obj.setNote("删除重复的用户需求");
          result = drc.modRequiredRing(obj,2);
          if(result != null && result.size()>0){
                session.setAttribute("rList",result);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="queryRequireRing.jsp">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
          if(getResultFlag(result)){
                   HashMap map1 = new HashMap();
                   map1.put("OPERID",operID);
                   map1.put("OPERNAME",operName);
                   map1.put("OPERTYPE","301");
                   map1.put("RESULT","1");
                   map.put("PARA1","ip:"+request.getRemoteAddr());
                   map1.put("DESCRIPTION","Delete subscriber's ringtone<br>requirements");
                   purview.writeLog(map1);
          }
      }
      if (op.equals("bakdata")) {
        response.setContentType("application/msexcel");
        String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "requireRing", XlsNameGenerate.STATISTIC_DAY);
        response.setHeader("Content-disposition","inline; filename=" + file_name);
        out.clear();
        out.println("<table border='1'>");
    	out.println("<tr><td>Registration date</td><td>Subscriber number</td><td>Song name</td><td>Singer name</td>");
    	if(isMotenegro == 1){
    	   out.println("<td>Notes</td>");
    	}
    	out.println("</tr>");
        for (int i = 0; i < arraylist.size(); i++) {
          map = (HashMap) arraylist.get(i);
          out.println("<tr><td>" + (String) map.get("statdate") + "</td><td>" + (String) map.get("usernumber") + "</td><td>" + displayRingName((String) map.get("ringlabel")) + "</td><td>" + displayRingAuthor((String) map.get("singername")) + "</td><td>" + displaySpName((String) map.get("note")) + "</td></tr>");
        }
        out.println("</table>");
        return;
      }
      int records = 20;
      int thepage = 0;
      int pagecount = 0;
      int size = 0;
      if (arraylist == null)
        size = -1;
      else
        size = arraylist.size();
      pagecount = size / records;
      if (size % records > 0)
        pagecount = pagecount + 1;
      if (pagecount == 0)
        pagecount = 1;
        manSysPara syspara = new manSysPara();
         ArrayList scplist = syspara.getScpList();
          for (int i = 0; i < scplist.size(); i++)
              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
%>
<html>
<head>
<title>Query the subscriber's ringtone requirements</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT><body background="background.gif" class="body-style1" onload="loadPage();">
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
      if (!CheckInputStr(fm.ringlabel,'Ringtone name')){
         fm.ringlabel.focus();
         return  flag;
      }
      if (!CheckInputStr(fm.singername,'Singer Name')){
         fm.singername.focus();
         return  flag;
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
/* <%// if(arraylist==null || arraylist.size()<1){ %>
      alert("No Stat.data for export!");
      return;
 <% //}else{%>
    parent.location.href="downloadPic.jsp?filename=tmp_<%//=operID%>.xls&filepath=<%//=application.getRealPath("temp").replace('\\','/')+"/"%>";
 */
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

  function delRing (usenumber,ringlabel,singername) {
     // if(confirm("您确认要删除此用户铃音需求吗？")){
      if(confirm("Are you sure to delete the subscriber's ringtone requirements?")){
          var fm = document.inputForm;
      }
      fm.usenumber.value = usenumber;
      fm.hringlabel.value = ringlabel;
      fm.hsingername.value = singername;
      fm.op.value = 'del';
      fm.target="_self";
      fm.submit();
  }

</script><form name="inputForm" method="post" action="queryRequireRing.jsp">
    <input type="hidden" name="pagecount" value="<%= pagecount %>">
    <input type="hidden" name="thepage" value="<%= thepage+1 %>">
    <input type="hidden" name="start" value="<%= startday + "" %>">
    <input type="hidden" name="end" value="<%= endday + "" %>">
    <input type="hidden" name="op" value="">
    <input type="hidden" name="usenumber" value="">
    <input type="hidden" name="hringlabel" value="">
    <input type="hidden" name="hsingername" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="750";
</script>    <table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2">
        <tr>
            <td height="26" align="center" class="text-title" background="image/n-9.gif">Query the subscriber's ringtone requirements</td>
        </tr>
        <tr>
   <td align="left" height="35">
      <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="90%"  align="center">
      <tr height=35>
      <td>
        Please select SCP&nbsp; <select name="scplist" size="1" class="input-style1">
              <% out.print(optSCP); %>
             </select>
      </td>
     </tr>
     </table>
  </td>
  </tr>
        <tr>
            <td align="center">
                <table border="0" cellspacing="0" cellpadding="0" class="table-style2" width="98%">
                    <tr>
                        <td width="40%">                Ringtone&nbsp;
                            &nbsp;
                            <input type="text" name="ringlabel" value="<%= ringlabel %>" maxlength="40" class="input-style0" style="width:120px">
                        </td>
                        <td width="60%">Singer
                            &nbsp;
                            <input type="text" name="singername" value="<%= singername %>" maxlength="40" class="input-style0" style="width:120px">
                            &nbsp;
                            <input type="checkbox" name="checkTime" value="on" onclick="onCheckTime()"
                              <% if(checkflag){
                                out.print(" checked ");
                              }%>
                              >
                           <span title="Time range(YYYY.MM.DD)">Time range</span>
                        </td>
                    </tr>
                    <tr>
     <td width="40%" >
      Start time&nbsp;
                            <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:100px">
                        </td>
	 <td width="40%" >
      End time&nbsp;
                            <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:100px">
                            &nbsp;
                            <img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()">
                            <img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
            <%
              int record = 0;
              for (int i = 0; i < pagecount; i++) {
                String pageid = "page_" + Integer.toString(i + 1);
            %>
                <table width="100%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style2" id="<%= pageid %>" style="display:none">
                    <tr class="tr-ring">
                        <td height="30" width="80">
              <div align="center">Registration date</div>
                        </td>
                        <td height="30" width="60">
              <div align="center">User number</div>
                        </td>
                        <td height="30" width="140">
                            <div align="center">Ringtone</div>
                        </td>
                        <td height="30" width="80">
                            <div align="center">Singer</div>
                        </td>
                        <td height="30" width="150" style="<%=display%>">
                          <div align="center">Notes</div>
                        </td>
                        <td height="30" width="40">
                            <div align="center">Del</div>
                        </td>
                       </tr>
                <%if (size == 0) {                %>
                    <tr>
                        <td align="center" colspan="10">No record matched the criteria</td>
                    </tr>
                <%
                  } else if (size > 0) {
                    if (i == (pagecount - 1))
                      record = size - (pagecount - 1) * records;
                    else
                      record = records;
                    for (int j = 0; j < record; j++) {
                      String strcolor = j % 2 == 0 ? "#FFFFFF" : "E6ECFF";
                      map = (HashMap) arraylist.get(i * records + j);
                      %>
                      <tr bgcolor=<%=strcolor%> height=20 >
                      <td align="center"><%=map.get("statdate").toString()%></td>
                      <td align="center"><%=map.get("usernumber").toString()%></td>
                      <td title='<%=map.get("ringlabel")%>' ><%=displayRingName(map.get("ringlabel").toString())%></td>
                      <td title='<%=map.get("singername")%>' ><%=displayRingAuthor(map.get("singername").toString())%></td>
                      <td title='<%=map.get("note")%>' style="<%=display%>"><%=map.get("note").toString()%></td>
                      <td align="center"><img src="../image/delete.gif" alt="Del" width=15 height=15 onMouseOver="this.style.cursor='hand'" onClick="javascript:delRing('<%=map.get("usernumber").toString()%>','<%=(map.get("ringlabel").toString())%>','<%=displayRingAuthor(map.get("singername").toString())%>')"></td>
                      </td></tr>
                      <%
                    }
                //    session.setAttribute("ResultSession", arraylist);
                %>

<%
         if (arraylist.size() > records) {
%>
                    <tr>
                        <td width="100%" colspan="7">
                            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
                                <tr>
              <td>Total:<%= arraylist.size() %>&nbsp;,<%= pagecount %>page(s)&nbsp;&nbsp;now on page &nbsp;<%= i+1 %>&nbsp;</td>
              <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()"></td>
                                    <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>></td>
                                    <td><img src="button/nextpage.gif" <%= i * records + records >= arraylist.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %>></td>
                                    <td>
                                        <img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage()">
                                    </td>
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
<script language="javascript">
   var sTmp = "<%=  singername  %>";
   if(sTmp!='')
     document.forms[0].singername.value = sTmp;
</script></form>
<%} else {%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   document.URL = 'enter.jsp';
</script><%
  }
  } catch (Exception e) {
    Vector vet = new Vector();
    sysInfo.add(sysTime + operName + " Exception occurred in querying ringtone requirements!");
    sysInfo.add(sysTime + operName + e.toString());
    if(op.equals("del")){
        vet.add("Error occurred in deleteing ringtone requirements!");
    }else{
        vet.add("Error occurred in querying ringtone requirements!");
    }

    vet.add(e.getMessage());
    session.setAttribute("ERRORMESSAGE", vet);
%>
<form name="errorForm" method="post" action="error.jsp">
    <input type="hidden" name="historyURL" value="queryRequireRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script><%}%>
</body>
</html>

