<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<jsp:useBean id="db" class="zxyw50.SpManage" scope="page" />
<jsp:setProperty name="db" property="*" />
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<html>
<head>
<title>Manage ringtone in music box</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">

<%
   //String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);


 //add by ge quanmin 2005-07-07
 String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","Provider");
    ringsourcename=transferString(ringsourcename);
//end
String userday = CrbtUtil.getConfig("uservalidday","0");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String spIndex = (String)session.getAttribute("SPINDEX");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");


	 String ringgroup=(String)session.getAttribute("RINGGROUP");
	 String grouplabel=(String)session.getAttribute("GROUPLABEL");

    try {
        manSysRing sysring = new manSysRing();
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
		sysTime = sysring.getSysTime() + "--";

		String errMsg="";
		boolean alertflag=false;
		if (spIndex  == null || spIndex.equals("-1")){
			errMsg = "Sorry,you are not manager!";
			alertflag=true;
		}
        else if (purviewList.get("10-7") == null)  {
			errMsg = "Sorry,you have no right to access this function!";
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
        	throw new Exception("The name of ringtone is too long,please re-enter!");//您输入的Ringtone name超过长度限制,请您重新输入!
        String ringauthor = request.getParameter("ringauthor") == null ? "" : transferString((String)request.getParameter("ringauthor"));
        if(checkLen(ringauthor,40))
        	throw new Exception("The name of artist is too long,please re-enter!");//您输入的Artist name长度超出限制,请重新输入!
        String price = request.getParameter("price") == null ? "" : (String)request.getParameter("price");
        String validate = request.getParameter("validate")==null?"":(String)request.getParameter("validate");
		String ringsource = request.getParameter("ringsource")==null?"":transferString((String)request.getParameter("ringsource"));
		if(checkLen(ringsource,40))
			throw new Exception("The name of provider is too long,please re-enter!");//您输入的铃音提供商长度超过限制,请重新输入!
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
                map.put("OPERTYPE","1007");
                map.put("RESULT","1");
                map.put("PARA1",crid);
                map.put("PARA2",ringLabel);
                map.put("PARA3",ringauthor);
                map.put("PARA4",validdate);
                map.put("PARA5",price);
                map.put("PARA6","ip:"+request.getRemoteAddr());
                // 如果是Edit铃声标签
                ArrayList  rList = new ArrayList();
			}
            if (op.equals("del")) {
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

   function tryListen () {
      fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert('Please select the ringtone before try-listrn!');
         return;
      }
      var tryURL = '../manager/tryListen.jsp?ringid=' + fm.crid.value+'&ringname='+fm.ringLabel.value+'&ringauthor='+fm.ringauthor.value;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }
    function ringInfo () {
      fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert('Please select the ringtone before view detail!');
         return;
      }
      infoWin = window.open('../ringinfo.jsp?ringid=' + fm.crid.value,'infoWin','width=400, height=340');
   }

 function addMember () {
      fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert('Please select the ringtone before add');
         return;
      }
      var userday='';
      <%if(userday.equalsIgnoreCase("1"))
                    {%>
                    userday = '&uservalidday='+fm.uservalidday.value
                  <%}%>
      var newurl='musicboxMemberAddEnd.jsp?ringid='+fm.crid.value+'&ringfee='+fm.price.value+'&ringlabel='+fm.ringLabel.value+'&singgername='+fm.ringauthor.value+'&validdate='+fm.validdate.value+'&ringspell='+fm.ringspell.value+userday;
      window.document.location.href = newurl;
   }
 function comeBack () {
     window.parent.location.href = 'musicboxMember.jsp?ringgroup='+<%=ringgroup%>+'&grouplabel='+<%="'"+grouplabel+"'"%>
   }

</script>
<form name="inputForm" method="post" action="musicboxMemberEdit.jsp">
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
          <td height="22" align="right">Ringtone sort library</td>
          <td><input type="text" name="ringlibname" value="<%= Pos %>" maxlength="40" class="input-style0" readonly></td>
        </tr>
        <tr>
          <td height="22" align="right" valign="center">Ringtone code</td>
          <td height="22" valign="center"><input type="text" name="ringid"  maxlength="20" class="input-style0" disabled ></td>
        </tr>
        <tr>
          <td height="22" align="right" valign="center">Ringtone name</td>
          <td height="22" valign="center"><input type="text" name="ringLabel"  maxlength="40" class="input-style0"></td>
        </tr>
        <tr>
          <td height="22" align="right" valign="center">Ringtone speeling</td>
          <td height="22" valign="center"><input type="text" name="ringspell"  maxlength="20" class="input-style0"></td>
        </tr>
        <tr>
          <td height="22" align="right" valign="center">Artist name</td>
          <td height="22" valign="center"><input type="text" name="ringauthor"  maxlength="40" class="input-style0"  readonly ></td>
        </tr>
        <%if(useringsource.equals("1")){//modify by ge quanmin 2005-07-07%%>
        <tr>
          <td height="22" align="right" valign="center"><%=ringsourcename%></td>
          <td height="22" valign="center"><input type="text" name="ringsource"  maxlength="40" class="input-style0"></td>
        </tr>
         <%}%>
        <tr>
          <td height="22" align="right">Price(<%=minorcurrency%>)</td>
          <td height="22"><input type="text" name="price"  maxlength="5" class="input-style0" readonly ></td>
        </tr>
                              <%if(userday.equalsIgnoreCase("1"))
                    {%>
        <%//begin add Validity%>
        <tr>
          <td align="right">Validity(day)</td>
          <td><input type="text"  readonly name="uservalidday" value="0" maxlength="4" class="input-style0"></td>
        </tr>
        <%}//end%>
        <tr>
          <td height="22" align="right">Validate(YYYY.MM.DD)</td>
          <td height="22"><input type="text" name="validdate"  maxlength="10" class="input-style0" readonly ></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="33%" align="center"><img src="../button/trylisten.gif" width="45" height="19" onclick="javascript:tryListen()" onmouseover="this.style.cursor='hand'"></td>
                <td width="33%" align="center"><img src="../button/sure.gif" width="45" height="19" onclick="javascript:addMember()" onmouseover="this.style.cursor='hand'"></td>
                <td width="33%" align="center"><img src="../button/back.gif" width="45" height="19" onclick="javascript:comeBack()" onmouseover="this.style.cursor='hand'"></td>
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
			errMsg = "Please log in first!";
			alertflag=true;
        }if(alertflag==true){
%>
<script language="javascript">
   var errorMsg = '<%= operID!=null?errMsg:"Please log in first!"%>';
   alert(errorMsg);
   parent.document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in adding SP musci box!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + " errors occurred in adding SP musci box!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="musicboxMemberEdit.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
