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
<title>Manage <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>'s ID prefix</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body  class="body-style1" onload="JavaScript:initform(document.forms[0])" >
<%
    //法电彩像版本新增
    String ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia","0");
    String isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage","0");

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");

    //String RIDPREFIX_LEN = session.getAttribute("RIDPREFIXLEN")==null?"4":(String)session.getAttribute("RIDPREFIXLEN");

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
             //铃音前缀类型
            String sprefixtype=request.getParameter("prefixtype") == null ? "1" :(String)request.getParameter("prefixtype").trim();
            Manager manage = new Manager();
             String RIDPREFIX_LEN="";
            if(sprefixtype.equals("2")){
              RIDPREFIX_LEN=manage.getRidPrelen(8)+"";
            }
            else{
              RIDPREFIX_LEN=manage.getRidPrelen(Integer.parseInt(sprefixtype))+"";
            }
            String sRIDPrefix = request.getParameter("ridprefix") == null ? "" : (String)request.getParameter("ridprefix").trim();
            String sSeqno = request.getParameter("seqno") == null ? "" : (String)request.getParameter("seqno").trim();
            String sOldSeqno = request.getParameter("oldseqno") == null ? "" : (String)request.getParameter("oldseqno").trim();
            String sSpLabel = request.getParameter("splabel") == null ? " System provider " : transferString((String)request.getParameter("splabel")).trim();
            String sMediaType = request.getParameter("mediaType") == null ? "1" : (String)request.getParameter("mediaType").trim();
            int  optype =0;
            String title = "";
            String desc = "";
            HashMap map = null;
            if (op.equals("add")) {
                optype = 1;
                sOldSeqno = sSeqno;
                desc  = operName + "add "+sSpLabel + "'s ringtone ID prefix " + sRIDPrefix;
                title = "Add ringtong ID prefix";
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + " modify "+sSpLabel + "'s ringtone ID prefix " + sRIDPrefix;
                title = "Modify ringtone ID prefix";
            }
            else if (op.equals("del")) {
                optype = 2;
                sSeqno = sOldSeqno ;
                desc  = operName + " delete "+sSpLabel + "'s ringtone ID prefix " + sRIDPrefix;
                title = "Delete ringtone ID prefix";
             }
             if(optype>0){
                hash.put("optype",optype+"");
                hash.put("spindex",sSpIndex);
                hash.put("oldseqno",sOldSeqno);
                hash.put("seqno",sSeqno);
                hash.put("ridprefix",sRIDPrefix);
                hash.put("prefixtype",sprefixtype);
                hash.put("para1","2");
                hash.put("mediaType",sMediaType);
                rList = syspara.setSpRIDPrefix(hash);
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
                    map.put("DESCRIPTION",title+" ip:"+request.getRemoteAddr());
                    purview.writeLog(map);
                }

                sysInfo.add(sysTime + desc);

                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="ringIDPrefix.jsp?spindex=<%= sSpIndex %>&amp;prefixtype=<%=sprefixtype%>">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }

           ArrayList spInfo = syspara.getSPInfo();
           list = syspara.getSpRIDPrefix(sSpIndex,sprefixtype);
           // list = syspara.getSpRIDPrefix(sSpIndex,"1");
%>
<script language="javascript">
   var v_ridprefix = new Array(<%= list.size() + "" %>);
   var v_seqno = new Array(<%= list.size() + "" %>);
   var v_mediatype = new Array(<%= list.size() + "" %>);
<%
            for (int i = 0; i < list.size(); i++) {
                map = (HashMap)list.get(i);
%>
   v_ridprefix[<%= i + "" %>] = '<%= (String)map.get("ridprefix") %>';
   v_seqno[<%= i + "" %>] = '<%= (String)map.get("seqno") %>';
   v_mediatype[<%= i + "" %>] = '<%= (String)map.get("mediaType") %>';
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
     var temp2="<%= sprefixtype %>";
      for(var i=0; i<pform.prefixtype.length; i++){
        if(pform.prefixtype.options[i].value == temp2){
           pform.prefixtype.selectedIndex = i;
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
	  fm.mediaType.value = v_mediatype[index];
      fm.seqno.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.seqno.value);
      if (value == '') {
         alert('Sorry, please enter the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID prefix!');//对不起,请输入前缀序号!
         fm.seqno.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('Sorry, index of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID prefix can only be a digital number!');//对不起,前缀序号只能是数字类型,请重新输入!
         fm.seqno.focus();
         return flag;
      }
      value = trim(fm.ridprefix.value);
      if (value == '') {
         alert('Sorry, please enter the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID prefix!');//对不起,请输入铃音前缀!
         fm.ridprefix.focus();
         return flag;
      }
      if(!checkstring('0123456789',value)){
         alert('Sorry, the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID prefix can only be a digital number!');//对不起,铃音前缀只能是数字类型,请重新输入!
         fm.ridprefix.focus();
         return flag;
      }
      if(value.length != RIDPREFIX_LEN){
         alert('Sorry, the lenght of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID prefix can only be ' + RIDPREFIX_LEN + ' character!');//对不起,铃音前缀只能是'+ RIDPREFIX_LEN +'位数字类型,请重新输入!
         fm.ridprefix.focus();
         return flag;
      }
      if(value.substring(0,2)=='99'){
         alert("Sorry, <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID prefix can't begin with 99, please re-enter!");//对不起,铃音前缀前两位不能是99,请重新输入!
         fm.ridprefix.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      if(fm.spindex.selectedIndex==-1){
          alert('Please choose SP!');//请选择SP!
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
          alert('Please choose SP!');//请选择SP!
          return;
      }
      if(fm.prefixlist.length ==0){
          alert("Sorry, no ringtong ID prefix to edit!");//对不起,目前没有可供Edit的铃音前缀!
          return;
      }
      if(fm.prefixlist.selectedIndex ==-1){
          alert("Sorry, please choose the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID prefix which you want to edit!");//对不起,请选择您要Edit的铃音前缀!
          return;
      }
	  var oldmtvalue=v_mediatype[fm.prefixlist.selectedIndex];
      if(oldmtvalue != fm.mediaType.value){
       alert('Sorry, you cannot modify the mediaType!');  //mediaType不允许修改
       fm.mediaType.value=oldmtvalue;
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
          alert('Please choose SP!');//请选择SP!
          return;
      }
      if(fm.prefixlist.length ==0){
          alert("Sorry, no ringtong ID prefix to delete!");//对不起,目前没有可供删除的铃音前缀!
          return;
      }
      if(fm.prefixlist.selectedIndex ==-1){
          alert("Sorry, please choose the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID prefix you want to delete!");//对不起,请选择您要删除的铃音前缀!
          return;
      }
      if(!confirm("Are you sure to delete this IP?"))//您确信要删除该IP吗？
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

   function onprefixtypeChange(){
      var fm = document.inputForm;
      fm.submit();
   }

   function onmediaChange(){
      var fm = document.inputForm;
      fm.submit();
   }

</script>
<script language="JavaScript">
    if(parent.frames.length>0)
	parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="ringIDPrefix.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldseqno" value="">
<input type="hidden" name="splabel" value="<%= sSpLabel %>">

<table width="440" height="450" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Manage <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID prefix</td>
        </tr>
        <tr >
          <td height="10" colspan="3" align="center" class="text-title">&nbsp;</td>
        </tr>
        <tr>
          <td rowspan="4" align="center" width="style:200">
           <p>SP&nbsp;&nbsp;&nbsp;
                <select name="spindex" size="1" onChange="javascript:onSPChange()" style="width:180">
                  <%
               //if(bGroup) out.println("<option value=-2 >Group SP</option> ");
               if(bAllowUp) out.println("<option value=-3 >Person SP</option>");
               out.println("<option value=0 >System provider</option>");
               for (int i = 0; i < spInfo.size(); i++) {
                  HashMap map1 = (HashMap)spInfo.get(i);
                  out.println("<option value=" +  (String)map1.get("spindex") + " >" + (String)map1.get("spname") + "</option>");
               }
               %>
                </select>
              </p>
              <p>Prefix type
				  <select name="prefixtype" size="1" onChange="javascript:onprefixtypeChange()" style="width:150">
              <%if(sSpIndex.equals("-3")){
                if(sprefixtype.equals("3")){
                %>
                <option value=3 selected="selected">Personal <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
                <option value=4> PLUS <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
                <%}else{%>
                  <option value=3> personal ID</option>
                  <option value=4 selected="selected"> PLUS <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
              <%}}else{
                if(sprefixtype.equals("1")){
                %>
              <option value=1 selected="selected">System <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
              <option value=3>Personal <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
              <option value=4>PLUS <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
              <%}else if(sprefixtype.equals("3")){%>
               <option value=1>System <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
              <option value=3 selected="selected">Personal <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
              <option value=4> PLUS <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
              <%}else{%>
              <option value=1> System <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
              <option value=3> Person <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
              <option value=4 selected="selected"> PLUS <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</option>
              <%}%>
              <%}%>
              </select>
			  </p>

			  <select name="prefixlist" size="8" <%= list.size() == 0 ? "disabled " : "" %> class="input-style1" onclick="javascript:selectPrefix()" style="width:200" >
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
          <td align="right">index of prefix</td>
          <td><input type="text" name="seqno"  value="" maxlength="6" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix</td>
          <td><input type="text" name="ridprefix" maxlength="<%= RIDPREFIX_LEN %>" class="input-style1"  value=""  ></td>
        </tr>
		<%-- 法电增加判断 --%>
		<tr>
			<td align="right">mediatype</td>
			<td>
				<select name="mediaType" size="1" style="width:150" onchange="onmediaChange()">
					<%
					String str1="";
					String str2="";
					String str4="";
					if("1".endsWith(sMediaType))
					str1="selected=\"selected\"";
					else if("2".endsWith(sMediaType))
					str2="selected=\"selected\"";
					else if("4".endsWith(sMediaType))
					str4="selected=\"selected\"";
					%>
					<option value="1" <%=str1%>> <%=zte.zxyw50.util.CrbtUtil.getConfig("audioring","0")%>(.wav)</option>
					<% if("1".equals(ismultimedia)){%>
					<option value="2" <%=str2%>> <%=zte.zxyw50.util.CrbtUtil.getConfig("videoring","0")%>(.3gp)</option>
					<% }if("1".equals(isimage)){%>
					<option value="4" <%=str4%>><%=zte.zxyw50.util.CrbtUtil.getConfig("photoring","0")%>(.gif,.jpg,.bmp) </option>
					<%}%>
				</select>
			</td>
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
               <td >&nbsp;&nbsp;&nbsp;1.The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix is used by SP on uploading the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>;</td>
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;2.Do add,edit or delete the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix only after choose the SP;</td>
              </tr>
               <tr>
               <td >&nbsp;&nbsp;&nbsp;3.If the current SP has ringtongs, it can't be allowed to edit or delete;</td>
              </tr>
              <tr>
               <td >&nbsp;&nbsp;&nbsp;4.The index of prefix and the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix can only be the digital number,and the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> prefix's lengh must be <%= RIDPREFIX_LEN %>!</td>
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
                   alert( "Sorry, you have no right to access this function!");//Sorry,you have no access to this function!
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in manage ringtone prefix!");//铃音前缀管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error in manage this ringtone prefix!");//铃音前缀管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="ringIDPrefix.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
