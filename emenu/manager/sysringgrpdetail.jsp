<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.sysringgrp.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
//    request.setCharacterEncoding("gbk");
    String userday = CrbtUtil.getConfig("uservalidday","0");
    String grouptype = request.getParameter("grouptype") == null ? "1" : (String)request.getParameter("grouptype");
    String groupid = request.getParameter("groupid") == null ? "" : (String)request.getParameter("groupid");
    String grouplabel = request.getParameter("grouplabel") == null ? "" : transferString((String)request.getParameter("grouplabel"));
    String spindex = request.getParameter("spindex") == null ? "" : (String)request.getParameter("spindex");
    String ringid    = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid"));

    String sysTime = null;
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String spcode = (String)session.getAttribute("SPCODE");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String backurl = null;
    try
    {
        SpManage sysring = new SpManage();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-13") != null)
        {
          SpManage  sysringgroup= new SpManage();

            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            HashMap map1= new HashMap();
            Map hash = null;
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            int optype = 0;
            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("HOSTNAME",request.getRemoteAddr());
            map.put("SERVICEKEY",sysring.getSerkey());
            map.put("OPERTYPE","1007");
            map.put("RESULT","1");
            map.put("PARA1",groupid);
            map.put("PARA2",grouplabel);
            map.put("PARA3",ringid);
            map.put("PARA4","ip:"+request.getRemoteAddr());
            String title = "";

            if (op.equals("del"))
            {
                optype = 2;
                title = "Delete sp music box:["+grouplabel+"] ringtone";
                map.put("DESCRIPTION","Delete sp music box:[" + grouplabel+"] ringtone");
            }
            if(optype>0)
            {
              map1.put("opcode",String.valueOf(optype));
              map1.put("ringgroup",groupid);
              map1.put("ringid",ringid);
              map1.put("newringid","0");  //该参数对删除无效

              rList = sysringgroup.modSysRingGroupMem(map1);
              purview.writeLog(map);
              if(rList.size()>0){
                session.setAttribute("rList",rList);
                backurl="sysringgrpdetail.jsp?grouptype=" + grouptype + "&groupid=" + groupid + "&grouplabel=" + grouplabel + "&spindex="+spindex;
                %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="<%= backurl %>">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
<%
}
}
}
              else
              {
                if(operID== null)
                {
                  %>
                  <script language="javascript">
                  alert( "Please log in to the system!");
                  document.URL = 'enter.jsp';
                  </script>
                  <%
                }
                else
                {
                %>
                <script language="javascript">
                alert( "Sorry,you have no access to this function!");//Sorry,you have no access to this function!
              </script>
              <%
            }
            }
    }
    catch(Exception ex)
    {
          Vector vet = new Vector();
          sysInfo.add(sysTime + operName + "Exception occourred in the process of search detail information!");
          sysInfo.add(sysTime + operName + ex.toString());
          vet.add("Error occourred in the process of search detail information");
          vet.add(ex.getMessage());
          session.setAttribute("ERRORMESSAGE",vet);
%>
          <form name="errorForm" method="post" action="error.jsp">
            <input type="hidden" name="historyURL" value="<%=backurl%>">
            </form>
<script language="javascript">
            document.errorForm.submit();
</script>
<%
   return ;
    }
%>

<!--修改以上 code -->

<html>
    <script src="../pubfun/JsFun.js"></script>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<script language="javascript">

   var currentRingId=null;
   var currentAction=-1;//0 collection 1 largess
   function refresh(number){
       parent.refresh(number);
       if(currentAction==0){
           collection (currentRingId);
       }else if(currentAction==1){
           largess(currentRingId);
       }
   }


  function login(ringid,action){
       currentRingId = ringid;
       currentAction = action;
       var child = window.open('enter1.jsp','loginWin','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }

   function myfavorite(op,ringid){
      var tryURL = 'myfavorite.jsp?ringid=' + ringid+'&op='+op;
      if(op==1)//add
         window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      else
         document.location.href = tryURL;
   }

   function tryListen(ringID,ringName,ringAuthor,mediatype) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
      if(trim(mediatype)=='1'){
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='4'){
        tryURL = 'tryView.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }
   }

   function ringInfo (ringid) {
      infoWin = window.open('ringInfo.jsp?ringid=' + ringid,'infoWin','width=400, height=340,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }
   function goback(){
       document.URL ='sysringgroup.jsp?grouptype=<%=grouptype%>';
   }

   //增加铃音到铃音组中
   function addRing()
   {
      var fm = document.inputForm;
      document.location.href = 'musicboxMemberSelect.jsp?grouptype=<%=grouptype%>&ringgroup='+fm.groupid.value+'&grouplabel='+fm.grouplabel.value+'&spindex='+
      fm.spindex.value;
   }

   //删除铃音
   function delRing(ringid)
   {
     var fm = document.inputForm;
     fm.op.value = 'del';
     //提示用户确认
    if (!confirm('Are you sure to delete?'))
      return;
     fm.ringid.value = ringid;
     fm.submit();
   }

    function goPage(){
      var fm = document.inputForm;
      var pages = parseInt(fm.pages.value);
      var thispage = parseInt(fm.page.value);
      var thepage =parseInt(trim(fm.gopage.value));

      if(thepage==''){
         alert("Please specify the value of the page to go to!")//Please specify the value of the page to go to!
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
         alert("The value of the page to go to can only be a digital number!")//The value of the page to go to can only be a digital number
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!")//alert("转到的页码值范围不正确  页）!
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      if(thepage==thispage){
         alert("This page has been displayed currently. Please re-specify a page!")//This page has been displayed currently. Please re-specify a page!
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }
 function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }
</script>
    <%
    List vet = new ArrayList();
//    String groupid = request.getParameter("groupid") == null ? "" : (String)request.getParameter("groupid");
    if(!groupid.trim().equals(""))
    {
      vet = new SysRingGrpDataGateway().queryGroupDetail(groupid);
    }
    String isFavorite = (String)request.getAttribute("isfavorite");
    if(isFavorite == null)
       isFavorite = "";
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    int largessflag = 0;
    if(disLargess.equals("1"))
        largessflag = 1;
    int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
    int records = 25;
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
    if(ringdisplay.equals(""))  ringdisplay = "ringtone";
    String userNumber = (String)session.getAttribute("USERNUMBER");
    int pages = vet.size()/records;
    if(vet.size()%records>0)
         pages = pages + 1;
    int  RINGNAME_LENGTH = 20;
    if(userNumber == null)
       RINGNAME_LENGTH = 24;//
    %>
<meta http-equiv="Content-Type" content="text/html; "><style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>

<form name="inputForm" method="post" action="sysringgrpdetail.jsp">
  <input type="hidden" name="groupid" value="<%=groupid%>"/>
  <input type="hidden" name="grouplabel" value="<%=grouplabel%>"/>
  <input type="hidden" name="grouptype" value="<%=grouptype%>"/>
  <input type="hidden" name="spindex" value="<%=spindex%>"/>
  <input type="hidden" name="op" value=""/>
  <input type="hidden" name="ringid" value=""/>
  <input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">



<table width="535" border="0" cellspacing="0" cellpadding="0" align="center">
<tr> <td width="100%"><table width="99%" border="0" cellpadding="1" cellspacing="1" class="table-style4" align="center" >
  <tr class="tr-ringlist">
    <td height="30" width="70">
      <div align="center"><font color="#FFFFFF"><span title="<%= ringdisplay %> ID"> ID</span></font></div></td>

    <td height="30">
      <div align="center"><font color="#FFFFFF"><span title="<%= ringdisplay %> Name"> <%=zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></span></font></div></td>

    <td height="30">
      <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></font></div></td>
     <%if(userday.equalsIgnoreCase("1"))
     {%>
     <%//begin add 用户有效期%>
     <td height="30" width="70">
      <div align="center"><font color="#FFFFFF"><span title="User Period of validity">Validity</span></font></div></td>
          <%}%>
    <td height="30" width="70">
      <div align="center"><font color="#FFFFFF"><span title="Copyright validity">Copyright validity</span></font></div></td>
   <td height="30" width="20">
      <div align="center"><font color="#FFFFFF"><span title="Delete this ringtone">Delete</span></font></div></td>
    <td height="30" width="20">
      <div align="center"><font color="#FFFFFF"><span title="Listen this ringtone ">Listen</span></font></div></td>
  </tr>
  <%
      Map hash = null;
      int count = vet.size() == 0 ? records : 0;
      for (int i = thepage * records; i < thepage * records +records && i < vet.size(); i++) {
         hash = (Map)vet.get(i);
         count++;
    %>
  <tr bgcolor="<%= count % 2 == 0 ?  "FFFFFF" : "E6ECFF"%>">
    <td height="20"><%= (String)hash.get("ringid") %></td>
    <td height="20"><%= getLimitString((String)hash.get("ringname"),RINGNAME_LENGTH) %></td>
    <td height="20"><%= displayRingAuthor((String)hash.get("signer")) %></td>
     <%if(userday.equalsIgnoreCase("1"))
     {%>
      <td height="20" align="center"><%= (String)hash.get("uservalidday") %></td>
    <% }%>
    <td height="20"><%= (String)hash.get("validdate") %></td>
    <td height="20" align="center"><img src="../image/delete.gif" height='15'  width='15' alt="Delete" onmouseover="this.style.cursor='hand'" onclick="javascript:delRing('<%=(String)hash.get("ringid")%>')"></td><!--删除-->
    <td height="20" align="center"><img src="../image/play.gif"   height='15'  width='15' alt="Try listen this <%= ringdisplay %>" onmouseover="this.style.cursor='hand'" onclick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringname") %>','<%= (String)hash.get("signer") %>','<%= (String)hash.get("mediatype") %>')"></td>
  </tr>
  <% } if (vet.size() > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;Total:<%= vet.size() %>,&nbsp;&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;page(s)&nbsp;&nbsp;Now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
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
	<tr>
          <td width="100%" align="center" height="16">
              <img src="../button/add.gif" onMouseOver="this.style.cursor='hand'" onClick="addRing()">
                  &nbsp;&nbsp;
              <img src="../button/back.gif" onMouseOver="this.style.cursor='hand'" onClick="goback()">
        </td>
	</tr>
</table>
</form>

