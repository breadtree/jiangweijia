<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.zte.zxywpub.*" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Management of group service application</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
String sysTime = "";
Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
String operID = (String)session.getAttribute("OPERID");
String operName = (String)session.getAttribute("OPERNAME");
Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
try {
  manSysPara syspara = new manSysPara();
  sysTime = syspara.getSysTime() + "--";
  if (operID != null && purviewList.get("3-20") != null) {
    Vector vet = new Vector();
    Hashtable hash = new Hashtable();
    String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
    String sno = request.getParameter("sno") == null ? "" : transferString((String)request.getParameter("sno")).trim();
    String recorddate = request.getParameter("recorddate") == null ? "" : transferString((String)request.getParameter("recorddate")).trim();
    String groupname = request.getParameter("groupname") == null ? "" : transferString((String)request.getParameter("groupname")).trim();
    String groupphone = request.getParameter("groupphone") == null ? "" : transferString((String)request.getParameter("groupphone")).trim();
    String groupaddress = request.getParameter("groupaddress") == null ? "" : transferString((String)request.getParameter("groupaddress")).trim();
    String linkman = request.getParameter("linkman") == null ? "" : transferString((String)request.getParameter("linkman")).trim();
    String email = request.getParameter("email") == null ? "" : transferString((String)request.getParameter("email")).trim();
    String ifcheck = request.getParameter("ifcheck") == null ? "" : transferString((String)request.getParameter("ifcheck")).trim();
    String oldsno = request.getParameter("oldsno") == null ? "" : transferString((String)request.getParameter("oldsno")).trim();
    int  optype =0;
    String title = "";
    String desc = "";
    if (op.equals("edit")) {
      optype = 3;
      desc  = operName + " edit group"+colorName+" service application";
      title = "Edit group "+colorName+" service application";
    }
    else if (op.equals("del")) {
      optype = 2;
      desc  = operName + " delete group "+colorName+" service application";
      title = "Delete group "+colorName+" service application";
    }
    if(optype>0){
      hash.put("optype",optype+"");
      hash.put("sno",sno);
      hash.put("recorddate",recorddate);
      hash.put("groupname",groupname);
      hash.put("groupphone",groupphone);
      hash.put("groupaddress",groupaddress);
      hash.put("linkman",linkman);
      hash.put("email",email);
      hash.put("ifcheck",ifcheck);
      hash.put("oldsno",oldsno);
      syspara.setWantedGroup(hash);
      sysInfo.add(sysTime + desc);
      // 准备写操作员日志
      zxyw50.Purview purview = new zxyw50.Purview();
      HashMap map = new HashMap();
      map.put("OPERID",operID);
      map.put("OPERNAME",operName);
      map.put("OPERTYPE","320");
      map.put("RESULT","1");
      map.put("PARA1",sno);
      map.put("PARA2",groupname);
      map.put("PARA3","ip:"+request.getRemoteAddr());
      map.put("DESCRIPTION",title);
      purview.writeLog(map);
    }
    vet = syspara.getWantedgroup();
%>
<script language="javascript">
   var v_sno = new Array(<%= vet.size() + "" %>);
   var v_recorddate = new Array(<%= vet.size() + "" %>);
   var v_groupname = new Array(<%= vet.size() + "" %>);
   var v_groupphone = new Array(<%= vet.size() + "" %>);
   var v_groupaddress = new Array(<%= vet.size() + "" %>);
   var v_linkman = new Array(<%= vet.size() + "" %>);
   var v_email = new Array(<%= vet.size() + "" %>);
   var v_ifcheck = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_sno[<%= i + "" %>] = '<%= (String)hash.get("sno") %>';
   v_recorddate[<%= i + "" %>] = '<%= (String)hash.get("recorddate") %>';
   v_groupname[<%= i + "" %>] = '<%= (String)hash.get("groupname") %>';
   v_groupphone[<%= i + "" %>] = '<%= (String)hash.get("groupphone") %>';
   v_groupaddress[<%= i + "" %>] = '<%= (String)hash.get("groupaddress") %>';
   v_linkman[<%= i + "" %>] = '<%= (String)hash.get("linkman") %>';
   v_email[<%= i + "" %>] = '<%= (String)hash.get("email") %>';
   v_ifcheck[<%= i + "" %>] = '<%= (String)hash.get("ifcheck") %>';
<%
            }
%>


   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if (index == -1 || index >= fm.infoList.length)
           return;
      fm.sno.value = v_sno[index];
      fm.oldsno.value = v_sno[index];
      fm.recorddate.value = v_recorddate[index];
      fm.groupname.value = v_groupname[index];
      fm.groupphone.value = v_groupphone[index];
      fm.groupaddress.value = v_groupaddress[index];
      fm.linkman.value = v_linkman[index];
      fm.email.value = v_email[index];
      fm.ifcheck.value = v_ifcheck[index];
   }
   function editInfo () {
      var fm = document.inputForm;
      var displayname='<%=colorName%>';
      if(fm.infoList.length == 0){
          alert('Sorry,no any group '+displayname+' service appplication can be modified!');
          return false;
      }
      if(fm.infoList.selectedIndex == -1){
          alert('Please select the group '+displayname+' service you want to modify!');
          return false;
      }
      fm.op.value = 'edit';
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
       var displayname='<%=colorName%>';
      if(fm.infoList.length == 0){
         // alert('对不起,没有任何集团'+displayname+'业务申请可供删除!');
         alert("Sorry,no any group "+displayname+" service can be deleted!");
          return false;
      }
      if(fm.infoList.selectedIndex == -1){
         // alert('请选择您要删除的集团'+displayname+'业务!');
          alert("Please select the group "+displayname+" service to be deleted!");
          return false;
      }
      fm.op.value = 'del';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="wantedGrpPrefix.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="sno" value="">
<input type="hidden" name="oldsno" value="">
<table width="450" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr background="image/n-9.gif">
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Management of group <%=colorName%> service application</td>
        </tr>
        <tr>
          <td rowspan="9" width="45%">
            <select name="infoList" size="6" <%= vet.size() == 0 ? "disabled " : "" %> style="width:200; height:200" class="select-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Hashtable)vet.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)hash.get("sno")+"------"+(String)hash.get("groupname") %></option>
<%
            }
%>
            </select>
          </td>
          			<tr>
          			  <td align="right" width="18%">Application date</td>
          			  <td  width="34%"><input type="text" name="recorddate" value="" maxlength="40" class="input-style1" readonly></td>
          			</tr>
          			<tr>
                      <td align="right" width="18%">Group name</td>
                      <td  width="34%"><input type="text" name="groupname" value="" maxlength="40" class="input-style1" readonly></td>
                    </tr>
                    <tr>
                      <td align="right">Group telephone </td>
                      <td><input type="text" name="groupphone" value="" maxlength="40" class="input-style1" readonly></td>
                    </tr>
                    <tr>
                      <td align="right">Group address</td>
                      <td><input type="text" name="groupaddress" value="" maxlength="20" class="input-style1" readonly></td>
                    </tr>
                    <tr>
                      <td align="right">linkman</td>
                      <td><input type="text" name="linkman" value="" maxlength="20" class="input-style1" readonly></td>
                    </tr>
                    <tr>
                      <td align="right">email</td>
                      <td><input type="text" name="email" value="" maxlength="40" class="input-style1" readonly></td>
                    </tr>
                    <tr>
                      <td align="right">Audit or not</td>
                      <td><select name="ifcheck">
                        <%if("1".equals(ifcheck)){%><option value="1">Yes</option><option value="0">No</option>
                        <%}else{%><option value="0">No</option><option value="1">Yes</option><%}%>
                      </select></td>
                    </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                <td width="25%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
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
                   alert( "Sorry,you have no access to the function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " group "+colorName+" exception occourred in management of service application!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Group "+colorName+" error occourred in management of service application!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="wantedGrpPrefix.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
