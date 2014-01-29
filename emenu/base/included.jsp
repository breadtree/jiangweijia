<%@ taglib uri="/WEB-INF/tao.tld"  prefix="zte" %>
<%@page import ="com.zte.tao.Applications" %>
<%@page import ="com.zte.tao.constant.ApplicationContext" %>
<%@page import ="com.zte.tao.util.JspUtil" %>
<%@include file="/base/i18n.jsp"%>
<%@include file="/base/table.jsp"%>
<%@include file="/base/JsFun.jsp"%>
<%@include file="/base/calendar.jsp"%>
<%@include file="/base/common.jsp"%>
<%@include file="/base/form.jsp"%>
<%
String webappname = ((ApplicationContext)Applications.currentApp(application)).getModuleName();
%>
<link href="<%=webappname + "/base/base.css"%>" type="text/css" rel="stylesheet">
