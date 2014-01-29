<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page"/>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Group info management</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="init()">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String grouplen = (String)session.getAttribute("GROUPIDLEN")==null?"10":(String)session.getAttribute("GROUPIDLEN");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String enablegrpaccount =  CrbtUtil.getConfig("enablegrpaccount","1");
    HashMap map = new HashMap();
    //add by wxq 2005.06.07 for version 3.16.01
    String enablegrphallno = CrbtUtil.getConfig("enablegrphallno","1");
    //查询参数
    String groupCode = request.getParameter("groupCode") == null ? "" : request.getParameter("groupCode");
    String groupName = request.getParameter("groupName") == null ? "" : transferString(request.getParameter("groupName"));
    String serareano = request.getParameter("serareano") == null ? "0" : request.getParameter("serareano");
    String hallno = request.getParameter("hallno") == null ? "0" : request.getParameter("hallno");
    String mode = request.getParameter("mode") == null ? "query" : request.getParameter("mode");
    HashMap hash = new HashMap();
    int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
    String groupindex = request.getParameter("groupIndex") == null ? "" : request.getParameter("groupIndex");
    String groupid = request.getParameter("groupId") == null ? "" : request.getParameter("groupId");
    try {
        manSysPara syspara = new manSysPara();
        ManGroup mangroup = new ManGroup();
        Hashtable hashInfo = new Hashtable();
        ArrayList resultList = new ArrayList();
        ArrayList rList  = new ArrayList();
        if (mode.equals("query")){
            hashInfo.put("groupCode",groupCode);
            hashInfo.put("groupName",groupName);
            hashInfo.put("serareano",serareano);
            hashInfo.put("hallno",hallno);
            resultList = (ArrayList)mangroup.queryGrpInfo(hashInfo);
        }
        if (mode.equals("del")){
            boolean bl_result = purview.checkGroupOperateRight(session,"11-1",groupid);
            if (bl_result){
              rList = mangroup.delGroup(groupid,groupindex);

              String outresult="1";
              if(rList.size()>0 ){
              	//只看主SCP执行结果
               	Hashtable  hashout = (Hashtable)rList.get(0);
                if(!((String)hashout.get("result")).equals("0")){
                outresult="0";
                }
              }
              // 准备写操作员日志
              map.put("OPERID",operID);
              map.put("OPERNAME",operName);
              map.put("OPERTYPE","601");
              map.put("RESULT",outresult);
              map.put("PARA1",groupindex);
              map.put("PARA2",groupid);
              map.put("PARA3","ip:"+request.getRemoteAddr());
              map.put("PARA4","main SCP");
              map.put("DESCRIPTION","Delete Group");

              if(rList.size()>0){
                session.setAttribute("rList",rList);
%>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="grpInfo.jsp">
<input type="hidden" name="title" value="Delete group">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
<%
                }
            purview = new zxyw50.Purview();
            purview.writeLog(map);
            sysInfo.add(sysTime + operName +" delete group");


            }else{
%>
<script language="javascript">
 // alert('抱歉,您没有权限访问此集团信息!');
    alert('sorry,you have no access to the group information!');
</script>
<%
            }

        }
        //
        hashInfo.put("groupCode",groupCode);
        hashInfo.put("groupName",groupName);
        hashInfo.put("serareano",serareano);
        hashInfo.put("hallno",hallno);
        resultList = mangroup.queryGrpInfo(hashInfo);


        int pages = resultList.size()/25;
        if(resultList.size()%25>0)
            pages = pages + 1;
        sysTime = mangroup.getSysTime() + "--";
        if (operID != null && purviewList.get("11-1") != null) {
            String serviceKey = (String)session.getAttribute("SERVICEKEY");
        ArrayList serviceList = purview.getServiceList(serviceKey);
        String selectedServiceKey = (String)((HashMap)serviceList.get(0)).get("SERVICEKEY");
        ArrayList paramList = purview.getServiceParamList(selectedServiceKey);   // 权限范围列表
        map = (HashMap)paramList.get(0);   //业务区查询参数
        ArrayList paramInfoList = purview.getServiceParamInfo(map);
        //map = (HashMap)paramList.get(1);   //营业厅查询参数
        map = new HashMap();
        map.put("SWHERE","");
        map.put("PVALUEFIELD","hallno");
        if(purview.getDBType("133")==1)
            map.put("PTABLENAME","zxinsys.dbo.ser_pstn51_hall");
        else
            map.put("PTABLENAME","zxinsys.ser_pstn51_hall");
        map.put("PARAMORDER","1");
        map.put("PCFIELDNAME","Business hall");
        //返回serareano与hallname字段,用‘@’进行拼接,以方便以后拆分数组时使用
        if(purview.getDBType("133")==1)
            map.put("PFIELDNAME"," convert(varchar,serareano)+'@'+hallname");
        else
            map.put("PFIELDNAME"," to_char(serareano)||'@'||hallname");
        ArrayList hallInfoList = purview.getServiceParamInfo(map);
%>
<script language="javascript">
  //开始了漫长的动态关联hall与serarea脚本的生成
  var size = '<%= paramInfoList.size() +"" %>';
  //关联数组
  var where = new Array(size);
  //关联模式
  function comefrom(loca,locacity){
    this.loca = loca; this.locacity = locacity;
  }
<%
             HashMap tmpMap = new HashMap();
             String tmpName;
             //拆分拼接的hall字符串
             String[] tmpStr = null;
             //拼接hall信息所使用的StringBuffer
             StringBuffer sb = new StringBuffer();
             for (int k = 0; k < paramInfoList.size(); k++){
                 tmpMap = (HashMap)paramInfoList.get(k);
                 String tmpValue = (String)tmpMap.get("VALUE");
//                 int sum = k - 1;
                 int sum = k;
                 //value=0的记录集不需要
//                 if (!tmpValue.equals("0")){
                     for (int l = 0; l < hallInfoList.size(); l++){
                         map = (HashMap)hallInfoList.get(l);
                         tmpName = (String)map.get("NAME");
                         String value = (String)map.get("VALUE");
                         //value=0的记录集不需要
//                         if(!(value.equals("0"))){
                             tmpStr = tmpName.split("@");
                             String strSerareano = tmpStr[0];
                             String strHallname = tmpStr[1];
                             //关联hall与serarea的实现
                             if (strSerareano.equals(tmpValue)){
                                 sb.append(value).append("*").append(strHallname).append("|");
                             }//if
//                         }//if
                     }//for
                     if (sb.toString().equals("")){
                         sb.append("-1*no business hall data").append("|");
                     }
%>
  where[<%= sum + "" %>] = new comefrom('<%= tmpValue + "*" + (String)tmpMap.get("NAME") %>','<%= sb.toString() %>');
  <%if(tmpValue.equals(serareano)){%>
  where[<%=sum+""%>].selected=true;
<%}
                     //清空sb中的信息
                     sb = new StringBuffer();
//                 }//if
             }//for
%>
//将hallno关联到serareano
function selTime() {
  with(document.inputForm.serareano) {
    var loca2 = options[selectedIndex].value;
  }
  for(i = 0;i < where.length;i ++) {
    if (where[i].loca.split("*")[0] == loca2) {
      loca3 = (where[i].locacity).split("|");
      var locaLength = loca3.length - 1;
      for(j = 0;j < locaLength;j++) {
        with(document.inputForm.hallno) {
          length = loca3.length - 1;
          options[j].text = loca3[j].split("*")[1];
          options[j].value = loca3[j].split("*")[0];
          var loca4=options[selectedIndex].value;
        }
      }
      break;
    }
  }
}
//初始化serareano与hallno
function init() {
  with(document.inputForm.serareano) {
    length = where.length;
    for(k = 0;k < where.length;k++) {
      options[k].text = where[k].loca.split("*")[1];
      options[k].value = where[k].loca.split("*")[0];
      if(where[k].selected){
       options[k].selected=true;
      }
    }
  }
  with(document.inputForm.hallno) {
    loca3 = (where[0].locacity).split("|");
    length = loca3.length - 1;
    for(l=0;l<length;l++) {
      options[l].text = loca3[l].split("*")[1];
      options[l].value = loca3[l].split("*")[0];
    }
  }
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
    alert('Please input the digital number!');
    return false;
  }
}
//查询集团信息
function searchGroup(){
  var fm = document.inputForm;
  var groupName = trim(fm.groupName.value);
  var groupCode = trim(fm.groupCode.value);
//  if (groupCode == '' && groupName == ''){
//    alert('请输入查询条件');
//    return;
//  }
//  if (groupName.indexOf("'") == 0){
//    alert("输入的信息不能包含'号,请重新输入!");
//    fm.groupCode.value = '';
//    fm.groupName.focus();
//    return;
//  }
  for (var i = 0;i<groupName.length;i++){
    var ch = groupName.charAt(i);
    if("'".indexOf(ch) == 0){
    //  alert("输入的信息不能包含'号,请重新输入!");
      alert("The input information cannot include ',please re-enter!");
      fm.groupName.value = '';
      fm.groupName.focus();
      return;
      break;
    }
  }
  for (var i = 0;i<groupName.length;i++){
    var ch = groupName.charAt(i);
    if("\"".indexOf(ch) == 0){
     // alert("输入的信息不能包含\"号,请重新输入!");
        alert("The input information cannot include \",please re-enter!");
      fm.groupName.value = '';
      fm.groupName.focus();
      return;
      break;
    }
  }
  fm.mode.value = 'query';
  fm.page.value = 0;
  fm.submit();
}
function goPage(){
  var fm = document.inputForm;
  var pages = parseInt(fm.pages.value);
  var thispage = parseInt(fm.page.value);
  var thepage =parseInt(trim(fm.gopage.value));

  if(thepage==''){
    alert("Please specify the value of the page to go to!")
    fm.gopage.focus();
    return;
  }
  if(!checkstring('0123456789',thepage)){
    alert("he value of the page to go to can only be a digital number!")
    fm.gopage.focus();
    return;
  }
  if(thepage<=0 || thepage>pages ){
    alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!")
    fm.gopage.focus();
    return;
  }
  thepage = thepage -1;
  if(thepage==thispage){
    alert("This page has been displayed currently. Please re-specify a page!")
    fm.gopage.focus();
    return;
  }
  toPage(thepage);
}
function toPage (page) {
  document.inputForm.page.value = page;
  document.inputForm.mode.value = 'query';
  document.inputForm.submit();
}
//增加集团
function addInfo () {
  var fm = document.inputForm;
  var grpresult =  window.showModalDialog('grpInfoAdd.jsp',window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-380)/2)+";dialogTop:"+((screen.height-450)/2)+";dialogHeight:680px;dialogWidth:400px");
  if(grpresult && (grpresult=='yes')){
//    fm.op.value = '';
    fm.submit();
  }
}
function showInfo(groupindex,groupid,groupname,groupphone,groupaccount,maxtimes,maxrings,payflag,rentfee,extrafee,ischeck,serareano,hallno,nrentfee,managerphone,exitgrp,grpmode,opendate,maxmembers){
  window.showModalDialog('grpInfoAdd.jsp?mode=query&groupindex='+groupindex+'&groupid='+groupid+'&groupname='+encodeURIComponent(groupname)+'&groupphone='+groupphone+'&groupaccount='+groupaccount+'&maxtimes='+maxtimes+'&maxrings='+maxrings+'&payflag='+payflag+'&rentfee='+rentfee+'&extrafee='+extrafee+'&ischeck='+ischeck+'&serareano='+serareano+'&hallno='+hallno+'&nrentfee='+nrentfee+'&managerphone='+managerphone+'&exitgrp='+exitgrp+'&grpmode='+grpmode+'&opendate='+opendate +'&maxmembers='+maxmembers,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-380)/2)+";dialogTop:"+((screen.height-450)/2)+";dialogHeight:680px;dialogWidth:400px");
}
function delGroup(strGroupIndex,strGroupId){
  if (confirm('Are you sure to delete the group?')){
    var fm = document.inputForm;
    fm.groupIndex.value = strGroupIndex;
    fm.groupId.value = strGroupId;
    fm.mode.value = 'del';
    fm.submit();
  }else{
    return;
  }
}
function editGroup(groupindex,groupid,groupname,groupphone,groupaccount,maxtimes,maxrings,payflag,rentfee,extrafee,ischeck,serareano,hallno,nrentfee,managerphone,exitgrp,grpmode,opendate,maxmembers){
  var fm = document.inputForm;
  var grpresult = window.showModalDialog('grpInfoAdd.jsp?mode=edit&groupindex='+groupindex+'&groupid='+groupid+'&groupname='+encodeURIComponent(groupname)+'&groupphone='+groupphone+'&groupaccount='+groupaccount+'&maxtimes='+maxtimes+'&maxrings='+maxrings+'&payflag='+payflag+'&rentfee='+rentfee+'&extrafee='+extrafee+'&ischeck='+ischeck+'&serareano='+serareano+'&hallno='+hallno+'&nrentfee='+nrentfee+'&managerphone='+managerphone+'&exitgrp='+exitgrp+'&grpmode='+grpmode+'&opendate='+opendate +'&maxmembers='+maxmembers,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-380)/2)+";dialogTop:"+((screen.height-450)/2)+";dialogHeight:720px;dialogWidth:400px");
  if(grpresult && (grpresult=='yes')){
    fm.mode.value = 'query';
    fm.submit();
  }
}
</script>
<!--end-->
<form name="inputForm" action="grpInfo.jsp">
<input type="hidden" name="mode" value=""/>
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="groupIndex" value="">
<input type="hidden" name="groupId" value="">
<input type="hidden" name="pages" value="<%= pages %>">
<script language="JavaScript">
  if(parent.frames.length>0)
    parent.document.all.main.style.height="880";
</script>
<table widht="100%" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td>
      <table align="center" width="100%"  border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr >
          <td height="26" colspan="6" align="center" class="text-title" background="image/n-9.gif">Group info management</td>
        </tr>
        <tr >
          <td height="10" colspan="6" align="center" class="text-title">&nbsp;</td>
        </tr>
        <tr>
          <td align="right">Service area name</td>
          <td>
            <select name="serareano" class="input-style1" onchange="selTime()">
            </select>
          </td>
          <!--保留营业厅信息,3.17.06中未要求使用-->
          <td align="center" <%= enablegrphallno.equals("1") ? "style=\"display:none\"" : "style=\"display:none\"" %>>Business hall name</td>
          <td <%= enablegrphallno.equals("1") ? "style=\"display:none\"" : "style=\"display:none\"" %>>
            <select name="hallno" class="input-style1" onchange="selTime()">
            </select>
          </td>
        </tr>
        <tr>
          <td align="center">Group code</td>
          <td>
            <input type="text" value="<%=groupCode%>" name="groupCode" class="input-style1" onkeypress="return numbersOnly(this);" maxlength="<%=grouplen%>"/>
          </td>
          <td align="center">Group name</td>
          <td>
            <input type="text" value="<%=groupName%>" name="groupName" class="input-style1"/>
          </td>
          <td align="right"><img src="button/search.gif" alt="Find group" onmouseover="this.style.cursor='hand'" onclick="javascript:searchGroup('')"></td>
          <td align="right"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()" alt="Add group"/></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td width="100%" align="center">
      <table width="100%" border="0" cellspacing="1" cellpadding="1" align="left" class="table-style4">
         <tr class="tr-ringlist">
           <td  height="30" width="70">
             <div align="left"><font color="#FFFFFF">Group code</font></div>
           </td>
           <td height="30" width="120">
             <div align="left"><font color="#FFFFFF">Group name</font></div>
           </td>
           <td height="30" width="150">
             <div align="left"><font color="#FFFFFF">Service area code </font></div>
           </td>
           <td height="30"  width="60" <%= enablegrphallno.equals("1") ? "style=\"display:none\"" : "style=\"display:none\"" %>>
             <div align="left"><font color="#FFFFFF">Business hall no</font></div>
           </td>
           <td height="30" width="20">
             <div align="center"><font color="#FFFFFF">Info</font></div>
           </td>
           <td height="30" width="20">
             <div align="center"><font color="#FFFFFF">Edit</font></div>
           </td>
           <td height="30" width="20">
             <div align="center"><font color="#FFFFFF">Delete</font></div>
           </td>
         </tr>
<%
        int count = resultList.size() == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < resultList.size(); i++) {
            hash = (HashMap)resultList.get(i);
            count++;
%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">

        <td height="20"><div align="left"><%= (String)hash.get("groupid") %></div></td>
        <td height="20"><div align="left"><%= (String)hash.get("groupname") %></div></td>
        <td height="20"><div align="left"><%= ((String)hash.get("serareano")).equals("-1") ? "No devide" : (String)hash.get("serareano") %></div></td>

        <td height="20"><div align="center"><img src="../image/info.gif"   height=15 width=15 alt="Info" onMouseOver="this.style.cursor='hand'" onclick="showInfo('<%=(String)hash.get("groupindex")%>','<%=(String)hash.get("groupid")%>','<%=(String)hash.get("groupname")%>','<%=(String)hash.get("groupphone")%>','<%=(String)hash.get("groupaccount")%>','<%=(String)hash.get("maxtimes")%>','<%=(String)hash.get("maxrings")%>','<%=(String)hash.get("payflag")%>','<%=(String)hash.get("rentfee")%>','<%=(String)hash.get("extrafee")%>','<%=(String)hash.get("ischeck")%>','<%=(String)hash.get("serareano")%>','<%=(String)hash.get("hallno")%>','<%=(String)hash.get("nrentfee")%>','<%=(String)hash.get("managerphone")%>','<%=(String)hash.get("exitgrp")%>','<%=(String)hash.get("grpmode")%>','<%=(String)hash.get("opendate")%>','<%=(String)hash.get("maxmembers")%>')"></div></td>
        <td height="20"><div align="center"><img src="../image/edit.gif"   height=15 width=15 alt="Edit" onMouseOver="this.style.cursor='hand'" onclick="editGroup('<%=(String)hash.get("groupindex")%>','<%=(String)hash.get("groupid")%>','<%=(String)hash.get("groupname")%>','<%=(String)hash.get("groupphone")%>','<%=(String)hash.get("groupaccount")%>','<%=(String)hash.get("maxtimes")%>','<%=(String)hash.get("maxrings")%>','<%=(String)hash.get("payflag")%>','<%=(String)hash.get("rentfee")%>','<%=(String)hash.get("extrafee")%>','<%=(String)hash.get("ischeck")%>','<%=(String)hash.get("serareano")%>','<%=(String)hash.get("hallno")%>','<%=(String)hash.get("nrentfee")%>','<%=(String)hash.get("managerphone")%>','<%=(String)hash.get("exitgrp")%>','<%=(String)hash.get("grpmode")%>','<%=(String)hash.get("opendate")%>','<%=(String)hash.get("maxmembers")%>')"></div></td>
        <td height="20"><div align="center"><img src="../image/delete.gif" height=15 width=15 alt="Delete" onMouseOver="this.style.cursor='hand'" onclick="delGroup('<%=(String)hash.get("groupindex")%>','<%=(String)hash.get("groupid")%>')"></div></td>
        </tr>
<%
        }
        if (resultList.size() == 0 && !mode.equals("")){
%>
        <tr bgcolor="E6ECFF">
          <td align="center" colspan="10">No record matched the criteria!</td>
        </tr>
<%
        }
        if (resultList.size() > 25) {
%>
      </table>
    </td>
  </tr>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;Total:<%= resultList.size() %>,&nbsp;&nbsp;<%=  resultList.size()%25==0?resultList.size()/25:resultList.size()/25+1 %>&nbsp;page(s),&nbsp;&nbsp;Now on Page &nbsp;<%= thepage+1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= resultList.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (resultList.size() - 1) / 25 %>)"></td>
        </tr>
        <tr>
          <td colspan="5" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >Page&nbsp;</td>
             <td> <input style=text value="<%= String.valueOf(thepage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
             <td ><img src="../button/go.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:goPage()"  ></td>
            </tr>
            </table>
          </td>
       </tr>
      </table>
    </td>
  </tr>
<%
        }
%>
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
                   alert( "You have no access to this function!");
</script>
<%
            }
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in managing group info!");//集团信息管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing group info!");//集团信息管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="grpInfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

