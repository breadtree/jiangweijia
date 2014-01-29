<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.ManGroup" %>
<%@ page import="zxyw50.CrbtUtil" %>


<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%   
    String mainTitle = request.getParameter("title") == null ? "" : transferString(request.getParameter("title"));
%>
<html>
<head>
<title><%= mainTitle %></title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String enablegrpaccount =  CrbtUtil.getConfig("enablegrpaccount","1");
    String grouplen = (String)session.getAttribute("GROUPIDLEN")==null?"10":(String)session.getAttribute("GROUPIDLEN");
    String target = request.getParameter("target") == null ? "" : transferString(request.getParameter("target"));
    String strPurview = request.getParameter("purview") == null ? "" : transferString(request.getParameter("purview"));
    try {
        ManGroup mangroup = new ManGroup();
        sysTime = mangroup.getSysTime() + "--";
        if (operID != null) {
            ArrayList vet = new ArrayList();
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String groupindex = request.getParameter("groupindex") == null ? "" :  (String)request.getParameter("groupindex");
            String groupid = request.getParameter("inputGroupid") == null ? "" : transferString((String)request.getParameter("inputGroupid")).trim();
            String groupname = request.getParameter("groupname") == null ? "" : transferString((String)request.getParameter("groupname")).trim();
            boolean result = false;
            if(op.equals("check")){
                hash = (Hashtable)mangroup.getGroupInfoByid(groupid);
                groupindex = (String)hash.get("groupindex");
                groupname = (String)hash.get("groupname");
                zxyw50.Purview purview = new zxyw50.Purview();
                result = purview.checkGroupOperateRight(session,strPurview,groupid);
                if (result){
            %>
<form name="resultForm" method="post" action="../group/<%= target %>">
<input type="hidden" name="historyURL" value="grpChoice.jsp"/>
<!--表示已经通过验证-->
<input type="hidden" name="mode" value="manager"/>
<input type="hidden" name="target" value="<%=  target %>"/>
<input type="hidden" name="groupindex" value="<%= groupindex %>"/>
<input type="hidden" name="groupid" value="<%= groupid %>"/>
<input type="hidden" name="groupname" value="<%= groupname %>"/>
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
<%
                }//if
                else{
%>
<script language="javascript">
  //alert('您无权对本集团进行操作!');
    alert('You have no access to this group!');
  history.back();
</script>
<%
                }
            }//if
%>
<script language="javascript">
   function manageInfo(){
     var grouplen = <%= grouplen %>;
     var fm = document.inputForm;
     var index = fm.inputGroupid.value;
     if (index == ''){
      // alert('请输入集团号码!');
       alert('Please input the group number!');
       fm.inputGroupid.focus();
       return;
     }
      if(index.length < grouplen){
         // alert('集团 code长度最大不得超过15位,最短不得小于'+grouplen + '位,请重新输入!');
          alert('The group code cannot be larger than 15 bytes and cannot be less than '+grouplen+' bytes,please re-enter!');
          fm.inputGroupid.focus();
          return;
      }
       if(index.length >15){
          //alert('集团 code长度最大不得超过15位,最短不得小于'+grouplen + '位,请重新输入!');
          alert('The group code cannot be larger than 15 bytes and cannot be less than '+grouplen+' bytes,please re-enter!');
          fm.inputGroupid.focus();
          return;
      }
     fm.submit();
   }
     //限定只能输入数字
  function numbersOnly(field,event){
    var key,keychar;
    if(window.event){
      key = window.event.keyCode;
    }
    else if (event){
      key = event.which;
    }
    else{
      return true
    }
    keychar = String.fromCharCode(key);
    if((key == null) || (key == 0) || (key == 8)|| (key == 9) || (key == 13) || (key == 27)){
      return true;
    }
    else if(('0123456789').indexOf(keychar) > -1){
      return true;
    }
    else {
     // alert('请输入数字');
      alert('Please input a digit!');
      return false;
    }
  }
</script>
<script language="JavaScript">
  if (parent.frames.length > 0)
    parent.document.all.main.style.height="520";
</script>
<form name="inputForm" method="post" action="grpChoice.jsp">
<input type="hidden" name="target" value="<%=  target %>"/>
<input type="hidden" name="groupindex" value=""/>
<input type="hidden" name="groupid" value=""/>
<input type="hidden" name="groupname" value=""/>
<input type="hidden" name="op" value="check"/>
<input type="hidden" name="purview" value="<%= strPurview %>"/>
<table width="440" height="480" border="0" align="center" class="table-style2">
  <tr valign="middle">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif"><%= mainTitle %></td>
        </tr>
	<tr >
          <td height="20" colspan="3" align="center" >&nbsp;</td>
        </tr>
        <tr>
          <td align="center"><b>Management of the input group number</b></td>
        </tr>
        <tr>
          <td width="100%" align="center" valign="top">
            <input type="text" name="inputGroupid" value="" class="input-style1" onkeypress="return numbersOnly(this);"/>
          </td>
        </tr>
	<tr>
          <td>
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="33%" align="center"><img src="button/member.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:manageInfo()" alt="Management"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr >
          <td height="26" colspan="3" >
           <table border="0" width="100%" class="table-style2">
              <tr>
               <td class="table-styleshow" background="image/n-9.gif" height="26">Notes:</td>
              </tr>
              <tr>
               <td >&nbsp;Please input the group number,then click the "manage" button. </td>
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
        else {

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "You have no access to this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occurred in managing the group!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing the group");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpChoice.jsp?title=<%= mainTitle %>&amp;target=<%= target %>&amp;purview=<%= strPurview %>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
