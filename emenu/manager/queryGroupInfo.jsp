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
<title>Group information query</title>
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
    //��ѯ����
    String groupCode = request.getParameter("groupCode") == null ? "" : request.getParameter("groupCode");
    String groupName = request.getParameter("groupName") == null ? "" : request.getParameter("groupName");
    String serareano = request.getParameter("serareano") == null ? "" : request.getParameter("serareano");
    String hallno = request.getParameter("hallno") == null ? "" : request.getParameter("hallno");
    String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
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
              // ׼��д����Ա��־
              map.put("OPERID",operID);
              map.put("OPERNAME",operName);
              map.put("OPERTYPE","601");
              map.put("RESULT","1");
              map.put("PARA1",groupindex);
              map.put("PARA2",groupid);
              map.put("PARA3","ip:"+request.getRemoteAddr());
              map.put("DESCRIPTION","Delete");
              purview = new zxyw50.Purview();
              purview.writeLog(map);
              sysInfo.add(sysTime + operName +" delete group");
              if(rList.size()>0){
                session.setAttribute("rList",rList);
%>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="queryGroupInfo.jsp">
<input type="hidden" name="title" value="Delete group">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
<%
                }else{
                  hashInfo.put("groupCode",groupCode);
                  hashInfo.put("groupName",groupName);
                  hashInfo.put("serareano",serareano);
                  hashInfo.put("hallno",hallno);
                  resultList = mangroup.queryGrpInfo(hashInfo);
              }
        }else{
%>
<script language="javascript">
  alert('Sorry,you have no access to this group information!');//��Ǹ,��û��Ȩ�޷��ʴ˼�����Ϣ!
</script>
<%
            }
        }
        int pages = resultList.size()/25;
        if(resultList.size()%25>0)
            pages = pages + 1;
        sysTime = mangroup.getSysTime() + "--";
        if (operID != null && purviewList.get("11-1") != null) {
            String serviceKey = (String)session.getAttribute("SERVICEKEY");
        ArrayList serviceList = purview.getServiceList(serviceKey);
        String selectedServiceKey = (String)((HashMap)serviceList.get(0)).get("SERVICEKEY");
        ArrayList paramList = purview.getServiceParamList(selectedServiceKey);   // Ȩ�޷�Χ�б�
        map = (HashMap)paramList.get(0);   //ҵ������ѯ����
        ArrayList paramInfoList = purview.getServiceParamInfo(map);
        //map = (HashMap)paramList.get(1);   //Ӫҵ����ѯ����
        map = new HashMap();
        map.put("SWHERE","");
        map.put("PVALUEFIELD","hallno");
        if(purview.getDBType("133")==1)
            map.put("PTABLENAME","zxinsys.dbo.ser_pstn51_hall");
        else
            map.put("PTABLENAME","zxinsys.ser_pstn51_hall");
        map.put("PARAMORDER","1");
        map.put("PCFIELDNAME","Business hall");//Ӫҵ��
        //����serareano��hallname�ֶ�,�á�@������ƴ��,�Է����Ժ�������ʱʹ��
        if(purview.getDBType("133")==1)
            map.put("PFIELDNAME"," convert(varchar,serareano)+'@'+hallname");
        else
            map.put("PFIELDNAME"," to_char(serareano)||'@'||hallname");
        ArrayList hallInfoList = purview.getServiceParamInfo(map);
%>
<script language="javascript">
  //��ʼ�������Ķ�̬����hall��serarea�ű�������
  var size = '<%= paramInfoList.size() +"" %>';
  //��������
  var where = new Array(size);
  //����ģʽ
  function comefrom(loca,locacity){
    this.loca = loca; this.locacity = locacity;
  }
<%
             HashMap tmpMap = new HashMap();
             String tmpName;
             //���ƴ�ӵ�hall�ַ���
             String[] tmpStr = null;
             //ƴ��hall��Ϣ��ʹ�õ�StringBuffer
             StringBuffer sb = new StringBuffer();
             for (int k = 0; k < paramInfoList.size(); k++){
                 tmpMap = (HashMap)paramInfoList.get(k);
                 String tmpValue = (String)tmpMap.get("VALUE");
                 int sum = k - 1;
                 //value=0�ļ�¼������Ҫ
                 if (!tmpValue.equals("0")){
                     for (int l = 0; l < hallInfoList.size(); l++){
                         map = (HashMap)hallInfoList.get(l);
                         tmpName = (String)map.get("NAME");
                         String value = (String)map.get("VALUE");
                         //value=0�ļ�¼������Ҫ
                         if(!(value.equals("0"))){
                             tmpStr = tmpName.split("@");
                             String strSerareano = tmpStr[0];
                             String strHallname = tmpStr[1];
                             //����hall��serarea��ʵ��
                             if (strSerareano.equals(tmpValue)){
                                 sb.append(value).append("*").append(strHallname).append("|");
                             }//if
                         }//if
                     }//for
                     if (sb.toString().equals("")){
                         sb.append("-1* No business hall data").append("|");
                     }
%>
  where[<%= sum + "" %>] = new comefrom('<%= tmpValue + "*" + (String)tmpMap.get("NAME") %>','<%= sb.toString() %>');
<%
                     //���sb�е���Ϣ
                     sb = new StringBuffer();
                 }//if
             }//for
%>
//��hallno������serareano
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
//��ʼ��serareano��hallno
function init() {
  with(document.inputForm.serareano) {
    length = where.length;
    for(k = 0;k < where.length;k++) {
      options[k].text = where[k].loca.split("*")[1];
      options[k].value = where[k].loca.split("*")[0];
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
//�޶�ֻ����������
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
    alert('Please input a digital number');//����������
    return false;
  }
}
//��ѯ������Ϣ
function searchGroup(){
  var fm = document.inputForm;
  var groupName = trim(fm.groupName.value);
  var groupCode = trim(fm.groupCode.value);
//  if (groupCode == '' && groupName == ''){
//    alert('�������ѯ����');
//    return;
//  }
  if (groupName.indexOf("'") == 0){
    //alert('��������\'��');
      alert("Cannot input '");
    fm.groupCode.value = '';
    fm.groupName.focus();
    return;
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
    alert("Please specify the value of the page to go to!");//Please specify the value of the page to go to!
    fm.gopage.focus();
    return;
  }
  if(!checkstring('0123456789',thepage)){
    alert("The value of the page to go to can only be a digital number!")
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
function showInfo(groupindex,groupid,groupname,groupphone,groupaccount,maxtimes,maxrings,payflag,rentfee,extrafee,ischeck,serareano,hallno){
  window.showModalDialog('grpInfoAdd.jsp?mode=query&groupindex='+groupindex+'&groupid='+groupid+'&groupname='+groupname+'&groupphone='+groupphone+'&groupaccount='+groupaccount+'&maxtimes='+maxtimes+'&maxrings='+maxrings+'&payflag='+payflag+'&rentfee='+rentfee+'&extrafee='+extrafee+'&ischeck='+ischeck+'&serareano='+serareano+'&='+hallno,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-380)/2)+";dialogTop:"+((screen.height-450)/2)+";dialogHeight:450px;dialogWidth:380px");
}
function delGroup(strGroupIndex,strGroupId){
  var fm = document.inputForm;
  fm.groupIndex.value = strGroupIndex;
  fm.groupId.value = strGroupId;
  fm.mode.value = 'del';
  fm.submit();
}
function editGroup(groupindex,groupid,groupname,groupphone,groupaccount,maxtimes,maxrings,payflag,rentfee,extrafee,ischeck,serareano,hallno){
  window.showModalDialog('grpInfoAdd.jsp?mode=edit&groupindex='+groupindex+'&groupid='+groupid+'&groupname='+groupname+'&groupphone='+groupphone+'&groupaccount='+groupaccount+'&maxtimes='+maxtimes+'&maxrings='+maxrings+'&payflag='+payflag+'&rentfee='+rentfee+'&extrafee='+extrafee+'&ischeck='+ischeck+'&serareano='+serareano+'&='+hallno,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-380)/2)+";dialogTop:"+((screen.height-450)/2)+";dialogHeight:450px;dialogWidth:380px");
}
</script>
<!--end-->
<form name="inputForm" action="queryGroupInfo.jsp">
<input type="hidden" name="mode" value=""/>
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="groupIndex" value="">
<input type="hidden" name="groupId" value="">
<input type="hidden" name="pages" value="<%= pages %>">
<table width="551" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td>
      <table align="left" width="95%"  border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td align="right">Service area name</td>
          <td>
            <select name="serareano" class="input-style1" onchange="selTime()">
            </select>
          </td>
          <!--����Ӫҵ����Ϣ,3.17.06��δҪ��ʹ��-->
          <td align="right" <%= enablegrphallno.equals("1") ? "style=\"display:none\"" : "style=\"display:none\"" %>>Business hall name</td>
          <td <%= enablegrphallno.equals("1") ? "style=\"display:none\"" : "style=\"display:none\"" %>>
            <select name="hallno" class="input-style1" onchange="selTime()">
            </select>
          </td>
        </tr>
        <tr>
          <td align="right">Group code</td>
          <td>
            <input type="text" value="<%=groupCode%>" name="groupCode" class="input-style1" onkeypress="return numbersOnly(this);" maxlength="15"/>
          </td>
          <td align="right">Group name</td>
          <td>
            <input type="text" value="<%=groupName%>" name="groupName" class="input-style1"/>
          </td>
          <td align="left"><img src="../button/search.gif" alt="Search group" onmouseover="this.style.cursor='hand'" onclick="javascript:searchGroup('')"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td width="95%" align="left">
      <table width="95%" border="0" cellspacing="1" cellpadding="1" align="left" class="table-style4">
         <tr class="tr-ringlist">
           <td  height="30" width="70">
             <div align="center"><font color="#FFFFFF">Group code</font></div>
           </td>
           <td height="30" width="120">
             <div align="center"><font color="#FFFFFF">Group name</font></div>
           </td>
           <td height="30" width="80">
             <div align="center"><font color="#FFFFFF">Service area code</font></div>
           </td>
           <td height="30"  width="60" <%= enablegrphallno.equals("1") ? "style=\"display:none\"" : "style=\"display:none\"" %>>
             <div align="center"><font color="#FFFFFF">Business hall no</font></div>
           </td>
           <td height="30" width="20">
             <div align="center"><font color="#FFFFFF">Information</font></div>
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

        <td height="20"><div align="center"><%= (String)hash.get("groupid") %></div></td>
        <td height="20"><div align="center"><%= (String)hash.get("groupname") %></div></td>
        <td height="20"><div align="center"><%= (String)hash.get("serareano") %></div></td>

        <td height="20"><div align="center"><img src="../image/info.gif" alt="information" onMouseOver="this.style.cursor='hand'" onclick="showInfo('<%=(String)hash.get("groupindex")%>','<%=(String)hash.get("groupid")%>','<%=(String)hash.get("groupname")%>','<%=(String)hash.get("groupphone")%>','<%=(String)hash.get("groupaccount")%>','<%=(String)hash.get("maxtimes")%>','<%=(String)hash.get("maxrings")%>','<%=(String)hash.get("payflag")%>','<%=(String)hash.get("rentfee")%>','<%=(String)hash.get("extrafee")%>','<%=(String)hash.get("ischeck")%>','<%=(String)hash.get("serareano")%>','<%=(String)hash.get("hallno")%>')"></div></td>
        <td height="20"><div align="center"><img src="../image/edit.gif" alt="Edit" onMouseOver="this.style.cursor='hand'" onclick="editGroup('<%=(String)hash.get("groupindex")%>','<%=(String)hash.get("groupid")%>','<%=(String)hash.get("groupname")%>','<%=(String)hash.get("groupphone")%>','<%=(String)hash.get("groupaccount")%>','<%=(String)hash.get("maxtimes")%>','<%=(String)hash.get("maxrings")%>','<%=(String)hash.get("payflag")%>','<%=(String)hash.get("rentfee")%>','<%=(String)hash.get("extrafee")%>','<%=(String)hash.get("ischeck")%>','<%=(String)hash.get("serareano")%>','<%=(String)hash.get("hallno")%>')"></div></td>
        <td height="20"><div align="center"><img src="../image/delete.gif" alt="Delete" onMouseOver="this.style.cursor='hand'" onclick="delGroup('<%=(String)hash.get("groupindex")%>','<%=(String)hash.get("groupid")%>')"></div></td>
        </tr>
<%
        }
        if (resultList.size() == 0 && !mode.equals("")){
%>
        <tr bgcolor="E6ECFF">
          <td class="table-style2" align="center" colspan="10">No record matched the criteria!</td>
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
          <td>&nbsp;<%= resultList.size() %>&nbsp;entries in total&nbsp;<%= resultList.size()%25==0?resultList.size()/25:resultList.size()/25+1%>&nbsp;page&nbsp;&nbsp;You are now on Page &nbsp;<%= thepage + 1 %>&nbsp;</td>
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
  parent.document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime + " error occourred in the query of group information!");//��ѯ������Ϣ���̳��ִ���!
        sysInfo.add(sysTime + e.toString());
        //vet.add("��ѯ������Ϣ���̳��ִ���!");
        vet.add(" error occourred in the query of group information!");  
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="queryGroupInfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
