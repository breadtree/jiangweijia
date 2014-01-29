<%@page import="com.zte.tao.IAppContext"%>
<%@include file="/base/i18n.jsp"%>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
response.setContentType("text/html; charset="+com.zte.tao.config.TaoUtil.getCharset("UTF-8"));
String img_path = "intl/"+ getZteLocale(request)+"/"; //add by chenxi 2007-03-01
%>
<%@ include file="commonhead.jsp" %>
<head>
<title><i18n:message key='UserMSG0053300' /></title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body class="body-style1">
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" >
  <tr><td height="200"> </td></tr>
  <tr>
    <td width="100%"><img src="<%=img_path%>image/pop013.gif" width="400" height="60"></td>
  </tr>
  <tr>
    <td> <img src="image/pop02.gif" width="400" height="26"></td>
  </tr>
  <tr>
    <td background="image/pop03.gif" height="91">
      <div align="center">
        <table width="80%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
        <%

        boolean flag =false;
        try {
            String[] strMsgs = (String[]) request.getAttribute(IAppContext.MESSAGE_NAME);
            if (strMsgs == null||strMsgs.length<=0) {
                strMsgs = new String[]{"<i18n:message key='UserMSG0053301' />"};
            }
            for(int i=0;i<strMsgs.length;i++){

              String tmp = strMsgs[i];
            	if(tmp.indexOf("No this number prefix")==0){
                flag= true;
                  strMsgs[i] = getArgMsg(request,"UserMSG0053304","0");
                }
                %>
                <tr>
                    <td><%= strMsgs[i] %>            </td>
                </tr>
                <%
                }
          } catch (Exception e) {
        %>
          <tr>
            <td><i18n:message key='UserMSG0053302' /></td>
          </tr>
        <%} %>

        <%if(flag) { %>
        <tr>
            <td align="center"><br><br><button class="submitBtn" onClick="javascript:window.history.back();"><span><%= getArgMsg(request,"UserMSG0053303","1")%></span></button></td>
        </tr>
       <% }%>

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
