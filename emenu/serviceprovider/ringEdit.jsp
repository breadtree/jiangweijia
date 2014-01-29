<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<jsp:useBean id="db" class="zxyw50.SpManage" scope="page" />
<jsp:setProperty name="db" property="*" />
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
        ywaccess oYwAccess = new ywaccess();
    int cmpval = oYwAccess.getParameter(52);
%>

<html>
<head>
<title>Manage system ringtones</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">

<%
	//String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
	String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");

String userday = CrbtUtil.getConfig("uservalidday","0");
    //add by gequanmin 2005-07-08
    String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","Provider");
    ringsourcename=transferString(ringsourcename);
    //end
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String spIndex = (String)session.getAttribute("SPINDEX");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysRing sysring = new manSysRing();
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
		sysTime = sysring.getSysTime() + "--";

		String errMsg="";
		boolean alertflag=false;
		if (spIndex  == null || spIndex.equals("-1")){
			errMsg = "Sorry, you are not an SP administrator!";//Sorry,you are not the SP administrator
			alertflag=true;
		}
        else if (purviewList.get("10-2") == null)  {
			errMsg = "No access to this function.";//无权访问此功能
			alertflag=true;
        }

        else if (operID != null) {
		Hashtable tmph = new Hashtable();
	    String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String crid = request.getParameter("crid") == null ? "" : (String)request.getParameter("crid");
        String craccount = request.getParameter("ringlibid") == null ? "" : transferString((String)request.getParameter("ringlibid"));
        String ringlibcode = request.getParameter("ringlibcode") == null ? "" : transferString((String)request.getParameter("ringlibcode"));
        String Pos = request.getParameter("Pos") == null ? "" : transferString((String)request.getParameter("Pos"));

        String ringLabel = request.getParameter("ringLabel") == null ? "" : transferString((String)request.getParameter("ringLabel"));
        if(checkLen(ringLabel,40))
        	throw new Exception("The length of the ringtone name you entered has exceeded the limit. Please re-enter!");//您输入的Ringtone name长度超出限制,请重新输入!
        String ringauthor = request.getParameter("ringauthor") == null ? "" : transferString((String)request.getParameter("ringauthor"));
        if(checkLen(ringauthor,40))
        	throw new Exception("The length of the artist name you entered has exceeded the limit. Please re-enter!");//您输入的Artist name长度超出限制,请重新输入!
        String price = request.getParameter("price") == null ? "" : (String)request.getParameter("price");
        String validate = request.getParameter("validate")==null?"":(String)request.getParameter("validate");
		String ringsource = request.getParameter("ringsource")==null?"":transferString((String)request.getParameter("ringsource"));
		if(checkLen(ringsource,40))
			throw new Exception("The name of the SP you entered is too long. Please re-enter!");//您输入的铃音提供商长度超过限制,请重新输入
		String ringoption = "";
        String validdate = request.getParameter("validdate") == null ? "" : (String)request.getParameter("validdate");
        String ringspell = request.getParameter("ringspell") == null ? "" : (String)request.getParameter("ringspell");

		Hashtable hash = new Hashtable();
        Hashtable tmp = new Hashtable();
        Vector vetRing = new Vector();
        Vector sysRing = new Vector();
        Vector ringInfo = new Vector();
		int ringCount = 0;
        Hashtable result = new Hashtable();

            Vector vetLib = sysring.getRingLibraryInfo();
            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            if (craccount != null) {
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERTYPE","1001");
                map.put("RESULT","1");
                map.put("PARA1",crid);
                map.put("PARA2",ringLabel);
                map.put("PARA3",ringauthor);
                map.put("PARA4",validdate);
                map.put("PARA5",price);
                map.put("PARA6","ip:"+request.getRemoteAddr());
                // 如果是Edit铃声标签
                ArrayList  rList = new ArrayList();
                if (op.equals("edit")) {
                    hash.put("usernumber",craccount);
                    hash.put("ringid",crid);
                    hash.put("ringlabel",ringLabel);
                    hash.put("ringfee",price);
                    hash.put("ringauthor",ringauthor);
                    hash.put("ringsource",ringsource);
                    hash.put("validdate",validdate);
                    hash.put("ringspell",ringspell);
                       //begin add validity
                   hash.put("uservalidday",request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday"));
                  //end
                   hash.put("iffree","-1");
                    rList = sysring.editSysRingLabel(hash);
                    sysInfo.add(sysTime + operName + "Ringtone info modified successfully!");
                    map.put("DESCRIPTION","Edit");
                    purview.writeLog(map);
                    if(rList.size()>0){
                      session.setAttribute("rList",rList);
                    %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="ringEdit.jsp?ringlibid=<%= craccount  %>">
<input type="hidden" name="title" value="Modify system ringtone">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
                   <%
                   }


                }
                // 如果是删除铃音
                if (op.equals("del")) {
                    ringCount = sysring.getSysRingCount(crid) - 1;
                    if (ringCount > 0)
                        throw new Exception("The ringtone is in use by " + ringCount + "  subscribers!");//铃音已经被  个用户使用
                    // 如果铃音没有被使用,直接删除
                    if (sysRing.size() == 0)
                        op = "delend";
                }
                // 如果是删除铃音,已经被确认
                if (op.equals("delend")) {
                    hash.put("opcode","01010203");
                    hash.put("craccount",ringlibcode);
                    hash.put("crid",crid);
                    hash.put("ret1","");
                    hash.put("ringidtype","1");
                    result = SocketPortocol.send(pool,hash);
                    sysInfo.add(sysTime + operName + "delete ringtone successfully!");
                    map.put("DESCRIPTION","Delete");
                    purview.writeLog(map);
                }
			}
            if (op.equals("del")) {
%>

<form name="inputForm" method="post" action="ringEdit.jsp">
<input type="hidden" name="crid" value="<%= crid %>">
<input type="hidden" name="op" value="delend">
<input type="hidden" name="Pos" value="<%= Pos %>">
<input type="hidden" name="ringlibid" value="<%= craccount == null ? "" : craccount %>">
<table border="0" cellspacing="0" cellpadding="0" align="center" valign="middle" width="60%" class="table-style2" >
  <tr>
    <td colspan="2" align="center" class="text-title">Ringtone usage info</td>
  </tr>

  <tr><td colspan="2">This ringtone has been used by<%= ringCount %>subscribers!</td></tr>

  <tr>
    <td width="50%" align="center"><img src="../button/sure.gif" width="45" height="19" onclick="javascript:confirmdel()" onmouseover="this.style.cursor='hand'"></td>
    <td width="50%" align="center"><img src="../button/cancel.gif" width="45" height="19" onclick="javascript:document.inputForm.op.value='';document.inputForm.submit()" onmouseover="this.style.cursor='hand'"></td>
  </tr>
</table>
</form>
<script language="javascript">
   alert("The ringtone you want to delete is still in use. \r\n If this ringtone is deleted, all related info will be lost. \r\n You select Cancel to cancel deleting this ringtone!");//您选择删除的铃音尚在使用,\r\n如果删除该铃音将会丢失所有相关信息,\r\n您选择“取消”而不删除该铃音!
</script>
<%
            }
            else {
            // 查询铃音
            if(craccount==null || craccount.length()==0)
				craccount="-1";
		  hash = new Hashtable();
		  hash.put("spindex",spIndex);
		  hash.put("ringlibid",craccount);

		  hash.put("sortby","buytimes");
		  vetRing = db.spManRingList(hash);
                  ringlibcode = "";

          Hashtable hLib=  sysring.getRingLibraryNode(craccount);

          if(hLib!=null && hLib.size()>0)

             ringlibcode = (String)hLib.get("ringlibcode");

%>
<script language="javascript">
   var v_ringid = new Array(<%= vetRing.size() + "" %>);
   var v_ringlabel = new Array(<%= vetRing.size() + "" %>);
   var v_ringfee = new Array(<%= vetRing.size() + "" %>);
   var v_ringsource = new Array(<%= vetRing.size() + "" %>);
   var v_singerid = new Array(<%= vetRing.size() + "" %>);
   var v_singername = new Array(<%= vetRing.size() + "" %>);
   var v_validdate = new Array(<%= vetRing.size() + "" %>);
   var v_ringspell = new Array(<%= vetRing.size() + "" %>);
          <%if(userday.equalsIgnoreCase("1"))
                    {%>
 var v_uservalidday = new Array(<%= vetRing.size() + "" %>);
<%}%>

<%
            for (int i = 0; i < vetRing.size(); i++) {
                hash = (Hashtable)vetRing.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
   v_ringfee[<%= i + "" %>] = '<%= (String)hash.get("ringfee") %>';
   v_ringsource[<%= i + "" %>] = '<%= (String)hash.get("ringsource") %>';
   v_singerid[<%= i + "" %>] = '<%= (String)hash.get("singerid") %>';
   v_singername[<%= i + "" %>] = '<%= (String)hash.get("ringauthor") %>';
   v_validdate[<%= i + "" %>] = '<%= (String)hash.get("validate") %>';
   v_ringspell[<%= i + "" %>] = '<%= (String)hash.get("ringspell") %>';
       <%if(userday.equalsIgnoreCase("1"))
                    {%>
v_uservalidday[<%= i + "" %>] = '<%= (String)hash.get("uservalidday") %>';
<%}%>
<%
            }
%>


   function selectSysRing () {
      var fm = document.inputForm;
      var index = fm.personalRing.value;
      if (index == null)
         return;
      if (index == '') {
         fm.ringLabel.focus();
         return;
      }
      fm.crid.value = v_ringid[index];
      fm.ringid.value = v_ringid[index];
      fm.ringLabel.value = v_ringlabel[index];
      fm.price.value = v_ringfee[index];
      fm.ringauthor.value = v_singername[index];
      fm.ringsource.value = v_ringsource[index];
      fm.validdate.value = v_validdate[index];
      fm.ringspell.value = v_ringspell[index];
             <%if(userday.equalsIgnoreCase("1"))
                    {%>
      fm.uservalidday.value = v_uservalidday[index];
      <%}%>

      fm.ringLabel.focus();
   }

   function checkfee (fee) {
   	  if(fee.length==0)
			return false;
      var tmp = '';
      for (i = 0; i < fee.length; i++) {
         tmp = fee.substring(i, i + 1);
         if (tmp < '0' || tmp > '9')
            return false;
      }
      return true;
   }

   function edit () {
      var fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert("Please select the ring to edit!");
         return;
      }
      if (trim(fm.ringLabel.value) == '') {
         alert("Please enter a ringtone name!");//请输入Ringtone name
         fm.ringLabel.focus();
         return;
      }
       if (!CheckInputStr(fm.ringLabel,'ringtone name')){
         fm.ringLabel.focus();
         return  ;
      }
      if (trim(fm.ringspell.value) == '') {
         alert("Please enter the spelling of a ringtone name");//请输入铃音拼音
         fm.ringspell.focus();
         return;
      }
      if(!CheckInputChar1(fm.ringspell,'ringtone spelling')){
      	fm.ringspell.focus();
      	return;
      }
       if (trim(fm.ringauthor.value) == '') {
         alert("Please enter an artist name");//请输入Artist name
         fm.ringauthor.focus();
         return;
      }
      if (!CheckInputStr(fm.ringauthor,'name of artist')){
         fm.ringauthor.focus();
         return  ;
      }
       //modify by ge quanmin 2005-07-07
      <%if(useringsource.equals("1")){%>
       if (trim(fm.ringsource.value) == '') {
         alert("please input provider name!");
         fm.ringsource.focus();
         return;
      }
      if (!CheckInputStr(fm.ringsource,"provider")){
         fm.ringsource.focus();
         return;
      }
     <%}%>
      if (! checkfee(trim(fm.price.value))) {
         alert("Invalid price:);//铃音价格错误
         fm.price.focus();
         return;
      }
       <%if(userday.equalsIgnoreCase("1"))
                    {%>
                    //begin add validity
                    var tmp1 = trim(fm.uservalidday.value);
                    if ( tmp1 == '') {
                      alert("please input user validate!");
                      fm.uservalidday.focus();
                      return ;
                    }
                    if (!checkstring('0123456789',tmp1)) {
                      alert("uservalidate must be digital number!");
                      fm.uservalidday.focus();
                      return ;
                    }
                    //end
                  <%}%>
      var validdate = trim(fm.validdate.value);
      if(validdate==''){
          alert("Please enter an expiration date");//请输入铃音有效期
          fm.validdate.focus();
          return ;
      }
      if(!checkDate2(validdate)){
          alert("The expiration date entered is incorrect. Please re-enter!");//铃音有效期输入不正确,请重新输入
          fm.validdate.focus();
          return ;
      }
      if(checktrue2(validdate)){
          alert("The expiration date cannot be earlier than the current time. Please re-enter!");//铃音有效期不能低于当前时间,请重新输入
          fm.validdate.focus();
          return ;
      }

      if(checktrueyear(validdate,'<%=expireTime%>')){
         alert("The validate can not earlier than <%=expireTime%>, please re-enter!");
          fm.validdate.focus();
          return ;
      }

      fm.op.value = 'edit';
      fm.submit();
   }

   function del () {
      var fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert("Please select the ringtone to be modified");//请先选择需要修改的铃音
         return;
      }
      fm.op.value = 'del';
      fm.submit();
   }

   function tryListen () {
      fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert("Please select a ring back tone before listening!");//请先选择铃音,再试听
         return;
      }
      var tryURL = '../manager/tryListen.jsp?ringid=' + fm.crid.value+'&ringname='+fm.ringLabel.value+'&ringauthor='+fm.ringauthor.value;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }
    function ringInfo () {
      fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert("Please select a ringtone before view its info!");//请先选择铃音,再查看它的信息!
         return;
      }
      infoWin = window.open('../ringinfo.jsp?ringid=' + fm.crid.value,'infoWin','width=400, height=340');
   }

</script>
<form name="inputForm" method="post" action="ringEdit.jsp">
<input type="hidden" name="crid" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="Pos" value="<%= Pos %>">
<input type="hidden" name="ringlibcode" value="<%= ringlibcode %>">
<input type="hidden" name="ringlibid" value="<%= craccount == null ? "" : craccount %>">
<table width="377" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
	<tr>
    <td><img src="../manager/image/007.gif" width="377" height="15"></td>
  </tr>
  <tr>
    <td background="../manager/image/009.gif" width="377">
      <table border="0" align="center" class="table-style2" width="377">
        <tr>
          <td rowspan="9" valign="top">
            <select name="personalRing" size="16" <%= vetRing.size() == 0 ? "disabled " : "" %>onclick="javascript:selectSysRing()" class="input-style1" style="width: 120;">
<%
                for (int i = 0; i < vetRing.size(); i++) {
                    tmp = (Hashtable)vetRing.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)tmp.get("ringlabel") %></option>
<%
            }
%>
            </select>
          </td>
          <td height="22" align="right">Ringtone  library</td>
          <td><input type="text" name="ringlibname" value="<%= Pos %>" maxlength="40" class="input-style0" readonly></td>
        </tr>
        <tr>
          <td height="22" align="right" valign="center">Ringtone code</td>
          <td height="22" valign="center"><input type="text" name="ringid"  maxlength="20" class="input-style0" disabled ></td>
        </tr>
        <tr>
          <td height="22" align="right" valign="center">Ringtone name</td>
          <td height="22" valign="center"><input type="text" name="ringLabel"  maxlength="40" class="input-style0" readonly></td>
        </tr>
        <tr>
          <td height="22" align="right" valign="center">Spelling of ringtone</td>
          <td height="22" valign="center"><input type="text" name="ringspell"  maxlength="20" class="input-style0" readonly></td>
        </tr>
        <tr>
          <td height="22" align="right" valign="center">artists name</td>
          <td height="22" valign="center"><input type="text" name="ringauthor"  maxlength="40" class="input-style0" readonly></td>
        </tr>
         <%if(useringsource.equals("1")){//modify by ge quanmin 2005-07-07%%>
        <tr>
          <td height="22" align="right" valign="center"><%=ringsourcename%></td>
          <td height="22" valign="center"><input type="text" name="ringsource"  maxlength="40" class="input-style0" readonly></td>
        </tr>
        <%}%>
        <tr>
          <td height="22" align="right">Ringtone price (<%=minorcurrency%>)</td>
          <td height="22"><input type="text" name="price"  maxlength="5" class="input-style0" readonly></td>
        </tr>
                       <%if(userday.equalsIgnoreCase("1"))
                    {%>
        <%//begin add validate%>
        <tr>
          <td align="right">validate(days)</td>
          <td><input type="text"  readonly name="uservalidday" value="0" maxlength="4" class="input-style0"></td>
        </tr>
        <%}//end%>
        <tr>
          <td height="22" align="right">Period of Validity(yyyy.mm.dd)</td>
          <td height="22"><input type="text" name="validdate"  maxlength="10" class="input-style0"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="33%" align="center"><img src="../button/trylisten.gif" width="45" height="19" onclick="javascript:tryListen()" onmouseover="this.style.cursor='hand'"></td>
                <td width="34%" align="center"><img src="../button/edit.gif" width="45" height="19" onclick="javascript:edit()" onmouseover="this.style.cursor='hand'"></td>
                <td width="33%" align="center"><img src="../button/del.gif" width="45" height="19" onclick="javascript:del()" onmouseover="this.style.cursor='hand'"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td><img src="../manager/image/008.gif" width="377" height="15"></td>
  </tr>
</table>
</form>
<%
            }
        }else{
			errMsg = "Please log in to the system first!";
			alertflag=true;
        }if(alertflag==true){
%>
<script language="javascript">
   var errorMsg = '<%= operID!=null?errMsg:"Please log in to the system first!"%>';
   alert(errorMsg);
   parent.document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + ",Exception occurred in managing SP ring back tones!");//管理SP铃音过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + ",Error occurred in managing SP ring back tones!");//管理SP铃音出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="ringEdit.html">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
