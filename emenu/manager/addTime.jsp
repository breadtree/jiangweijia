<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.zxywpub.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%!
    public String display (Hashtable hash) throws Exception {
        try {
            String starttime = "000000" + (String)hash.get("starttime");
            starttime = starttime.substring(starttime.length() - 6);
            starttime = starttime.substring(0,2) + ":" + starttime.substring(2,4) + ":" + starttime.substring(4,6);
            String stoptime = "000000" + (String)hash.get("stoptime");
            stoptime = stoptime.substring(stoptime.length() - 6);
            stoptime = stoptime.substring(0,2) + ":" + stoptime.substring(2,4) + ":" + stoptime.substring(4,6);
            return starttime + "------" + stoptime;
        }
        catch (Exception e) {
            throw new Exception ("Incorrect data obtained!");//Obtain incorrect data!
        }
    }
%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Account opening time constraints management</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1" onload="JavaScript:initform(document.forms[0])">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-7") != null) {
            Vector vet = new Vector();
			String  optSCP = "";
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
			String timeid = request.getParameter("timeid") == null ? "" : transferString((String)request.getParameter("timeid")).trim();
            String starttime = request.getParameter("starttime") == null ? "" : transferString((String)request.getParameter("starttime")).trim();
            String stoptime = request.getParameter("stoptime") == null ? "" : transferString((String)request.getParameter("stoptime")).trim();
            hash.put("scp",scp);
            hash.put("timeid",timeid);
            hash.put("starttime",starttime);
            hash.put("stoptime",stoptime);
            String sDesc = "";
            if (op.equals("add")) {
                syspara.addAddTime(hash);
                sDesc = "Add";
                sysInfo.add(sysTime + operName + "Account opening time constraint added successfully!");
            }
            else if (op.equals("edit")) {
                syspara.editAddTime(hash);
                sysInfo.add(sysTime + operName + "Account opening time constraints edited successfully!");
                 sDesc = "Edit";

            }
            else if (op.equals("del")) {
                syspara.delAddTime(Integer.parseInt(timeid),scp);
                sysInfo.add(sysTime + operName + "Account opening time constraint deleted successfully!");
                sDesc = "Delete";
            }
            // 准备写操作员日志
            if(!op.equals("")){
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","310");
                map.put("RESULT","1");
                map.put("PARA1",timeid);
                map.put("PARA2",starttime);
                map.put("PARA3",stoptime);
                map.put("PARA4","ip:"+request.getRemoteAddr());
                map.put("DESCRIPTION",sDesc);
                purview.writeLog(map);
            }
			ArrayList scplist = syspara.getScpList();
            for (int i = 0; i < scplist.size(); i++) {
               if(i==0 && scp.equals(""))
                  scp = (String)scplist.get(i);
               optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
            }
            if(!scp.equals(""))
              vet = syspara.getAddTime(scp);
%>
<script language="javascript">
   var v_timeid = new Array(<%= vet.size() + "" %>);
   var v_starttime = new Array(<%= vet.size() + "" %>);
   var v_stoptime = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_timeid[<%= i + "" %>] = '<%= (String)hash.get("timeid") %>';
   v_starttime[<%= i + "" %>] = '<%= (String)hash.get("starttime") %>';
   v_stoptime[<%= i + "" %>] = '<%= (String)hash.get("stoptime") %>';
<%
            }
%>

   function initform(pform){
     var temp = "<%= scp %>";
      for(var i=0; i<pform.scplist.length; i++){
        if(pform.scplist.options[i].value == temp){
           pform.scplist.selectedIndex = i;
           break;
        }
     }

   }

   // 删除字符串的左边空格
   function leftTrim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = str;
      var i = 0;
      for (i = 0; i < str.length; i++) {
         if (tmp.substring(0,1) == ' ')
            tmp = tmp.substring(1,tmp.length);
         else
            return tmp;
      }
   }

   // 删除字符串的右边空格
   function rightTrim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = str;
      var i = 0;
      for (i = str.length - 1; i >= 0; i--) {
         if (tmp.substring(tmp.length - 1,tmp.length) == ' ')
            tmp = tmp.substring(0,tmp.length - 1);
         else
            return tmp;
      }
   }

   // 删除字符串的两边空格
   function trim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = leftTrim(str);
      return rightTrim(tmp);
   }

   function formatTime (str) {
      var tmp = '000000' + str;
      tmp = tmp.substring(tmp.length - 6, tmp.length);
      tmp = tmp.substring(0,2) + ':' + tmp.substring(2,4) + ':' + tmp.substring(4,6);
      return tmp;
   }

   function checkTime (str) {
      var tmp = trim(str);
      if (tmp.length != 8)
         return -1;
      if (tmp.substring(2,3) != ':' || tmp.substring(5,6) != ':')
         return -1;
      tmp = tmp.substring(0,2) + tmp.substring(3,5) + tmp.substring(6,8);
      var c = '';
      for (i = 0; i < tmp.length; i++) {
         c = tmp.substring(i,i + 1);
         if (c < '0' || c > '9')
            return -1;
      }
      c = tmp.substring(0,2);
      if (c < '00' || c > '23')
         return -1;
      c = tmp.substring(2,4);
      if (c < '00' || c > '59')
         return -1;
      c = tmp.substring(4,6);
      if (c < '00' || c > '59')
         return -1;
      return tmp;
   }

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '')
         return;
      fm.timeid.value = v_timeid[index];
      fm.starttime.value = v_starttime[index];
      fm.stoptime.value = v_stoptime[index];
      fm.starttime1.value = formatTime(v_starttime[index]);
      fm.stoptime1.value = formatTime(v_stoptime[index]);
      fm.starttime1.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var tmp = '';
      tmp = checkTime(fm.starttime1.value);
      if (tmp == '-1') {
         alert('Start time format error!');//开始时间格式错误!
         fm.starttime1.focus();
         return flag;
      }
      fm.starttime.value = tmp;
      tmp = checkTime(fm.stoptime1.value);
      if (tmp == '-1') {
         alert('End time format error!');//结束时间格式错误
         fm.stoptime1.focus();
         return flag;
      }
      fm.stoptime.value = tmp;
      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'add';
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      if (fm.timeid.value.length == 0) {
         alert('Please select the time period to be edited!');//请先选择要Edit的time segment
         fm.starttime1.focus();
         return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      if (fm.timeid.value.length == 0) {
         alert('Please select the time period to be deleted!');//请先选择要删除的time segment
         fm.starttime1.focus();
         return;
      }
      if (confirm('Are you sure you want to delete this time period?') == 0) {//您确认要删除这个time segment吗
         fm.starttime1.focus();
         return;
      }
      fm.op.value = 'del';
      fm.submit();
   }
    function onSCPChange(){
       document.inputForm.op.value = "";
       document.inputForm.submit();
   }


</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="addTime.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="timeid" value="">
<input type="hidden" name="starttime" value="">
<input type="hidden" name="stoptime" value="">
<table border="0" align="center" height="400" class="table-style2">
  <tr valign="center">
    <td align="center">
      <table border="0" align="center" class="table-style2" align="center">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Account opening time constraints management</td>
        </tr>
        <tr>
          <td  width=40% align="center" >
           SCP SELECT<br> <select name="scplist" size="1" onchange="javascript:onSCPChange()" class="input-style1">
              <% out.print(optSCP); %>
             </select>
            <select name="infoList" size="6" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()" style="width:200">
<%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Hashtable)vet.get(i);
%>
              <option value="<%= i + "" %>"><%= display(hash) %></option>
<%
            }
%>
            </select>
          </td>
          <td width=60%>
             <table border="0" class="table-style2">
             <tr>
               <td height="30" align="right">Start time of account opening(HH:MM:SS)</td>
               <td ><input type="text" name="starttime1" value="" maxlength="8" class="input-style1"></td>
             </tr>
             <tr>
               <td height="30" align="right">End time of account opening(HH:MM:SS)</td>
               <td ><input type="text" name="stoptime1" value="" maxlength="8" class="input-style1"></td>
             </tr>
             <tr>
               <td colspan="2" height=50>
                 <table border="0" width="100%" class="table-style2">
                   <tr>
                     <td width="25%" align="center"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                     <td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                     <td width="25%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                     <td width="25%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
                   </tr>
                 </table>
               </td>
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
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//You have no access to this function!
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in managing account opening time constraints!");//开户时间限制管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing account opening time constraints!");//开户时间限制管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="addTime.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
