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
            throw new Exception ("Incorrect data obtained!");//Obtain incorrect data
        }
    }
%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Manage ringtone verification criteria</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    //String individualcheck = (String)application.getAttribute("INDIVIDUALCHECK")==null?"1":(String)application.getAttribute("INDIVIDUALCHECK");
    String allowup = (String)application.getAttribute("ALLOWUP")==null?"0":(String)application.getAttribute("ALLOWUP");
    //System.out.println("allowup="+allowup + " individualcheck="+individualcheck);
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-8") != null) {
            ArrayList rList  = new ArrayList();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String censor = request.getParameter("ringcensor") == null ? "" : transferString((String)request.getParameter("ringcensor")).trim();
            int ringcensor = 0;
            if (censor.length() > 0)
                ringcensor = Integer.parseInt(censor);
            else
                ringcensor = syspara.getCheckInfo();
            if (op.equals("edit")) {
                rList = syspara.editCheckInfo(ringcensor);
                sysInfo.add(sysTime + operName + " edit ringtone verification criteria successfully!");
                // 准备写操作员日志
                if(getResultFlag(rList)){
                    zxyw50.Purview purview = new zxyw50.Purview();
                    HashMap map = new HashMap();
                    map.put("OPERID",operID);
                    map.put("OPERNAME",operName);
                    map.put("OPERTYPE","311");
                    map.put("RESULT","1");
                    map.put("PARA1",ringcensor+"");
                    map.put("PARA2","ip:"+request.getRemoteAddr());
                    purview.writeLog(map);
                }
                if(rList.size()>0){
                  session.setAttribute("rList",rList);
                %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="ringCensor.jsp">
<input type="hidden" name="title" value="Ringtone verification criteria">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
              <%
               }

            }
            boolean censor1 = false;
            boolean censor2 = false;
            boolean censor4 = false;
            if (ringcensor >= 4) {
                censor4 = true;
                ringcensor = ringcensor - 4;
            }
            if (ringcensor >= 2) {
                censor2 = true;
                ringcensor = ringcensor - 2;
            }
            if (ringcensor >= 1) {
                censor1 = true;
                ringcensor = ringcensor - 1;
            }
%>
<script language="javascript">
   function doSure () {
      var fm = document.inputForm;
      var ringcensor = 0;
      if (fm.censor1.checked)
         ringcensor = ringcensor + 1;
      if (fm.censor2.checked)
         ringcensor = ringcensor + 2;
      if (fm.censor4.checked)
         ringcensor = ringcensor + 4;
      fm.ringcensor.value = ringcensor;
      fm.op.value = 'edit';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="ringCensor.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="ringcensor" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
          <td height="26" align="center" background="image/n-9.gif" class="text-title" >Manage <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> verification criteria</td>
        </tr>
        <tr>
          <td><input type="checkbox" name="censor1" value="1"<%= censor1 ? " checked" : "" %>>Verify system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
        </tr>
        <tr style=<%= allowup.equals("1") ?"display:block":"display:none" %>>
          <td><input type="checkbox" name="censor2" value="2"<%= censor2 ? " checked" : "" %>>Verify subscriber-uploaded <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
        </tr>
        <tr style=<%= allowup.equals("1")?"display:block":"display:none" %>>
          <td><input type="checkbox" name="censor4" value="4"<%= censor4 ? " checked" : "" %>>Verify subscriber-recorded <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
        </tr>
        <tr>
          <td align="center"><img src="button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:doSure()"></td>
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
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in managing ringtone verification criteria!");//铃音审核条件管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing ringtone verification criteria!");//铃音审核条件管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="ringCensor.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
