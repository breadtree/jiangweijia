<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="java.io.File"%>
<%@ page import="jxl.*"%>
<%@ page import="jxl.write.*"%>
<%@ page import="zxyw50.XlsNameGenerate"%>

<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String xbaseenable = CrbtUtil.getConfig("xbaseenable","0");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title><%= colorName %> &nbsp;System</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
     int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
 	  String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	   String isSmartPriceFlag = CrbtUtil.getConfig("isSmartPriceFlag","0");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

    try {
     	zxyw50.Purview purview = new zxyw50.Purview();

      if (operID != null && purviewList.get("4-18") != null && purview.CheckOperatorRightAllSerno(session,"4-3")) {
        sysTime = SocketPortocol.getSysTime() + "--";
        manSysRing sysring = new manSysRing();
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        String operation = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The keyword length you entered has exceeded the limit. Please re-enter!");//您输入的关键字长度超出限制,请重新输入!
//        String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
        String sortby =  "" ;
        String searchkey = request.getParameter("searchkey") == null ? ">=" : (String)request.getParameter("searchkey");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        ArrayList vet = new ArrayList();
        Hashtable hash1 = new Hashtable();
        HashMap hash = new HashMap();
        hash1.put("searchvalue",searchvalue);
        hash1.put("searchkey",searchkey);
        hash1.put("sortby",sortby);
        if(operation!=null&&(operation.trim().equals("1") || operation.equals("bakdata"))){
            if(xbaseenable.equals("1")){
                QryXbase qryRing=new QryXbase();
                vet = qryRing.searchRingbyOrderTimes(hash1);
            }
            else{
                ColorRing  colorring = new ColorRing();
                vet = colorring.searchRingbyOrderTimes(hash1);
            }
            //write Excel File, the temp file use the same file,here wo think concurrent is a little probability
          /*  try{
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
              label = new Label(2, 0, "Ringtone provider");
              sheet.addCell(label);
              label = new Label(3, 0, "Singer");
              sheet.addCell(label);
              label = new Label(4, 0, "Price"+majorcurrency);
              sheet.addCell(label);
              label = new Label(5, 0, "Counts of Orders");
              sheet.addCell(label);
              label = new Label(6, 0, "Counts of presents");
              sheet.addCell(label);
              String strTmp;
              for(int i=0;i<vet.size();i++){
               HashMap tmpMap = (HashMap) vet.get(i);
               label = new Label(0,i+1,(String)tmpMap.get("ringid"));
               sheet.addCell(label);
               label = new Label(1,i+1,tmpMap.get("ringlabel").toString());
               sheet.addCell(label);
               label = new Label(2,i+1,tmpMap.get("ringsource").toString());
               sheet.addCell(label);
               label = new Label(3,i+1,tmpMap.get("ringauthor").toString());//strTmp.getBytes("ISO8859_1"), "GBK")
               sheet.addCell(label);
               label = new Label(4,i+1,(String)tmpMap.get("ringfee"));
               sheet.addCell(label);
               label = new Label(5,i+1,(String)tmpMap.get("buytimes"));
               sheet.addCell(label);
               label = new Label(6,i+1,(String)tmpMap.get("largesstimes"));
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
        if(operation.equals("bakdata")){
                response.reset();
                //response.setContentType("application/msexcel;charset=UTF-8");//UTF-8
    		response.setContentType("application/vnd.ms-excel; charset=GBK");//UTF-8  gb2312
    		//response.setContentType("application/msexcel;charset=UTF-8");//UTF-8  gb2312
		String file_name = XlsNameGenerate.get_xls_filename("", "", "ringOrderStat", XlsNameGenerate.STATISTIC_NONE);
        response.setHeader("Content-disposition","inline; filename=" + file_name);
             	out.clear();
        String temp="";
        if(issupportmultipleprice == 1){
        temp="<td>Daily Price(" +majorcurrency+ ")</td>";
        }
        else{
        temp="";
        }
             	out.println("<table border='1'>");
        out.println("<tr><td>Ringtone code</td><td>Ringtone name</td><td>Ringtone provider</td><td>Singer</td>"+temp+"<td>Monthly Price(" +majorcurrency+ ")</td><td>Counts of Orders</td><td>Counts of presents</td></tr>");
            	for (int i = 0; i < vet.size(); i++) {
            	        hash = (HashMap)vet.get(i);
            	      if(issupportmultipleprice == 1){
                        temp="<td>&lrm;"+displayFee((String)hash.get("ringfee2"))+"</td>";
                        }   
                        else{
                        temp="";
               	}
                       	out.println("<tr><td>&lrm;"+(String)hash.get("ringid")+"</td><td>&nbsp;"+displayRingName((String)hash.get("ringlabel"))+"</td><td>"+displaySpName((String)hash.get("ringsource"))+"</td><td>"+displayRingAuthor((String)hash.get("ringauthor"))+"</td>"+temp+"<td>&lrm;"+displayFee((String)hash.get("ringfee"))+"</td><td>"+(String)hash.get("buytimes")+"</td><td>"+(String)hash.get("largesstimes")+"</td></tr>");
               	}
               	out.println("</table>");
                vet.clear();
        	return;
      	  }
        int pages = vet.size()/25;
        if(vet.size()%25>0)
          pages = pages + 1;
%>
<script language="javascript">
   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.op.value="1";
      document.inputForm.target="_self";
      document.inputForm.submit();
   }

   function searchRing (sortby) {
      fm = document.inputForm;
      if (sortby.length > 0)
         fm.sortby.value = sortby;
      if (trim(fm.searchvalue.value) != '') {
          if(!checkstring('0123456789',trim(fm.searchvalue.value))){
              alert('The number of orders can only be digital!');//定购次数仅能为数字!
              fm.searchvalue.focus();
              return;
          }
      }
      fm.target="_self";
      fm.page.value = 0;
      fm.op.value="1";
      fm.submit();
   }

   function WriteDataInExcel(){
     fm = document.inputForm;
     //parent.location.href="downloadPic.jsp?filename=tmp_<//%=operID%>.xls&filepath=<//%=application.getRealPath("temp").replace('\\','/')+"/"%>";
     if (trim(fm.searchvalue.value) != '') {
       if(!checkstring('0123456789',trim(fm.searchvalue.value))){
         alert('The number of orders can only be digital!');//定购次数仅能为数字!
         fm.searchvalue.focus();
         return;
       }
     }
     var fm = document.inputForm;
     fm.op.value = 'bakdata';
     fm.target="top";
     fm.submit();
   }

   function goPage(){
      var fm = document.inputForm;
      var pages = parseInt(fm.pages.value);
      var thispage = parseInt(fm.page.value);
      var thepage =parseInt(trim(fm.gopage.value));

      if(thepage==''){
         alert("Please specify the value of the page to go to!")//Please specify the value of the page to go to!
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
         alert("The value of the page to go to can only be a digital number!")//The value of the page to go to can only be a digital number
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!")//alert("转到的页码值范围不正确  页）!
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      if(thepage==thispage){
         alert("This page has been displayed currently. Please re-specify a page!")//This page has been displayed currently. Please re-specify a page!
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }

  function ringInfo (ringid, buytimes,largesstimes) {
					//  document.URL ='ringInfo.jsp?ringid=' + ringid + '&libid=' + libid;
				 var url ='ringInfo1.jsp?ringid=' + ringid + '&ringtype=1&fromCCS=true'+ '&buytimes=' + buytimes + '&largesstimes=' + largesstimes;
                    window.showModalDialog(url,window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-500)/2)+";dialogTop:"+((screen.height-500)/2)+";dialogHeight:500px;dialogWidth:500px");
	}
</script>
<script language="JavaScript">
	var hei=600;
	if(parent.frames.length>0){

<%
	if(vet==null || vet.size()<15 || vet.size()==15){
%>
	hei = 600;
<%
	}else if(vet.size()>15 && vet.size()<25){
%>
	hei = 600 + (<%= vet.size()%>-15)*20;

<%
	}else{
%>
	hei = 800;

<%
}
%>
	parent.document.all.main.style.height=hei;
    }

</script>
<form name="inputForm" method="post" action="orderTimes.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="op" value="<%=operation%>">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr >
          <td height="40"  align="center" class="text-title" background="image/n-9.gif">Query the number of ringtone orders</td>
</tr>
<tr>
    <td width="100%">
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td width="10"></td>
		  <td>
            Query mode
            <select size="1" name="searchkey" class="select-style1">
              <option value="&gt;">greater than</option>
              <option value="&gt;=">greater than or equal to</option>
              <option value="&lt;">less than</option>
              <option value="&lt;=">less than or equal to</option>
              <option value="=">equal to</option>
            </select>
          </td>
          <td>Number of orders
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style1" >
          </td>
          <td><img src="button/search.gif" alt="Search ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
            </td>
        </tr>
        <tr>
          <td colspan="4">&nbsp;

          </td>
        </tr>
      </table>
    </td>
  </tr>
<script language="javascript">
   if ('<%= searchkey %>' != '-1')
      document.inputForm.searchkey.value = '<%= searchkey %>';
</script>
  <tr>
    <td width="100%" align="center">
      <table width="98%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style2">
         <tr class="tr-ring">
                <td height="30" width="70">
                    <div align="center">Ringtone code</div>
                  </td>
                  <td height="30">
                    <div align="center">Ringtone name</div>
                  </td>
                  <td height="30">
                    <div align="center">Ringtone provider</div>
                  </td>
                  <td height="30" >
                    <div align="center">Singer</div>
                  </td>
                  <%if(issupportmultipleprice == 1){%>
                  <td height="30" >
                    <div align="center">Daily Price<br>(<%=majorcurrency%>)</div>
                  </td>
                  <%}
                   if ("1".equals(isSmartPriceFlag)) { %>
			<td height="30">
					      <div align="center"><span title="Ringtone Info.">Info.</span></div>
			</td>
				  <% } else { %>
		  		  <td height="30" >
                    <div align="center"><%if(issupportmultipleprice == 1){%>Monthly <%}%> Price<br>(<%=majorcurrency%>)</div>
                  </td>
                   <% } %>
		  		  <td height="30" >
                  	<div align="center">Number <br>of orders</div>
                  </td>
                  <td height="30" >
                    <div align="center">Number<br>of presents</div>
                  </td>
              </tr>

<%
        int count = vet.size() == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash = (HashMap)vet.get(i);
            count++;
%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">

        <td height="20"><%= (String)hash.get("ringid") %></td>
        <td height="20"><%= displayRingName((String)hash.get("ringlabel")) %></td>
        <td height="20"><%= displaySpName((String)hash.get("ringsource")) %></td>
        <td height="20" align="center" ><%= displayRingAuthor((String)hash.get("ringauthor")) %></td>
        <%if(issupportmultipleprice == 1){%>
        <td height="20" align="center">
         <div align="center"><%= displayFee((String)hash.get("ringfee2")) %></div></td>
         <%}
           if ("1".equals(isSmartPriceFlag)) { %>
         <td height="20" align="center"><img src="../image/info.gif"  height='15'  width='15' alt="Ringtone Information" onMouseOver="this.style.cursor='hand'" onClick="javascript:ringInfo('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("buytimes") %>','<%= (String)hash.get("largesstimes") %>')">
		 </td>
   <% } else { %>
        <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee")) %></div></td>
		 <%} %>
        <td height="20" align="center"><%= (String)hash.get("buytimes") %></td>
        <td height="20" align="center"><%= (String)hash.get("largesstimes") %></td>
        </tr>
<%
         }
        // session.setAttribute("ResultSession",vet);

        if (vet.size() > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
        </tr>
        <tr>
          <td colspan="5" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >pages&nbsp;</td>
             <td> <input style=text value="<%= String.valueOf(thepage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
             <td ><img src="../button/go.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:goPage()"  ></td>
            </tr>
            </table>
          </td>
       </tr>
      </table>
    </td>
  </tr>
<%
        }
%>


</table>
</form>
<%
        }
        else {
          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in first!");//Please log in to the system
                    parent.document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime + "Exception occurred in querying the number of ringtone orders");//铃音订购次数查询过程出现异常!
        sysInfo.add(sysTime + e.toString());
        vet.add( "Error occurred in querying the number of ringtone orders!");//铃音订购次数查询过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="orderTimes.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
