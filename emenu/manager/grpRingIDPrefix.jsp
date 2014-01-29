<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.Manager" %>
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
<title>Group ringtone prefix management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body  class="body-style1" onload="JavaScript:initform(document.forms[0])" >
<%
	 String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	 String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	 String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	 int ratio = Integer.parseInt(currencyratio);

    //String ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia","0");

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
   // String RIDPREFIX_LEN = session.getAttribute("RIDPREFIXLEN")==null?"5":(String)session.getAttribute("RIDPREFIXLEN");
   Manager manage = new Manager();
   String RIDPREFIX_LEN="";
   try{
     //获得集团铃音id的前缀长度限制
     RIDPREFIX_LEN=manage.getRidPrelen(8)+"";
   }catch(Exception e){
    e.printStackTrace();
   }
   String allowUp = (String)application.getAttribute("ALLOWUP")==null?"0":(String)application.getAttribute("ALLOWUP");
    String isgroup = (String)application.getAttribute("ISGROUP")==null?"0":(String)application.getAttribute("ISGROUP");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    //add by wxq 2005.05.31
    String grpRingFee = request.getParameter("grpRingFee") == null ? "0" : request.getParameter("grpRingFee");

    try {
        ArrayList rList  = new ArrayList();
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-22") != null) {
            ArrayList list = new ArrayList();
            Hashtable hash = new Hashtable();
            //SP信息
            ArrayList spInfo = syspara.getSPInfo();
            String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op").trim();
            //SP索引,如果为空,且spInfo不为空,则取spInfo中的第一条记录
            String sSpIndex = request.getParameter("spindex") == null ? "" :(String)request.getParameter("spindex").trim();
            //SP名称,如果为空,且spInfo不为空,则取spInfo中的第一条记录
            String sSpLabel = request.getParameter("splabel") == null ? "" : transferString((String)request.getParameter("splabel")).trim();
            HashMap mapTmp = new HashMap();
            if (sSpIndex.equals("") && spInfo.size() > 0){
                mapTmp = (HashMap)spInfo.get(0);
                sSpIndex = (String)mapTmp.get("spindex");
            }
            if (sSpIndex.equals("")){
                sSpIndex = "0";
            }
            if (sSpLabel.equals("") && spInfo.size() > 0){
                mapTmp = (HashMap)spInfo.get(0);
                sSpLabel = (String)mapTmp.get("spname");
            }
            String sRIDPrefix = request.getParameter("ridprefix") == null ? "" : (String)request.getParameter("ridprefix").trim();
            String sSeqno = request.getParameter("seqno") == null ? "" : (String)request.getParameter("seqno").trim();
            String sOldSeqno = request.getParameter("oldseqno") == null ? "" : (String)request.getParameter("oldseqno").trim();
            int  optype =0;
            String title = "";
            String desc = "";
            HashMap map = null;
            if (op.equals("add")) {
                optype = 1;
                sOldSeqno = sSeqno;
                desc  = operName + " add"+sSpLabel + " group ringtone prefix" + sRIDPrefix;
                title = "Add group ringtone prefix";//增加集团铃音前缀
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + " modify "+sSpLabel + " group ringtone prefix " + sRIDPrefix;//集团铃音前缀
                //title = "更改集团铃音前缀";
                title ="Modify group ringtone prefix";
            }
            else if (op.equals("del")) {
                optype = 2;
                sSeqno = sOldSeqno ;
                desc  = operName + " delete "+sSpLabel + " group ringtone prefix" + sRIDPrefix;
              //  title = "删除集团铃音前缀";
                 title ="Delete group ringtone prefix";
             }
             if(optype>0){
                hash.put("optype",optype+"");
                hash.put("spindex",sSpIndex);
                hash.put("oldseqno",sOldSeqno);
                hash.put("seqno",sSeqno);
                hash.put("ridprefix",sRIDPrefix);
                hash.put("prefixtype","2");
                hash.put("para1",grpRingFee);
				//法电版本先不做集团铃音，故现令mediaType=1
				hash.put("mediaType","1");
                rList = syspara.setSpRIDPrefix(hash);
                if(getResultFlag(rList)){
                    // 准备写操作员日志
                    zxyw50.Purview purview = new zxyw50.Purview();
                    map = new HashMap();
                    map.put("OPERID",operID);
                    map.put("OPERNAME",operName);
                    //需要修改
                    map.put("OPERTYPE","322");
                    map.put("RESULT","1");
                    map.put("PARA1",sSpIndex);
                    map.put("PARA2",sOldSeqno);
                    map.put("PARA3",sSeqno);
                    map.put("PARA4",sRIDPrefix);
                    map.put("PARA5",grpRingFee);
                    map.put("DESCRIPTION",title+" ip:"+request.getRemoteAddr());

                    //map.put("prefixtype","2");
                    //map.put("para1",grpRingFee);

                    purview.writeLog(map);
                }

                sysInfo.add(sysTime + desc);

                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="grpRingIDPrefix.jsp?spindex=<%= sSpIndex %>">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }

           list = syspara.getSpRIDPrefix(sSpIndex,"2");
%>
<script language="javascript">
   var v_ridprefix = new Array(<%= list.size() + "" %>);
   var v_seqno = new Array(<%= list.size() + "" %>);
   var v_para1 = new Array(<%= list.size() + "" %>);
<%
            for (int i = 0; i < list.size(); i++) {
                map = (HashMap)list.get(i);
%>
   v_ridprefix[<%= i + "" %>] = '<%= (String)map.get("ridprefix") %>';
   v_seqno[<%= i + "" %>] = '<%= (String)map.get("seqno") %>';
   v_para1[<%= i + "" %>] = '<%= (String)map.get("para1") %>';
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
      fm.grpRingFee.value = v_para1[index];
      fm.seqno.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.seqno.value);
      if (value == '') {
        // alert('对不起,请输入前缀序号!');
         alert("Sorry,please input the prefix serial number!");
         fm.seqno.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
        // alert('对不起,前缀序号只能是数字类型,请重新输入!');
          alert("Sorry,the prefix serial number can only be a digital number,please re-enter!");
         fm.seqno.focus();
         return flag;
      }
      value = trim(fm.grpRingFee.value);
      if (value == ''){
        //alert('对不起,请输入价格!');
        alert("Sorry,please input price!");
        fm.grpRingFee.focus();
        return flag;
      }
      if(!checkstring('0123456789',value)){
        //alert('对不起,价格只能是数字,请重新输入!');
         alert("Sorry,price can only be a digital number,please re-enter!");
        fm.grpRingFee.focus();
        return flag;
      }
      value = trim(fm.ridprefix.value);
      if (value == '') {
        // alert('对不起,请输入集团铃音前缀!');
         alert("Sorry,please input the group <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix!");
         fm.ridprefix.focus();
         return flag;
      }
      if(!checkstring('0123456789',value)){
         alert('Sorry, the group tone prefix is the digit type only, please input it again!');
         fm.ridprefix.focus();
         return flag;
      }
      if(value.length != RIDPREFIX_LEN){
         alert('Sorry, the group tone prefix is '+ RIDPREFIX_LEN +' digit type, please input it again!');
         fm.ridprefix.focus();
         return flag;
      }
      if(value.substring(0,2)=='99'){
         alert('Sorry, the first two digits of the group tone prefix should not be 99. Please input it again!');//对不起,集团铃音前缀前两位不能是99,请重新输入!
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
          //alert("对不起,目前没有可供Edit的集团铃音前缀!");
          alert("Sorry, no group tone prefix is available for editing!!");
          return;
      }
      if(fm.prefixlist.selectedIndex ==-1){
          alert("Sorry, please select the group tone prefix for editing!");//对不起,请选择您要Edit的集团铃音前缀!
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
          alert("Please select SP!");//请选择SP!
          return;
      }
      if(fm.prefixlist.length ==0){
          alert("Sorry, no group tone prefix is available for deletion!");//对不起,目前没有可供删除的集团铃音前缀!
          return;
      }
      if(fm.prefixlist.selectedIndex ==-1){
          alert("Sorry, please select the group tone prefix to be deleted!");//对不起,请选择您要删除的集团铃音前缀!
          return;
      }
      //if(!confirm("您确信要删除该IP吗？"))
        if(!confirm("Are you sure to delete the IP?"))
         return ;
      fm.op.value = 'del';
      fm.submit();
   }

   function onSPChange(){
     var fm = document.inputForm;
      fm.splabel.value = fm.spindex.options[fm.spindex.selectedIndex].text;
      fm.op.value = '';
      fm.submit();
   }
  //限定只能输入数字
  function numbersOnly(field,event){
    var key,keychar;
    if(window.event){
      key = window.event.keyCode;
    }
    else if (event){
      key = event.which;
    }
    else{
      return true
    }
    keychar = String.fromCharCode(key);
    if((key == null) || (key == 0) || (key == 8)|| (key == 9) || (key == 13) || (key == 27)){
      return true;
    }
    else if(('0123456789').indexOf(keychar) > -1){
      return true;
    }
    else {
      alert('Please input a digit!');//请输入数字
      return false;
    }
  }
</script>
<script language="JavaScript">
    if(parent.frames.length>0)
	parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="grpRingIDPrefix.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldseqno" value="">
<input type="hidden" name="splabel" value="<%= sSpLabel %>">
<table width="440" height="450" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Group <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix management</td>
        </tr>
        <tr >
          <td height="10" colspan="3" align="center" class="text-title">&nbsp;</td>
        </tr>
        <tr>
          <td rowspan="4" align="center" width="style:200">
           Please select SP&nbsp; <select name="spindex" size="1" onChange="javascript:onSPChange()" style="width:140">
             out.println("<option value=0 >System carrier</option>");
<%
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
          <td align="right">Prefix serial number</td>
          <td><input type="text" name="seqno"  value="" maxlength="6" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix</td>
          <td><input type="text" name="ridprefix" maxlength="<%= RIDPREFIX_LEN %>" class="input-style1"  value=""  ></td>
        </tr>
        <tr>
          <td align="right">Price</td>
          <td><input type="text" name="grpRingFee"  value="" maxlength="9" class="input-style1" onkeypress="return numbersOnly(this);"><%=minorcurrency%></td>
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
               <td >&nbsp;&nbsp;&nbsp;1. The group prefix is used by SP to upload <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s and assign <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> codes;</td>
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;2. You can add, modify, and delete the group prefix after select the SP is;</td>
              </tr>
               <tr>
               <td >&nbsp;&nbsp;&nbsp;3. You are not allowed to modify and delete the prefix serial number and <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix,when it exists in the SP;</td>
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;4. The prefix serial number and <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix must be integers, and the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix length must be <%= RIDPREFIX_LEN %>. </td>
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
        sysInfo.add(sysTime + operName + "It is abnormal during the group tone prefix management!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the group tone prefix management");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpRingIDPrefix.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
