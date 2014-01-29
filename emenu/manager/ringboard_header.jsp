<%@ page import="zte.zxyw50.util.*" %>

<%@ page import="com.zte.tao.util.JspUtil" %>
<%
    String aValue = JspUtil.getSafeParameterUnencode("searchvalue",request);
    int searchvalue = Integer.parseInt(com.zte.tao.util.StringUtil.isEmpty(aValue)? "0" : aValue);
%>
<form name="inputForm" method="post" action="ringboard.action">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
      <td valign="top" bgcolor="#FFFFFF"><%@include file="common_header.jsp"%></td>
   </tr>
   <%if (searchvalue != 4 && searchvalue != 6&&searchvalue!=7)
   //4 特别专区  6 广告铃音 7 随意铃专区 当显示为这两个页面时不需要显示排行榜列表
   {%>
   <tr>
     <td width="100%" class="table-style2">&nbsp;&nbsp;Billboard&nbsp;&nbsp;
       <select size="1" name="searchvalue" class="select-style1" onchange="javascript:submit()">
         <option <%=searchvalue == 0 ? "selected" : ""%> value="0">Total billboard</option>
         <option <%=searchvalue == 1 ? "selected" : ""%> value="1">Monthly billboard</option>
         <option <%=searchvalue == 2 ? "selected" : ""%> value="2">weekly billboard</option>
         <%if("1".equals(CrbtUtil.getConfig("showzuixin","0"))){%>
         <option <%=searchvalue == 5 ? "selected" : ""%> value="5">the latest ringtone</option>
         <%}if("1".equals(CrbtUtil.getConfig("ifringrecommend","0"))){%>
         <option <%=searchvalue == 3 ? "selected" : ""%> value="3">the latest recommendation</option>
         <%}%>
       </select>
     </td>
   </tr>
   <%}%>
</table>
</form>

