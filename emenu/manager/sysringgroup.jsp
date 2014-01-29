<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="zxyw50.sysringgrp.*" %>
<%@ page import="zxyw50.SpManage"%>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%  //for daily and monthly price
    int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);



	String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
        String operID = (String)session.getAttribute("OPERID");
	int largessflag = 0;
	if(disLargess.equals("1"))
		largessflag = 1;
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Ringtone System</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
String musicvaliddate = CrbtUtil.getConfig("musicvaliddate","0");
String musicprice = CrbtUtil.getConfig("musicprice","0");
String stylevaliddate="(yyyy.mm.dd)";
    String grouptype = request.getParameter("grouptype") == null ? "1" : (String)request.getParameter("grouptype");
    String jName = (String)application.getAttribute("JNAME");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    if(ringdisplay.equals(""))  ringdisplay = "Ringtone";
    String ifringcommend = (String)application.getAttribute("IFRINGRECOMMEND")==null?"0":(String)application.getAttribute("IFRINGRECOMMEND");
    
    boolean bAuth = (purviewList.get("2-13")==null)?false:true;
    if( bAuth && "2".equals(grouptype))
    {
    	//大礼包需要判断配置文件中ifShowGiftBag,避免直接URL访问大礼包功能
    	String ifShowGiftBag = CrbtUtil.getConfig("ifShowGiftBag","1");
    	if(!"1".equals(ifShowGiftBag))
    		bAuth = false;
    }
    
    
    try {
     if (operID != null && bAuth) {
        String opertype=request.getParameter("opertype") == null ? "" : (String)request.getParameter("opertype");
        if(opertype.equals("edit")){
          String ringgroupid=request.getParameter("ringgroupid") == null ? "0" : (String)request.getParameter("ringgroupid");
          String ringgroupdailyprice = ((request.getParameter("ringgroupdailyprice") == null)||(request.getParameter("ringgroupdailyprice") == "")) ? "0" : (String)request.getParameter("ringgroupdailyprice");
		  String ringgroupmonthlyprice =(( request.getParameter("ringgroupmonthlyprice") == null)||(request.getParameter("ringgroupmonthlyprice") == "")) ? "0" : (String)request.getParameter("ringgroupmonthlyprice");
          String ringgroupvaliddate = request.getParameter("ringgroupvaliddate") == null ? "" : (String)request.getParameter("ringgroupvaliddate");
            if(musicvaliddate.trim().equalsIgnoreCase("1")&&!ringgroupvaliddate.trim().equalsIgnoreCase("")&&"1".equals(grouptype))
            {
             Calendar ca = new GregorianCalendar(Integer.parseInt(ringgroupvaliddate.substring(0,4)),Integer.parseInt(ringgroupvaliddate.substring(5,7))-1,1);
             ringgroupvaliddate = ringgroupvaliddate+"."+ca.getActualMaximum(ca.DAY_OF_MONTH);
            }
          SpManage spM=new SpManage();
          spM.modifyRingGroupPrice(ringgroupid,ringgroupdailyprice,ringgroupmonthlyprice,ringgroupvaliddate);
        }
        if(opertype.equals("hide")){
          String ringgroupid=request.getParameter("grpid") == null ? "" : (String)request.getParameter("grpid");
          String grpisshow=request.getParameter("grpisshow") == null ? "" : (String)request.getParameter("grpisshow");
          SpManage spM=new SpManage();
          spM.modifyRingGroupIsshow(ringgroupid,grpisshow);
        }

        String allIndex = request.getParameter("index") == null ? "" : (String)request.getParameter("index");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        HashMap hash = new HashMap();
        List vet = null;

        if("1".equals(grouptype))//音乐盒
        {
           vet = new SysRingGrpDataGateway().querySysRingGroup(1,-1);
          if(musicvaliddate.trim().equalsIgnoreCase("1"))
             stylevaliddate="(yyyy.mm)";
        }
        else //大礼包
           vet = new SysRingGrpDataGateway().querySysRingGroup(2,-1);
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

  function collection (ringID) {
         document.URL = 'collection.jsp?ringidtype=3&ringid='+ringID+'&url=sysringgroup.jsp&grouptype=<%= grouptype%>&page=<%=  thepage %>';
		 //var colURL = 'collection.jsp?ringid=' + ringID;
         //collectionRing = window.open(colURL,'col','width=400, height=200');
   }

   function largess (ringid) {
      document.URL = 'largess.jsp?ringidtype=3&crid='+ringid+'&url=sysringgroup.jsp&grouptype=<%= grouptype%>&page=<%=  thepage %>';
	  //largessWin = window.open('largess.jsp?crid=' + ringid,'largessWin','width=480, height=250');
   }

   function delRing (ringid) {
     var result =  window.showModalDialog('delRing.jsp?ringidtype=3&ringid=' + ringid,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:250px;dialogWidth:410px");
     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }
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
   function edit(ringgroup,dailyprice,monthlyprice,validdate){
     document.all.item("editid").style.display="";
     document.inputForm.ringgroupid.value=ringgroup;
     if(<%=issupportmultipleprice%> == 1){
	 document.inputForm.ringgroupdailyprice.value=dailyprice;
	 }
     document.inputForm.ringgroupmonthlyprice.value=monthlyprice;
     document.inputForm.ringgroupvaliddate.value=validdate;
     document.inputForm.ringgroupvaliddateOld.value=validdate;
   }
   function hide(ringgroup,isshow)
   {
      var ishow=trim(isshow);
      ishow=ishow=='1'?"0":"1";
      document.inputForm.grpid.value=ringgroup;
       document.inputForm.grpisshow.value=ishow;
     document.inputForm.opertype.value='hide';
     var thispage = parseInt(document.inputForm.page.value);
     toPage(thispage);
   }
   function editInfo(){
          if(document.inputForm.ringgroupid.value==0)
          alert("Please click the edit button to edit the ringtone group!");
      
	 if(!checkstring('0123456789',document.inputForm.ringgroupmonthlyprice.value)){
       //alert("价格只能为整数字符串,请重新输入!");
       alert("Price can only be a digital string ,please re-enter!");
       document.inputForm.ringgroupmonthlyprice.focus();
       return false;
     }
     <%if("1".equalsIgnoreCase(musicprice.trim())){%>
          var vprice = trim(document.inputForm.ringgroupmonthlyprice.value);
          if(vprice%50!=0||vprice==0)
          {
            alert("The price of ringtone group should be a multiple of 50");
            document.inputForm.ringgroupmonthlyprice.focus();
            return;
          }
      <%}%>
         if(<%=issupportmultipleprice%> == 1){
          if(!checkstring('0123456789',document.inputForm.ringgroupdailyprice.value)){
          alert("Price can only be a digital string ,please re-enter!");
          document.inputForm.ringgroupdailyprice.focus();
          return false;
           }
          
          <%if("1".equalsIgnoreCase(musicprice.trim())){%>
          var dprice = trim(document.inputForm.ringgroupdailyprice.value);
          if(dprice%50!=0||dprice==0){
              alert("The price of ringtone group should be a multiple of 50");
            document.inputForm.ringgroupdailyprice.focus();
            return;
          }
        <%}%>
        if(document.inputForm.ringgroupdailyprice.value == '')
        {
        document.inputForm.ringgroupdailyprice.value = 0;
        }  
        if(document.inputForm.ringgroupmonthlyprice.value == '')
        {
        document.inputForm.ringgroupmonthlyprice.value = 0;
     }
        var dprice=parseInt(trim(document.inputForm.ringgroupdailyprice.value),10);
        var mprice =parseInt(trim(document.inputForm.ringgroupmonthlyprice.value),10);
        if(mprice <= dprice){
        alert('Monthly price should be greater than Daily price');
        document.inputForm.ringgroupdailyprice.focus();
            return;
          }
          }
         
   	var validdate = trim(document.inputForm.ringgroupvaliddate.value);
      if(validdate==''){
         // alert('请输入铃音组有效期!');
         alert("Please input the validity period of ringtone group!");
          document.inputForm.ringgroupvaliddate.focus();
          return ;
      }
      <%if(!"1".equals(grouptype) ||"0".equalsIgnoreCase(musicvaliddate.trim())){%>
      //年月日
      if(!checkDate2(validdate)){
        //alert('铃音组有效期输入不正确,格式为年月日(xxxx.xx.xx),请重新输入!');
        alert("Expiry date of ringtone group is invalid,please re-enter the date with the ****.**.** format!");
         document.inputForm.ringgroupvaliddate.focus();
        return ;
      }
      if(checktrue2(validdate)){
       // alert('铃音组有效期不能低于当前时间,请重新输入!');
         alert("Expiry date of ringtone group can not ealier than current time ,please re-enter!");
        document.inputForm.ringgroupvaliddate.focus();
        return ;
      }

      var newset = validdate.substring(0,4) + validdate.substring(5,7) + validdate.substring(8,10);
      var oldset = document.inputForm.ringgroupvaliddateOld.value.substring(0,4) + document.inputForm.ringgroupvaliddateOld.value.substring(5,7) + document.inputForm.ringgroupvaliddateOld.value.substring(8,10);

      if((newset-oldset)<0)
      {
        alert("Expiry date of ringtone group can not shorten,please re-enter!");
        document.inputForm.ringgroupvaliddate.focus();
        return ;
      }
     <%}else{
       %>
      if(!checkDate1(validdate)){
        //alert('铃音组有效期输入不正确,请重新输入!');
        alert("Expiry date of ringtone group is invalid,please re-enter!");
        document.inputForm.ringgroupvaliddate.focus();
        return ;
      }
      if(checktrue1(validdate)){
        //alert('铃音组有效期不能低于当前时间,请重新输入!');
         alert("Expiry date of ringtone group can not ealier than current time ,please re-enter!");
        document.inputForm.ringgroupvaliddate.focus();
        return ;
      }

      var newset = validdate.substring(0,4) + validdate.substring(5,7);
      var oldset = document.inputForm.ringgroupvaliddateOld.value.substring(0,4) + document.inputForm.ringgroupvaliddateOld.value.substring(5,7);

      if((newset-oldset)<0)
      {
        alert("Expiry date of ringtone group can not shorten,please re-enter!");
        document.inputForm.ringgroupvaliddate.focus();
        return ;
      }
     <%}%>
     document.inputForm.opertype.value='edit';
     var thispage = parseInt(document.inputForm.page.value);
     toPage(thispage);
   }


</script>
<form name="inputForm" method="post" action="sysringgroup.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
  <input type="hidden" name="grouptype" value="<%= grouptype %>">
<input type="hidden" name="opertype" value="0">
<input type="hidden" name="grpid" value="">
  <input type="hidden" name="grpisshow" value="">
<input type="hidden" name="ringgroupvaliddateOld" value="">
<table width="525" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">
          <%
         	String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");
    		String giftbag   = CrbtUtil.getConfig("giftname","giftbag");
    	   %>
    	   	
          <%="1".equals(grouptype)?musicbox:giftbag%> management</td>
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
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * records + records >= ringsize ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (ringsize - 1) / records %>)"></td>
        </tr>
        <tr>
          <td colspan="5" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >page&nbsp;</td>
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
<table class="table-style2"  id="editid" style="display:none">
  <tr><td height="15">&nbsp;</td><td>&nbsp;</td></tr>
  <tr>
      <td>Code </td><td colspan="3"><input type="text" name="ringgroupid" readonly value="0" size="15"></td></tr>
   <tr>
    <%if(issupportmultipleprice == 1){%>
      <td>Daily Price(<%=minorcurrency%>)</td><td><input type="text" name="ringgroupdailyprice" value="0" maxlength="9" size="10"></td>
      <%}%>
	  <td> <%if(issupportmultipleprice == 1){%>Monthly <%}%> Price(<%=minorcurrency%>)</td><td><input type="text" name="ringgroupmonthlyprice" value="0" maxlength="9" size="10"></td></tr>
  <tr>
      <td>Validdate<%=stylevaliddate%></td><td colspan="3"><input type="text" name="ringgroupvaliddate" value="" maxlength="10" size="10"></td>
  </tr>
  <tr>
    <td colspan="2" align="center"><img src="../button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
  </tr>
</table>
</form>
<%
     }   else {
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
                   alert( "Sorry,you have no right to access this function!");
              </script>
              <%
               
              }
         }
    }
    catch (Exception e) {
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + " Exception occurred in managing system ringtone group!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Errors occurred in managing system ringtone group!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="sysringgroup.jsp?grouptype=<%=grouptype%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
