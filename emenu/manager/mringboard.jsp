<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="zxyw50.*" %>
<%@include file="/base/i18n.jsp"%>
<%
   String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String isSmartPriceFlag = CrbtUtil.getConfig("isSmartPriceFlag","0");

%>
<title><i18n:message key='UserMSG0032200' /></title>
</head>
<link rel="stylesheet" type="text/css" href="style.css">
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="framed">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td valign="top">
        <%@include file="mringboard_header.jsp" %>
    </td>
  </tr>
  <tr>
    <td>
        <%@include file="mringboard_body.jsp" %>
    </td>
  </tr>
</table>
</body>
</html>
