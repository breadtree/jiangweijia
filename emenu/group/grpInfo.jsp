<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.ManGroup" %>


<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Group configuration information </title>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1" onload="initform(document.forms[0])">
<%
    String sysTime = "";
     //add by ge quanmin 3.19
    String usegrpmode = CrbtUtil.getConfig("usegrpmode","0");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String groupid =  (String)session.getAttribute("GROUPID");
    String groupindex =  (String)session.getAttribute("GROUPINDEX");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();


   //String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	 String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

    try {
        ManGroup mangroup = new ManGroup();
        sysTime = mangroup.getSysTime() + "--";
        if (operID != null && purviewList.get("12-6") != null) {
             if(op.trim().equalsIgnoreCase("edit")){
           String groupname = request.getParameter("groupname") == null ? "" : transferString((String)request.getParameter("groupname")).trim();
           String groupphone = request.getParameter("groupphone") == null ? "" : transferString((String)request.getParameter("groupphone")).trim();
           String groupaccount = request.getParameter("groupaccount") == null ? "" : transferString((String)request.getParameter("groupaccount")).trim();
           String maxtimes = request.getParameter("maxtimes") == null ? "5" : transferString((String)request.getParameter("maxtimes")).trim();

           String maxrings = request.getParameter("maxrings") == null ? "5" : transferString((String)request.getParameter("maxrings")).trim();
           String payflag = request.getParameter("payflag") == null ? "0" : transferString((String)request.getParameter("payflag")).trim();
           String rentfee = request.getParameter("rentfee") == null ? "0" : transferString((String)request.getParameter("rentfee")).trim();
            String extrafee = request.getParameter("extrafee") == null ? "0" : transferString((String)request.getParameter("extrafee")).trim();
           String ischeck = request.getParameter("ischeckhidden") == null ? "0" : transferString((String)request.getParameter("ischeckhidden")).trim();

           String managerphone = request.getParameter("managerphone") == null ? "" : transferString((String)request.getParameter("managerphone")).trim();
           String grpmode = request.getParameter("grpmode") == null ? "2" : transferString((String)request.getParameter("grpmode")).trim();
           String exitgrp = request.getParameter("exitgrphidden") == null ? "1" : transferString((String)request.getParameter("exitgrphidden")).trim();
           Hashtable hash = new Hashtable();
            hash.put("newgroupid",groupid);
            hash.put("groupid",groupid);
            hash.put("groupname",groupname);
            hash.put("groupphone",groupphone);
            hash.put("groupaccount",groupaccount);
            hash.put("maxtimes",maxtimes);
            hash.put("maxrings",maxrings);
            hash.put("payflag",payflag);
            hash.put("rentfee",rentfee);
            hash.put("extrafee",extrafee);
            hash.put("ischeck",ischeck);
            //add by ge quanmin 2005.08.10 for version 3.19.01
            hash.put("managerphone",managerphone);
            hash.put("grpmode",grpmode);
            hash.put("exitgrp",exitgrp);
            ArrayList rList  = new ArrayList();
            rList = mangroup.editGroup(hash);
            }
            Hashtable hash = null;
            hash = mangroup.getGrpInfoByindex(groupindex);
            String ischeck = (String)hash.get("ischeck");
            String payflag = (String)hash.get("payflag");
            String grpmode=(String)hash.get("grpmode");
            String exitgrp=(String)hash.get("exitgrp");
%>

<script language="javascript">
  function initform(pform){
     var  temp = "<%= ischeck  %>";
     var  index = parseInt(temp);
     pform.ischeck[index].checked = true;
     temp = "<%= payflag   %>";
     index = parseInt(temp);
     pform.payflag[index].checked = true;
       temp = "<%= exitgrp   %>";
     index = parseInt(temp);
     pform.exitgrp[index].checked = true;
      temp = "<%= grpmode   %>";
     index = parseInt(temp);
     pform.grpmode[index-1].checked = true;
  }

    function editInfo () {
      var fm = document.inputForm;
      var value = trim(fm.managerphone.value);
      if (!checkstring('0123456789',value)) {
        // alert('管理员电话只能为数字!');
        alert("The telephone of the administrator can only be a digital number!");
         fm.managerphone.focus();
         return false;
      }
      if(value == ''){
        alert("The telephone of the administrator can not be null!");
         fm.managerphone.focus();
         return false;
      }
      fm.op.value = 'edit';
      fm.submit();
   }
</script>

<script language="JavaScript">
	if(parent.frames.length>0)
		 parent.document.all.main.style.height="550";
</script>
<form name="inputForm" >
<input type="hidden" name="op" value="">
<input type="hidden" name="oldgroupid" value="">
<input type="hidden" name="groupindex" value="">
<table width="480" height="450" border="0" align="center" class="table-style2">
  <tr valign="middle">
    <td>
      <table width="90%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="../manager/image/n-9.gif">Group configuration information </td>
        </tr>
        <tr>
            <td align="right">Group code&nbsp;</td>
          <td><input type="text" name="groupid" value="<%= groupid %>" maxlength="15" class="input-style1" readonly ></td>
        </tr>
         <tr>
            <td align="right">Group name&nbsp;</td>
          <td><input type="text" name="groupname" value="<%= (String)hash.get("groupname") %>" maxlength="40" class="input-style1" readonly ></td>
        </tr>
        <tr>
            <td align="right">Telephone&nbsp;</td>
          <td><input type="text" name="groupphone" value="<%= (String)hash.get("groupphone") %>" maxlength="40" class="input-style1" readonly ></td>
        </tr>
        <tr>
          <td align="right">Account opening date&nbsp;</td>
          <td><input type="text" name="opendate" value="<%= (String)hash.get("opendate") %>"  maxlength="10" class="input-style1" readonly ></td>
        </tr>
        <tr>
            <td align="right">Charge account&nbsp;</td>
          <td><input type="text" name="groupaccount" value="<%= (String)hash.get("groupaccount") %>"  maxlength="5" class="input-style1"  readonly ></td>
        </tr>
        <tr>
            <td align="right">Payment mode&nbsp;</td>
            <td>
            <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td width="60%"><input type="radio" checked name="payflag" value="0" disabled > <span title="Personal payment">Personal</span></td>
                <td width="40%"><input type="radio" name="payflag" value="1" disabled ><span title="Group payment">Group</span></td>
              </tr>
            </table>
          </td>
        </tr>
		<tr>
           <td align="right">Monthly rental(<%=minorcurrency%>) &nbsp;</td>
          <td><input type="text" name="rentfee" value="<%= (String)hash.get("rentfee") %>" maxlength="5" class="input-style1" readonly ></td>
        </tr>
         <tr>
           <td align="right">Next month rental(<%=minorcurrency%>)</td>
          <td><input type="text" name="nrentfee" value="<%= (String)hash.get("nrentfee") %>" maxlength="6" class="input-style1" readonly ></td>
        </tr>
        <tr>
           <td align="right">Additional fee (<%=minorcurrency%>)&nbsp;</td>
          <td><input type="text" name="extrafee" value="<%= (String)hash.get("extrafee") %>" maxlength="5" class="input-style1" readonly ></td>
        </tr>
        <tr>
            <td align="right">Maximum number of time period&nbsp;</td>
           <td><input type="text" name="maxtimes" value="<%= (String)hash.get("maxtimes") %>" maxlength="2" class="input-style1" readonly ></td>
        </tr>
		<tr>
            <td align="right">Maximum ringtone number&nbsp;</td>
           <td><input type="text" name="maxrings" value="<%= (String)hash.get("maxrings") %>"  maxlength="2" class="input-style1" readonly ></td>
        </tr>
        <tr>
          <td align="right">Audit ringtone or not&nbsp;</td>
          <td>
            <table border="0" width="100%" class="table-style2">
              <input type="hidden" name="ischeckhidden" value="<%= ischeck  %>"  >
              <tr align="center">
                <td width="50%"><input type="radio" checked name="ischeck" value="0" disabled >No</td>
                <td width="50%"><input type="radio" name="ischeck" value="1" disabled >Yes</td>
              </tr>
            </table>
          </td>
        </tr>
         <tr>
            <td align="right">Manager phone&nbsp;</td>
	    <td><input type="text" name="managerphone" value="<%= (String)hash.get("managerphone") %>" maxlength="40" class="input-style0" ><span style="font:11px;">(can be modified)</span></td>
        </tr>
         <tr>
          <td align="right">Allow user to log out or not&nbsp;</td>
          <td>
            <table border="0" width="100%" class="table-style2">
              <input type="hidden" name="exitgrphidden" value="<%= exitgrp   %>"  >
              <tr align="center">
                <td width="50%"><input type="radio" checked name="exitgrp" value="0" disabled >No</td>
                <td width="50%"><input type="radio" name="exitgrp" value="1" disabled >Yes</td>
              </tr>
            </table>
          </td>
        </tr>
          <% String typeDisplay = "none";
         if("1".equals(usegrpmode))
           typeDisplay = "";
        %>
          <tr style="display:<%= typeDisplay %>">
          <td align="right">Group mode&nbsp;</td>
          <td>
            <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td width="50%"><input type="radio" checked name="grpmode" value="0" disabled >a Mode</td>
                <td width="50%"><input type="radio" name="grpmode" value="1" disabled >b Mode</td>
              </tr>
            </table>
          </td>
        </tr>
          <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
              <td width="25%" align="center"><img src="../manager/button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
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

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no access to this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occourred in Group configuration information!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occourred in the group configuration information!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpInfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
