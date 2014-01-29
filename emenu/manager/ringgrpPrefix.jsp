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
<title>System ringtone group prefix management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body  class="body-style1" onload="JavaScript:initform(document.forms[0])" >
<%
    String sysTime = "";
    //add by gequanmin 2005-08-11 for version 3.19.01
    String usediscount = CrbtUtil.getConfig("usediscount","0");
    String sysringgrpenable= CrbtUtil.getConfig("sysringgrpenable","0");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String RIDPREFIX_LEN = session.getAttribute("RIDGRPPREFIXLEN")==null?"3":(String)session.getAttribute("RIDGRPPREFIXLEN");
    String allowUp = (String)application.getAttribute("ALLOWUP")==null?"0":(String)application.getAttribute("ALLOWUP");
    boolean bAllowUp = (Integer.parseInt(allowUp) == 1)?true:false;
    String isgroup = (String)application.getAttribute("ISGROUP")==null?"0":(String)application.getAttribute("ISGROUP");
    boolean bGroup = (Integer.parseInt(isgroup) == 1)?true:false;
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    Purview purview = new Purview();
    Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();

   	     //音乐盒与大礼包名字
    String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");
    String giftbag   = CrbtUtil.getConfig("giftname","giftbag");
    String ifShowGiftBag = CrbtUtil.getConfig("ifShowGiftBag","0");
    String DIYmscBoxDisp  = CrbtUtil.getConfig("DIYmscBoxDisp","DIY Music Box");


    try {
        ArrayList rList  = new ArrayList();
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-24") != null) {
            ArrayList list = new ArrayList();
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op").trim();
            String sSpIndex = request.getParameter("spindex") == null ? "0" :(String)request.getParameter("spindex").trim();
            String sRinggrpType = request.getParameter("ringgrptype") == null ? "1" :(String)request.getParameter("ringgrptype").trim();
            String sRIDPrefix = request.getParameter("ridprefix") == null ? "" : (String)request.getParameter("ridprefix").trim();
            String sSeqno = request.getParameter("seqno") == null ? "" : (String)request.getParameter("seqno").trim();
            String sOldSeqno = request.getParameter("oldseqno") == null ? "" : (String)request.getParameter("oldseqno").trim();
            String sSpLabel = request.getParameter("splabel") == null ? "System carrier" : transferString((String)request.getParameter("splabel")).trim();
            int  optype =0;
            String title = "";
            String desc = "";
            Manager manage = new Manager();
            String ringgrpDIYprefix = manage.getParameter(112)+"";
            HashMap map = null;
            if (op.equals("add")) {
                optype = 1;
                sOldSeqno = sSeqno;
                desc  = operName + " add"+sSpLabel + " system ringtone group prefix " + sRIDPrefix;
                title = "Add system ringtone group prefix";//增加系统铃音组前缀
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + " modify"+sSpLabel + " system ringtone group prefix " + sRIDPrefix;
                title = "Edit system ringtone group prefix"; //更改系统铃音组前缀
            }
            else if (op.equals("del")) {
                optype = 2;
                sSeqno = sOldSeqno ;
                desc  = operName + "delete"+sSpLabel + " system ringtone group prefix " + sRIDPrefix;
                title = "Delete system ringtone group prefix"; //删除系统铃音组前缀
             }
             if(optype>0){
                hash.put("optype",optype+"");
                hash.put("spindex",sSpIndex);
                hash.put("oldseqno",sOldSeqno);
                hash.put("seqno",sSeqno);
                hash.put("ridprefix",sRIDPrefix);
                hash.put("prefixtype",sRinggrpType);
                rList = syspara.setSpRingGrpPrefix(hash);
                if(getResultFlag(rList)){
                    // 准备写操作员日志
                   // zxyw50.Purview purview = new zxyw50.Purview();
                    map = new HashMap();
                    map.put("OPERID",operID);
                    map.put("OPERNAME",operName);
                    map.put("OPERTYPE","324");
                    map.put("RESULT","1");
                    map.put("PARA1",sSpIndex);
                    map.put("PARA2",sOldSeqno);
                    map.put("PARA3",sSeqno);
                    map.put("PARA4",sRIDPrefix);
                    map.put("DESCRIPTION",title+" ip:"+request.getRemoteAddr());
                    purview.writeLog(map);
                }

                sysInfo.add(sysTime + desc);

                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="ringgrpPrefix.jsp?spindex=<%= sSpIndex %>">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }

           ArrayList spInfo = syspara.getSPInfo();
           int grpringtype=Integer.parseInt(sRinggrpType);
           list = syspara.getSpRingGrpPrefix(sSpIndex,grpringtype);
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
   var sRinggrpDIYprefix= <%=ringgrpDIYprefix %>;
  function initform(pform){
      var temp = "<%= sSpIndex %>";
      for(var i=0; i<pform.spindex.length; i++){
        if(pform.spindex.options[i].value == temp){
           pform.spindex.selectedIndex = i;
           break;
        }
     }
      var temp2="<%=sRinggrpType%>";
       for(var j=0; j<pform.ringgrptype.length; j++){
        if(pform.ringgrptype.options[j].value == temp2){
           pform.ringgrptype.selectedIndex = j;
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
         //alert('对不起,请输入前缀序号!');
         alert("Sorry,please input the prefix number!");
         fm.seqno.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
        // alert('对不起,前缀序号只能是数字类型,请重新输入!');
         alert("Sorry,the prefix number can only be a digital number,please re-enter!");
         fm.seqno.focus();
         return flag;
      }
      value = trim(fm.ridprefix.value);
      if (value == '') {
         //alert('对不起,请输入系统铃音组前缀!');
         alert('sorry,please input the system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix!');
         fm.ridprefix.focus();
         return flag;
      }
      if(!checkstring('0123456789',value)){
         //alert('对不起,系统铃音组前缀只能是数字类型,请重新输入!');
         alert("Sorry,the system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix can only be a digital number,please re-enter!");
         fm.ridprefix.focus();
         return flag;
      }

     <% if(sysfunction.get("2-42-0")== null ){%>
    
     if(fm.ringgrptype.value == 3 && value.length != sRinggrpDIYprefix){
    	
         //alert('对不起,系统铃音组前缀只能是'+ RIDPREFIX_LEN +'位数字类型,请重新输入!');
         alert("Sorry,the system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix can only be digital number with the length of"+sRinggrpDIYprefix +",please re-enter!");
         fm.ridprefix.focus();
         return flag;
      }else if(fm.ringgrptype.value != 3 && value.length != RIDPREFIX_LEN){
          //alert('对不起,系统铃音组前缀只能是'+ RIDPREFIX_LEN +'位数字类型,请重新输入!');
          alert("Sorry,the system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix can only be digital number with the length of"+RIDPREFIX_LEN +",please re-enter!");
         fm.ridprefix.focus();
         return flag;
      }
    <%}else{%>
      if(value.length != RIDPREFIX_LEN){
         //alert('对不起,系统铃音组前缀只能是'+ RIDPREFIX_LEN +'位数字类型,请重新输入!');
         alert("Sorry,the system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix can only be digital number with the length of"+RIDPREFIX_LEN +",please re-enter!");
         fm.ridprefix.focus();
         return flag;
      }
      <%}%>
      if(value.substring(0,2)=='99'){
        // alert('对不起,系统铃音组前缀前两位不能是99,请重新输入!');
         alert("Sorry,the first two digits of system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix cannot be 99,please re-enter!");
         fm.ridprefix.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      if(fm.spindex.selectedIndex==-1){
         // alert("请选择SP!");
          alert("Please select SP!");
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
          //alert("请选择SP!");
          alert("Please select SP!");
          return;
      }
      if(fm.prefixlist.length ==0){
         // alert("对不起,目前没有可供Edit的系统铃音组前缀!");
          alert("Sorry,there is no any system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix to edit!");
          return;
      }
      if(fm.prefixlist.selectedIndex ==-1){
         // alert("对不起,请选择您要Edit的系统铃音组前缀!");
         alert("Sorry,please select the system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix to edit!");
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
          //alert("请选择SP!");
          alert("Please select SP!");
          return;
      }
      if(fm.prefixlist.length ==0){
         // alert("对不起,目前没有可供删除的系统铃音组前缀!");
          alert("Sorry,there is no any system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix to delete!");
          return;
      }
      if(fm.prefixlist.selectedIndex ==-1){
         // alert("对不起,请选择您要删除的系统铃音组前缀!");
          alert("Sorry,please select the system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix to delete!");
          return;
      }
     // if(!confirm("您确信要删除该前缀吗？"))
        if(!confirm("Are you sure to delete the prefix?"))
         return ;
      fm.op.value = 'del';
      fm.submit();
   }

    function onringgrptypeChange(){
      var fm = document.inputForm;
      fm.op.value = '';
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
	parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="ringgrpPrefix.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldseqno" value="">
<input type="hidden" name="splabel" value="<%= sSpLabel %>">

<table width="440" height="450" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">System <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix management</td>
        </tr>
        <tr >
          <td height="10" colspan="3" align="center" class="text-title">&nbsp;</td>
        </tr>
        <tr>
          <td rowspan="4" align="center" width="style:200">
           <p>Please select SP&nbsp; <select name="spindex" size="1" onChange="javascript:onSPChange()" style="width:140">
               <%
               if(bGroup) out.println("<option value=-2 >Group SP</option> ");
               if(bAllowUp) out.println("<option value=-3 >Personal SP</option>");
               out.println("<option value=0 >System carrier</option>");
               for (int i = 0; i < spInfo.size(); i++) {
                  HashMap map1 = (HashMap)spInfo.get(i);
                  out.println("<option value=" +  (String)map1.get("spindex") + " >" + (String)map1.get("spname") + "</option>");
               }
               %>
              </select>
           </p>
              <p align="center"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group type<select name="ringgrptype" size="1" onChange="javascript:onringgrptypeChange()" style="width:140">
               <%if("1".equals(sysringgrpenable)){%>
               <option value=1><%=musicbox%></option>
              <%}if("1".equals(ifShowGiftBag)){%>
               <option value=2><%=giftbag%></option>
             <%}if(sysfunction.get("2-42-0")== null){%>
              <option value=3><%=DIYmscBoxDisp%></option>
              <%}
              if("1".equals(usediscount)){
              %>
           <option value=3>Package</option>
              <% }%>
                </select>
                </p>
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
          <td align="right">Prefix number</td>
          <td><input type="text" name="seqno"  value="" maxlength="6" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix</td>
          <td><input type="text" name="ridprefix"  class="input-style1"  value=""  ></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                   <%
          String typeDisplay = "none";
          String typedisplay2="";
          System.out.println("***"+sRinggrpType);
         if(!"3".equals(sRinggrpType)){
           typeDisplay = "";
           typedisplay2="none";
           }
                %>
                <td width="34%" align="center" style="display:<%= typedisplay2 %>"></td>
                <td width="34%" align="center"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="33%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"  style="display:<%= typeDisplay %>"></td>
                <td width="33%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"  style="display:<%= typeDisplay %>"></td>
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
               <td >&nbsp;&nbsp;&nbsp;1. The system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix is used by SP to upload <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> and allocate the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code;</td><!-- 系统铃音组前缀是供SP上传铃音分配Ringtone code时使用； -->
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;2. You can add, modify, and delete the system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group prefix after select the SP;</td>
              </tr>
               <tr>
               <td >&nbsp;&nbsp;&nbsp;3. You are not allowed to modify or delete the prefix ID or system tone group prefix when the SP has the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s already;</td>
              </tr>
              <tr>
                  <td >&nbsp;&nbsp;&nbsp;4. The prefix ID and system tone group  prefix must be integers. The length of the system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix must be <%= RIDPREFIX_LEN %> for <%=musicbox %> and <%=giftbag %>. The length of the system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> 
                    prefix must be <%= ringgrpDIYprefix %> for <%=DIYmscBoxDisp %> .</td>
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
                   alert( "Sorry,you have no access to this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occourred in the  system ringtone prefix management!");//系统铃音组前缀管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occourred in the  system ringtone prefix management!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="ringgrpPrefix.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
