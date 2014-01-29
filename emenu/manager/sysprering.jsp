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
<%    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
    String useweekstar = CrbtUtil.getConfig("weekstar","0");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title><%= colorName %> System</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1"  >
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    int iDispOpcode = 0;

    try {
            if (operID != null && purviewList.get("2-32") != null) {
        sysTime = SocketPortocol.getSysTime() + "--";
        manSysRing sysring = new manSysRing();

        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
        String allindex = request.getParameter("allindex_h") == null ? "" : transferString((String)request.getParameter("allindex_h")).trim();
        String ringindex = request.getParameter("ringindex_h") == null ? "" : transferString((String)request.getParameter("ringindex_h")).trim();
        String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();

        String title = "";

         int  optype = 0;
         ArrayList rList = new ArrayList();
		 ArrayList aExtraInfoList = new ArrayList();
		 if (op.equals("add")){
             optype =1;
             ringindex = sysring.getRingIndex("",ringid);
             title = "Add System Pretone Ring";
            }
         if(op.equals("del")){
          optype=2;
		  //iDispOpcode=2;
          title="Delete System Pretone Ring";
         }
          if(optype>0){
              rList = sysring.modSysPreRing( String.valueOf(optype),allindex,ringindex);

               if(rList.size()>0){
                session.setAttribute("rList",rList);

             %>
             <form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="sysprering.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
             <%}
          }
        ArrayList list  = new ArrayList();
        HashMap hash = new HashMap();
         list = sysring.getSysPreRing("0");
        int pages = list.size()/25;
        if(list.size()%25>0)
          pages = pages + 1;
%>
<script language="javascript">

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

    function setRingInfo (ringid, allindex)
    {
      var fm = document.inputForm;
      fm.allindex_h.value = allindex;
      fm.ringid.value = ringid;
      fm.op.value = 'add';
      fm.submit();
    }

   function addSysPreRing () {
	 var result =  window.open('syspreringdd.jsp','sysPretoneAdd','width=400, height=280,top='+((screen.height-280)/2)+',left='+((screen.width-400)/2));

     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }

   }
   
   function delSysPrenRing(allindex,ringindex){
     var fm = document.inputForm;
     fm.allindex_h.value = allindex;
     fm.ringindex_h.value = ringindex;
     fm.op.value = 'del';
     fm.submit();
   }


</script>
<script language="JavaScript">
	var hei=600;
	if(parent.frames.length>0){
<%
	if(list==null || list.size()<15 || list.size()==15){
%>
	hei = 600;
<%
	}else if(list.size()>15 && list.size()<25){
%>
	hei = 600 + (<%= list.size()%>-15)*20;
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
<form name="inputForm" method="post" action="sysprering.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="op" value="">
<input type="hidden" name="allindex_h" value="">
<input type="hidden" name="ringindex_h" value="">
<input type="hidden" name="ringid" value="">


<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr>
    <td width="100%">
    <table width="98%" border="0" cellspacing="1" cellpadding="1" class="table-style2">
              <tr >
            <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">System Pretone Manage</td>
          </tr>
        <tr>
          
          <td><img src="button/add.gif" alt="Add system pretone" onmouseover="this.style.cursor='hand'" onclick="javascript:addSysPreRing()"></td>
        </tr>
        <tr>
          <td colspan="4">
              &nbsp;
          </td>
        </tr>
      </table>
    </td>
  </tr>

  <tr>
    <td width="100%" align="center">
      <table width="98%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style4">
         <tr class="tr-ringlist">
                <td height="30" width="70" style="display:none">
                    <div align="center"><font color="#FFFFFF">Allindex</font></div>
                  </td>
                  <td height="30" width="60" style="display:none">
                    <div align="center"><font color="#FFFFFF">Ringtone Index</font></div>
                  </td>
                  <td height="30" width="100">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone code">Ringtone Code</span></font></div>
                  </td>
                  <td height="30" width="100">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone name">Ringtone name</span></font></div>
                  </td>
                  <td height="30" width="60">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone provider">Provider</span></font></div>
                  </td>
                  <td height="30" width="60">
                    <div align="center"><font color="#FFFFFF"><span title="Singer"><%=CrbtUtil.getConfig("authorname","Singer")%></span></font></div>
                  </td>
                  <td height="30" width="60">
                    <div align="center"><font color="#FFFFFF"><span title="Copyright period of validity">Validity</span></font></div>
                  </td>
        
        
		        <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">Delete</font></div>
                </td>
              </tr>

<%
        int count = list.size() == 0 ? 25 : 0;

        for (int i = thepage * 25; i < thepage * 25 + 25 && i < list.size(); i++) {
            hash = (HashMap)list.get(i);
            count++;
%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td height="20" style="display:none"><%= (String)hash.get("allindex") %></td>
        <td height="20" style="display:none"><%= (String)hash.get("ringindex")%></td>
        <td height="20"><%= (String)hash.get("ringid")%></td>
        <td height="20"><%= displayRingName((String)hash.get("ringlabel"))%></td>
        <td height="20"><%= displaySpName((String)hash.get("ringsource"))%></td>
        <td height="20"><%= displayRingAuthor((String)hash.get("ringauthor"))%></td>
        <td height="20"><%= (String)hash.get("validdate")%></td>
        
        <td height="20" width="40" align="center">
          	<img src="../image/delete.gif" height='15'  width='15'  alt="Delete"  height='15'  width='15'  onMouseOver="this.style.cursor='hand'" onclick="javascript:delSysPrenRing('<%= (String)hash.get("allindex") %>','<%= (String)hash.get("ringindex") %>')">
        </td>

   </tr>
<%
         }
        if (list.size() > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;<%= list.size() %>&nbsp;entries in total&nbsp;<%= list.size()%25==0?list.size()/25:list.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on page &nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= list.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (list.size() - 1) / 25 %>)"></td>
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
<table border="0" width="90%" align="left" class="table-style2">
    <tr>
		<td>Notes:</td>
	</tr>
	<tr>
		<td >&nbsp;&nbsp;&nbsp;If there is data in the list, you need to delete before you can add</td>
	</tr>
</table>
</form>
<%
        }
        else {
          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = 'enter.jsp';
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
        e.printStackTrace();
        sysInfo.add(sysTime + operName + " Exception occurs in managing system pretone!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs in managing system pretone!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="sysprering.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
