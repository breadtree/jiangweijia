<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manUser" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    private Vector StrToVector(String str){
	  int index = 0;
	  String  temp = str;
	  String  temp1 ="";
	  Vector ret = new Vector();
	  if (str.length() ==0)
	      return ret;
	  index = str.indexOf("|");
   	  while(index >= 0){
	      if(index==0)
	         temp1 = "&nbsp;";
	      else
	         temp1 = temp.substring(0,index);
	      ret.addElement(temp1);
		  if(index < temp.length())
		     temp = temp.substring(index+1);
		  else
		     break;
		  index = 0;
		  if (temp.length() > 0)
		     index  = temp.indexOf("|");
	  }
	  return ret;
  }

%>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<script src="../pubfun/JsFun.js"></script>
<title>Relieve user black number</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    zxyw50.Purview purview = new zxyw50.Purview();
    try {
        sysTime = manUser.getSysTime() + "--";
        if (operID != null && purviewList.get("1-8") != null) {
           String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
           if (op.equals("set")) {
             String sUserList = request.getParameter("userlist") == null ? "" : ((String)request.getParameter("userlist")).trim();
             Vector vetRing = null;
             vetRing = StrToVector(sUserList);
             Hashtable result = new Hashtable();
%>
<script language="javascript">
   function onBack() {
      var fm = document.inputForm;
      fm.op.value ="";
      fm.submit();
   }
    var hei=450;
   if(parent.frames.length>0){

<%

	if(vetRing==null || vetRing.size()<=5 ){
%>
	hei = 500;
<%
	}else  {
%>
	hei = 500 + (<%= vetRing.size()%>-5)*15;

<%
	}
%>
	parent.document.all.main.style.height=hei;
	}
</script>
<form name="inputForm" method="post" action="userBlack.jsp">
<input type="hidden" name="op" value="">
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" height="200">
<tr>
   <td><img src="../image/pop013.gif" width="400" height="60"></td>
</tr>
<tr>
   <td><img src="../image/pop02.gif" width="400" height="26"></td>
</tr>
<tr>
   <td background="../image/pop03.gif" height="91">
   <table width="98%" cellspacing="1" cellpadding="2" border="0" class="table-style2" align="center">
   <tr>
       <td align="center" colspan=2  height=40>  <font class="font"><b><img src="../image/n-8.gif" width="8" height="8">Relieve user black number</b></font> </td>
   </tr>
   <tr>
        <td align="center" colspan=2>
        <table width="98%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
        <tr class="tr-ringlist">
        <td width="40" align="center">Index</td>
        <td width="80" align="center" >User number</td>
        <td align="center">Result</td>
        </tr>
        <%
         String sNumber = "";
         manUser manuser = new manUser();
         HashMap  map = null;
         for(int i=0;i<vetRing.size()-1;i++){
            sNumber = vetRing.get(i).toString();
            String  res = "Success";
            try  {
                manuser.releaseBlack(sNumber);
            }
            catch (Exception ex){
               res = "Failure," + ex.getMessage();
            }
            sysInfo.add(sysTime + operName + " Unchain user black number " + sNumber + " " + res );
            String color = i == 0 ? "E6ECFF" :"#FFFFFF" ;
            out.print("<tr bgcolor='"+color+"'>");
            out.print("<td >"+Integer.toString(i+1)+"</td>");
            out.print("<td >"+sNumber+"</td>");
            out.print("<td >" + res + "</td>");
            out.print("</tr>");

            // 准备写操作员日志
            map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","108");
            map.put("RESULT","1");
            map.put("PARA1",sNumber);
            map.put("PARA2","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
        }
      %>

      </table>
      <tr>
      <td align="center" colspan=2>
          <img src="../button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="Javascript:submit()">
      </td>
      </tr>
    </table>
    </tr>
	    <tr>
      <td><img src="../image/pop04.gif" width="400" height="23"></td>
    </tr>
  </table>
  <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
    <tr>
      <td>&nbsp;</td>
  </tr>
</table>
</form>
<%
        }
        else {
           manUser manuser = new manUser();
           String sUserNumber = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();

          String scp = request.getParameter("scplist") == null ? "" : (String)request.getParameter("scplist");
           int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
           ArrayList vet = new ArrayList();
           HashMap  hash1 = new HashMap();
           HashMap hash = new HashMap();
           if(!op.equals("")){
              if(sUserNumber.equals("")){
          	if(!purview.CheckOperatorRightAllSerno(session,"1-8")){
             		throw new Exception("You have no right to manage this service area!");
          	}
              }else{
          	if(!purview.CheckOperatorRight(session,"1-8",sUserNumber)){
            		throw new Exception("You have no right to manage this subscriber!");
          	}
              }
              vet = manuser.getBlackUser(scp, sUserNumber);
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
               if(scp.equals((String)scplist.get(i)))
                 optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " selected > " + (String)scplist.get(i)+ " </option>";
               else
                  optSCP = optSCP + "<option value=" + (String)scplist.get(i) + "  > " + (String)scplist.get(i)+ " </option>";
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
      var  sTmp  = '';
      sTmp = trim(fm.usernumber.value);
      if(sTmp!='' ){
         if(!checkstring('0123456789',sTmp)){
              alert("The user number must be a digital number, please re-enter!");//User number前缀必须是数字,请重新输入!
              fm.usernumber.focus();
	      return
         }
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
       if(!sender.checked){
        fm.selectall.checked=false;
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
	   return;
   }
  function  onCollection(){
     var fm = document.inputForm;
     var userList = trim(fm.userlist.value);
     if(userList==''){
        alert("Please select the user to remove the black list!");//请选择您要解除黑名单的用户!
        return;
     }
     fm.op.value = 'set';
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
<form name="inputForm" method="post" action="userBlack.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="userlist" value="">
<input type="hidden" name="op" value="">
<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
<tr >
    <td height="40"  align="center" class="text-title">Unchain the black user</td>
</tr>
<tr>
    <td  width="100%" align="center">
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="100%" align="center">
    <tr>
          <td >Select SCP&nbsp;&nbsp;
             <select name="scplist" size="1" style="width:120px">
              <% out.print(optSCP); %>
             </select>
           </td>
	      <td width="50%">
           User number prefix&nbsp;<input type="text" name="usernumber" value="<%= sUserNumber %>" maxlength="30" class="input-style7" style="width:120" >
          </td>
         <td><img src="button/search.gif" alt="Search" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing()"></td>
        </tr>
      </table>
   </td>
  </tr>
  <tr>
    <td width="100%" align="center">
      <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center" class="table-style4">
         <tr class="tr-ringlist">
               <td height="30" width="20%">
                  <div align="center"><font color="#FFFFFF">Select flag</font></div>
                </td>
                <td height="30" width="40%">
                  <div align="center"><font color="#FFFFFF">User number</font></div>
                </td>
                <td height="30" width="40%">
                    <div align="center"><font color="#FFFFFF">Times of enter the password</font></div>
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
        <td height="20" align="center"><%= (String)hash.get("passerr") %></td>
         </tr>
<%
         }
         if(vet.size()==0 && !op.equals("")){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="3" height="20" >No subscribers match the query condition</td>
         </tr>
        <%
        }
         else if(vet.size()>0){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="3"  height="40"  width="100%">
              <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2" width="98%">
              <tr>
               <td width=70 align="center" >&nbsp;&nbsp;&nbsp;<input type='checkbox' name='selectall'  onclick="javascript:onSelectAll()">Select all</td>
               <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="button/send.gif" alt="Unchain the black number" onmouseover="this.style.cursor='hand'" onClick="javascript:onCollection()" > </td>
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
               <td>&nbsp;<%= vet.size() %>&nbsp;enters in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
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
                   alert( "Sorry, you have no right to access this function!");
              </script>
            <%

        }
    }
  }
   catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime +  "Exception occurred in Unchaining black number!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Errors occurred in Unchaining black number!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="userBlack.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
