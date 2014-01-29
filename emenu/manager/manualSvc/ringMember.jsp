<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.ringAdm" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ include file="../../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Ringtone Group Member Management</title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String sysTime = "";
    String craccount = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String ringgroup = request.getParameter("ringgroup") == null ? "" : ((String)request.getParameter("ringgroup")).trim();
    String grpLabel = request.getParameter("grpLabel") == null ? "" : transferString(((String)request.getParameter("grpLabel")).trim());
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ringdisplay = " Ringtone ";//铃音
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String crid = request.getParameter("crid") == null ? "" : ((String)request.getParameter("crid")).trim();
        craccount = request.getParameter("craccount") == null ? "" : ((String)request.getParameter("craccount")).trim();
        String  mediatype = request.getParameter("mediatype") == null ? "" : ((String)request.getParameter("mediatype")).trim();
        Hashtable hash = new Hashtable();
        Hashtable groupInfo = new Hashtable();
        Vector vetGroupRing = new Vector();
        Vector vetNoGroupRing = new Vector();
        Hashtable tmp = new Hashtable();
        Hashtable result = new Hashtable();
        if (craccount != null) {
            ringAdm ringadm = new ringAdm();
            hash.put("usernumber",craccount);
            hash.put("ringgroup",ringgroup);
            hash.put("ringid",crid);
            hash.put("mediatype",mediatype);
            // 如果是增加铃音组成员
            if (op.equals("add")) {
                ringadm.addRingInGroup(hash);
                sysInfo.add(sysTime + operName +  " add member "+ crid +" for user " + craccount + "'s ringtone group " + ringgroup);//sysInfo.add(sysTime + operName +  "为用户" + craccount + "的铃音组" + ringgroup +"增加成员" + crid );

                HashMap map = new HashMap();
                zxyw50.Purview purview = new zxyw50.Purview();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("HOSTNAME",request.getRemoteAddr());
                map.put("SERVICEKEY",ColorRing.getSerkey());
                map.put("OPERTYPE","54");
                map.put("RESULT","1");
                map.put("PARA1","ip:"+request.getRemoteAddr());
                map.put("DESCRIPTION",operName +  " add member "+ crid +" for user " + craccount + "''s ringtone group " + ringgroup);//  map.put("DESCRIPTION",operName +  "为用户" + craccount + "的铃音组" + ringgroup +"增加成员" + crid );
                purview.writeLog(map);
            }
            // 如果是删除铃音组成员
            if (op.equals("del")) {
                ringadm.delRingFromGroup(hash);
                sysInfo.add(sysTime + operName +  " delete member "+ crid +" for user " + craccount + "'s ringtone group " + ringgroup);//  sysInfo.add(sysTime + operName +  "为用户" + craccount + "的铃音组" + ringgroup +"删除成员" + crid );
                HashMap map = new HashMap();
                zxyw50.Purview purview = new zxyw50.Purview();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("HOSTNAME",request.getRemoteAddr());
                map.put("SERVICEKEY",ColorRing.getSerkey());
                map.put("OPERTYPE","54");
                map.put("RESULT","1");
                map.put("PARA1","ip:"+request.getRemoteAddr());
                map.put("DESCRIPTION",operName +  " delete member "+ crid +" for user " + craccount + "''s ringtone group " + ringgroup);//map.put("DESCRIPTION",operName +  "为用户" + craccount + "的铃音组" + ringgroup +"删除成员" + crid );
                purview.writeLog(map);
            }
            // 查询铃音组成员信息
            vetGroupRing = (Vector)ringadm.getRingFromGroup(hash);
            vetNoGroupRing = (Vector)ringadm.getRingNotInGroup(hash);
%>
<script language="javascript">
   var   ringdisplay = "<%=  ringdisplay  %>";
   function addRing () {
      var fm = document.inputForm;
      if ((fm.outRing.selectedIndex) < 0) {
         alert('Please select the ' + ringdisplay + ' to be added to the ' + ringdisplay + ' group!');//('请选择添加到' + ringdisplay + '组中的' + ringdisplay + '!')
         return;
      }
      fm.op.value = 'add';
      fm.crid.value = fm.outRing.value;
      fm.submit();
   }

   function delRing () {
      var fm = document.inputForm;
      if ((fm.inRing.selectedIndex) < 0) {
         alert('Please select the ' + ringdisplay + ' to be deleted from ' + ringdisplay + ' group!');
         return;
      }
      fm.op.value = 'del';
      fm.crid.value = fm.inRing.value;
      fm.submit();
   }
   function windowClose(){
   	window.close();
   }
</script>
<form name="inputForm" method="post" action="ringMember.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="crid" value="">
<input type="hidden" name="craccount" value="<%= craccount %>">
<input type="hidden" name="ringgroup" value="<%= ringgroup %>">
<input type="hidden" name="grpLabel" value="<%= grpLabel %>">
<input type="hidden" name="mediatype" value="<%= mediatype %>">
  <table width="551" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td valign="top" bgcolor="#FFFFFF">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
                <tr>
                  <td width="28"><img src="../../image/home_r14_c3.gif" width="28" height="31"></td>
                  <td background="../../image/home_r14_c5bg.gif"><font color="#006600"><b></b>
                    <b><font class="font"> <%=  ringdisplay  %>&nbsp; group member management</font></b></font></td>
                  <td width="12"><img src="../../image/home_r14_c5.gif" width="12" height="31"></td>
                </tr>
              </table>
              <table width="100%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
                <tr valign="top">
                  <td width="100%">
				   <table width="100%" border="0" cellpadding="2" cellspacing="1" class="table-style3">
                      <tr>
					  <td colspan="3">The &nbsp;<%=  ringdisplay  %>&nbsp;group:&nbsp;&nbsp;&nbsp;<%= ringgroup + "-" + grpLabel %></td>
                      </tr>
                      <tr class="table-styleshow">
                        <td><%=  ringdisplay  %>&nbsp; in the&nbsp;<%=  ringdisplay  %>&nbsp;group</td>
                        <td>&nbsp;</td>
                        <td><%=  ringdisplay  %> not contained in the <%=  ringdisplay  %>&nbsp;group</td>
                      </tr>
                      <tr> <td>
                  <select name="inRing" size="8" <%= vetGroupRing.size() == 0 ? "disabled " : "" %> class="select-style3">
                            <%
                for (int i = 0; i < vetGroupRing.size(); i++) {
                    hash = (Hashtable)vetGroupRing.get(i);
%>
                            <option value="<%= (String)hash.get("ringid") %>" selected><%= (String)hash.get("ringid") + "-----------" + (String)hash.get("ringlabel") %></option>
                            <%
            }
%>
                          </select> </td>
                        <td align="center" valign="center"> <input type="button" name="add2" value="<<" onclick="javascript:addRing()" <%= vetNoGroupRing.size() == 0 ? "disabled" : "" %>>
                          <p>&nbsp; <p>
                  <input type="button" name="del" value=">>" onclick="javascript:delRing()" <%= vetGroupRing.size() == 0 ? "disabled" : "" %>>
                        </td>
                  <td>
                  <select name="outRing" size="8" <%= vetNoGroupRing.size() == 0 ? "disabled " : "" %> class="select-style3">
                            <%
                for (int i = 0; i < vetNoGroupRing.size(); i++) {
                    hash = (Hashtable)vetNoGroupRing.get(i);
%>
                            <option value="<%= (String)hash.get("ringid") %>"><%= (String)hash.get("ringid") + "-----------" + (String)hash.get("ringlabel") %></option>
                            <%
            }
%>
                          </select> </td>
                      </tr>
                      <tr>
                        <td colspan="3">
						<table border="0" width="100%" class="table-style2">
                            <tr>
                              <td align="center"><img src="../../button/close.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:windowClose()"></td>
                            </tr>
                          </table>
						  </td>
                      </tr>
                    </table>

                  </td>
                </tr>
                <tr valign="top">
                  <td width="100%">
				  <table width="90%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
                      <tr>
                        <td class="table-styleshow" background="../../image/n-9.gif" height="26">
                          Help information:</td>
                      </tr>
                      <tr>
                        <td>1.Click &nbsp;'&lt;&lt;'&nbsp;button,add&nbsp;<%=  ringdisplay  %>&nbsp;to&nbsp;<%=  ringdisplay  %>&nbsp;group;</td>
                      </tr>
                      <tr>
                        <td>2.Click '&gt;&gt;'&nbsp;button,delete&nbsp;<%=  ringdisplay  %>&nbsp;from &nbsp;<%=  ringdisplay  %>&nbsp;group;</td>
                      </tr>
                       </table></td>
                </tr>
              </table></td>
          </tr>
        </table>
        </td>
    </tr>
    </table>

</form>
<%
        }
        else {
%>
<script language="javascript">
   alert('Please log in first!');//请先登录
parent.document.location.href = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount + ringdisplay  + "Exception occurred during group member management!");//组成员管理过程出现异常
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add(ringdisplay + "Error occurred during group member management!");//组成员管理错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
   alert("<%= e.getMessage()  %>");
   window.close();
</script>
<%
    }
%>
</body>
</html>
