<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.sysringgrp.*" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%@ include file="../../pubfun/JavaFun.jsp" %>

<%
String userday = CrbtUtil.getConfig("uservalidday","0");
    String grouptype = request.getParameter("grouptype") == null ? "1" : (String)request.getParameter("grouptype");
 %>
<html>
    <script src="../../pubfun/JsFun.js"></script>
<head>
<link href="../style.css" type="text/css" rel="stylesheet">
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

   function tryListen(ringID,ringName,ringAuthor) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }

   function ringInfo (ringid) {
      infoWin = window.open('ringInfo.jsp?ringid=' + ringid,'infoWin','width=400, height=340,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }
   function goback(){
       document.URL ='sysringgroup.jsp?grouptype=<%=grouptype%>';
   }
</script>

    <%
    List vet = new ArrayList();
    String groupid = request.getParameter("groupid") == null ? "" : (String)request.getParameter("groupid");
    if(!groupid.trim().equals("")){
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
       RINGNAME_LENGTH = 24;
    String showmusicstyle = CrbtUtil.getConfig("showmusicstyle","0");
    String showgiftvaliddate = CrbtUtil.getConfig("showgiftvaliddate","1");
    
    
    String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
    
    
    
    String pricestyle = showmusicstyle.trim().equals("0")?"&nbsp;"+majorcurrency :"&nbsp;"+majorcurrency+"/month";
    String grpname = "";
    if(grouptype.trim().equals("2"))
    {
      grpname = CrbtUtil.getConfig("giftname","giftbag")+" ";
      pricestyle = "&nbsp;"+majorcurrency ;
    }else{
      grpname = CrbtUtil.getConfig("ringBoxName","musicbox")+" ";
    }
    SysRingGrpDataGateway sysgrp = new SysRingGrpDataGateway();
    List vet1=null;
    HashMap map = new HashMap();
    vet1 = sysgrp.querySysRingGroup(Integer.parseInt(grouptype),groupid);
    if(vet1!=null && vet1.size()>0){
      map = (HashMap)vet1.get(0);
    }
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
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr> <td width="100%">
  <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style4" align="center">

         <tr class="tr-ringlist">
            <td align="center" width="50%" colspan="2">
              <div align="center"><b><font color="#FFFFFF">
                <%=  grpname  %>Information</font></b></div>
            </td>
          </tr>
          <tr bgcolor="E6ECFF">
            <td align="right" width="50%"><%=  grpname  %>Code:&nbsp;</td>
            <td width="50%">&nbsp;<%= map==null?"":(String)map.get("ringid") %></td>
          </tr>
          <tr bgcolor="FFFFFF">
            <td align="right"><%=  grpname  %>Name:&nbsp;</td>
            <td>&nbsp;<%= map==null?"":(String)map.get("ringname") %></td>
          </tr>
          <tr bgcolor="E6ECFF">
            <td align="right"><%=  grpname  %>Provider:&nbsp;</td>
            <td>&nbsp;<%= map==null?"":(String)map.get("spname") %></td>
          </tr>
          <tr bgcolor="FFFFFF">
            <td align="right"><%=  grpname  %>Price:&nbsp;</td>
            <td>&nbsp;<%= formatFee(map==null?"0":(String)map.get("ringfee")) %><%=pricestyle%></td>
          </tr>
          <%if(grouptype.trim().equals("1")){%>
          <tr bgcolor="E6ECFF">
            <td align="right">Validaty:&nbsp;</td>
            <td >&nbsp;<%=(map==null?"":((String)map.get("validdate")).trim() ) %>
            </td>
          </tr>
          <%}else{
             if(showgiftvaliddate.trim().equals("1")){%>
          <tr bgcolor="E6ECFF">
            <td align="right">Validaty:&nbsp;</td>
            <td >&nbsp;<%=(map==null?"":((String)map.get("validdate")).trim() ) %>
            </td>
          </tr>
         <% }}%>
         <%if(grouptype.trim().equals("1")){%>
         <tr bgcolor="FFFFFF">
         <%}else{
             if(showgiftvaliddate.trim().equals("1")){%>
             <tr bgcolor="FFFFFF">
        <%}else{%><tr bgcolor="E6ECFF"><%}}%>
            <td align="right">Times of order:&nbsp;</td>
            <td>&nbsp;<%= map==null?"":(String)map.get("buytimes") %></td>
          </tr>
          <tr bgcolor="E6ECFF">
            <td align="right">Descrption:&nbsp;</td>
            <td >&nbsp;<%=(map==null?"":((String)map.get("description")).trim() ) %>
            </td>
          </tr>
  </table>
<br>
  <table width="99%" border="0" cellpadding="1" cellspacing="1" class="table-style4" align="center" >
  <tr class="tr-ringlist">
    <td height="30" width="70">
      <div align="center"><font color="#FFFFFF"><%= ringdisplay %> Code</font></div></td>

    <td height="30">
      <div align="center"><font color="#FFFFFF"><%= ringdisplay %> Name</font></div></td>

    <td height="30">
      <div align="center"><font color="#FFFFFF">Singer</font></div></td>
     <%if(userday.equalsIgnoreCase("1"))
     {%>
     <%//begin add 用户有效期%>
     <td height="30" width="70">
      <div align="center"><font color="#FFFFFF">Subscriber<br>Validity(day)</font></div></td>
          <%}%>
    <td height="30" width="70">
      <div align="center"><font color="#FFFFFF">Copyright<br>validaty</font></div></td>
      <!--
    <td height="30" width="20">
      <div align="center"><font color="#FFFFFF">Pre-listen</font></div></td>
      -->
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
          <!--
    <td height="20" align="center"><img src="../../image/play.gif" alt="Pre-listen<%= ringdisplay %>" onmouseover="this.style.cursor='hand'" onclick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringname") %>','<%= (String)hash.get("signer") %>')"></td>
      -->
  </tr>
  <% } %>
</table>

    </td>
</tr>
	<tr>
            <td  align="center"><br>
                <img src="../../button/back.gif" onMouseOver="this.style.cursor='hand'" onClick="goback();">
	</tr>
	</table>


