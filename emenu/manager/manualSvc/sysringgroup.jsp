<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ include file="../../pubfun/JavaFun.jsp" %>
<%@ page import="zxyw50.sysringgrp.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
	String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
	int largessflag = 0;
	if(disLargess.equals("1"))
		largessflag = 1;
%>
<script src="../../pubfun/JsFun.js"></script>
<html>
<head>
<link href="../style.css" type="text/css" rel="stylesheet">
<title>Ringtone of system</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String grouptype = request.getParameter("grouptype") == null ? "1" : (String)request.getParameter("grouptype");
    String jName = (String)application.getAttribute("JNAME");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String sysTime = "";
    String operID = (String)session.getAttribute("OPERID");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
    if(ringdisplay.equals(""))  ringdisplay = "ringtone";
    String ifringcommend = (String)application.getAttribute("IFRINGRECOMMEND")==null?"0":(String)application.getAttribute("IFRINGRECOMMEND");
    
    boolean bAuth = (purviewList.get("13-15")==null)?false:true;
    if( bAuth && "2".equals(grouptype))
    {
    	//大礼包需要判断配置文件中ifShowGiftBag,避免直接URL访问大礼包功能
    	String ifShowGiftBag = CrbtUtil.getConfig("ifShowGiftBag","1");
    	if(!"1".equals(ifShowGiftBag))
    		bAuth = false;
    }
    
    try {
           if (operID != null &&  bAuth) {
             String allIndex = request.getParameter("index") == null ? "" : (String)request.getParameter("index");
             int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
             HashMap hash = new HashMap();
             List vet = null;
             if("1".equals(grouptype))//音乐盒
             vet = new SysRingGrpDataGateway().querySysRingGroup(1,1);
             else //大礼包
             vet = new SysRingGrpDataGateway().querySysRingGroup(2,1);
//        List vet_tmp=new ArrayList();
//        for(int i=0;i<vet.size();i++){
//          HashMap tmpMap =(HashMap)vet.get(i);
//          String isshow=(String)tmpMap.get("isshow");
//          String ischeck=(String)tmpMap.get("ischeck");
//          if(isshow.equals("1")&&ischeck.equals("2"))
 //           vet_tmp.add(tmpMap);
 //       }
  //      vet=vet_tmp;
             String userNumber = (String)session.getAttribute("USERNUMBER");
             int records = 25;
             int  ringsize = vet.size();
             int pages = ringsize/records;
             if(ringsize%records>0)
             pages = pages + 1;
             %>
             <script language="javascript">

             var currentRingId=null;
             var currentAction=-1//0 collection 1 largess
             function refresh(number){
               parent.refresh(number);
               if(currentAction==0){
                 collection (currentRingId);
               }else if(currentAction==1){
                 largess(currentRingId);
               }
             }

             function searchRing(){
               document.inputForm.page.value=0;
               document.inputForm.submit();
             }

             function collection (ringID,name) {
               var dlgLeft = event.screenX;
               var dlgTop = event.screenY;
               var result =  window.showModalDialog("inputUser.html",window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-315)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:250px;dialogWidth:315px");
               if(result&&result!='false'){
                 document.URL = 'collection.jsp?ringidtype=3&phone='+result+'&ringList='+ringID+'|&ringLabel='+name+'|&url=sysringgroup.jsp?grouptype=<%=grouptype%>'+'&op=addsysring';
               }
             }

             function largess (ringid) {
               document.URL = 'largess.jsp?ringidtype=3&crid='+ringid+'&url=sysringgroup.jsp&grouptype=<%= grouptype%>&page=<%=  thepage %>';
               //largessWin = window.open('largess.jsp?crid=' + ringid,'largessWin','width=480, height=250');
             }

             function toPage (page) {
               document.inputForm.page.value = page;
               document.inputForm.submit();
             }
             function goPage(){
               var fm = document.inputForm;
               var pages = parseInt(fm.pages.value);
               var thepage =parseInt(trim(fm.gopage.value));
               if(thepage==''){
                 alert("Please specify the value of the page to go to!");//Please specify the value of the page to go to!
                 fm.gopage.focus();
                 return;
               }
               if(!checkstring('0123456789',thepage)){
                 alert("The value of the page to go to can only be a digital number!");//The value of the page to go to can only be a digital number
                 fm.gopage.focus();
                 return;
               }
               if(thepage<=0 || thepage>pages ){
                 alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!");//alert("转到的页码值范围不正确  页）!
                 fm.gopage.focus();
                 return;
               }
               thepage = thepage -1;
               toPage(thepage);
             }


             </script>
             <script language="JavaScript">
               var hei=500;
               if(parent.frames.length>0){

                 <%
                 if(vet==null || ringsize<15 || ringsize==15){
                   %>
                   hei = 500;
                   <%
                 }else if(ringsize>15 && ringsize<records){
                   %>
                   hei = 500 + (<%= ringsize%>-15)*30;

                   <%
                 }else{
                   %>
                   hei = 800;

                   <%
                 }
                 %>
                 parent.document.all.main.style.height=hei;
               }

               </script>
               <form name="inputForm" method="post" action="sysringgroup.jsp">
                 <input type="hidden" name="page" value="<%= thepage %>">
                   <input type="hidden" name="pages" value="<%= pages %>">
                     <input type="hidden" name="grouptype" value="<%= grouptype %>">
                       <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                         <tr>
                           <td valign="top" bgcolor="#FFFFFF">
                             <table width="100%" border="0" align="center" class="table-style2">
                               <tr >
                                 <td height="26" colspan="3" align="center" class="text-title" background="../image/n-9.gif">Manage 
                                  <%
         								String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");
    									String giftbag   = CrbtUtil.getConfig("giftname","giftbag");
    	   						  %>
                                 <%="1".equals(grouptype)?musicbox:giftbag%></td>
                               </tr>
                             </table>
</td>
                         </tr>
                         <tr>
                           <td width="100%" class="table-style2">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                         </tr>
                         <tr> <td width="100%">
                           <%
                           request.setAttribute("ringlist",vet);
                           if("1".equals(grouptype))
                           pageContext.include("musicbox_table.jsp");
                           else
                           pageContext.include("giftbox_table.jsp");
                           if (ringsize > records) {
                             %>
                             <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
                               <tr>
                                 <td>&nbsp;<%= ringsize %>&nbsp;enters in total&nbsp;<%= ringsize%records==0?ringsize/records:ringsize/records+1 %>&nbsp;pages&nbsp;&nbsp;You are now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
                                 <td><img src="../../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
                                   <td><img src="../../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
                                     <td><img src="../../button/nextpage.gif"<%= thepage * records + records >= ringsize ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
                                       <td><img src="../../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (ringsize - 1) / records %>)"></td>
                               </tr>
                               <tr>
                                 <td colspan="5" align="right" >
                                   <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
                                     <tr>
                                       <td >Page&nbsp;</td>
                                       <td> <input style=text value="<%= String.valueOf(thepage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
                                         <td ><img src="../../button/go.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:goPage()"  ></td>
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
               </form>
               <%
 }   else {
          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in first!");
                    document.URL = '../enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no right to access this function!");
              </script>
              <%
              }
         }
    }
    catch (Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + "Exception occurred in managing manual music box(gift bag)!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Errors occurred in managing manual music box(gift bag)!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp" >
<input type="hidden" name="historyURL" value="manualSvc/sysringgroup.jsp?grouptype=<%=grouptype%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

