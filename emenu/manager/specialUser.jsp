<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.*" %>



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
<title>Special User management</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");

	// add for starhub
	String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");


    HashMap map = new HashMap();


    //查询参数
    String usernumber = request.getParameter("usernumber") == null ? "" : request.getParameter("usernumber");

	String opertype = request.getParameter("opertype") == null ? "0" : transferString(request.getParameter("opertype"));
    String mode = request.getParameter("mode") == null ? "query" : request.getParameter("mode");
    HashMap hash = new HashMap();
    int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));


    try {
    	 String  errmsg = "";
    	 boolean flag=true;
	    if (operID  == null){
           errmsg = "Please log in to the system first!";//Please log in to the system
           flag = false;
        }
        else if (purviewList.get("1-20") == null) { //sunqi:需要修改
          errmsg = "You have no right to access function!";//You have no access to this function
          flag = false;
        }

    if (flag) {
        manProductCode productCode = new manProductCode();
        Hashtable hashInfo = new Hashtable();
        ArrayList resultList = null;
        ArrayList rList  = new ArrayList();
        hashInfo.put("usernumber",usernumber);


        if (mode.equals("del")){
              hashInfo.put("optype","2");
        	  hashInfo.put("bflag","2");
        	  hashInfo.put("para1","1");
        	  hashInfo.put("para2","2");
              rList = productCode.setSpecialUser(hashInfo);


              // 准备写操作员日志
              map.put("OPERID",operID);
              map.put("OPERNAME",operName);
              map.put("OPERTYPE","120");
              map.put("RESULT","1");
              map.put("PARA1",usernumber);
              map.put("PARA2","2");
              map.put("PARA3","");
              map.put("PARA4","IP:"+request.getRemoteAddr());
              map.put("DESCRIPTION","Delete");

              purview.writeLog(map);
              sysInfo.add(sysTime + operName +" delete special user");



              if(rList.size()>0){
                session.setAttribute("rList",rList);
%>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="specialUser.jsp?page=<%=thepage%>">
<input type="hidden" name="title" value="Delete Special User">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
<%
                }

        }
        resultList = productCode.getSpecialUser(hashInfo);


        int pages = resultList.size()/25;
        if(resultList.size()%25>0)
            pages = pages + 1;
        sysTime = productCode.getSysTime() + "--";



%>
<script language="javascript">

//限定只能输入数字
function numbersOnly(field,event){
  var key,keychar;
  if(window.event){
    key = window.event.keyCode;
  }
  else if (event){
    key = event.which;
  }
  else{
    return true
  }
  keychar = String.fromCharCode(key);
  if((key == null) || (key == 0) || (key == 8)|| (key == 9) || (key == 13) || (key == 27)){
    return true;
  }
  else if(('0123456789').indexOf(keychar) > -1){
    return true;
  }
  else {
    alert('Please input the digital number!');
    return false;
  }
}


function searchInfo(){
  var fm = document.inputForm;
  var usernumber = trim(fm.usernumber.value);


  if(!checkstring('0123456789',usernumber))
  {
  	alert("Usernumber must be a digital number!");
  	return;
  }

  fm.mode.value = 'query';
  fm.page.value = 0;
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
  document.inputForm.mode.value = 'query';
  document.inputForm.submit();
}
//增加
function addInfo () {
	var fm = document.inputForm;
  	var result = window.showModalDialog('specialUserAdd.jsp',window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-250)/2)+";dialogTop:"+((screen.height-350)/2)+";dialogHeight:250px;dialogWidth:350px");
   	if(result && (result=='yes'))
    	fm.submit();

}

function delInfo(usernumber){
	if (confirm('Are you sure to delete this special user?'))
	{
    	var fm = document.inputForm;
    	fm.usernumber.value = usernumber;
    	fm.mode.value = 'del';
    	fm.submit();
  	}else{
    	return;
  	}
}


</script>
<!--end-->
<form name="inputForm" action="specialUser.jsp">
<input type="hidden" name="mode" value=""/>
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<script language="JavaScript">
  if(parent.frames.length>0)
    parent.document.all.main.style.height="880";
</script>
<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
      <table align="center" width="100%"  border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr >
          <td height="26" colspan="5" align="center" class="text-title" background="image/n-9.gif">Special User Management</td>
        </tr>
        <tr >
          <td height="10" colspan="5" align="center" class="text-title">&nbsp;</td>
        </tr>

        <tr>
          <td align="left" width="45%"><%=user_number%>
          	<input type="text" value="<%=usernumber%>" name="usernumber" class="input-style0"  maxlength="20" />
          </td>
          <td align="left" width="25%"><img src="button/search.gif" alt="Find <%=user_number%>" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"></td>
          <td align="left" width="30%"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()" alt="Add special user"/></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td width="90%" align="center">
      <table width="100%" border="0" cellspacing="1" cellpadding="1" align="left" class="table-style4">
         <tr class="tr-ringlist">
           <td  height="30" width="25%">
             <div align="center"><font color="#ffffff"><%=user_number%></font></div>
           </td>

           <td height="30" width="20%">
             <div align="center"><font color="#ffffff">Bflag</font></div>
           </td>

           <td height="30" width="20%">
             <div align="center"><font color="#ffffff">Parameter1</font></div>
           </td>
           <td height="30" width="20%">
             <div align="center"><font color="#ffffff">Parameter2</font></div>
           </td>
           <td height="30" width="20%">
             <div align="center"><font color="#ffffff">Delete</font></div>
           </td>
         </tr>
<%
        int count = resultList.size() == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < resultList.size(); i++) {
            hash = (HashMap)resultList.get(i);
            count++;
%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">

        <td height="20"><div align="center"><%= (String)hash.get("usernumber") %></div></td>
        <td height="20"><div align="center"><%= (String)hash.get("bflag")  %></div></td>
        <td height="20"><div align="center"><%= (String)hash.get("para1") %></div></td>
        <td height="20"><div align="center"><%= (String)hash.get("para2") %></div></td>
        <td height="20"><div align="center"><img src="../image/delete.gif" alt="Delete" onMouseOver="this.style.cursor='hand'" onclick="delInfo('<%=(String)hash.get("usernumber")%>')"></div></td>
        </tr>
<%
        }
        if (resultList.size() == 0 && !mode.equals("")){
%>
        <tr bgcolor="E6ECFF">
          <td align="center" colspan="10">No record matched the criteria!</td>
        </tr>
<%
        }
        if (resultList.size() > 25) {
%>
      </table>
    </td>
  </tr>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;Total:<%= resultList.size() %>,&nbsp;&nbsp;<%=  resultList.size()%25==0?resultList.size()/25:resultList.size()/25+1 %>&nbsp;page(s),&nbsp;&nbsp;Now on Page &nbsp;<%= thepage+1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= resultList.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (resultList.size() - 1) / 25 %>)"></td>
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
%>
      </table>
    </td>
  </tr>
 <tr>
   <td>
   </br>
    </br>
   </td>
  </tr>
  <tr >
   	<td><table border="0" width="100%" class="table-style2">
        <tr>
                <td class="table-styleshow" background="image/n-9.gif" height="26">
                  Notes:</td>
        </tr>
        <tr>
          <td height="20" style="color: #FF0000">
            <p>1. The Parameter1 is open/cancel mode</p>
          </td>
        </tr>
        <tr>
          <td height="20" style="color: #FF0000">
            <p>2. The Parameter1 is,when bflag=1,type of open a account, 2-realtime message 3-realtime file 4-quasi realtime file 7-quasi realtime message.<br>
              </p>
          </td>
        </tr>
        <tr>
          <td height="20" style="color: #FF0000">
            3. The Parameter2 is no use.
          </td>
        </tr>
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
        sysInfo.add(sysTime + operName + "Exception occurred in managing special user!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing special user!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="specialUser.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

