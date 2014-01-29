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
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
     //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    //add end
	String isSmartPriceFlag = CrbtUtil.getConfig("isSmartPriceFlag","0");
String userday = CrbtUtil.getConfig("uservalidday","0");
String isAdRing = CrbtUtil.getConfig("isshowad","0");

int ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia",0);
int isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage",0);
int imageup = zte.zxyw50.util.CrbtUtil.getConfig("imageup",0);

String audioring = zte.zxyw50.util.CrbtUtil.getConfig("audioring","Audio");
String videoring = zte.zxyw50.util.CrbtUtil.getConfig("videoring","Video");
String photoring = zte.zxyw50.util.CrbtUtil.getConfig("photoring","Photo");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Search ringtone</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onLoad="loadpage(document.forms[0])" >
  <base target="_self">
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

 	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

    try {
            if (operID != null && purviewList.get("2-3") != null) {
        sysTime = SocketPortocol.getSysTime() + "--";
        manSysRing sysring = new manSysRing();
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        String oper = request.getParameter("oper") == null ? "" : transferString((String)request.getParameter("oper"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The length of the keyword you entered has exceeded the limit. Please re-enter!");//您输入的关键字长度超出限制,请重新输入!
//        String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
        String sortby =  "" ;
        String libid = request.getParameter("ringlib") == null ? "0" : (String)request.getParameter("ringlib");
        String spindex = request.getParameter("spindex") == null ? "0" : (String)request.getParameter("spindex");
        String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
        String mediatype = request.getParameter("mediatype") == null ? "" : (String)request.getParameter("mediatype");
        String hidemediatype = request.getParameter("hidemediatype") == null ? "" : (String)request.getParameter("hidemediatype");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        if(hidemediatype.equals("1")){
          mediatype = "1";
        }
        ArrayList vet = new ArrayList();
        Hashtable hash1 = new Hashtable();
        HashMap hash = new HashMap();
        if(searchkey.equals("sp"))
            hash1.put("searchvalue",spindex);
        else
            hash1.put("searchvalue",searchvalue);
        hash1.put("searchkey",searchkey);
        hash1.put("sortby",sortby);
        hash1.put("libid","503" );
        hash1.put("mediatype",mediatype );
        ColorRing  colorring = new ColorRing();
        vet = colorring.searchRingToManager(hash1);

        int pages = vet.size()/25;
        if(vet.size()%25>0)
          pages = pages + 1;

        manSysPara syspara = new manSysPara();
        ArrayList spInfo = new ArrayList();
        spInfo = syspara.getSPInfo();
        HashMap map = new HashMap();
%>
<script language="javascript">

   function loadpage(pform){
      var sTmp = "<%=  searchkey  %>";
      if(sTmp=='sp'){
         document.all('id_spshow').style.display= 'block';
         var value  = <%=  spindex  %>;
         document.forms[0].spindex.value = value;
      }
     else
        document.all('id_keyshow').style.display= 'block';
   }

  function modeChange(){
      if(document.forms[0].searchkey.value=='sp'){
         document.all('id_keyshow').style.display= 'none';
         document.all('id_spshow').style.display= 'block';
      }
      else{
         document.all('id_keyshow').style.display= 'block';
         document.all('id_spshow').style.display= 'none';
      }
   }




   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }

   function tryListen (ringID,ringName,ringAuthor) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }

   function searchRing (sortby) {
      fm = document.inputForm;
      if (sortby.length > 0)
         fm.sortby.value = sortby;
//      if (trim(fm.searchvalue.value) == '') {
//         alert('请输入查询条件!');
//         fm.searchvalue.focus();
//         return;
//      }
      if (trim(fm.searchvalue.value) != '') {
          if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringid'){
              alert("The No. of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> can only be a digital number!");//Ringtone code仅能为数字!
              fm.searchvalue.focus();
              return;
          }
          if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
              alert('Please enter the correct ****.**.** format time when it was added to the database! And this time cannot be later than the current time!');//请按照****.**.**的格式输入正确的入库时间!并且该时间不能大于当前时间!
              fm.searchvalue.focus();
              return;
          }
      }
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
   function confirm (ringid) {
       var agt=navigator.userAgent.toLowerCase();
       var is_ie=(agt.indexOf("msie")!=-1 && document.all);
        if(is_ie)
        {
                window.returnValue = ringid;
		window.opener.document.inputForm.ringID.value = ringid;
         }
		else
		{
		         window.opener.document.getElementById("res").value = ringid;
        }
       window.close();
//       var libid = document.inputForm.ringlib.value;
//     var result =  window.showModalDialog('ringInfo.jsp?libid='+libid+'&ringid=' + ringid,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:250px;dialogWidth:410px");
//     if(result&&(result=='yes')){
//         var thispage = parseInt(document.inputForm.page.value);
//         toPage(thispage);
//     }
   }
   function delRing (ringid,libid,ringlabel) {
	     var fm = document.inputForm;
//       var libid = document.inputForm.ringlib.value;
      var sresult = "";
     var agt=navigator.userAgent.toLowerCase();
     var is_ie=(agt.indexOf("msie")!=-1 && document.all);
     if(is_ie)
    {
     sresult = window.showModalDialog('delRing.jsp?libid='+libid+'&ringid=' + ringid+'&ringlabel='+ringlabel,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:250px;dialogWidth:410px");
	 }
	else
  {
		netscape.security.PrivilegeManager.enablePrivilege('UniversalBrowserWrite');     window.open('delRing.jsp?libid='+libid+'&ringid=' + ringid+'&ringlabel='+ringlabel,'window','modal=YES,resizable=NO,scrollbars=NO,status=0,left='+((screen.width-410)/2)+',top='+((screen.height-250)/2)+',width=410px,height=250px'); ;
        sresult = fm.result.value;
  }
     if(sresult&&(sresult=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }
   }

  function ringInfo (ringid, buytimes,largesstimes) {
					//  document.URL ='ringInfo.jsp?ringid=' + ringid + '&libid=' + libid;
				 var url ='ringInfo1.jsp?ringid=' + ringid + '&ringtype=1&fromCCS=true'+ '&buytimes=' + buytimes + '&largesstimes=' + largesstimes;
                    window.showModalDialog(url,window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-500)/2)+";dialogTop:"+((screen.height-500)/2)+";dialogHeight:500px;dialogWidth:500px");
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
<form name="inputForm" method="post" action="ringSearch3.jsp?oper=<%=oper%>">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="ringlib" value="0">
<input id="res" type="hidden" name="result" value=""/>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">

<%
        Vector ringLib = sysring.getRingLibraryInfo();
%>
  <script language="JavaScript">
  //modify by gequanmin 2005-07-05

  </script>
<tr>
    <td width="100%">
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td width="10"></td>
		  <td>
            Select type
            <select size="1" name="searchkey" class="select-style5"  onchange="modeChange();" style="width:140px">
              <option value="ringid"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</option>
              <option value="ringlabel"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></option>
              <option value="singgername"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></option>
              <option value="sp">Content Provider</option>
              <option value="uploadtime">Database time</option>
            </select>
          </td>
          <td id="id_keyshow" style="display:none" >Keyword
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" >
          </td>
          <td id="id_spshow" style="display:none">
	    Provider
	    <select name="spindex" class="input-style1"  >
             <option value=0 > All provider</option>
	     <%
                 for (int i = 0; i < spInfo.size(); i++) {
                     map = (HashMap)spInfo.get(i);
                     out.println("<option value="+(String)map.get("spindex") + ">" + (String)map.get("spname") + "</option>");
                 }
         %>
	     </select>
	     </td>
         <%if(isimage==1){%>
         <%if(!hidemediatype.equals("1")){%>
          <td>Mediatype
           <select name="mediatype" class="select-style5" >
             <option value="" <%="".equals(mediatype)?"selected":""%> >All Mediatype</option>
             <option value="1" <%="1".equals(mediatype)?"selected":""%> ><%=audioring%></option>
             <%if(ismultimedia == 1){%>
             <option value="2" <%="2".equals(mediatype)?"selected":""%> ><%=videoring%></option>
             <option value="3" <%="3".equals(mediatype)?"selected":""%> ><%=audioring%>/<%=videoring%></option>
             <%}%>
             <%if(imageup == 1){%>
             <option value="4" <%="4".equals(mediatype)?"selected":""%> ><%=photoring%></option>
             <%}%>
           </select>
         </td>
         <%}else{%>
         <input type="hidden" name="mediatype" value="1">
         <input type="hidden" name="hidemediatype" value="1">
        <% }%>
        <%}%>
          <td  valign="bottom">
              <input type="text" name="ringcatalog" readonly value="Default <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Library" style="width:145px"class="input-style7" >
          </td>
          <td><img src="../button/search.gif" alt="Search ringtone" onMouseOver="this.style.cursor='pointer'" onClick="javascript:searchRing('')"></td>
        </tr>
        <tr>
          <td colspan="4">&nbsp;

          </td>
        </tr>
      </table>
    </td>
  </tr>
<script language="javascript">
   if ('<%= searchkey %>' != '-1')
      document.inputForm.searchkey.value = '<%= searchkey %>';
      document.inputForm.ringlib.value='<%=libid%>';

   //  document.inputForm.ringcatalog.value=name;

</script>
  <tr>
    <td width="100%" align="left">
      <table width="95%" border="0" cellspacing="1" cellpadding="1" align="left" class="table-style4">
         <tr class="tr-ring">
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</font></div>
                  </td>
                  <td height="30" width="120">
                    <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></font></div>
                  </td>
                  <td height="30" width="80" >
                    <div align="center"><font color="#FFFFFF">Content Provider</font></div>
                  </td>
                  <td height="30"  width="60"  >
                    <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></font></div>
                  </td>
                 <%if(userday.equalsIgnoreCase("1"))
                    {%>
                  <td height="30" width="60" >
                    <div align="center"><font color="#FFFFFF">Period of validity</font></div>
                  </td>
   <%}%>
                  <td height="30" width="50" >
                    <div align="center"><font color="#FFFFFF">Period of copyright</font></div>
                  </td>
                   <%if("1".equals(isAdRing)){%>
                  <td height="30" width="60">
                    <div align="center"><font color="#FFFFFF">Ad.ringtone or not</font></div>
                    </td>
                  <%}%>
				    <% if ("1".equals(isSmartPriceFlag)) { %>
                  <td height="30" width="40">
                      <div align="center"><font color="#FFFFFF"><span title="Ringtone Info.">Info.</span></font></div>
                  </td>
				  <% } else { %>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF">Price(<%=majorcurrency%>)</font></div>
                  </td>
				  <% } %>
		  <td height="30" width="20" style="display:none">
                  <div align="center"><font color="#FFFFFF">Pre-listen</font></div>
                </td>
                 <%if(isimage == 1 && !hidemediatype.equals("1")){%>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">Mediatype</font></div>
                </td>
               <%}%>
                <%if(!oper.equals("manager") ){%>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">Confirm</font></div>
                </td>
               <%}%>
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
            String mediashow = (String)hash.get("mediatype");
            if(mediashow.equals("1")){
              mediashow = zte.zxyw50.util.CrbtUtil.getConfig("audioring","Audio");
            }
            if(mediashow.equals("2")){
              mediashow = zte.zxyw50.util.CrbtUtil.getConfig("videoring","Video");
            }
            if(mediashow.equals("4")){
              mediashow = zte.zxyw50.util.CrbtUtil.getConfig("photoring","Phote");
            }

%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td height="20"><%= (String)hash.get("ringid") %></td>
        <td height="20"><%= displayRingName((String)hash.get("ringlabel")) %></td>
        <td height="20"><%= displaySpName((String)hash.get("ringsource")) %></td>
        <td height="20"><%= displayRingAuthor((String)hash.get("ringauthor")) %></td>
          <%if(userday.equalsIgnoreCase("1"))
         {%>
        <td height="20"  align="center"><%= (String)hash.get("uservalidday") %></td>
<%}%>
          <td height="20"><%= (String)hash.get("validtime") %></td>
          <%if("1".equals(isAdRing)){%>
         <td height="20"><%= isadflag%></td>
         <%}%>
  <% if ("1".equals(isSmartPriceFlag)) { %>
		 <td height="20" align="center"><img src="../image/info.gif"  height='15'  width='15' alt="Ringtone Information" onMouseOver="this.style.cursor='hand'" onClick="javascript:ringInfo('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("buytimes") %>','<%= (String)hash.get("largesstimes") %>')">
		  </td>
   <% } else { %>
       <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee")) %></div></td>
	   <% } %>
        <td height="20" style="display:none">
          <div align="center"><font class="font-ring""><img src="../image/play.gif" alt="Pre-listen this ringtone" onMouseOver="this.style.cursor='pointer'" onClick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("ringauthor") %>')"></font></div></td>
          <%if(isimage == 1 && !hidemediatype.equals("1")){%>
                <td height="30" width="20">
                  <div align="center"><%= mediashow%></div>
                </td>
        <%}%>
         <%if(!oper.equals("manager") ){%>
        <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/icon_search.gif" alt="Select this ringtone" onMouseOver="this.style.cursor='pointer'" onClick="javascript:confirm('<%= (String)hash.get("ringid") %>')"></font></div></td>
        </tr>
<%
			}
         }
        if (vet.size() > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="95%" align="left">
      <table border="0" cellspacing="1" cellpadding="1" align="left" class="table-style2">
        <tr>
          <td>&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on Page &nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='pointer'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='pointer'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
        </tr>
        <tr>
          <td colspan="6" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >page&nbsp;</td>
             <td> <input style=text value="<%= String.valueOf(thepage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
             <td ><img src="../button/go.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:goPage()"  ></td>
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
                    alert( "Please log in first!");
                    parent.document.location.href = 'enter.jsp';
		    window.close();
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no right to access this function!");
              </script>
              <%
              }
         }
    }
   catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + " Exception occurred in managing ringtone search!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Errors occurred in managing ringtone search!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</table>
</form>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="ringSearch1.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
