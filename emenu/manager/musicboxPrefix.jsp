<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
     public String display (String sSeqNo, String sRIDPrefix) throws Exception {
      if(sSeqNo==null) sSeqNo = "";
      for (; sSeqNo.length() < 8; )
           sSeqNo += "-";
       return sSeqNo + sRIDPrefix;
     }
%>

<html>
<head>
<title>Manage music box prefix</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body  class="body-style1" onload="JavaScript:initform(document.forms[0])" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String RIDPREFIX_LEN = session.getAttribute("RIDGRPPREFIXLEN")==null?"3":(String)session.getAttribute("RIDGRPPREFIXLEN");
    String allowUp = (String)application.getAttribute("ALLOWUP")==null?"0":(String)application.getAttribute("ALLOWUP");
    boolean bAllowUp = (Integer.parseInt(allowUp) == 1)?true:false;
    String isgroup = (String)application.getAttribute("ISGROUP")==null?"0":(String)application.getAttribute("ISGROUP");
    boolean bGroup = (Integer.parseInt(isgroup) == 1)?true:false;
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        ArrayList rList  = new ArrayList();
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-19") != null) {
            ArrayList list = new ArrayList();
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op").trim();
            String sSpIndex = request.getParameter("spindex") == null ? "0" :(String)request.getParameter("spindex").trim();
            String sRIDPrefix = request.getParameter("ridprefix") == null ? "" : (String)request.getParameter("ridprefix").trim();
            String sSeqno = request.getParameter("seqno") == null ? "" : (String)request.getParameter("seqno").trim();
            String sOldSeqno = request.getParameter("oldseqno") == null ? "" : (String)request.getParameter("oldseqno").trim();
            String sSpLabel = request.getParameter("splabel") == null ? "System provider" : transferString((String)request.getParameter("splabel")).trim();
            int  optype =0;
            String title = "";
            String desc = "";
            HashMap map = null;
            if (op.equals("add")) {
                optype = 1;
                sOldSeqno = sSeqno;
                desc  = operName + " add "+sSpLabel + " music box prefix " + sRIDPrefix;
                title = "Add music box prefix";
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + " edit "+sSpLabel + " music box prefix " + sRIDPrefix;
                title = "Edit music box prefix";
            }
            else if (op.equals("del")) {
                optype = 2;
                sSeqno = sOldSeqno ;
                desc  = operName + " delete "+sSpLabel + " music box prefix " + sRIDPrefix;
                title = "Delete music box prefix";
             }
             if(optype>0){
                hash.put("optype",optype+"");
                hash.put("spindex",sSpIndex);
                hash.put("oldseqno",sOldSeqno);
                hash.put("seqno",sSeqno);
                hash.put("ridprefix",sRIDPrefix);
                hash.put("prefixtype","1");
                rList = syspara.setSpRingGrpPrefix(hash);
                if(getResultFlag(rList)){
                    // 准备写操作员日志
                    zxyw50.Purview purview = new zxyw50.Purview();
                    map = new HashMap();
                    map.put("OPERID",operID);
                    map.put("OPERNAME",operName);
                    map.put("OPERTYPE","319");
                    map.put("RESULT","1");
                    map.put("PARA1",sSpIndex);
                    map.put("PARA2",sOldSeqno);
                    map.put("PARA3",sSeqno);
                    map.put("PARA4",sRIDPrefix);
                    map.put("PARA5","ip:"+request.getRemoteAddr());
                    map.put("DESCRIPTION",title);
                    purview.writeLog(map);
                }

                sysInfo.add(sysTime + desc);

                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="musicboxPrefix.jsp?spindex=<%= sSpIndex %>">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }

           ArrayList spInfo = syspara.getSPInfo();
           list = syspara.getSpRingGrpPrefix(sSpIndex,1);
%>
<script language="javascript">
   var v_ridprefix = new Array(<%= list.size() + "" %>);
   var v_seqno = new Array(<%= list.size() + "" %>);
<%
            for (int i = 0; i < list.size(); i++) {
                map = (HashMap)list.get(i);
%>
   v_ridprefix[<%= i + "" %>] = '<%= (String)map.get("ridprefix") %>';
   v_seqno[<%= i + "" %>] = '<%= (String)map.get("seqno") %>';
<%
             }
%>
   var RIDPREFIX_LEN = <%= RIDPREFIX_LEN %>;

  function initform(pform){
      var temp = "<%= sSpIndex %>";
      for(var i=0; i<pform.spindex.length; i++){
        if(pform.spindex.options[i].value == temp){
           pform.spindex.selectedIndex = i;
           break;
        }
     }
   }

   function selectPrefix () {
      var fm = document.inputForm;
      var index = fm.prefixlist.selectedIndex;
      if (index <0 || index >=v_ridprefix.length)
         return;
      fm.ridprefix.value = v_ridprefix[index];
      fm.seqno.value = v_seqno[index];
      fm.oldseqno.value = v_seqno[index];
      fm.seqno.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.seqno.value);
      if (value == '') {
         alert("Sorry,please enter the No. of prefix!");//对不起,请输入前缀序号!
         fm.seqno.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert("Sorry,the No. of prefix can only be a digital number!");//对不起,前缀序号只能是数字类型,请重新输入!
         fm.seqno.focus();
         return flag;
      }
      value = trim(fm.ridprefix.value);
      if (value == '') {
         alert("Sorry,please enter the music box prefix!");//对不起,请输入音乐盒前缀!
         fm.ridprefix.focus();
         return flag;
      }
      if(!checkstring('0123456789',value)){
         alert("Sorry,the music box prefix can only be a digital number,please re-enter!");//对不起,音乐盒前缀只能是数字类型,请重新输入!
         fm.ridprefix.focus();
         return flag;
      }
      if(value.length != RIDPREFIX_LEN){
         alert("Sorry,music box prefix can only be " + RIDPREFIX_LEN + " long.Please re-enter!");//对不起,音乐盒前缀只能是'+ RIDPREFIX_LEN +'位数字类型,请重新输入!
         fm.ridprefix.focus();
         return flag;
      }
      if(value.substring(0,2)=='99'){
         alert("Sorry,the music box prefix can't begin with 99,please re-enter!");//对不起,音乐盒前缀前两位不能是99,请重新输入!
         fm.ridprefix.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      if(fm.spindex.selectedIndex==-1){
          alert("Please choose the SP!");

          return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'add';
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      if(fm.spindex.selectedIndex==-1){
          alert("Please choose the SP!");//请选择SP!
          return;
      }
      if(fm.prefixlist.length ==0){
          alert("Sorry,there is no musix box prefix for editing!");//对不起,目前没有可供Edit的音乐盒前缀!
          return;
      }
      if(fm.prefixlist.selectedIndex ==-1){
          alert("Sorry,please select the music box prefix for editing!");//对不起,请选择您要Edit的音乐盒前缀!
          return;
      }
      fm.op.value = 'edit';
      if (! checkInfo())
         return;

      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      if(fm.spindex.selectedIndex==-1){
          alert("Please choose the SP!");//请选择SP!
          return;
      }
      if(fm.prefixlist.length ==0){
          alert("Sorry,there is no musicbox prefix to delete!");//对不起,目前没有可供删除的音乐盒前缀!
          return;
      }
      if(fm.prefixlist.selectedIndex ==-1){
          alert("Sorry,please select the musicbox prefix to delete!");//对不起,请选择您要删除的音乐盒前缀!
          return;
      }
      if(!confirm("Are you sure to delete this prefix?"))//您确信要删除该前缀吗？
         return ;
      fm.op.value = 'del';
      fm.submit();
   }

   function onSPChange(){
     var fm = document.inputForm;
      fm.splabel.value =fm.spindex.options[fm.spindex.selectedIndex].text;
      fm.op.value = '';
      fm.submit();
   }

</script>
<script language="JavaScript">
    if(parent.frames.length>0)
	parent.document.all.main.style.height="450";
</script>
<form name="inputForm" method="post" action="musicboxPrefix.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldseqno" value="">
<input type="hidden" name="splabel" value="<%= sSpLabel %>">
<table width="440" height="450" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Manage music box prefix</td>
        </tr>
        <tr >
          <td height="10" colspan="3" align="center" class="text-title">&nbsp;</td>
        </tr>
        <tr>
          <td rowspan="4" align="center" width="style:200">
            Please select SP&nbsp; <select name="spindex" size="1" onChange="javascript:onSPChange()" style="width:140">
               <%
               if(bGroup) out.println("<option value=-2 >Group SP</option> ");
               if(bAllowUp) out.println("<option value=-3 >Person SP</option>");
               out.println("<option value=0 >System provider</option>");
               for (int i = 0; i < spInfo.size(); i++) {
                  HashMap map1 = (HashMap)spInfo.get(i);
                  out.println("<option value=" +  (String)map1.get("spindex") + " >" + (String)map1.get("spname") + "</option>");
               }
               %>
              </select>
            <br>
            <select name="prefixlist" size="10" <%= list.size() == 0 ? "disabled " : "" %> class="input-style1" onclick="javascript:selectPrefix()" style="width:200" >
<%
            for (int i = 0; i < list.size(); i++) {
               map = (HashMap)list.get(i);
               out.println("<option value=" + String.valueOf(i) + " >" + display((String)map.get("seqno"),(String)map.get("ridprefix")) + "</option>");
            }
%>
            </select>
          </td>
          <td align="right">SP name</td>
          <td><input type="text" name="spname" value="<%= sSpLabel %>" maxlength="30" class="input-style1" disabled ></td>
        </tr>
         <tr>
          <td align="right">No. of prefix</td>
          <td><input type="text" name="seqno"  value="" maxlength="6" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Music box prefix</td>
          <td><input type="text" name="ridprefix" maxlength="<%= RIDPREFIX_LEN %>" class="input-style1"  value=""  ></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="34%" align="center"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="33%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                <td width="33%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr >
          <td height="26" colspan="3" >
           <table border="0" width="100%" class="table-style2">
              <tr>
               <td>Remark:</td>
              </tr>
               <tr>
               <td >&nbsp;&nbsp;&nbsp;1.Music box prefix is used by SP for assign the ringtone's code when the ringtone is be uploaded;</td>
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;2.Add,edit or delete the music box prefix must after the SP is be selected;</td>
              </tr>
               <tr>
               <td >&nbsp;&nbsp;&nbsp;3.If this SP has own the ringtone,it's No. of prefix and music box prefix can't be allowed to modify or delete;</td>
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;4.The No. of prefix and the music box prefix must be a digital number, the music box prefix's lenght must should be <%= RIDPREFIX_LEN %> long.</td>
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
                    alert( "Please log in first!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no right to access this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred to the music box prefix manage!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Errors occurred to the music box prefix manage!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="musicboxPrefix.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
