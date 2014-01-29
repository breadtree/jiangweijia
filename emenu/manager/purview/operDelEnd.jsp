<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<%
    try {
        // ±»É¾³ýµÄidºÅ
        String operID = (String)request.getParameter("operID");
        purview.delOper(operID);
        String opertype = (String)request.getParameter("operType");
        String pid = (String)request.getParameter("pid");

%>
<html>
<head>
<title>Delete operator</title>
</head>
<body>
<script language="javascript">
<%if("del".equals(opertype)){%>
    window.opener.delMember('<%=operID%>','<%=pid%>');
    window.close();
<%}else{%>
    window.opener.refresh();
    window.close();
<%}%>
</script>
</body>
</html>
<%
    }
    catch (Exception e) {
        out.println(e.getMessage());
    }
%>
