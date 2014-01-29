<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<%
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
     //add by gequanmin 2005-07-05
    String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","ringtone producer");
    ringsourcename=transferString(ringsourcename);
    //add end
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
	String userday = CrbtUtil.getConfig("uservalidday","0");
	String isAdRing = CrbtUtil.getConfig("isshowad","0");


	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
	String singer_name = CrbtUtil.getConfig("authorname", "Singer");
%>

<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Video Zone Management</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    try {
      if (operID != null && purviewList.get("2-27") != null) {
        sysTime = SocketPortocol.getSysTime() + "--";
        manSysRing sysring = new manSysRing();
        String libid = request.getParameter("ringlib") == null ? "0" : (String)request.getParameter("ringlib");
        String spindex = request.getParameter("spindex") == null ? "0" : (String)request.getParameter("spindex");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        ArrayList vet = new ArrayList();
        HashMap hash = new HashMap();
        ArrayList rList = new ArrayList();
        HashMap map = new HashMap();
        HashMap map1= new HashMap();
        String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
        String rsubindex = request.getParameter("rsubindex") == null ? "" : transferString((String)request.getParameter("rsubindex")).trim();
        String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
        String newringid = request.getParameter("newringid") == null ? "" : transferString((String)request.getParameter("newringid")).trim();
        int optype = 0;
        String title = null;
        if (op.equals("add")){
          optype = 1;
         // title = "增加IVR分类铃音";
          title = "Add Video Zone Ringtone";
        }
        else if (op.equals("del")) {
          optype = 2;
          title = "Delete Video Zone Ringtone";//删除增加IVR分类铃音
        }
        else if (op.equals("edit")) {
          optype = 3;
          title = "Edit Video Zone Ringtone";//Edit增加IVR分类铃音
        }
        if(optype>0){
          map1.put("optype",optype+"");
          map1.put("allindex",libid);
          map1.put("ringid",ringid);
        //  map1.put("newringid",newringid);
          map1.put("rsubindex",rsubindex);
          map1.put("boardtype","160");
          rList = sysring.setRecommend(map1);
          // 准备写操作员日志
          if(getResultFlag(rList)){
            zxyw50.Purview purview = new zxyw50.Purview();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","227");
            map.put("RESULT","1");
            map.put("PARA1", ringid);//ringid);
            map.put("PARA2", rsubindex);//rsubindex);
            map.put("PARA3", newringid);
            map.put("PARA4","ip:"+request.getRemoteAddr());
            map.put("DESCRIPTION",title);
            purview.writeLog(map);
          }
          if(rList.size()>0){
            session.setAttribute("rList",rList);
            %>
            <form name="resultForm" method="post" action="result.jsp">
              <input type="hidden" name="historyURL" value="videoZoneMgmt.jsp">
                <input type="hidden" name="title" value="<%= title %>">
                  <script language="javascript">
                    document.resultForm.submit();
                    </script>
                    </form>
                    <%
                    }
                  }
        ColorRing  colorring = new ColorRing();
        vet = colorring.getVideoRingDisplay();
        int pages = vet.size()/25;
        if(vet.size()%25>0)
          pages = pages + 1;
%>

<script type="text/javascript">
function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }
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
   function searchRing () {
      fm = document.inputForm;
      fm.page.value = 0;
      fm.submit();
   }

   function goPage(){
      var fm = document.inputForm;
      var pages = parseInt(fm.pages.value);
      var thispage = parseInt(fm.page.value);
      var thepage =parseInt(trim(fm.gopage.value));

      if(thepage==''){
         alert("Please specify the value of the page to go to!");//Please specify the value of the page to go to!
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
        alert("The value of the page to go to can only be a digital number!");//The value of the page to go to can only be a digital number
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!");//alert("转到的页码值范围不正确  页）!
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      if(thepage==thispage){
         alert("This page has been displayed currently. Please re-specify a page!");//This page has been displayed currently. Please re-specify a page!
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }
   
   function setRingInfo (ringid, subindex)
   {
     var fm = document.inputForm;
     fm.rsubindex.value = subindex;
     fm.ringid.value = ringid;
     fm.op.value = 'add';
     fm.submit();
   }
   function getEditInfo (ringid,newringid,subindex) {
     var fm = document.inputForm;
     fm.rsubindex.value = subindex;
     fm.ringid.value = newringid;
     fm.newringid.value = newringid;
     fm.op.value = 'edit';
     fm.submit();
   }
   function addInfo (){
     window.open('videoZoneRingAdd.jsp','videoZoneRingAdd','width=400, height=280,top='+((screen.height-280)/2)+',left='+((screen.width-400)/2));
   }
   function editInfo (ringid,ringlabel,rsubindex) {
     var fm = document.inputForm;

     var editURL = 'videoZoneRingEdit.jsp?ringid='+ringid+'&ringlabel='+ringlabel+'&rsubindex='+rsubindex;
     window.open(editURL,'videoZoneRingEdit','width=400, height=300,top='+((screen.height-300)/2)+',left='+((screen.width-400)/2));
   }
   function delInfo (ringid,rsubindex) {
     var fm = document.inputForm;
     fm.rsubindex.value = rsubindex;
     fm.ringid.value = ringid;
     fm.op.value = 'del';
     fm.submit();
   }   
</script>
<script language="JavaScript">
	var hei=600;
	if(parent.frames.length>0){

<%
	if(vet==null || vet.size()<15 || vet.size()==15){
%>
	hei = 600;
<%
	}else if(vet.size()>15 && vet.size()<25){
%>
	hei = 600 + (<%= vet.size()%>-15)*20;

<%
	}else{
%>
	hei = 900;

<%
}
%>
	parent.document.all.main.style.height=hei;
    }

</script>

<form name="inputForm" method="post" action="videoZoneMgmt.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="op" value="">
<input type="hidden" name="ringid" value="">
<input type="hidden" name="newringid" value="">
<input type="hidden" name="rsubindex" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
    <td width="100%">
    <table  width="98%" border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td width="10"></td>
          <td></td><table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Video Zone Management</td>
        </tr>
      </table>
      </td>
          
        </tr>
        <tr>
          <td colspan="4">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
    <tr>
    <td><img src="../button/add.gif" alt="Add ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
    </tr>
    <tr>
    <td width="100%" align="center">
      <table width="98%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style4">
         <tr class="tr-ringlist">
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone code">Code</span></font></div>
                  </td>
                  <td height="30" width="100">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone name"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></span></font></div>
                  </td>

                   <td height="30" width="60" >
                     <div align="center"><font color="#FFFFFF"><span title="Ringtone provider">Content Provider</span></font></div>
                   </td>
                    <%if(useringsource.equals("1")){//modify by ge quanmin 2005-07-07%%>
                    <td height="30" width="60" >
                      <div align="center"><font color="#FFFFFF"><%=ringsourcename%></font></div>
                    </td>
                    <%}%>
                  <td height="30"  width="60"  >
                    <div align="center"><font color="#FFFFFF"><%=singer_name%></font></div>
                  </td>
                <%if(userday.equalsIgnoreCase("1"))
                    {%>
                  <td height="30" width="50" >
                    <div align="center"><font color="#FFFFFF">Validity period of subscriber(day)</font></div>
                  </td>
                 <%}%>
                  <td height="30" width="50" >
                    <div align="center"><font color="#FFFFFF"><span title="Validity period of copyright">Copyright validity</span></font></div>
                  </td>
                  <%if("1".equals(isAdRing)){%>
                  <td height="30" width="50">
                    <div align="center"><font color="#FFFFFF"><span title="advertisement ringtone or not">Ad. ringone</span></font></div>
                    </td>
                  <%}%>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><span title="Monthly Price(<%=majorcurrency%>)">Monthly Price(<%=majorcurrency%>)</span></font></div>
                  </td>
                   <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><span title="Daily Price(<%=majorcurrency%>)">Daily Price(<%=majorcurrency%>)</span></font></div>
                  </td>
		  <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="Preview this ringtone">Preview</span></font></div>
                </td>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="Delete this ringtone">Delete</span></font></div>
                </td>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="Edit this ringtone">Edit</span></font></div>
                </td>
              </tr>

<%
        int count = vet.size() == 0 ? 25 : 0;
        String isadflag = "";
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash = (HashMap)vet.get(i);
            count++;
        if("1".equals((String)hash.get("isadflag"))){
              isadflag = "Yes";
            }else{
              isadflag = "No";
            }
%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td height="20"><%= (String)hash.get("ringid") %></td>
        <td height="20"><%= displayRingName((String)hash.get("ringlabel")) %></td>
        <td height="20"><%= displaySpName((String)hash.get("ringsource")) %></td>
        <!--取ringsource字段-->
        <%if(useringsource.equals("1")){%>
        <td height="20"><%=displaySpName((String)hash.get("producer"))%></td>
        <%}%>
        <td height="20"><%= displayRingAuthor((String)hash.get("ringauthor")) %></td>
        <%if(userday.equalsIgnoreCase("1"))
         {%>
        <td height="20"  align="center"><%= (String)hash.get("uservalidday") %></td>
      <%}%>
        <td height="20"><%= (String)hash.get("validtime") %></td>
      <%if("1".equals(isAdRing)){%>
         <td height="20"><%= isadflag%></td>
         <%}%>
      <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee")) %></div></td>
       <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee2")) %></div></td>   	
          	
        <td height="20">
          <div align="center">
            <font class="font-ring"">
              <%
                  String strPhoto="../image/play.gif";
                  String strMediatype=(String)hash.get("mediatype");
                  if("2".equals(strMediatype))
                  {
                    strPhoto="../image/play1.gif";
                  }
                  else if("4".equals(strMediatype))
                  {
                    strPhoto="../image/play2.gif";
                  }
                  else
                  {
                    strPhoto="../image/play.gif";
                  }
              %>
            <img src="<%= strPhoto %>"  height='15'  width='15' alt="Preview this ringtone" onmouseover="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("ringauthor") %>','<%= (String)hash.get("mediatype") %>')">
            </font>
          </div>
        </td>
        <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/delete.gif" width="15" height="15" alt="Delete" onMouseOver="this.style.cursor='hand'" onclick="javascript:delInfo('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("libindex") %>')"></font></div></td>
        <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/edit.gif"   width="15" height="15" alt="Edit" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("buytimes") %>')"></font></div></td>
        </tr>
<%
         }
        if (vet.size() > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1 %>&nbsp;pages&nbsp;&nbsp;You are now on Page &nbsp;<%= thepage+1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
        </tr>
        <tr>
          <td colspan="5" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >Page&nbsp;</td>
             <td> <input style=text value="<%= String.valueOf(thepage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
             <td ><img src="../button/go.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:goPage()"  ></td>
            </tr>
            </table>
          </td>
       </tr>
      </table>
    </td>
  </tr>
<%
        }
%>
</table>
</form>

<%
        }
        else {
          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system!
                    parent.document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert("Sorry,you have no access to the function!");//Sorry,you have no access to this function!
              </script>
              <%
              }
         }
    }
   catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + "exception occourred in Video Zone Management "+ zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" category");//分类铃音管理过程出现异常!
        sysInfo.add(sysTime + e.toString());
        vet.add("Error occourred in Video Zone Management");//ivr分类铃音管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="videoZoneMgmt.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
