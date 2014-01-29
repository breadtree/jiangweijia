<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.zxywpub.*" %>
<%@ page import="zxyw50.SpManage" %>


<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

   String sysTime = "";
   Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
   String operID = (String)session.getAttribute("OPERID");
   String operName = (String)session.getAttribute("OPERNAME");
   String spindex = (String)request.getParameter("spindex");
   String ringlibid = (String)request.getParameter("ringlibid");
   String pos = (String)request.getParameter("pos");
   String grouptype = (String)request.getParameter("grouptype");
   String strTitle = "1".equals(grouptype) ? "Add music box member" : "Add gift-bag member";
   Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

   if (operID == null || purviewList.get("2-13") == null)
   {
     String errMsg = "Please log in to the system first!";
%>
<script language="javascript1.2">
   alert(<%=errMsg%>);
</script>
<%
   return;
}
%>

<%

    try
    {
      String ringgroup=(String)request.getParameter("ringgroup");
      String grouplabel=(String)request.getParameter("grouplabel");
      String ringid   =(String)request.getParameter("ringid");

      HashMap  map = new HashMap();
      map.put("opcode","1");
      map.put("ringgroup",ringgroup);
      map.put("ringid",ringid);
      map.put("newringid","newringid"); //该参数无用
      SpManage sysringgroup = new SpManage();
      ArrayList rList = new ArrayList();
      rList=sysringgroup.modSysRingGroupMem(map);


      map = new HashMap();
      zxyw50.Purview purview = new zxyw50.Purview();
      String serviceKey = (String)session.getAttribute("SERVICEKEY");
      map.put("OPERID",operID);
      map.put("OPERNAME",operName);
      map.put("OPERTYPE","1007");
      map.put("RESULT","1");
      map.put("DESCRIPTION","Add ringtone group "+ringgroup+"member:"+ringid);
      map.put("PARA1",ringgroup);
      map.put("PARA2",grouplabel);
      map.put("PARA3",ringid);
      map.put("PARA4","ip:"+request.getRemoteAddr());
      purview.writeLog(map);


      if(rList.size()>0){
        session.setAttribute("rList",rList);
%>
<html>
<head>
  <title><%=strTitle%></title>
</head>
<body>
<form name="resultForm" method="post" action="result.jsp">
  <!--"musicboxMemberEdit.jsp"-->
<input type="hidden" name="historyURL" value="musicboxMemberEdit.jsp?grouptype=<%=grouptype%>&ringlibid=<%=ringlibid%>&pos=<%=JspUtil.getParameter(pos)%>&spindex=<%=spindex%>&ringgroup=<%=ringgroup%>&grouplabel=<%=JspUtil.getParameter(grouplabel)%>" >
<input type="hidden" name="title" value="<%=strTitle%>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
</body>
</html>
<%
		}
    }
    catch (Exception e) {
        out.println(e.getMessage());
    }

%>
