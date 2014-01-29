<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.CrbtUtil" %>
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
<title>ProductCode management</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="init()">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");


    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");


    HashMap map = new HashMap();


    //查询参数
    String prodcode = request.getParameter("prodcode") == null ? "" : request.getParameter("prodcode");
    String spcode   = request.getParameter("spcode") == null ? "" : transferString(request.getParameter("spcode"));
	 String opertype = request.getParameter("opertype") == null ? "0" : transferString(request.getParameter("opertype"));
    String mode = request.getParameter("mode") == null ? "query" : request.getParameter("mode");
    HashMap hash = new HashMap();
    int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));


   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
    try {
    	 String  errmsg = "";
    	 boolean flag=true;
	    if (operID  == null){
           errmsg = "Please log in to the system first!";//Please log in to the system
           flag = false;
        }
        else if (purviewList.get("3-29") == null) {
          errmsg = "You have no right to access function!";//You have no access to this function
          flag = false;
        }

    if (flag) {
        manSysPara syspara = new manSysPara();
        manProductCode productCode = new manProductCode();
        Hashtable hashInfo = new Hashtable();
        ArrayList resultList = null;
        ArrayList rList  = new ArrayList();
        if (mode.equals("query")){
            hashInfo.put("prodcode",prodcode);
            hashInfo.put("spcode",spcode);
            if(!"0".equals(opertype))
            	hashInfo.put("opertype",opertype);
            resultList = productCode.getProductCode(hashInfo);
        }
        if (mode.equals("del")){
              rList = productCode.delProductCode(prodcode);

              // 准备写操作员日志

              map.put("OPERID",operID);
              map.put("OPERNAME",operName);
              map.put("OPERTYPE","329");
              map.put("RESULT","1");
              map.put("PARA1",prodcode);
              map.put("PARA2",opertype);
              map.put("PARA3",spcode);
              map.put("PARA4","IP:"+request.getRemoteAddr());
              map.put("DESCRIPTION","Delete");
              purview = new zxyw50.Purview();
              purview.writeLog(map);
              sysInfo.add(sysTime + operName +" delete product code");

              if(rList.size()>0){
                session.setAttribute("rList",rList);
%>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="productCode.jsp">
<input type="hidden" name="title" value="Delete Product Code">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
<%
                }


        }
        hashInfo.put("prodcode",prodcode);
        hashInfo.put("spcode",spcode);
        resultList = productCode.getProductCode(hashInfo);


        int pages = resultList.size()/25;
        if(resultList.size()%25>0)
            pages = pages + 1;
        sysTime = productCode.getSysTime() + "--";



%>
<script language="javascript">

function init() {

}

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
  var prodcode = trim(fm.prodcode.value);
  var spcode = trim(fm.spcode.value);

  for (var i = 0;i<prodcode.length;i++){
    var ch = prodcode.charAt(i);
    if("'".indexOf(ch) == 0){
    //  alert("输入的信息不能包含'号,请重新输入!");
      alert("The input information cannot include ',please re-enter!");
      fm.prodcode.value = '';
      fm.prodcode.focus();
      return;
      break;
    }
  }
  for (var i = 0;i<spcode.length;i++){
    var ch = spcode.charAt(i);
    if("\"".indexOf(ch) == 0){
     // alert("输入的信息不能包含\"号,请重新输入!");
        alert("The input information cannot include \",please re-enter!");
      fm.spcode.value = '';
      fm.spcode.focus();
      return;
      break;
    }
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
  var grpresult = window.showModalDialog('productCodeAdd.jsp',window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-380)/2)+";dialogTop:"+((screen.height-450)/2)+";dialogHeight:350px;dialogWidth:450px");
   if(grpresult && (grpresult=='yes')){
    fm.submit();
  }
}
function showInfo(productcode){
  window.showModalDialog('productCodeAdd.jsp?mode=query&productcode='+productcode,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-380)/2)+";dialogTop:"+((screen.height-450)/2)+";dialogHeight:350px;dialogWidth:450px");
}
function delInfo(productcode){
	if (confirm('Are you sure to delete this product code?')){
    var fm = document.inputForm;
    fm.prodcode.value = productcode;
    fm.mode.value = 'del';
    fm.submit();
  }else{
    return;
  }
}

function editInfo(productcode){
  var fm = document.inputForm;
  var grpresult = window.showModalDialog('productCodeAdd.jsp?mode=edit&productcode='+productcode,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-380)/2)+";dialogTop:"+((screen.height-450)/2)+";dialogHeight:350px;dialogWidth:450px");
  if(grpresult && (grpresult=='yes')){
    fm.mode.value = '';
    fm.submit();
  }
}
</script>
<!--end-->
<form name="inputForm" action="productCode.jsp">
<input type="hidden" name="mode" value=""/>
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<script language="JavaScript">
  if(parent.frames.length>0)
    parent.document.all.main.style.height="880";
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td>
      <table align="center" width="100%"  border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr >
          <td height="26" colspan="5" align="center" class="text-title" background="image/n-9.gif">Product Code Management</td>
        </tr>
        <tr >
          <td height="10" colspan="5" align="center" class="text-title">&nbsp;</td>
        </tr>

        <tr>
          <td align="left">Product Code
            <input type="text" value="<%=prodcode%>" name="prodcode" class="input-style0"  maxlength="20"/>
          </td>

          <td align="left">OperType
            <select name="opertype" size="1" class="input-style1" style="width:210">
            	<option value="0" <%=("0".equals(opertype))?" selected ":""%>>All operation</option>
                <option value="1" <%=("1".equals(opertype))?" selected ":""%>>CMT Monthly Subscription Fee</option>
                <option value="2" <%=("2".equals(opertype))?" selected ":""%>>Corporate CMT Monthly Subscription</option>
                <option value="3" <%=("3".equals(opertype))?" selected ":""%>>Monthly Content Fee</option>
                <option value="4" <%=("4".equals(opertype))?" selected ":""%>>Juke Box</option>
                <option value="5" <%=("5".equals(opertype))?" selected ":""%>>Music Station</option>
              </select>
          </td>


          <td align="left">SP Code
            <input type="text" value="<%=spcode%>" name="spcode" class="input-style2"  maxlength="20"  />
          </td>
          <td align="right"><img src="button/search.gif" alt="Find group" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"></td>
          <td align="right"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()" alt="Add product code"/></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td width="100%" align="center">
      <table width="100%" border="0" cellspacing="1" cellpadding="1" align="left" class="table-style4">
         <tr class="tr-ringlist">
           <td  height="30" width="60">
             <div align="left"><font color="#ffffff">Product Code</font></div>
           </td>
           <td height="30" width="90">
             <div align="left"><font color="#ffffff">Operation Type</font></div>
           </td>
           <td height="30" width="50">
             <div align="left"><font color="#ffffff">Spcode</font></div>
           </td>
           <td height="30" width="100">
             <div align="center"><font color="#ffffff">Description</font></div>
           </td>
           <td height="30" width="20">
             <div align="center"><font color="#ffffff">Info</font></div>
           </td>
           <td height="30" width="20">
             <div align="center"><font color="#ffffff">Edit</font></div>
           </td>
           <td height="30" width="20">
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

        <td height="20"><div align="left"><%= (String)hash.get("prodcode") %></div></td>
        <td height="20"><div align="left"><%= productCode.getOpertypeDesc((String)hash.get("opertype")) %></div></td>
        <td height="20"><div align="left"><%= (String)hash.get("spcode") %></div></td>
        <td height="20"><div align="left"><%= (String)hash.get("description") %></div></td>
        <td height="20"><div align="center"><img src="../image/info.gif"   width=15 height=15 alt="Info" onMouseOver="this.style.cursor='hand'" onclick="showInfo('<%=(String)hash.get("prodcode")%>');"></div></td>
        <td height="20"><div align="center"><img src="../image/edit.gif"   width=15 height=15 alt="Edit" onMouseOver="this.style.cursor='hand'" onclick="editInfo('<%=(String)hash.get("prodcode")%>')"></div></td>
        <td height="20"><div align="center"><img src="../image/delete.gif" width=15 height=15 alt="Delete" onMouseOver="this.style.cursor='hand'" onclick="delInfo('<%=(String)hash.get("prodcode")%>')"></div></td>
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
          <td class="table-style2">&nbsp;Total:<%= resultList.size() %>,&nbsp;&nbsp;<%=  resultList.size()%25==0?resultList.size()/25:resultList.size()/25+1 %>&nbsp;page(s),&nbsp;&nbsp;Now on Page &nbsp;<%= thepage+1 %>&nbsp;</td>
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
<input type="hidden" name="historyURL" value="productCode.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

