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
<title>MRB Management</title>
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
    int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null &&  purviewList.get("3-1") != null) {
            Vector vet = new Vector();
            String optIP = "";
            ArrayList rList  = new ArrayList();
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String mrbmodel = request.getParameter("mrbmodel") == null ? "" : transferString((String)request.getParameter("mrbmodel")).trim();
            String ipid = request.getParameter("iplist") == null ? "" : transferString((String)request.getParameter("iplist")).trim();
            String oldmrbmodel = request.getParameter("newmrbmodel") == null ? "" : transferString((String)request.getParameter("newmrbmodel")).trim();
            String oldipid = request.getParameter("newipid") == null ? "" : transferString((String)request.getParameter("newipid")).trim();
            String ipaddr1 = request.getParameter("ipaddr1") == null ? "" : transferString((String)request.getParameter("ipaddr1")).trim();
            String mrbname = request.getParameter("mrbname") == null ? "" : transferString((String)request.getParameter("mrbname")).trim();
            if(checkLen(mrbname,40))
            	throw new Exception("The length of the MRB name you entered has exceeded the limit. Please re-enter!");//您输入的MRB名称长度超出限制,请重新输入!
            int  optype =0;
            String title = "";
            String desc = "";
            if (op.equals("add")) {
                optype = 1;
                oldmrbmodel = mrbmodel;
                oldipid = ipid;
                desc  = operName + "Add MRB";
                title = "Add MRB";
            }
            else if (op.equals("edit")) {
                optype = 2;
                desc  = operName + "Modify MRB";
                title = "Modify MRB";
            }
            else if (op.equals("del")){
                optype = 0;
                title = "Delete MRB";
                rList = syspara.delMRB(oldipid,oldmrbmodel);
                sysInfo.add(sysTime + operName + " Delete MRB");
             }
             if(optype==1 || optype==2){
                hash.put("optype",optype+"");
                hash.put("newmrbmodel",mrbmodel);
                hash.put("newipid",ipid);
                hash.put("mrbmodel",oldmrbmodel);
                hash.put("ipid",oldipid);
                hash.put("ipaddr1",ipaddr1);
                hash.put("mrbname",mrbname);
                rList = syspara.setMrb(hash);
                sysInfo.add(sysTime + desc);
            }
            if(!op.equals("")&& getResultFlag(rList)) {
                // 准备写操作员日志
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","302");
                map.put("RESULT","1");
                map.put("PARA1",oldmrbmodel);
                map.put("PARA2",mrbmodel);
                map.put("PARA3",ipid);
                map.put("PARA4",ipaddr1);
                map.put("PARA5",mrbname);
                map.put("DESCRIPTION",title+" ip:"+request.getRemoteAddr());
                purview.writeLog(map);
            }
            if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="mrb.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }

            vet = syspara.getIPInfo();
            for (int i = 0; i < vet.size(); i++) {
               hash = (Hashtable)vet.get(i);
               optIP =  optIP + "<option value=" + (String)hash.get("ipid") + " >" + (String)hash.get("ipname") + "</option>";
            }
            if(vet.size()>0)
               vet.clear();
            vet = syspara.getMRBInfo();

%>
<script language="javascript">
   var v_mrbmodel = new Array(<%= vet.size() + "" %>);
   var v_mrbname = new Array(<%= vet.size() + "" %>);
   var v_ipaddr1 = new Array(<%= vet.size() + "" %>);
   var v_ipid = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_mrbmodel[<%= i + "" %>] = '<%= (String)hash.get("mrbmodel") %>';
   v_mrbname[<%= i + "" %>] = '<%= (String)hash.get("mrbname") %>';
   v_ipaddr1[<%= i + "" %>] = '<%= (String)hash.get("ipaddr1") %>';
   v_ipid[<%= i + "" %>] = '<%= (String)hash.get("ipid") %>';
<%
            }
%>

   // 检查输入的IP地址的准确性
   function checkIP () {
      var tmp = document.inputForm.ipaddr1.value;
      var index = tmp.indexOf('.');
      var ip;
      // 检查IP地址第一段
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 1 || ip > 255) {
         alert('The IP address entered is incorrect!');//地址输入错误
         document.inputForm.ipaddr1.focus();
         return false;
      }
      // 检查IP地址第二段
      tmp = tmp.substring(index + 1,tmp.length);
      index = tmp.indexOf('.');
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
         alert('The IP address entered is incorrect!');//地址输入错误
         document.inputForm.ipaddr1.focus();
         return false;
      }
      // 检查IP地址第三段
      tmp = tmp.substring(index + 1,tmp.length);
      index = tmp.indexOf('.');
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
         alert('The IP address entered is incorrect!');//地址输入错误
         document.inputForm.ipaddr1.focus();
         return false;
      }
      // 检查IP地址第四段
      ip = tmp.substring(index + 1,tmp.length);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
         alert('The IP address entered is incorrect!');//地址输入错误
         document.inputForm.ipaddr1.focus();
         return false;
      }
      return true;
   }

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if (index ==-1)
         return;
      fm.mrbmodel.value = v_mrbmodel[index];
      fm.mrbname.value = v_mrbname[index];
      fm.ipaddr1.value = v_ipaddr1[index];
      var  selValue = parseInt(v_ipid[index]);
      fm.iplist.selectedIndex = 0;
      for(var i=0; i<fm.iplist.length; i++)
        if(fm.iplist.options[i].value == selValue){
            fm.iplist.selectedIndex = i;
            break;
        }
      fm.oldmrbname.value =  v_mrbname[index];
      fm.newmrbmodel.value = v_mrbmodel[index];
      fm.newipid.value = v_ipid[index];
      fm.mrbmodel.focus();
   }

   function checkModel () {
      var fm  = document.forms[0];
      var mrbname = fm.mrbname.value;
      var mrbmodel = fm.mrbmodel.value;
      var ipid = fm.iplist.value;
      var optype = fm.op.value;
      var flag = 0;
      if(optype == 'add') {
        for(var i =0;i<v_mrbname.length;i++){
          if(mrbname ==v_mrbname[i]){
            flag = 1;
            break;
          }
        }
        if(flag ==1){
            alert("MRB name already exists!");//MRB名称已经存在!
            return false;
        }
        flag =0;
        for(var i=0; i<v_ipid.length;i++){
           if(ipid==v_ipid[i] && mrbmodel== v_mrbmodel[i]){
             flag =1;
             break;
           }
        }
        if(flag == 1){
           alert("Sorry. The MRB number configured for the IP already exists!");//对不起,该IP配置的MRB号已经存在!
           return false;
        }
     }
     else if(optype == 'edit'){
        if(fm.oldmrbname.value !=mrbname ){
          for(var i =0;i<v_mrbname.length;i++){
            if(mrbname ==v_mrbname[i] ){
              flag = 1;
              break;
            }
          }
          if(flag ==1){
              alert("MRB name already exists!");//MRB名称已经存在!
              return false;
          }
          flag =0;
        }
        var newipid = fm.newipid.value;
        var newmrbmodel = fm.newmrbmodel.value;
        if(newipid != ipid || newmrbmodel!=mrbmodel){
          for(var i=0; i<v_ipid.length;i++){
             if(ipid==v_ipid[i] && mrbmodel== v_mrbmodel[i]){
               flag =1;
               break;
             }
          }
          if(flag == 1){
             alert("Sorry. The MRB number configured for the IP already exists!");//对不起,该IP配置的MRB号已经存在!
             return false;
          }
        }
     }
     return true;

   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.mrbmodel.value) == '') {
         alert('Please enter an MRB module number!');//请输入MRB模块号!
         fm.mrbmodel.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.mrbmodel.value))) {
         alert('MRB module number can only contain digits!');//MRB模块号只能为数字!
         fm.mrbmodel.focus();
         return flag;
      }
      if (trim(fm.mrbname.value) == '') {
         alert('Please enter an MRB name!');//请输入MRB名称!
         fm.mrbname.focus();
         return flag;
      }
      if (!CheckInputStr(fm.mrbname,'MRB name')){
         fm.mrbname.focus();
         return  flag;
      }
      <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.mrbname.value,40)){
            alert("The MRB name should not exceed 40 bytes!");
            fm.mrbname.focus();
            return;
          }
        <%
        }
        %>
      if (trim(fm.ipaddr1.value) == '') {
         alert('Please enter the IP address of the MRB!');//请输入MRB的ip地址!
         fm.ipaddr1.focus();
         return flag;
      }
      if (! checkIP())
         return;
      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      fm.op.value = 'add';
      if(fm.iplist.length==0){
         alert("Sorry. You cannot perform any MRB operations. Please configure IP info first!");//对不起,您不能对MRB进行任何操作,请现配置IP信息!
         return false;
      }
      if (! checkInfo())
          return;
      if(!checkModel())
        return;
      fm.submit();
   }

   function editInfo () {
     var fm = document.inputForm;
     fm.op.value = 'edit';
     if(fm.iplist.length==0){
         alert("Sorry. You cannot perform any MRB operations. Please configure IP info first!");//对不起,您不能对MRB进行任何操作,请现配置IP信息!
         return false;
      }
      if(fm.infoList.selectedIndex ==-1){
         alert("Please select an MRB first.");//请选择您要Edit的MRB!
         return false;
      }
      if (! checkInfo())
         return;
      if(!checkModel())
        return;

      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      if (trim(fm.mrbmodel.value) == '') {
         alert('Please select an MRB first.');//请先选择要删除的MRB!
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
<form name="inputForm" method="post" action="mrb.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="newipid" value="">
<input type="hidden" name="newmrbmodel" value="">
<input type="hidden" name="oldmrbname" value="">
<table width="80%" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">MRB management</td>
        </tr>
        <tr>
          <td rowspan="5">
            <select name="infoList" size="8" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Hashtable)vet.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)hash.get("mrbname") %></option>
<%
            }
%>
            </select>
          </td>
           <td align="right">MRB name</td>
           <td><input type="text" name="mrbname" value="" maxlength="40" class="input-style1"></td>
        </tr>
        <tr>
           <td align="right">IP configuration information</td>
          <td>
           <select name="iplist" size="1" style="width:150px">
            <% if(!optIP.equals("")) out.println(optIP); %>
           </select>
       </tr>
        <tr>
          <td align="right">MRB Module No.</td>
          <td><input type="text" name="mrbmodel" value="" maxlength="3" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">IP address</td>
          <td><input type="text" name="ipaddr1" value="" maxlength="20" class="input-style1"></td>
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
                    alert( "Please log in first!");//Please log in to the system
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
        sysInfo.add(sysTime + operName + "Exception occurred in managing MRB!");//MRB管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing MRB!");//MRB管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="mrb.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
