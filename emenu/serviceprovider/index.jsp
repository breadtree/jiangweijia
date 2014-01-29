<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="zxyw50.bulletin.*" %>

<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="com.zte.socket.imp.manager.PoolManager" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<script language="JavaScript" src="../scroller.js"></script>
<script language="JavaScript" src="../navcond.js"></script>
<script language="javascript">
var myScroller1 = new Scroller(0, 0, 170, 100, 0, 8);
var first = true;
myScroller1.setColors("#006600", "fffff5", "#060000");
myScroller1.setFont("Arial", 1);//Arial
function runscroller() {
    if(first){
        var layer;
        var x, y;
        layer = getLayer("content3");
        x = getPageLeft(layer)+1;
        y = getPageTop(layer)-1;
        myScroller1.create();
        myScroller1.hide();
        myScroller1.moveTo(x, y);
        myScroller1.setzIndex(100);
        first = false;
    }
  myScroller1.show();
}


   function isshow(aa){
   var id = aa;
   var menu="";
   for (var i=1;i<=3;i++)
   {
       menu = window.eval('window.content'+ i)
   	   if (menu.id==aa)
   	   {
   	   	  continue;
   	   }
        if(i==3){
            myScroller1.hide();
        }
       menu.style.display ='none';
   }
   	aa= window.eval('window.'+ aa)
	if (aa.style.display=='none'){
	aa.style.display="";
        if(id=='content3'){
            runscroller();
        }
    }else{
        aa.style.display='none';
        if(id=='content3'){
            myScroller1.hide();
        }
    }
}

   function refresh () {
      document.URL = 'menu.jsp';
   }
   function openwin(path,name){
   	window.open(path,name,"height=500,width=700,resizable=yes,scrollbars=yes,status=no,toolbar=no,menubar=no,location=no");
  }

   var currentid="";
   var lastid="";
   function f_changeColor(id){
     lastid=currentid;
     currentid=id;

     var objC  = eval("" + currentid);
     objC.style.color="red";


 	 if(lastid!=currentid)
 	 {
 	  	if(lastid=="")
 	 		return;
     	var objL = eval("" + lastid);
     	objL.style.color="gray";
	 }
   }


</script>
<title></title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body class="body-style1" background="../manager/image/bac.gif">
<%
    String ringdisplay = zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone");
    String shortdisplay = zte.zxyw50.util.CrbtUtil.getConfig("shortdisplay","ring");

    String operID = (String)session.getAttribute("OPERID")==null?"":(String)session.getAttribute("OPERID");
    String spIndex = (String)session.getAttribute("SPINDEX");
    String sysringgrpenable = CrbtUtil.getConfig("sysringgrpenable","0");
    String isshowadring = CrbtUtil.getConfig("isshowad","0");
    String scPage = CrbtUtil.getConfig("scPage","0");
     String allowup = (String)application.getAttribute("ALLOWUP")==null?"0":(String)application.getAttribute("ALLOWUP");
    String spscPage=CrbtUtil.getConfig("spscPage","0");
     String headurl=CrbtUtil.getConfig("headurl","../pubfun/head_bottom/head.html");
    String bottomurl=CrbtUtil.getConfig("bottomurl","../pubfun/head_bottom/bottom.html");
    //是否使用套餐功能
    String usediscount=CrbtUtil.getConfig("usediscount","0");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	 String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");


	    //是否显示大礼包
    String ifShowGiftBag = CrbtUtil.getConfig("ifShowGiftBag","1");
	    //音乐盒与大礼包名字
    String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");
    String giftbag   = CrbtUtil.getConfig("giftname","giftbag");
    String ifhidemixtune   = CrbtUtil.getConfig("ifhidemixtune","0");
	String managertype = (String)session.getAttribute("OPERATORTYPE");
	if(!"spmanager".equals(managertype) )
   	{
   		purviewList.clear();
   		session.invalidate();
   		operID = "";
   	}



        if(operID!=null&&spIndex!=null && !spIndex.equals("-1")){
            //DefaultBulletinContext context = new DefaultBulletinContext();
           //List list = context.loadSpBulletins(spIndex);
           List list = new ArrayList();
           if(list.size()>0){
               for(int i=0;i<list.size();i++){
                   BulletinObj obj = (BulletinObj)list.get(i);
                   %>
                   <script language="javascript">
                   myScroller1.addItem("<font size=1 color=4f677f><%=obj.getRecorddate()%></font><br><span class='text-default'> <a href='javascript:openwin(\"viewbulletin.jsp?bindex=<%=obj.getIndex()%>\",<%=obj.getIndex()%>)'><%=obj.getTitle()%></a></span>");
                   </script>
               <%}
           }else{
               %>
                   <script language="javascript">
                   myScroller1.addItem("<span class='text-default'>No bulletin now!</span>");//暂时没有公告信息
                   </script>
           <%}
        }else{
               %>
                   <script language="javascript">
                   myScroller1.addItem("<span class='text-default'>No bulletin now!</span>");//暂时没有公告信息
                   </script>
           <%}
%>
<form name="inputForm" method="get" action="">
<%
 if("1".equals(scPage)&&("1".equals(spscPage))){
%>
<iframe width=768  name="topbar"  align="center"  height="120" scrolling=no frameborder=0  src="../<%=headurl%>" ></iframe>
<%}%>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="182"><img src="../image/home_r1_c1.gif" width="182" height="102"></td>
    <td background="../manager/image/home_r1_c2.gif" width="576"><img src="..//image/spmanager.gif" width="576" height="102"></td>
  </tr>
</table>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td background="../manager/image/home_r2_c1.gif" width="8"><img src="../manager/image/home_r2_c1.gif" width="8" height="38"></td>
    <td valign="top" width="170" background="../manager/image/home_r10_c2bg.gif">
        <!-- here -->

<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="table-style2">
	<tr>
          <td background="../manager/image/ab.gif" height="24" valign="bottom">
            <div align="left">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2"  onClick="<%= operID.length()==0?"":"javascript:isshow('content3')" %>" onMouseOver="this.style.cursor='hand'" >
                <tr>
                  <td valign="bottom" height="20" align="center" ><font class="font-man"><b>Bulletin</b></font>
                    </td>
                </tr>
              </table>
            </div>
            </td></tr>
            <tr><td>
            <div align="center">
            <img src="../manager/image/ae.gif" width="170" height="13">
                </div>
          </td>
            </tr>
	<tr><td><div id="content3" style="position:relative;align:center;display:none; width:170; height:100;" align="right"></div>
   </td>
  </tr>
</table>
<!-- here-->
     <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
          <td background="../manager/image/ab.gif" height="24" valign="bottom">
            <div align="left">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2" onClick="<%= operID.length()==0?"":"javascript:isshow('content1')" %>" onMouseOver="this.style.cursor='hand'">
                <tr>
                  <td width="20">&nbsp;</td>
                  <td valign="bottom" height="20" align="center" ><font class="font-man"><b><span title="SP <%=ringdisplay%> management">SP <%=ringdisplay%> </span></b></font>
                    </td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
              <table id='content1' width="100%" cellspacing="0" cellpadding="0" class="table-style2" background="../manager/image/home_r6_c2.gif" style="DISPLAY:none">
               <%
                 if(purviewList.get("10-1") != null){
               %>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif" width="16" height="16"><a href="ringUpload.html" target="main" title="Upload SP <%=ringdisplay%>"><font class="font" onclick="f_changeColor('td1001')" id="td1001"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Upload</font></a></td>
                               </tr>
               <%
                       }if(purviewList.get("10-12") != null){%>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif" width="16" height="16"><a href="altspringUpload.html" target="main" title="Upload SP Shake <%=ringdisplay%>"><font class="font" onclick="f_changeColor('td1012')" id="td1012"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Upload Shake</font></a></td>
                               </tr>
               <%//sp mix tone
                       }
		if( ( ifhidemixtune.equals("1") ) && (purviewList.get("10-17") != null) )
						   {
						%>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif" width="16" height="16"><a href="mixtune.jsp?initial=1" target="main" title="Mix Tune"><font class="font" onclick="f_changeColor('td1017')" id="td1017"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Mix Tune</font></a></td>
                               </tr>

                       <%}
                       if(purviewList.get("10-2") != null){
               %>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="ringEdit3.jsp" target="main" title="SP <%=ringdisplay%> Management"><font class="font" onclick="f_changeColor('td1002')" id="td1002"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Management</font></a></td>
                               </tr>
                <%
                       }if(purviewList.get("10-13") != null){
               %>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="alertringspedit.jsp" target="main" title="SP Shake <%=ringdisplay%> Management"><font class="font" onclick="f_changeColor('td1013')" id="td1013"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Management Shake</font></a></td>
                               </tr>
                <%}if(purviewList.get("10-14") != null){
               %>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="alertringmobedit.jsp" target="main" title="SP <%=ringdisplay%> relation manage"><font class="font" onclick="f_changeColor('td1014')" id="td1014"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Relation</font></a></td>
                               </tr>
                <%}if(purviewList.get("10-3") != null){
               %>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="springSearch.jsp" target="main" title="Search SP <%=ringdisplay%>s"><font class="font" onclick="f_changeColor('td1003')" id="td1003"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Search SP <%=ringdisplay%>s</font></a></td>
                               </tr>
                <%
                       }

//                       if(purviewList.get("10-4") != null){
//
//               	<!--			<tr>
//                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="springDate.html" target="main"><font class="font"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Modify SP ringtone validity</font></a></td>
//                             </tr>-->
//                <%
//                       }
                       if(purviewList.get("10-5") != null){
               %>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="springReplace.html" target="main" title="Replace SP <%=ringdisplay%>"><font class="font" onclick="f_changeColor('td1005')" id="td1005"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Replace SP <%=ringdisplay%></font></a></td>
                               </tr>
                <%
                       } if(purviewList.get("10-6") != null){
               %>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="springRecommend.jsp" target="main" title="SP hot <%=ringdisplay%>"><font class="font" onclick="f_changeColor('td1006')" id="td1006"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">SP hot <%=ringdisplay%></font></a></td>
                               </tr>
                <%
                       } if("1".equals(sysringgrpenable)&&(purviewList.get("10-7") != null)){

               %>
               			<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="musicbox.jsp" target="main" title="SP <%=musicbox%>"><font class="font" onclick="f_changeColor('td1007')" id="td1007"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">SP <%=musicbox%></font></a></td>
                        </tr>
                <%}if("1".equals(usediscount)&& (purviewList.get("10-11") != null)){

                %>
                        <tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="discount.jsp" target="main" title="SP Package"><font class="font" onclick="f_changeColor('td1011')" id="td1011"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">SP Package</font></a></td>
                        </tr>

                <%
                       } if("1".equals(sysringgrpenable)&&(purviewList.get("10-8") != null) && "1".equals(ifShowGiftBag) ){

               %>
               			<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="giftbag.jsp" target="main" title="SP <%=giftbag%>"><font class="font" onclick="f_changeColor('td1008')" id="td1008"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">SP <%=giftbag%></font></a></td>
                        </tr>
 <%      }  if("1".equals(isshowadring)&&(purviewList.get("10-9") != null)){

               %>
               			<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="ringAdArea.jsp" target="main" title="The SP advertisement special area <%=ringdisplay%> manage"><font class="font" onclick="f_changeColor('td1009')" id="td1009"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Special area</font></a></td>
                        </tr>
               <%      }  %>
               <%
               if(purviewList.get("10-10") != null) {  %>
               <tr>
                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="spbackRing.jsp" target="main" title="SP refusal <%=ringdisplay%> manage"><font class="font" onclick="f_changeColor('td1010')" id="td1010"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Refusal <%=ringdisplay%></font></a></td>
                 </tr>
               <%      }    %>
               <%
              if ((purviewList.get("10-16") != null)&& allowup.equals("1") ) {   %>
               <tr>
                   <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="checkUserRing.jsp" target="main" title="SP Personal <%=ringdisplay%> audit"><font class="font" onclick="f_changeColor('td1016')" id="td1016"><img src="../manager/image/n-8.gif" width="8" height="8" border="0"><%=ringdisplay%> audit</font></a></td>
               </tr>
               <%      }    %>
              </table>
              <img src="../manager/image/ae.gif" width="170" height="13"></div>
          </td>
        </tr>
      </table>

      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
          <td background="../manager/image/ab.gif" height="24">
            <div align="center">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2" onClick="<%= operID.length()==0?"":"javascript:isshow('content2')" %>" onMouseOver="this.style.cursor='hand'">
                <tr>
                  <td width="20">&nbsp;</td>
                  <td height="20" valign="bottom" align="center"><font class="font-man"><b><span title="SP query and statistics">Query and Statistics</span></b></font></td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
              <table id='content2' width="100%" cellspacing="0" cellpadding="0" class="table-style2" background="../manager/image/home_r6_c2.gif" style="DISPLAY:none">
<%
if (purviewList.get("9-1") != null ||purviewList.get("9-2") != null||purviewList.get("9-3") != null ||purviewList.get("9-4") != null ||purviewList.get("9-5") != null ) {
%>
				<tr>
                  <td width="100%"><img src="../manager/image/ac.gif" width="170" height="14"></td>
                </tr>
                <%}
        if (purviewList.get("9-1") != null) {
%>
                <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/midblk.gif"><a href="spScribStat.jsp" target="main" title="Query SP <%=ringdisplay%> orders"><font class="font" onclick="f_changeColor('td0901')" id="td0901"><img src="../manager/image/n-8.gif" width="8" height="8" border="0"><%=ringdisplay%> orders</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("9-2") != null) {
%>
                <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="spRingList.jsp" target="main" title="SP <%=ringdisplay%> sort"><font class="font" onclick="f_changeColor('td0902')" id="td0902"><img src="../manager/image/n-8.gif" width="8" height="8" border="0"><%=ringdisplay%> sort</font></a></td>
                </tr>
                <%
        }
          if (purviewList.get("9-3") != null) {
%>
                <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="spUncheckRing.jsp" target="main" title="The refused SP <%=ringdisplay%>s"><font class="font" onclick="f_changeColor('td0903')" id="td0903"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Refused <%=ringdisplay%>s</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("9-4") != null) {
%>
                <tr>
                  <td width="100%" height="17"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="spSysStat.jsp" target="main" title="SP system statistics"><font class="font" onclick="f_changeColor('td0904')" id="td0904"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">SP system statistics</font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("9-5") != null) {
%>
                <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="spInfo.jsp" target="main" title="SP Setting Info"><font class="font" onclick="f_changeColor('td0905')" id="td0905"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">SP Setting Info</font></a></td>
                </tr>

 <%
        }
        if (purviewList.get("9-7") != null) {
%>
                <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="qryCheckRing.jsp" target="main" title="Query SP <%=ringdisplay%> for Approval"><font class="font" onclick="f_changeColor('td0907')" id="td0907"><img src="../manager/image/n-8.gif" width="8" height="8" border="0"><%=ringdisplay%> for Approval</font></a></td>
                </tr>
                <%} if (purviewList.get("9-9") != null) {%>
                <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="qryOper.jsp" target="main" title="Query SP operations for Approval"><font class="font" onclick="f_changeColor('td0909')" id="td0909"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Ops. for Approval</font></a></td>
                </tr>
                <%} if ("1".equals(sysringgrpenable)&&purviewList.get("9-10") != null) {%>
                <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="qryopermusic.jsp" target="main" title="Query Ringgroup for Approval"><font class="font" onclick="f_changeColor('td0910')" id="td0910"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Ringgroup for Approval</font></a></td>
                </tr>
                <%} if ("1".equals(sysringgrpenable)&&purviewList.get("9-11") != null) {%>
                <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="spmusicqrycheck.jsp" target="main" title="Query ringgroup audit"><font class="font" onclick="f_changeColor('td0911')" id="td0911"><img src="../manager/image/n-8.gif" width="8" height="8" border="0">Ringgroup audit</font></a></td>
                </tr>
 <%
        }
%>
                <tr>
                  <td width="100%"><img src="../manager/image/ad.gif" width="170" height="8"></td>
                </tr>

              </table>
              <img src="../manager/image/ae.gif" width="170" height="13"></div>
          </td>
        </tr>
      </table>



	  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
        <tr>
          <td><img src="../manager/image/home_r10_c2bg.gif" width="170" height="8"></td>
        </tr>
      </table>

 <%

	if(operID.length() != 0 && purviewList.get("9-8") != null ){
    %>
      <table width="165" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
        <tr>
          <td width="28"><img src="../manager/image/home_r14_c3.gif" width="28" height="31"></td>
          <td background="../manager/image/home_r14_c5bg.gif">
            <div align="center"><a href="batchRing.jsp" target="main"><font class="font-man" ><b>Batch upload <%=ringdisplay%></b></font></a></div>
          </td>
          <td width="12"><img src="../manager/image/home_r14_c5.gif" width="12" height="31"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
        <tr>
          <td><img src="../manager/image/home_r10_c2bg.gif" width="170" height="8"></td>
        </tr>
      </table>
<%
	}
    if(operID.length() != 0){
%>
   <table width="165" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
        <tr>
          <td width="28"><img src="../manager/image/home_r14_c3.gif" width="28" height="31"></td>
          <td background="../manager/image/home_r14_c5bg.gif">
            <div align="center"><a href="spchangePassword.jsp" target="main"><font class="font-man"><b>Modify SP password</b></font></a></div>
          </td>
          <td width="12"><img src="../manager/image/home_r14_c5.gif" width="12" height="31"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
        <tr>
          <td><img src="../manager/image/home_r10_c2bg.gif" width="170" height="8"></td>
        </tr>
      </table>
     <%
      }
	if(operID.length() != 0 && purviewList.get("9-6") != null ){
    %>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
      </table>
      <table width="165" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
        <tr>
          <td width="28"><img src="../manager/image/home_r14_c3.gif" width="28" height="31"></td>
          <td background="../manager/image/home_r14_c5bg.gif">
            <div align="center"><a href="../manager/purview/operLog.jsp?operflag=1" target="main"><font class="font-man"><b>SP Operation log</b></font></a></div>
          </td>
          <td width="12"><img src="../manager/image/home_r14_c5.gif" width="12" height="31"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
        <tr>
          <td><img src="../manager/image/home_r10_c2bg.gif" width="170" height="8"></td>
        </tr>
      </table>
<%
	}
%>
      <table width="165" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
        <tr>
          <td width="28"><img src="../manager/image/home_r14_c3.gif" width="28" height="31"></td>
          <td background="../manager/image/home_r14_c5bg.gif">
            <div align="center"><a href="<%= operID.length() == 0 ? "enter" : "logout" %>.jsp" target="main"><font class="font-man"><b><%= operID.length() == 0 ? "Login" : "Logoff " %></b></font></a></div>
          </td>
          <td width="12"><img src="../manager/image/home_r14_c5.gif" width="12" height="31"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
        <tr>
          <td><img src="../manager/image/home_r10_c2bg.gif" width="170" height="8"></td>
        </tr>
      </table>
      <p>&nbsp;</p>
    </td>
    <td width="11" valign="top" background="../manager/image/home_r4_c3bg.gif"><img src="../manager/image/home_r2_c3.gif" width="11" height="28"></td>
    <td bgcolor="#FFFFFF" valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../manager/image/home_r2_c5.gif" width="551" height="19"></td>
        </tr>
      </table>
      <iframe height="400" width="551" scrolling=yes frameborder=0 src='<%= operID.length()==0?"enter.jsp":"face.html" %>' name="main"></iframe>
    </td>
    <td valign="top" background="../manager/image/home_r5_c6bg.gif" width="9"><img src="../manager/image/home_r2_c6.gif" width="9" height="31"></td>
    <td valign="top" background="../manager/image/home_r2_c7.gif" width="9"><img src="../manager/image/home_r2_c7.gif" width="9" height="31"></td>
  </tr>
</table>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td><img src="../manager/image/home_r16_c1.gif" width="758" height="17"></td>
  </tr>
</table>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center" background="../manager/image/home_r15_c1.gif">
  <tr>
    <td>
      <table width="758" border="0" cellspacing="0" cellpadding="0" align="center" background="../manager/image/home_r15_c1.gif">
    <tr>
     <td width="100%"> <iframe width="741" scrolling=no frameborder=0 src='../manager/bottom.html' name="bottom"></iframe>
     </td>
     </tr>
  </table>
    </td>
  </tr>
</table>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td><img src="../manager/image/home_r19_c1.gif" width="758" height="17"></td>
  </tr>
</table>
<%
 if("1".equals(scPage)&&"1".equals(spscPage)){
%>
 <iframe width=768  name="topbar"   align="center" scrolling=no frameborder=0  height=60 src="../<%=bottomurl%>" ></iframe>
<%}%>
</form>
<iframe scrolling=no frameborder=0 height=0 src='popedom.jsp' name="popedom"></iframe>
</body>
</html>
