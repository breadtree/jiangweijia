<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>IP Management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("isMS","0");
    int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        ArrayList rList  = new ArrayList();
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-9") != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String ipid = request.getParameter("iplist") == null ? "" : transferString((String)request.getParameter("iplist")).trim();
            String iptype = request.getParameter("iptype") == null ? "0" : transferString((String)request.getParameter("iptype")).trim();
            String ipname = request.getParameter("ipname") == null ? "" : transferString((String)request.getParameter("ipname")).trim();
            String ipaddr = "1234567";
            String ipgt = request.getParameter("ipgt") == null ? "" : transferString((String)request.getParameter("ipgt")).trim();
            String agentipaddr = request.getParameter("agentipaddr") == null ? "" : transferString((String)request.getParameter("agentipaddr")).trim();
            String agentport = request.getParameter("agentport") == null ? "0" : transferString((String)request.getParameter("agentport")).trim();
            String ipphone = request.getParameter("ipphone") == null ? "0" : transferString((String)request.getParameter("ipphone")).trim();
            String postoffice= request.getParameter("postoffice") == null ? "0" : transferString((String)request.getParameter("postoffice")).trim();
            if(agentport.equals(""))
                agentport = "0";
            if(postoffice.equals(""))
                postoffice="0";
            if(checkLen(ipname,30))
            	throw new Exception("The length of the IP name you entered has exceeded the limit. Please re-enter!");

            int  optype =0;
            String title = "";
            String desc = "";
            if (op.equals("add")) {
                optype = 1;
                desc  = operName + "Add IP";
                title = "Add IP";
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + "Modify IP";
                title = "Modify IP";
            }
            else if (op.equals("del")) {
                optype = 2;
                desc  = operName + "Delete IP";
                title = "Delete IP";
             }
             if(optype>0){
                hash.put("optype",optype+"");
                hash.put("ipid",ipid);
                hash.put("ipname",ipname);
                hash.put("ipaddr",ipaddr);
                hash.put("ipgt",ipgt);
                hash.put("agentipaddr",agentipaddr);
                hash.put("agentport",agentport);
                hash.put("ipphone",ipphone);
                hash.put("postoffice",postoffice);
                //如果配置打开则传入ismultimedia值
                if("1".equals(ismultimedia) ){
                  hash.put("iptype",iptype);
                }else{
                  hash.put("iptype","0");
                }
                rList = syspara.setIP(hash);
                sysInfo.add(sysTime + desc);

                if(getResultFlag(rList)){
                  // 准备写操作员日志
                   zxyw50.Purview purview = new zxyw50.Purview();
                   HashMap map = new HashMap();
                   map.put("OPERID",operID);
                   map.put("OPERNAME",operName);
                   map.put("OPERTYPE","301");
                   map.put("RESULT","1");
                   map.put("PARA1",ipid);
                   map.put("PARA2",ipname);
                   map.put("PARA3",agentipaddr);
                   map.put("PARA4",agentport);
                   map.put("PARA5",ipphone);
                   map.put("PARA6",postoffice);
                   map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                   purview.writeLog(map);
                }
                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="IpInfo.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }
            if("1".equals(ismultimedia)){
           vet = syspara.getIPInfo();
           }else{
             vet=syspara.getIPInfoMrb(0);
           }
%>
<script language="javascript">
   var v_iptype=new Array(<%= vet.size() + "" %>);
   var v_ipname = new Array(<%= vet.size() + "" %>);
   var v_ipaddr = new Array(<%= vet.size() + "" %>);
   var v_ipgt = new Array(<%= vet.size() + "" %>);
   var v_agentipaddr = new Array(<%= vet.size() + "" %>);
   var v_agentport = new Array(<%= vet.size() + "" %>);
   var v_ipphone = new Array(<%= vet.size() + "" %>);
   var v_postoffice=new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_iptype[<%= i + "" %>] = '<%= (String)hash.get("iptype") %>';
   v_ipname[<%= i + "" %>] = '<%= (String)hash.get("ipname") %>';
   v_ipaddr[<%= i + "" %>] = '<%= (String)hash.get("ipaddr") %>';
   v_ipgt[<%= i + "" %>] = '<%= (String)hash.get("ipgt") %>';
   v_agentipaddr[<%= i + "" %>] = '<%= (String)hash.get("agentipaddr") %>';
   v_agentport[<%= i + "" %>] = '<%= (String)hash.get("agentport") %>';
   v_ipphone[<%= i + "" %>] = '<%= (String)hash.get("ipphone") %>';
   v_postoffice[<%= i + "" %>] = '<%= (String)hash.get("postoffice") %>';

<%
            }
%>



   // 检查输入的IP地址的准确性
   function checkIP () {
      var tmp = document.inputForm.agentipaddr.value;
      var index = tmp.indexOf('.');
      var ip;
      // 检查IP地址第一段
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 1 || ip > 255) {
         alert('Error in inputting proxy process IP address!');//代理进程IP地址输入错误!
         document.inputForm.agentipaddr.focus();
         return false;
      }
      // 检查IP地址第二段
      tmp = tmp.substring(index + 1,tmp.length);
      index = tmp.indexOf('.');
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
         alert('Error in inputting proxy process IP');//代理进程IP输入错误!
         document.inputForm.agentipaddr.focus();
         return false;
      }
      // 检查IP地址第三段
      tmp = tmp.substring(index + 1,tmp.length);
      index = tmp.indexOf('.');
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
         alert('Error in inputting proxy process IP');//代理进程IP输入错误!
         document.inputForm.agentipaddr.focus();
         return false;
      }
      // 检查IP地址第四段
      ip = tmp.substring(index + 1,tmp.length);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
         alert('Error in inputting proxy process IP');//代理进程IP输入错误!
         document.inputForm.agentipaddr.focus();
         return false;
      }
      return true;
   }

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.iplist.selectedIndex;
      if (index <0 || index >=v_ipname.length)
         return;
      fm.ipname.value = v_ipname[index];
      fm.ipgt.value = v_ipgt[index];
      fm.agentipaddr.value = v_agentipaddr[index];
      var  port = v_agentport[index];
      if(port==0)
           port ='';
      fm.agentport.value =  port;

      fm.ipphone.value = v_ipphone[index];
      var office=v_postoffice[index];
      if(office==0)
      office='';
      fm.postoffice.value=office
      fm.iptype.value=v_iptype[index];
      fm.ipname.focus();
   }


   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.ipname.value) == '') {
         alert('Please enter an IP name');//请输入IP名称!
         fm.ipname.focus();
         return flag;
      }
       <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.ipname.value,30)){
            alert("The ip name should not exceed 30 bytes!");
            fm.ipname.focus();
            return;
          }
        <%
        }
        %>
      var valueStr = trim(fm.ipphone.value);
      var num1 = valueStr.indexOf("'");
      var num2 = valueStr.indexOf("\"");
      var num3 = valueStr.indexOf("\'");
      var num4 = valueStr.indexOf("\"");
      var num5 = valueStr.indexOf("\'");
      var num6 = valueStr.indexOf("\`");
      if(num1>=0||num2>=0||num3>=0||num4>=0||num5>=0||num6>=0){
        //alert('不能输入单引号或双引号!');
        alert('cannot input single quotes or double quotes!');
        fm.ipphone.focus();
        return;
      }
      if (!CheckInputStr(fm.ipname,'IP name')){
         fm.ipname.focus();
         return  flag;
      }
      if (trim(fm.ipaddr.value) == '') {
         alert('Please enter the pilot line');//请输入引示线!
         fm.ipaddr.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.ipaddr.value))) {
         alert('The pilot line can only be a digital number');//引示线只能为数字!
         fm.ipaddr.focus();
         return flag;
      }
      if (trim(fm.ipgt.value) == '') {
         alert('Please enter an GT code!');//请输入GT编码!
         fm.ipgt.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.ipgt.value))) {
         alert('GT code can only contain digits!');//GT编码只能为数字!
         fm.ipgt.focus();
         return flag;
      }
      var value = trim(fm.agentipaddr.value);
      var port = trim(fm.agentport.value);
      if(value =='' && port !=''){
         alert("Please enter the IP adress of the proxy process!");//请输入代理进程IP地址!
         return flag;
      }
      if(value!='' && port ==''){
         alert("Please enter the port number of the proxy process!");//请输入代理进程端口号
         return flag;
      }
      if (value != '') {
         if(!checkIP())
             return flag;
         if (!checkstring('0123456789',port)) {
           alert('The port number of the proxy process can only contain digits');//代理进程端口号只能为数字!
           fm.agentport.focus();
           return flag;
         }
          if(port <= 0){
               alert('The port number should be greater than 0!');//代理进程端口号必须大于0!
               fm.agentport.focus();
               return flag;
          }
      }
      if (!checkstring('0123456789',trim(fm.ipphone.value))) {
         alert('IP phone number can only contain digits!');
         fm.ipphone.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.postoffice.value))) {
         //alert('IP对应局号只能为数字!');
         alert('IP postoffice number can only contain digits!');
         fm.postoffice.focus();
         return flag;
      }
      var optype  = fm.op.value;
      var value = fm.ipname.value;
      var flag = 0;
      if(optype == 'add'){ //添加
        for(var index=0; index<v_ipname.length;index++){
           if(v_ipname[index] == value){
              flag = 1;
              break;
          }
        }
     }
     else if(optype == 'edit'){ //修改
         var select  = document.forms[0].iplist.selectedIndex;
         for(var index=0; index<v_ipname.length;index++){
           if(v_ipname[index] == value && index!=select){
               flag = 1;
               break;
           }
         }
     }
     if(flag == 1){
        alert("IP name already exists. Please re-enter!");//IP名称已经存在,请重新输入!
        document.forms[0].ipname.focus();
        return false;
     }
      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      fm.op.value = 'add';
      if (! checkInfo())
         return;
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      fm.op.value = 'edit';
      if(fm.iplist.selectedIndex ==-1) {
         alert('Please select the IP to be modified!');//请先选择要修改的IP!
         return;
      }
     var temp=<%=ismultimedia%>;
     //if(temp=='1'){
       var oldvalue=v_iptype[fm.iplist.selectedIndex];
       if(oldvalue!=fm.iptype.value){
         alert('you can not modify the IP type!');
         fm.iptype.value=oldvalue;
         return;
       }
      if (! checkInfo())
         return;
      fm.submit();
  // }
   }

   function delInfo () {
      var fm = document.inputForm;
      fm.op.value = 'del';
      if(fm.iplist.selectedIndex ==-1) {
         alert('Please select the IP to be deleted!');//请先选择要删除的IP!
         return;
      }
      if(!confirm("Are you sure to delete this IP?"))//您确信要删除该IP吗？
         return ;
      fm.submit();
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="IpInfo.jsp">
<input type="hidden" name="op" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="middle">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">IP Management</td>
        </tr>
        <tr>
			<%--
			String strRowspan ="7";
			if("1".equals(ismultimedia)){
			 	strRowspan ="8";
			}
			<td rowspan="<%=strRowspan %>" align="center"> --%>
            <td rowspan="8" align="center">
            <select name="iplist" size="12" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Hashtable)vet.get(i);

%>
              <option value="<%= (String)hash.get("ipid")  %>"><%= (String)hash.get("ipname") %></option>
<%
            }
%>
            </select>
          </td>

		<td align="right">&nbsp;IP Type</td>
		<td>
			<select size="1" name="iptype" class="select-style1">
				<option value=0>IP</option>
				<%if("1".equals(ismultimedia)){ %>
				<option value=1>MS</option>
				<% }%>
			</select>
		</td>

        </tr>
		<tr>
          <td align="right">&nbsp;IP Name</td>
          <td><input type="text" name="ipname" value="" maxlength="30" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">&nbsp;Pilot line</td>
          <td><input type="text" name="ipaddr" maxlength="20" class="input-style1"  value="1234567" disabled ></td>
        </tr>
        <tr>
          <td align="right">&nbsp;GT Code</td>
          <td><input type="text" name="ipgt" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">IP address of<br>proxy process</td>
          <td><input type="text" name="agentipaddr" maxlength="20" class="input-style1" ></td>
        </tr>
        <tr>
          <td align="right">Port number of<br>proxy process</td>
          <td><input type="text" name="agentport" maxlength="8" class="input-style1" ></td>
        </tr>
        <tr>
          <td align="right">IP phone number</td>
          <td><input type="text" name="ipphone" maxlength="8" class="input-style1" ></td>
        </tr>
        <!--add by ge quanmin 2005-08-09 -->
         <tr>
          <td align="right">IP postoffice number</td>
          <td><input type="text" name="postoffice" maxlength="10" class="input-style1" ></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="25%" align="center"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                <td width="25%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                <td width="25%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
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
        sysInfo.add(sysTime + operName + " Exception occurred in managing IP!");//IP管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing IP!");//IP管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="IpInfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
