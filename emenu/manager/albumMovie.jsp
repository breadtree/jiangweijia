 <%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Search Album or Movie Details</title>
 <base target="_self" />
</head>
<body topmargin="0" leftmargin="0" class="body-style1">

<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
  
    try {
       if (operID != null && purviewList.get("2-66") != null) {
        sysTime = SocketPortocol.getSysTime() + "--";
        String oper = request.getParameter("oper") == null ? "" : transferString((String)request.getParameter("oper"));
      
//        String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
//        String sortby =  "" ;
        String searchkey = request.getParameter("searchkey") == null ? "ID" : (String)request.getParameter("searchkey");
		String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
		String type = request.getParameter("type") == null ? "" : (String)request.getParameter("type");
		String idType = type.equals("") ? "" : type.equals("1") ? "Album" : type.equals("2") ? "Movie": "" ;
		System.out.println(" idType --------------------------------> "+idType); // remove this 
		/*if(!type.equals("")){
			if(type.equals("1")){
				idType = "Album";
			} else if(type.equals("2")) {
				idType = "Album"
			}
		} */
		int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        ArrayList vet = new ArrayList();
        Hashtable hash1 = new Hashtable();
        HashMap hash = new HashMap();
        ColorRing  colorring = new ColorRing();
        hash1.put("searchvalue", searchvalue);
        hash1.put("searchkey", searchkey);
        hash1.put("functype", type); // 3 - Ring
       // hash1.put("sortby",sortby);

		vet = colorring.getExtraRingFuncInfo(hash1);
		System.out.println(" vet size ----------------------------------->  "+vet.size()+"type ---> "+type); // remove this 
        int pages = vet.size()/25;
        if(vet.size()%25>0){
          pages = pages + 1;
		}
%>

<script language="javascript">
   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }

 
   function searchRing() {
      fm = document.inputForm;
        if (trim(fm.searchvalue.value) != '') {
          if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ID'){
              alert("The ID can only be a digital number!");
              fm.searchvalue.focus();
              return;
          }
          
      }
      fm.page.value = 0;
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
         alert("This page has been displayed currently. Please re-specify a page!");//This page has been displayed currently. Please re-specify a page!
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }

   function confirm (ringinfo) {
	//   alert(" confirm -- >  "+ringinfo);
     window.returnValue = ringinfo;
     window.close();
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
	hei = 900;

<%
}
%>
	parent.document.all.main.style.height=hei;
    }

</script>

<form name="inputForm" method="post" action="albumMovie.jsp?oper=<%=oper%>">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="type" value="<%= type %>">


<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
 <tr>
    <td width="100%">
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td width="10"></td>
		  <td>
            Select type
            <select size="1" name="searchkey" class="select-style5"  style="width:140px">
              <option value="ID"><%= idType%> Code</option>
              <option value="Label"> <%= idType%> Name</option>
            </select>
          </td>
          <td id="id_keyshow" >Keyword
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" >
          </td>
          <td><img src="../button/search.gif" alt="Search <%= idType%>"  onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
        </tr>
        <tr>
          <td colspan="4">
              &nbsp;
          </td>
        </tr>
      </table>
    </td>
  </tr>
<script language="javascript">
   if ('<%= searchkey %>' != '-1') {
      document.inputForm.searchkey.value = '<%= searchkey %>';
  }
</script>
  <tr>
    <td width="100%" align="left">
      <table width="95%" border="0" cellspacing="1" cellpadding="1" align="left" class="table-style4">
         <tr class="tr-ring">
                <td height="30" width="30%">
                    <div align="center"><font color="#FFFFFF"> Code </font></div>
                  </td>
                  <td height="30" width="50%">
                    <div align="center"><font color="#FFFFFF"> Name </font></div>
                  </td>
                
                <%if(!oper.equals("manager") ){%>
                <td height="30" width="15%">
                  <div align="center"><font color="#FFFFFF">Confirm</font></div>
                </td>
               <% } %>
              </tr>

<%
        int count = vet.size() == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash = (HashMap)vet.get(i);
            count++;
 %>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td height="20"><%= (String)hash.get("funcid") %></td>
        <td height="20"><%= (String)hash.get("funcname") %></td>
          <%if(!oper.equals("manager") ){%>
        <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/icon_search.gif" alt="Select this ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:confirm('<%= (String)hash.get("funcid") %>#<%= (String)hash.get("funcname") %>')"></font></div></td>
        </tr>
<%
			}
         }
        if (vet.size() > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="95%" align="left">
      <table border="0" cellspacing="1" cellpadding="1" align="left" class="table-style2">
        <tr>
          <td>&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on Page &nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
        </tr>
        <tr>
          <td colspan="6" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >page&nbsp;</td>
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
                    parent.document.URL = 'enter.jsp';
		    window.close();
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
        sysInfo.add(sysTime + " Exception occurred in managing Album or Movie search!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Errors occurred in managing Album or Movie search!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="albumMovie.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
