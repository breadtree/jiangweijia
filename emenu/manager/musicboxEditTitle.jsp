<%@ include file="../pubfun/JavaFun.jsp" %>
<html>
<head>

<title>Music Box Management</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String grouplabel = request.getParameter("grouplabel");//(String)session.getAttribute("GROUPLABEL");
    //区分组类型:1:音乐盒 2:大礼包
    String grouptype = request.getParameter("grouptype")==null ? "1":request.getParameter("grouptype");
    System.out.println("musicboxEditTitle.jsp::grouplabel:"+ grouplabel);
%>
<body background="background.gif" class="body-style1">
<table  border="0" align="center" class="table-style2" height="100%" width="80%">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Add <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to <%=grouptype.equals("1")?"Music box:":"Big gift:"%><%=grouplabel%></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
