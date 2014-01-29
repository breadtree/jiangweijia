<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.manSysPara" %>

<%@ include file="../../pubfun/JavaFun.jsp" %>
<%
String userday = CrbtUtil.getConfig("uservalidday","0");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Special name list Edit</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
<script language="JavaScript">
   function edit () {
      var fm = document.inputForm;
      if(!checkstring('0123456789',trim(fm.limittimes.value))){
       alert('Limit times can only be digital!');
       fm.limittimes.focus();
       return false;
     }
     if(trim(fm.limittimes.value) == ""){
       alert('Limit times can not be empty!');
       fm.limittimes.focus();
       return false;
     }
     if(fm.limittimes.value.length>10){
       alert('Limti times go beyond the range!');
       fm.limittimes.focus();
       return false;
     }
      fm.op.value = 'edit';

      fm.submit();
   }

function ok(){
  edit();
}
function cancel(){
  window.returnValue = "no";
  window.close();
}
</script>
</head>
<base target="_self">
<body topmargin="0" leftmargin="0" class="body-style1"  background="background.gif" >
<%

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String specialnum = request.getParameter("specialnum") == null ? "" : ((String)request.getParameter("specialnum")).trim();
    String limittimes =  request.getParameter("limittimes") == null ? "0" : ((String)request.getParameter("limittimes")).trim();
    String specialtype =  request.getParameter("specialtype") == null ? "0" : ((String)request.getParameter("specialtype")).trim();
    String typename = "";
    if(specialtype.equals("1")){
      typename = "download times ";
    }else{
      typename = "gift times ";
    }
    String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        List speciallist = new ArrayList();
        ArrayList rList  = new ArrayList();
        manSysPara syspara = new manSysPara();
        Hashtable hash = new Hashtable();
        if(op.equals("edit")){
          hash.put("optype","3");
          hash.put("specialnum",specialnum);
          hash.put("limittimes",limittimes);
          hash.put("specialtype",specialtype);
          speciallist.add(hash);
          rList = syspara.setSpecial(speciallist);
          sysInfo.add(sysTime + " modfy special name list");
          // 准备写操作员日志
          zxyw50.Purview purview = new zxyw50.Purview();
          HashMap map = new HashMap();
          map.put("OPERID",operID);
          map.put("OPERNAME",operName);
          map.put("OPERTYPE","114");
          map.put("RESULT","1");
          map.put("PARA1",specialnum);
          map.put("PARA2",limittimes);
          map.put("PARA3",specialtype);
          map.put("PARA4","ip:"+request.getRemoteAddr());
          map.put("DESCRIPTION"," modfy special name list");
          purview.writeLog(map);
          %>
          <script language="JavaScript">
            window.returnValue = "yes";
            window.close();
            </script>
       <%
          }%>

<form name="inputForm" method="post" action="specialInfo.jsp">
<input type="hidden" name="op" value="">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
    <td>
      <br>
      <table  width="100%"  border="0">
      <tr>
          <td width="100%" align="center" valign="middle">
              <div id="hintContent" >
      <table border="0" align="center" class="table-style2">
         <tr>
          <td height="22" align="left" valign="center">Number</td>
          <td height="22" valign="center"><input type="text" name="specialnum"  value="<%= specialnum%>" maxlength="20" class="input-style0"  readonly="readonly" ></td>
        </tr>

        <%if(!"1".equals(specialtype)){
          limittimes = "0";} %>

        <tr>
          <td height="22" align="left" valign="center">Restriction times</td>
          <td height="22" valign="center"><input type="text" name="limittimes"  <%=!"1".equals(specialtype)?"readonly":""%>   value="<%= limittimes%>"  maxlength="20" class="input-style0"></td>
        </tr>

        <tr>
          <td align="left" width="37%" valign="center">Limit type</td>
          <td height="22" valign="center"><%= typename%><input type="hidden" name="specialtype"  value="<%= specialtype%>"  maxlength="20" class="input-style0"></td>
        </tr>
      </table>
              </div>
          </td>
      </tr>
      <tr>
          <td width="100%" align="center" height="16" align="center">
              <img src="../button/sure.gif" alt="Ok" onmouseover="this.style.cursor='hand'" onclick="javascript:ok()" >
                  &nbsp;&nbsp;
              <img src="../button/cancel.gif" alt="Cancel" onmouseover="this.style.cursor='hand'" onclick="javascript:cancel()" >
        </td>
          </tr>
        </table>

    </td>
  </tr>
</table>
</form>
<%
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Erro occurred in editting " + specialnum + "!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Erro occurred in editting special name list!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
   alert("Erro occurred in editting <%= specialnum%>:<%= e.getMessage() %>");
   window.close();
</script>
<%
    }
%>
</body>
</html>
