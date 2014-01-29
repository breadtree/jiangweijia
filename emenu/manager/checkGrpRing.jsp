<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public Vector refuseComment() {
        Vector vet = new Vector();
        vet.add("Refused this ringtone");//该铃音拒绝通过审核
        vet.add("Invalid Ringtone properties");//铃音属性配置不真确
        vet.add("Ringtone name exist");//Ringtone name已经存在
        vet.add("Unreasonable ringtone price");//铃音价格不合理
        vet.add("Blue ringtone");//黄色铃音
        vet.add("Reactionary ringtone");//反动铃音
        vet.add("Poor ringtone Quality");//铃音音质太差
        vet.add("Unable to play");//铃音无法播放
        vet.add("Other reasons");//其它原因
        return vet;
    }
%>
<html>
<head>
<title>Group ringtone verification</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" onload="initform(document.forms[0])">
<%
   //String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13

   //add by ge quanmin 2005-07-11 for version 3.18.01
    String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","ringtone producer");// ringtone producer
    ringsourcename=transferString(ringsourcename);
    //end
    String sysTime = "";
    String jName = (String)application.getAttribute("JNAME");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        manSysRing sysring = new manSysRing();

        sysTime = sysring.getSysTime() + "--";
        int operflag = 0; //0:无权限 1:内容审核,2:资费审核 3:内容审核和资费审核
        if (purviewList.get("6-5") != null)
           operflag = 1;
        if (purviewList.get("6-6") != null)
           operflag = operflag + 2;
        if(operflag ==0 || operID==null){
%>
<script language="javascript">
    alert('<%= operID == null ? "Please log in to the system first!" : "You have no access to this function!" %>');
	document.URL = 'enter.jsp';
</script>
<%
        }
        else if (operID != null) {
            String ringindex = request.getParameter("ringindex") == null ? "" : ((String)request.getParameter("ringindex")).trim();
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String ringname = request.getParameter("ringname") == null ? "" : transferString((String)request.getParameter("ringname")).trim();
            String refusecomment = request.getParameter("reasontext") == null ? "": transferString((String)request.getParameter("reasontext")).trim();

            // 铃音审核通过
            ArrayList rList = new ArrayList();
            String    title = "";
            Hashtable tTmp = new Hashtable();
            if (op.equals("1")) {    //内容审核通过
                 title = "Content verification passed "+ringname;
                 rList = sysring.checkGrpRingPass(pool,Integer.parseInt(ringindex),3);
                 title = "Content verification passed "+ringname;
                 refusecomment = "";
            }
            else if (op.equals("2")){ //拒绝内容审核
                rList = sysring.checkSysRingRefuse(Integer.parseInt(ringindex),refusecomment,1);
                title = "Refuse content verification "+ringname;
            }
            else if (op.equals("3")){  //资费审核通过
                rList = sysring.checkGrpRingPass(pool,Integer.parseInt(ringindex),4);
                title = "Tariff verification passed "+ringname;
                refusecomment = "";
            }
            else if (op.equals("4")){  //拒绝资费审核
                rList = sysring.checkSysRingRefuse(Integer.parseInt(ringindex),refusecomment,1);
                title = "Refuse tariff verification "+ringname;
            }
             //填写操作员日志
            if(!op.equals("") && getResultFlag(rList)){
                 Hashtable stmp = (Hashtable)rList.get(0);
                  // 准备写操作员日志
                  zxyw50.Purview purview = new zxyw50.Purview();
                  HashMap map = new HashMap();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","403");
                  map.put("RESULT","1");
                  map.put("PARA1",op);
                  map.put("PARA2",(String)stmp.get("ringid"));
                  map.put("PARA3",(String)stmp.get("ringlabel"));
                  map.put("PARA4","ip:"+request.getRemoteAddr());
                  map.put("DESCRIPTION",refusecomment);
                  purview.writeLog(map);
             }


            if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="checkGrpRing.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }

            manSysRing  syspara = new manSysRing();
            Vector vet = sysring.gerGrpCheckRing(operflag);
            Hashtable hash = new Hashtable();

%>
<script language="javascript">

   var v_ringindex = new Array(<%= vet.size() + "" %>);
   var v_usernumber = new Array(<%= vet.size() + "" %>);
   var v_ringlabel = new Array(<%= vet.size() + "" %>);
   var v_ringsource = new Array(<%= vet.size() + "" %>);
   var v_ringfee = new Array(<%= vet.size() + "" %>);
   var v_ischeck = new Array(<%= vet.size() + "" %>);
   var v_ringallindex = new Array(<%= vet.size() + "" %>);
   var v_groupname = new Array(<%= vet.size() + "" %>);
   var v_mediatype = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_ringindex[<%= i + "" %>] = '<%= (String)hash.get("ringindex") %>';
   v_usernumber[<%= i + "" %>] = '<%= (String)hash.get("usernumber") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
   v_ringsource[<%= i + "" %>] = '<%= (String)hash.get("ringsource") %>';
   v_ringfee[<%= i + "" %>] = '<%= (String)hash.get("ringfee") %>';
   v_ischeck[<%= i + "" %>] = '<%= (String)hash.get("ischeck") %>';
   v_ringallindex[<%= i + "" %>] = '<%= (String)hash.get("allindex") %>';
   v_groupname[<%= i + "" %>] = '<%= (String)hash.get("groupname") %>';
   v_mediatype[<%= i + "" %>] = '<%= (String)hash.get("mediatype") %>';

<%
            }
%>

   function initform(pform){
       var value = parseInt(pform.operflag.value);
       disableButton(value);
   }

   function disableButton(value){
      var pform = document.inputForm;
      if(value ==0){
          pform.checkpass1.disabled  = true;
          pform.checkpass2.disabled  = true;
          pform.checkpass3.disabled  = true;
          pform.checkpass4.disabled  = true;
       }
       else if(value==1){
          pform.checkpass1.disabled  = false;
          pform.checkpass2.disabled  = false;
          pform.checkpass3.disabled  = true;
          pform.checkpass4.disabled  = true;

       }
       else if(value==2){
          pform.checkpass1.disabled  = true;
          pform.checkpass2.disabled  = true;
          pform.checkpass3.disabled  = false;
          pform.checkpass4.disabled  = false;

       }else if(value==3){
          pform.checkpass1.disabled  = false;
          pform.checkpass2.disabled  = false;
          pform.checkpass3.disabled  = false;
          pform.checkpass4.disabled  = false;
       }
   }

   function selectRing () {
      var fm = document.inputForm;
      var index = fm.ringlist.value;
      var usernumber = '';
      if (index == null) {
         fm.ringlist.focus();
         return;
      }
      if (index == '')
         return;
      fm.ringindex.value = v_ringindex[index];
      fm.usernumber.value = v_usernumber[index] ;
      fm.groupname.value = v_groupname[index];
      fm.ringlabel.value = v_ringlabel[index];
      fm.ringsource.value = v_ringsource[index];
      fm.ringfee.value = v_ringfee[index];
      fm.ringname.value = v_ringlabel[index];
      fm.mediatype.value = v_mediatype[index];
      var operflag = fm.operflag.value;
      var value = v_ischeck[index];
      if(value==0)
          disableButton(operflag);
      else if(value==3){
          if(operflag==3 || operflag == 1)
             disableButton(2);
          else
             disableButton(0);
      }else if(value ==4){
          if(operflag==3 || operflag == 2)
              disableButton(1);
          else
             disableButton(0);
      }
      else
         disableButton(0);
   }

   function checkpass (opflag) {
      //opflag: 1:内容审核通过,2:内容审核拒绝,3:资费审核通过,4:资费审核拒绝
       fm = document.inputForm;
       var strcon = "";
       var strtemp = "";
       switch(opflag){
        case 1:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that requires content verification";//请先选择要内容审核的铃音
          strtemp = "Are you sure you want to pass the content verification of this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>?";//您确认这条铃音通过内容审核吗
          break;
        case 2:
          strcon = "Plese select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that should be refused to pass the content verification";

          strtemp = "Are you sure you refuse to pass the content verification of this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>?";//您确认拒绝这条铃音通过内容审核吗
          if(!checkRefuse())
             return;
          break;
        case 3:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that requires tariff verification";//请先选择要资费审核的铃音
          strtemp = "Are you sure you want to pass the tariff verification of this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>?";//您确认这条铃音通过资费审核吗
          break;
        case 4:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that should be refused to pass the tariff verification";//请先选择拒绝通过资费审核的铃音
          strtemp = "Are you sure you refuse to pass the tariff verification of this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>?";//您确认拒绝这条铃音通过资费审核吗
          if(!checkRefuse())
             return;
          break;

      }
      if (fm.ringindex.value == '') {
         alert(strcon);
         return;
      }
      if (confirm(strtemp) == 0)
         return;
      fm.op.value = opflag;
      fm.submit();
   }

   function checkRefuse () {
      fm = document.inputForm;
      if (fm.ringindex.value == '') {
         alert('Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be refused!');//请先选择要拒绝的铃音
         return false;
      }
      if(fm.ischeck[0].checked){
          if(fm.refusecomment.selectedIndex == -1){
             alert("Please select a reason of refuse!");
             return false;
          }
          fm.reasontext.value = fm.refusecomment.options[fm.refusecomment.selectedIndex].text;
      } else {
          var value = trim(fm.reason.value);
          if(value == ''){
              alert("Please enter reason of refuse");
              fm.reason.focus();
              return false;
          }
            <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.reason.value,100)){
             alert("The reason of refuse can't be longer than 100 character,please re-enter!");
              fm.reason.focus();
              return false;
          }
        <%
        }
        else{
        %>
        if(strlength(value)>100){
              alert("The reason of refuse can't be longer than 100 character,please re-enter!");
              fm.reason.focus();
              return false;
          }
        <%}%>
          fm.reasontext.value = fm.reason.value;
      }
      return true;
   }

   function tryListen () {
      fm = document.inputForm;
      if (fm.ringindex.value == '') {
         alert('Please select a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> before pre-listening!');//请先选择铃音,再试听!
         return;
      }
      if(fm.ringindex.value.substring(0,2)=='99'){
         alert("Sorry,music group cannot pre-listen!");//对不起,铃音组不能试听!
         return;
      }
	  var tryURL = 'listenCheck.jsp?ringindex=' + fm.ringindex.value + '&ringname='+fm.ringname.value+'&mediatype='+ fm.mediatype.value;
      if(trim(fm.mediatype.value)=='1'){
      preListen =  window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(fm.mediatype.value)=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(fm.mediatype.value)=='4'){
        tryURL = 'viewCheck.jsp?ringindex=' + fm.ringindex.value + '&ringname='+fm.ringname.value+'&mediatype='+ fm.mediatype.value;
            preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));;
   		}
  }/*
  function tryListen (ringindex,ringname,mediatype) {
      fm = document.inputForm;
      var tryURL = 'listenCheck.jsp?ringindex=' + ringindex + '&ringname='+ringname+'&mediatype='+ mediatype;
      if(trim(mediatype)=='1'){
      preListen =  window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='4'){
        tryURL = 'viewCheck.jsp?ringindex=' + ringindex + '&ringname='+ringname+'&mediatype='+ mediatype;
            preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));;
   }
   }*/

   function OnRadioCheck(){
      var fm = document.inputForm;
      if(fm.ischeck[0].checked){
          id_text.style.display = 'none';
          id_select.style.display = 'block';
      }
      else{
          id_text.style.display = 'block';
          id_select.style.display = 'none';
      }
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="checkGrpRing.jsp">
<input type="hidden" name="ringindex" value="">
<input type="hidden" name="operflag" value="<%= operflag %>">
<input type="hidden" name="ringname" value="">
<input type="hidden" name="reasontext" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="mediatype" value="">
<table border="0" align="center" height="400" cellspacing="0" cellpadding="0" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Group <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> verification</td>
        </tr>
        <tr>
          <td height="15" colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr>
          <td width=40% align="right">
            <select name="ringlist" size="10" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectRing()">
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
              <option value="<%= i %>"><%= (String)hash.get("ringlabel") %></option>
<%
            }
%>
            </select>
          </td>
          <td width="60%">
              <table border="0"  cellspacing="1" cellpadding="1" class="table-style2">
               <tr>
                 <td height="22" align="right">Group code</td>
                 <td height="22"><input type="text" name="usernumber" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right">Group name</td>
                   <td height="22"><input type="text" name="groupname" disabled style="input-style1"></td>
                 </td>
               </tr>
               <tr>
                 <td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</td>
                 <td height="22"><input type="text" name="ringlabel" disabled style="input-style1"></td>
               </tr>
                  <%
                   String typeDisplay = "none";
                   if("1".equals(useringsource)){
                    typeDisplay = "";
                    }
                %>
               <tr style="display:<%= typeDisplay %>">
                 <td height="22" align="right"><%=ringsourcename%></td>
                 <td height="22"><input type="text" name="ringsource" disabled style="input-style1"></td>
               </tr>

               <tr>
                 <td height="22" align="right">Price (<%=minorcurrency%>)</td>
                 <td height="22"><input type="text" name="ringfee" disabled style="input-style1"></td>
               </tr> 
                          <tr>
                <td height="22" align="right">Refuse</td>
                <td>
                <table border="0" width="100%" class="table-style2">
                <tr align="center">
                  <td width="50%"><input type="radio" checked name="ischeck" value="0" onclick="OnRadioCheck()" checked >Select</td>
                  <td width="50%"><input type="radio" name="ischeck" value="1" onclick="OnRadioCheck()" >Input</td>
                 </tr>
                 </table>
                 </td>
               </tr>
               <tr>
                   <td height="22" align="right">Refuse reason</td>
                   <td height="22" style='display:block' id="id_select" >
                   <select name="refusecomment" class="input-style1">
                 <%
                   Vector refuseComment = refuseComment();
                   for (int i = 0; i < refuseComment.size(); i++) {
                  %>
                     <option value="<%= i %>"><%= (String)refuseComment.get(i) %></option>
                  <%
                   }
                  %>
                  </select>
                 </td>
                  <td height="22" style="display:none" id="id_text" ><input type="text" name="reason" maxlength="100" value="" style="input-style1"></td>
                 </tr>
                </table>
           </td>
           </tr>
         <tr>
          <td align="center" colspan=2 height=40>
            <table border="0" width="85%" class="table-style2" align="center">
              <tr >
                <td width="20%" align="center" ><input type='button' style="width:150px"  value="Preview" onclick="javascript:tryListen()"> </td>
                <td width="20%" align="center" ><input type='button' style="width:150px"  name="checkpass1" value="Contents pass" onclick="javascript:checkpass(1)"></td>
                <td width="20%" align="center" ><input type='button' style="width:150px"  name="checkpass2"   value="Contents refuse"  onclick="javascript:checkpass(2)"></td>
              </tr>
              <tr>
                <td width="20%" align="center" ><input type='button' style="width:150px" name="checkpass3" value="Charge pass" onclick="javascript:checkpass(3)"></td>
                <td width="20%" align="center" ><input type='button' style="width:150px" name="checkpass4" value="Charge refuse" onclick="javascript:checkpass(4)"></td>
              </tr>
            </table>
          </td>
        </tr>
 </table>
</form>
<script language="javascript">
</script>
<%
        }
        else {
              if(operID== null){
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
        sysInfo.add(sysTime + operName + " Exception occurred in verifying group ringtones!");//集团铃音审核过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + " Error occurred in verifying group ringtones!");//集团铃音审核出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="checkGrpRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
