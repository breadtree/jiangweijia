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
<title>Photo http service Management</title>
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
        if (operID != null && purviewList.get("3-34") != null) {
            Vector vet = new Vector();
             String optIP = "";
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String hsindex = request.getParameter("hsindex") == null ? "" : transferString((String)request.getParameter("hsindex")).trim();
            String hsname = request.getParameter("hsname") == null ? "" : transferString((String)request.getParameter("hsname")).trim();
            String hsaddr = request.getParameter("hsaddr") == null ? "" : transferString((String)request.getParameter("hsaddr")).trim();
            String hsdir = request.getParameter("hsdir") == null ? "" : transferString((String)request.getParameter("hsdir")).trim();

            String hsuser = request.getParameter("hsuser") == null ? "" : transferString((String)request.getParameter("hsuser")).trim();
            String hspwd= request.getParameter("hspwd") == null ? "" : transferString((String)request.getParameter("hspwd")).trim();
            if(checkLen(hsname,30))
            	throw new Exception("The length of the http name you entered has exceeded the limit. Please re-enter!");
            int  optype =0;
            String title = "";
            String desc = "";
            if (op.equals("add")) {
                optype = 1;
                desc  = operName + "Add http service";
                title = "Add http service";
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + "Modify http service";
                title = "Modify http service";
            }
            else if (op.equals("del")) {
                optype = 2;
                desc  = operName + "Delete http service";
                title = "Delete http service";
             }
             if(optype>0){
                hash.put("optype",optype+"");
                hash.put("hsindex",hsindex);
                hash.put("hsname",hsname);
                hash.put("hsaddr",hsaddr);
                hash.put("hsdir",hsdir);
                hash.put("hsuser",hsuser);
                hash.put("hspwd",hspwd);
                rList = syspara.setHttpSvrInfo(hash);
                sysInfo.add(sysTime + desc);

                if(getResultFlag(rList)){
                  // 准备写操作员日志
                   zxyw50.Purview purview = new zxyw50.Purview();
                   HashMap map = new HashMap();
                   map.put("OPERID",operID);
                   map.put("OPERNAME",operName);
                   map.put("OPERTYPE","332");
                   map.put("RESULT","1");
                   map.put("PARA1",hsindex);
                   map.put("PARA2",hsname);
                   map.put("PARA3",hsaddr);
                   map.put("PARA4",hsdir);
                   map.put("PARA5",hsuser);
                   map.put("PARA6",hspwd);
                   map.put("DESCRIPTION",desc);
                   purview.writeLog(map);
                }
                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="httpsvrinfo.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }
           vet = syspara.getHttpSvrInfo(); //取得HttpSvrInfo 列表

%>
<script language="javascript">
   var v_hsindex =new Array(<%= vet.size() + "" %>);
   var v_hsname =new Array(<%= vet.size() + "" %>);
   var v_hsaddr = new Array(<%= vet.size() + "" %>);
   var v_hsdir = new Array(<%= vet.size() + "" %>);
   var v_hsuser = new Array(<%= vet.size() + "" %>);
   var v_hspwd=new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
  v_hsindex[<%= i + "" %>] = '<%= (String)hash.get("hsindex") %>';
  v_hsname[<%= i + "" %>] = '<%= (String)hash.get("hsname") %>';
   v_hsaddr[<%= i + "" %>] = '<%= (String)hash.get("hsaddr") %>';
   v_hsdir[<%= i + "" %>] = '<%= (String)hash.get("hsdir") %>';
   v_hsuser[<%= i + "" %>] = '<%= (String)hash.get("hsuser") %>';
   v_hspwd[<%= i + "" %>] = '<%= (String)hash.get("hspwd") %>';

<%
            }
%>



   // 检查输入的IP地址的准确性
   function checkIP () {
      var tmp = document.inputForm.hsaddr.value;
      var index = tmp.indexOf('.');
      var ip;
      // 检查IP地址第一段
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 1 || ip > 255) {
         alert('Error in inputting the IP address of http service!'); // HTTP服务器 IP地址输入错误！
         document.inputForm.hsaddr.focus();
         return false;
      }
      // 检查IP地址第二段
      tmp = tmp.substring(index + 1,tmp.length);
      index = tmp.indexOf('.');
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
         alert('Error in inputting the IP address of http service!'); // HTTP服务器 IP地址输入错误！
         document.inputForm.hsaddr.focus();
         return false;
      }
      // 检查IP地址第三段
      tmp = tmp.substring(index + 1,tmp.length);
      index = tmp.indexOf('.');
      ip = tmp.substring(0,index);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
        alert('Error in inputting the IP address of http service!'); // HTTP服务器 IP地址输入错误！
         document.inputForm.hsaddr.focus();
         return false;
      }
      // 检查IP地址第四段
      ip = tmp.substring(index + 1,tmp.length);
      if (ip.length == 0 || isNaN(ip) || ip < 0 || ip > 255) {
        alert('Error in inputting the IP address of http service!');  // HTTP服务器 IP地址输入错误！
         document.inputForm.hsaddr.focus();
         return false;
      }
      return true;
   }

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.iplist.selectedIndex;
      if (index <0 || index >=v_hsaddr.length)
         return;
      fm.hsindex.value = v_hsindex[index];
      fm.hsname.value = v_hsname[index];
      fm.hsaddr.value = v_hsaddr[index];
      fm.hsdir.value = v_hsdir[index];
      fm.hsuser.value = v_hsuser[index];
      fm.hspwd.value = v_hspwd[index];

      fm.hsaddr.focus();
   }


   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.hsname.value) == '') {
        alert('Please enter an http service!');  //请输入Http服务器名称！
         fm.hsname.focus();
         return flag;
      }
      if (!CheckInputStr(fm.hsname,'http service name')){
         fm.hsname.focus();
         return  flag;
      }
      if(trim(fm.hsindex.value)==''){
        alert('Please enter an http service number!');  //请输入HTTP服务器序号！
        fm.hsindex.focus();
        return flag;
      }
      if (!checkstring('0123456789',trim(fm.hsindex.value))) {
         alert('The http service number can only be a digital number!');  //Http服务器序号只能为数字！
         fm.hsindex.focus();
         return flag;
      }
      var value = trim(fm.hsaddr.value);
      if (trim(value) == '') {
         alert('Please enter an IP address of the http service!');  //请输入Http服务器 IP地址！
         fm.hsaddr.focus();
         return flag;
      }
       if (value != '') {
         if(!checkIP())
             return flag;
      }
      if(trim(fm.hsdir.value)==''){
        alert('Please enter the path of http service!');  //请输入HTTP服务器目录！
        fm.hsdir.focus();
        return flag;
      }
      if(trim(fm.hsuser.value)==''){
        alert('Please enter the FTP username of http service!');  //请输入HTTP服务器FTP用户名！
        fm.hsuser.focus();
        return flag;
      }
      if(trim(fm.hspwd.value)==''){
        alert('Please enter the FTP password of http service!');  //请输入HTTP服务器FTP密码！
        fm.hspwd.focus();
        return flag;
      }
      var optype  = fm.op.value;
      var value = fm.hsname.value;
      var flag = 0;
      if(optype == 'add'){ //添加
        if(fm.iplist.length>0){
          alert("you can add a photo http service at most");  //只能添加一个图像Http服务器！
          return false;
        }
        for(var index=0; index<v_hsaddr.length;index++){
           if(v_hsname[index] == value){
              flag = 1;
              break;
          }
        }
     }
     else if(optype == 'edit'){ //修改
         var select  = document.forms[0].iplist.selectedIndex;
         for(var index=0; index<v_hsaddr.length;index++){
           if(v_hsname[index] == value && index!=select){
               flag = 1;
               break;
           }
         }
     }
     if(flag == 1){
        alert("IP name already exists. Please re-enter!");  //IP名称已经存在，请重新输入！
        document.forms[0].hsname.focus();
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
         alert('Please select the http service name to be modified!');  //请先选择要修改的Http服务器！
         return;
      }
      var oldnfsvalue=v_hsindex[fm.iplist.selectedIndex];
      if(oldnfsvalue!=fm.hsindex.value){
       alert('The http service number can not be modified!');  //Http服务器序号不允许修改
       fm.hsindex.value=oldnfsvalue;
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
         alert('Please select the http service name to be deleted!');  //请先选择要删除的Http服务器！
         return;
      }
      if(!confirm("Are you sure to delete this http service?"))  //您确信要删除该Http服务器吗？
         return ;
      fm.submit();
   }

   function checkinput(src){
    var fm = document.inputForm;
    var re = /([^A-Za-z0-9 \/]+)/;
    var arr;
    if ((arr = re.exec(src)) == null)
      { re = /^[\/]/;
	  if ((arr = re.exec(src)) == null)
	  {   re = /[\/]$/;
	      if ((arr = re.exec(src)) == null)
		     return;
	  }
	}
     alert('you hava entered same not legal characters!');  //您输入了"%\&*$<>："等非法字符！
     fm.hsdir.value='';
     fm.hsdir.focus();
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="httpsvrinfo.jsp">
<input type="hidden" name="op" value="">
<table width="440" height="380" border="0" align="center" class="table-style2">
  <tr valign="middle">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Photo http service Management</td>
        </tr>
        <tr>
          <td rowspan="6" align="center">
            <select name="iplist" size="10" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Hashtable)vet.get(i);

%>
              <option value="<%= (String)hash.get("hsindex")  %>"><%= (String)hash.get("hsname") %></option>
<%
            }
%>
            </select>
          </td>
          <td align="right">&nbsp;Http service name</td>
          <td><input type="text" name="hsname" value="" maxlength="30" class="input-style1"></td>
        </tr>

        <tr>
          <td align="right">&nbsp;Http service number</td>
          <td><input type="text" name="hsindex" maxlength="20" class="input-style1"  value="" ></td>
        </tr>
        <tr>
          <td align="right">Http service address</td>
          <td><input type="text" name="hsaddr" maxlength="20" class="input-style1" ></td>
        </tr>
        <tr>
          <td align="right">Http service path</td>
          <td><input type="text" name="hsdir" maxlength="20" class="input-style1" onchange='checkinput(this.value)'></td>
        </tr>
        <tr>
          <td align="right">FTP username of<br>Http service</td>
          <td><input type="text" name="hsuser" maxlength="8" class="input-style1"></td>
        </tr>
         <tr>
          <td align="right">FTP password of<br>Http service</td>
          <td><input type="text" name="hspwd" maxlength="10" class="input-style1" ></td>
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
  <tr>
  <td colspan=2>notes：
    <br>1.if you modify the IP and dir of http photo service ,it will maybe affect server use normally,please operate carefully!
      <%-- 1、修改Http图片服务器的IP和dir可能影响图片服务器使用，请谨慎操作。--%>
    <br>2.Please split the many stages path of photo files with "/"!
      <%-- 2、图片目录为多级时请使用“/”分隔！ --%>
  </td>
  <tr>
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
        sysInfo.add(sysTime + operName + "MS管理过程出现异常！");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("MS管理过程出现错误！");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="httpsvrinfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
