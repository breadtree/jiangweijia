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
<title>The gift package prefix management</title>
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
            String sSpLabel = request.getParameter("splabel") == null ? "System SP" : transferString((String)request.getParameter("splabel")).trim();
            int  optype =0;
            String title = "";
            String desc = "";
            HashMap map = null;
            if (op.equals("add")) {
                optype = 1;
                sOldSeqno = sSeqno;
                desc  = operName + " add "+sSpLabel + " gift package prefix " + sRIDPrefix;
                title = " add gift package prefix";
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + " modify "+sSpLabel + " gift package prefix " + sRIDPrefix;
                title = "modify gift package prefix ";
            }
            else if (op.equals("del")) {
                optype = 2;
                sSeqno = sOldSeqno ;
                desc  = operName + " delete "+sSpLabel + " gift package prefix " + sRIDPrefix;
                title = "delete  gift package prefix ";
             }
             if(optype>0){
                hash.put("optype",optype+"");
                hash.put("spindex",sSpIndex);
                hash.put("oldseqno",sOldSeqno);
                hash.put("seqno",sSeqno);
                hash.put("ridprefix",sRIDPrefix);
                hash.put("prefixtype","2");
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
<input type="hidden" name="historyURL" value="giftboxPrefix.jsp?spindex=<%= sSpIndex %>">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }

           ArrayList spInfo = syspara.getSPInfo();
           list = syspara.getSpRingGrpPrefix(sSpIndex,2);
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
         alert('Sorry,Please input the prefix!');
         fm.seqno.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('Sorry,the prefix can only contain digital!Please re-enter!');
         fm.seqno.focus();
         return flag;
      }
      value = trim(fm.ridprefix.value);
      if (value == '') {
         alert('Sorry,please enter the prefix of gift package!');
         fm.ridprefix.focus();
         return flag;
      }
      if(!checkstring('0123456789',value)){
         alert('Sorry,the prefix of gift package can only contain digital!Please re-enter!');
         fm.ridprefix.focus();
         return flag;
      }
      if(value.length != RIDPREFIX_LEN){
         alert('Sorry,the prefix of gift package can only be'+ RIDPREFIX_LEN +'-digit number,Please re-enter!');
         fm.ridprefix.focus();
         return flag;
      }
      if(value.substring(0,2)=='99'){
         alert('Sorry,the prefix of gift package can not be 99,Please re-enter!');
         fm.ridprefix.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      if(fm.spindex.selectedIndex==-1){
          alert("Please select SP");
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
          alert("Please select SP!");
          return;
      }
      if(fm.prefixlist.length ==0){
          alert("Sorry,there is no gift package prefix can be edited!");
          return;
      }
      if(fm.prefixlist.selectedIndex ==-1){
          alert("Sorry,Please select the gift package prefix to edit!");
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
          alert("Please select SP!");
          return;
      }
      if(fm.prefixlist.length ==0){
          alert("Sorry,there is no gift package prefix can be deleted!");
          return;
      }
      if(fm.prefixlist.selectedIndex ==-1){
          alert("Sorry,Please select the gift package prefix to delete!");
          return;
      }
      if(!confirm("Are you sure you want to delete the prefix?"))
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
<form name="inputForm" method="post" action="giftboxPrefix.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldseqno" value="">
<input type="hidden" name="splabel" value="<%= sSpLabel %>">
<table width="440" height="450" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">The gift package prefix management</td>
        </tr>
        <tr >
          <td height="10" colspan="3" align="center" class="text-title">&nbsp;</td>
        </tr>
        <tr>
          <td rowspan="4" align="center" width="style:200">
           Please select SP&nbsp; <select name="spindex" size="1" onChange="javascript:onSPChange()" style="width:140">
               <%
               if(bGroup) out.println("<option value=-2 >Group SP</option> ");
               if(bAllowUp) out.println("<option value=-3 >Individual SP</option>");
               out.println("<option value=0 >System SP</option>");
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
          <td align="right">SP Name</td>
          <td><input type="text" name="spname" value="<%= sSpLabel %>" maxlength="30" class="input-style1" disabled ></td>
        </tr>
         <tr>
          <td align="right">Prefix sequence</td>
          <td><input type="text" name="seqno"  value="" maxlength="6" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Gift package prefix</td>
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
               <td>Notes:</td>
              </tr>
               <tr>
               <td >&nbsp;&nbsp;&nbsp;1. The gift package prefix is used to distribute ringtone id for SP uploadding ringtone;</td>
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;2. After you select a SP,you can add,modify and delete;</td>
              </tr>
               <tr>
               <td >&nbsp;&nbsp;&nbsp;3. If the SP has ringtones,the prefix can not be modified and deleted!</td>
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;4. The prefix sequence and gift package prefix must be <%= RIDPREFIX_LEN %>-digit integer;</td>
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
        sysInfo.add(sysTime + operName + " Exception occurred in managing gift package!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing gift package!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="giftboxPrefix.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
