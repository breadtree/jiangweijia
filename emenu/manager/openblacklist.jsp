<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Blacklist management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js" type=""></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    // add for starhub
	String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
	try {
        ArrayList rList  = new ArrayList();
        List blacklist = new ArrayList();
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        //配置权限？？？？？
        if (operID != null && purviewList.get("1-9") != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String blacknum = request.getParameter("tblacknum") == null ? "" : transferString((String)request.getParameter("tblacknum")).trim();
            String filename = request.getParameter("filename") == null ? "" :transferString((String)request.getParameter("filename")).trim();
            int  optype =0;
            String title = "";
            String desc = "";
            String blackfromdb = null;
            if (op.equals("add")) {

                optype = 1;
                desc  = operName + " Add blacklist ";
                title = "Add blacklist";//增加黑名单
            }
            else if (op.equals("del")) {
                optype = 2;
                desc  = operName + "Delete blacklist";//删除黑名单
                title = "Delete blacklist";//删除黑名单
             }
             else if(op.equals("batchadd")){
                 optype = 3;
                 desc = operName + " add blacklist in batch";//批量增加黑名单
                 title = "Add blacklist in batch";//批量增加黑名单
             }
             if(optype>0){
                 //单个操作
                 if(optype==1 || optype ==2){
                     hash.put("optype",optype+"");
                     hash.put("blacknum",blacknum);
                     blacklist.add(hash);
                 }else{//批量操作,读文件
                     blacklist = syspara.getBlackList(filename);
                 }

                rList = syspara.setblack(blacklist);
                sysInfo.add(sysTime + desc);
                Hashtable rHash = null;
                for(int i= 0;i<rList.size();i++){
                    rHash = (Hashtable)rList.get(i);
                    if(rHash !=null && (rHash.get("result")).toString().equals("0")){
                        zxyw50.Purview purview = new zxyw50.Purview();
                   HashMap map = new HashMap();
                   map.put("OPERID",operID);
                   map.put("OPERNAME",operName);
                   map.put("OPERTYPE","109");
                   map.put("RESULT","1");
                   map.put("PARA1",blacknum);
                   map.put("PARA2","ip:"+request.getRemoteAddr());
                   map.put("DESCRIPTION",title);
                   purview.writeLog(map);
                    }
                }

                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="openblacklist.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }
           vet = syspara.getBlackInfo();
%>
<script language="javascript">
   var v_blacknum = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                 blackfromdb= vet.get(i).toString();
%>
   v_blacknum[<%= i + "" %>] = '<%= blackfromdb %>';

<%
            }
%>

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.blacklist.selectedIndex;
      if (index <0 || index >=v_blacknum.length)
         return;
      fm.tblacknum.value = v_blacknum[index];
      fm.tblacknum.focus();
   }


   function checkInfo () {
      var fm = document.inputForm;
      var value = trim(fm.tblacknum.value);
      if(!isUserNumber(value,'<%=user_number%>')){
            fm.tblacknum.focus();
            return false;
      }
      return true;
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
         alert('Please select the blacklist to be modified first!');
         return;
      }
      if (! checkInfo())
         return;
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      fm.op.value = 'del';
      if(fm.blacklist.selectedIndex ==-1) {
         alert('Please select the blacklist to delete first!');//请先选择要删除的黑名单!
         return;
      }
      if(!confirm("Are you sure to delete it?"))//您确信要删除该黑名单吗？
         return ;
      fm.submit();
   }

   function selectFile() {
      var fm = document.inputForm;
      var uploadURL = 'blackupload.jsp';
      uploadRing = window.open(uploadURL,'blackbatchUpload','width=400, height=200');
   }

   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.filename.value = name;
      fm.tfile.value = label;
   }

   function batchadd() {
       var fm = document.inputForm;
       fm.op.value = 'batchadd';
       fm.submit();
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="openblacklist.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="filename" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Open Blacklist management</td>
        </tr>
        <tr>
          <td rowspan="6" align="center">
            <select name="blacklist" size="10" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                     blackfromdb= vet.get(i).toString();

%>
              <option value="<%= blackfromdb  %>"><%= blackfromdb %></option>
<%
            }
%>
            </select>
          </td>
          <td align="right">&nbsp;<%=user_number%></td>
          <td><input type="text" name="tblacknum" value="" maxlength="30" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="33%" align="center"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="33%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                <td width="33%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <br>
      <br>
      <br>
      <table align="center" class="table-style2" width="100%" border="0">
          <tr >
          <td height="26" colspan="4" align="center" class="text-title" background="image/n-9.gif">Add blacklist users in batch</td>
        </tr>
        <tr>
            <td align="right">&nbsp;File name</td>
                <td><input type="text" name="tfile" value="" maxlength="30" class="input-style1"> </td>
                <td ><img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"> &nbsp;&nbsp;</td>
                <td ><img src="button/upload.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:batchadd()"></td>
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
                    alert( "Please log in to the system first!");//Please log in to the system!
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no access to this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "It is abnormal during the blacklist management procedure!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the blacklist management procedure!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="openblacklist.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
