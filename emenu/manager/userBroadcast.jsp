<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manUser" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Operation AD broadcast</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="JavaScript:initform(document.forms[0])" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    // add for starhub
	String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
	try {
        sysTime = manUser.getSysTime() + "--";
      if (operID != null && purviewList.get("1-7") != null) {

	zxyw50.Purview purview = new zxyw50.Purview();

        String sUserNumber = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();


        manUser manuser = new manUser();
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String scp = request.getParameter("scplist") == null ? "" : (String)request.getParameter("scplist");
        String sEnddate = request.getParameter("enddate") == null ? "" : (String)request.getParameter("enddate");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));

        ArrayList vet = new ArrayList();
        HashMap  hash1 = new HashMap();
        HashMap hash = new HashMap();
        if(!op.equals("")){
         if(sUserNumber.equals("")){
          if(!purview.CheckOperatorRightAllSerno(session,"1-7")){
             throw new Exception("You have no right to manage this service area!");
          }
         }else{
          if(!purview.CheckOperatorRight(session,"1-7",sUserNumber)){
            	throw new Exception("You have no right to manage this subscriber!");
          }
         }
         vet = manuser.queryNoBuyUser(scp,sEnddate, sUserNumber);
        }
        int rowcount = 0;
        int pages = vet.size()/25;
        if(pages > thepage)
            rowcount = 25;
        else
          rowcount = vet.size()- pages * 25 ;
       if(vet.size()==0) rowcount = 0;
       if(vet.size()%25>0)
           pages = pages + 1;
        String userNumber = (String)session.getAttribute("USERNUMBER");
        HashMap map = new HashMap();

        String  optSCP ="";
        ArrayList scplist = manuser.getScpList();
         for (int i = 0; i < scplist.size(); i++) {
               if(i==0 && scp.equals(""))
                  scp = (String)scplist.get(i);
               optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
          }
%>



<script language="javascript">

   var v_UserNumber = new Array(<%= rowcount + "" %>);
<%
   for (int i =0 ; i <  rowcount; i++) {
                hash = (HashMap)vet.get( thepage * 25 +i );
%>
   v_UserNumber[<%= i + "" %>] = '<%= (String)hash.get("usernumber") %>';
<%
    }
%>
   var datasource;
   function modeChange(){
      document.forms[0].searchvalue.value = '';
      document.forms[0].searchvalue.focus();
   }

   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.op.value = 'search';
      document.inputForm.submit();
   }

   function tryListen (ringID,ringName,ringAuthor) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }

   function searchRing () {
      var fm = document.inputForm;
      if(fm.selectedIndex == -1){
         alert('Please select SCP!');
         return;
      }
      var  sTmp  = '';
      sTmp = trim(fm.usernumber.value);
      if(sTmp!='' ){
         if(!checkstring('0123456789',sTmp)){
              alert("The prefix of <%=user_number%> must be a digital number,please re-enter!");//User number前缀必须是数字,请重新输入!
              fm.usernumber.focus();
	      return
         }
      }
      sTmp = trim(fm.enddate.value);
      if(sTmp == ''){
         alert("Please enter the end date!");//请输入截止日期!
         fm.enddate.focus();
         return;
      }
      if(!checkDate2(sTmp)){
	 alert("The end date's format is yyyy.mm.dd,please re-enter!");//截止日期输入格式为yyyy.mm.dd,请重新输入!
	 fm.enddate.focus();
	 return
      }
      if(!checktrue2(sTmp)){
	 alert("The end date cannot be later than the current time!");
	 fm.enddate.focus();
	 return
      }
      fm.page.value = 0;
      fm.op.value = 'search';
      fm.submit();
   }
   function goPage(){
      var fm = document.inputForm;
      var pages = parseInt(fm.pages.value);
      var thispage = parseInt(fm.page.value);
      var thepage =parseInt(trim(fm.gopage.value));

      if(thepage==''){
         alert("Please specify the value of the page to go to!");//Please specify the value of the page to go to!
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
         alert("The value of the page to go to can only be a digital number!");//The value of the page to go to can only be a digital number
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!");//alert("转到的页码值范围不正确  页）!
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      if(thepage==thispage){
         alert("The entered page is current page,please re-enter!");//This page has been displayed currently. Please re-specify a page!
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }
   function oncheckbox(sender,userNumber){
       var fm = document.inputForm;
       var userList = fm.userlist.value;
       var sTmp = "";
       if(sender.checked){
           fm.userlist.value = userList + userNumber  + "|";
           return;
       }
       var idd = userList.indexOf("|");
       while( idd > 0){
	      if(userList.substring(0,idd)==userNumber){
	         sTmp = sTmp + userList.substring(idd+1);
	         break;
	      }
	      sTmp = sTmp +  userList.substring(0,idd) + '|';
	      userList = userList.substring(idd + 1);
	      idd =-1;
	      if(userList.length>1)
	         idd  = userList.indexOf("|");
	   }
	   fm.userlist.value = sTmp;
fm.selectall.checked = false;
	   return;
   }
  function checkInfo(){
     var fm =  document.inputForm;
     var value = trim(fm.message.value);
     if(value == ''){
          alert("Please enter the content of SMS!");//请输入发送短信内容!
          fm.message.focus();
          return false;
      }
      if(strlength(value)>120){
          alert("The length of SMS can't longer than 120 character,please re-enter!");//短信内容不能超过120个字节,请重新输入!
          fm.message.focus();
          return false;
     }
     return true;
  }

  function  onCollection(){
     var fm = document.inputForm;
     var userList = trim(fm.userlist.value);
     if(userList==''){
        alert("Please select the personal ringtone to transform system ringtone!");//请选择要转化为系统铃音的用户个人铃音!
        return;
     }
     if(!checkInfo())
        return;
     var userArray =  userList.split('|');
     var conf = 'The content of this SMS is ' + fm.message.value +'\n';
     conf = conf + ' The SMS will be send to :\n\n';
     for(var i=0; i<userArray.length-1; i++ )
        conf = conf + eval(i+1) + '. ' + userArray[i] + '\n';
     conf = conf + " \n" + eval(userArray.length-1) + " enters in total, Are you confirm?";
     if(!confirm(conf))
        return;
     fm.action = 'userBroadcastEnd.jsp';
     fm.submit();
  }
  function searchCatalog(){
     var dlgLeft = event.screenX;
     var dlgTop = event.screenY;
     var result =  window.showModalDialog("treeDlg.html",window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+dlgLeft+";dialogTop:"+dlgTop+";dialogHeight:250px;dialogWidth:215px");
     if(result){
         var name = getRingLibName(result);
         document.inputForm.ringlib.value=result;
         document.inputForm.ringcatalog.value=name;
     }
 }

 function getRingLibName(id){
     for(var i = 0;i<datasource.length;i++){
        var row =  datasource[i];
        if(row[0] == id)
           return row[2];
     }
 }
 function onSelectAll(){
      var fm = document.inputForm;
      var userList = "";
      if(fm.selectall.checked){
         for(var i=0;i<v_UserNumber.length; i++){
            eval('document.inputForm.crbt'+v_UserNumber[i]).checked = true;
            userList = userList +v_UserNumber[i] + '|';
         }
      }
      else {
          for(var i=0;i<v_UserNumber.length; i++)
            eval('document.inputForm.crbt'+v_UserNumber[i]).checked = false;
      }
      fm.userlist.value = userList;
      return;
   }

    function initform(pform){
      var  temp = "<%= scp %>";
       pform.scplist.value = temp;
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
	hei = 600 + (<%= vet.size()%>-10)*20;

<%
	}else{
%>
	hei = 900;

<%
}
%>
	parent.document.all.main.style.height=hei;
	}
</script>
<form name="inputForm" method="post" action="userBroadcast.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="userlist" value="">
<input type="hidden" name="op" value="">
<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
<tr >
    <td height="26"  align="center" class="text-title" background="image/n-9.gif">Operation AD broadcast</td>
</tr>
<tr>
    <td  width="100%" align="center">
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="100%" align="center">
        <tr>
          <td colspan=3 >Select SCP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
             <select name="scplist" size="1" style="width:120px">
              <% out.print(optSCP); %>
             </select>
           </td>
        </tr>
        <tr>
         <td >
           Prefix of <%=user_number%><br><input type="text" name="usernumber" value="<%= sUserNumber %>" maxlength="30" class="input-style7" style="width:120" >
         </td>
         <td >
           End date(yyyy.mm.dd)<br><input type="text" name="enddate" value="<%= sEnddate %>" maxlength="10" class="input-style7" style="width:120" >
          </td>
         <td><img src="button/search.gif" alt="search" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing()"></td>
        </tr>

      </table>
   </td>
  </tr>
  <tr>
    <td width="100%" align="center">
      <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center" class="table-style4">
         <tr class="tr-ringlist">
               <td height="30" width="20%">
                  <div align="center">Selected flag</div>
                </td>
                <td height="30" width="40%">
                  <div align="center"><%=user_number%></div>
                </td>
                <td height="30" width="40%">
                    <div align="center">The time of last modify <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></div>
                </td>
              </tr>
<%
        int count = vet.size() == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash = (HashMap)vet.get(i);
            count++;
%>

        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td align="center"> <input type='checkbox'  name='<%= "crbt"+(String)hash.get("usernumber") %>'  onclick=oncheckbox(this,'<%= (String)hash.get("usernumber") %>') > </td>
        <td height="20" align="center" ><%= (String)hash.get("usernumber") %></td>
        <td height="20" align="center"><%= (String)hash.get("lastbuydate") %></td>
         </tr>
<%
         }
         if(vet.size()==0 && !op.equals("")){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="3" height="20" >No subscribers match the query condition,please re-enter!</td>
         </tr>
        <%
        }
         else if(vet.size()>0){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="3"  height="60"  width="100%">
              <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2" width="98%">
              <tr>
               <td width=50 align="center" > <input type='checkbox' name='selectall'  onclick="javascript:onSelectAll()">Select all</td>
               <td  width=350 align="right"> Content of SMS&nbsp; <input type="text" name="message" value="" maxlength="120" class="input-style7" size=35 > </td>
               <td>&nbsp;<img src="button/send.gif" alt="Send" onmouseover="this.style.cursor='hand'" onClick="javascript:onCollection()" > </td>
              </tr>
              </table>
           </td>
         </tr>
        <%
         }
%>
  </table>
  <%   if (vet.size() > 25) { %>
  <tr>
    <td width="100%" align="center">
      <table border="0" cellspacing="1" cellpadding="1" align="center" class="table-style2"  width="100%">
        <tr>
		    <td align="right">
		    <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
			<tr>
               <td>&nbsp;<%= vet.size() %>&nbsp;enters in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are on page&nbsp;<%= thepage + 1 %>&nbsp;</td>
               <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
               <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
               <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
               <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
             </tr>
			 </table>
		     </td>
		</tr>
        <tr>
          <td  align="right" >
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
</form>
<%
    }
    else {
        if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in first!");
                    document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime +  "Exception occurred in AD broadcast!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Exception occurred in AD broadcast!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="userBroadcast.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
