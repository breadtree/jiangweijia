<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="zxyw50.manStatUser"%>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="java.io.File"%>
<%@ page import="jxl.*"%>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%@ page import="jxl.write.*"%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");
    String giftbag   = CrbtUtil.getConfig("giftname","giftbag");
    try {
        ArrayList arraylist = null;
        ArrayList opermodelist = null;
        HashMap   map  = new HashMap();
        String    errmsg = "";
        String    queryType = "";
        int       queryMode = 0;
        boolean   flag =true;
        Calendar showdate = Calendar.getInstance();
        showdate.add(Calendar.MONTH,-1);
        SimpleDateFormat formate = new SimpleDateFormat("yyyy.MM");
        String qrydate = formate.format(showdate.getTime())+".01";

	zxyw50.Purview purview = new zxyw50.Purview();
        if (purviewList.get("4-31") == null ) {
          errmsg = "You have no access to this function!";//You have no access to this function
          flag = false;
         }
       if (operID  == null){
          errmsg = "Please log in first!";//Please log in to the system
          flag = false;
       }
       if(flag){
          String startday = qrydate;
          String endday = qrydate;
             String usertype =null;
             String stattype =null;
             String opertype =null;
             String spindex  =null;
          Hashtable hash = null;
          String  optSCP = "";
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
          manStatUser statuser = new manStatUser();
          String  total ="";
          if(op.equals("search") || op.equals("bakdata")){
             startday = request.getParameter("start") == null ? qrydate : ((String)request.getParameter("start")).trim();
             endday = request.getParameter("end") == null ? qrydate : ((String)request.getParameter("end")).trim();
             usertype = request.getParameter("usertype") == null ? "" : ((String)request.getParameter("usertype")).trim();
             stattype = request.getParameter("stattype") == null ? "" : ((String)request.getParameter("stattype")).trim();
             opertype = request.getParameter("opertype") == null ? "" : ((String)request.getParameter("opertype")).trim();
             spindex  = request.getParameter("spindex") == null ? "" : ((String)request.getParameter("spindex")).trim();
             map.put("scp",scp);
             map.put("startday",startday);
             map.put("endday",endday);
             map.put("usertype",usertype);
             map.put("stattype",stattype);
             map.put("opertype",opertype);
             map.put("spindex",spindex);
             arraylist = statuser.sysRingContentStat(map);
            //write Excel File, the temp file use the same file,here wo think concurrent is a little probability
            /*try{
              String filename = application.getRealPath("temp")+"/tmp_"+operID+".xls";
              System.out.println("1111111111  filename="+filename);
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
              Label label = new Label(0, 0, "Subs Type");
              sheet.addCell(label);
              label = new Label(1, 0, "Time Period");
              sheet.addCell(label);
              label = new Label(2, 0, "Supplier");
              sheet.addCell(label);
              label = new Label(3, 0, "Artiste Name");
              sheet.addCell(label);
              label = new Label(4, 0, "Transaction Type");
              sheet.addCell(label);
              label = new Label(5, 0, "Nr. Of Purchase");
              sheet.addCell(label);
              label = new Label(6, 0, "Nr. Of Gift");
              sheet.addCell(label);
              label = new Label(7, 0, "Amount");
              sheet.addCell(label);
              for(int i=0;i<arraylist.size();i++){
               HashMap tmpMap = (HashMap) arraylist.get(i);
               label = new Label(0,i+1,(String)tmpMap.get("usernettype"));
               sheet.addCell(label);
               label = new Label(1,i+1,tmpMap.get("statstartdate").toString()+"--"+tmpMap.get("statenddate").toString());
               sheet.addCell(label);
               label = new Label(2,i+1,tmpMap.get("spname").toString());
               sheet.addCell(label);
               label = new Label(3,i+1,tmpMap.get("ringlabel").toString());
               sheet.addCell(label);
               String strOpertype = tmpMap.get("opertype").toString().trim();
               if(strOpertype.equals("2"))
                    strOpertype=musicbox;
               else if(strOpertype.equals("3"))
                    strOpertype=giftbag;
               label = new Label(4,i+1,strOpertype);
               sheet.addCell(label);
               label = new Label(5,i+1,tmpMap.get("buytimes").toString());
               sheet.addCell(label);
               label = new Label(6,i+1,tmpMap.get("largesstimes").toString());
               sheet.addCell(label);
               label = new Label(7,i+1,tmpMap.get("totalfee").toString());
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
             response.setContentType("application/msexcel;charset=gb2312");
             String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "contentStat", XlsNameGenerate.STATISTIC_DAY);
             response.setHeader("Content-disposition","inline; filename=" + file_name);
             	out.clear();
             	out.println("<table border='1'>");
    		out.println("<tr><td>Subs Type</td><td>Time Period</td><td>Supplier</td>");
                out.println("<td>Artiste Name</td><td>Transaction Type</td>");
                out.println("<td>Nr. Of Purchase</td><td>Nr. Of Gift</td><td>Amount</td></tr>");
            	for (int i = 0; i <arraylist.size(); i++) {
                  map = (HashMap)arraylist.get(i);
                  out.println("<tr><td>"+(String)map.get("usernettype")+"</td><td>"+(String)map.get("statstartdate")+ "--"+(String)map.get("statenddate")+"</td><td>"+(String)map.get("spname")+"</td><td>");
                  String strOpertype = map.get("opertype").toString().trim();
                  if(strOpertype.equals("2"))
                    strOpertype=musicbox;
                  else if(strOpertype.equals("3"))
                    strOpertype=giftbag;
                  out.println((String)map.get("ringlabel")+"</td><td>"+strOpertype+"</td><td>");
                  out.println((String)map.get("buytimes")+"</td><td>"+(String)map.get("largesstimes")+"</td><td>"+CrbtUtil.displayFee(map.get("totalfee").toString().trim())+"</td></tr>");
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
<title>Statistics on the subscriber's login to the website</title>
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

   function modeChange(){
      if(document.forms[0].opermode.value==4){
        if(document.forms[0].spcode.length==0){
           alert("No ringtone provider can be queried. Please configure SPs first.");//没有铃音供应商可供查询,请先配置SP
           return;
        }
        document.all('id_spshow').style.display= 'block';
      }
      else
        document.all('id_spshow').style.display= 'none';
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
         if(fm.stattype.value !=2)//Can only get one month data
         {
           if(fm.start.value.substr(0,7)!=fm.end.value.substr(0,7))
           {
             alert('The start and end date should be the same month!');
             return false;
           }
         }else{// for week you can get the data of two month
           if(fm.start.value.substr(0,7)!=fm.end.value.substr(0,7)){
             v_year= parseInt(fm.end.value.substr(0,4));
             v_month= parseInt(fm.end.value.substr(5,7));
             if(v_month==1){
              v_month=12;
              v_year--;
             }else if(v_month<12)
               v_month--;
             strbegin=fm.start.value.substr(0,7);
             strend=''+v_year+'.';
             if(v_month<10)
               strend +='0'+v_month;
             else
               strend +=v_month;
             if(strbegin<strend)
               alert('You can only get the data of the latest two month!');
           }
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
 if (! checkInfo())
         return;
   //   parent.location.href="downloadPic.jsp?filename=tmp_<//%=operID%>.xls&filepath=<//%=application.getRealPath("temp").replace('\\','/')+"/"%>";

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
<form name="inputForm" method="post" action="contentStat.jsp">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="start" value="<%= startday + "" %>">
<input type="hidden" name="end" value="<%= endday + "" %>">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="900";
</script>
  <table border="0" width="98%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
          <td height="26"  align="center" class="text-title">Content Statistic</td>
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
        User Type <select name="usertype" size="1" class="input-style2">
                    <option value="*">All</option>
                    <option value="0">Mobile</option>
                    <option value="2">Fixed</option>
                    <!--<option value="1">CDMA</option>-->
                    <!--<option value="3">PHS</option>-->
                </select>
      </td>
     </tr>
     </table>
  </td>
  </tr>
   <tr>
   <td align="center">
      <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="93%"  align="center">
      <tr height=35>
      <td>
        Statistic Type <select name="stattype" size="1" class="input-style2">
           <option value="*">Total</option>
           <option value="1">Day</option>
           <option value="2">Week</option>
           <option value="3">Month</option>
          </select>
        Operation Type <select name="opertype" size="1" class="input-style0">
                    <option value="*">All</option>
                    <option value="2"><%=musicbox%></option>
                    <option value="3"><%=giftbag%></option>
                </select>
      </td>
     </tr>
     </table>
  </td>
  </tr>
   <tr>
   <td align="center">
      <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="93%"  align="center">
      <tr height=35>
      <td>
        Sp List &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="spindex" size="1" class="input-style0">
          <option value="*">All Sp</option>
          <option value="0">System</option>
<%
             manSysPara  syspara = new manSysPara();
             ArrayList spInfo = syspara.getSPInfo();
             for (int i = 0; i < spInfo.size(); i++) {
               HashMap map1 = (HashMap)spInfo.get(i);
              // String spindex = (String)map1.get("spindex");
%>
   <option value="<%= (String)map1.get("spindex") %>" ><%= (String)map1.get("spname") %></option>
<%
}
%>
                </select>
        </td>
        <td align="right">
          <img border="0" src="button/search.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:searchInfo()">&nbsp;
          <img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      </td>
     </tr>
     </table>
  </td>
  </tr>

   <tr>
   <td align="center">
     <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="93%"  align="center">
     <tr height=35>
     <td>Start Date
      <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:100px">&nbsp;
      &nbsp;End Date
      <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:100px">
        YYYY.MM.DD
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
              Subs Type
          </td>
          <td height="30" width="16%" align="center" >
             Time Period
          </td>
          <td height="30" width="16%" align="center" >
             Supplier
          </td>
          <td height="30" width="16%" align="center" >
             Artiste Name
          </td>
          <td height="30" width="16%" align="center" >
             Transaction Type
          </td>
          <td height="30" width="8%" align="center" >
             Nr. Of Purchase
          </td>
          <td height="30" width="8%" align="center" >
             Nr. Of Gift
          </td>
          <td height="30" width="8%" align="center" >
             Amount
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
                out.print("<td align=center>"+(String)map.get("usernettype")+"</td>");
                out.print("<td align=center >"+(String)map.get("statstartdate")+ "<br>-"+(String)map.get("statenddate")+"</td>");
                out.print("<td align=center>"+(String)map.get("spname")+"</td>");
                out.print("<td align=center>"+(String)map.get("ringlabel")+"</td>");
                String strOpertype = map.get("opertype").toString().trim();
                if(strOpertype.equals("2"))
                  strOpertype=musicbox;
                else if(strOpertype.equals("3"))
                  strOpertype=giftbag;
                out.print("<td align=center>"+strOpertype+"</td>");
                out.print("<td align=center>"+(String)map.get("buytimes")+"</td>");
                out.print("<td align=center>"+(String)map.get("largesstimes")+"</td>");
                out.print("<td align=center>"+CrbtUtil.displayFee(map.get("totalfee").toString().trim())+"</td>");
                out.print("</td></tr>");
      }
       //     session.setAttribute("ResultSession",arraylist);

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
<table border="0" width="96%" class="table-style2" align="center">
  <tr><td height="10">&nbsp;</td></tr>
  <tr>
    <td class="table-styleshow" background="image/n-9.gif" height="26">
    Notes:</td>
  </tr>
  <tr>
    <td style="color: #FF0000">1.You can get only one month data, but for week statistic,you can get two month data.</td>
  </tr>
</table>
</form>
<script language="JavaScript">
<%if(usertype!=null){%>
  document.inputForm.usertype.value='<%=usertype%>'
<%}%>
<%if(stattype!=null){%>
  document.inputForm.stattype.value='<%=stattype%>'
<%}%>
<%if(opertype!=null){%>
  document.inputForm.opertype.value='<%=opertype%>'
<%}%>
<%if(spindex!=null){%>
  document.inputForm.spindex.value='<%=spindex%>'
<%}%>
</script>
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
        sysInfo.add(sysTime + operName + " Exception occurred in the content statistics ");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in the content statistics ");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="contentStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
