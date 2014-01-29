<%@ taglib uri="/WEB-INF/tao.tld"  prefix="zte" %>
<%@page import ="com.zte.tao.Applications" %>
<%@page import ="com.zte.tao.constant.ApplicationContext" %>
<%@page import ="com.zte.tao.util.JspUtil" %>
<%
String webappname = ((ApplicationContext)Applications.currentApp(application)).getModuleName();
%>
<script language="JavaScript" src="<%=webappname + "/base/form.js"%>" > </script>
<script language="JavaScript" src="<%=webappname + "/base/common.js"%>" > </script>
<script language="JavaScript" src="<%=webappname + "/base/table.js"%>" > </script>
<script language="JavaScript" src="<%=webappname + "/base/JsFun.js"%>" ></script>
<script language="JavaScript" src="<%=webappname + "/base/calendar.js"%>" ></script>
<link href="<%=webappname + "/base/base.css"%>" type="text/css" rel="stylesheet">
