<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>

<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>

<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%@ page import="jxl.*"%>
<%@ page import="jxl.write.*"%>
<%@ page import="zxyw50.XlsNameGenerate"%>

<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<jsp:useBean id="purview" class="zxyw50.Purview" scope="page"/>
<script src="../pubfun/JsFun.js"></script>

<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Reuploaded ring Status</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ringid = request.getParameter("ringid") == null ? "" : request.getParameter("ringid").toString();
    ArrayList ringList = new ArrayList();
	ArrayList ringStatusList = new ArrayList();
	HashMap hash = new HashMap();
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
	String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
	String sMaxLimit = zte.zxyw50.util.CrbtUtil.getConfig("maxlimit","65536");
    int maxlimit = Integer.parseInt(sMaxLimit);
	manSysRing mansys = new manSysRing();
    try {
    	String  errmsg = "";
    	boolean flag=true;
	    if (operID  == null){
           errmsg = "Please log in to the system first!";//Please log in to the system
           flag = false;
        }
        else if (purviewList.get("4-69") == null) {
          errmsg = "You have no right to access function!";//You have no access to this function
          flag = false;
        }
		if (flag) {
		
		ringList = (ArrayList)mansys.getReuploadRingInfo(); // To get the Re-uploaded rings
		//Export to Excel
		if (op.equals("bakdata")) {
			ArrayList al = (ArrayList) session.getAttribute("ResultSession");
			String sFileName = "Re-uploadedRingStatus.xls";
			String eRingName = "All";
		    try{
				response.setContentType("application/msexcel");
				response.setHeader("Content-disposition","inline; filename=" + sFileName);
						
				java.io.OutputStream os=response.getOutputStream();
				out.clear();
 			    out = pageContext.pushBody(); 
				
				WritableWorkbook wwb=null;
     			wwb=Workbook.createWorkbook(os);
      			WritableSheet ws=wwb.createSheet("Re-uploaded Ring Status Report",25);

		   	    WritableFont boldFont = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD);
	  			WritableCellFormat cell_boldfont = new WritableCellFormat(boldFont);
				
				if(!ringid.equals("all")){
					if(ringList!= null && ringList.size()>0){
						for (int i = 0; i <ringList.size(); i++) {
							HashMap map = (HashMap)ringList.get(i);
							if(map.get("ringid").equals(ringid)){
								eRingName = map.get("ringlabel").toString();
							}
						}
					}
				}
				
			    ws.addCell(new jxl.write.Label(0, 0, "REPORT",cell_boldfont));
			    ws.addCell(new jxl.write.Label(0, 1, "Ring NAME",cell_boldfont));

				ws.addCell(new jxl.write.Label(2, 0, "Re-uploaded Ring Status Report"));
				ws.addCell(new jxl.write.Label(2, 1, eRingName));
						   
				ws.addCell(new jxl.write.Label(0, 4, "Ring Id",cell_boldfont));
				ws.addCell(new jxl.write.Label(1, 4, "Upload Status",cell_boldfont));
				ws.addCell(new jxl.write.Label(2, 4, "First Upload Time",cell_boldfont));
				ws.addCell(new jxl.write.Label(3, 4, "Last reupload Time",cell_boldfont));
				ws.addCell(new jxl.write.Label(4, 4, "Re-uploaded Times",cell_boldfont));
					
				ws.setColumnView(0,20);
			  	ws.setColumnView(1,15);
				ws.setColumnView(2,20);
				ws.setColumnView(3,20);
				ws.setColumnView(4,20);
			
				if(al.size() > 0) {
					int k=0,j=0;
					for (int i = 0; i <al.size(); i++) {
						hash = (HashMap)al.get(i);
						if(i > (maxlimit+(maxlimit*j)-2) ) {
							ws=wwb.createSheet("Re-uploaded Ring Status"+j,25);
							j++;
							k=0;
						}
						if(i == 0) {
							k=5;
						}
						ws.addCell(new jxl.write.Label(0, k, (String)hash.get("ringId")));
						ws.addCell(new jxl.write.Label(1, k, (String)hash.get("result")));
						ws.addCell(new jxl.write.Label(2, k, (String)hash.get("startTime")));
						ws.addCell(new jxl.write.Label(3, k, (String)hash.get("lastModifyTime")));
						ws.addCell(new jxl.write.Label(4, k, (String)hash.get("syncTimes")));
						k++;
					}
				} else {
					ws.addCell(new jxl.write.Label(2, 5, "No record matched the criteria!"));
				}
				wwb.write();
				os.flush();
				wwb.close();
				os.close();
			}catch(Exception e) {
%>
<script>
	alert("The Server is busy!");
</script>
<%
	   	}
	}//end of export 

	// To search the re-uploaded rings status 
	if (op.equals("search")){
		ringStatusList = (ArrayList)mansys.getRingReuploadStatus(ringid);
		session.setAttribute("ResultSession", ringStatusList);
	}// end of search
	
	int records = 2;
	int pages = ringStatusList.size()/records;
    if(ringStatusList.size()%records>0)
    	pages = pages + 1;
%>

<script language="javascript">

	function WriteDataInExcel(){
		var fm = document.inputForm;
	    fm.op.value='bakdata';
		fm.ringid.value = '<%=ringid%>';
        fm.target="top";
        fm.submit();
	}

	function searchInfo(){
		var fm = document.inputForm;
		fm.op.value='search';
		fm.submit();
	}

	function goPage(){
	  var fm = document.inputForm;
	  var pages = parseInt(fm.pages.value);
	  var thispage = parseInt(fm.page.value);
	  var thepage =parseInt(trim(fm.gopage.value));
	
	  if(thepage==''){
		alert("Please specify the value of the page to go to!")
		fm.gopage.focus();
		return;
	  }
	  if(!checkstring('0123456789',thepage)){
		alert("he value of the page to go to can only be a digital number!")
		fm.gopage.focus();
		return;
	  }
	  if(thepage<=0 || thepage>pages ){
		alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!")
		fm.gopage.focus();
		return;
	  }
	  thepage = thepage -1;
	  if(thepage==thispage){
		alert("his page has been displayed currently. Please re-specify a page!")
		fm.gopage.focus();
		return;
	  }
	  toPage(thepage);
	}

	function toPage (page) {
	  document.inputForm.page.value = page;
	  document.inputForm.submit();
	}

	function addInfo () {
	  var fm = document.inputForm;
	  var grpresult = window.showModalDialog('productCodeAdd.jsp',window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-380)/2)+";dialogTop:"+((screen.height-450)/2)+";dialogHeight:350px;dialogWidth:450px");
	   if(grpresult && (grpresult=='yes')){
		fm.submit();
	  }
	}
</script>

<form name="inputForm" action="RingReupload.jsp">
<input type="hidden" name="op" value="<%= op%>">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">

<script language="JavaScript">
  if(parent.frames.length>0)
    parent.document.all.main.style.height="880";
</script>

<table align="center" width="100%"  border="0" cellspacing="1" cellpadding="1" class="table-style2">
 <tr> <td height="26" colspan="4" align="center" class="text-title" background="image/n-9.gif">Ring Re-upload Status</td> </tr>
 <tr> <td height="10" colspan="4" align="center" class="text-title">&nbsp;</td> </tr>
 <tr> 
  <td width="40%" align="left">&nbsp;Ring Name&nbsp;
   <select size="1" name="ringid" class="select-style1" style="width=100px" >
	<option value="all" >All</option>
<%
	if(ringList!=null && ringList.size()!=0){
		for(int j=0;j<ringList.size();j++) {
			HashMap ringMap = (HashMap)ringList.get(j);
    		if (ringid.equals((String)ringMap.get("ringid"))){
    			out.println("<option value='"+(String)ringMap.get("ringid")+"' selected>"+(String)ringMap.get("ringlabel")+"</option>");
    		}else {
    			out.println("<option value='"+(String)ringMap.get("ringid")+"'>"+(String)ringMap.get("ringlabel")+"</option>");	
    		}
		}
	}
%>
   </select>
  </td>
  <td width="24%" align="right">
   <img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()">&nbsp;&nbsp;
   <img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
  </td>
  <td width="36%" align="right">&nbsp;</td>
 </tr>
</table><br/>
<% if("search".equals(op)){%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
 <tr>
  <td width="100%" align="center">
   <table width="100%" border="0" cellspacing="1" cellpadding="1" align="left" class="table-style4">
    <tr class="tr-ringlist">
     <td  height="30" width="15%" align="center"> <font color="#ffffff">Ring Id</font> </td>
     <td  height="30" width="15%" align="center"> <font color="#ffffff">Upload Status</font> </td>
     <td  height="30" width="20%" align="center"> <font color="#ffffff">First Upload Time</font> </td>
     <td  height="30" width="20%" align="center"> <font color="#ffffff">Last reupload Time</font> </td>
     <td  height="30" width="15%" align="center"> <font color="#ffffff">Re uploaded Times</font> </td>
    </tr>
<%
	int count = ringStatusList.size() == 0 ? records : 0;
    for (int i = thepage * records; i < thepage * records + records && i < ringStatusList.size(); i++) {
		hash = (HashMap)ringStatusList.get(i);
        count++;
        String ringId = (String)hash.get("ringId") == null ? "":(String)hash.get("ringId");
        String result = (String)hash.get("result") == null ? "":(String)hash.get("result");
        String startTime = (String)hash.get("startTime") == null ? "":(String)hash.get("startTime");
        String lastModifyTime = (String)hash.get("lastModifyTime") == null ? "":(String)hash.get("lastModifyTime");
        String syncTimes = (String)hash.get("syncTimes") == null ? "0":(String)hash.get("syncTimes");
%>
	<tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
	 <td height="15" width="20%"><div align="center"><%= ringId %></div></td>
	 <td height="15" width="20%"><div align="center"><%= result %></div></td>
     <td height="15" width="20%"><div align="center"><%= startTime %></div></td>
     <td height="15" width="20%"><div align="center"><%= lastModifyTime %></div></td>
	 <td height="15" width="20%"><div align="center"><%= syncTimes %></div></td>
    </tr>
<%
	}
    if (ringStatusList.size() == 0 && !op.equals("")){
%>
	<tr bgcolor="E6ECFF"> <td align="center" colspan="10">No record matched the criteria!</td> </tr>
<%
	}
    if (ringStatusList.size() > records) {
%>
   </table>
  </td>
 </tr>
 <tr>
  <td width="100%">
   <table align="right" class="table-style2" width="100%" >
    <tr>
     <td class="table-style2">&nbsp;Total:<%= ringStatusList.size() %> records;&nbsp;&nbsp;<br>
       <%=  ringStatusList.size()%records==0?ringStatusList.size()/records:ringStatusList.size()/records+1 %>&nbsp;page(s),&nbsp;&nbsp;Now on Page &nbsp;<%= thepage+1 %>&nbsp;
	 </td>
     <td colspan="4" align="right">
	  <img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)">
      <img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>>
      <img src="../button/nextpage.gif"<%= thepage * records + records >= ringStatusList.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>>
      <img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (ringStatusList.size() - 1) / records %>)">
	 </td>
    </tr>
    <tr>
     <td colspan="5" align="right" >
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
       <tr>
        <td >Page&nbsp;</td>
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
	}
%>
  </table>
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
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
</script>
<%
            }
            else{
%>
<script language="javascript">
                   alert( "You have no access to this function!");
</script>
<%
            }
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in managing product code!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing product code!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="RingReupload.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>