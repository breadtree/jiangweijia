<%@ page import="zte.zxyw50.util.CrbtUtil" %>
<%@ page import="zte.zxyw50.CRBTContext" %>
<%@ page import="com.zte.tao.IModelData" %>
<%@ page import="com.zte.tao.util.JspUtil" %>

<%
    int largessflag = CrbtUtil.getConfig("disLargess", 0);
    String ringdisplay = CrbtUtil.getConfig("ringdisplay", "ringback tone");
    String colorName = CrbtUtil.getConfig("colorname", "CRBT");
    IModelData[] spInfo = CRBTContext.querySpInfo(true);
   // String strSpvalue = request.getParameter("searchvalue") == null ? "0" : request.getParameter("searchvalue");
    //String strSortBy = request.getParameter("sortby") == null ? "s50ring.buytimes" : request.getParameter("sortby");
    String strSpvalue=JspUtil.getSafeParameterUnencode("searchvalue",request,"0");
    String strSortBy=JspUtil.getSafeParameterUnencode("sortby",request,"s50ring.buytimes");
%>
<script language="JavaScript" src="../base/JsFun.js"></script>
<script language="JavaScript">
    function searchRing(sortby) {
      fm = document.inputForm;
      if (sortby.length > 0)
      fm.sortby.value = sortby;
      if (trim(fm.searchvalue.value) == '') {
        alert("Please enter the querying condition!");
        fm.searchvalue.focus();
        return;
      }
      fm.submit();
   }
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <form name="inputForm" method="post" action="ringshop.jsp">
  <tr>
      <td valign="top" bgcolor="#FFFFFF"><%@include file="common_header.jsp"%></td>
  </tr>
  <tr>
    <td width="95%" align="center">
    <table>
    <tr>
    <td width="35%">
      <table border="0" cellspacing="0" cellpadding="0" align="right" class="table-style2">
        <tr>
          <td width="28"><img src="image/home_r14_c3.gif" width="28" height="31"></td>
            <a href="searchsinger.jsp" target="main"> <td background="image/home_r14_c5bg.gif" onMouseOver="this.style.cursor='hand'" ><font class="font">By Singer</font></td></a>
            <td width="12"><img src="image/home_r14_c5.gif" width="12" height="31"></td>
          </tr>
       </table>
     </td>
     <td width="30%">
       <table border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
         <tr>
           <td width="28"><img src="image/home_r14_c3.gif" width="28" height="31"></td>
             <a href="searchsong.jsp" target="main"> <td background="image/home_r14_c5bg.gif" onMouseOver="this.style.cursor='hand'" ><font class="font">By Name</font></td></a>
           <td width="12"><img src="image/home_r14_c5.gif" width="12" height="31"></td>
         </tr>
       </table>
     </td>
     <td width="35%">
       <table border="0" cellspacing="0" cellpadding="0" align="left" class="table-style2">
         <tr>
           <td width="28"><img src="image/home_r14_c3.gif" width="28" height="31"></td>
             <a href="ringcatasearch.jsp" target="main"> <td background="image/home_r14_c5bg.gif" onMouseOver="this.style.cursor='hand'" ><font class="font">By Type</font></td></a>
           <td width="12"><img src="image/home_r14_c5.gif" width="12" height="31"></td>
         </tr>
       </table>
     </td>
     </tr>
     </table>
     </td>
    </tr>
    <tr>
      <td width="95%" colspan="3" align="left">
        <table border="0" cellspacing="1" cellpadding="1" class="table-style2">
          <tr>
            <td>&nbsp;&nbsp;&nbsp;&nbsp;<%= colorName %>supermarket</td>
            <td><select name="searchvalue" class="select-style1">
              <option value="0">-all <%=  ringdisplay  %> providers-</option>
              <%
              for (int i = 0; i < spInfo.length; i++) {
                %>
                <option <%=strSpvalue.equals(spInfo[i].getFieldValue("spindex")) ? "selected" : "" %> value="<%= spInfo[i].getFieldValue("spindex")%>">
                  <%= spInfo[i].getFieldValue("spname") %></option>
                <%}%>
              </select>
            </td>
            <td>Sort</td>
            <td>
              <select size="1" name="sortby" class="select-style1" onchange="javascript:document.inputForm.sortby.value = this.value">
                <option <%=strSortBy.equals("s50ring.ringid") ? "selected" : ""%> value="s50ring.ringid"> <%=  ringdisplay  %> Code</option>
                <option <%=strSortBy.equals("s50ring.ringlabel") ? "selected" : ""%> value="s50ring.ringlabel"><%=  ringdisplay  %> Name</option>
                <option <%=strSortBy.equals("s50singer.singgername") ? "selected" : ""%> value="s50singer.singgername">Singer</option>
                <option <%=strSortBy.equals("s50ring.ringfee") ? "selected" : ""%> value="s50ring.ringfee">Price</option>
                <option <%=strSortBy.equals("s50ring.buytimes") ? "selected" : ""%> value="s50ring.buytimes">Order times</option>
                <% if(largessflag!=1){%>
                <option <%=strSortBy.equals("s50ring.largesstimes") ? "selected" : ""%> value="s50ring.largesstimes">Gift times</option>
                <%}%>
                <option <%=strSortBy.equals("s50ring.uploadtime") ? "selected" : ""%> value="s50ring.uploadtime">Time to Lib</option>
              </select>
            </td>
            <td><img src="button/search.gif" alt="Search<%=  ringdisplay  %>" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
         </tr>
       </form>
       </table>

