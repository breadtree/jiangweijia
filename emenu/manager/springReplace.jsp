<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="com.zte.zxywpub.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@page import="zte.zxyw50.util.JCalendar"%>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="zxyw50.SpManage" scope="page" />
<jsp:setProperty name="db" property="*" />
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<title>System ringtone uploading</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%!
int isfarsicalendar = zte.zxyw50.util.CrbtUtil.getConfig("isfarsicalendar", 0);
JCalendar cal = new JCalendar();
public String jcalendar(String str){
	if(isfarsicalendar == 1){
		str = cal.gregorianToPersian(str); 
	}	
	return str;
}
%>
<%
	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	int ratio = Integer.parseInt(currencyratio);




int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
 String useringsource=CrbtUtil.getConfig("useringsource","0");
 String ringsourcename=CrbtUtil.getConfig("ringsourcename","ringtone producer");
 ringsourcename=transferString(ringsourcename);
String sysTime = "";
Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
String operID = (String)session.getAttribute("OPERID");
String operName = (String)session.getAttribute("OPERNAME");
String ringlibid = request.getParameter("ringlibid") == null ? "" : (String)request.getParameter("ringlibid");
Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
String ringlibname = request.getParameter("ringlibname") == null ? "" : transferString((String)request.getParameter("ringlibname"));
String ringindex = request.getParameter("ringindex") == null ? "" : (String)request.getParameter("ringindex");
String hidemediatype = request.getParameter("hidemediatype") == null ? "" : (String)request.getParameter("hidemediatype");
try {
  manSysRing sysring = new manSysRing();
  sysTime = sysring.getSysTime() + "--";
  String op = request.getParameter("op") == null ? null : (String)request.getParameter("op");
  int flag = 0;
  String errMsg="";
  boolean alertflag=false;
  if (purviewList.get("2-20") == null)  {
    errMsg = "You have no right to access this function!";
    alertflag=true;
  }
  else if (operID != null) {
    Vector vet = new Vector();
    Hashtable hash = new Hashtable();
    if (op != null) {
      SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
      String filename = request.getParameter("ringfile") == null ? "" : transferString((String)request.getParameter("ringfile"));
      String crid = request.getParameter("crid") == null ? "" : transferString((String)request.getParameter("crid"));
      hash.put("crid",crid);
      hash.put("ringindex",ringindex);
      hash.put("filename",filename);
      sysring.ringReplace(pool,hash);
      sysInfo.add(sysTime + operName + "Replace system tone " + crid + " successfully!");
%>
<script language="javascript">
   alert('Replace <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> susccessfully!');//铃音置换成功!
</script>
<%
// 准备写操作员日志
zxyw50.Purview purview = new zxyw50.Purview();
HashMap map = new HashMap();
map.put("OPERID",operID);
map.put("OPERNAME",operName);
map.put("OPERTYPE","220");
map.put("RESULT","1");
map.put("PARA1",crid);
map.put("PARA2",filename);
map.put("PARA3","ip:"+request.getRemoteAddr());
purview.writeLog(map);
}
String Pos = "";
String ringlibcode = "";
Vector vetRing = new Vector();
if(ringlibid.length()>0){
  Hashtable hLib=  sysring.getRingLibraryNode(ringlibid);
  if(hLib!=null && hLib.size()>0){
    Pos = Pos + (String)hLib.get("ringliblabel");
    ringlibcode = ringlibcode + (String)hLib.get("ringlibcode");
  }
  vetRing = sysring.ManRingList(ringlibid,hidemediatype);
}
%>
<script language="javascript">
   var v_ringid = new Array(<%= vetRing.size() + "" %>);
   var v_ringindex = new Array(<%= vetRing.size() + "" %>);
   var v_ringlabel = new Array(<%= vetRing.size() + "" %>);
   if(<%=issupportmultipleprice%> == 1){
   var v_ringfee2 = new Array(<%= vetRing.size() + "" %>);
   }
   var v_ringfee = new Array(<%= vetRing.size() + "" %>);
   var v_ringsource = new Array(<%= vetRing.size() + "" %>);
   var v_singerid = new Array(<%= vetRing.size() + "" %>);
   var v_singername = new Array(<%= vetRing.size() + "" %>);
   var v_validdate = new Array(<%= vetRing.size() + "" %>);
   var v_ringspell = new Array(<%= vetRing.size() + "" %>);
  <%
       for (int i = 0; i < vetRing.size(); i++) {
                hash = (Hashtable)vetRing.get(i);
 %>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringindex[<%= i + "" %>] = '<%= (String)hash.get("ringindex") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
   if(<%=issupportmultipleprice%> == 1){
   v_ringfee2[<%= i + "" %>] = '<%= (String)hash.get("ringfee2") %>';
   }
   v_ringfee[<%= i + "" %>] = '<%= (String)hash.get("ringfee") %>';
   v_ringsource[<%= i + "" %>] = '<%= (String)hash.get("ringsource") %>';
   v_singerid[<%= i + "" %>] = '<%= (String)hash.get("singerid") %>';
   v_singername[<%= i + "" %>] = '<%= (String)hash.get("ringauthor") %>';
   v_validdate[<%= i + "" %>] = '<%= jcalendar((String)hash.get("validate")) %>';
   v_ringspell[<%= i + "" %>] = '<%= (String)hash.get("ringspell") %>';

<%
            }
%>

  function selectSysRing () {
      var fm = document.inputForm;
      var index = fm.personalRing.value;
      if (index == null)
         return;
      if (index == '') {
         return;
      }
      fm.crid.value = v_ringid[index];
      fm.ringindex.value = v_ringindex[index];
      fm.ringname.value = v_ringlabel[index];
      if(<%=issupportmultipleprice%> == 1){
	  fm.dailyprice.value = v_ringfee2[index];
	  }
      fm.monthlyprice.value = v_ringfee[index];
      fm.ringauthor.value = v_singername[index];
      if(<%= useringsource%> == 1){
         fm.ringsource.value = v_ringsource[index];
      }

      fm.validdate.value = v_validdate[index];
      fm.ringpell.value = v_ringspell[index];
   }


   function upload () {
      var fm = document.inputForm;
      if (trim(fm.ringlibid.value) == '') {
         alert('Select <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category library!');//请选择铃音分类库!
         return;
      }
      if(fm.personalRing.selectedIndex == -1){
         alert('Please select <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> first!');//请先选择铃音!
         return;
      }
	  if (trim(fm.filename.value) == '') {
         alert('Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> file to be replaced!');//请先选择您要置换的铃音文件!
         return;
      }
      fm.ringname.disabled = false;
      fm.op.value = 'replace';
      fm.submit();
   }

   function selectFile () {
      var fm = document.inputForm;
      if (trim(fm.ringlibid.value) == '') {
         alert('Please select <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category library!');//请选择铃音分类库!
         return;
      }
      if(fm.personalRing.selectedIndex == -1){
         alert('Please select <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> first!');//请先选择铃音!
         return;
      }
      var uploadURL = 'ringReplace.jsp?ringlibid=' + fm.ringlibid.value;
      uploadRing = window.open(uploadURL,'upload','width=400, height=200');
   }

   function selectLib () {
      var fm = document.inputForm;
      var lib = fm.ringlibid.value;
   }

   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.ringfile.value = name;
      fm.filename.value = label;
      fm.ringname.value = label.substring(0,label.length - 4);
   }
</script>

<form name="inputForm" method="post" action="springReplace.jsp">
<input type="hidden" name="ringfile" value="">
<input type="hidden" name="crid" value="">
<input type="hidden" name="ringindex" value="">
<input type="hidden" name="ringlibid" value="<%= ringlibid %>">
<input type="hidden" name="op" value="">
<table width="377" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
 <tr>
    <td><img src="../manager/image/007.gif" width="377" height="15"></td>
  </tr>
  <tr>
    <td background="../manager/image/009.gif" width="377">
      <table border="0" align="center" class="table-style2" width="377">
        <tr>
         <td rowspan="10" valign="top">
            <select name="personalRing" size="25" <%= vetRing.size() == 0 ? "disabled " : "" %>onclick="javascript:selectSysRing()" class="input-style1" style="width: 150;">
<%
                Hashtable tmp = null;
                for (int i = 0; i < vetRing.size(); i++) {
                    tmp = (Hashtable)vetRing.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)tmp.get("ringlabel") %></option>
<%
            }
%>
            </select>
          </td>
          <td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category library</td>
          <td><input type="text" name="ringlibname" value="<%= Pos %>" maxlength="40" class="input-style0" readonly></td>
        </tr>
        <tr>
          <td align="right">Category code</td>
          <td><input type="text" name="ringlibcode" value="<%= ringlibcode %>" disabled class="input-style0" ></td>
        </tr>
        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
          <td><input type="text" name="ringname" value="" maxlength="40" class="input-style0" disabled ></td>
        </tr>
         <tr>
          <td align="right">Spell of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
          <td><input type="text" name="ringpell" value="" maxlength="20" class="input-style0" disabled ></td>
        </tr>
        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></td>
          <td><input type="text" name="ringauthor" value="" maxlength="40" class="input-style0" disabled ></td>
        </tr>
        <%if(useringsource.equals("1")){//modify by ge quanmin 2005-07-07%%>
        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> provider</td>
          <td><input type="text" name="ringsource" value="" maxlength="40" class="input-style0" disabled  ></td>
        </tr>
         <%}%>
         <%if(issupportmultipleprice == 1){%>
		  <tr>
          <td align="right">Daily Price(<%=minorcurrency%>)</td>
          <td><input type="text" name="dailyprice" value="" maxlength="5" class="input-style0" disabled ></td>
        </tr>
        <%}%>
        <tr>
          <td align="right"><%if(issupportmultipleprice == 1){%>Monthly <%}%> Price(<%=minorcurrency%>)</td>
          <td><input type="text" name="monthlyprice" value="" maxlength="5" class="input-style0" disabled ></td>
        </tr>
		<tr>
          <td align="right">Validity period(yyyy.mm.dd)</td>
          <td><input type="text" name="validdate" value="" maxlength="10" class="input-style0" disabled ></td>
        </tr>
         <tr>
          <td align="right">Replace files</td>
          <td><input type="text" name="filename" value="" disabled class="input-style0"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="right"><img src="../button/file.gif" width="45" height="19" onclick="javascript:selectFile()" onmouseover="this.style.cursor='hand'"> &nbsp;&nbsp;</td>
                <td width="50%" >&nbsp;&nbsp;&nbsp;&nbsp;<img src="../button/replace.gif" width="45" height="19" onclick="javascript:upload()" onmouseover="this.style.cursor='hand'"></td>
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
<script language="javascript">
   document.inputForm.ringlibid.value = '<%= ringlibid %>';
   selectLib();

   <% if(!ringindex.equals("")){
  for (int i = 0; i < vetRing.size(); i++) {
%>
if(v_ringindex[<%= i + "" %>] == '<%=ringindex%>'){
  document.inputForm.personalRing.value = '<%= i + "" %>';
  selectSysRing ()
}

<%
}
}
%>

</script>
<%
        }
        else {
			errMsg = "Please log in to the system first!";
			alertflag=true;
        }if(alertflag==true){
%>
<script language="javascript">
   var errorMsg = '<%= operID!=null?errMsg:"Please log in to the system first!"%>';
   alert(errorMsg);
   parent.document.URL = 'enter.jsp';
</script>
<%  }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "It is abnormal during the tone uploading!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the tone uploading!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="springReplace.html">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
