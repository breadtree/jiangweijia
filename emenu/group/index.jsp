<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.group.util.Resource" %>

<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="com.zte.socket.imp.manager.PoolManager" %>
<%@ page import="zxyw50.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
   SocketPool pool = PoolManager.getInstance().getPool("Colorring");
   application.setAttribute("SOCKETPOOL",pool);
%>
<html>
<head>
<title></title>

<link href="style.css" type="text/css" rel="stylesheet">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>

<body>
<%
    String f1 = request.getParameter("loginFlag1");
    String f2 = request.getParameter("loginFlag2");

    String operID = "";
    if("1".equals(f1) || "1".equals(f2)){
      operID = (String)session.getAttribute("OPERID")==null?"":(String)session.getAttribute("OPERID");
    }

    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    //add by ge quanmin 2005.08.11
    String grpmode=(String)session.getAttribute("GRPMODE")==null?"2":(String)session.getAttribute("GRPMODE");
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
     //add by wxq 2005.05.26
    //是否允许集团用户进行集团用户分组  "0"不允许；"1"允许,默认为"0"；
    String grpgrouping = (String)CrbtUtil.getConfig("grpgrouping","0");
     //是否使用集团模式功能 add by ge quanmin 3.19
    String usegrpmode = CrbtUtil.getConfig("usegrpmode","0");
    //add by ge quanmin 2005.07.29
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
	if(ringdisplay.equals(""))
          ringdisplay = "ringtone";
    String islnlt = CrbtUtil.getConfig("islnlt","0");
    String easyBFlag = request.getParameter("easyBFlag") == null ? "" : request.getParameter("easyBFlag");
    String isshowpwd = request.getParameter("isshowpwd") == null ? "" : request.getParameter("isshowpwd");

    if(("1".equals(islnlt))&&("1".equals(easyBFlag))){
          String userid = request.getParameter("userid") == null ? "" : request.getParameter("userid");
          String pwd = request.getParameter("password") == null ? "" : request.getParameter("password");
%>
<form name="tempForm" method="post" action="login.jsp">
  <input type="hidden" name="servicekey" value="<%= "pstn51" %>">
  <input type="hidden" name="userid" value="<%=userid%>">
  <input type="hidden" name="password" value="<%=pwd%>">
  <input type="hidden" name="easyBFlag" value="1">
  <input type="hidden" name="islnlt" value="1">
</form>
 <script language="javascript">
                document.tempForm.submit();
  </script>
<%
    }
%>
<script language="javascript">
function userLogin() {
  if (document.inputForm.opername.value == '') {
    //alert('请输入用户名!');
    alert('Please input the user name!');
    return;
  }
  if (document.inputForm.password.value == '') {
    alert('Please input the password!');
    return;
  }
  document.inputForm.submit();
}

//键盘响应函数
function OnKeyPress(evn,Next_ActiveControl,SenderType)
{
  var
  charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
  status = charCode;
  if (charCode == 13)
  {
    Next_ActiveControl.select();
    Next_ActiveControl.focus();
    return false;
  }
  switch (SenderType.toUpperCase())
  {
    case 'int'.toUpperCase():
    if ((charCode < 48) || (charCode > 57)){
      return false;
    }
    break;

    case 'float'.toUpperCase():
    var i = 0;
    if ((charCode != 46) && (charCode < 48) || (charCode > 57)){
      evn.KeyCode = 0;
      return false;
    } else if (charCode == 46){
      if (Sender.value == "")
      return false;
      else{
        for(var i = 0; i < Sender.value.length; i++){
          var sChar = Sender.value.charAt(i);
          if (sChar == '.') return false;
        }
      }
    }
    break;

    case 'date'.toUpperCase():
    if (((charCode < 48) || (charCode > 57)) && (charCode!=45)){
      return false;
    }
    break;
    default:
    break;

  }

  return true;

}

function onPassword(evn) {
  var   charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
  if (charCode == 13){
    document.forms[0].password.blur();
    userLogin();
  }

}


</script>
<script language="javascript">
function isshow(aa){
   var menu="";
   for (var i=1;i<=3;i++)
   {
       menu = window.eval('window.content'+ i)
   	   if (menu.id==aa)
   	   {
   	   	  continue;
   	   }
       menu.style.display ='none';
   }
   	aa= window.eval('window.'+ aa)

	if (aa.style.display=='none')
    {
        aa.style.display="";
    }
	else
    {
        aa.style.display='none';
    }
}

   function refresh () {
      document.URL = 'menu.jsp';
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
<form name="inputForm" method="post" action="login.jsp">
<table width="780" border="0" align="center" cellpadding="0" cellspacing="0" background="image/corpring0bg.gif">
  <tr>
    <td width="423"><img src="image/corpring01.gif" width="423" height="83"></td>
    <td>&nbsp;</td>
  </tr>
</table>
<table width="780" height="34" border="0" align="center" cellpadding="0" cellspacing="0" background="image/index_r2_c2.gif">
  <tr>
     <td width="127">&nbsp;</td>
    <td background="image/index_r2_c2.gif">&nbsp;</td>
  </tr>
</table>
<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="image/index_r14_c4.gif" width="4" height="5"></td>
  </tr>
</table>
<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="tr-ring3">
    <td width="169" valign="top">
    <%if(operID.length() == 0){%>
      <table width="100%" border="0" cellspacing="0" cellpadding="0"  class="tr-ring4"  >
        <tr>
          <td colspan="2">
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="10"><img src="image/corpring021.gif" width="10" height="44"></td>
                <td background="image/corpring022.gif" class="text-corpring">User login</td>
                <td width="10"><img src="image/corpring023.gif" width="10" height="44"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr >
          <td colspan="2"><form name="inputForm" method="post" action="login.jsp">
        <input type="hidden" name="servicekey" value="<%= "pstn51" %>">
        <tr   class="table-style3">
          <td>
            &nbsp;
          </td>
          <td></td>
        </tr>
        <tr   class="table-style3">
          <td>
            <div align="right"><font class="font4">Group user &nbsp;</font> </div>
          </td>
          <td>
            <input name="opername"  class="input-style2" value="" maxlength="20" onKeyPress="return OnKeyPress(event,document.inputForm.password,'')">
          </td>
        </tr>
        <tr   class="table-style3" >
          <td>
            <div align="right"><font class="font4">Password &nbsp;</font> </div>
          </td>
          <td>
            <input type="password" class="input-style2" name="password" value="" maxlength="20" onKeyPress="return onPassword(event)">
          </td>
        </tr>
        <tr  class="table-style3">
          <td colspan="2" >
            <table border="0" width="100%" class="table-style3">
              <tr>
                <td width="50%" align="center"><img src="../button/login.gif" onclick="javascript:userLogin()" onmouseover="this.style.cursor='hand'"></td>
                <td width="50%" align="center">
                  <div align="left"><img src="../button/reset.gif"  onclick="javascript:document.inputForm.reset()" onmouseover="this.style.cursor='hand'"></div>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10"><img src="image/corpring021.gif" width="10" height="44"></td>
              <td background="image/corpring022.gif" class="text-corpring"><a href="../index.jsp"><font color="#FFFFFF">Back to index</font></a></td>
              <td width="10"><img src="image/corpring023.gif" width="10" height="44"></td>
            </tr>
            <tr>
              <td width="10"><img src="image/corpring021.gif" width="10" height="44"></td>
              <td background="image/corpring022.gif" class="text-corpring">Group <%=colorName%> introduce</td>
              <td width="10"><img src="image/corpring023.gif" width="10" height="44"></td>
            </tr>
          </table></td>
        </tr>
        <tr  class="tr-ring3">
          <td height="100"><div align="center"><table width="90%"  border="0" align="center" class="table-style7">
            <tr>
              <td>Show enterprise culture and brand and advertise service philosophy
                </td>
            </tr>
          </table></div></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10"><img src="image/corpring021.gif" width="10" height="44"></td>
              <td background="image/corpring022.gif" class="text-corpring">Charge standard</td>
              <td width="10"><img src="image/corpring023.gif" width="10" height="44"></td>
            </tr>
          </table></td>
        </tr>
        <tr  class="tr-ring3">
          <td height="200"><div align="center"><table width="90%"  border="0" align="center" class="table-style7">
            <tr>
              <td><div align="left"><strong>&gt;Group <%=colorName%>  month function fee</strong>:
                  A nature month is a charge period. If it is less than one month, it is subject to the whole month.Group <%=colorName%> month function fee is paid uniformly by a group unit.Group <%=colorName%> function fee and personal xx month function fee should not be paid at the same time.<br>
                  <strong>&gt;Group  <%=colorName%> information fee</strong>:Group unit uses the group <%=colorName%> fee, Its price is subject to the content provider. It is paid uniformly by the group unit. The carrier collects it.<%=colorName%> Members in the <%=ringdisplay%> group will not pay any information fee.
                  <br>
                  <strong>&gt; <%=colorName%>information fee:</strong><%=colorName%> group<br>
                  Member ordered <%=ringdisplay%>Fee is paid according to personal <%=colorName%> user information fee standard. Each member is responsible for it.<br>
              </div></td>
            </tr>
          </table></div></td>
        </tr>
      </table>
      <%}else{%>
     <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
   <td >
            <div align="left">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0"  onClick="<%= operID.length()==0?"":"javascript:isshow('content1')" %>" onMouseOver="this.style.cursor='hand'">
                <tr>
                  <td width="10"><img src="image/corpring021.gif" width="10" height="44"></td>
                  <td background="image/corpring022.gif" class="text-corpring"><font class="font-man"><b><font color="#FFFFFF"><span title="Group ringtone management">&nbsp;Group ringtone</span></font></b></font>
                  </td>
                  <td width="10"><img src="image/corpring023.gif" width="10" height="44"></td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
               <table id='content1' width="100%" cellspacing="0" cellpadding="0"  class="table-style8 " style="DISPLAY:none">
               <%
                 if(purviewList.get("12-1") != null){
               %>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/../manager/folder/lastblk.gif" width="16" height="16"><a href="ringUpload.jsp" target="main"><font class="font" onclick="f_changeColor('td1201')" id="td1201"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group ringtone upload">&nbsp;Ringtone upload</span></font></a></td>
                               </tr>
               <%
                       }if(purviewList.get("12-2") != null){
               %>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="editRing.jsp" target="main"><font class="font" onclick="f_changeColor('td1202')" id="td1202"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group ringtone edit">&nbsp;Ringtone edit</span></font></a></td>
                               </tr>
                <%
                       }if(purviewList.get("12-3") != null&&(Resource.getInstance().getConfig("grpprering","0").trim().equals("1"))){
               %>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="preRing.jsp" target="main"><font class="font" onclick="f_changeColor('td1203')" id="td1203"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group guidance ringtone setting">&nbsp;Guidance set</span></font></a></td>
                               </tr>
                <%
                       }
                       if("1".equals(usegrpmode)){
                       if(purviewList.get("12-4") != null&&grpmode.equals("2")){
               %>
                             <tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="callingTime.jsp" target="main"><font class="font" onclick="f_changeColor('td1204')" id="td1204"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group time period ringtone setting">&nbsp;Time period</span></font></a></td>
                             </tr>
                <%
                       }
                     }else{
                       if(purviewList.get("12-4") != null){
               %>
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="callingTime.jsp" target="main"><font class="font" onclick="f_changeColor('td1204')" id="td1204"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group time period ringtone setting">&nbsp;Time period</span></font></a></td>
                             </tr>
                <%
                       }
                     }
                       if(purviewList.get("12-5") != null){

               %>		<!--
               				<tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="springReplace.html" target="main"><font class="font"><img src="../image/n-8.gif" width="8" height="8" border="0">Group user time segment ringtone setting </font></a></td>
                               </tr>
                               -->
                <%
                       }
                                //add by wxq 20050602 for version3.16.01
                        if("1".equals(usegrpmode)){
                       if(purviewList.get("12-9") != null&&grpmode.equals("2")){
                                %>
                                <tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="weekCallingTime.jsp" target="main"><font class="font" onclick="f_changeColor('td1209')" id="td1209"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group week period ringtone setting">&nbsp;Week period</span></font></a></td>
                                </tr>
                                <%
                                    }
                       }else{
                       if(purviewList.get("12-9") != null){%>
                         <tr>
                           <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="weekCallingTime.jsp" target="main"><font class="font" onclick="f_changeColor('td1209')" id="td1209"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group week period ringtone setting">&nbsp; Week period</span></font></a></td>
                         </tr>
                       <%
                           }
                            }
                       if("1".equals(usegrpmode)){
                       if(purviewList.get("12-10") != null&&grpmode.equals("2")){
                                %>
                                <tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="monthCallingTime.jsp" target="main"><font class="font" onclick="f_changeColor('td1210')" id="td1210"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group month period ringtone setting">&nbsp;Month period</span></font></a></td>                                </tr>
                                </tr>
                                <%
                                    }
                                  }else{
                                   if(purviewList.get("12-10") != null){%>
                                    <tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="monthCallingTime.jsp" target="main"><font class="font" onclick="f_changeColor('td1210')" id="td1210"><img src="../image/n-8.gif" width="8" height="8" border="0"> <span title="Group month period ringtone setting">&nbsp;Month period</span></font></a></td>                                </tr>
                                </tr>
                                   <%}

                                  }
                                if (purviewList.get("12-13") != null){
                                %>
                                <!--end-->
             <!--add by ge quanmin 2005-07-05 -->
                                 <tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="grpringgroup.jsp" target="main"><font class="font" onclick="f_changeColor('td1213')" id="td1213"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group ringtone group management">&nbsp;Group management</span> </font></a></td>                                </tr>
                                </tr>
                                <%}
                                if (purviewList.get("12-14") != null){
                                %>
                                 <tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="checkRing.jsp" target="main"><font class="font" onclick="f_changeColor('td1214')" id="td1214"><img src="../image/n-8.gif" width="8" height="8" border="0"> <span title="Group ringtone to be audited">&nbsp;Audited ringtone</span></font></a></td>                                </tr>
                                </tr>
                              <%}%>
              </table>
            </div>
          </td>
        </tr>
      </table>


       <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
          <td >
            <div align="left">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0"  onClick="<%= operID.length()==0?"":"javascript:isshow('content3')" %>" onMouseOver="this.style.cursor='hand'">
                <tr>
                  <td width="10"><img src="image/corpring021.gif" width="10" height="44"></td>
                  <td background="image/corpring022.gif" class="text-corpring"><font class="font-man"><b><font color="#FFFFFF"><span title="Group user management">Group user</span></font></b></font>
                  </td>
                  <td width="10"><img src="image/corpring023.gif" width="10" height="44"></td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
               <table id='content3' width="100%" cellspacing="0" cellpadding="0"  class="table-style8 " style="DISPLAY:none">
                  <%if("1".equals(usegrpmode)){
                       if(purviewList.get("12-11") != null&&grpmode.equals("2")){
                                %>
                                <tr <%=  grpgrouping.equals("1") ? "" : "style=\"display:none\""%>>
                                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/../manager/folder/lastblk.gif" width="16" height="16"><a href="grpGrouping.jsp" target="main"><font class="font" onclick="f_changeColor('td1211')" id="td1211"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group grouping management">&nbsp;Grouping manage</span></font></a></td>
                                </tr>
                                <%
                                    }
                       }else{
                       if(purviewList.get("12-11") != null){%>
                         <tr <%=  grpgrouping.equals("1") ? "" : "style=\"display:none\""%>>
                                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/../manager/folder/lastblk.gif" width="16" height="16"><a href="grpGrouping.jsp" target="main"><font class="font" onclick="f_changeColor('td1211')" id="td1211"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group grouping management">&nbsp;Grouping manage</span></font></a></td>
                         </tr>
                       <%
                           }
                            } if (purviewList.get("12-15") != null){
                                %>
                                 <tr>
                                 <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="useractive.jsp" target="main"><font class="font" onclick="f_changeColor('td1215')" id="td1215"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group user activate/suspend">&nbsp;Activate/suspend</span></font></a></td>                                </tr>
                                </tr>
                         <% }if(purviewList.get("12-16") != null){%>
                                 <tr>
                              <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="grpAccount.jsp" target="main"><font class="font" onclick="f_changeColor('td1216')" id="td1216"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group user Add">&nbsp;User Add</span></font></a></td>                                </tr>
                                </tr>
                         <%}if(purviewList.get("12-17") != null){%>
                                <tr>
                              <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="grpCanncel.jsp" target="main"><font class="font" onclick="f_changeColor('td1217')" id="td1217"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group user exit">&nbsp;User exit</span></font></a></td>                                </tr>
                                </tr>
                             <% }%>

              </table>

            </div>
          </td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
          <td>
            <div align="center">
              <table width="100%" border="0" cellspacing="0" cellpadding="0"  onClick="<%= operID.length()==0?"":"javascript:isshow('content2')" %>" onMouseOver="this.style.cursor='hand'">
                <tr>
       <td width="10"><img src="image/corpring021.gif" width="10" height="44"></td>
                  <td background="image/corpring022.gif" class="text-corpring"><font class="font-man"><b><font color="#FFFFFF"><span title="Group query/stat.">Group query</span></font></b></font>
                  </td>
                  <td width="10"><img src="image/corpring023.gif" width="10" height="44"></td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
              <table id='content2' width="100%" cellspacing="0" cellpadding="0" class="table-style8"  style="DISPLAY:none">
<%
if (purviewList.get("12-6") != null ||purviewList.get("12-7") != null||purviewList.get("12-8") != null ) {
%>
				<tr>
                    <td width="100%">&nbsp;</td>
                </tr>
                <%}
        if (purviewList.get("12-6") != null) {
%>
                <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/midblk.gif"><a href="grpInfo.jsp" target="main"><font class="font" onclick="f_changeColor('td1206')" id="td1206"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group configuration information">&nbsp;Config Info.</span></font></a></td>
                </tr>
                <%
        }
        if (purviewList.get("12-7") != null) {
%>
                <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="grpSysStat.jsp" target="main"><font class="font" onclick="f_changeColor('td1207')" id="td1207"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group real time user number query">&nbsp;Real time user</span></font></a></td>
                </tr>
                <%
        }
          if (purviewList.get("12-8") != null) {
%>
                <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="grpDetailStat.jsp" target="main"><font class="font" onclick="f_changeColor('td1208')" id="td1208"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group detail query Stat.">&nbsp;Detail query</span></font></a></td>
                </tr>
                <%
        }
if (purviewList.get("12-12") != null){
%>

                <tr>
<td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/lastblk.gif"><a href="grpMemberDetailStat.jsp" target="main"><font class="font" onclick="f_changeColor('td1212')" id="td1212"><img src="../image/n-8.gif" width="8" height="8" border="0"><span title="Group member detail query Stat.">&nbsp;Member query</span></font></a></td>
   </tr>
<%
        }
%>
                <tr>
                  <td width="100%">&nbsp;</td>
                </tr>

              </table>

            </div>
 </td>
        </tr>
      </table>





 <%
    if(operID.length() != 0 && !"1".equals(isshowpwd) ){
%>
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="10"><img src="image/corpring021.gif" width="10" height="44"></td>
          <td background="image/corpring022.gif" class="text-corpring"><a href="changePassword.jsp" target="main"><font  color="#FFFFFF"><b>Operator password modify</b></font></a></td>
          <td width="10"><img src="image/corpring023.gif" width="10" height="44"></td>
        </tr>
      </table>
     <%
      }
	if(operID.length() != 0 && purviewList.get("12-5") != null ){
    %>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
      </table>
  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="10"><img src="image/corpring021.gif" width="10" height="44"></td>
          <td background="image/corpring022.gif" class="text-corpring"><a href="../manager/purview/operLog.jsp?operflag=2" target="main"><font  color="#FFFFFF"><b>Group operator log</b></font></a></td>
          <td width="10"><img src="image/corpring023.gif" width="10" height="44"></td>
        </tr>
      </table>
<%
	}
%>
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
      <td width="10"><img src="image/corpring021.gif" width="10" height="44"></td>
          <td background="image/corpring022.gif" class="text-corpring"><a href="<%= operID.length() == 0 ? "enter" : "logout" %>.jsp" target="main"><font  color="#FFFFFF"><b><%= operID.length() == 0 ? "" : "Exit" %><font color="#FFFFFF"></font></b></font></a></td>
          <td width="10"><img src="image/corpring023.gif" width="10" height="44"></td>
        </tr>
      </table>
      <%}%>
    </td>
    <td valign="top"><img src="image/index_r14_c4.gif" width="4" height="5"></td>
     <td valign="top" width="607"><iframe height=610 width=607 scrolling=no frameborder=0 src='main.jsp' name="main"></iframe></td>
  </tr>
</table>
<div align="center"><table width="780" height="64" border="0" align="center" cellpadding="0" cellspacing="0" background="image/index_r35_c2.gif">
  <tr>
    <td>
      <iframe width="780" scrolling=no frameborder=0 src='bottom.html' name="bottom"></iframe>
    </td>
  </tr>
</table></div>
</body>
</html>
