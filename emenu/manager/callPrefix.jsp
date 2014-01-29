<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Area code management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" onload="initform(document.forms[0])">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String areacode = (String)application.getAttribute("AREACODE")==null?"1":(String)application.getAttribute("AREACODE");
	String usecalling =zte.zxyw50.util.CrbtUtil.getConfig("usecalling","0");
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-10") != null) {
            Vector vet = new Vector();
            String optIpList = "";
            String optPrefixList = "";
			String  optSCP = "";
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
		    String ipid = request.getParameter("ipid") == null ? "0" : transferString((String)request.getParameter("ipid")).trim();
			String newipid = request.getParameter("iplist") == null ? "" : transferString((String)request.getParameter("iplist")).trim();
            String prefix = request.getParameter("prefix") == null ? "" : transferString((String)request.getParameter("prefix")).trim();
            String oldprefix = request.getParameter("oldprefix") == null ? "" : transferString((String)request.getParameter("oldprefix")).trim();
            String flag = request.getParameter("flag") == null ? "1" : transferString((String)request.getParameter("flag")).trim();

            int optype = 0;
            String  desc = "";
            if (op.equals("add")) {
                optype = 1;
                ipid = newipid;
                oldprefix = prefix;
                desc = "Add call prefix";//增加呼叫前缀
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc = "Edit call prefix";//Edit呼叫前缀
            }
            else if (op.equals("del")) {
                optype = 2;
                desc = "Delete call prefix";//删除呼叫前缀
            }
            if(optype > 0){
                hash.put("optype",optype +"");
                hash.put("scp",scp);
                hash.put("newprefix",prefix);
                hash.put("oldprefix",oldprefix);
                hash.put("flag",flag);
                hash.put("ipid",ipid);
                hash.put("newipid",newipid);
                syspara.setCallPrefix(hash);
                sysInfo.add(sysTime + operName + desc + " successfully!");

                // 准备写操作员日志
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","312");
                map.put("RESULT","1");
                map.put("PARA1",oldprefix);
                map.put("PARA2",prefix);
                map.put("PARA3",scp);
                map.put("PARA4",flag);
                map.put("PARA5",ipid);
                map.put("PARA6",newipid);
                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
            }
            vet = syspara.getIPInfo();
            for (int i = 0; i < vet.size(); i++) {
               hash = (Hashtable)vet.get(i);
               if(i==0 && ipid.equals(""))
                  ipid = (String)hash.get("ipid");
               optIpList = optIpList + "<option value=" + (String)hash.get("ipid") + " > " + (String)hash.get("ipname")+ " </option>";
            }
            if(vet.size()>0)
               vet.clear();
            ArrayList scplist = syspara.getScpList();
            for (int i = 0; i < scplist.size(); i++) {
               if(i==0 && scp.equals(""))
                  scp = (String)scplist.get(i);
               optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
            }

            if(!scp.equals("")){
              vet = syspara.getCallPrefixInfo(scp,flag);
              System.out.println(vet.toString());
              for (int i = 0; i < vet.size(); i++) {
                 hash = (Hashtable)vet.get(i);
                 int flag1 = Integer.parseInt((String)hash.get("flag"));
                 String strFlag = "";
                 switch (flag1) {
                    case 1:
			strFlag = "Called Number management";//管理号码
                         break;
                    case 2:
                         strFlag = "PHS call";//PHS呼叫
                         break;
                    case 3:
                         strFlag = "GSM subscription";//G网签约
                         break;
                    case 4:
                         strFlag = "CDMA subscription";//C网签约
                         break;
                    case 5:
                         strFlag = "GSM call forwarding";//G网前转
                         break;
                    case 6:
                         strFlag = "CDMA call forwarding";//C网前转
                         break;
                    case 7:
                         strFlag = "Fast order prefix";//快速定购前缀
                         break;
		    case 21:
			 strFlag = "Calling Number management"; //IVR主叫
			 break;
                    default:
                         strFlag = "Unknown type";//未知类型
                         break;
                }
                String strtemp = (String)hash.get("prefix");
                for (; strtemp.length() < 15; )
                    strtemp += "-";
                strtemp = strtemp + strFlag;
                optPrefixList = optPrefixList + "<option value='" + Integer.toString(i) + "' > " + strtemp + " </option>";
            }
         }


%>
<script language="javascript">
   var v_flag = new Array(<%= vet.size() + "" %>);
   var v_prefix = new Array(<%= vet.size() + "" %>);
   var v_ipid   = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_flag[<%= i + "" %>] = '<%= (String)hash.get("flag") %>';
   v_prefix[<%= i + "" %>] = '<%= (String)hash.get("prefix") %>';
   v_ipid[<%= i + "" %>] = '<%= (String)hash.get("ipid") %>';
<%
            }
%>

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.prefixlist.selectedIndex;
      if(index<0 || index>=v_prefix.length)
         return ;
      fm.prefix.value =v_prefix[index];
      var value = v_flag[index];
      fm.oldprefix.value = v_prefix[index];
      fm.ipid.value = v_ipid[index];
      fm.oldflag.value = parseInt(v_flag[index]);
      fm.iplist.value = v_ipid[index];
      var len  =  fm.flag.length;
      for (var i=0; i<len; i++){
        if(fm.flag.options[i].value ==  value){
           fm.flag.selectedIndex = i;
           break;
        }
      }
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.prefix.value) == '') {
         alert('Please enter a call prefix!');//请输入呼叫前缀!
         fm.prefix.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.prefix.value))) {
         alert('The call prefix must be a digital number!');//呼叫前缀必须是数字
         fm.prefix.focus();
         return flag;
      }
      if (fm.flag.selectedIndex == -1) {
         alert('Please select a prefix type!');//请选择前缀类型
         return flag;
      }
      flag = true;
      return flag;
   }

   function onScpChange(){
       document.inputForm.submit();
   }

   function onFlagChange(){
       document.inputForm.submit();
   }

   function initform(pform){
      var  temp = "<%= scp %>";
      for(var i=0; i<pform.scplist.length; i++){
        if(pform.scplist.options[i].value == temp){
           pform.scplist.selectedIndex = i;
           break;
        }
     }

      temp = "<%= flag %>";
      for(var i=0; i<pform.flag.length; i++){
        if(pform.flag.options[i].value == temp){
           pform.flag.selectedIndex = i;
           break;
        }
     }

   }

   function checkCode () {
      var fm = document.inputForm;
      var prefix = trim(fm.prefix.value);
      var flag = trim(fm.flag.value);
      var optype = fm.op.value;
      var  index = 0;
      index = fm.prefixlist.selectedIndex;
      if(optype == "add") {
        for (var i = 0; i < v_prefix.length; i++)
           if (prefix == v_prefix[i] && flag==v_flag[i])
              return true;
      }
      else if(optype == "edit"){
        for (var i = 0; i < v_prefix.length; i++)
           if (prefix == v_prefix[i] && i!=index && flag==v_flag[i])
              return true;
      }
      return false;
   }

  function checkPerm(){
     var fm = document.inputForm;
     if(fm.iplist.length ==0){
        alert("Sorry. You must enter the IP Management to configure IP. Otherwise no call prefix operation can be performed!");//对不起,您必须现进入IP管理中配置IP,否则不能进行任何呼叫前缀操作
        return false;
      }
      if(fm.iplist.selectedIndex ==-1){
        alert("Please select IP Configuration");//请选择IP配置!
        return false;
      }
      return true;
  }

   function addInfo () {
      var fm = document.inputForm;
      if(!checkPerm())
        return;
      if (! checkInfo())
         return;
      fm.op.value = 'add';
      if (checkCode()) {
         alert('The call prefix to be added already exists!');//您要增加的呼叫前缀已经存在
         fm.prefix.focus();
         return;
      }
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
       if(fm.prefixlist.selectedIndex ==-1){
        alert("Please select the call prefix you want to edit");//请选择您要删除的呼叫前缀
        return ;
      }
      if(!checkPerm())
        return;

      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      if (checkCode()) {
         alert('The call prefix to be edited already exists!');//要Edit的呼叫前缀已经存在
         fm.prefix.focus();
         return;
      }
      if(!confirm("In view of the significance of call prefix, please be cautious in the modification! \n Are you sure you want to modify this call prefix?"))//由于呼叫前缀的重要性,请您慎重进行修改操作!\n您确信要修改该呼叫前缀吗?
        return ;
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      if(!checkPerm())
        return;
      if(fm.prefixlist.selectedIndex ==-1){
        alert("Please select the call prefix you want to delete");//请选择您要删除的呼叫前缀
        return ;
      }
      if(!confirm("In view of the significance of call prefix, please be cautious in the deletion! \n Are you sure you want to delete this call prefix?"))//由于呼叫前缀的重要性,请您慎重进行删除操作!\n您确信要删除该呼叫前缀吗?
        return ;
      fm.op.value = 'del';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="callPrefix.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldprefix" value="">
<input type="hidden" name="ipid" value="">
<input type="hidden" name="oldflag" value="">
<table border="0" align="center" height="400" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr >
         <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Call prefix management</td>
        </tr>
        <tr>
        <td style="width:220px">
             <table border=0  class="table-style2">
             <tr>
             <td width="68" height="22">SCP</td>
             <td>
             <select name="scplist" size="1" onchange="javascript:onScpChange()" style="width:150px">
              <% out.print(optSCP); %>
             </select>
             </td>
             </tr>
             <tr>
                <td >Prefix type</td>
                <td>
                <select name="flag" size="1" style="width:220px" onchange="onFlagChange()">
		<option value=1>Called number prefix management</option>
		<% if(usecalling.equals("1")){ %>
		<option value="21">Calling number prefix management</option>
		<% } %>
                <% if(areacode.indexOf("3")>=0){%>
			    <option value=2>PHS call prefix</option>
			    <% }
			     if(areacode.indexOf("1")>=0){%>
			    <option value=3>GSM subscription prefix</option>
                <option value=5>GSM call forwarding prefix</option>
                <% }
                 if(areacode.indexOf("2")>=0){%>
                <option value=4>CDMA subscription prefix</option>
                <option value=6>CDMA call forwarding prefix</option>
                <%}%>
                <option value=7>Fast order prefix</option>

		</select>
                </td>
             </tr>
             <tr>
             <td colspan=2 >
             <select name="prefixlist" size="6" <%= vet.size() == 0 ? "disabled " : "" %> style="width:255px" onclick="javascript:selectInfo()">
              <% out.print(optPrefixList); %>
             </select>
             </td>
             </tr>
             </table>
        </td>

        <td>
            <table border =0 class="table-style2">
             <tr>
             <td align="right">Call prefix</td>
             <td><input type="text" name="prefix"  maxlength="30" class="input-style1"></td>
             </tr>
			 <tr>
             <td colspan="2">&nbsp;</td>
             </tr>
			 <tr>
             <td align="right">IP configuration</td>
             <td><select name="iplist" size="1"  class="input-style1">
              <% out.print(optIpList); %>
             </select></td>
             </tr>
             <tr>
             <td colspan="2">&nbsp;</td>
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
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//You have no access to this function!
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in managing call prefixes!");//呼叫前缀管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing call prefixes!");//呼叫前缀管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="callPrefix.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
