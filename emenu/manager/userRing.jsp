<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Pre-listen subscriber's ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String craccount = (String)request.getParameter("usernumber");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String areacode = (String)application.getAttribute("AREACODE")==null?"1":(String)application.getAttribute("AREACODE");
    // add for starhub
	String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
	try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        Vector vetRing = new Vector();
        Hashtable hash = new Hashtable();
        if (operID != null && purviewList.get("1-2") != null) {
            if (craccount != null) {
                // 查询个人铃音
                zxyw50.Purview purview = new zxyw50.Purview();
            	if(!purview.CheckOperatorRight(session,"1-2",craccount)){
               		throw new Exception("Have no right to this operation!");
            	}
//                hash.put("opcode","01010301");
//                hash.put("craccount",craccount);
//                hash.put("ret1","");
                userAdm adm = new userAdm();
                Hashtable result = adm.queryPersonalRing(craccount);
//                Hashtable result = SocketPortocol.send(pool,hash);
                vetRing = (Vector)result.get("data");
            }

%>
    <script language="javascript">
   //铃音库铃音
   var v_ringlabel = new Array(<%= vetRing.size() + "" %>);
   var v_ringauthor = new Array(<%= vetRing.size() + "" %>);
   var v_ringidtype = new Array(<%= vetRing.size() + "" %>);
   var v_mediatype = new Array(<%= vetRing.size() + "" %>);
<%
            for (int i = 0; i < vetRing.size(); i++) {
                hash = (Hashtable)vetRing.get(i);
%>
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("filename") %>';
   v_ringauthor[<%= i + "" %>] = '<%= (String)hash.get("author") %>';
   v_ringidtype[<%= i + "" %>] = '<%= (String)hash.get("ringidtype") %>';
   v_mediatype[<%= i + "" %>] = '<%= (String)hash.get("mediatype") %>';
<%
            }
%>

   function selectPersonalRing () {
      var fm = document.inputForm;
      var index = fm.personalRing.selectedIndex;
      if (fm.personalRing.value == null) {
         fm.usernumber.focus();
         return;
      }
      if (fm.personalRing.value == '')
         return;
      fm.crid.value = fm.personalRing.value;
      fm.ringname.value   = v_ringlabel[index];
      fm.ringauthor.value = v_ringauthor[index];
      fm.ringidtype.value=v_ringidtype[index];
      fm.mediatype.value=v_mediatype[index];
   }

   function searchRing () {
      fm = document.inputForm;
      var value = trim(fm.usernumber.value);
      if (value == '') {
         alert('Please enter a number first!');//请先输入号码
         fm.usernumber.focus();
         return;
      }
      if (value.length<=5) {
         alert('The subscriber number entered is incorrect. Please re-enter!');//User number输入不正确,请重新输入
         fm.usernumber.focus();
         return;
      }
      fm.submit();
   }

   function tryListen () {
      fm = document.inputForm;
      if (fm.craccount.value == '')
         return;
      if (fm.crid.value == '') {
         alert('Please select a ringtone before pre-listening!');//请先选择铃音,再试听!
         return;
      }
      if(fm.ringidtype.value=='3'){
         alert('Sorry,music box cannot pre-listen!');//对不起,音乐盒不能试听!
         return;
      }
        if(fm.ringidtype.value=='2'){
         alert('Sorry,music group cannot pre-listen!');//对不起,铃音组不能试听!
         return;
      }
      if(fm.crid.value.substring(0,2)=='99'){
         alert("Sorry,music group cannot pre-listen!");//对不起,铃音组不能试听!
         return;
      }
      var tryURL = 'tryListen.jsp?ringid=' + fm.crid.value+'&ringname='+fm.ringname.value+'&ringauthor='+fm.ringauthor.value +"&usernumber="+fm.craccount.value+"&mediatype="+fm.mediatype.value;
      if(trim(fm.mediatype.value)=='1'){
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else  if(trim(fm.mediatype.value)=='2'){
      	preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else  if(trim(fm.mediatype.value)=='4'){
         var tryURL = 'tryView.jsp?ringid=' + fm.crid.value+'&ringname='+fm.ringname.value+'&ringauthor='+fm.ringauthor.value +"&usernumber="+fm.craccount.value+"&mediatype="+fm.mediatype.value;
      	preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="userRing.jsp">
<input type="hidden" name="crid" value="">
<input type="hidden" name="ringname" value="">
<input type="hidden" name="ringauthor" value="">
<input type="hidden" name="ringidtype" value="">
<input type="hidden" name="mediatype" value="">
<input type="hidden" name="craccount" value="<%= craccount == null ? "" : craccount %>">
<table width="450"  border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Preview Subscriber's Purchased <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
        </tr>
        <tr>
          <td width="36%" align="right"><%=user_number%></td>
          <td width="64%"><input type="text" name="usernumber" value="<%= craccount == null ? "" : craccount %>" maxlength="20" class="input-style1">
          <img src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing()"></td>
        </tr>
        <tr>
          <td colspan="2" align="center">
            <select name="personalRing" size="10" <%= vetRing.size() == 0 ? "disabled " : "" %>onclick="javascript:selectPersonalRing()" class="input-style1" style="width: 240;">
<%
                Hashtable tmp = new Hashtable();
                for (int i = 0; i < vetRing.size(); i++) {
                    tmp = (Hashtable)vetRing.get(i);
                    if(((String)tmp.get("crid")).startsWith("99"))
                      continue;

%>
              <option value="<%= (String)tmp.get("crid") %>"><%= (String)tmp.get("crid") + "---" + (String)tmp.get("filename") %></option>
<%
                }
%>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan="2" align="center">
               <img src="button/trylisten.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:tryListen()">
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td colspan=2>
          <table border="0" width="100%" class="table-style2">
            <tr>
                <td class="table-styleshow" background="image/n-9.gif" height="26">
                  Notes:</td>
              </tr>
            <%  if(areacode.equals("3")){
            %>
              <tr>
                <td style="color: #FF0000">Format of PHS <%=user_number%>: 0+area code+actual number.</td>
              </tr>
             <% } else {%>
              <tr>
                <td style="color: #FF0000"><%=user_number%>: Mobile Phone Number.</td>
              </tr>
            <% } %>
           </table>
          </td>
        </tr>
</table>
</form>
<%
        }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                   alert( "Please log in to the system first!");//Please log in to the system
                   document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime + operName + ",Exception occurred in pre-listening the subscriber's ringtone!");//试听用户铃音过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in pre-listening the subscriber's ringtone!");//试听用户铃音过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="userRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
