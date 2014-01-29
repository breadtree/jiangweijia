<%@ page import="java.util.HashMap" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>ringtone center management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manCRBT syscrbt = new manCRBT();
        sysTime = syscrbt.getSysTime() + "--";
        if (operID != null && purviewList.get("15-1") != null) {
            ArrayList vet = new ArrayList();
            HashMap hash = new HashMap();
            ArrayList rList  = new ArrayList();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String crbtcode = request.getParameter("crbtcode") == null ? "" : transferString((String)request.getParameter("crbtcode")).trim();
            String crbtid = request.getParameter("crbtid") == null ? "1" : transferString((String)request.getParameter("crbtid")).trim();
            String crbtname = request.getParameter("crbtname") == null ? "" : transferString((String)request.getParameter("crbtname")).trim();
            String crbttype = request.getParameter("crbttype") == null ? "" : transferString((String)request.getParameter("crbttype")).trim();
            String crbtstate = request.getParameter("oldcrbtstate") == null ? "1" : transferString((String)request.getParameter("oldcrbtstate")).trim();

            int optype = 0;
            String  sTmp = "";
            String  title = "";
            HashMap map = new HashMap();
            String  sDesc = "";
            if (op.equals("add")) {
                optype = 0;
                sTmp = sysTime + operName + "Add CRBT";
                title = "Add CRBT " + crbtname;
                sDesc = "Add";
                crbtstate="1";

             }
            else if (op.equals("edit")) {
                optype = 1;
                sTmp = sysTime + operName + " Edit CRBT";//EditCRBT
                title = "Edit CRBT " + crbtname;
                sDesc = "Edit";
            }
            else if (op.equals("del")) {
                optype = 2;
                sTmp = sysTime + operName + "Delete CRBT";
                title = "Delete CRBT " + crbtname;
                sDesc = "Delete";
            }
            if(op.equals("add") || op.equals("edit") || op.equals("del") ){
                hash.put("optype",optype+"");
                hash.put("crbtcode",crbtcode);
                hash.put("crbtid",crbtid);
                hash.put("crbtname",crbtname);
                hash.put("crbttype",crbttype);
                hash.put("crbtstate",crbtstate);
                rList = syscrbt.setCRBT(hash);

                // 准备写操作员日志
                if(getResultFlag(rList)){
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","701");
                  map.put("RESULT","1");
                  map.put("PARA1",crbtid);
                  map.put("PARA2",crbtcode);
                  map.put("PARA3",crbtname);
                  map.put("PARA4",crbttype);
                  map.put("PARA5","ip:"+request.getRemoteAddr());
                  zxyw50.Purview purview = new zxyw50.Purview();
                  purview.writeLog(map);
                }
                sysInfo.add(sTmp);
                if(rList.size()>0){
                session.setAttribute("rList",rList);
                %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="crbt.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
              <%
                }

            }else if(op.equals("resume")){
        			SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
               Hashtable hs=new Hashtable();
               hs.put("opcode","01010405");
               hs.put("crbtid",crbtid);
               Hashtable result = SocketPortocol.send(pool,hs); %>

 <script language="JavaScript">
	//alert('您的彩铃中心<%=  crbtid  %>已恢复告警设置成功!');
          alert('Your CRBT center <%=  crbtid  %> have restored warning setting successfully!');
</script>
<%
            }
            vet = syscrbt.getCRBTInfo();
%>
<script language="javascript">
   var v_crbtid = new Array(<%= vet.size() + "" %>);
   var v_crbtcode = new Array(<%= vet.size() + "" %>);
   var v_crbtname = new Array(<%= vet.size() + "" %>);
   var v_crbttype = new Array(<%= vet.size() + "" %>);
   var v_crbtstate = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                map = (HashMap)vet.get(i);
%>
   v_crbtid[<%= i + "" %>] = '<%= (String)map.get("crbtid") %>';
   v_crbtcode[<%= i + "" %>] = '<%= (String)map.get("crbtcode") %>';
   v_crbtname[<%= i + "" %>] = '<%= (String)map.get("crbtname") %>';
   v_crbttype[<%= i + "" %>] = '<%= (String)map.get("crbttype") %>';
   v_crbtstate[<%= i + "" %>] ='<%= (String)map.get("crbtstate") %>';
<%
        }
%>

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '') {
         fm.spcode.focus();
         return;
      }
      fm.oldcrbtid.value = v_crbtid[index];
      fm.crbtcode.value = v_crbtcode[index];
      fm.crbtid.value = v_crbtid[index];
      fm.crbtname.value = v_crbtname[index];
      fm.crbttype.value = v_crbttype[index];
      fm.crbtstate.value = v_crbtstate[index];
      fm.oldcrbtstate.value=fm.crbtstate.value;
      fm.crbtid.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;

      if (!checkstring('0123456789',trim(fm.crbtcode.value))) {
         alert('CRBT code can only contain digital number!');//郑?);
         fm.crbtcode.focus();
         return flag;
      }
      if (trim(fm.crbtname.value) == '') {
         //alert('请输入彩铃名称!');
          alert('Please input the CRBT name!');
         fm.crbtname.focus();
         return flag;
      }

      if (!CheckInputStr(fm.crbtname,'CRBT name')){
         fm.crbtname.focus();
         return flag;
      }

      if (trim(fm.crbttype.value) == '') {
         //alert('请输入彩铃中心类型!');
         alert('Please input the CRBT center type!');
         fm.crbttype.focus();
         return flag;
      }


      flag = true;
      return flag;
   }

   function checkCode (index) {
      var fm = document.inputForm;
      var code = trim(fm.crbtcode.value);
      for (i = 0; i < v_crbtcode.length; i++)
         if (code == v_crbtcode[i])
            return true;
      return false;
   }

   function checkID (index) {
      var fm = document.inputForm;
      var code = trim(fm.crbtid.value);
      for (i = 0; i < v_crbtid.length; i++)
         if (code == v_crbtid[i])
            return true;
      return false;
   }
 function actResume(){
      var fm = document.inputForm;
      if (fm.infoList.length == 0) {
         //alert('对不起,没有可供恢复的CRBT!');
         alert('sorry,there is no restored CRBT!');
         return;
      }
      if (fm.infoList.selectedIndex == -1) {
         //alert('请先选择您要恢复状态的CRBT!');
         alert('please select the CRBT you want to restore at first!');
         return;
      }
      fm.crbtid.value = fm.oldcrbtid.value;
      fm.op.value = 'resume';
      fm.submit();
 }
   function addInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      if (checkID(-1)) {
        // alert('该CRBT ID已经在使用,不能添加!');
         alert('The CRBT ID have always in used,cannot be added!');
         fm.crbtid.focus();
         return;
      }
      if (checkCode(-1)) {
         //alert('该CRBT code已经在使用,不能添加!');
         alert('The CRBT ID have always in used,cannot be added!');
        fm.crbtcode.focus();
         return;
      }
      fm.op.value = 'add';
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      if (fm.infoList.length == 0) {
      //   alert('对不起,没有可供更改的CRBT!');
           alert('sorry,there is no CRBT that can be changed!');
         return;
      }
      if (fm.infoList.selectedIndex == -1) {
        // alert('请先选择您要更改的CRBT!');
         alert('Please select the CRBT that you want to change!');
         return;
      }
      if (! checkInfo())
         return;
      fm.crbtid.value = fm.oldcrbtid.value;
      fm.op.value = 'edit';
      fm.submit();
   }




   function delInfo () {
      var fm = document.inputForm;
      if (fm.infoList.length == 0) {
         //alert('对不起,没有可供删除的CRBT!');
          alert('Sorry,there is no CRBT that can be changed!');
          return;
      }
      if (fm.infoList.selectedIndex == -1) {
        // alert('请先选择您要删除的CRBT!');
         alert('Please select the CRBT that you want to change!');
         return;
      }
      fm.crbtid.value = fm.oldcrbtid.value;
      fm.op.value = 'del';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		 parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="crbt.jsp">
<input type="hidden" name="oldcrbtid" value="">
<input type="hidden" name="oldcrbtstate" value="">

<input type="hidden" name="op" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">CRBT management</td>
        </tr>
        <tr>
          <td valign="top" rowspan="8">
            <select name="infoList" size="14" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                    map = (HashMap)vet.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)map.get("crbtcode") + "---" + (String)map.get("crbtname") %></option>
<%
            }
%>
            </select>
          </td>
          <td align="right">CRBT&nbsp;&nbsp;ID</td>
          <td><select name="crbtid" size="1" value="<%=crbtid %>">
          <%for(int i=1;i<21;i++){%>
          	<option value="<%=i%>"><%=i%></option>
          <%}%>
          </select>
        </tr>
        <tr>
 	  <td align="right">CRBT&nbsp;&nbsp;code</td>
          <td><input type="text" name="crbtcode" value="" class="input-style1" maxlength="10"></td>        </tr>
         <tr>
          <td align="right">CRBT&nbsp;&nbsp;name</td>
          <td><input type="text" name="crbtname" value="" maxlength="40" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">CRBT type</td>
          <td><select name="crbttype" size="1">
          	<option value="0">CRBT center</option>
          	<option value="1">CRBT center and integer</option>
          </select>
        </tr>
         <tr>
          <td align="right">CRBT state</td>
          <td><select name="crbtstate" size="1" disabled>
          	<option value="1">Valid</option>
          	<option value="0">invalid</option>
          </select></td>
        </tr>
         <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="25%" align="center"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                <td width="25%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                <td width="25%" align="center"><img src="button/huifugaojin.gif" onmouseover="this.style.cursor='hand'"  onclick="javascript:actResume()"></td>
                <td width="25%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr >
          <td height="26" colspan="3" >
           <table border="0" width="100%" class="table-style2">
              <tr>
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
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occour on the management of CRBT!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(" Error occour on the management of CRBT!");//CRBT管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="crbt.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
