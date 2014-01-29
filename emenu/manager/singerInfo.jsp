<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="com.zte.tao.util.JspUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    String useweekstar = CrbtUtil.getConfig("weekstar","0");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    ywaccess oYwAccess = new ywaccess();
    String msg="";
	String imgDir = (String)CrbtUtil.getConfig("singerpath","C:/zxin10/Was/tomcat/webapps/colorring/image/singer/");
	//String realpath = application.getRealPath("/");
	//System.out.println("REAL PATH------------->"+realpath);
	
	String sDisp=imgDir;
	sDisp=sDisp.substring(sDisp.indexOf("colorring")+9);
        String isSamaLibiya = CrbtUtil.getConfig("isSamaLibiya","0");
        String isCombodia = CrbtUtil.getConfig("isCombodia","0");
%>
<html>
<head>
<title>Singer edit</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script language="JavaScript">

   function edit () {
      var fm = document.inputForm;
      if (trim(fm.singgername.value) == '') {
         alert('Please input <%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name');
         fm.singgername.focus();
         return;
      }
      if (<%=isSamaLibiya%> == '0' && !CheckInputStr(fm.singgername,'Singer name')){
         fm.singgername.focus();
         return;
      }
      if (trim(fm.spellsinger.value) == '') {
         alert('Please input the spelling of <%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%>');
         fm.spellsinger.focus();
         return;
      }
      if((<%=isSamaLibiya%> == '0' || <%=isCombodia%> == '0') && !CheckInputChar1(fm.spellsinger,'Spelling of <%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%>')){
      	fm.spellsinger.focus();
      	return;
      }
       if (!CheckInputStr(fm.descrip,'Notes')){
         fm.descrip.focus();
         return;
      }
      fm.op.value = 'edit';
      fm.submit();
   }

function ok(){
  edit();
}
function cancel(){
  window.returnValue = "no";
  window.close();
}
function selectFile ()
{
	var fm = document.inputForm;
	var filename = trim(fm.filename.value);
/*	alert("File---->"+filename);  */
	//var urlpath = trim(fm.urlpath.value);
	var uploadURL = 'uploadSingerImage.jsp?frompage=singer&filename='+filename;
	uploadRing = window.open(uploadURL,'upload','width=400, height=200');
}

function delFile() {
	document.inputForm.filename.value="";
}

function getListName(label) {
	var fm = document.inputForm;
	fm.filename.value = label;
	if(fm.filename.value=='') {
		document.getElementById('singerimg').src='image/no_img.jpg';
	}else {
		document.getElementById('singerimg').src='..<%=sDisp%>'+label;
}
}
</script>
</head>
<base target="_self">
<body topmargin="0" leftmargin="0" class="body-style1"  background="background.gif" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String singerid = request.getParameter("singerid") == null ? "" : ((String)request.getParameter("singerid")).trim();
    String singgername = request.getParameter("singgername") == null ? "" : transferString((String)request.getParameter("singgername"));
    if(checkLen(singgername,40))
    throw new Exception("The length of singer name you input exceeds the limit, please input it again!");
    String singgersex  = request.getParameter("singgersex") == null ? "0" : transferString((String)request.getParameter("singgersex")).trim();
    String weekstar  = request.getParameter("weekstar") == null ? "0" : transferString((String)request.getParameter("weekstar")).trim();
    String spellsinger = request.getParameter("spellsinger") == null ? "" : transferString((String)request.getParameter("spellsinger")).trim();
    String descrip = request.getParameter("descrip") == null ? "" : transferString((String)request.getParameter("descrip")).trim();
    String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
    String opcode = request.getParameter("opcode") == null ? "" : (String)request.getParameter("opcode");
	
	String alias1_name =  request.getParameter("alias1_name") == null ? "" : transferString((String)request.getParameter("alias1_name")).trim();
    String alias2_name =  request.getParameter("alias2_name") == null ? "" : transferString((String)request.getParameter("alias2_name")).trim();
    String region =  request.getParameter("region") == null ? "" : transferString((String)request.getParameter("region")).trim();
	String sFileName = request.getParameter("filename") == null ? "" : (String)request.getParameter("filename").trim();
	//System.out.println("SFILENAME------------->"+sFileName);
	//String sExtraSingerID = request.getParameter("extrasingerid") == null ? "" : transferString((String)request.getParameter("extrasingerid")).trim();
	//System.out.println("sExtraSingerID---------------->"+sExtraSingerID);
 	int isSingerAlias1 =  zte.zxyw50.util.CrbtUtil.getConfig("singeralias1",0);
	int isSingerAlias2 =  zte.zxyw50.util.CrbtUtil.getConfig("singeralias2",0);
	int isExtraSingerInfo =  zte.zxyw50.util.CrbtUtil.getConfig("extra_singerinfo",0);
	String sLangLabel1 = CrbtUtil.getConfig("langlabel1","Arabic");
	String sLangLabel2 = CrbtUtil.getConfig("langlabel2","French");

    int iDispOpcode = 0;

    String title = "";
    int  optype = 0;
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        if(op.equals("edit")){
            if(opcode.equals("add")){
             optype = 0;
			 iDispOpcode = 1;
             title = "Add singer";
             singerid = "";
            }
            else{
             optype = 2;
	     iDispOpcode = singerid.equals("")?1:3;			
             title = "Edit singer";
            }
            manSysRing manring = new manSysRing();
            HashMap map1=new HashMap();
                ArrayList rList = null;
                map1.put("optype",optype+"");
                map1.put("singerid",singerid);
                map1.put("singgername",singgername);
                map1.put("singgersex",singgersex);
                map1.put("spellsinger",spellsinger);
                map1.put("descrip",descrip);
                map1.put("weekstar",weekstar);
                rList = manring.setSinger(map1);
				
				map1.put("name",singgername);
                                map1.put("extrainfooptype",iDispOpcode+"");
				map1.put("alias1",alias1_name);
				map1.put("alias2",alias2_name);
				map1.put("region",region);
				map1.put("image",sFileName);
				map1.put("opflag","4");
				map1.put("imgdir",imgDir);
				if(getResultFlag(rList) && (isSingerAlias1==1 || isSingerAlias2==1 || isExtraSingerInfo==1)) {
					Hashtable hashSing=(Hashtable)rList.get(1);
					if(hashSing !=null && !((String)hashSing.get("singerid")).equals("")) {
						singerid=(String)hashSing.get("singerid");
						map1.put("funcid",singerid);
					}
					rList = manring.setAliasInfo(map1);   
				}
				
                sysInfo.add(sysTime + operName + "modify singer information successfully!");
                msg = JspUtil.generateResultList(rList);
                if(!msg.equals("")){
                   msg = msg.replace('\n',' ');
                   throw new Exception(msg);
                }
               if(getResultFlag(rList)){
                 // 准备写操作员日志
                 zxyw50.Purview purview = new zxyw50.Purview();
                 HashMap map = new HashMap();
                 map.put("OPERID",operID);
                 map.put("OPERNAME",operName);
                 map.put("OPERTYPE","205");
                 map.put("RESULT","1");
                 map.put("PARA1",singerid);
                 map.put("PARA2",singgername);
                 map.put("PARA3",spellsinger);
                 map.put("PARA4","ip:"+request.getRemoteAddr());
                 map.put("DESCRIPTION",title);
                 purview.writeLog(map);
               }
                %>
                <script language="JavaScript">
                window.returnValue = "yes";
                window.close();
                </script>
        <%}else{%>

<form name="inputForm" method="post" action="singerInfo.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="opcode" value='<%=opcode%>'>

<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
    <td>
      <br />
      <table  width="100%"  border="0">
      <tr>
          <td width="100%" align="center" valign="middle">
              <div id="hintContent" >
      <table border="0" align="center" class="table-style2">
         <tr>
          <td height="22" valign="bottom"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> code</td>
          <td height="22" valign="top"><input type="text" name="singerid"  value="<%=singerid%>" maxlength="20" class="input-style0"  readonly="readonly" >&nbsp;&nbsp;<%if(isExtraSingerInfo == 1){
        if(!sFileName.equals("")) {%>
         <img src="..<%=sDisp%><%=sFileName%>" border="0" width="64" height="64" alt="<%=sFileName%>" id="singerimg" style="float:right;position:absolute;" /><%}else{%><img src="image/no_img.jpg" border="0" width="64" height="64" id="singerimg" style="float:right;position:absolute;" /><%}}%> </td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name</td>
          <td height="22" valign="center"><input type="text" name="singgername"  value="<%=singgername%>"  maxlength="40" class="input-style0"></td>
        </tr>
		<tr <%if(isExtraSingerInfo==1 && isSingerAlias1==1) {%> style="display:block" <%}else{%> style="display:none" <%}%>>
			<td height="22" align="left" valign="center"><%=sLangLabel1+" "+zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name</td>
			<td height="22" align="left" valign="center"><input type="text" name="alias1_name"  value="<%=alias1_name%>"  maxlength="100" class="input-style0" /></td>
		</tr>
		<tr <%if(isExtraSingerInfo==1 && isSingerAlias2==1) {%> style="display:block" <%}else{%> style="display:none" <%}%>>
			<td height="22" align="left" valign="center"><%=sLangLabel2+" "+zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name</td>
			<td height="22" align="left" valign="center"><input type="text" name="alias2_name"  value="<%=alias2_name%>"  maxlength="100" class="input-style0" /></td>
		</tr>
       <tr>
            <td align="left"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> gender</td>
            <td>
                <table border="0" width="100%" class="table-style2">
                  <tr align="left">
                    <%if(singgersex.equals("0")){%>
                    <td width="25%"><input type="radio" name="singgersex" value="0" checked="checked">Male</td>
                   <td width="75%"><input type="radio" name="singgersex" value="1" >Female</td>
                    <%}else{%>
                       <td width="25%"><input type="radio" name="singgersex" value="0">Male</td>
                      <td width="75%"><input type="radio" name="singgersex" value="1"  checked="checked">Female</td>
                       <%}%>
                  </tr>
                </table>
            </td>
         </tr>
        <tr>
          <td height="22" align="left" valign="center">Spelling of <%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></td>
          <td height="22" valign="center"><input type="text" name="spellsinger" value="<%=spellsinger%>"  maxlength="20" class="input-style0"></td>
        </tr>
          <tr style="<%=("0".equals(useweekstar)?"display: none ":"display: block ")%>">
            <%if("2".equals(useweekstar))
             {%>
               <td align="right">Artiste of The Month</td>
               <%} else{%>
             <td align="right">Star of this week</td>
             <%}%>

            <td>
              <table border="0" width="100%" class="table-style2">
                <tr  align="center">
               <%if(weekstar.equals("0")){%>
               <td width="50%"><input type="radio" name="weekstar" value="0" checked="checked">No</td>
                 <td width="50%"><input type="radio" name="weekstar" value="1" >Yes</td>
                   <%}else{%>
                    <td width="50%"><input type="radio" name="weekstar" value="0">No</td>
                 <td width="50%"><input type="radio" name="weekstar" value="1" checked="checked">Yes</td>
                   <%}%>
               </tr>
             </table>
            </td>
         </tr>
        <tr>
          <td height="22" align="left" valign="center" >Notes</td>
          <td height="22" valign="center"><input type="text" name="descrip"  value="<%=descrip%>"  maxlength="40" class="input-style0"></td>
        </tr>
		<tr <%if(isExtraSingerInfo==1) {%> style="display:block" <%}else{%> style="display:none" <%}%>>
			<td height="22" align="left" valign="center">Singer Image</td>
			<td height="22" align="left" valign="center"><input type="text" name="filename" value="<%=sFileName%>" readonly class="input-style0" />&nbsp;<img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()" width="45" height="19">&nbsp;<img src="button/del_img.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delFile()" width="62" height="19"></td>
		</tr>
		<tr <%if(isExtraSingerInfo==1) {%> style="display:block" <%}else{%> style="display:none" <%}%>>
			<td height="22" align="left" valign="center">Region</td>
			<td height="22" align="left" valign="center"><input type="text" name="region"  value="<%=region%>"  maxlength="100" class="input-style0" /></td>
        </tr>
      </table>
              </div>
          </td>
      </tr>
      <tr>
          <td width="100%" align="center" height="16" align="center">
              <img src="button/sure.gif" alt="OK" onmouseover="this.style.cursor='hand'" onclick="javascript:ok()" >
                  &nbsp;&nbsp;
              <img src="button/cancel.gif" alt="Cancel" onmouseover="this.style.cursor='hand'" onclick="javascript:cancel()" >
        </td>
          </tr>
        </table>

    </td>
  </tr>
</table>
</form>
<%
}
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Singer management" + singerid + "is abnormal ");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the singer management!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
alert('<%=msg%>');
window.close();
//window.open('singerInfo.jsp?opcode='+'add','try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
</script>
<%
    }
%>
</body>
</html>
