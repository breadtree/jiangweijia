<%@page language="java" import="com.zte.tao.IAppContext"%>
<%@page language="java" import="com.zte.tao.util.Logger"%>
<%@include file="/base/i18n.jsp"%>
<% response.setContentType("text/html; charset="+com.zte.tao.config.TaoUtil.getCharset("UTF-8"));%>
<%@ include file="commonhead.jsp" %>
<head>
<title><i18n:message key='UserMSG0053600' /></title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body class="body-style1">
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" >
  <tr><td height="30"> </td></tr>
  <tr>
    <td> <img src="./image/pop013.gif" width="400" height="60"></td>
  </tr>
  <tr>
    <td background="./image/pop03.gif" height="91">
      <div align="center">
        <table width="80%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
        <%
        ErrorData data  = pageContext.getErrorData();
        Logger logger = Logger.getLogger(data.getRequestURI());
        logger.fatal(data.getThrowable().getMessage(),data.getThrowable());
          try {
            %>
            <tr><td><%=data.getThrowable().getMessage()%></td></tr>
            <%
          }catch(Exception e) {
        %>
          <tr>
            <td><i18n:message key='UserMSG0053601' /></td>
          </tr>
        <%}%>
        </table>
      </div>
    </td>
  </tr>
  <tr>
    <td>
      <img src="image/pop04.gif" width="400" height="23" alt="">
    </td>
  </tr>
</table>
</body>
</html>
