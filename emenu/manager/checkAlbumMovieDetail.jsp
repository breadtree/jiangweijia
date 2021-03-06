<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.sysringgrp.*" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.group.util.DateUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    String grouptype = request.getParameter("usernumber") == null ? "1" : (String)request.getParameter("usernumber");
    System.out.println("grouptype: "+grouptype);
 %>

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

   function goback(){
       window.close();
   }
</script>

    <%
    List vet = new ArrayList();
    String groupid = request.getParameter("groupid") == null ? "" : (String)request.getParameter("groupid");
	String type = request.getParameter("type") == null ? "" : (String)request.getParameter("type");
    System.out.println("groupid: "+groupid+" Type="+type);
    manSysRing sysring = new manSysRing();
    String title = "";
	if("1".equals(type)) {
        title = "Album";
	} else {
        title = "Movie";
	}

    if(!groupid.trim().equals("")){
      vet = sysring.queryAlbumMovieDetail(groupid);
    }

    int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
    int records = 25;
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
    if(ringdisplay.equals(""))  ringdisplay = "ringtone";
    String userNumber = (String)session.getAttribute("USERNUMBER");

    int pages = vet.size()/records;
    String uservalidday = CrbtUtil.getConfig("uservalidday","0") == null ? "0" : CrbtUtil.getConfig("uservalidday","0");

    if(vet.size()%records>0)
         pages = pages + 1;
    int  RINGNAME_LENGTH = 20;
    if(userNumber == null)
       RINGNAME_LENGTH = 24;
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

<table width="551" border="0" cellspacing="0" cellpadding="0" align="center">
<tr> 
  <td width="100%">
  <table width="99%" border="0" cellpadding="1" cellspacing="1" class="table-style4" align="center" >
  <tr class="tr-ringlist">
		<td height="30" width="70">
		  <div align="center"><font color="#FFFFFF"><%= title%> Name</font></div></td>
		<td height="30" width="70">
		  <div align="center"><font color="#FFFFFF"> code</font></div></td>
		<td height="30">
		  <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></font></div></td>
		<td height="30">
		  <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></font></div></td>
		<td height="30" width="70">
		  <div align="center"><font color="#FFFFFF">Period of Validity</font></div></td>
		<td height="30" width="20">
		  <div align="center"><font color="#FFFFFF">Preview</font></div></td>
  </tr>
  <%
      Map hash = null;
      int count = vet.size() == 0 ? records : 0;
      if(vet.size()>0){
      for (int i = thepage * records; i < thepage * records +records && i < vet.size(); i++) {
         hash = (Map)vet.get(i);
         count++;
         String playurl = "";
          String mediatype=  (String)hash.get("mediatype");
          if(mediatype.equals("1"))
              playurl = "../image/play.gif";
          if(mediatype.equals("2"))
              playurl = "../image/play1.gif";
          if(mediatype.equals("4"))
              playurl = "../image/play2.gif";
          %>
          <tr bgcolor="<%= count % 2 == 0 ?  "FFFFFF" : "E6ECFF"%>">
		      <td height="20"><%= (String)hash.get("funcname") %></td>
              <td height="20"><%= (String)hash.get("ringid") %></td>
              <td height="20"><%= getLimitString((String)hash.get("ringname"),RINGNAME_LENGTH) %></td>
              <td height="20"><%= displayRingAuthor((String)hash.get("signer")) %></td>
              <td height="20">
                    <%
                    if(("1").equals(uservalidday)){
                        long long1 = 0 ,long2 = 0 ;
                        long1 =  DateUtil.diffDate(DateUtil.toDate((String)hash.get("validdate")),DateUtil.getCurrentDate());
                        long2 = Long.parseLong((String)hash.get("uservalidday"));
                        if(long1<long2) {
                            long2 = long1;
                        }
                        if("0".equals((String)hash.get("uservalidday"))) {
                            out.println((String)hash.get("validdate"));
                        } else {
                            out.println(long2); %>&nbsp;days
                        <%
                        }
                    } else {
                        out.println((String)hash.get("validdate"));
                    }
                    %>
              </td>
              <td height="20" align="center"><img src="<%=playurl%>" alt="preview this:<%= ringdisplay %>" onmouseover="this.style.cursor='hand'" onclick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringname") %>','<%= (String)hash.get("signer") %>','<%= (String)hash.get("mediatype") %>')"></td>
          </tr>
          <%
     }
  }
  %>
  </table>
</td>
</tr>
    <tr>
        <td  align="center"><br>
        <img src="button/back.gif" onMouseOver="this.style.cursor='hand'" onClick="goback()">
	</tr>
</table>


