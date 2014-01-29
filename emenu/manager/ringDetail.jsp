<%@ page import="zte.zxyw50.colorring.domain.CRBTRingDO" %>
<%@ page import="zte.zxyw50.colorring.service.RingServiceImpl" %>
<%@ page import="zte.zxyw50.colorring.util.*" %>
<%@ page import="zte.zxyw50.user.service.UserServiceImpl" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <%@include file="../comminclude.jsp"%>
    <%@include file="../crbt.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%= colorName %> Service</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
function goBack(){
	window.close();
}
</script>
</head>
<%
CRBTRingDO ringInfo = null;
String ringtype = request.getParameter("ringtype");
String ringid = request.getParameter("ringid") == null ? "" : request.getParameter("ringid");
int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
    String usernumber = (String)session.getAttribute(com.zte.tao.constant.SessionConstant.USER_NUMBER);
    if(usernumber==null){
       usernumber=request.getParameter("usernumber")==null?"":request.getParameter("usernumber");
    }
    if ("3".equals(ringtype)){
      ringInfo = (CRBTRingDO)new UserServiceImpl(RingViewHelper.getZteLocale(request)).getPersonalRingInfoByID(usernumber, -1, ringid);
    }else{
      ringInfo = (CRBTRingDO)new RingServiceImpl(RingViewHelper.getZteLocale(request)).getRingInfoByID(ringid, false);
    }
        String buytimes=request.getParameter("buytimes")==null?"":request.getParameter("buytimes");
		String reqpage=request.getParameter("page")==null?"":request.getParameter("page");
		String largesstimes=request.getParameter("largesstimes")==null?"":request.getParameter("largesstimes");

%>
<body class="body-style1"  background="background.gif">
<table border="0" cellspacing="0" cellpadding="0" width="100%"  >
  <tr>
    <td>
	  <table border="0" align="center" class="table-style2">
        <tr>
			<td><img src="../image/spacer.gif" border="0" height="30" /></td>
		</tr> 
		<tr>
          <td class="text-title"><%=ringdisplay %> Details</td>
        </tr>
		<tr>
          <td ><table width="100%" border="0" cellspacing="4" cellpadding="0">
             <tr><td><%= getArgMsg(request,"UserMSG0035900","1",ringdisplay)%></td>
              <td ><%= zte.zxyw50.util.CrbtUtil.toString(ringInfo.getRingid())%></td>
             </tr>
            <tr>
              <td><%= getArgMsg(request,"UserMSG0035901","1",ringdisplay)%></td>
              <td><%= zte.zxyw50.util.CrbtUtil.toString(ringInfo.getName())%></td>
              </tr>
            <tr>
              <td><%=zte.zxyw50.util.CrbtUtil.getDbStr(request,"authorname","Singer")%>:</td>
              <td>&nbsp;<%= zte.zxyw50.util.CrbtUtil.toString(ringInfo.getSinggername())%></td>
            </tr>
            <!--
            <tr>
              <td class="leftLabel"><%= getArgMsg(request,"UserMSG0035903","1",ringdisplay)%></td>
              <td class="blueTxt">&nbsp;<%= zte.zxyw50.util.CrbtUtil.toString(ringInfo.getSpname())%></td>
            </tr>
            -->
			<%if(issupportmultipleprice == 1){%>
            <tr>
              <td><%= getArgMsg(request,"UserMSG0035904","1",ringdisplay)%></td>
              <td>&nbsp;<%= zte.zxyw50.util.CrbtUtil.getDbStr(request,"majorcurrency", "")+" "+zte.zxyw50.util.CrbtUtil.displayFee(ringInfo.getRingfee2())%></td>
            </tr>
			<%}%>
            <tr>
              <td><%= getArgMsg(request,"UserMSG0035904","1",ringdisplay)%></td>
              <td>&nbsp;<%= zte.zxyw50.util.CrbtUtil.getDbStr(request,"majorcurrency", "")+" "+zte.zxyw50.util.CrbtUtil.displayFee(ringInfo.getPrice())%></td>
            </tr>
            <tr>
              <td><i18n:message key='UserMSG0035905' /></td>
              <td>&nbsp;<%= zte.zxyw50.util.CrbtUtil.toString(ringInfo.getValiddate())%></td>
            </tr>
            <tr>
              <td><i18n:message key='UserMSG0035906' /> </td>
              <td>&nbsp;<%= buytimes%></td>
            </tr>
            <tr>
              <td><i18n:message key='UserMSG0035907' /></td>
              <td>&nbsp;<%= largesstimes%></td>
            </tr>
            <tr>
              <td><i18n:message key='UserMSG0035908' /></td>
              <td>&nbsp;<%= zte.zxyw50.util.CrbtUtil.toString(ringInfo.getUploadtime()) %></td>
            </tr>
			
            <tr>
              <td align="center" colspan="2">
			    
			  <input type="button" value="Cancel" class="btnWhite" onClick="javascript:goBack();">
              </td>
            </tr>
            </table></td>
        </tr>

		</table>
	
  </tr>
</table>
</body>
</html>

