<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.*" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.group.util.*" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Prefix management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body  class="body-style1" onload="JavaScript:initform(document.forms[0])">
<%
    String sysTime = "";
    //ColorRing colorRing = (ColorRing)application.getAttribute("COLORRING");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String areacode = (String)application.getAttribute("AREACODE")==null?"1":(String)application.getAttribute("AREACODE");
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    //法电彩像版本新增
    String ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia","0");
	String prefixlength = zxyw50.CrbtUtil.getConfig("prefixlength","4");
	if(prefixlength.equals("0"))
	{
        prefixlength = "4";
	}

        Vector vResult = new Vector();
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-2") != null) {
          String optMRB = "";
          String optIP = "";
          String optSCP = "";
          Vector vet = new Vector();
          Vector mrb = new Vector();
          Vector ipinf = new Vector();
          int hlrNum = 0;
          int    optype = 0 ;
          String sOperation  ="";
          Hashtable hash = new Hashtable();

          String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
          String scp = request.getParameter("scplist") == null ? "" : transferString((String)request.getParameter("scplist")).trim();
          String hlr = request.getParameter("oldhlr") == null ? "" : transferString((String)request.getParameter("oldhlr")).trim();
          String newhlr = request.getParameter("hlr") == null ? "" : transferString((String)request.getParameter("hlr")).trim();
          String mrbmodel = request.getParameter("mrbmodel") == null ? "0" : transferString((String)request.getParameter("mrbmodel")).trim();
          String nettype = request.getParameter("nettype") == null ? "0" : transferString((String)request.getParameter("nettype")).trim();
          String ipid = request.getParameter("iplist") == null ? "0" : transferString((String)request.getParameter("iplist")).trim();
          String activeid = request.getParameter("activeid") == null ? "0" : transferString((String)request.getParameter("activeid")).trim();
          String opentype = request.getParameter("opentype") == null ? "7" : transferString((String)request.getParameter("opentype")).trim();
          HashMap map1 = new HashMap();
          String serareano = "-1";
          if (op.equals("add")) {
            optype = 1;
            hlr = newhlr;
            sOperation = "Add prefix" + hlr;
          }
          else if (op.equals("edit")) {
            optype = 3;
            sOperation = "Edit prefix" + hlr;
          }
          else if (op.equals("del")) {
            optype = 2;
            sOperation = "Delete prefix" + hlr;
          }
          String listfile = request.getParameter("listfile") == null ? "" : request.getParameter("listfile");
          String filename = request.getParameter("filename") == null ? "" : request.getParameter("filename");
          if(!StringUtil.isEmpty(listfile)&&!StringUtil.isEmpty(filename)&&optype==1){
            String[] hlrs = syspara.getHlrFromFile(listfile);
            if(hlrs==null||hlrs.length<=0)
            vResult.add("The file of batch join prefix is null!");
            StringBuffer sb = new StringBuffer();
            for(int i=0;i<hlrs.length;i++){
              sb.append(hlrs[i]);
              sb.append(":");
              try{
                map1.put("optype",Integer.toString(optype));
                map1.put("scp",scp);
                map1.put("hlr",hlrs[i]);
                map1.put("newhlr",hlrs[i]);
                map1.put("mrbmodel",mrbmodel);
                map1.put("nettype",nettype);
                map1.put("activeid",activeid);
                map1.put("opentype",opentype);
                map1.put("ipid",ipid);
                map1.put("serareano",serareano);
                syspara.addHlr(map1);
                vResult.add("Add prefix:"+hlrs[i] + "successful");
              }catch(Exception e2){
                vResult.add("Errors in add prefix:"+hlrs[i]+e2.toString());
              }
                // 准备写操作员日志
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map  = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("SERVICEKEY",syspara.getSerkey());
                map.put("OPERTYPE","303");
                map.put("RESULT","1");
                map.put("PARA1",hlrs[i]);
                map.put("PARA2",hlrs[i]);
                map.put("PARA3",scp);
                map.put("PARA4",ipid);
                map.put("PARA5",mrbmodel);
                map.put("PARA6",nettype);
                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
            }%>
            <script>
            function initform(pform){
            }
            </script>
            <form name="inputForm" method="post" action="hlr.jsp">
              <table border="0" height="100%" align="center" class="table-style2">
                <tr valign="center">
                  <td>
                    <table border="0" align="center" class="table-style2">
                      <%
                      for(int i=0;i<vResult.size();i++){
                        %>
                        <tr>
                          <td align="left" ><%=(String)vResult.elementAt(i)%> </td>
                        </tr>
                        <% } %>
                        <tr>
                          <td align="center"><br>
                            <a href="hlr.jsp">Back</a></td>
                        </tr>
                    </table>
                 </td>
                </tr>
              </table>
            </form>
            <%
            }else{
              if(optype>0){
                map1.put("optype",Integer.toString(optype));
                map1.put("scp",scp);
                map1.put("hlr",hlr);
                map1.put("newhlr",newhlr);
                map1.put("mrbmodel",mrbmodel);
                map1.put("nettype",nettype);
                map1.put("activeid",activeid);
                map1.put("opentype",opentype);
                map1.put("ipid",ipid);
                map1.put("serareano",serareano);
                if(optype==1)
                syspara.addHlr(map1);
                else if(optype==2)
                syspara.delHlr(map1);
                else if(optype==3)
                syspara.editHlr(map1);
                sysInfo.add(sysTime + operName + sOperation + " successfully!");
                // 准备写操作员日志
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map  = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("SERVICEKEY",syspara.getSerkey());
                map.put("OPERTYPE","303");
                map.put("RESULT","1");
                map.put("PARA1",hlr);
                map.put("PARA2",newhlr);
                map.put("PARA3",scp);
                map.put("PARA4",ipid);
                map.put("PARA5",mrbmodel);
                map.put("PARA6",nettype);
                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
              }
              ipinf = syspara.getIPGrp();
              for (int i = 0; i < ipinf.size(); i++) {
                hash = (Hashtable)ipinf.get(i);
                if(i==0 && (ipid.equals("0") ||ipid.equals("")))
                ipid = (String)hash.get("ipid");
                optIP = optIP + "<option value=" + (String)hash.get("ipid") + " > " + (String)hash.get("ipname")+ " </option>";
              }

              ArrayList scplist = syspara.getScpList();
              for (int i = 0; i < scplist.size(); i++) {
                if(i==0 && scp.equals(""))
                scp = (String)scplist.get(i);
                optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
              }
              if(!ipid.equals("")){
                mrb = syspara.getMrbByIP(ipid);
                for (int i = 0; i < mrb.size(); i++) {
                  String  strtemp = mrb.get(i).toString();
                  optMRB = optMRB + "<option value=" + strtemp + " > " + strtemp + " </option>";
                }
              }

              if(!ipid.equals("") && !scp.equals(""))
              vet = syspara.getHlrByScp(scp,ipid);
              %>
              <script language="javascript">
                var v_hlr = new Array(<%= vet.size() + "" %>);
                var v_nettype = new Array(<%= vet.size() + "" %>);
                var v_mrbmodel = new Array(<%= vet.size() + "" %>);
                var v_ipid = new Array(<%= vet.size() + "" %>);
                var v_activeid = new Array(<%= vet.size() + "" %>);
                var v_opentype = new Array(<%= vet.size() + "" %>);
                <%
                for (int i = 0; i < vet.size(); i++) {
                  hash = (Hashtable)vet.get(i);
                  %>
                  v_hlr[<%= i + "" %>] = '<%= (String)hash.get("hlr") %>';
                  v_nettype[<%= i + "" %>] = '<%= (String)hash.get("nettype") %>';
                  v_mrbmodel[<%= i + "" %>] = '<%= (String)hash.get("mrbmodel") %>';
                  v_ipid[<%= i + "" %>] = '<%= (String)hash.get("ipid") %>';
                  v_activeid[<%= i + "" %>] = '<%= (String)hash.get("activeid") %>';
                  v_opentype[<%= i + "" %>] = '<%= (String)hash.get("opentype") %>';
                  <%
                }
                %>
                function selectInfo () {
                  var fm = document.inputForm;
                  var index = fm.infoList.selectedIndex;
                  if (index <0 || index >=v_hlr.length)
                  return;
                  fm.hlr.value = v_hlr[index];
                  fm.oldhlr.value = v_hlr[index];
                  var value = parseInt(v_mrbmodel[index]);
                  for(var i=0; i<fm.mrbmodel.length; i++){
                    if(fm.mrbmodel.options[i].value == value){
                      fm.mrbmodel.selectedIndex = i;
                      break;
                    }
                  }
                  value = parseInt( v_nettype[index]);
                  for(var i=0; i<fm.nettype.length; i++){
                    if(fm.nettype.options[i].value == value){
                      fm.nettype.selectedIndex = i;
                      break;
                    }
                  }

                  value = parseInt( v_activeid[index]);
                  for(var i=0; i<fm.activeid.length; i++){
                    if(fm.activeid.options[i].value == value){
                      fm.activeid.selectedIndex = i;
                      break;
                    }
                  }
                  fm.opentype.value = v_opentype[index];
                  fm.hlr.focus();
                }

                function checkInfo () {
                  var fm = document.inputForm;
                  var flag = false;
				  var prefixlength = "<%=prefixlength%>";
				  if ((trim(fm.hlr.value)).length < prefixlength) {
                  alert('The number prefix should contain at least ' +prefixlength+ ' digits!');//号码前缀至少应有 4 位!
                    fm.hlr.focus();
                    return flag;
                  }
                  if(!checkstring('0123456789',trim(fm.hlr.value))){
         alert('The number prefix can only be a digital number!');//号码前缀只能是数字
                    fm.hlr.focus();
                    return flag;
                  }

                  if (trim(fm.nettype.value) == '') {
         alert('Please select a network type!');//请选择网络类型
                    fm.nettype.focus();
                    return flag;
                  }
                  if (trim(fm.mrbmodel.value) == '') {
         alert('Please select an MRB module number!');//请选择MRB模块号
                    fm.mrbmodel.focus();
                    return flag;
                  }
                  if (trim(fm.activeid.value) == '') {
                    alert('Please select a calling type!');
                    fm.activeid.focus();
                    return flag;
                  }
                  if (trim(fm.opentype.value) == '') {
                    alert('Please select a account-open type!');
                    fm.activeid.focus();
                    return flag;
                  }
                  flag = true;
                  return flag;
                }

                function checkHlr () {
                  var fm = document.inputForm;
                  var t_hlr = trim(fm.hlr.value);
                  var optype = fm.op.value;
                  if(optype =="add"){
                    for (i = 0; i < v_hlr.length; i++)
                    if (t_hlr == v_hlr[i])
                    return true;
                  }
                  else if(optype =="edit"){
                    var index = fm.infoList.selectedIndex;
                    for (i = 0; i < v_hlr.length; i++)
                    if (t_hlr == v_hlr[i] && i!=index)
                    return true;
                  }
                  return false;
                }

                function addInfo () {
                  var fm = document.inputForm;
                  if(document.inputForm.listfile.value!=''){
                    fm.op.value = 'add';
                    fm.submit();
                    return true;
                  }
                  if(fm.iplist.length ==0){
        alert("Sorry. You must enter the IP Management to configure IP. Otherwise no prefix configuration can be made!");//对不起,您必须现进入IP管理中配置IP,否则不能进行任何号段配置操作
                    return false;
                  }
                  if(fm.iplist.selectedIndex ==-1){
        alert("Please select IP Configuration!");//请选择IP配置
                    return false;
                  }
                  if (! checkInfo())
                  return;
                  fm.op.value = 'add';
                  if (checkHlr()) {
         alert('The subscriber number prefix to be added already exists!');//您要增加的用户号段已经存在
                    fm.hlr.focus();
                    return;
                  }
                  fm.submit();
                }

                function initform(pform){
                  var temp = "<%= ipid %>";
                  for(var i=0; i<pform.iplist.length; i++){
                    if(pform.iplist.options[i].value == temp){
                      pform.iplist.selectedIndex = i;
                      break;
                    }
                  }
                  temp = "<%= scp %>";
                  for(var i=0; i<pform.scplist.length; i++){
                    if(pform.scplist.options[i].value == temp){
                      pform.scplist.selectedIndex = i;
                      break;
                    }
                  }

                }
                function editInfo () {
                  var fm = document.inputForm;
                  if(fm.iplist.length ==0){
        alert("Sorry. You must enter the IP Management to configure IP. Otherwise no prefix configuration can be made!");//对不起,您必须现进入IP管理中配置IP,否则不能进行任何号段配置操作
                    return false;
                  }
                  if(fm.iplist.selectedIndex ==-1){
        alert("Please select IP Configuration!");//请选择IP配置
                    return false;
                  }
                  if(fm.infoList.length ==0){
        alert("No prefix configuration can be modified!");//没有号段配置可供修改
                    return false;
                  }
                  if(fm.infoList.selectedIndex ==-1){
        alert("Please select a number prefix!");//请选择号段
                    return false;
                  }

                  if (! checkInfo())
                  return;
                  fm.op.value = 'edit';
                  if (checkHlr()) {
         alert('The subscriber number prefix to be edited already exists!');//您要Edit的用户号段已经 存在!
                    fm.hlr.focus();
                    return;
                  }
                  fm.submit();
                }

                function delInfo () {
                  var fm = document.inputForm;
                  if(fm.scplist.length ==0){
        alert("Sorry. Please contact the system administrator to confirm if the SCP has been loaded!");//对不起,请与系统管理员联系,确认scp是否加载
                    return false;
                  }
                  if(fm.scplist.selectedIndex ==-1){
        alert("Please select an SCP!");//请选择SCP
                    return false;
                  }
                  if(fm.iplist.length ==0){
        alert("Sorry. You must enter the IP Management to configure IP. Otherwise no prefix configuration can be made!");//对不起,您必须现进入IP管理中配置IP,否则不能进行任何号段配置操作
                    return false;
                  }
                  if(fm.iplist.selectedIndex ==-1){
        alert("Please select IP Configuration!");//请选择IP配置
                    return false;
                  }
                  if(fm.infoList.length ==0){
        alert("No prefix configuration can be deleted!");//没有号段配置可供删除
                    return false;
                  }
                  if(fm.infoList.selectedIndex ==-1){
        alert("Please select a number prefix!");//请选择号段
                    return false;
                  }
      if(!confirm("Are you sure to delete this number prefix?"))//您确信要删除该号段吗
                  return ;
                  fm.op.value = 'del';
                  fm.submit();
                }
                function onIPChange(){
                  document.inputForm.submit();
                }

                function onSCPChange(){
                  document.inputForm.op.value = "";
                  document.inputForm.submit();
                }

                function selectFile () {
                  var fm = document.inputForm;
                  var uploadURL = 'hlrBatchUpload.jsp';
                  window.open(uploadURL,'upload','width=400, height=230,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
                }
                function getListName (name, label) {
                  var fm = document.inputForm;
                  fm.listfile.value = name;
                  fm.filename.value = label;
                  fm.hlr.value=label;
                }

                </script>
                <script language="JavaScript">
                  if(parent.frames.length>0)
                  parent.document.all.main.style.height="500";
                  </script>
                  <form name="inputForm" method="post" action="hlr.jsp">
                    <input type="hidden" name="op" value="">
                      <input type="hidden" name="oldhlr" value="">
                        <input type="hidden" name="InfoIndex" value="">
                          <input type="hidden" name="listfile" value="">
                            <input type="hidden" name="filename" value="">
                              <table width="100%" height="400" border="0" align="center" class="table-style2">
                                <tr valign="center">
                                  <td>
                                    <table width="100%" border="0" align="center" class="table-style2">
                                      <tr>
        <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif"><%= colorName %> Prefix management</td>
                                      </tr>
                                      <tr>
                                        <td width="50%">
                                          <table width="100%" border=0  class="table-style2">
                                            <tr>
             <td  width="65" align="right">SCP Select</td>
                                              <td width="175">
                                                <select name="scplist" size="1" onchange="javascript:onSCPChange()" style="width:150px">
                                                  <% out.print(optSCP); %>
                                                </select>
                                              </td>
                                            </tr>
                                            <tr>
             <td  width="65" align="right">I&nbsp;P Select</td>
                                              <td width="175">
                                                <select name="iplist" size="1" onchange="javascript:onIPChange()" style="width:150px">
                                                  <% out.print(optIP); %>
                                                </select>
                                              </td>
                                            </tr>
                                            <tr>
                                              <td colspan=2 align="center">
                                                <select name="infoList" size="9" <%= vet.size() == 0 ? "disabled " : "" %> style="width:200px" onclick="javascript:selectInfo()">
                                                  <%
                                                  for (int i = 0; i < vet.size(); i++) {
                                                    hash = (Hashtable)vet.get(i);
                                                    out.println("<option value="+(String)hash.get("hlr")+" >" +(String)hash.get("hlr")+" </option>");
                                                  }
                                                  %>
                                                  </select>
                                              </td>
                                            </tr>
                                          </table>
</td>
<td>
  <table width="100%" border =0 class="table-style2" >
    <tr>
            <td align="right" height=30><%= colorName %> number prefix</td>
      <td><input type="text" name="hlr" value="" maxlength="11" class="input-style1"></td>
    </tr>
    <tr>
            <td align="right"  height=30>MRB Module No.</td>
      <td>
        <select name="mrbmodel" class="input-style1">
          <% out.print(optMRB); %>
        </select>
      </td>
    </tr>
    <tr>
            <td align="right"  height=30>Network type</td>
      <td>
        <select name="nettype" class="input-style1">
          <% if(areacode.indexOf("1")>=0){%>
          <option value="0">GSM</option>
          <%}if(areacode.indexOf("2")>=0){%>
          <option value="1">CDMA</option>
          <%}if(areacode.indexOf("3")>=0){%>
          <option value="2">PSTN</option>
          <option value="3">PHS</option>
          <%}if("1".equals(ismultimedia)){%>
          <option value="10">IMS</option>
          <%}%>
        </select>
      </td>
    </tr>
    <tr>
            <td align="right"  height=30>Account opening mode</td>
      <td>
        <select name="activeid" class="input-style1">
              <option value="1">Subscription mode</option>
              <option value="2">Forwarding mode</option>
              <option value="3">Switch mode</option>
              <option value="4">Called switch mode</option>
        </select>
      </td>
    </tr>
    <tr>
      <td align="right"  height=30>Subscription mode</td>
      <td>
        <select name="opentype" class="input-style1">
          <option value="2">Real-time news</option>
          <option value="3">Real-time files</option>
          <option value="4">Pre-real time files</option>
          <option selected="selected" value="7">Pre-real time news</option>
        </select>
      </td>
    </tr>
    <tr>
      <td colspan="2"  height=50>
        <table border="0" width="100%" class="table-style2">
          <tr>
            <td width="50%" align="center"><img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"></td>
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
                                      <% if(areacode.equals("3")){  %>
                                      <tr height="20">
                                        <td colspan="2"></td>
                                      </tr>
                                      <tr>
          <td colspan="2" style="color: #FF0000">Notes:Prefix of a PHS subscriber number should be 0+area code+prefix</td>
                                      </tr>
                                      <% }  %>
         <tr height="20">
        <td colspan="2" style="color: #FF0000">Notes:If the type of IP which is selected is MS, MRB Module No. is useless.</td>
        </tr>

                                    </table>
            </td>
                                </tr>
                              </table>
                  </form>
                  <%
                  }
                }else {

                      if(operID == null){
                        %>
                        <script language="javascript">
                    alert( "Please log in first!");//Please log in to the system
                          document.URL = 'enter.jsp';
                          </script>
                          <%
                          }
                          else{
                            %>
                            <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
                              </script>
                              <%

                            }
                        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in managing prefixes!");//号段管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing prefixes!");//号段管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="hlr.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
