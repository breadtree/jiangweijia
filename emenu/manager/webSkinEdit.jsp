<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.WebSkinVO" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%   String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
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

	  String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

    try {

        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
      if (operID != null && purviewList.get("3-31") != null) {

        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The keyword you input exceeds the limit,please re-enter!");//您输入的关键字长度超出限制,请重新输入!
//        String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
        String sortby =  "" ;
        //String libid = request.getParameter("ringlib") == null ? "0" : (String)request.getParameter("ringlib");
        //String spindex = request.getParameter("spindex") == null ? "0" : (String)request.getParameter("spindex");
        String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        WebSkinVO vo =new WebSkinVO();
        ArrayList vet = new ArrayList();
        vet = (ArrayList) syspara.getWebSkinList();

        int pages = vet.size()/25;
        if(vet.size()%25>0)
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
   function editurl (itemno) {
    window.location.href = "webSkinInfo.jsp?itemno="+itemno;
   }
   function changePic (filename, filepath) {
     var uploadURL = 'uploadPic.jsp?filecode=' + filename+'&filepath='+filepath;
      uploadRing = window.open(uploadURL,'uploadpic','width=400, height=200');
   }
function downloadPic(filename, filepath)
{

window.location.href="downloadPic1.jsp?filename="+filename+"&filepath="+filepath;

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
<form name="inputForm" method="post" action="webSkinEdit.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr>
    <td width="100%">
    <table width="98%" border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr >
          <td height="26" colspan="9" align="center" class="text-title" background="image/n-9.gif">Web Skin Management</td>
        </tr>
          <td colspan="8">
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
                <td height="30" width="80">
                    <div align="center"><font color="#FFFFFF"><span title="Item name">Name</span></font></div>
                  </td>
                  <td height="30" width="120">
                    <div align="center"><font color="#FFFFFF"><span title="File name">File name</span></font></div>
                  </td>

                  <td height="30"  width="40"  >
                    <div align="center"><font color="#FFFFFF"><span title="Item Length">Length</span></font></div>
                  </td>

                  <td height="30" width="40" >
                    <div align="center"><font color="#FFFFFF"><span title="Item Width">Width</span></font></div>
                  </td>

		  <td height="30" width="60">
                  <div align="center"><font color="#FFFFFF"><span title="URL type">URL type</span></font></div>
                </td>
                <td height="30" width="60" style="display:none">
                  <div align="center"><font color="#FFFFFF"><span title="Link URL or Code">Link URL or Code</span></font></div>
                </td>
                 <td height="30" width="30">
                  <div align="center"><font color="#FFFFFF"><span title="Edit URL">Edit</span></font></div>
                </td>
                 <td height="30" width="30">
                  <div align="center"><font color="#FFFFFF"><span title="Picture Download">Download</span></font></div>
                </td>
                 <td height="30" width="30">
                  <div align="center"><font color="#FFFFFF"><span title="Picture Replace">Replace</span></font></div>
                </td>
              </tr>

<%
        int count = vet.size() == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            vo = (WebSkinVO)vet.get(i);
            count++;

%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">

        <td height="20"><%= vo.getItemname()%></td>
        <td height="20"><%= vo.getFilename() %></td>

        <td height="20"><%= vo.getItemlength() %></td>

        <td height="20"><%= vo.getItemwidth() %></td>

        <td height="20">
        <%if(vo.getUrltype()==0){%>
        No Link
        <%}else if(vo.getUrltype()==1) {%>
        Outer Link
        <%}else if(vo.getUrltype()==2) {%>
        Singer
        <%}else if(vo.getUrltype()==3) {%>
        Music Station
        <%}else if(vo.getUrltype()==4) {%>
        Music jukebox
        <%}else{%>
        No Link
       <% }%>
        </td>

        <td height="20" style="display:none">
        <%= vo.getUrl()%>
        </td>

       <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/edit.gif" alt="Edit" onmouseover="this.style.cursor='hand'" onclick="javascript:editurl('<%= vo.getItemno() %>')"></font></div>
       </td>
       <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/buy.gif" alt="Download picture" onmouseover="this.style.cursor='hand'" onclick="javascript:downloadPic('<%= vo.getFilename() %>', '<%= vo.getFilepath() %>')"></font></div>
       </td>
       <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/manage.gif" alt="Replace picture" onmouseover="this.style.cursor='hand'" onclick="javascript:changePic('<%= vo.getFilename() %>', '<%= vo.getFilepath() %>')"></font></div>
       </td>

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
<tr>
          <td colspan="8" > <table border="0" width="100%" class="table-style2">
              <tr><td height=10 > &nbsp;&nbsp;</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;Notes:</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. You can click the download button to backup the current picture to your local disk.</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. You can click the replace button to replace the current picture in system with the picture in your local disk.</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. If you haved replaced one picture, you can find the picture be replaced with the .bak extend file name in the same directory. </td></tr>
                      </table>
           </td>
          </tr>
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
        sysInfo.add(sysTime + "Exception occourred in the management of Web Skin!");// 系统铃音管理过程出现异常!
        sysInfo.add(sysTime + e.toString());
       // vet.add("系统铃音管理过程出现错误!");
        vet.add("Error occourred in the management of Web Skin!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="webSkinEdit.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
