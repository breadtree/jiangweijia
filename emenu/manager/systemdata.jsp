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
<title>System Parameter</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
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
        if (operID != null && purviewList.get("3-36") != null) {
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String sysparameter = request.getParameter("sysparameter") == null ? "" : ((String)request.getParameter("sysparameter")).trim();
            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","111");
            map.put("RESULT","1");
            map.put("PARA1",sysparameter);
            map.put("DESCRIPTION","System parameters management");
            if (op.equals("edit")) {
                syspara.updateParameter(20089,sysparameter);
                sysInfo.add(sysTime + operName + ",System parameter edited successfully!");
                purview.writeLog(map);
            }
            int ret = syspara.getParameter(20089);
%>
<script language="javascript">

    function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.sysparameter.value) == '') {
         alert('Please select one item!');
         fm.sysparameter.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.sysparameter.value))) {
         alert('The System parameter can only be digital!');//日放号数量只能为数字
         fm.sysparameter.focus();
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

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="430";
</script>
<form name="inputForm" method="post" action="systemdata.jsp">
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr background="image/n-9.gif">
          <td height="26" colspan="2" align="center" class="text-title"background="image/n-9.gif">System Parameter</td>
        </tr>
        <tr >
          <td height="15" colspan="2" align="center" >&nbsp;</td>
        </tr>
        <tr>
          <td align=right height=30 >Copy ringtone set</td>
          <td height="22">
            <select name="sysparameter">
              <option value="0">Only permit the calling number specified</option>
              <option value="1">Permit to copy all ring</option>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan="2" align="center">
            <img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:doSure()">
          </td>
        </tr>
        <tr height="20">
          <td colspan="2"></td>
        </tr>
        <!--
        <tr>
          <td colspan="2" style="color: #FF0000">Notes:</td>
        </tr>
        <tr>
          <td colspan="2" style="color: #FF0000">1. </td>
        </tr>
        -->
      </table>
    </td>
  </tr>
</table>
</form>
<script language="JavaScript">
        document.inputForm.sysparameter.value=<%=ret%>;
</script>
<%
        }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//请先登录系统
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
        sysInfo.add(sysTime + operName + "Exception occurred in managing System parameters!");//日放号数量管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing System parameters!");//日放号数量管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="systemdata.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
