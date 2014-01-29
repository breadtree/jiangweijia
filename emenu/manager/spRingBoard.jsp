<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.manSysPara"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
	response.addHeader("Cache-Control", "no-cache");
	response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
	<title>Manage latest recommended ringtones</title>
	<link rel="stylesheet" type="text/css" href="style.css">
	<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" >
<%
	String sysTime = "";
	Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
	String operID = (String)session.getAttribute("OPERID");
	String operName = (String)session.getAttribute("OPERNAME");
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	try
	{
		ColorRing  colorring = new ColorRing();
		manSysRing sysring = new manSysRing();
		manSysPara syspara = new manSysPara();
		sysTime = sysring.getSysTime() + "--";
		if (operID != null && purviewList.get("3-37") != null)
		//if (operID != null)
		{
			ArrayList rList = new ArrayList();
			HashMap map = new HashMap();
			HashMap map1= new HashMap();
			Map hash = null;
			String op = request.getParameter("op") == null ? "" : transferString((String) request.getParameter("op")).trim();
			String boardtype = request.getParameter("boardtype") == null ? "11" : transferString((String) request.getParameter("boardtype")).trim();
			String seqno = request.getParameter("seqno") == null ? "" : transferString((String) request.getParameter("seqno")).trim();
			String spcode = request.getParameter("spcode") == null ? "" : transferString((String) request.getParameter("spcode")).trim();
			String spindex = request.getParameter("spindex") == null ? "" : transferString((String) request.getParameter("spindex")).trim();
			String ringid = request.getParameter("ringid") == null ? "" : transferString((String) request.getParameter("ringid")).trim();

			int optype = 0;
			String title = "";
			if (op.equals("add")){
				optype = 1;
				title = "Add sp ring board";//增加SP铃音排行榜
			}
			else if (op.equals("del")) {
				optype = 2;
				title = "Delete sp ring board";//删除SP铃音排行榜
			}
			else if (op.equals("edit")) {
				optype = 3;
				title = "Modify sp ring board";//修改SP铃音排行榜
			}

			if(optype>0){
				map1.put("optype", optype + "");
				map1.put("ringid", ringid);
				map1.put("spcode", spcode);
				map1.put("seqno", seqno);
				map1.put("boardtype", boardtype);
				rList = syspara.setSPRingBoard(map1);
				// 准备写操作员日志
				if(getResultFlag(rList)){
					zxyw50.Purview purview = new zxyw50.Purview();
					map.put("OPERID",operID);
					map.put("OPERNAME",operName);
					map.put("OPERTYPE","336");
					map.put("RESULT","1");
					map.put("PARA1",optype+"");
					map.put("PARA2",spcode);
					map.put("PARA3",boardtype);
					map.put("PARA4",ringid);
					map.put("PARA5",seqno);
					map.put("DESCRIPTION",title);
					purview.writeLog(map);
				}
				if(rList.size()>0){
					session.setAttribute("rList",rList);
%>
					<form name="resultForm" method="post" action="result.jsp">
						<input type="hidden" name="historyURL" value="spRingBoard.jsp?spcode=<%= spcode%>&boardtype=<%= boardtype%>"/>
						<input type="hidden" name="title" value="<%= title %>"/>
						<script language="javascript">
							document.resultForm.submit();
						</script>
					</form>
<%
			   }
			}
			List vet = null;
			vet = syspara.getSPInfo();
			StringBuffer spstr = new StringBuffer();
			StringBuffer infostr = new StringBuffer();
			StringBuffer boardstr = new StringBuffer();
			if(vet.size()>0)
			{
				for (int i = 0; i < vet.size(); i++) {
					map = (HashMap)vet.get(i);
					spstr.append("<option value=\""+ (String)map.get("spcode") +"\"");
					if(spcode.equals((String)map.get("spcode")))
					{
						spstr.append(" selected");
						spindex = (String)map.get("spindex");
					}
					spstr.append(">"+(String)map.get("spname") +"</option>");
				}
				if(spcode.equals(""))
				{
					map = (HashMap)vet.get(0);
					spcode = (String)map.get("spcode");
					spcode = spcode.trim();
					spindex = (String)map.get("spindex");
				}
			}
			for (int i = 1; i < 11; i++) {
				boardstr.append("<option value=\""+ (i+10) +"\"");
				if(boardtype.equals(i+10+""))
				{
					boardstr.append(" selected");
				}
				boardstr.append(">");
				boardstr.append("Boardtype"+String.valueOf(i));
				boardstr.append("</option>");
			}
			HashMap cmap = new HashMap();
			cmap.put("spcode",spcode);
			cmap.put("boardtype",boardtype);
			vet = syspara.getSPRingBoard(cmap);
			for (int i = 0; i < vet.size(); i++)
			{
				map = (HashMap)vet.get(i);
				infostr.append("<option value="+ i +">");
				infostr.append((String)map.get("seqno")+"--");
				infostr.append((String)map.get("ringid"));
				infostr.append("</option>");
			}
 %>
			<script language="javascript">
			var v_ringid = new Array(<%= vet.size() + "" %>);
			var v_spcode = new Array(<%= vet.size() + "" %>);
			var v_boardtype = new Array(<%= vet.size() + "" %>);
			var v_sepno = new Array(<%= vet.size() + "" %>);
<%
			for (int i = 0; i < vet.size(); i++)
			{
				hash = (Map)vet.get(i);
%>
				v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
				v_spcode[<%= i + "" %>] = '<%= (String)hash.get("spcode") %>';
				v_boardtype[<%= i + "" %>] = '<%= (String)hash.get("boardtype") %>';
				v_sepno[<%= i + "" %>] = '<%= (String)hash.get("seqno") %>';
<%
			}
%>
			function selectInfo ()
			{
				var fm = document.inputForm;
				var index = fm.infoList.value;
				if (index == null)
					return;
				if (index == '')
					return;
				fm.ringid.value = v_ringid[index];
				fm.spcode.value = v_spcode[index];
				fm.boardtype.value = v_boardtype[index];
				fm.seqno.value =v_sepno[index];
			}

			function checkSepno()
			{
				var seqno = document.inputForm.seqno.value;
				var temp="<%=  vet.size() %>";
				var flag = 0;
				if(seqno<1 || seqno >15)
				{
					alert("The serial number of sp ring board you entered should be in 1~15. Please re-enter!");//您输入的名称已经重复,请重新输入
					document.inputForm.seqno.focus();
					return false;
				}
				for(var i=0; i<parseInt(temp); i++)
				{
					if(v_sepno[i]==seqno){
						flag = 1;
						break;
					}
				}
				if(flag ==1) {
					alert("The serial number of sp ring board you entered has been repeated. Please re-enter!");//您输入的名称已经重复,请重新输入
					document.inputForm.boardtype.focus();
					return false;
				}
				return true;
			}

			function checkRingid()
			{
				var seqno = document.inputForm.seqno.value;
				var ringid = document.inputForm.ringid.value;
				var temp="<%=  vet.size() %>";
				var flag = 0;
				for(var i=0; i<parseInt(temp); i++)
				{
					if(v_ringid[i]==ringid)
					{
						if(v_sepno[i]==seqno)
						{
							flag = 2;
						}
						else
						{
							flag = 1;
						}
						break;
					}
				}
				if(flag ==1) {
					alert("The ringtone you hava selected has been repeated. Please re-enter!");//您选择的铃音已经重复,请重新输入
					return false;
				}
				if(flag == 2){
					alert("The ringtone you hava selected was same to the original ringtone. Please re-enter!");//您选择的铃音与原先相同,请重新输入
					return false;
				}
				return true;
			}

			function addInfo () {
				var fm = document.inputForm;
				var index = fm.infoList.selectedIndex;
				if(!checkInfo)
				{
					return;
				}
				if(!checkSepno())
				{
					return;
				}
				if(!checkRingid())
				{
					return;
				}
				fm.op.value = 'add';
				fm.submit();
			}

			function editInfo () {
				var fm = document.inputForm;
				var index = fm.infoList.selectedIndex;
				if(fm.infoList.length==0){
					alert("Sorry. You must configure a sp ring board first!");
					return;
				}
				if(fm.seqno.value != v_sepno[index])
				{
					alert("Sorry. You can not change the serial number !");
					return;
				}
				if(index == -1){
					alert("Please select a sp ring board to be edited");//请选择您要Edit的SP铃音排行榜
					return;
				}
				if(!checkInfo)
				{
					return;
				}
				if(!checkRingid())
					return ;
				fm.op.value = 'edit';
				fm.submit();
			}

			function delInfo () {
				var fm = document.inputForm;
				var index = fm.infoList.selectedIndex;
				if(index == -1){
					alert("Please select the sp ring board to be deleted");//请选择您删除的排行榜
					return;
				}
				fm.ringid.value=v_ringid[index];
				fm.seqno.value=v_sepno[index]
				fm.op.value = 'del';
				fm.submit();
			}
			function checkInfo () {
				var fm = document.inputForm;
				var flag = false;
				var value = trim(fm.ringid.value);
				if(value==''){
					alert("Please enter the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code!");//请输入Ringtone code
					fm.ringid.focus();
					return flag;
				}
				if (!checkstring('0123456789',value)) {
					alert('The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code must be a digital number!');//Ringtone code必须是数字
					fm.ringid.focus();
					return flag;
				}
				var value = trim(fm.seqno.value);
				if(value==''){
					alert("Please enter the serial number of sp ring board!");//请输入铃音序号
					fm.seqno.focus();
					return flag;
				}
				if (!checkstring('0123456789',value)) {
					alert('The serial number of sp ring board must be a digital number!');//铃音序号必须是数字
					fm.seqno.focus();
					return flag;
				}
				flag = true;
				return flag;
			}

			function searchRing()
			{
				var fm = document.inputForm;
				fm.op.value = 'search';
				fm.submit();
			}

			function queryInfo() {
				var fm = document.inputForm;
				if(fm.spcode.value=='')
				{
					alert('Please select a sp!');//铃音序号必须是数字
					return;
				}
				var result =  window.showModalDialog('spRingSearch.jsp?spindex=<%= spindex %>',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
				if(result){
					document.inputForm.ringid.value=result;
				}
			}
			</script>
			<script language="JavaScript">
			if(parent.frames.length>0)
				parent.document.all.main.style.height="400";
			</script>
			<form name="inputForm" method="post" action="spRingBoard.jsp">
				<input type="hidden" name="op" value=""/>
				<table width="90%" border="0" align="center" class="table-style2">
					<tr>
						<td>
							<table width="100%" border="0" align="center" class="table-style2">
								<tr>
									<td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">SP Ring Board Management</td>
								</tr>
								<tr>
									<td align="center">
										<select name="infoList" size="15" <%= vet.size() == 0 ? "disabled " : "" %> class="input-style1" style="width:200px" onclick="javascript:selectInfo()">
											<%= infostr.toString() %>
										</select>
									</td>
									<td  valign="middle">
										<table width="100%" border =0 class="table-style2" height='100%'>
											<tr>
												<td align=right height=30>
													&nbsp;&nbsp;Select SP
												</td>
												<td>
													<select name="spcode" class="select-style1" onchange="javascript:searchRing()">
														<%= spstr.toString() %>
													</select>
												</td>
											</tr>
											<tr>
												<td align=right height=30>
													 &nbsp;&nbsp;Boardtype
												</td>
												<td>
													<select name="boardtype" class="select-style1" onchange="javascript:searchRing()">
														<%= boardstr.toString() %>
													</select>
												</td>
											</tr>
											<tr>
												<td  align=right height=30 >&nbsp;&nbsp;Serial Number</td>
												<td><input  type="text" name="seqno" value="" maxlength="2" class="input-style1" ></td>
											</tr>
											<tr>
												<td align=right height=30>&nbsp;&nbsp;Ringtone code</td>
												<td><input type="text" name="ringid" value="" maxlength="20" class="input-style1" readonly="readonly"><img  height="15" src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo()">
												</td>
											</tr>
											<tr>
												<td colspan="2" align="center" height=30>
													<table border="0" width="100%" class="table-style2"  align="center">
														<tr>
															<td width="25%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()" /></td>
															<td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"/></td>
															<td width="25%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"/></td>
															<td width="25%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"/></td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<table border="0" width="90%" align="center" class="table-style2">
											<tr>
												<td>Notes:</td>
											</tr>
											<tr>
												<td >&nbsp;&nbsp;&nbsp;1. The serial Number should be 1~15;</td>
											</tr>
											<tr>
												<td >&nbsp;&nbsp;&nbsp;2. you can delete the existent ring board;</td>
											</tr>
											<tr>
												<td >&nbsp;&nbsp;&nbsp;3. you can edit the corresponding ring of the serial number, and can not edit the serial number;</td>
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
	sysInfo.add(sysTime + operName + " Exception occurred in managing the sp ring board!");
	sysInfo.add(sysTime + operName + e.toString());
	vet.add("Error occurred in managing the sp ringboard manager!");
	vet.add(e.getMessage());
	session.setAttribute("ERRORMESSAGE",vet);
%>
	<form name="errorForm" method="post" action="error.jsp">
		<input type="hidden" name="historyURL" value="spRingBoard.jsp"/>
	</form>
	<script language="javascript">
		document.errorForm.submit();
	</script>
	<%
	}
	%>
	</body>
</html>
