<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="zxyw50.manStatUser"%>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="java.io.File"%>
<%@ page import="jxl.*"%>
<%@ page import="jxl.write.*"%>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        ArrayList arraylist = null;
        ArrayList opermodelist = null;
        HashMap   map  = new HashMap();
        String    errmsg = "";
        String    queryType = "";
        int       queryMode = 0;
        boolean   flag =true;
        Calendar showdate = Calendar.getInstance();
        showdate.add(Calendar.DATE ,-7);
        SimpleDateFormat formate = new SimpleDateFormat("yyyy.MM.dd");
        String qrydate = formate.format(showdate.getTime());

	zxyw50.Purview purview = new zxyw50.Purview();
        if (purviewList.get("4-34") == null ) {
          errmsg = "You have no access to this function!";//You have no access to this function
          flag = false;
         }
       if (operID  == null){
          errmsg = "Please log in first!";//Please log in to the system
          flag = false;
       }
       if(flag){
          String startday = qrydate;
          Hashtable hash = null;
          String  optSCP = "";
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
          manStatUser statuser = new manStatUser();
          String  total ="";
          if(op.equals("search") || op.equals("bakdata")){
             startday = request.getParameter("start") == null ? qrydate : ((String)request.getParameter("start")).trim();
             map.put("scp",scp);
             map.put("startday",startday);
             map.put("stattype","2");

             arraylist = statuser.artistOrderStat(map);

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
              Label label = new Label(0, 0, "Numbers of purchases in the week");
              sheet.addCell(label);
              label = new Label(1, 0, "Under Singer of");
              sheet.addCell(label);
              for(int i=0;i<arraylist.size();i++){
               HashMap tmpMap = (HashMap) arraylist.get(i);
               label = new Label(0,i+1,(String)tmpMap.get("buytimes"));
               sheet.addCell(label);
               label = new Label(1,i+1,tmpMap.get("singgername").toString());
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
		String file_name = XlsNameGenerate.get_xls_filename(startday, startday, "artistOrderStat", XlsNameGenerate.STATISTIC_DAY);
        response.setHeader("Content-disposition","inline; filename=" + file_name);
             	out.clear();
             	out.println("<table border='1'>");
    		out.println("<tr><td>Numbers of purchases in the week</td><td>Under Singer of</td></tr>");
            	for (int i = 0; i <arraylist.size(); i++) {
                  map = (HashMap)arraylist.get(i);
                  out.print("<tr><td align=left>"+(String)map.get("buytimes")+"</td>");
                  out.print("<td align=left>"+(String)map.get("singgername")+"</td></tr>");
               	}
               	out.println("</table>");
        	return;
      	  }
          int thepage = 0 ;
          int pagecount = 0;
          int size=0;
          if(arraylist==null)
             size =-1;
          else
             size = arraylist.size();
          pagecount = size/15;
          if(size%15>0)
             pagecount = pagecount + 1;
          if(pagecount==0)
             pagecount = 1;
          ArrayList scplist = statuser.getScpList();
          for (int i = 0; i < scplist.size(); i++)
              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
 %>

<html>
<head>
<title>Artist's Orders Statistic Weekly</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<body background="background.gif" class="body-style1" onload="loadpage(document.forms[0])" >

<script language="javascript">

   function loadpage(pform){
      firstPage();
      var temp = "<%= scp %>";
      for(var i=0; i<pform.scplist.length; i++){
        if(pform.scplist.options[i].value == temp){
           pform.scplist.selectedIndex = i;
           break;
        }
     }
   }


   function checkInfo () {
      var fm = document.inputForm;
      var tmp = '';
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

         fm.start.value = tmp = trim(fm.startday.value);

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
 if (! checkInfo())
         return;
  //    parent.location.href="downloadPic.jsp?filename=tmp_<//%=operID%>.xls&filepath=<//%=application.getRealPath("temp").replace('\\','/')+"/"%>";
      var fm = document.inputForm;
      fm.op.value = 'bakdata';
      fm.target="top";
      fm.submit();
   }
   function onpage(num){
      var obj  = eval("page_" + num);
  	  obj.style.display="block";
  	  document.forms[0].thepage.value = num;
  }

   function offpage(num){
  	var obj  = eval("page_" + num);
  	obj.style.display="none";
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
<form name="inputForm" method="post" action="artistOrderStat.jsp">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="start" value="<%= startday + "" %>">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="900";
</script>
  <table border="0" width="98%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
          <td height="26"  align="center" class="text-title">Artist's Orders Statistic Weekly</td>
   </tr>

   <tr>
   <td align="center">
      <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="93%"  align="center">
      <tr height=35>
      <td>
        SCP List&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <select name="scplist" size="1" class="input-style2">
              <% out.print(optSCP); %>
          </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
       Date
      <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:100px">&nbsp;
          <img border="0" src="button/search.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:searchInfo()">&nbsp;
          <img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
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

     <table width="95%" border="0" cellspacing="1" cellpadding="2" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
         <tr class="table-title1" align="center">
           <td height="30" width="12%" align="center">
              Numbers of purchases in the week
          </td>
          <td height="30" width="16%" align="center" >
             Under Singer of
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
               record = (i+1)*15;;
            for(int j=i*15;j<record;j++){
                String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                map = (HashMap)arraylist.get(j);
                out.print("<tr bgcolor=" +strcolor + ">");
                out.print("<td align=left>"+(String)map.get("buytimes")+"</td>");
                out.print("<td align=left>"+(String)map.get("singgername")+"</td>");
                out.print("</td></tr>");
      }
         //   session.setAttribute("ResultSession",arraylist);

 %>

<%
         if (arraylist.size() > 15) {
%>
        <tr>
        <td width="100%" colspan="10">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td>&nbsp;Total:<%= arraylist.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s),&nbsp;Now on Page &nbsp;<%= i+1 %>&nbsp;</td>
              <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()"></td>
              <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>></td>
              <td><img src="button/nextpage.gif" <%= i * 15 + 15 >= arraylist.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %>></td>
              <td><img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage()"></td>
            </tr>
          </table>
        </td>
      </tr>
   </table>
<%                             }%>

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
        sysInfo.add(sysTime + operName + " Exception occurred in Artist's Orders Statistic Weekly");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in Artist's Orders Statistic Weekly");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="artistOrderStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
