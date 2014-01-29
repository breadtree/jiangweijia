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
<%    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
    String useweekstar = CrbtUtil.getConfig("weekstar","0");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title><%= colorName %> System</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="loadpage(document.forms[0])" >
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    int iDispOpcode = 0;
	String isSingerAlias1 =  zte.zxyw50.util.CrbtUtil.getConfig("singeralias1","0");
	String isSingerAlias2 =  zte.zxyw50.util.CrbtUtil.getConfig("singeralias2","0");
	String isExtraSingerInfo =  zte.zxyw50.util.CrbtUtil.getConfig("extra_singerinfo","0");
	String imgDir = (String)CrbtUtil.getConfig("singerpath","0");
    try {
            if (operID != null && purviewList.get("2-6") != null) {
        sysTime = SocketPortocol.getSysTime() + "--";
        manSysRing sysring = new manSysRing();
           String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The keyword exceeds the limit,please re-enter!");
        String searchkey = request.getParameter("searchkey") == null ? "singgername" : (String)request.getParameter("searchkey");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
         String singgername = request.getParameter("singgername") == null ? "" : transferString((String)request.getParameter("singgername")).trim();
            if(checkLen(singgername,40))
            	throw new Exception("The length of the singer name you entered has exceeded the limit. Please re-enter!");
            String singgersex  = request.getParameter("singgersex") == null ? "0" : transferString((String)request.getParameter("singgersex")).trim();
            String weekstar  = request.getParameter("weekstar") == null ? "0" : transferString((String)request.getParameter("weekstar")).trim();
            String spellsinger = request.getParameter("spellsinger") == null ? "" : transferString((String)request.getParameter("spellsinger")).trim();
            String descrip = request.getParameter("descrip") == null ? "" : transferString((String)request.getParameter("descrip")).trim();
            if(checkLen(descrip,40))
            	throw new Exception("The length of the singer description you entered has exceeded the limit. Please re-enter!");//������ĸ���������Ϣ���ȳ�������\uFFFD,����������!
            String singerid = request.getParameter("singerid") == null ? "" : transferString((String)request.getParameter("singerid")).trim();
          String title = "";
        
		 String sSingerAlias1= request.getParameter("singer_alias1") == null ? "" : transferString((String)request.getParameter("singer_alias1")).trim();
         String sSingerAlias2= request.getParameter("singer_alias2") == null ? "" : transferString((String)request.getParameter("singer_alias2")).trim();
		 String sSingerImage= request.getParameter("singer_image") == null ? "" : transferString((String)request.getParameter("singer_image")).trim();
		 String sRegion = request.getParameter("region") == null ? "" : transferString((String)request.getParameter("region")).trim();


         int  optype = 0;
         ArrayList rList = new ArrayList();
		 ArrayList aExtraInfoList = new ArrayList();
         if(op.equals("del")){
          optype=1;
		  iDispOpcode=2;
          title="Delete singer";
         }
          if(!op.equals("")){
            if(isExtraSingerInfo.equals("1")){
              StringTokenizer token = new StringTokenizer(imgDir, "|" );
			boolean fResult=false;
              if(iDispOpcode==2) {
    			if(sSingerImage!=null && !sSingerImage.equals("")) {
    					int m=0;
					while(token.hasMoreTokens())
					{
						String sEachImgDirInfo=token.nextToken();
						if(sEachImgDirInfo!=null && !sEachImgDirInfo.equals("")) {
							String filePath = sEachImgDirInfo + sSingerImage;
							java.io.File file = new java.io.File(filePath);
							try{
							fResult=file.delete();
							}catch(Exception e) {
								e.printStackTrace(); 
							}
							/*if(!fResult) {
								throw new Exception("Delete: deletion of image file failed");  
							}  */
						}
						m++;
					}
       			}
			}

          }
            HashMap  map1=new HashMap();
            map1.put("optype",optype+"");
            map1.put("singerid",singerid);
            map1.put("singgername",singgername);
            map1.put("singgersex",singgersex);
            map1.put("spellsinger",spellsinger);
            map1.put("descrip",descrip);
            map1.put("weekstar",weekstar);
            rList = sysring.setSinger(map1);
             if(rList.size()>0){
               session.setAttribute("rList",rList);
             %>
             <form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="singer.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
             <%}
          }
        ArrayList list  = new ArrayList();
        Hashtable hash1 = new Hashtable();
        HashMap hash = new HashMap();
         hash1.put("searchkey",searchkey);
         hash1.put("searchvalue",searchvalue);
         list = sysring.getSingerbyconditon(hash1);
        int pages = list.size()/25;
        if(list.size()%25>0)
          pages = pages + 1;
%>
<script language="javascript">
   var datasource;
   function loadpage(pform){
      var sTmp = "<%=  searchkey  %>";
   }

   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }

   function searchSinger() {
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
         alert("Please specify the value of the page to go to!")
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
         alert("The value of the page to go to can only be a digital number!")
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!")
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      if(thepage==thispage){
         alert("This page has been displayed currently. Please re-specify a page!")
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }
  <%if(isExtraSingerInfo.equals("1")){%>
   function editSinger (singerid,singgername,singgersex,spellsinger,descrip,weekstar,alias1,alias2,singerimage,region) {
    // var result =  window.showModalDialog('singerInfo.jsp?singerid='+singerid+'&singgername=' + encodeURIComponent(singgername)+'&singgersex=' + singgersex+'&spellsinger=' + encodeURIComponent(spellsinger)+'&descrip=' + encodeURIComponent(descrip)+'&weekstar=' + weekstar+'&alias1_name='+encodeURIComponent(alias1)+'&alias2_name='+encodeURIComponent(alias2)+'&filename='+singerimage+'&region='+encodeURIComponent(region),window,"scroll:yes;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:350px;dialogWidth:410px");
    // window.open('singerInfo.jsp?singerid='+singerid+'&singgername=' + encodeURIComponent(singgername)+'&singgersex=' + singgersex+'&spellsinger=' + encodeURIComponent(spellsinger)+'&descrip=' + encodeURIComponent(descrip)+'&weekstar=' + weekstar+'&alias1_name='+encodeURIComponent(alias1)+'&alias2_name='+encodeURIComponent(alias2)+'&filename='+singerimage+'&region='+encodeURIComponent(region),'window',"width=410,height=350");
    var result= window.showModalDialog('singerInfo.jsp?singerid='+singerid+'&singgername=' + encodeURIComponent(singgername)+'&singgersex=' + singgersex+'&spellsinger=' + encodeURIComponent(spellsinger)+'&descrip=' + encodeURIComponent(descrip)+'&weekstar=' + weekstar+'&alias1_name='+encodeURIComponent(alias1)+'&alias2_name='+encodeURIComponent(alias2)+'&filename='+singerimage+'&region='+encodeURIComponent(region),'window',"scroll:yes;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:360px;dialogWidth:410px");
     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }
   }
<%}else{%>
   function editSinger (singerid,singgername,singgersex,spellsinger,descrip,weekstar) {
     var result =  window.showModalDialog('singerInfo.jsp?singerid='+singerid+'&singgername=' + encodeURIComponent(singgername)+'&singgersex=' + singgersex+'&spellsinger=' + encodeURIComponent(spellsinger)+'&descrip=' + encodeURIComponent(descrip)+'&weekstar=' + weekstar,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:250px;dialogWidth:410px");

     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }
   }
<%}%>
   function addSinger () {
     var opcode='add';
     var result =   window.open('singerInfo.jsp?opcode='+opcode,'AddWindow','width=410, height=350');
	 //var result = window.showModalDialog('singerInfo.jsp?opcode='+opcode,window,"scroll:yes;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:350px;dialogWidth:410px");
	
     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }
   }
<%if(isExtraSingerInfo.equals("1")){%>
   function delSinger(singerid,singgername,singgersex,spellsinger,descrip,weekstar,alias1,alias2,singerimage,region){
      var fm = document.inputForm;
      fm.singerid.value=singerid;
      fm.singgername.value=singgername;
      fm.singgersex.value=singgersex;
      fm.spellsinger.value=spellsinger;
      fm.descrip.value=descrip;
      fm.weekstar.value=weekstar;
	  fm.singer_alias1.value=alias1;
	  fm.singer_alias2.value=encodeURIComponent(alias2);
	  fm.singer_image.value=singerimage;
	  fm.region.value=region;
      fm.op.value = 'del';
      if(!confirm("Are you sure to delete the information of this singer?")) //��ȷ��Ҫɾ��ø�����Ϣ��\uFFFD
         return ;
      fm.submit();
   }
<%}else
{%>
   function delSinger(singerid,singgername,singgersex,spellsinger,descrip,weekstar){
      var fm = document.inputForm;
      fm.singerid.value=singerid;
      fm.singgername.value=singgername;
      fm.singgersex.value=singgersex;
      fm.spellsinger.value=spellsinger;
      fm.descrip.value=descrip;
      fm.weekstar.value=weekstar;
      fm.op.value = 'del';
      if(!confirm("Are you sure to delete the information of this singer?")) //��ȷ��Ҫɾ��ø�����Ϣ��\uFFFD
         return ;
      fm.submit();
   }
<%}%>

</script>
<script language="JavaScript">
	var hei=600;
	if(parent.frames.length>0){
<%
	if(list==null || list.size()<15 || list.size()==15){
%>
	hei = 600;
<%
	}else if(list.size()>15 && list.size()<25){
%>
	hei = 600 + (<%= list.size()%>-15)*20;
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
<form name="inputForm" method="post" action="singer.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="op" value="">
<input type="hidden" name="singerid" value="">
<input type="hidden" name="singgername" value="">
<input type="hidden" name="singgersex" value="">
<input type="hidden" name="spellsinger" value="">
<input type="hidden" name="spellsinger" value="">
<input type="hidden" name="descrip" value="">
<input type="hidden" name="weekstar" value="">

<input type="hidden" name="singer_alias1" value="">
<input type="hidden" name="singer_alias2" value="">
<input type="hidden" name="singer_image" value="">
<input type="hidden" name="region" value="">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr>
    <td width="100%">
    <table width="98%" border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td width="10"></td>
		  <td>
            Select type
            <select size="1" name="searchkey" class="select-style1" >
              <%if(searchkey.equals("singgername")){%>
              <option value="singgername" selected="selected"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name</option>
              <option value="spellsinger">Spelling of <%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></option>
              <%}else{%>
              <option value="singgername"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name</option>
              <option value="spellsinger" selected="selected">Spelling of <%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></option>
              <%}%>
            </select>
          </td>
          <td>Key word
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" >
          </td>
          <td><img src="button/search.gif" alt="Search singer" onmouseover="this.style.cursor='hand'" onclick="javascript:searchSinger()"></td>
            <td><img src="button/add.gif" alt="Add singer" onmouseover="this.style.cursor='hand'" onclick="javascript:addSinger()"></td>
        </tr>
        <tr>
          <td colspan="4">
              &nbsp;
          </td>
        </tr>
      </table>
    </td>
  </tr>

  <tr>
    <td width="100%" align="center">
      <table width="98%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style4">
         <tr class="tr-ringlist">
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name</font></div>
                  </td>
                  <td height="30" width="60">
                    <div align="center"><font color="#FFFFFF">Gender</font></div>
                  </td>
                  <td height="30" width="60">
                    <div align="center"><font color="#FFFFFF">Spelling of <%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></font></div>
                  </td>
                  <td height="30"  width="80" >
                    <div align="center"><font color="#FFFFFF">Note</font></div>
                  </td>
                  <td height="30" width="60" style="<%=("0".equals(useweekstar)?"display: none ":"display: block ")%>">
                       <%if("2".equals(useweekstar))
                      {%>
                        <div align="center"><font color="#FFFFFF"> Artiste of The Month</font></div>
                      <%} else{%>
                      <div align="center"><font color="#FFFFFF">The star of this week</font></div>
                      <%}%>

                  </td>
		  <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">Delete</font></div>
                </td>
                 <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">Edit</font></div>
                </td>
              </tr>

<%
        int count = list.size() == 0 ? 25 : 0;

        for (int i = thepage * 25; i < thepage * 25 + 25 && i < list.size(); i++) {
            hash = (HashMap)list.get(i);
            count++;
%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td height="20"><%= (String)hash.get("singgername") %></td>
        <td height="20" align="center"><%= displaySex((String)hash.get("singgersex")) %></td>
        <td height="20"><%= (String)hash.get("spellsinger")%></td>
        <td height="20"><%= (String)hash.get("descrip")%></td>
         <%if(!("0".equals(useweekstar))){%>
         <td height="20"><%= displayWeekstar((String)hash.get("weekstar"))%></td>
        <%}if(isExtraSingerInfo.equals("1")){%>
        <td height="20" width="40" align="center">
          	<img src="../image/delete.gif" height='15'  width='15'  alt="Delete"  height='15'  width='15'  onMouseOver="this.style.cursor='hand'" onclick="javascript:delSinger('<%= (String)hash.get("singerid") %>','<%= (String)hash.get("singgername") %>','<%= (String)hash.get("singgersex") %>','<%= (String)hash.get("spellsinger") %>','<%= (String)hash.get("descrip") %>','<%= (String)hash.get("weekstar") %>','<%= (String)hash.get("alias1") %>','<%= (String)hash.get("alias2") %>','<%= (String)hash.get("filename") %>','<%= (String)hash.get("region") %>')">
        </td>
        <td height="20" width="20">
          <div align="center"><font class="font-ring"><img src="../image/edit.gif"   height='15'  width='15'  alt="Edit" onmouseover="this.style.cursor='hand'" onclick="javascript:editSinger('<%= (String)hash.get("singerid") %>','<%= (String)hash.get("singgername") %>','<%= (String)hash.get("singgersex") %>','<%= (String)hash.get("spellsinger") %>','<%= (String)hash.get("descrip") %>','<%= (String)hash.get("weekstar") %>','<%= (String)hash.get("alias1") %>','<%= (String)hash.get("alias2") %>','<%= (String)hash.get("filename") %>','<%= (String)hash.get("region") %>','<%= (String)hash.get("extrasingerid") %>')"></font>
          </div>
        </td><%}else
        {%>
        <td height="20" width="40" align="center">
          	<img src="../image/delete.gif" height='15'  width='15'  alt="Delete"  height='15'  width='15'  onMouseOver="this.style.cursor='hand'" onclick="javascript:delSinger('<%= (String)hash.get("singerid") %>','<%= (String)hash.get("singgername") %>','<%= (String)hash.get("singgersex") %>','<%= (String)hash.get("spellsinger") %>','<%= (String)hash.get("descrip") %>','<%= (String)hash.get("weekstar") %>')">
        </td>
        <td height="20" width="20">
          <div align="center"><font class="font-ring"><img src="../image/edit.gif"   height='15'  width='15'  alt="Edit" onmouseover="this.style.cursor='hand'" onclick="javascript:editSinger('<%= (String)hash.get("singerid") %>','<%= (String)hash.get("singgername") %>','<%= (String)hash.get("singgersex") %>','<%= (String)hash.get("spellsinger") %>','<%= (String)hash.get("descrip") %>','<%= (String)hash.get("weekstar") %>')"></font>
          </div>
        </td>
        <%}%>
   </tr>
<%
         }
        if (list.size() > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;<%= list.size() %>&nbsp;entries in total&nbsp;<%= list.size()%25==0?list.size()/25:list.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on page &nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= list.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (list.size() - 1) / 25 %>)"></td>
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
        sysInfo.add(sysTime + operName + " Exception occurs in managing singers !");//���ֹ����̳����쳣
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs in managing singers !");//���ֹ����̳��ִ���
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="singer.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
