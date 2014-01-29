<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
     public String display (Map map) throws Exception {
        try {
            String str = (String)map.get("ringid") + "--" + (String)map.get("ringlabel");
            return str;
        }
        catch (Exception e) {
            throw new Exception ("Obtain incorrect data!");
        }
    }
%>
<html>
<head>
<title>Present some user ringtones</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" >
  <%
  String usecalling  = CrbtUtil.getConfig("usecalling","0");
  ywaccess ywAcc = new ywaccess();
  manSysRing sysring = new manSysRing();
  manSysPara syspara = new manSysPara();
  int startTime = ywAcc.getParameter(15);
  int endTime   = ywAcc.getParameter(16);
  String sysTime = sysring.getSysTime() + "--";
  int stopDate = Integer.parseInt(sysTime.substring(11,13));
  if(startTime>stopDate || endTime<stopDate){
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
    String objSort = request.getParameter("objSort") == null ? "3" : ((String)request.getParameter("objSort")).trim();
    String hdlist = request.getParameter("hdlist") == null ? "-1" : ((String)request.getParameter("hdlist")).trim();
    String usernumber = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();
    String optarealisttem = request.getParameter("optarealist") == null ? "0" : ((String)request.getParameter("optarealist")).trim();
    String scpno = request.getParameter("scpno") == null ? "" : ((String)request.getParameter("scpno")).trim();
    String ischeck = request.getParameter("ischeck") == null ? "0" : ((String)request.getParameter("ischeck")).trim();
    String listfile = request.getParameter("listfile") == null ? "" : (String)request.getParameter("listfile");
    int order = request.getParameter("order") == null ? -1 : Integer.parseInt((String)request.getParameter("order"));
    String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
      String     sSpCode = "";
      sysTime = sysring.getSysTime() + "--";
      if (operID != null && purviewList.get("2-19") != null) {
        //业务区下拉框****************
        HashMap map = new HashMap();
        HashMap map1 = new HashMap();
        String optAreaList = "";
        ArrayList serviceList =  new ArrayList();
        serviceList = syspara.getServiceAreaAll();
        for(int i=0;i<serviceList.size();i++){
          map = (HashMap)serviceList.get(i);
          if(optarealisttem.equals((String)map.get("serareano"))){
            optAreaList = optAreaList +  "<option selected value=" + (String)map.get("serareano") + ">" +(String)map.get("serareaname") + "</option>";
          }else{
            optAreaList = optAreaList +  "<option value=" + (String)map.get("serareano") + ">" +(String)map.get("serareaname") + "</option>";
          }
        }
        //号段下拉框****************
        ArrayList hdlists = new ArrayList();
        String hdOptions = "";
        if(!optarealisttem.equals("0") && !scpno.equals("")){
          hdlists = syspara.getHlrByArea(scpno,optarealisttem);
        }
        for(int i=0;i<hdlists.size();i++){
          map = (HashMap)hdlists.get(i);
          hdOptions = hdOptions + "<option value=" + (String)map.get("hlr") + ">" +(String)map.get("hlr") + "</option>";
        }
        if(order == -1){
      %>
<script language="javascript">
   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if(<%=objSort%> == "1" && trim(fm.optarealist.value) == "-1"){
        alert("Please select service area!");//请选择业务区!
        return flag;
      }
      if(<%=objSort%> == "2" &&  trim(fm.filetext.value) == ""){
         alert('Please select the directory file!');
         return;
      }
      if(<%=objSort%> == "3" && trim(fm.usernumber.value) == ""){
        alert("Please input the presented user number!");
        return flag;
      }
      if (<%=objSort%> == "3" && !checkstring('0123456789',trim(fm.usernumber.value))) {
        alert('User number must in the digit format!');
        fm.usernumber.focus();
        return flag;
      }
      var value = trim(fm.ringid.value);
      if(value==''){
         alert("Please input <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code!");
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code must be in digit format!');
         fm.ringid.focus();
         return flag;
      }
      if(fm.ischeck.checked){
        fm.ischeck.value = '1';
      }else{
        fm.ischeck.value = '0';
      }
      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      if(!checkInfo())
        return;
      if(confirm('<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> present may take some time. Are you sure to present it?')){
        fm.op.value = 'add';
        fm.order.value = "0";
        fm.submit();
      }
   }

   function queryInfo() {
     sresult =  window.showModalDialog('ringSearch.jsp',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(sresult){
         document.inputForm.ringid.value = sresult;
         //document.inputForm.submit();
     }
   }
      
   function selectClick(){
     var fm = document.inputForm;
     if(fm.ischeck.checked){
       fm.ischeck.value = '1';
     }else{
       fm.ischeck.value = '0';
     }
     fm.submit();
   }
   var v_scpno = new Array(<%= serviceList.size() + "" %>);
   <%
   for(int i=0;i<serviceList.size();i++){
     map = (HashMap)serviceList.get(i);
     %>
     v_scpno[<%= i + "" %>] = '<%= (String)map.get("scpno") %>';
     <%
   }
   %>

   function changeAreaList(){
     var fm = document.inputForm;
     var index = fm.optarealist.selectedIndex;
     if (index == null)
     return;
     if (index == '') {
       fm.optarealist.focus();
       return;
     }
     fm.scpno.value = v_scpno[index-1];
     fm.submit();
   }
<%if(usecalling.trim().equalsIgnoreCase("1")){%>
function bclk(avar)
{
  document.inputForm.userType.value=avar;
}
<%}%>
   function selectFile() {
      var fm = document.inputForm;
      var uploadURL = 'largessUpload.jsp';
      uploadRing = window.open(uploadURL,'largessUpload','width=400, height=200');
   }
   function getListName (name, label) {
      var fm = document.inputForm;
      fm.listfile.value = name;
      fm.filetext.value = label;
   }
   </script>

<script language="JavaScript">
	if(parent.frames.length>0)
          parent.document.all.main.style.height="700";
</script>
<form name="inputForm" method="post" action="largessPartRing.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="scpno" value="<%=scpno%>">
<input type="hidden" name="order" value="-1">
<input type="hidden" name="listfile" value="">
<input type="hidden" name="userType" value="0">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> gift</td>
        </tr>
        <td align="center">

        </td>
        <td height='100%'>
            <table width="422" border =0 class="table-style2" height='106'>
            <tr>
              <td align="left" height="26" colspan="2"><input type="radio" name="objSort" value="1" onclick="selectClick()" <%if("1".equals(objSort)){%> checked<%}%>>Service area or Number prefix
             <input type="radio" name="objSort" value="2" onclick="selectClick()" <%if("2".equals(objSort)){%> checked<%}%>>File list
                                           <input type="radio" name="objSort" value="3" onclick="selectClick()" <%if(!"1".equals(objSort) && !"2".equals(objSort)){%>checked<%}%>>User number</td>
            </tr>
            <tr>
             <td width="155" align=right height="26">Receiver</td>
             <%if("1".equals(objSort)){%>
             <td width="257" colspan="3" height="26">
               <select name="optarealist" size="1" style="width:120px" onchange="changeAreaList()">
               <option value="-1" >Service area</option>
               <% out.print(optAreaList); %>
             </select><select name="hdlist" size="1" style="width:120px">
               <option value="-1">All number segments</option>
               <% out.print(hdOptions); %>
             </select></td>
              <% }else if("2".equals(objSort)){%>
             <td width="257" colspan="3" height="26"><input type="text" name="filetext" size="20" class="input-style1" disabled>&nbsp;<img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"></td>

             <% }else{%>
             <td width="257" colspan="3" height="26"><input type="text" name="usernumber" value="Subscriber number" maxlength="20" class="input-style1" onMouseOver="javascript:this.focus();this.select();"></td>
              <% }%>
            </tr>
            <tr>
             <td width="155" align=right height="27"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
             <td width="257" height="27"><input type="text" name="ringid" value="<%= ringid %>" maxlength="20" class="input-style1"  ><img src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo()"></td>
            </tr>
            <%if(usecalling.trim().equalsIgnoreCase("1")){%>
            <tr>
               <td width="155" align=right height="27">User Service type</td>
               <td width="257" height="27">
               	<input type="radio" name="bj" value="0" checked onclick="bclk('0');">Called</input>
               	<input type="radio" name="bj" value="1" onclick="bclk('1');">Calling</input>
               	<!--<input type="radio" name="bj" value="2" onclick="bclk('2');">Calling/called</input></td>-->
            </tr>
            <%}%>
            <tr>
            <td align=center height="27" colspan="2">Whether to be the default <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>
             <input type="checkbox" name="ischeck" value="<%=ischeck%>" <%if("1".equals(ischeck)){%> checked<%}%>></td>
            </tr>
            <tr>
            <td colspan="2" align="center" height="27">
              <table border="0" width="100%" class="table-style2"  align="center" height="38">
              <tr>
                <td width="97%" align="center"><img src="button/largess.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()">&nbsp;&nbsp;<img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>

              <tr>
            <td align=left height="27" colspan="2">
              Notes: User will get the gift,  if he has open the selected service.
            </tr>
              </table>
            </td>
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
else if(order == 0){
      //新增事件******************
      String userType = request.getParameter("userType") == null ? "0" : (String) request.getParameter("userType").trim();
      if(userType.trim().equalsIgnoreCase(""))
         userType = "0";
      int optype = 0;
      String title = "";
      if (op.equals("add")){
        optype = 1;
        title = "Present ringtone";
      }
      Vector log = new Vector();
      if(optype>0){
        Vector vet = new Vector();
        Hashtable hashtabel = new Hashtable();
        //操作日志
        String telnumber = null;
        zxyw50.Purview purview = new zxyw50.Purview();
        map1.put("OPERID",operID);
        map1.put("OPERNAME",operName);
        map1.put("OPERTYPE","219");
        map1.put("RESULT","1");
        map1.put("PARA1",ringid);
        map1.put("PARA2",telnumber);
        map1.put("PARA3","ip:"+request.getRemoteAddr());
        map1.put("DESCRIPTION",title);
        Vector list = new Vector();
        Hashtable rTem = new Hashtable();
        if(objSort.equals("1")){//选择业务区号段
          if(!"-1".equals(hdlist)){//选择业务区下单个号段
            try{
              list = sysring.getHdUsernumber(hdlist,scpno);
            }catch(YW50Exception e1e1){
              log.add(e1e1.getMessage());
            }
            for(int i=0;i<list.size();i++){
            rTem = (Hashtable)list.get(i);
              try{
                hashtabel = sysring.setLargessRing((String)rTem.get("usernumber"),ringid,Integer.parseInt(ischeck),Integer.parseInt(userType));
                log.add("Subscriber:"+(String)rTem.get("usernumber")+":ringtone present successfully");
                String flag =  (String)hashtabel.get("flag");
                if(flag.equals("0") && ischeck.equals("1")){
                  log.add("Subscriber:"+(String)rTem.get("usernumber")+":succeeded in setting default ringtones");
                }
                telnumber = (String)rTem.get("usernumber");
                purview.writeLog(map1);
              }catch(YW50Exception e1){
                log.add("Subscriber:"+(String)rTem.get("usernumber")+":"+e1.getMessage());
              }
            }
          }else{//选择业务区下所有号段
          if(hdlists.size()>0){
            for(int j=0;j<hdlists.size();j++){
              map = (HashMap)hdlists.get(j);
              try{
                list = new Vector();
                list = sysring.getHdUsernumber((String)map.get("hlr"),scpno);
              }catch(YW50Exception ee1){
                log.add(ee1.getMessage());
              }
              for(int i=0;i<list.size();i++){
                rTem = (Hashtable)list.get(i);
                try{
                  hashtabel = new Hashtable();
                  hashtabel = sysring.setLargessRing((String)rTem.get("usernumber"),ringid,Integer.parseInt(ischeck),Integer.parseInt(userType));
                  log.add("Subscriber:"+(String)rTem.get("usernumber")+":ringtone present successfully");
                  String flag =  (String)hashtabel.get("flag");
                  if(flag.equals("0") && ischeck.equals("1")){
                    log.add("Subscriber:"+(String)rTem.get("usernumber")+":succeeded in setting default tones!");
                  }
                  telnumber = (String)rTem.get("usernumber");
                  purview.writeLog(map1);
                }catch(YW50Exception e1){
                  log.add("Subscriber:"+(String)rTem.get("usernumber")+":"+e1.getMessage());
                }
              }
            }
          }else{
            log.add("There is no number segment in your selected service area!");
          }
          }
        }
        else if(objSort.equals("3")){//选择单个用户,输入User number
          try{
            hashtabel = new Hashtable();
            hashtabel = sysring.setLargessRing(usernumber,ringid,Integer.parseInt(ischeck),Integer.parseInt(userType));
            log.add(" Subscriber:"+usernumber+":succeeded in presenting ringtone");
            String flag =  (String)hashtabel.get("flag");
            if(flag.equals("0") && ischeck.equals("1")){
              log.add("Subscriber:"+usernumber+":succeeded in setting default tones");
            }
            telnumber = usernumber;
            purview.writeLog(map1);
          }catch(YW50Exception e1){
            log.add("Subscriber:"+usernumber+":"+e1.getMessage());
          }
        }
        else if (objSort.equals("2")){
          if (listfile.length() > 0){
            //sSpCode = sysring.getLargessNumFile(listfile);
            vet = sysring.analyseLargessNum(listfile);
          }
          for(int i=0;i<vet.size();i++){
            try{
              hashtabel = new Hashtable();
              hashtabel = sysring.setLargessRing(vet.elementAt(i)+"",ringid,Integer.parseInt(ischeck),Integer.parseInt(userType));
              log.add("Subscriber:"+vet.elementAt(i)+":succeeded in presenting ringtones");
              String flag =  (String)hashtabel.get("flag");
              if(flag.equals("0") && ischeck.equals("1")){
                log.add("Subscriber:"+vet.elementAt(i)+":succeeded in setting default ringtones");
              }
              telnumber = vet.elementAt(i)+"";
              purview.writeLog(map1);
            }catch(Exception e1){
              log.add("Subscriber:"+vet.elementAt(i)+":"+e1.getMessage());
            }
          }
        }
      } %>
<form name="inputForm" method="post" action="largessPartRing.jsp">
<input type="hidden" name="order" value="<%= (order + 1) + "" %>">
  <input type="hidden" name="userType" value="<%=userType%>">
<table border="0" height="100%" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <%if(log.size()>0){
        for(int i=0;i<log.size();i++){
        %>
        <tr>
          <td align="left" ><%=(String)log.elementAt(i)%> </td>
        </tr>
        <% } }else{%>
        <tr>
          <td align="left" >No user number can be used for the presenting!</td>
        </tr>
       <% }%>
        <tr>
          <td align="center"><a href="largessPartRing.jsp"><img src="button/back.gif" onmouseover="this.style.cursor='hand'" border="0"></a></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
  <%
    }
    }
    else {
      if(operID == null){
        %>
        <script language="javascript">
        alert( "Please log in to the system first!");//Please log in to the system!
        document.URL = 'enter.jsp';
        </script>
        <%
      }
      else{
        %>
        <script language="javascript">
          alert( "Sorry, you are not allowed to perform this function!");
          </script>
          <%

        }
      }
      }
      catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "It is abnormal during the setting of system present ringtone!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the tone present procedure!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
        %>
        <form name="errorForm" method="post" action="error.jsp">
          <input type="hidden" name="historyURL" value="largessPartRing.jsp">
        </form>
        <script language="javascript">
        document.errorForm.submit();
        </script>
        <%
      }
  }else{
    %>
        <script language="javascript">
          alert( "Sorry, the system is not stable in presenting tones in this time segment. Please perform the operation except the time <%=startTime%> :00 to <%=endTime%> :59");
          document.URL = '../intro.html';
          </script>
          <%
  }

      %>
      </body>
    </html>
