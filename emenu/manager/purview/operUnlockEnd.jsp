<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<%
    try {
        String operID = (String)request.getParameter("operID");
        String opertype = (String)request.getParameter("operType");
        String opname = JspUtil.getParameter((String)request.getParameter("opname"));
        purview.unlockOper(operID);
%>
<html>
<head>
<title>Delete operator</title>
</head>
<body>
<script language="javascript">
<%if("unlock".equals(opertype)){%>
    window.opener.unlockMember('<%=operID%>','<%=opname%>');
<%}else{%>
    window.opener.refresh();
<%}%>
    window.close();
</script>
</body>
</html>
<%
    }
    catch (Exception e) {
        out.println(e.getMessage());
    }
%>
