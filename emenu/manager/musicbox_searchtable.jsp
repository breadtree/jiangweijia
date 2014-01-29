<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

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

   function tryListen (ringID,ringName,ringAuthor) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }

   function ringInfo (ringid, grouplabel, spindex) {
      document.URL ='sysringgrpdetail.jsp?grouptype=1&groupid=' + ringid + '&grouplabel=' + grouplabel + '&spindex='+spindex;
   }

</script>

    <%
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
    String manageModSysRingGrpPrice =(String)application.getAttribute("manageModSysRingGrpPrice")==null?"0":(String)application.getAttribute("manageModSysRingGrpPrice");
    if(ringdisplay.equals(""))  ringdisplay = "ringtone";
    String userNumber = (String)session.getAttribute("USERNUMBER");
    int pages = vet.size()/records;
    if(vet.size()%records>0)
         pages = pages + 1;
    int  RINGNAME_LENGTH = 20;
    if(userNumber == null)
       RINGNAME_LENGTH = 24;

    String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
    String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");
    %>
    <table width="98%" border="0" cellpadding="1" cellspacing="1" class="table-style4" align="center" >
    <tr class="tr-ringlist">
        <td height="30" width="70">
          <div align="center"><font color="#FFFFFF"><span title="Number of <%=musicbox%>">Code</span></font></div>
        </td>
        <td height="30">
          <div align="center"><font color="#FFFFFF"><span title="Name of <%=musicbox%>">Name</span></font></div>
        </td>
        <td height="30" >
              <div align="center"><font color="#FFFFFF"><span title="Provider of <%=musicbox%>">Provider</span></font></div>
        </td>
        <td height="30" width="60">
              <div align="center"><font color="#FFFFFF"><span title="Period of validity">Validity</span></font></div>
        </td>
        <td height="30" width="60">
              <div align="center"><font color="#FFFFFF"><span title="Update time">Update</span></font></div>
        </td>

        <td height="30" width="40">
              <div align="center"><font color="#FFFFFF"><span title="Price of this <%=musicbox%>">Price(<%=majorcurrency%>)</span></font></div>
        </td>

        <%	if(manageModSysRingGrpPrice.equals("1")){%>
        <td height="30" width="40" style="display:none">
              <div align="center"><font color="#FFFFFF"><span title="Edit this <%=musicbox%>">Edit</span></font></div>
        </td>
        <%}%>

        <td height="30" width="20" style="display:none">
        <div align="center"><font color="#FFFFFF"><span title="Delete this <%=musicbox%>">Delete</span></font></div>
        </td>
        <td height="30" width="40" style="display:none">
              <div align="center"><font color="#FFFFFF"><span title="<%=musicbox%> Info.">Info.</span></font></div>
        </td>
        <td height="30" width="20" style="display:none">
        <div align="center"><font color="#FFFFFF"><span title="Hide or Resume <%=musicbox%> ">Hide/<br>Resume</span></font></div>
        </td>
        <td height="30" width="20" style="display:none">
        <div align="center"><font color="#FFFFFF"><span title="Display or not in user's website">Show</span></font></div>
        </td>
        <td height="30" width="20" >
                  <div align="center"><font color="#FFFFFF">Confirm</font></div>
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
       <td height="20"><%= displayRingAuthor((String)hash.get("spname")) %></td>
       <td height="20"><%= (String)hash.get("validdate") %></td>
       <%
          String modifytime=((String)hash.get("modifytime")).trim();
          String addtime=((String)hash.get("addtime")).trim();
          String deletetime=((String)hash.get("deletetime")).trim();
          if(modifytime.compareTo(addtime)<0)modifytime=addtime;
          if(modifytime.compareTo(deletetime)<0)modifytime=deletetime;
       %>
       <td height="20"><%= modifytime %></td>

       <td height="20" align="center"><%= displayFee((String)hash.get("ringfee")) %></td>
<%	if(manageModSysRingGrpPrice.equals("1")){%>
       <td height="20" align="center" style="display:none"><img src="../image/edit.gif" alt="Edit" onMouseOver="this.style.cursor='hand'" onclick="javascript:edit('<%=(String)hash.get("ringid")%>','<%=(String)hash.get("ringfee")%>','<%= (String)hash.get("validdate") %>')"></td>
<%}%>
       <td height="20" align="center" style="display:none"><img src="../image/delete.gif" alt="Delete" onMouseOver="this.style.cursor='hand'" onclick="javascript:delRing('<%= (String)hash.get("ringid") %>')" ></td>
       <td height="20" align="center" style="display:none"><img src="../image/info.gif" alt="Find music box detail info." onmouseover="this.style.cursor='hand'" onclick="javascript:ringInfo('<%= (String)hash.get("ringid") %>',
         '<%= (String)hash.get("ringname")%>', '<%= (String)hash.get("spindex") %>')" ></td>
       <td height="20" align="center" style="display:none"><img src="../image/hfyc.gif" alt="Hide/Resume" onMouseOver="this.style.cursor='hand'" onclick="javascript:hide('<%=(String)hash.get("ringid")%>','<%=(String)hash.get("isshow")%>')"></td>
       <td height="20" align="center" style="display:none"><%=((String)hash.get("isshow")).trim().equals("1")?"Yes":"No"%></td>

       <td height="20" align="center">
          <img src="../image/icon_search.gif" alt="Select" onmouseover="this.style.cursor='hand'" onclick="javascript:confirm('<%= (String)hash.get("ringid") %>')"></td>

</tr>
    <% } %>

    </tr>
    </table>


