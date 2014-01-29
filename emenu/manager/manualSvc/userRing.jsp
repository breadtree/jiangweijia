<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.ringAdm" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<%!
    public String transferString(String str) throws Exception {
        try {
            return (new String(str.getBytes("ISO8859_1"),"ISO8859_1")).trim();
        }
        catch (UnsupportedEncodingException e) {
            throw new Exception (e.getMessage() + "\r\nUnsupported character type!");
        }
    }
    private Vector StrToVector(String str){
	  int index = 0;
	  String  temp = str;
	  String  temp1 ="";
	  Vector ret = new Vector();

	  if (str.length() ==0)
	      return ret;
	  index = str.indexOf("|");
   	  while(index > 0){
	      temp1 = temp.substring(0,index);
		  if(index < temp.length())
		     temp = temp.substring(index+1);
		  ret.addElement(temp1);
		  index = 0;
		  if (temp.length() > 0)
		    index  = temp.indexOf("|");
	  }
	  return ret;
  }
%>

<script src="../../pubfun/JsFun.js"></script>
<html>
<head>
<link href="../style.css" type="text/css" rel="stylesheet">
<title>Personal Ringtone Library Management</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1"  >
<%
String userday = CrbtUtil.getConfig("uservalidday","0");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

 	String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");

    try {
      String   craccount ="";
      String   crid ="";
      String ringidtype = "1";
      if (operID != null && purviewList.get("13-9") != null) {
        boolean flag = false;
        craccount = request.getParameter("craccount") == null ? "" : (String)request.getParameter("craccount");
        if(!"".equals(craccount)){
          manSysPara msp = new manSysPara();
          flag = msp.isAdUser(craccount);
        }

        if(!flag){
	zxyw50.Purview purview = new zxyw50.Purview();
	if(!craccount.equals("")){
            if(!purview.CheckOperatorRight(session,"13-4",craccount)){
            	throw new Exception("You have no right to manage this subsciber!");
            }
         }
             crid = request.getParameter("ringlist") == null ? "" : (String)request.getParameter("ringlist");
             int index1 = crid.indexOf("~");
             if(index1>0){
               ringidtype = crid.substring(0,index1);
               crid=crid.substring(index1+1);
             }
        sysTime = SocketPortocol.getSysTime() + "--";
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        Hashtable hash = new Hashtable();
        Hashtable result = new Hashtable();
        Vector vetRing = new Vector();
        // 如果是单个铃音删除
        Vector useInfo = new Vector();

        if (op.equals("del")) {
             ringAdm ringadm = new ringAdm();
             useInfo = ringadm.getRingUseInfo(craccount,crid,ringidtype);
             // 如果铃音没有被使用,直接删除
             if (useInfo.size() == 0)
                 op = "delend";
        }

        if (op.equals("delend")) {
                //crid = request.getParameter("ringlist") == null ? "" : (String)request.getParameter("ringlist");
             if(!"2".equals(ringidtype))
             {
                hash.put("opcode","01010203");
                hash.put("craccount",craccount);
                hash.put("crid",crid);
                hash.put("ret1","");
                hash.put("opmode","6");
                hash.put("ipaddr",operName);
                hash.put("ringidtype",ringidtype);
                result = SocketPortocol.send(pool,hash);
                sysInfo.add(sysTime + operName + " delete user " + craccount + "'s ringtone " + crid ); //删除用户

              }else{
                ringAdm ringadm = new ringAdm();
                Hashtable hash1 = new Hashtable();
                hash1.put("usernumber",craccount);
                hash1.put("ringgroup",crid);
                hash1.put("ipaddr",request.getRemoteAddr());
                ringadm.delRingGroup(hash1);
                sysInfo.add(sysTime + operName + " delete user " + craccount + "'s ringtone group " + crid ); //删除用户

              }

                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","509");
                map.put("RESULT","1");
                map.put("PARA1",craccount);
                map.put("PARA2",crid);
                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                // zxyw50.Purview purview = new zxyw50.Purview();
                purview.writeLog(map);
                %>
       <script language="JavaScript">
         var  str = "User " + "<%= craccount %>" + " delete ringtone '" + "<%= crid %>'" + " successfully!"//用户    删除铃音  成功
	     alert(str)
      </script>
       <% }
     if(op.equals("del")){
       String ringLabel = request.getParameter("ringLabel") == null ? "" : transferString((String)request.getParameter("ringLabel"));
       crid = request.getParameter("ringlist") == null ? "" : (String)request.getParameter("ringlist");

%>
<script language="javascript">
   function onBack() {
      var fm = document.inputForm;
      fm.op.value ="";
      fm.submit();
   }
</script>
<form name="inputForm" method="post" action="userRing.jsp">
<input type="hidden" name="ringlist" value="<%= crid %>">
<input type="hidden" name="craccount" value="<%= craccount %>">
<input type="hidden" name="op" value="delend">
<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
 <tr >
          <td height="26"  align="center" class="text-title" background="../image/n-9.gif"><%= craccount %>--Delete ringtone(group)</td>
</tr>
 <tr >
          <td height="10"  align="center" class="text-title" >&nbsp;</td>
</tr>
<tr>
     <td valign="top" bgcolor="#FFFFFF">
     <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
     <tr valign="top">
     <td width="100%">
          <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="table-style2">
          <tr><td colspan="2" height=30 >Ringtone (group) name:<font class="font" ><%= ringLabel %></font></td></tr>
          <tr><td colspan="2" height=30 >Ringtone (group) code:<font class="font" ><%= crid.indexOf("~")==-1?crid:crid.substring(crid.indexOf("~")+1)  %></font></td></tr>
          <tr><td colspan="2" height=30 >Current usage status:</td></tr>
          <%
               for (int i = 0; i < useInfo.size(); i++) {
          %>
           <tr><td colspan="2" style="color: #FF0000" >&nbsp;&nbsp;<%= i+1 %>. <%= (String)useInfo.get(i) %></td></tr>
           <%
            }
           %>
           <tr>
           <td colspan="2"><br> </td>
           </tr>
           <tr>
           <td width="50%" align="center"><img src="../../button/sure.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:document.inputForm.submit()"></td>
		   <td width="50%" align="center"><img src="../../button/cancel1.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:document.inputForm.op.value='';document.inputForm.submit()"></td>
           </tr>
           </table>

      </td>
      </tr>
      <tr valign="top">
      <td width="100%">
          <table width="100%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
          <tr>
          <td class="table-styleshow" background="../image/n-9.gif" height="26">
          Warning Info:</td>
            </tr>
            <tr>
              <td>1.All relevant information will be lost if you delete the select ringtone (group);</td>
            </tr>
            <tr>
              <td>2.Click "Ok" to delete the selected ringtone (group) and all its relevant information;</td>
            </tr>
            <tr>
              <td>3.Click "Cancel" to give up and return.</td>
            </tr>
            </table>
	</td>
    </tr>
    </table>
</td>
</tr>
</table>
</form>

<%
       }
       else
       if(op.equals("delall")){
             String ringid = request.getParameter("ringlist") == null ? "" : transferString((String)request.getParameter("ringlist")).trim();
             vetRing = StrToVector(ringid);
%>
<script language="javascript">
   function onBack() {
      var fm = document.inputForm;
      fm.op.value ="";
      fm.submit();
   }
</script>
<form name="inputForm" method="post" action="userRing.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="craccount" value="<%= craccount %>">
<table width="346"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
 <tr>
    <td><img src="../image/004.gif" width="346" height="15"></td>
 </tr>
 <tr >
    <td background="../../manager/image/006.gif">
    <table width="340" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
    <tr>
        <td colspan=2>&nbsp;</td>
    </tr>
    <tr>
    <td align="center" colspan=2 class="text-title"> <%= craccount  %>Delete ringtones (groups) in ringtone library</td>
   </tr>
   <tr>
   <td align="center" colspan=2>
      <table width="98%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
      <tr class="tr-ringlist">
        <td width="20%" align="center">Ringtone No.</td>
        <td width="20%" align="center">Execution result</td>
        <td width="60%" align="center">Failure cause</td>
      </tr>
      <%
         ArrayList  rList = new ArrayList();
         Hashtable stmp =  null;
         //zxyw50.Purview purview = new zxyw50.Purview();
         for(int i=0;i<vetRing.size();i++){
           crid = vetRing.get(i).toString();
             int index = crid.indexOf("~");
             if(index>0){
               ringidtype = crid.substring(0,index);
               crid=crid.substring(index+1);
             }
           String  ret = "Success";
           String reason ="";
           try{
             if(!"2".equals(ringidtype))
             {
                hash.put("opcode","01010203");
                hash.put("craccount",craccount);
                hash.put("crid",crid);
                hash.put("ret1","");
                hash.put("opmode","6");
                hash.put("ipaddr",operName);
                hash.put("ringidtype",ringidtype);
                result = SocketPortocol.send(pool,hash);
                sysInfo.add(sysTime + operName + " delete user " + craccount + "'s ringtone " + crid );//删除用户  铃音
              }else{
                ringAdm ringadm = new ringAdm();
                Hashtable hash1 = new Hashtable();
                hash1.put("usernumber",craccount);
                hash1.put("ringgroup",crid);
                hash1.put("ipaddr",request.getRemoteAddr());
                ringadm.delRingGroup(hash1);
                sysInfo.add(sysTime + operName + " delete user " + craccount + "'s ringtone group " + crid );//删除用户  铃音
                }
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","509");
                map.put("RESULT","1");
                map.put("PARA1",craccount);
                map.put("PARA2",crid);
                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
             }catch(Exception ex){
               ret = "Failure";
               reason = ex.getMessage();
             }
             String color = i == 0 ? "E6ECFF" :"#FFFFFF" ;
             out.print("<tr bgcolor='"+color+"'>");
             out.print("<td align='center'>"+crid+"</td>");
             out.print("<td align='center'>"+ret+"</td>");
             out.print("<td >"+reason+"</td>");
             out.print("</tr>");

        }
      %>


      </table>
      <tr>
      <td align="center" colspan=2>
          <img src="../button/back.gif" onmouseover="this.style.cursor='hand'" onclick="Javascript:onBack()">
      </td>
      </tr>
  </table>
  <tr>
     <td><img src="../image/005.gif" width="346" height="15"></td>
  </tr>
 </table>
</form>
<%
      }else{
        String desc = "No ringtone in the " +  craccount  + " ringtone library. Please purchase some!";//用户   铃音库中无铃音记录,请订购铃音!
        if(!craccount.equals("")){
           ColorRing colorring = new ColorRing();
           if(!colorring.searchUser(craccount))
             desc = "User " +  craccount  + " does not exist or has been deleted. Please re-enter a user number and query!";//用户   不存在或已销户,请重新输入User number进行查询!

//           hash.put("opcode","01010301");
//           hash.put("craccount",craccount);
//           hash.put("ret1","");
//           result = SocketPortocol.send(pool,hash);
            userAdm adm = new userAdm();
            result = adm.queryPersonalRing(craccount);

           vetRing = (Vector)result.get("data");
        }
%>
<script language="javascript">
   var v_ringid = new Array(<%= vetRing.size() + "" %>);
   var v_ringidtype = new Array(<%= vetRing.size() + "" %>);
<%
            for (int i = 0; i < vetRing.size(); i++) {
                hash = (Hashtable)vetRing.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("crid") %>';
   v_ringidtype[<%= i + "" %>] = '<%= (String)hash.get("ringidtype") %>';
<%
            }
%>
   function tryListen (ringID,ringName,ringAuthor,ringflag,mediatype) {
     if(ringID.substring(0,2)=='99'){
         alert("Sorry, ringtone group cannot be listened!");
         return;
      }
       if(ringflag=='3'){
        alert("Sorry, <%=musicbox%> cannot be listened!");
        return;
      }
      var tryURL = '../tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor + "&usernumber="+"<%= craccount %>"+'&mediatype='+mediatype;
      if(trim(mediatype)=='1'){
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='4'){
        tryURL = '../tryView.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor + "&usernumber="+"<%= craccount %>"+'&mediatype='+mediatype;
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }

   }

   function searchRing () {
      fm = document.inputForm;
      var value = trim(fm.craccount.value);
      if (!isUserNumber(value,'The subscriber number ')) {
         fm.craccount.focus();
         return;
      }
      fm.op.value = "";
      fm.submit();
   }
   function onCraccountPress(evn) {
    var   charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
    if (charCode == 13){
       document.forms[0].craccount.blur();
       searchRing();
       return;
     }
     return;
   }

   function ringInfo (ringid,ringflag,ispersonalring) {
      fm = document.inputForm;
      if(ringflag=='3'){
         infoWin = window.open('ringinfo.jsp?usernumber=<%= craccount %>&ringid='+ringid+'&ringtype='+3,'infoWin','width=400, height=220,top='+((screen.height-330)/2)+',left='+((screen.width-400)/2));
         return;
     }
      if(ringid.substring(0,2)=='99'){
         alert("Sorry,you can not view the information of ringtone group!");
         return;
      }
      if(ispersonalring=='1'){
        infoWin = window.open('../../ringinfo.jsp?pagecaller=man&usernumber=<%= craccount %>&ringid='+ringid+'&ringtype='+3,'infoWin','width=400, height=338,top='+((screen.height-330)/2)+',left='+((screen.width-400)/2));
      }else{
     	infoWin = window.open('../../ringinfo.jsp?pagecaller=man&usernumber=<%= craccount %>&ringid=' + ringid,'infoWin','width=400, height=338,top='+((screen.height-330)/2)+',left='+((screen.width-400)/2));
   		}
    }


   function oncheckbox(sender,ringid){
       var fm = document.inputForm;
       var ringlist = fm.ringlist.value;
       var ringvalue = "";
       if(sender.checked){
           fm.ringlist.value = ringlist + ringid  + "|";
           return;
       }
       var idd = ringlist.indexOf("|");
	   while( idd > 0){
	      if(ringlist.substring(0,idd)==ringid){
	         ringvalue = ringvalue + ringlist.substring(idd+1);
	         break;
	      }
	      ringvalue = ringvalue +  ringlist.substring(0,idd) + '|';
	      ringlist = ringlist.substring(idd + 1);
	      idd =-1;
	      if(ringlist.length>1)
	         idd  = ringlist.indexOf("|");
	   }
           fm.selectall.checked = false;
	   fm.ringlist.value = ringvalue;
	   return;
   }

    function onSelectAll(){
      var fm = document.inputForm;
      var ringlist = "";
      if(fm.selectall.checked){
         for(var i=0;i<v_ringid.length; i++){
            eval('document.inputForm.crbt'+v_ringid[i]).checked = true;
            ringlist = ringlist +v_ringidtype[i]+"~"+v_ringid[i] + '|';
         }
      }
      else {
          for(var i=0;i<v_ringid.length; i++)
            eval('document.inputForm.crbt'+v_ringid[i]).checked = false;
      }
      fm.ringlist.value = ringlist;
      return;
   }
   function delRing (ringid,ringlabel) {
     fm = document.inputForm;
     var str = ringid ;
     if(str.indexOf("~")>0)
        str = str.substring(str.indexOf("~")+1);
     if(!confirm("Ringtone name: "+ringlabel + "\nRingtone code:" +  str+"\n " + "Are you sure user "+ "<%= craccount %>" + " delete the ringtone?" ))
         return;
     fm.ringlist.value = ringid;
     fm.ringLabel.value = ringlabel;
     fm.op.value = "del";
     fm.submit();
   }

   function delAll () {
     fm = document.inputForm;
     if(fm.ringlist.value==''){
        alert("Please select the ringtone you wish to delete!");//请选择您要删除的铃音
        return;
     }
     fm.op.value = "delall";
     fm.submit();
   }
</script>
<script language="JavaScript">
	var hei=750;
	if(parent.frames.length>0)
	parent.document.all.main.style.height=hei;
</script>
<form name="inputForm" method="post" action="userRing.jsp">
<input type="hidden" name="op" value="" >
<input type="hidden" name="ringlist" value="">
<input type="hidden" name="ringLabel" value="">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr >
         <td height="26"  align="center" class="text-title" background="../image/n-9.gif"><%= craccount.equals("")?"Ringtone library management":craccount+"--Ringtone library management" %></td>
 </tr>
 <tr >
         <td height="20"  align="center" class="text-title">&nbsp;</td>
 </tr>
<tr>
    <td width="100%">
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width=100%>
        <tr>
		  <td>
            Please enter the user number
            <input type="text" name="craccount" value="<%= craccount %>" maxlength="20" class="input-style7" onKeyPress="return onCraccountPress(event)" >&nbsp;&nbsp;
           <img src="../button/search.gif" alt="Find ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
        </tr>
        <tr>
          <td >&nbsp;
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td width="100%" align="center">
      <table width=100% border="0" cellspacing="1" cellpadding="1" align="center" class="table-style4">
         <tr class="tr-ringlist">
                <td height="30" width="40">
                <div align="center" ><font color="#FFFFFF"><span title="Select Flag">Flag</span></font></div></td>
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone code">Code</span></font></div>
                  </td>
                  <td height="30">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone name">Name</span></font></div>
                  </td>
                  <td height="30">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone type">Type</span></font></div>
                  </td>
                   <td height="30" >
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone singer">Singer</span></font></div>
                  </td>
                  <td height="30">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone provider">Provider</span></font></div>
                  </td>
                   <%if(userday.equalsIgnoreCase("1"))
                    {%>
                                      <td height="30">
                    <div align="center"><font color="#FFFFFF"><span title="Subscriber validity">Validity</span></font></div>
                  </td>
                 <%} %>
		        <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="Listen ringtone">Listen</span></font></div>
                </td>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="Ringtone Info.">Info</span></font></div>
                </td>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="Delete">Delete</span></font></div>
                </td>
              </tr>

<%
        int count = vetRing.size();
        for (int i =0; i < count; i++) {
          hash = (Hashtable) vetRing.get(i);
          String strRing = (String)hash.get("crid");
          String ringidtype1 = (String)hash.get("ringidtype");
          String ispersonalring = (String)hash.get("ispersonalring");
          String  ringtype = "ringtone";
          int     ringflag =1;
          if("3".equals(ringidtype1)){
              //ringtype = "music box";
              ringtype = musicbox;
              ringflag = 3;
          }else if("2".equals(ringidtype1)){
              ringtype = "ringtone group";
              ringflag = 2;
         }
         String strPhoto="../../image/play.gif";
                  String strMediatype=(String)hash.get("mediatype");
                  if("2".equals(strMediatype))
                  {
                    strPhoto="../../image/play1.gif";
                  }
                  else if("4".equals(strMediatype))
                  {
                    strPhoto="../../image/play2.gif";
                  }
                  else
                  {
                    strPhoto="../../image/play.gif";
                  }


%>
        <tr bgcolor="<%= i % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td align="center"> <input type='checkbox' name='<%= "crbt"+(String)hash.get("crid") %>'  onclick=oncheckbox(this,'<%= ringflag+"~"+(String)hash.get("crid") %>') > </td>
        <td height="20"><%= strRing %></td>
        <td height="20"><%= (String)hash.get("filename") %></td>
        <td height="20" align="center" ><%= ringtype %></td>
        <td height="20"><%= (String)hash.get("author") %></td>
        <td height="20"><%= (String)hash.get("supplier") %></td>
         <%if(userday.equalsIgnoreCase("1"))
          {%>
        <td height="20"><%= (String)hash.get("validdate") %></td>
        <%}%>
        <td height="20">
          <div align="center"><font class="font-ring""><img src="<%=strPhoto%>"  height='15'  width='15' alt="Pre-listen this ringtone" onmouseover="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("crid") %>','<%= (String)hash.get("filename") %>','<%= (String)hash.get("author") %>','<%=ringflag%>','<%= (String)hash.get("mediatype") %>')"></font></div></td>
        <td height="20">
          <div align="center"><font class="font-ring"><img src="../../image/info.gif"   height='15'  width='15' alt="Details" onmouseover="this.style.cursor='hand'" onclick="javascript:ringInfo('<%= (String)hash.get("crid") %>','<%=ringflag%>','<%=ispersonalring%>')"></font></div></td>
        <td height="20">
          <div align="center"><font class="font-ring"><img src="../../image/delete.gif" height='15'  width='15' alt="Delete" onMouseOver="this.style.cursor='hand'" onclick="javascript:delRing('<%= ringflag+"~"+(String)hash.get("crid") %>','<%= (String)hash.get("filename") %>')"></font></div></td>
        </tr>
   <% }
    if(!craccount.equals("")&& count==0){
    %>
    <tr align="center" bgcolor="FFFFFF" ><td colspan=9 height="23" style="color: #FF0000" ><%= desc %></td></tr>

    <%}
      if(count>0){
    %>
    <tr >
    <td colspan=9 >
        <table width=100% border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
        <tr>
           <td width="50%" align="center" ><input type='checkbox' name='selectall'  onclick="javascript:onSelectAll()">Select All </td>
           <td width="50%" align="center"><img src="../button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delAll()"></td>
        </tr>
        </table>
    </td>
    </tr>

     <% } %>
       </table>
 </td>
 </tr>
</table>
</form>
<%
          }
         } else {
%>
              <script language="javascript">
                   var str = 'Sorry! the number ' +<%= craccount %>+' you entered is ad subscriber,can not use the system!';
                   alert(str);
                   document.URL = 'userRing.jsp';
              </script>
<%
            }
        }
        else {
          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    parent.document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
              </script>
              <%
              }
         }
    }
   catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + "Exception occurred during ringtone library management!");//用户铃音库管理过程出现异常
        sysInfo.add(sysTime + e.toString());
        vet.add("Error occurred during ringtone library management!");//用户铃音库管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/userRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
