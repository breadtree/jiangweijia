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
<title>Donation period management</title>
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
        if (operID != null && purviewList.get("1-18") != null) {
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String maxdaycapacity = request.getParameter("maxdaycapacity") == null ? "" : ((String)request.getParameter("maxdaycapacity")).trim();
            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","109");
            map.put("RESULT","1");
            map.put("PARA1",maxdaycapacity);
            map.put("DESCRIPTION","Edit the donation period");
            if (op.equals("edit")) {
                syspara.updateParameter(79,maxdaycapacity);
                sysInfo.add(sysTime + operName + ",donation period edited successfully!");
                purview.writeLog(map);
            }
            int ret = syspara.getParameter(79);
%>
<script language="javascript">

    function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.maxdaycapacity.value) == '') {
         alert('Please enter the number of day!');//请输入日放号数量
         fm.maxdaycapacity.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.maxdaycapacity.value))) {
         alert('The donation period can only be digital!');//日放号数量只能为数字
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

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="430";
</script>
<form name="inputForm" method="post" action="editPresentDay.jsp">
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" width="400" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2" width="100%">
        <tr background="image/n-9.gif">
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Gift Duration</td>
        </tr>
        <tr >
          <td height="15" colspan="2" align="center" >&nbsp;</td>
        </tr>
        <tr>
          <td align=right height=30 >Donation period(day)</td>
          <td height="22"><input type="text" name="maxdaycapacity" value="<%= ret %>" maxlength="6" class="input-style2"></td>
        </tr>
        <tr>
          <td colspan="2" align="center">
            <img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:doSure()">
          </td>
        </tr>
        <tr height="20">
          <td colspan="2"></td>
        </tr>
        <table border="0" width="100%" class="table-style2">
        <tr>
                <td class="table-styleshow" background="image/n-9.gif" height="26">
                  Notes:</td>
        </tr>
        <tr>
          <td height="20" style="color: #FF0000">
            <p>The number entered cannot be smaller than 0</p>
          </td>
        </tr>

      </table>

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
        sysInfo.add(sysTime + operName + "Exception occurred in managing donation period!");//日放号数量管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing donation period!");//日放号数量管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="editPresentDay.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
