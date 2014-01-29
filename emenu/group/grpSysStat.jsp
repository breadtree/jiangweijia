<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.ManGroup" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
   
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
     //change by wxq 2005.05.31 for version 3.16.01
    String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
    String groupindex,groupid,groupname;
    if (mode.equals("manager")){
        groupindex = request.getParameter("groupindex") == null ? "" : request.getParameter("groupindex");
        groupid = request.getParameter("groupid") == null ? "" : request.getParameter("groupid");
        groupname = request.getParameter("groupname") == null ? "" : transferString(request.getParameter("groupname"));
    }else{
        groupindex = (String)session.getAttribute("GROUPINDEX");
        groupid = (String)session.getAttribute("GROUPID");
        groupname =  (String)session.getAttribute("GROUPNAME");
    }
    //end
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
       String  errmsg = "";
       boolean flag =true;
       if (operID  == null){ 
          errmsg = "Please log in to the system first!";
          flag = false;
       }
       else if (purviewList.get("12-7") == null) {
         errmsg = "You have no access to this function!";
         flag = false;
       }
       if(flag){
         ManGroup mangroup = new ManGroup();
         String  grpmems = String.valueOf(mangroup.getGrpCurNum(groupindex));
         
 %>
 
<html>
<head>
<title>Group real-time user number query</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<form name="inputForm" method="post">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<table border="0" width="100%"  height="400" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr>
   <td valign="middle" width="100%">
   <table width="100%">
    <tr >
          <td height="26" >&nbsp;</td>
   </tr>
   <tr >
          <td height="26"  align="center" class="text-title" >Group real-time user number query</td>
   </tr>
   <tr>
    <td align="center" valign="top">
      <table border="0" width="70%" cellspacing="0" cellpadding="0" class="table-style2" bordercolorlight="#000000" bordercolordark="#FFFFFF" align="center">
        <tr >
          <td  colspan=2 height=20>&nbsp;</td>
        </tr>
        <tr >
          <td  height="24" width="40%" align="right">Group code&nbsp;</td>
          <td  height="24"><input type="text" name="groupid" value="<%= groupid %>" maxlength="15" class="input-style1" disabled ></td>
        </tr>
        <tr>
          <td  height="24" align="right" >Group name&nbsp;</td>
          <td  height="24"><input type="text" name="groupname" value="<%= groupname %>" maxlength="15" class="input-style1" disabled ></td>
        </tr>
        <tr>
           <td  height="24" align="right" >Current user number&nbsp;</td>
           <td  height="24"><input type="text" name="groupmems" value="<%= grpmems %>" maxlength="15" class="input-style1" disabled > </td>
        </tr>
      </table>
    </td>
  </tr>
  </table>
  </td>
  </tr>
</table>
</form>
<%
        }
        else {
%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " is abnormal during the group real time user number query!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the group real time user number query!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpSysStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
