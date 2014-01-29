<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Manage the number of daily distributed numbers</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" onload="JavaScript:initform(document.forms[0])" >
<%
    String sysTime = "";
    //ColorRing colorRing = (ColorRing)application.getAttribute("COLORRING");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-6") != null) {
            Hashtable hash = new Hashtable();
			String  optSCP = "";
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
			String maxdaycapacity = request.getParameter("maxdaycapacity") == null ? "" : ((String)request.getParameter("maxdaycapacity")).trim();
            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","309");
            map.put("RESULT","1");
            map.put("PARA1",scp);
            map.put("PARA2",maxdaycapacity);
            map.put("PARA3","ip:"+request.getRemoteAddr());
            if (op.equals("edit")) {
                syspara.editMaxDayCapacity(scp,Integer.parseInt(maxdaycapacity));
                sysInfo.add(sysTime + operName + "Number of daily distributed numbers edited successfully!");
                purview.writeLog(map);
            }
			ArrayList scplist = syspara.getScpList();
            for (int i = 0; i < scplist.size(); i++) {
               if(i==0 && scp.equals(""))
                  scp = (String)scplist.get(i);
               optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
            }
            String ret = syspara.getCapacityInfo(scp);
%>
<script language="javascript">
    function initform(pform){
     var temp = "<%= scp %>";
      for(var i=0; i<pform.scplist.length; i++){
        if(pform.scplist.options[i].value == temp){
           pform.scplist.selectedIndex = i;
           break;
        }
     }

   }
    function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.maxdaycapacity.value) == '') {
         alert('Please enter the number of daily distributed numbers!');//请输入日放号数量
         fm.maxdaycapacity.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.maxdaycapacity.value))) {
         alert('The number of daily distributed numbers can only be digital!');//日放号数量只能为数字
         fm.maxdaycapacity.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function doSure () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      fm.submit();
   }
   function onSCPChange(){
       document.inputForm.op.value = "";
       document.inputForm.submit();
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="editDayCapacity.jsp">
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr background="image/n-9.gif">
          <td height="26" colspan="2" align="center" class="text-title"background="image/n-9.gif">Manage the number of daily distributed numbers</td>
        </tr>
        <tr >
          <td height="15" colspan="2" align="center" >&nbsp;</td>
        </tr>
		 <tr>
          <td align=right  height=30 >SCP Select</td>
          <td height="22">
		   <select name="scplist" size="1" onchange="javascript:onSCPChange()" class="input-style1">
              <% out.print(optSCP); %>
             </select>
		  </td>
        </tr>
        <tr>
          <td align=right height=30 >Number of daily distributed numbers</td>
          <td height="22"><input type="text" name="maxdaycapacity" value="<%= ret %>" maxlength="6" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="center"><img src="button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:doSure()"></td>
                <td width="50%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr height="20">
          <td colspan="2"></td>
        </tr>
        <tr>
          <td colspan="2" style="color: #FF0000">Please enter the number of daily distributed numbers according to the following rules:</td>
        </tr>
        <tr>
          <td colspan="2" style="color: #FF0000">1. The number entered cannot be smaller than 0</td>
        </tr>
        <tr>
          <td colspan="2" style="color: #FF0000">2. If 0 is entered, daily numbers will be distributed without limit.</td>
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
        sysInfo.add(sysTime + operName + " Exception occurred in managing the number of daily distributed numbers!");//日放号数量管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing the number of daily distributed numbers!");//日放号数量管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="editDayCapacity.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
