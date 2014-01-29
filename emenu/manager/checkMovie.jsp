<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.manSysPara" %>
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
        vet.add("The movie audit don't pass");
        vet.add("The movie property config aren't exactly");
        vet.add("The movie name has already exist");
        vet.add("The movie price is unreasonable");
        vet.add("Unknown reason");
        return vet;
    }
%>

<html>

<head>
<title>The Movie audit</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>

<body background="background.gif" class="body-style1">
<%
	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	int ratio = Integer.parseInt(currencyratio);
	int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0);

    String sysTime = "";
    String jName = (String)application.getAttribute("JNAME");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    try {
        //SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        int operflag = 0; 
        if(purviewList.get("6-11") != null)
           operflag = 1;
        if(operflag ==0 || operID==null) {
			%>
			<script language="javascript">
				alert('<%= operID == null ? "Please log in to  the system frist!" : "You have not access to the function!" %>');
				document.URL = 'enter.jsp';
			</script>
			<%
        } else if (operID != null) {
            String qryRingName = request.getParameter("qryRingName") == null ? "" : transferString((String)request.getParameter("qryRingName")).trim();
            String ringindex = request.getParameter("ringindex") == null ? "" : ((String)request.getParameter("ringindex")).trim();
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String refusecomment = request.getParameter("reasontext") == null ? "": transferString((String)request.getParameter("reasontext")).trim();
            //String ringname = request.getParameter("ringlabel") == null ? "" : ((String)request.getParameter("ringlabel")).trim();
            manSysPara  syspara = new manSysPara();

            
            int checkflag =0;
            ArrayList rList = new ArrayList();
            String    title = "The movie audit";
            Hashtable tTmp = new Hashtable();
            if (op.equals("1")) {    
                 rList = sysring.checkMovieAlbum(ringindex,"4","2","Audit pass");
            } else if (op.equals("2")) { 
                 rList = sysring.checkMovieAlbum(ringindex,"5","2",refusecomment);
            }
            if(rList.size()>0) {
              if(getResultFlag(rList)) {
                  zxyw50.Purview purview = new zxyw50.Purview();
                  HashMap map = new HashMap();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","611");
                  map.put("RESULT","1");
                  map.put("PARA1",op);
                  map.put("PARA2",ringindex);
                  map.put("PARA3","000");
                  map.put("PARA4","ip:"+request.getRemoteAddr());
                  map.put("DESCRIPTION",refusecomment);
                  purview.writeLog(map);
                }
                session.setAttribute("rList",rList);
				%>
				<form name="resultForm" method="post" action="result.jsp">
				<input type="hidden" name="historyURL" value="checkMovie.jsp">
				<input type="hidden" name="title" value="<%= title %>">
				<script language="javascript">
				   document.resultForm.submit();
				</script>
				</form>
				<%
            }

            HashMap hash = new HashMap();
            hash.put("spindex","");
            hash.put("musiclabel",qryRingName);
			hash.put("functype","2");
            Vector vet = sysring.getCheckMovieAlbum(hash);

			%>
			<script language="javascript">
			   var v_ringindex = new Array(<%= vet.size() + "" %>);
			   var v_usernumber = new Array(<%= vet.size() + "" %>);
			   var v_ringlabel = new Array(<%= vet.size() + "" %>);
			   var v_validdate = new Array(<%= vet.size() + "" %>);
			   var v_description = new Array(<%= vet.size() + "" %>);
			<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (HashMap)vet.get(i);
				%>
				   v_ringindex[<%= i + "" %>] = '<%= (String)hash.get("funcid") %>';
				   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("funcname") %>';
				   v_validdate[<%= i + "" %>] = '<%= (String)hash.get("operdate") %>';
				   v_description[<%= i + "" %>] = "<%= JspUtil.convert((String)hash.get("comment"))%>";
				<%
            }
%>
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

      var value  = usernumber;
      if(value=='1')
         value='Music box';
      if(value=='2')
         value='Big gift package';

      fm.ringlabel.value = v_ringlabel[index];
      fm.validdate.value = v_validdate[index];
      fm.description.value = v_description[index];

   }

   function checkpass (opflag) {
      //opflag: 1:Í¨¹ý,2:¾Ü¾ø
       fm = document.inputForm;
       var strcon = "";
       var strtemp = "";
       switch(opflag) {
        case 1:
          strcon = "Please select the movie you want to audit";
          strtemp = "Are you sure to pass it?";
          break;
        case 2:
           strcon = "Please select the movie you want refuse to pass the audit."; 
           strtemp = "Are you sure to refuse it?";
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

   function checkviews() {
     fm = document.inputForm;
     if(fm.ringindex.value == ''){
       alert('Please select the movie you want to examine');
       return;
     }else {
       groupid = fm.ringindex.value;
       var result =  window.showModalDialog('checkAlbumMovieDetail.jsp?groupid='+groupid+'&type=2',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-460)/2)+";dialogTop:"+((screen.height-300)/2)+";dialogHeight:300px;dialogWidth:560px");
     }
   }

   function checkRefuse () {
      fm = document.inputForm;
      if (fm.ringindex.value == '') {
         alert('Please select the movie you want to refuse.');
         return false;
      }
      if(fm.ischeck[0].checked){
          if(fm.refusecomment.selectedIndex == -1){
             alert("Please select the reason of refuse!");
             return false;
          }
          fm.reasontext.value = fm.refusecomment.options[fm.refusecomment.selectedIndex].text;
      } else {
          var value = trim(fm.reason.value);
          if(value == ''){
              alert("Please input the reason of refuse!");
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

   function searchInfo () {
      fm = document.inputForm;
      if (!CheckInputStr(fm.qryRingName,'Ringtone group name for approval')){
         fm.qryRingName.focus();
         return  ;
      }
      fm.op.value = '';
      fm.submit();
   }
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
<form name="inputForm" method="post" action="checkMovie.jsp">
<input type="hidden" name="ringindex" value="">
<input type="hidden" name="reasontext" value="">
<input type="hidden" name="op" value="">

<table border="0" align="center" width="95%" height="400" cellspacing="0" cellpadding="0" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" cellspacing="1" cellpadding="1" class="table-style2" width="100%">
        <tr>
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Movie audit</td>
        </tr>
        <tr>
          <td height="15" colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr >
        <td colspan=2>
		    <table border="0" align="center" cellspacing="1" cellpadding="1" class="table-style2" width="100%">
               <tr>
                 <td align="right">The movie name for approval</td>
                 <td><input type="text" name="qryRingName" value="<%= qryRingName %>" maxlength="20" class="input-style1">
                     <img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()">
                 </td>
               </tr>
			</table>
        </td>
		</tr>
        <tr>
          <td height="15" colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr >
          <td width=35% align="right">
            <select name="ringlist" size="12" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectRing()">
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (HashMap)vet.get(i);
%>
              <option value="<%= i %>"><%= (String)hash.get("funcname") %></option>
<%
            }
%>
            </select>
          </td>
          <td width="65%">
              <table border="0"  cellspacing="1" cellpadding="1" class="table-style2" width="100%">
               <tr>
                 <td height="22" align="right"><span title="Movie name">Name</span></td>
                 <td height="22"><input type="text" name="ringlabel" disabled style="input-style1"></td>
               </tr>
               <tr style="display:none">
                 <td height="22" align="right"><span title="Movie provider">Provider</span></td>
                 <td height="22"><input type="text" name="ringsource" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right"><span title="Movie period of validity">Validity</span></td>
                 <td height="22"><input type="text" name="validdate" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td align="right">Description</td>
                 <td><textarea name="description" class="input-style1" rows="2" disabled></textarea></td>
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
                   <td height="22" align="right">Refused reason</td>
                   <td height="22" style='display:block' id="id_select"  >
                   <select name="refusecomment" class="input-style1" style="width:250px">
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
                <td width="20%" align="center" ></td>
                <td width="20%" align="center" ><input type='button'  style="width:100px" name="checkpass1" value="Pass" onclick="javascript:checkpass(1)"></td>
                <td width="20%" align="center" ><input type='button'  style="width:100px" name="checkpass2"   value="Refuse"  onclick="javascript:checkpass(2)"></td>
                <td width="20%" align="center" ><input type='button'  style="width:100px" name="checkview"   value="Details"  onclick="javascript:checkviews()"></td>
                <td width="20%" align="center" ></td>
              </tr>
            </table>
          </td>
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
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry. You have no access to this function!");
              </script>
              <%

                   }

        }
    }
    catch(Exception e) {
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occoured in the process of Movie audit!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + "Error occoured in the process of Movie audit!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="checkMovie.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
