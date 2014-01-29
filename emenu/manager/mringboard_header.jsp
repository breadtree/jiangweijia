<%@ page import="zte.zxyw50.util.*" %>
<%@ page import="com.zte.tao.util.JspUtil" %>
<%
    String aValue = JspUtil.getSafeParameterUnencode("searchvalue",request);
    int searchvalue = Integer.parseInt(com.zte.tao.util.StringUtil.isEmpty(aValue)? "0" : aValue);
    String buy =JspUtil.getSafeParameterUnencode("buy",request);
    String showlargess =JspUtil.getSafeParameterUnencode("showlargess",request);
%>
<form name="inputForm" method="post" action="mringboard.jsp">
	<input type="hidden" name="buy" value="<%=buy%>"/>
	<input type="hidden" name="showlargess" value="<%=showlargess%>"/>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
  <td height="26"  align="center" class="text-title"  background="image/n-9.gif">Query By Board</td>
   </tr>
   <tr>
   	<td>&nbsp;</td>
   </tr>
   <%if (searchvalue != 4 && searchvalue != 6&&searchvalue!=7)
   //4 特别专区  6 广告铃音 7 随意铃专区 当显示为这两个页面时不需要显示排行榜列表
   {%>
   <tr>
     <td width="100%" class="table-style2">&nbsp;&nbsp;<i18n:message key='UserMSG0031900' />&nbsp;&nbsp;
       <select size="1" name="searchvalue" class="select-style3" onchange="javascript:ChangeBoard()">
         <option <%=searchvalue == 0 ? "selected" : ""%> value="0"><i18n:message key='UserMSG0031901' /></option>
         <option <%=searchvalue == 1 ? "selected" : ""%> value="1"><i18n:message key='UserMSG0031902' /></option>
         <option <%=searchvalue == 2 ? "selected" : ""%> value="2"><i18n:message key='UserMSG0031903' /></option>
         <!--<%if("1".equals(CrbtUtil.getConfig("showzuixin","0"))){%>
         <option <%=searchvalue == 5 ? "selected" : ""%> value="5"><%=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0031904","1",zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay", "CRBT"))%></option>
         <%}if("1".equals(CrbtUtil.getConfig("ifringrecommend","0"))){%>
         <option <%=searchvalue == 3 ? "selected" : ""%> value="3"><i18n:message key='UserMSG0031905' /></option>-->
		  <option <%=searchvalue == 5 ? "selected" : ""%> value="5"><%=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0031904","1"	
		  ,zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay", "CRBT"))%></option>
		 <option <%=searchvalue == 3 ? "selected" : ""%> value="3"><i18n:message key='UserMSG0031905' /></option>
		 <!--<option <%=searchvalue == 10 ? "selected" : ""%> value="10">Daily Billboard</option>-->
         <%}%>
       </select>
     </td>
   </tr>
   <%}%>
</table>
<script type="text/javascript">
<!--
	function ChangeBoard(){
		    document.inputForm.page.value = 0;
			document.inputForm.submit();
		 }
//-->
</script>

