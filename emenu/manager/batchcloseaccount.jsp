<%@page import="java.lang.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="zxyw50.manSysPara"%>
<%@page import="zxyw50.manUser"%>
<%@page import="zxyw50.CrbtUtil"%>
<%@page import="com.zte.jspsmart.upload.*"%>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@include file="../pubfun/JavaFun.jsp"%>
<%
  response.addHeader("Cache-Control", "no-cache");
  response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Batch account cancellation</title>
<link href="style.css" type="text/css" rel="stylesheet">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js" type=""></SCRIPT></head>
<body background="background.gif" class="body-style1">
<%
  boolean isopened = false;
  String sysTime = "";
  int ret = 0;
  Vector sysInfo = (Vector) application.getAttribute("SYSINFO");
  String operID = (String) session.getAttribute("OPERID");
  String operName = (String) session.getAttribute("OPERNAME");
  Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable) session.getAttribute("PURVIEW");
   //add by zh 2005-09-07
    long intervaltime =Long.parseLong(CrbtUtil.getConfig("intervaltime","1000")) ;
    //add end
    String usecalling  = zte.zxyw50.util.CrbtUtil.getConfig("usecalling","0");
    String isimage  = zte.zxyw50.util.CrbtUtil.getConfig("isimage","0");
    String colorphotoname = zte.zxyw50.util.CrbtUtil.getConfig("colorphotoname","Color Photo Show");
    boolean is_starhub = CrbtUtil.getConfig("IsStarhub", "0").equals("1") ? true : false;

    try {
     ArrayList rList = null;
    Hashtable result = new Hashtable();
    List acctopenlist = null;
    manSysPara syspara = new manSysPara();
    sysTime = syspara.getSysTime() + "--";
    //配置权限？？？？？
    if (operID != null && purviewList.get("1-11") != null) {
      Vector vet = new Vector();
      int width =0;
      int per = 0;
      Hashtable hash = null;
      String op = request.getParameter("op") == null ? "" : transferString((String) request.getParameter("op")).trim();
      //String localfilename = request.getParameter("tfilename") == null ? "" : transferString((String) request.getParameter("tfilename")).trim();
      String filename = request.getParameter("filename") == null ? "" : transferString((String) request.getParameter("filename")).trim();
       int order = request.getParameter("order") == null ? -1: Integer.parseInt((String)request.getParameter("order"));
       String userType = request.getParameter("userType") == null ? "0" : (String) request.getParameter("userType").trim();
      if(userType.trim().equalsIgnoreCase(""))
         userType = "0";
      int optype = 0;
      String title = "";
      String desc = "";

      if (op.equals("syn97")) {
        optype = 1;
        //desc = operName + "同步97方式批量销户";
        desc = operName + " Batch account cancellation in the synchronous 97 mode";
        title = "Batch account cancellation"; //批量销户
      }
      else if (op.equals("nosyn97")) {
        optype = 2;
        // desc = operName + "不同步97方式批量销户";
        desc = operName + "Batch account cancellation in the asynchronous 97 mode";

       // title = "批量销户";
          title ="Batch account cancellation";
      }
      if(op.equals("saveasfile")){
        response.setContentType("APPLICATION/OCTET-STREAM");
    	response.setHeader("Content-Disposition","attachment; filename=\"account_cancellation_result.txt\"");
        List arra=(ArrayList)session.getAttribute("rList");
        Map tmap=null;
    	out.clear();
    //	out.println("User number       开户结果          ");
       out.println("Subscriber number       Account cancellation result          ");
	for(int k=0;k<arra.size();k++){
          tmap=(Hashtable)arra.get(k);
          out.println(tmap.get("acctnum").toString()+","+tmap.get("result").toString());
          tmap.clear();
	}
        arra.clear();
        return;
      }
      if (op.equals("first")) {
%>
<table border="0" align="center" class="table-style2" width=100%>
    <tr>
        <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Batch account cancellation</td>
    </tr>
    <tr>
        <td height="15" colspan="2" align="center">&nbsp;</td>
    </tr>
</table>
<form name="inputForm" method="POST" action="batchcloseaccount.jsp" >
<input type="hidden" name="filename" value="">
<input type="hidden" name="op" value="">
  <input type="hidden" name="userType" value="0">
<table align="center" class="table-style2">
    <tr >
        <td  colspan="2">File name <input type="text" name="filename1" value="" disabled class="input-style1">
       <img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"> &nbsp;&nbsp;</td>

    </tr>

     <tr style="<%=(("1".equals(usecalling)||"1".equals(isimage))?"display:block":"display:none")%>">

        <td  colspan="2">Account cancellation type
            <input type="radio" name="bj" value="1" checked  onclick="bclk('0');">Called</input>
            <%if("1".equals(zte.zxyw50.util.CrbtUtil.getConfig("usecalling","0"))){%>
            <input type="radio" name="bj" value="2" onclick="bclk('1');">Calling</input>
            <%}%>
        		<!--<input type="radio" name="bj" value="2" onclick="bclk('2');">Calling and called</input>-->
            <%if("1".equals(zte.zxyw50.util.CrbtUtil.getConfig("isimage","0"))){%>
                <input type="radio" name="bj" value="16" onclick="bclk('3');"><%= colorphotoname %></input>
            <% }%>
      </td>
    </tr>

    <tr>
        <td align="center">
            <!--这里需要两张图片一为人工台销户,一为。。。-->
            <img src="button/icon_zjxh.gif" onClick="actupnosyn()">
        </td>
        <%String showboss = "";
        if(is_starhub)
        { showboss ="none";
        }%>
        <td align="center" style="display:<%=showboss%>">
            <img src="button/icon_bossxh.gif" onClick="actupsyn()">
        </td>
    </tr>
</table>
</form>
<script language="JavaScript1.2">

function actupnosyn(){
  var value = document.inputForm.filename1.value;
  if(trim(value)==""){
     // alert("请先选择批量销户文件,谢谢!");
      alert("Please select batch account cancellation file!");
      return;
  }
  document.inputForm.op.value="nosyn97";
  document.inputForm.submit();
}

function actupsyn(){
    var value = document.inputForm.filename1.value;
  if(trim(value)==""){
     // alert("请先选择批量销户文件,谢谢!");
      alert("Please select batch account cancellation file!");
      return;
  }
  document.inputForm.op.value="syn97";
  document.inputForm.submit();
}

function bclk(avar)
{
  document.inputForm.userType.value=avar;
}

function selectFile() {
      var fm = document.inputForm;
      var uploadURL = 'batchcloseaccountupload.jsp';
      uploadRing = window.open(uploadURL,'batchcloseaccountupload','width=400, height=200');
   }

   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.filename1.value = label;
      fm.filename.value = name;
   }
</script><%
  } else if(optype>0) { //optype ==first

  if(order == -1){//第一次处理文件
    rList = new ArrayList();
    session.setAttribute("rList",rList);
    acctopenlist = syspara.getAcctList(filename,1,application);
    session.setAttribute("acctopenlist",acctopenlist);
    int acctcnt = acctopenlist.size();
    session.setAttribute("totalcnt", new Integer(acctcnt));
    %>
 <form name="inputForm" method="post" action="batchcloseaccount.jsp">
<input type="hidden" name="op" value="<%=op %>">
<input type="hidden" name="order" value="<%= (order + 1) + "" %>">
  <input type="hidden" name="userType" value="<%=userType%>">
<table border="0" align="center" class="table-style2" width=100%>
    <tr>
        <td height="26" colspan="2" align="center" class="text-title" background="../image/n-9.gif">Batch account cancellation result</td>
    </tr>
    <tr>
        <td height="15" colspan="2" align="center">&nbsp;</td>
    </tr>
</table>
<table width="98%" border="1" align="center" cellpadding="1" cellspacing="1" class="table-style2">
    <tr class="tr-ringlist">
        <td width="30%" align="center">Subscriber number</td>
        <td width="70%" align="center">Batch account cancellation result</td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
</table>
</form>
<script language="javascript">
<%
if((order+1)<acctopenlist.size()){
%>
   document.inputForm.submit();
<%
}
%>
</script>
    <%
  }else{
      acctopenlist = (ArrayList)session.getAttribute("acctopenlist");
      width=(int)((float)(order+1)/acctopenlist.size()*300f);
      int dot = (int)(((float)(order+1)/acctopenlist.size())*100);
      per = dot>100?100:dot;
      rList = (ArrayList)session.getAttribute("rList");
      if(order <acctopenlist.size()){

      String acctnum = null;
    //可以在函数中处理所有异常,待考虑
    try {
         acctnum = acctopenlist.get(order).toString();
      if (optype == 1) {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        hash = new Hashtable();
        hash.put("opcode","01010102");
        //System.out.println("userType="+userType);
        hash.put("userringtype",userType);
        hash.put("craccount",acctnum);
        hash.put("passwd","");
        hash.put("opmode","6");
        hash.put("ipaddr",operName);
       // hash.put("reason","管理员销户");
        hash.put("reason","operator cancel account");
		hash.put("servicetype","1");
        SocketPortocol.send(pool,hash);
      }
      else if(optype == 2) {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        hash = new Hashtable();
        hash.put("opcode","01010102");
        //System.out.println("userType="+userType);
        hash.put("userringtype",userType);
        hash.put("craccount",acctnum);
        hash.put("passwd","");
        hash.put("opmode","b");
        hash.put("ipaddr",operName);
        hash.put("reason","operator cancel account");
        hash.put("servicetype","1");
        SocketPortocol.send(pool,hash);

      }
      ret = 0;
       result.put("acctnum",acctnum);
       //result.put("result","销户成功");
       result.put("result","Account cancellation success");
       rList.add(result);
      }

    catch (Exception e) {
        ret = 1;
        result.put("acctnum",acctnum);
        result.put("result","Account cancellation failed. "+e.getMessage());
        rList.add(result);

    }
    Thread.currentThread().sleep(intervaltime);
     session.setAttribute("rList",rList);
      }
      %>
<form name="inputForm" method="post" action="batchcloseaccount.jsp">
<input type="hidden" name="op" value="<%=op %>">
<input type="hidden" name="order" value="<%= (order + 1) + "" %>">
    <input type="hidden" name="userType" value="<%=userType%>">
<table>
  <tr>
	  <td ><table><tr><td width="<%=width%>" bgcolor="#56ef45"></td><td><%=per%>%&nbsp;</td></tr></table></td>
  </tr>
  <tr>
	  <td><%=width==300?"Execute batch account cancellation operation finished!":"Excuting batch account cancellation operation,please wait..."%></td>
  </tr>
</table>
<table border="0" align="center" class="table-style2" width=100%>
    <tr>
        <td height="26" colspan="2" align="center" class="text-title" background="../image/n-9.gif">Batch account cancellation excute result</td>
    </tr>
    <tr>
        <td height="15" colspan="2" align="center">&nbsp;</td>
    </tr>
</table>
<table width="98%" border="1" align="center" cellpadding="1" cellspacing="1" class="table-style2">
    <tr class="tr-ringlist">
        <td width="30%" align="center">Subscriber number</td>
        <td width="70%" align="center">Account cancellation  result</td>
    </tr>
<%
  Map maptemp = null;
  for (int k = 0; k < rList.size(); k++) {
    maptemp = (Hashtable) rList.get(k);
    out.println("<tr bgcolor='" + (k % 2 == 0 ? "E6ECFF" : "#FFFFFF") + "'>");
    out.println("<td>" + maptemp.get("acctnum") + "</td>");
    out.println("<td>" + maptemp.get("result") + "</td>");
    out.println("</tr>");
  }
%>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
</table>

</form>
<script language="javascript">
<%
if((order+1)<acctopenlist.size()){
%>
   document.inputForm.submit();
<%
}
%>
</script>
  <%
  }
  if(order+1 == acctopenlist.size()){
    isopened = true;
  session.removeAttribute("acctcnt");
  session.removeAttribute("acctopenlist");
  }
  %>
<script language="JavaScript">
       if(parent.frames.length>0)
       parent.document.all.main.style.height="400";
</script>

<form name="inputForm1" method="post" action="batchcloseaccount.jsp">
<input type="hidden" name="op" value="saveasfile">
<table width="98%" border="1" align="center" cellpadding="1" cellspacing="1" class="table-style2">
    <tr>
        <td colspan="2" align="center">
            <input type="button" name="saveas" value="Save as file" <%if(!isopened){%> disabled="disabled""true" <%}else{%> disable="false" <%}%>onclick="saveasfile()">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" value="Back" onclick="f_return()">
        </td>
    </tr>
</table>
</form>
<script>
function saveasfile(){
  document.inputForm1.target="_parent";
  document.inputForm1.saveas.disabled=true;
  document.inputForm1.submit();
}

function f_return(){
  window.location.href="batchcloseaccount.jsp?op=first";
}
</script>
<%

  }
if(ret == 0 ){
    // 准备写操作员日志
    zxyw50.Purview purview = new zxyw50.Purview();
    HashMap map = new HashMap();
    map.put("OPERID", operID);
    map.put("OPERNAME", operName);
    map.put("OPERTYPE", "111");
    map.put("RESULT", "1");
    map.put("PARA1","ip:"+request.getRemoteAddr());
    map.put("DESCRIPTION", title);
    purview.writeLog(map);
}


   //batch acct
  } else { //operID != null && purviewList.get("13-1") != null
    if (operID == null) {
%>
<script language="javascript">
                    alert( "lease log in to the system first!");
                    document.URL = 'enter.jsp';
              </script><%} else {%>
<script language="javascript">
                   alert( "Sorry. You have no permission for this function!");
              </script><%
  }
  }
  } catch (Exception e) {
    Vector vet = new Vector();
    sysInfo.add(sysTime + operName + " Exception occurred in batch account cancellation!");
    sysInfo.add(sysTime + operName + e.toString());
    vet.add("Error occurred in batch account cancellation!");
    vet.add(e.getMessage());
    session.setAttribute("ERRORMESSAGE", vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="batchcloseaccount.jsp?op=first">
</form>
<script language="javascript">
   document.errorForm.submit();
</script><%}%>
</body>
</html>
