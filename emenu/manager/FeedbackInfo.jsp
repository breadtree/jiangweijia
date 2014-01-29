<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.RingQuery" %>


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
        boolean   flag =true;
       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
       }
      if (purviewList.get("1-54") == null) {
            errmsg = "Sorry,you have no access to this function!";//You have no access to this function!
            flag = false;
          }
		 //flag=true;
		 if(flag){
%>
<%
RingQuery ringQuery=new RingQuery();
int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));

  String userName = (String)request.getParameter("userName");
    	
  if(userName!=null){
  	 String number = (String)request.getParameter("weyak_mobile");
	 String email = (String)request.getParameter("email");
	 String channels = (String)request.getParameter("channels");
	 String subject = (String)request.getParameter("subject");
	 String feedback = (String)request.getParameter("feedback");
	 String errorMessage = (String)request.getParameter("errorMessage");
		 
  	 HashMap map = new HashMap();
	 map.put("optype",""+2);//2 to delete feed back.
	 map.put("number",number);
	 map.put("userName",userName);
	 map.put("email",email);
	 map.put("channels",channels);
	 map.put("subject",subject);
	 map.put("feedback",feedback);
	 map.put("errorMessage",errorMessage);
  	 ArrayList rList=ringQuery.updateFeedbackInfo(map);
	  
  }
 ArrayList vet = new ArrayList();
 
 vet = ringQuery.getFeedBackInfo();
  HashMap hash = new HashMap();
 int pages = vet.size()/25;
	if(vet.size()%25>0)
  	pages = pages + 1;
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>CRBT</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<form name="inputForm" method="post" action="FeedbackInfo.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">

<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="1100";
</script>


<table border="0" width="500" align="center" cellspacing="0" cellpadding="0" class="table-style2" height="26">
	<tr >
          <td height="20"  align="center">&nbsp;</td>
   </tr>
   <tr >
          <td height="26"  align="center" class="text-title"  background="image/n-9.gif" >Feedback Details</td>
   </tr>
   <tr >
          <td height="20"  align="center">&nbsp;</td>
   </tr>
 </table>

<table class="table-style2" cellspacing="1" cellpadding="1" border="0">
	<tr class="table-title1">
		<td height="24" align="center">Sl No </td>
		<td height="24" align="center">User Number</td>
		<td height="24" align="center">User Name</td>
		<td height="24" align="center">Email</td>
		<td height="24" align="center">Complaint Type</td>
		<td height="24" align="center">Subject</td>
		<td height="24" align="center">Feedback Message</td>
		<td height="24" align="center">Error Message</td>
		<td height="24" align="center">Delete</td>
	</tr>
	<%
        int count = vet.size() == 0 ? 25 : 0;
        String isadflag = "";
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash = (HashMap)vet.get(i);
            count++;
        if("1".equals((String)hash.get("isadflag"))){
              isadflag = "Yes";
            }else{
              isadflag = "No";
            }
		int type=Integer.parseInt((String)hash.get("type"));
		String typeName=null;
		if(type==1)typeName="About the service";
		if(type==2)typeName="Content";
		String feeback=(String)hash.get("feeback");
		String error_message=(String)hash.get("error_message");
		if(feeback==null || feeback.equals("null"))feeback="";
		if(error_message==null || error_message.equals("null"))error_message="";
%>
	<tr bgcolor="<%= i % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
		<td>&nbsp;&nbsp;<%=i+1%></td>
		<td>&nbsp;&nbsp;<%= (String)hash.get("usernumber")==null?"":(String)hash.get("usernumber")%></td>
		<td>&nbsp;&nbsp;<%= (String)hash.get("username")==null?"":(String)hash.get("username") %></td>
		<td>&nbsp;&nbsp;<%= (String)hash.get("email") %></td>
		<td>&nbsp;&nbsp;<%= typeName %></td>
		<td>&nbsp;&nbsp;<%= (String)hash.get("feeback_sub") %></td>
		<td>&nbsp;&nbsp;<%= feeback %></td>
		<td>&nbsp;&nbsp;<%= error_message %></td>
		<td>&nbsp;&nbsp;
			<div align="center"><font class="font-ring"><img src="../image/delete.gif" height='15'  width='15' alt="Delete" onMouseOver="this.style.cursor='hand'" onClick="javascript:delRing('<%= (String)hash.get("usernumber") %>','<%= (String)hash.get("username") %>','<%= (String)hash.get("email") %>','<%= (String)hash.get("type") %>','<%= (String)hash.get("feeback_sub") %>','<%= (String)hash.get("feeback") %>','<%= (String)hash.get("error_message") %>')"></font></div>
		</td>
		
	</tr>
	<%}%>
</table>
<% if (vet.size() > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;Total:<%= vet.size() %>,&nbsp;&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;page(s)&nbsp;&nbsp;Now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
        </tr>
        <tr>
          <td colspan="5" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >Page&nbsp;</td>
             <td> <input style=text value="<%= String.valueOf(thepage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
             <td ><img src="../button/go.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:goPage()"  ></td>
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
</form>
<script>
function delRing (usernumber,username,email,type,feeback_sub,feeback,error_message) {
//       var libid = document.inputForm.ringlib.value;
//由于存储过程参数的变化，libid存放的实际上是ringlibcode
	var deleteFeedback=confirm("Do you really want to delete the feedback?");
	if (deleteFeedback== true)
	 {
	   window.location="FeedbackInfo.jsp?weyak_mobile="+usernumber+"&userName="+username+"&email="+email+"&channels="+type+"&subject="+feeback_sub+"&feedback="+feeback+"&errorMessage="+error_message;
	 }
	else
	 {
	  
	 }
     
   }
   
   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
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
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occourred in the Stat.of subscriber feed back info!");// 用户铃音活动统计操作查询过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        //vet.add("用户铃音活动统计操作查询过程出现错误!");
        vet.add("Error occourred in the Stat.of subscriber feedback!");
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
