<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<script src="../pubfun/JsFun.js"></script>
<%
    int PAGE_ROW_NUM = 16; //每页的行数
    int iCurPage = request.getParameter("page") == null ? 0 : Integer.parseInt(request.getParameter("page").trim());
     ColorRing colorRing = new ColorRing();
     ArrayList vet = colorRing.getGroupRings();
     //数据总数
     int iRingCount = vet.size();
     //计算页数
     int iPages = iRingCount / PAGE_ROW_NUM;
     if (iRingCount % PAGE_ROW_NUM != 0)
     {
       iPages += 1;
     }
%>
<html>
<head>
<title>Untitled file</title>

<link href="style.css" type="text/css" rel="stylesheet">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
</head>
<script language="JavaScript">

 function tryListen (ringID, ringname, ringauthor,mediatype) {
      var tryURL = '../manager/tryListen.jsp?ringid=' + ringID +'&ringname='+ringname+'&ringauthor='+ringauthor+ '&mediatype='+mediatype;
      if(trim(mediatype)=='1'){
               preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='4'){
        tryURL = '../tryView.jsp?ringid=' + fm.crid.value+'&ringname='+v_ringlabel[index]+'&ringauthor='+v_ringauthor[index] + "'&usernumber=&mediatype="+v_mediatype[index];
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }
   }

   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }
   function goPage(){
      var fm = document.inputForm;
      if(fm.gopage.value==''){
         alert("Please specify the value of the page to go to!")
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',fm.gopage.value)){
         alert("The value of the page must be a digital number!")
         fm.gopage.focus();
         return;
      }
      var iPages=parseInt(fm.pagecount.value);
      var iGoPage =parseInt(trim(fm.gopage.value));
      if(iGoPage<=0 || iGoPage>iPages ){
         alert("Invalid range of page!");
         fm.gopage.focus();
         return;
      }
      iGoPage = iGoPage -1;
      toPage(iGoPage);
   }

</script>

<body>
<form name="inputForm" method="post" action="main.jsp">
<input type="hidden" name="page" value="<%= iCurPage %>">
<input type="hidden" name="pagecount" value="<%=iPages%>"-->
  <%
   //add by ge quanmin 2005.07.29
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
	if(ringdisplay.equals(""))
          ringdisplay = "ringtone";
  %>
<table width="602" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
            <div align="right"><img src="image/corpringbanner.gif" width="602" height="109"></div>
          </td>
        </tr>
      </table>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>&nbsp;</td>
        </tr>
      </table>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="135"><img src="image/corpring03.gif" width="135" height="40"></td>
          <td background="image/corpring03bg.gif">&nbsp;</td>
          <td width="78"><img src="image/corpring04.gif" width="78" height="40"></td>
        </tr>
      </table>
      <table width="100%"  border="0" cellspacing="1" cellpadding="1">
        <tr>
          <td bgcolor="#FFFFFF">
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td background="image/index_r30_c6.gif"><img src="image/index_r30_c6.gif" width="5" height="5"></td>
              </tr>
            </table>
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style1"  >
              <tr  class="tr-ringlist2">
                <td width="111" height="31">
                  <div align="center" class="font2">Group <%=ringdisplay%> name</div>
                </td>
                <td width="286" height="31">
                  <div align="center" class="font2">Group name</div>
                </td>
                <td width="120" height="31" >
                  <div align="center" class="font2">Time</div>
                </td>
                <td width="62" height="31">
                  <div align="center" class="font2">Try listen</div>
                </td>
              </tr>
              <%
              HashMap hash=null;
              int iStart = iCurPage * PAGE_ROW_NUM;
              int iEnd = iCurPage * PAGE_ROW_NUM + PAGE_ROW_NUM > iRingCount ? iRingCount : iCurPage * PAGE_ROW_NUM + PAGE_ROW_NUM;
              for (int i = iStart; i < iEnd ; i++) {
    hash = (HashMap)vet.get(i);
    %>
              <tr>
                <TD background=image/bg_header.gif colSpan=4 height=1><IMG height=1  src="image/spacer.gif" width=1></TD>
              </tr>
              <tr >
                <td height="20" align="center"><%= getLimitString((String)hash.get("ringlabel"),20) %></td>
                <td height="20" align="center"><%=  getLimitString((String)hash.get("groupname"),30) %></td>
                <td height="20" align="center"><%= (String)hash.get("uploadtime") %></td>
                <td height="20" align="center">
                  <div align="center"> <font color="#CC9900"><font class="font-ring"><img src="image/play.gif" onmouseover="this.style.cursor='hand'"
                    onClick="javascript:tryListen('<%= (String)hash.get("ringid") %>', '<%= (String)hash.get("ringlabel") %>', '<%= (String)hash.get("groupname") %>','<%= (String)hash.get("mediatype") %>')"></font></font></div>
                </td>
              </tr>
              <%}%>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>

  <tr> <td width="100%">
<%
if (iRingCount > PAGE_ROW_NUM) {
%>
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;<%= iRingCount %>&nbsp;entries in total&nbsp;<%= iPages%>&nbsp;pages&nbsp;&nbsp;You are now on page&nbsp;<%= iCurPage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= iCurPage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (iCurPage - 1)+ ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= iCurPage + 1 >= iPages ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (iCurPage + 1)  + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= iPages - 1 %>)"></td>
        </tr>
        <tr>
          <td colspan="5" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >Page&nbsp;</td>
             <td> <input style=text value="<%= String.valueOf(iCurPage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
             <td ><img src="../button/go.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:goPage(<%=iPages%>)" ></td>
            </tr>
            </table>
          </td>
       </tr>
      </table>
    </td>
  </tr>
<%}%>

</table>
</form>
<div align="center"></div>
</body>
</html>
