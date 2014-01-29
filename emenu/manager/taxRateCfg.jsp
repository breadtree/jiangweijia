<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<html>
<head>
<title>Tax Rate Config</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
         manSysPara syspara = new manSysPara();
         sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-32") != null) {
            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();

            Map hash = null;
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String faxRateValue = request.getParameter("faxRateValue") == null ? "" : transferString((String)request.getParameter("faxRateValue")).trim();

            // 单位是万分之一，要作*100处理
            if(faxRateValue!=null&&faxRateValue.trim().length()>0)
            {
              float b = Float.parseFloat(faxRateValue)*100;
             faxRateValue = String.valueOf((new Float(b)).intValue());

            }

            int optype = 0;
            String title = "";
            if (op.equals("edit")){
                optype = 1;
                title = "Set Tax Rate";

            }

            if(optype>0){

               rList = syspara.editFaxRate(faxRateValue);
               // 准备写操作员日志
               if(getResultFlag(rList)){
                 zxyw50.Purview purview = new zxyw50.Purview();
                 map.put("OPERID",operID);
                 map.put("OPERNAME",operName);
                 map.put("OPERTYPE","332");
                 map.put("RESULT","1");
                 map.put("PARA1",faxRateValue);
                 map.put("DESCRIPTION",title);
                 purview.writeLog(map);
               }
                 if(rList.size()>0){
                   session.setAttribute("rList",rList);
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="taxRateCfg.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }


            }
            String faxRate = null;
            String rateValue = syspara.getFaxRate();//费率信息 单位是万分之一要作/100处理
            float a = Float.parseFloat(rateValue)/100;
            faxRate = String.valueOf(a);

 %>
<script language="javascript">

   function checkInfo () {
      var fm = document.inputForm;
      var value = trim(fm.faxRateValue.value);
     if(!(/^[1-9]{1}[0-9]{0,1}[0-9]{0,1}\.[0-9]{0,2}$/.test(value))
     && !(/^0\.[0-9]{0,2}$/.test(value))
     && !(/^[1-9]{1}[0-9]{0,1}[0-9]{0,1}$/.test(value)))
  {
    alert("The tax Rate must be a positive integer less than 1000 or a decimal fraction like xxx.xx");
    fm.faxRateValue.focus();
    return false;
  }

  return true;
   }

   function editInfo () {
      var fm = document.inputForm;
      if(!checkInfo())
        return;
      fm.op.value = 'edit';
      fm.submit();
   }


</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="taxRateCfg.jsp">
<input type="hidden" name="op" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Set Tax Rate</td>
        </tr>
        <td height='100%'>
            <table width="100%" border =0 class="table-style2" height='100%'>
            <tr>
             <td width="50%" align=right>The Tax Rate of Ringtone Price &nbsp;&nbsp;</td>
             <td  align="center"><input type="text"   style="width:80px" name="faxRateValue" value="<%=faxRate%>" maxlength="10" class="input-style1">%</td>
            </tr>

            <tr>
            <td  colspan="2" align="center">
              <table border="0" width="100%" class="table-style2"  align="center">
              <tr>
                <td width="100%" align="center"><img src="button/edit.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
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
                    alert( "Please log in first!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry, you have no right to access this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in setting tax rate!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Errors occurred in setting tax rate!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="taxRateCfg.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
