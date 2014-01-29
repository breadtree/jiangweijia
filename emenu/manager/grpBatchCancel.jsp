<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.zxywpub.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="zxyw50.Purview" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Group user exits in batches</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String listfile = request.getParameter("listfile") == null ? "" : (String)request.getParameter("listfile");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        ColorRing colorRing = new ColorRing();
        ManGroup uploadRing = new ManGroup();
        String     sSpCode = "";
        int order = request.getParameter("order") == null ? -1 : Integer.parseInt((String)request.getParameter("order"));
        int flag = 0;
        if (operID != null && purviewList.get("11-3")!= null) {
            Vector vet = new Vector();
            // 第一次打开批量上传界面
            if (order == -1) {
%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
      if ((fm.listfile.value).length == '') {
         alert('Please select list file!');
         return;
      }
      if(confirm('The batch operation will take much time,are you sure to you want to continue?')){
        fm.order.value = '0';
        fm.submit();
      }

   }

   function selectFile () {
      var fm = document.inputForm;
      var uploadURL = 'grpBatchUpload.jsp';
      window.open(uploadURL,'upload','width=450, height=300,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }

   function getListName (name, label) {
      var fm = document.inputForm;
      fm.listfile.value = name;
      fm.filename.value = label;
   }
</script>

<form name="inputForm" method="post" action="grpBatchCancel.jsp">
<input type="hidden" name="listfile" value="">
<input type="hidden" name="order" value="0">
<table border="0" height="400" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr background="image/n-9.gif">
          <td height="26" colspan="2" align="center" class="text-title"background="image/n-9.gif">Group user exits in batches</td>
        </tr>
        <tr>
          <td height="22" align="right">List file name</td>
          <td height="22"><input type="text" name="filename" value="" disabled class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="center"><img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"></td>
                <td width="50%" align="center"><img src="button/upload.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()"></td>
              </tr>
            </table>          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%
            }
            // 第一次上传
            else if (order == 0) {
                if (listfile.length() > 0){
                    sSpCode = uploadRing.getGroupIDFromFile1(listfile);
                    vet = uploadRing.analyseGroupUser(listfile);
                }
             Vector log = new Vector();
             SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
               //鉴权使用
             Purview pview = new Purview();
            for(int i=0;i<vet.size();i++){
               try{
                 String craccount = (String)vet.elementAt(i);
            manUser manuser = new manUser();
            String type  = manuser.getUserCardinfo(craccount);
            if(type == null)
               throw new Exception("The subscriber does not exists!");
            else if("".equals(type))
               throw new Exception("The subscriber is not a group user!");
            String groupid = colorRing.getGroupId(craccount);
              //鉴权
                if (!pview.checkGroupOperateRight(session, "11-3", groupid))
                {
                    throw new Exception("Sorry,you have no permit on the user group " + groupid + "!");
                }
              Hashtable hash = new Hashtable();
              hash.put("opcode","01010519");
              hash.put("craccount",craccount);
              hash.put("strreserve1","1");
              hash.put("strreserve2",request.getRemoteAddr());
              Hashtable result = SocketPortocol.send(pool,hash);

              log.add("The user "+vet.elementAt(i)+" exits the group successfully");
                 // 准备写操作员日志
                 zxyw50.Purview purview = new zxyw50.Purview();
                 HashMap map = new HashMap();
                 map.put("OPERID",operID);
                 map.put("OPERNAME",operName);
                 map.put("OPERTYPE","603");
                 map.put("RESULT","1");
                 map.put("PARA1",vet.elementAt(i));
                 map.put("PARA2","ip:"+request.getRemoteAddr());
                 purview.writeLog(map);
               }catch(Exception e1){
                  e1.printStackTrace();
                  log.add("Subscriber "+vet.elementAt(i)+":"+e1.getMessage());
               }
             }

%>

<form name="inputForm" method="post" action="grpBatchCancel.jsp">
<input type="hidden" name="order" value="<%= (order + 1) + "" %>">
<table border="0" height="100%" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <%
        for(int i=0;i<log.size();i++){
        %>
        <tr>
          <td align="left" ><%=(String)log.elementAt(i)%> </td>
        </tr>
        <% } %>
      </table>
    </td>
  </tr>
</table>
</form>
<%
            }
        }
        else {
             if(operID== null){
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
        sysInfo.add(sysTime + operName + " Exception occurred in exitting from group in batches!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in exitting from group in batches!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpBatchCancel.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
