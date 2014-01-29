<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>HLR management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1"  onload="JavaScript:initform(document.forms[0])" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        ArrayList rList  = new ArrayList();
        manCRBT syscrbt = new manCRBT();
        String  optCRBT = "";
        sysTime = syscrbt.getSysTime() + "--";
        zxyw50.Purview purview = new zxyw50.Purview();
        if (operID != null && purviewList.get("15-2") != null) {
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            int    optype = -1;
            String crbt = request.getParameter("crbtlist") == null ? "" : ((String)request.getParameter("crbtlist")).trim();
            String hlr = request.getParameter("hlr") == null ? "0" : transferString((String)request.getParameter("hlr")).trim();
            String oldhlr = request.getParameter("infoList") ==null? "0" : transferString((String)request.getParameter("infoList")).trim();
            // 准备写操作员日志

            HashMap map1 = new HashMap();
            HashMap map = new HashMap();
            String  title = "";
            String desc = "";

            if (op.equals("add")){
                optype = 0;
                title = " Add HLR";//增加号段
            }
            else if (op.equals("edit")) {
                optype = 1;
                title = " Edit HLR";//Edit号段
            }
            else if (op.equals("del")) {
                optype = 2;
                title = " Delete HLR";//删除号段

            }
            desc  = operName+title;

            if(optype>=0){
               map1.put("optype",optype+"");
               map1.put("crbtid",crbt);
               map1.put("hlr",hlr);
               map1.put("oldhlr",oldhlr);
               rList=syscrbt.setCRBTHLR(map1);
	       sysInfo.add(sysTime + desc);

                if(getResultFlag(rList)){
                  // 准备写操作员日志
               map.put("OPERID",operID);
               map.put("OPERNAME",operName);
               map.put("OPERTYPE","702");
               map.put("RESULT","1");
               map.put("PARA1",crbt);
               map.put("PARA2",hlr);
               map.put("PARA3",oldhlr);
               map.put("PARA4","ip:"+request.getRemoteAddr());
               map.put("DESCRIPTION",title);
               purview.writeLog(map);
            }
                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="crbthlr.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }

            }

            ArrayList crbtlist = syscrbt.getCRBTList();
            for (int i = 0; i < crbtlist.size(); i++) {
              map = (HashMap)crbtlist.get(i);
              if(i==0 && crbt.equals(""))
                  crbt = (String)map.get("crbtid");
               optCRBT = optCRBT + "<option value=" + (String)map.get("crbtid") + " > " + (String)map.get("crbtname")+ " </option>";
            }
            ArrayList hlrcrbtList=null;

           ArrayList hlrList = new ArrayList();
           if(!crbt.equals(""))
                hlrcrbtList= syscrbt.gethlrs(crbt);

                hlrList = syscrbt.gethlrs();
%>
<script language="javascript">

   var v_hlr = new Array(<%= hlrList.size() + "" %>);

<%
   for (int i = 0; i < hlrList.size(); i++) {
         map = (HashMap)hlrList.get(i);
%>
   v_hlr[<%= i + "" %>] = '<%= (String)map.get("hlr") %>';

<% } %>
   function initform(pform){
     var temp = "<%= crbt %>";
      for(var i=0; i<pform.crbtlist.length; i++){
        if(pform.crbtlist.options[i].value == temp){
           pform.crbtlist.selectedIndex = i;
           break;
        }
     }

   }

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '')
         return;
      fm.hlr.value = index;

      fm.hlr.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.hlr.value);
      if (trim(value) == '') {
        // alert('请输入号段!');
         alert("Please input the HLR");
         fm.hlr.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         //alert('号段必须是数字!');
         alert("The HLR must be a digit!");
         fm.hlr.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function checkHlr () {
      var fm = document.inputForm;
      var code = trim(fm.hlr.value);
      var optype = fm.op.value;
      if(optype=='add'){
        for (i = 0; i < v_hlr.length; i++)
           if (code == v_hlr[i])
             return true;
      }

      return false;
   }


   function addInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'add';
      if (checkHlr()) {
         //alert('要增加的用户号段已经存在!');
          alert('The subscriber HLR you want to add  has already existed!');
         fm.hlr.focus();
         return;
      }
      fm.submit();
   }


   function delInfo () {
      var fm = document.inputForm;
      if(fm.infoList.length==0){
         // alert("没有任何用户号段可供删除!");
          alert("No subscriber HLR is for deleting!");
          return;
      }
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          //alert("请选择您删除的用户号段!");
          alert("Please select the HLR you want to delete!");
          return;
      }
     fm.op.value = 'del';
     fm.submit();
   }

    function onCRBTChange(){
       document.inputForm.op.value = "";
       document.inputForm.submit();
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="crbthlr.jsp">
<input type="hidden" name="op" value="">

<table width="500" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
        <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">CRBT center HLR management</td>
        </tr>
        <tr>
        <td width="45%" align="right">
           CRBT Select &nbsp; <select name="crbtlist" size="1" onchange="javascript:onCRBTChange()" class="input-style1">
              <% out.print(optCRBT); %>
             </select>

             <select name="infoList" size="7"  style="width:200px" onclick="javascript:selectInfo()">
             <%
                for (int i = 0; i < hlrcrbtList.size(); i++) {
                    map = (HashMap)hlrcrbtList.get(i);
                 out.println("<option value=" +(String)map.get("hlr") + ">" + (String)map.get("hlr") + "</option>");
               }
            %>
            </select>
        </td>
        <td width="55%">
            <table width="100%" border =0 class="table-style2" >
            <tr height="35">
            <td align="right" >The subscriber prefix</td>
            <td><input type="text" name="hlr" value="" maxlength="20" class="input-style1" ></td>
            </tr>
            <tr height="40">
             <td colspan="2">
               <table border="0" width="100%" class="table-style2">
                 <tr>
                   <td width="25%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
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
          <td colspan="2" style="color: #FF0000">&nbsp;&nbsp;&nbsp;Notes:
        if the max subscriber number is "0" it shows the service area don't restrict the subscriber number
      </td>
      </tr>
     </table>
 </td>
 </tr>
 </table>
</form>

<script language="JavaScript">

</script>
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
                   alert( "Sorry,you have no access to operate this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occourred in the management of CRBT center HLR!");//彩铃中心号段管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Exception occourred in the management of CRBT center HLR!");//彩铃中心号段管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="crbthlr.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>


</body>
</html>
