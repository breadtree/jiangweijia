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
<title>MS Management</title>
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
        ArrayList rList  = new ArrayList();
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-33") != null) {
            Vector vet = new Vector();
             String optIP = "";
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String nfsseq = request.getParameter("nfsseq") == null ? "" : transferString((String)request.getParameter("nfsseq")).trim();
            String ipid = request.getParameter("ipidlist") == null ? "" : transferString((String)request.getParameter("ipidlist")).trim();
            String nfsname = request.getParameter("nfsname") == null ? "" : transferString((String)request.getParameter("nfsname")).trim();
            String ipaddr = request.getParameter("ipaddr") == null ? "" : transferString((String)request.getParameter("ipaddr")).trim();

            String username = request.getParameter("username") == null ? "" : transferString((String)request.getParameter("username")).trim();
            String password= request.getParameter("password") == null ? "" : transferString((String)request.getParameter("password")).trim();
            if(checkLen(nfsname,30))
            	throw new Exception("The length of the NFS name you entered has exceeded the limit. Please re-enter!");
            int  optype =0;
            String title = "";
            String desc = "";
            if (op.equals("add")) {
                optype = 1;
                desc  = operName + "Add MS";
                title = "Add MS";
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + "Modify MS";
                title = "Modify MS";
            }
            else if (op.equals("del")) {
                optype = 2;
                desc  = operName + "Delete MS";
                title = "Delete MS";
             }
             if(optype>0){
                hash.put("optype",optype+"");
                hash.put("ipid",ipid);
                hash.put("nfsseq",nfsseq);
                hash.put("nfsname",nfsname);
                hash.put("ipaddr",ipaddr);
                hash.put("username",username);
                hash.put("password",password);
                rList = syspara.setMS(hash);
                sysInfo.add(sysTime + desc);

                if(getResultFlag(rList)){
                  // 准备写操作员日志
                   zxyw50.Purview purview = new zxyw50.Purview();
                   HashMap map = new HashMap();
                   map.put("OPERID",operID);
                   map.put("OPERNAME",operName);
                   map.put("OPERTYPE","329");
                   map.put("RESULT","1");
                   map.put("PARA1",ipid);
                   map.put("PARA2",nfsseq);
                   map.put("PARA3",nfsname);
                   map.put("PARA4",ipaddr);
                   map.put("PARA5",username);
                   map.put("PARA6",password);
                   map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                   purview.writeLog(map);
                }
                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="msinfo.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }
           vet = syspara.getIPInfoMrb(1);
            for (int i = 0; i < vet.size(); i++) {
               hash = (Hashtable)vet.get(i);
               optIP =  optIP + "<option value=" + (String)hash.get("ipid") + " >" + (String)hash.get("ipname") + "</option>";
            }
            if(vet.size()>0)
               vet.clear();
           vet = syspara.getMSInfo();
%>
<script language="javascript">
   var v_ipid =new Array(<%= vet.size() + "" %>);
   var v_nfsseq =new Array(<%= vet.size() + "" %>);
   var v_nfsname = new Array(<%= vet.size() + "" %>);
   var v_ipaddr = new Array(<%= vet.size() + "" %>);
   var v_username = new Array(<%= vet.size() + "" %>);
   var v_password=new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
  v_ipid[<%= i + "" %>] = '<%= (String)hash.get("ipid") %>';
  v_nfsseq[<%= i + "" %>] = '<%= (String)hash.get("nfsseq") %>';
   v_nfsname[<%= i + "" %>] = '<%= (String)hash.get("nfsname") %>';
   v_ipaddr[<%= i + "" %>] = '<%= (String)hash.get("ipaddr") %>';
   v_username[<%= i + "" %>] = '<%= (String)hash.get("username") %>';
   v_password[<%= i + "" %>] = '<%= (String)hash.get("password") %>';

<%
            }
%>



   // 检查输入的IP地址的准确性
   function checkIP () {
      var tmp = document.inputForm.ipaddr.value;
      var index = tmp.indexOf('.');
      var ip;
      // 检查IP地址第一段
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 1 || ip > 255) {
         alert('Error in inputting NFS IP address!');
         document.inputForm.ipaddr.focus();
         return false;
      }
      // 检查IP地址第二段
      tmp = tmp.substring(index + 1,tmp.length);
      index = tmp.indexOf('.');
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
         alert('Error in inputting NFS IP address!');
         document.inputForm.ipaddr.focus();
         return false;
      }
      // 检查IP地址第三段
      tmp = tmp.substring(index + 1,tmp.length);
      index = tmp.indexOf('.');
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
        alert('Error in inputting NFS IP address!');
         document.inputForm.ipaddr.focus();
         return false;
      }
      // 检查IP地址第四段
      ip = tmp.substring(index + 1,tmp.length);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
        alert('Error in inputting NFS IP address!');
         document.inputForm.ipaddr.focus();
         return false;
      }
      return true;
   }

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.iplist.selectedIndex;
      if (index <0 || index >=v_nfsname.length)
         return;
      fm.nfsseq.value = v_nfsseq[index];
      fm.nfsname.value = v_nfsname[index];
      fm.ipaddr.value = v_ipaddr[index];
      fm.username.value = v_username[index];
      fm.password.value = v_password[index];
      var  selValue = parseInt(v_ipid[index]);
      fm.ipidlist.selectedIndex = 0;
      for(var i=0; i<fm.ipidlist.length; i++)
        if(fm.ipidlist.options[i].value == selValue){
            fm.ipidlist.selectedIndex = i;
            break;
        }
     // fm.nfsseq.readOnly=true;
      fm.nfsname.focus();
   }


   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.nfsname.value) == '') {
        alert('Please enter an NFS name discription');
         fm.nfsname.focus();
         return flag;
      }
      if (!CheckInputStr(fm.nfsname,'NFS name discription')){
         fm.nfsname.focus();
         return  flag;
      }
      if(trim(fm.nfsseq.value)==''){
        alert('Please enter an NFS number!');
        fm.nfsseq.focus();
        return flag;
      }
      if (!checkstring('0123456789',trim(fm.nfsseq.value))) {
         alert('NFS number can only be a digital number!');
         fm.nfsseq.focus();
         return flag;
      }
      var value = trim(fm.ipaddr.value);
      if (trim(value) == '') {
         alert('Please enter an NFS address');
         fm.ipaddr.focus();
         return flag;
      }
       if (value != '') {
         if(!checkIP())
             return flag;
      }
      var optype  = fm.op.value;
      var value = fm.nfsname.value;
      var flag = 0;
      if(optype == 'add'){ //添加
        for(var index=0; index<v_nfsname.length;index++){
           if(v_nfsname[index] == value){
              flag = 1;
              break;
          }
        }

        for(var index=0; index<v_ipid.length;index++){
          if(v_ipid[index] == fm.ipidlist.value){
             alert("NFS already exists. Can not add more!");
             document.forms[0].nfsname.focus();
             return false;
          }
        }
     }
     else if(optype == 'edit'){ //修改
         var select  = document.forms[0].iplist.selectedIndex;
         for(var index=0; index<v_nfsname.length;index++){
           if(v_nfsname[index] == value && index!=select){
               flag = 1;
               break;
           }
         }
     }
     if(flag == 1){
        alert("NFS name already exists. Please re-enter!");
        document.forms[0].nfsname.focus();
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
         alert('Please select the MS to be modified!');
         return;
      }
      var oldnfsvalue=v_nfsseq[fm.iplist.selectedIndex];
      if(oldnfsvalue!=fm.nfsseq.value){
       alert('you can not modify the NFS number!');
       fm.nfsseq.value=oldnfsvalue;
       return;
      }
       var oldvalue=v_ipid[fm.iplist.selectedIndex];
      if(oldvalue!=fm.ipidlist.value){
       alert('you can not modify the MS number!');
       fm.ipidlist.value=oldvalue;
       return;
      }
      if (! checkInfo())
         return;
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      fm.op.value = 'del';
      if(fm.iplist.selectedIndex ==-1) {
         alert('Please select the MS to be deleted!');
         return;
      }
      if(!confirm("Are you sure to delete this MS?"))
         return ;
      fm.submit();
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="msinfo.jsp">
<input type="hidden" name="op" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="middle">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">MS Management</td>
        </tr>
        <tr>
          <td rowspan="6" align="center">
            <select name="iplist" size="10" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Hashtable)vet.get(i);

%>
              <option value="<%= (String)hash.get("nfsseq")  %>"><%= (String)hash.get("nfsname") %></option>
<%
            }
%>
            </select>
          </td>
          <td align="right">&nbsp;NFS Name Discription</td>
          <td><input type="text" name="nfsname" value="" maxlength="30" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">&nbsp;MS Number</td>
           <td>
           <select name="ipidlist" size="1" style="width:150px">
            <% if(!optIP.equals("")) out.println(optIP); %>
           </select>
        </tr>
        <tr>
          <td align="right">&nbsp;NFS Number</td>
          <td><input type="text" name="nfsseq" maxlength="20" class="input-style1"  value="" ></td>
        </tr>
        <tr>
          <td align="right">NFS Address</td>
          <td><input type="text" name="ipaddr" maxlength="20" class="input-style1" ></td>
        </tr>
        <tr>
          <td align="right">the FTP username<br>of NFS service</td>
          <td><input type="text" name="username" maxlength="8" class="input-style1"></td>
        </tr>
         <tr>
          <td align="right">the FTP password<br>of NFS service</td>
          <td><input type="text" name="password" maxlength="10" class="input-style1" ></td>
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
        e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "An exception occurred in MS management! "); // MS管理过程出现异常！
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("An error occurred in MS management!"); // MS管理过程出现错误！
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="msinfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
