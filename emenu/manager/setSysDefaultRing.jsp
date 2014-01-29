<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
     public String display (Map map) throws Exception {
        try {
            String str = (String)map.get("ringid") + "--" + (String)map.get("ringlable");
            return str;
        }
        catch (Exception e) {
            throw new Exception ("Get the uncorrect data!");
        }
    }
%>
<html>
<head>
<title>Set default system ringtone</title>
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
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-14") != null) {
            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            Hashtable map1= new Hashtable();
            Map hash = null;
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
            String ringlabel = request.getParameter("ringlabel") == null ? "" : transferString((String)request.getParameter("ringlabel")).trim();
            String rsubindex = "0";
            int optype = 0;
            String title = "";
            if (op.equals("add")){
                optype = 1;
                title = "Set default system "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone");

            }
            else if (op.equals("del")) {
                optype = 2;
                title = "Set default system "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone");
            }
            if(optype>0){
               map1.put("ringid",ringid);
               map1.put("type","0");
               map1.put("opcode",optype+"");
               map1.put("para1","1");
               map1.put("newringid","0");
               rList = sysring.setSysDefaultRing(map1);
               // 准备写操作员日志
               if(getResultFlag(rList)){
                 zxyw50.Purview purview = new zxyw50.Purview();
                 map.put("OPERID",operID);
                 map.put("OPERNAME",operName);
                 map.put("OPERTYPE","213");
                 map.put("RESULT","1");
                 map.put("PARA1",ringid);
                 map.put("PARA2",ringlabel);
                 map.put("PARA3","ip:"+request.getRemoteAddr());
                 map.put("DESCRIPTION",title);
                 purview.writeLog(map);
               }
                 if(rList.size()>0){
                   session.setAttribute("rList",rList);
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="setSysDefaultRing.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }


            }
            List vet = null;
            vet = sysring.querySysDefaultRing(0);//系统默认铃音
 %>
<script language="javascript">

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '')
         return;
      fm.ringid.value = v_ringid[index];
      fm.ringlabel.value = v_ringlabel[index];
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.ringid.value);
      if(value==''){
         alert("Please enter the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code");//请输入Ringtone code!
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert("The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code only can be a digital number");//Ringtone code必须是数字!
         fm.ringid.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      if(!checkInfo())
        return;
      fm.op.value = 'add';
      fm.submit();
   }
   function queryInfo() {
    var result =  window.showModalDialog('ringSearch.jsp?hidemediatype=1&mediatype=1',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
    if(result){
       document.inputForm.ringid.value=result;
         }
   // var result =  window.open('ringSearch.jsp?hidemediatype=1&mediatype=1','mywin','left=20,top=20,width=600,height=550,toolbar=1,resizable=0,scrollbars=yes');
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(fm.index.length==0){
         alert("Sorry,you must deploy the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> of special area first!");//对不起,您必须先配置特别专区铃音!
         return;
      }
      if(index == -1){
          alert("Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> of special area for editing!");//请选择您要Edit的特别专区铃音
          return;
      }
      if(!checkInfo())
        return;
      fm.submit();
      fm.op.value = 'edit';
   }

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> of special area for deleting");//请选择您删除的特别专区铃音
          return;
      }
     fm.op.value = 'del';
     fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="setSysDefaultRing.jsp">
<input type="hidden" name="op" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Set default system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
        </tr>
        <td height='100%'>
            <table width="100%" border =0 class="table-style2" height='100%'>
            <tr>
             <td width="30%" align=right><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
             <td><input type="text" name="ringlabel" value="" maxlength="40" class="input-style1"  disabled ></td>
            </tr>
            <tr>
             <td width="30%" align=right><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
             <td><input type="text" name="ringid" value="" maxlength="20" class="input-style1"  ><img src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:queryInfo()">
             </td>
            </tr>
            <tr>
                <!--
             <td  style="color: #FF0000" colspan=2 height=30> &nbsp;&nbsp;注意:“排列序号”是数字型字符串</td>
             -->
            </tr>
            <tr>
            <td colspan="2" align="center">
              <table border="0" width="100%" class="table-style2"  align="center">
              <tr>
                <td width="100%" align="center"><img src="../button/defaultring.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:addInfo()"></td>
             </tr>
              </table>
            </td>
            </tr>
			<% %> 
			<tr> <td colspan="2" align="center">
			  <select name="infoList" size="10" <%= vet.size() == 0 ? "disabled " : "" %> class="input-style1" onclick="javascript:selectPrePost()" style="width:200" >
            <%
            for (int i = 0; i < vet.size(); i++) {
               Map map2 = null;
			   map2 = (Map)vet.get(i);
               out.println("<option value=" + String.valueOf(i) + " >" + display(map2) + "</option>");
            }
			%>
                </select>
			</td>
			</tr>
			<tr>
			<td colspan="2" align="center">
			<table border="0" width="100%" class="table-style2"  align="center">
              <tr>
			  <td width="100%" align="center"><img src="button/del.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:delInfo()"></td>
			  </tr>
			 </table>
			</td>
			</tr>
			<%%>
            </table>
     </td>
     </tr>

     </table>
  </td>
  </tr>
</table>
</form>
<script >
   var v_ringid = new Array(<%= vet.size() + "" %>);
   var v_ringlabel = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Map)vet.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlable") %>';
<%}if(vet.size()>0){%>
document.inputForm.ringlabel.value = v_ringlabel[0];
document.inputForm.ringid.value = v_ringid[0];
<%}
	for (int i = 0; i < vet.size(); i++) {
	hash = (Map)vet.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlable") %>';
<%}
	if(vet.size()>0) { %>
		document.inputForm.ringlabel.value = v_ringlabel[0];
		document.inputForm.ringid.value = v_ringid[0];
<% } 
 %>

function selectPrePost () {
     var fm = document.inputForm;
     var index = fm.infoList.selectedIndex;
     if (index <0 || index >=v_ringlabel.length)
        return;
     fm.ringid.value = v_ringid[index];
     fm.ringlabel.value = v_ringlabel[index];
     document.getElementById('ringid').readOnly = true; 
 }
</script>
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
        sysInfo.add(sysTime + operName + "Exception occurred in setting default system ringtone!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Errors occurred in setting default system ringtone!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="setSysDefaultRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
