<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Delete Ringtone</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script language="JavaScript">

   function del () {
      var fm = document.inputForm;
      fm.op.value = 'del';
      fm.submit();
   }

function ok(){
  del();
}
function cancel(){
  window.returnValue = "no";
  window.close();
}

function acttype(){
      var fm = document.inputForm;
      fm.ctype.value=fm.dspctype.value;
}
</script>
</head>
<base target="_self">
<body topmargin="0" leftmargin="0" class="body-style1"  background="background.gif" >
<%
String spIndex = (String)session.getAttribute("SPINDEX");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String ringid = request.getParameter("ringid") == null ? "" : ((String)request.getParameter("ringid")).trim();
    String ringidtype = request.getParameter("ringidtype") == null ? "1" : ((String)request.getParameter("ringidtype")).trim();
    String libid =  request.getParameter("libid") == null ? "503" : ((String)request.getParameter("libid")).trim();
    String ringlabel =  request.getParameter("ringlabel") == null ? "" : transferString((String)request.getParameter("ringlabel")).trim();

    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        if(op.equals("del")){
           int ischeckop = 0 ;
           String mess = "";
           SpManage sm = new SpManage();
           ischeckop = sm.getSpOperischeck(spIndex);
            ColorRing colorRing = new ColorRing();
            // 查询铃音信息
            Map hash1 = (Map)colorRing.getRingInfo(ringid);
            if(hash1==null||hash1.size()<=0)
                    throw new Exception("The ring doesn't exist!");
          if(ischeckop==0)
          {
            String crid = request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid");
            String craccount = libid;
            String count = request.getParameter("count") == null ? "" : (String)request.getParameter("count");
            String stype=request.getParameter("ctype") == null ? "1" : (String)request.getParameter("ctype");
            manSysRing manring = new manSysRing();
            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","203");
            map.put("RESULT","1");
            map.put("PARA1",crid);
            map.put("PARA2",ringlabel);
            map.put("PARA3","ip:"+request.getRemoteAddr());
            Hashtable hash = new Hashtable();
            if("3".equals(ringidtype)){
              int countflag=1;
              int no=0;
              int scpindex = 0;
              Hashtable tRet = null;
              while(countflag==1){
                tRet = manring.forcedelringgrp(scpindex,crid);
                scpindex = Integer.parseInt((String)tRet.get("scpindex"));
                countflag = Integer.parseInt((String)tRet.get("flag"));
                if(countflag==0) //已删除完成
                break;
                try {
                  java.lang.Thread.sleep(2000);
                  //System.out.println("sleep 2s");
                }
                catch (Exception e) {
                }
              }
              sysInfo.add(sysTime + operName + ",Succeed to delete ring group forcely!");
              map.put("DESCRIPTION","delete ring group forcely");
              purview.writeLog(map);
              mess = "Succeed to delete ring group forcely!";
            }else if(count.equals("1")){
              int countflag=1;
              int no=0;
              int scpindex = 0;
              Hashtable tRet = null;
              int itype=Integer.parseInt(stype);
              while(countflag==1){
                tRet = manring.forcedel(scpindex,crid,itype);
                //   tRet = manring.forcedel(scpindex,crid);
                scpindex = Integer.parseInt((String)tRet.get("scpindex"));
                countflag = Integer.parseInt((String)tRet.get("flag"));
                if(countflag==0) //已删除完成
                break;
                try {
                  java.lang.Thread.sleep(2000);
                  //System.out.println("sleep 2s");
                }
                catch (Exception e) {
                }

              }
              sysInfo.add(sysTime + operName + ",Succeed to delete ring  forcely!");
              map.put("DESCRIPTION","delete ring  forcely!");
              purview.writeLog(map);
              mess = "Succeed to delete ring  forcely!";
            }
            //            else{
              //                hash.put("opcode","01010203");
              //                hash.put("craccount",craccount);
              //                hash.put("crid",crid);
              //                hash.put("ret1","");
              //                Hashtable result = SocketPortocol.send(pool,hash);
              //                sysInfo.add(sysTime + operName + ",Succeed to delete ring  forcely!");
              //                map.put("DESCRIPTION","delete ring  forcely!");
              //                purview.writeLog(map);
              //            }
            }else
            {
              ArrayList ls = null;
              Hashtable tmp = null;
              HashMap opmap = new HashMap();
               opmap.put("operid",spIndex);
               opmap.put("opername",operName);
               opmap.put("opertype","1");
               opmap.put("status","0");
               opmap.put("ringid",(String)hash1.get("ringid"));
               opmap.put("operdesc","");
               opmap.put("refusecomment","");
               opmap.put("ringfee",(String)hash1.get("ringfee"));
               opmap.put("ringlabel",(String)hash1.get("ringlabel"));
               opmap.put("singgername",(String)hash1.get("ringauthor"));
               opmap.put("validdate",(String)hash1.get("validtime"));
               opmap.put("ringspell",(String)hash1.get("ringspell"));
               opmap.put("uservalidday",(String)hash1.get("uservalidday"));
               manSysRing manring = new manSysRing();
             ls = manring.addoperCheck(opmap);
           for(int i=0;i<ls.size();i++)
           {
             tmp = (Hashtable)ls.get(i);
             if(!"0".equalsIgnoreCase(tmp.get("result").toString().trim()))
                  mess+=tmp.get("scp").toString().trim()+"-"+tmp.get("reason").toString().trim()+" ";
           }
           if(mess.trim().equalsIgnoreCase(""))
              mess = "Succeed to insert the verification data!";
           else
              mess = "Failed to insert the verification data,SCP:("+mess+")";
            }
            %>
                <script language="JavaScript">
                <%if(!mess.trim().equalsIgnoreCase("")){%>
                window.alert('<%=mess%>');
                <%}%>
                window.returnValue = "yes";
                window.close();
                </script>
      <% }else{
                  manSysRing manring = new manSysRing();
                  int usingCount = 1;
//                  if("3".equals(ringidtype)){
//                    usingCount = manring.getSysRingGrpCount(ringid);
//                  }else{
//                    usingCount = manring.getSysRingCount(ringid);
//                  }
%>
<form name="inputForm" method="post" action="delRing1.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="libid" value="<%=libid%>">
<input type="hidden" name="count" value="<%=((usingCount>0)?"1":"0")%>">
<input type="hidden" name="ringid" value="<%=ringid%>">
<input type="hidden" name="ringidtype" value="<%=ringidtype%>">
<table width="377" align="center" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
    <td>
      <br>
      <table  width="100%"  border="0">
      <tr>
          <td width="100%" align="center" valign="middle">
              <div id="hintContent" >
                  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" >
  <tr>
    <td><img src="../manager/image/007.gif" width="377" height="15"></td>
  </tr>

                      <tr>
                          <td background="../manager/image/009.gif"   height="91"> <div align="center">

                  <%
                  if(usingCount>0){
                   	out.println("&nbsp;<p>The ring has been used by "+ usingCount+" user !<br>Are you sure to delete it?<br><br><p>&nbsp;");
              		if(manring.getParameter(52)==1){ %>
                		Delete mode <select name="dspctype" size="1" onChange="acttype()">
                		<option value="2">Only the ring configure</option>
                		<option value="1">Both the ring and configure</option>
                		</select>
              <%}
                  }else{
                      out.println("&nbsp;<p>Are you sure to delete the ring "+ringid+" ?<br><br><p>&nbsp;");
                  }
              %>
</div></td>
  </tr>
  <tr>
    <td><img src="../manager/image/008.gif" width="377" height="15"></td>
  </tr>
</table>
              </div>
          </td>
      </tr>
      <tr>
          <td width="100%" align="center" height="16" align="center">
              <img src="../manager/button/sure.gif" alt="Ok" onmouseover="this.style.cursor='hand'" onclick="javascript:ok()" >
                  &nbsp;&nbsp;
              <img src="../manager/button/cancel.gif" alt="Cancel" onmouseover="this.style.cursor='hand'" onclick="javascript:cancel()" >
        </td>
          </tr>
        </table>

    </td>
  </tr>
</table>
</form>
<%
}
    }
    catch(Exception e) {
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + ",Exception occurred in deleting ring " + ringid + "!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in deleting ring!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
   alert("Failed to delete ring <%= ringid%>:<%= e.getMessage() %>");
   window.close();
</script>
<%
    }
%>
</body>
</html>
