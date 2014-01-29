<%@include file="../base/i18n.jsp"%>
<%@include file="../pubfun/JavaFun.jsp"%>
<%
   String majorcurrency = zxyw50.CrbtUtil.getConfig("majorcurrency","$");
   String isSmartPriceFlag = CrbtUtil.getConfig("isSmartPriceFlag","0");
	//String minorcurrency = zxyw50.CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = zxyw50.CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
%>
<html>
<head>
<title><i18n:message key='UserMSG0032800' /></title>
</head>
<link rel="stylesheet" type="text/css" href="style.css">
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="framed">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td><%@include file="mringcatasearch_header.jsp" %></td>
  </tr>
  <tr>
    <td><%@include file="mringcatasearch_body.jsp" %></td>
  </tr>
</table>
</body>
</html>
