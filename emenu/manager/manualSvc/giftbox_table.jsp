
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../../pubfun/JavaFun.jsp" %>

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

   function tryListen (ringID,ringName,ringAuthor) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }

   function ringInfo (ringid) {
      document.URL ='sysringgrpdetail.jsp?grouptype=2&groupid=' + ringid;
   }

</script>

    <%
     String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	  String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	  String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	  int ratio = Integer.parseInt(currencyratio);    
    
    List vet = (List)request.getAttribute("ringlist");
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
       
    String giftbag   = CrbtUtil.getConfig("giftname","giftbag");   
    %>
    <table width="95%" border="0" cellpadding="1" cellspacing="1" class="table-style4" align="left" >
    <tr class="tr-ringlist">
        <td height="30" width="80">
          <div align="center"><font color="#FFFFFF"><span title="<%=giftbag%> code">Code</span></font></div>
        </td>
        <td height="30">
          <div align="center"><font color="#FFFFFF"><span title="<%=giftbag%> name">Name</span></font></div>
        </td>
        <td height="30" >
              <div align="center"><font color="#FFFFFF"><span title="<%=giftbag%> Provider">Provider</span></font></div>
        </td>
        <td height="30" >
              <div align="center"><font color="#FFFFFF"><span title="Period of validity">Validity</span></font></div>
        </td>
         <td height="30" width="40">
              <div align="center"><font color="#FFFFFF"><span title="The number of ringtone in this <%=giftbag%>">Ringtons</span></font></div>
        </td>
        <td height="30" width="40">
          <div align="center"><font color="#FFFFFF"><span title="Price(<%=majorcurrency%>)">Price(<%=majorcurrency%>)</span></font></div>
        </td>
        <td height="30" width="40">
          <div align="center"><font color="#FFFFFF"><span title="The number of user order this <%=giftbag%>">Order number</span></font></div>
        </td>
        <td height="30" width="20">
        <div align="center"><font color="#FFFFFF"><span title="Order the <%=giftbag%> for user">Order</span></font></div>
        </td>
        <td height="30" width="20">
        <div align="center"><font color="#FFFFFF"><span title="<%=giftbag%> Information">Info.</span></font></div>
        </td>
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
       <td height="20" align="center" ><%= displayRingAuthor((String)hash.get("spname")) %></td>
       <td height="20" align="center" ><%= (String)hash.get("validdate") %></td>
       <td height="20" align="center" ><%= displayRingAuthor((String)hash.get("ringcnt")) %></td>
       <td height="20" align="center"><%= displayFee((String)hash.get("ringfee")) %></td>
       <td height="20" align="center"><%= (String)hash.get("buytimes") %></td>
       <td height="20" align="center"><img src="../../image/buy.gif"  height='15'  width='15' alt="Order <%=giftbag%> to personal <%= ringdisplay %> library" onMouseOver="this.style.cursor='hand'" onclick="javascript:collection('<%=(String)hash.get("ringid")%>','<%= (String)hash.get("ringname") %>')"></td>
       <td height="20" align="center"><img src="../../image/info.gif" height='15'  width='15' alt="View datail of <%=giftbag%>" onmouseover="this.style.cursor='hand'" onclick="javascript:ringInfo('<%= (String)hash.get("ringid") %>')"></td>
    </tr>
    <% } %>

    </tr>
    </table>


