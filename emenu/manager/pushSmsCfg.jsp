<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.*"%>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");

%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title><%= colorName %> System</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String optLang = "";
    try {
            if (operID != null && purviewList.get("3-35") != null) {
        sysTime = SocketPortocol.getSysTime() + "--";
        manSysPara syspara = new manSysPara();
        String isSuprtMultiLangSms = syspara.getParaValue(20223);
        String langno = request.getParameter("langno") == null ? "2" : transferString((String)request.getParameter("langno")); 
		String selected = "";
		ArrayList languageList = new ArrayList();
		languageList = syspara.getAllLanguageInfo();
		Hashtable lang = new Hashtable();
		if(isSuprtMultiLangSms.trim().equals("1")){
		if(languageList.size()>0){
			for(int j=0; j<languageList.size();j++){
                lang = (Hashtable)languageList.get(j);
				if(langno.equals((String)lang.get("langno"))){
					selected = "selected";
				}else{
					selected = "";
				}				
			    optLang = optLang + "<option value="+(String)lang.get("langno")+" "+selected+" >"+(String)lang.get("langname")+"</option>";
			}
		}
	}
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        ArrayList vet = new ArrayList();

        Hashtable hash = new Hashtable();
		if(isSuprtMultiLangSms.equals("1")){
        vet = syspara.getPushSmsCfgByLangno(langno);
		}else
        vet = syspara.getPushSmsCfg();

        int pages = vet.size()/25;
        if(vet.size()%25>0)
          pages = pages + 1;

%>
<script language="javascript">
   function toPage (page) {
      document.inputForm.page.value = page;
	var isSuprtSmsMultiLang = "<%=isSuprtMultiLangSms%>"; 
	if(isSuprtSmsMultiLang  == 1){		
		document.inputForm.langno.value = document.inputForm.language.options[document.inputForm.language.selectedIndex].value;		
	}
      document.inputForm.submit();
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
         alert("The value of the page to go to can only be a digital number!")
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
         alert("This page has been displayed currently. Please re-specify a page!")
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }
   function editSms (smsno,party,retcode1,langno) {
	 var result =  window.showModalDialog('pushSmsEdit.jsp?smsno='+smsno+'&party='+party+'&retcode='+retcode1+'&langno='+langno,window,"scroll:yes;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-450)/2)+";dialogHeight:500px;dialogWidth:485px");
     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }
   }

   function onChangeLanguage () {
	   var fm = document.inputForm;
	   fm.langno.value = fm.language.options[fm.language.selectedIndex].value;
	   fm.page.value = 0;
	   fm.pages.value = 0;
       fm.submit();
   }
/*
  function delSms (ringid,libid,ringlabel,retcode1) {
	 var result =  window.showModalDialog('delRing.jsp?libid='+libid+'&ringid=' + ringid+'&ringlabel='+ringlabel+'&retcode='+retcode1,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:250px;dialogWidth:410px");
     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }
   }
*/

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
	hei = 900;

<%
}
%>
	parent.document.all.main.style.height=hei;
    }

</script>
<form name="inputForm" method="post" action="pushSmsCfg.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="langno" value="">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<% if(isSuprtMultiLangSms.trim().equals("1")){%>  
<tr class="tr-ringlist">
	  <td>&nbsp;Select Language&nbsp;
	      <select name="language" size="1" style="width:150px" onChange="javascript:onChangeLanguage()">
			  <% out.print(optLang); %>
	      </select>
	  </td>
  </tr>
<%}%>
  <tr>&nbsp;</tr>

  <tr>
    <td width="100%" align="center">
      <table width="98%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style4">
         <tr class="tr-ringlist">
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><span title="Sms No.">Sms No.</span></font></div>
                  </td>
                  <td height="30" width="120">
                    <div align="center"><font color="#FFFFFF"><span title="Description">Description</span></font></div>
                  </td>
                  <td height="30" width="60" >
                    <div align="center"><font color="#FFFFFF"><span title="If valid">If valid</span></font></div>
                  </td>
                  <td height="30"  width="60"  >
                    <div align="center"><font color="#FFFFFF"><span title="Party">Party</span></font></div>
                  </td>
				  <td height="30"  width="60">
					  <div align="center"><font color="#FFFFFF"><span title="ReturnCode">ReturnCode</span></font></div>
				  </td>
                 <td height="30" width="40">
                  <div align="center"><font color="#FFFFFF"><span title="Edit the Sms">Edit</span></font></div>
                </td>
              </tr>

<%
        int count = vet.size() == 0 ? 25 : 0;

        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash = (Hashtable)vet.get(i);
            count++;

%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">

        <td height="20"><%= (String)hash.get("smsno") %></td>
        <td height="20"><%=(String)hash.get("descrip") %></td>
        <% String isvalid = (String)hash.get("isvalid");
         if(isvalid.equals("1")){%>
          <td height="20" align="center">yes</td>
        <%} else {%>
          <td height="20" align="center">no</td>
        <%} String party = (String)hash.get("party");
         if(party.equals("1")){%>
          <td height="20">calling</td>
        <%} else {%>
          <td height="20">called</td>
        <%}%>
		<td>
		<%= (String)hash.get("retcode") %>
		</td>
        <td height="20">
	    <div align="center"><font class="font-ring"><img src="../image/edit.gif"  height='15'  width='15' alt="Edit" onmouseover="this.style.cursor='hand'" onclick="javascript:editSms('<%= (String)hash.get("smsno") %>','<%= (String)hash.get("party") %>','<%= (String)hash.get("retcode") %>','<%= langno %>')"></font></div></td>
        </tr>
<%
         }
        if (vet.size() > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;Total:<%= vet.size() %>,&nbsp&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;page(s).&nbsp;&nbsp;Now on Page &nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
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
</form>
<%
        }
        else {
          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");
                    parent.document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no access to this function!");
              </script>
              <%
              }
         }
    }
   catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + "Exception occourred in the management of Push Sms config!");
        sysInfo.add(sysTime + e.toString());

        vet.add("Error occourred in the management of Push Sms config!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="pushSmsCfg.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
