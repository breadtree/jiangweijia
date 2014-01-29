<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","Ringtone producer");
    ringsourcename=transferString(ringsourcename);
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");


	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

	int ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia",0);
	int isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage",0);
	int imageup = zte.zxyw50.util.CrbtUtil.getConfig("imageup",0);

	String audioring = zte.zxyw50.util.CrbtUtil.getConfig("audioring","Audio");
	String videoring = zte.zxyw50.util.CrbtUtil.getConfig("videoring","Video");
	String photoring = zte.zxyw50.util.CrbtUtil.getConfig("photoring","Photo");

	String ring_name = CrbtUtil.getConfig("ringName","name");
%>

<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Album-Movie Rings</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    try {
      if (operID != null && purviewList.get("2-3") != null) {
        sysTime = SocketPortocol.getSysTime() + "--";
        manSysRing sysring = new manSysRing();

        String grpType = request.getParameter("grpType") == null ? "1" : (String)request.getParameter("grpType");
        String ringgroup=request.getParameter("ringgroup")==null ? "":(String)request.getParameter("ringgroup");
        String grouplabel= request.getParameter("grouplabel")==null ? "":transferString((String)request.getParameter("grouplabel"));
		String op = request.getParameter("op")==null ? "":transferString((String)request.getParameter("op"));
        String mediatype = request.getParameter("mediatype") == null ? "" : (String)request.getParameter("mediatype");

		HashMap map = new HashMap();
		map.put("ringgroup",ringgroup);
		map.put("grpType",grpType);


	if("del".equals(op)) {
            map.put("opcode","2");  
            String delRing = request.getParameter("delRing") == null ? "" : (String)request.getParameter("delRing");
            String delRingFuncId = request.getParameter("delRingFuncId") == null ? "" : (String)request.getParameter("delRingFuncId");
            map.put("ringid",delRing);
            map.put("newringid","");

            sysring.modRingFuncMem(map);

	} else if("add".equals(op)) {
            String ringID = request.getParameter("ringID") == null ? "" : (String)request.getParameter("ringID");
            map.put("ringid",ringID);
            map.put("opcode","1");
	    map.put("newringid","");

            sysring.modRingFuncMem(map);

	} else if("mod".equals(op)) {
            String ringID = request.getParameter("ringID") == null ? "" : (String)request.getParameter("ringID");
            map.put("opcode","3");
            map.put("ringid",ringID);
            map.put("newringid","");

            sysring.modRingFuncMem(map);
	}

        ArrayList vet = new ArrayList();
        HashMap hash = new HashMap();
		

        vet = sysring.getAlbumMovieInfo(map);

%>

<script language="javascript">

   function tryListen(ringID,ringName,ringAuthor,mediatype) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
      if(trim(mediatype)=='1'){
               preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='4'){
        tryURL = 'tryView.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }
   }

   function queryInfo() {
   
           var result =  window.showModalDialog('ringSearch.jsp?hidemediatype=1&mediatype=1',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
       document.inputForm.ringID.value=result;
     }
   
     //  var result =  window.open('ringSearch.jsp?hidemediatype=1&mediatype=1','mywin','left=20,top=20,width=600,height=550,toolbar=1,resizable=0,scrollbars=yes');
	
   }

   function addMember () {
	   fm = document.inputForm;
	   if (trim(fm.ringID.value) == '') {
		   alert('Please select <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> first,and then add it!');
		   return;
	   }
       fm.op.value = 'add';
       fm.submit();
   }

   function deleteRing (ringid,albumIndex,grpType) {
	   fm = document.inputForm;
	   fm.op.value = 'del';
	   fm.delRing.value = ringid;
	   fm.submit();
   }

   function comeBack() {
	   if(<%=grpType%> == 1) {
	       window.document.location.href = 'album.jsp';
	   } else {
		   window.document.location.href = 'movie.jsp';
	   }
   }

</script>

<form name="inputForm" method="post" action="albumMovieRingEdit.jsp">

  <input type="hidden" name="op" value="">
  <input type="hidden" name="delRing" value="">
  <input type="hidden" name="ringgroup" value="<%=ringgroup%>">
  <input type="hidden" name="grpType" value="<%=grpType%>">

  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="100%">
    <table  width="98%" border="0" cellspacing="1" cellpadding="1" class="table-style2">
		<tr>
			<td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif"><%=grouplabel%></td>
		</tr>
    </table>
    </td>
  </tr>
  <tr>
    <td width="100%" align="center">
    <table width="98%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style4">
        <tr class="tr-ringlist">
           <td height="30" width="70">
               <div align="center"><font color="#FFFFFF"><span title="Ringtone code">Code</span></font></div>
           </td>
           <td height="30" width="100">
               <div align="center"><font color="#FFFFFF"><span title="Ringtone name"><%=ring_name%></span></font></div>
           </td>
           <td height="30" width="60" >
               <div align="center"><font color="#FFFFFF"><span title="Ringtone provider">Content Provider</span></font></div>
           </td>
           <td height="30"  width="60"  >
               <div align="center"><font color="#FFFFFF"><span title="Singer"><%=CrbtUtil.getConfig("authorname","Singer")%></span></font></div>
           </td>
           <td height="30" width="50" >
               <div align="center"><font color="#FFFFFF"><span title="Period of Validity">Validity</span></font></div>
           </td>
		   <td height="30" width="45">
		       <div align="center"><font color="#FFFFFF"><span title="Price(<%= majorcurrency %>)">Price(<%= majorcurrency %>)</span></font></div>
           </td>
		   <td height="30" width="20" style="display:none">
               <div align="center"><font color="#FFFFFF"><span title="Listen the ringtone">Preview</span></font></div>
           </td>
           <td height="30" width="20">
               <div align="center"><font color="#FFFFFF"><span title="Delete the ringtone ">Delete</span></font></div>
           </td>
        </tr>

        <%
        int count = 0;
        for (int i = 0; i < vet.size(); i++) {
            hash = (HashMap)vet.get(i);
            count++;
             %>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
			<td height="20"><%= (String)hash.get("ringid") %></td>
			<td height="20"><%= displayRingName((String)hash.get("ringlabel")) %></td>
			<td height="20"><%= displaySpName((String)hash.get("ringsource")) %></td>
			<td height="20"><%= displayRingAuthor((String)hash.get("ringauthor")) %></td>
			<td height="20"><%= (String)hash.get("validtime") %></td>
			<td height="20" align="center">
				<div align="center"><%= displayFee((String)hash.get("ringfee")) %></div>
			</td>
			<td height="20" style="display:none">
				<div align="center">
				<font class="font-ring">
				<%
					  String strPhoto="../image/play.gif";
					  String strMediatype=(String)hash.get("mediatype");
					  if("2".equals(strMediatype))  {
						strPhoto="../image/play1.gif";
					  } else if("4".equals(strMediatype)) {
						strPhoto="../image/play2.gif";
					  } else {
						strPhoto="../image/play.gif";
					  }
				%>
				<img src="<%= strPhoto %>"  height='15'  width='15' alt="Preview" onmouseover="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("ringauthor") %>','<%= (String)hash.get("mediatype") %>')">
				</font>
				</div>
			</td>
			<td height="20">
			  <div align="center"><font class="font-ring"><img src="../image/delete.gif" height='15'  width='15' alt="Delete" onMouseOver="this.style.cursor='hand'" onclick="javascript:deleteRing('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("albumIndex") %>','<%= grpType %>')"></font></div>
			</td>
        </tr>
        <%
        }
        %>
    </table>
    </td>
  </tr>
</table>
<table border="0" width="100%" class="table-style2">
	<tr>
		<td width="56%">ringtone code <input type="text" name="ringID" value="" maxlength="20" class="input-style1"  ><img src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:queryInfo()"></td>
		<td width="22%" align="center"><img src="button/sure.gif" height="19" onclick="javascript:addMember()" onmouseover="this.style.cursor='hand'"></td>
		<td width="22%" align="center"><img src="button/back.gif" width="45" height="19" onclick="javascript:comeBack()" onmouseover="this.style.cursor='hand'"></td>
	</tr>
</table>
</form>
        <%
        }
        else {
            if(operID == null) { %>
              <script language="javascript">
                    alert( "Please log in first!");
                    parent.document.URL = 'enter.jsp';
              </script>
              <%
            } else {
              %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");
              </script>
              <%
            }
        }
   } catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + " Exception occurred in managing album/movie!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Error occurred in managing album/movie!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
		%>
		<form name="errorForm" method="post" action="error.jsp" >
		<input type="hidden" name="historyURL" value="albumMovieRingEdit.jsp">
		</form>
		<script language="javascript">
		   document.errorForm.submit();
		</script>
		<%
   } %>

</body>
</html>
