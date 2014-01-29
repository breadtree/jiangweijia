<html>
<head>

<title>Music box management</title>
</head>
<%
    String ringgroup = request.getParameter("ringgroup") == null ? "" :request.getParameter("ringgroup");
    String grouplabel = request.getParameter("grouplabel") == null ? "" :request.getParameter("grouplabel");
    String spindex = request.getParameter("spindex") == null ? "" : request.getParameter("spindex");
    //区分组类型:1:音乐盒 2:大礼包
    String grouptype = request.getParameter("grouptype")==null ? "1":request.getParameter("grouptype");
%>
 <frameset rows="90,*" border="0" bordercolor="#000000">
    <frame src="musicboxEditTitle.jsp?grouptype=<%=grouptype%>&grouplabel=<%=grouplabel%>" name="libTitle" >
    <frameset cols="30%,70%">
      <frame src="musicboxMemberTree.jsp?grouptype=<%=grouptype%>&ringgroup=<%=ringgroup%>&grouplabel=<%=grouplabel%>&spindex=<%=spindex%>" name="musicboxMemberTree" scrolling="auto">
      <frame src="musicboxMemberEdit.jsp?grouptype=<%=grouptype%>&ringgroup=<%=ringgroup%>&grouplabel=<%=grouplabel%>&spindex=<%=spindex%>"
        name="musicboxMemberEdit" scrolling="auto">
    </frameset>
</frameset>
</html>
