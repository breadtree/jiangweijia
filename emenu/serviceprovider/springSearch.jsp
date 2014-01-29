<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.QryXbase" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.CrbtUtil" %>


<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
    String issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice","0");
	String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
	int largessflag = 0;
	if(disLargess.equals("1"))
          largessflag = 1;
        String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
%>
<html>
<head>
<script src="../pubfun/JsFun.js"></script>
<link href="../manager/style.css" type="text/css" rel="stylesheet">
<title><%= colorName %>System</title>
<base target="_self"/>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<%
       int ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia",0);
	   String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	   int isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage",0);
       int imageup = zte.zxyw50.util.CrbtUtil.getConfig("imageup",0);
	   String audioring = zte.zxyw50.util.CrbtUtil.getConfig("audioring","Audio");
       String videoring = zte.zxyw50.util.CrbtUtil.getConfig("videoring","Video");
       String photoring = zte.zxyw50.util.CrbtUtil.getConfig("photoring","Photo");
	 //String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	 //String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	 //int ratio = Integer.parseInt(currencyratio);


    String jName = (String)application.getAttribute("JNAME");
    String operName = (String)session.getAttribute("OPERNAME");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String xbaseenable = CrbtUtil.getConfig("xbaseenable","0");
    String sysTime = "";
    //3.17.07
    String queryMode = request.getParameter("queryMode") == null ? "" : request.getParameter("queryMode");
    try {
        String operID = (String)session.getAttribute("OPERID");
        sysTime = ColorRing.getSysTime() + "--";
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The keyword you entered is too long. Please re-enter!");//您输入的关键字长度超过限制,请重新输入!
        String sortBy = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
        String searchkey = request.getParameter("searchkey") == null ? "singgername" : (String)request.getParameter("searchkey");
        String mediatype = request.getParameter("mediatype") == null ? "" : (String)request.getParameter("mediatype");
		String hidemediatype = request.getParameter("hidemediatype") == null ? "" : (String)request.getParameter("hidemediatype");
		 if(hidemediatype.equals("1")){
          mediatype = "1";
        }

        Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    	String spIndex = (String)session.getAttribute("SPINDEX");
    	String spCode ="";
    	String spname = "";
        String ringoption = "";
        String errMsg="";
        boolean alertflag=false;
        if (spIndex  == null || spIndex.equals("-1")){
			errMsg = "Sorry, you are not an SP administrator!";//Sorry,you are not the SP administrator
          alertflag=true;
        }
        else if (purviewList.get("10-3") == null)  {
          errMsg = "No access to this function.";//无权访问此功能
          alertflag=true;
        } else if (operID != null) {
          Hashtable tmph = new Hashtable();
          int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
          Vector vet = new Vector();
          Hashtable hash = new Hashtable();

          hash.put("searchvalue",searchvalue);
          hash.put("searchkey",searchkey);
          hash.put("sortby",sortBy);
          hash.put("spindex",spIndex);
          hash.put("mediatype", mediatype);
          if(xbaseenable.equals("1")){
            QryXbase qryRing = new QryXbase();
            vet = qryRing.searchSPRing(hash);
          }else {
            ColorRing colorRing = new ColorRing();
            vet = colorRing.searchSPRing(hash);
          }
%>
<script language="javascript">

   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }

  function tryListen(ringID,ringName,ringAuthor,mediatype) {
     var tryURL = '../manager/tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
     if(trim(mediatype)=='1'){
       preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
     }else if(trim(mediatype)=='2'){
       preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
     }else if(trim(mediatype)=='4'){
       tryURL = '../manager/tryView.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
       preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
     }

   }

   function searchRing (sortBy) {
      fm = document.inputForm;
      if (sortBy.length > 0)
         fm.sortby.value = sortBy;
     /* if (trim(fm.searchvalue.value) == '') {
         alert("Please enter query criteria!");//???????
         fm.searchvalue.focus();
         return;
      }*/
	  if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringid'){
	  	alert("A ringtone code can only be a digital number!");//Ringtone code仅能为数字
		fm.searchvalue.focus();
		return;
	  }
	  if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
	  	alert("Please enter the correct ****.**.** format time when it was added to the database! And this time cannot be later than the current time!");//请按照****.**.**的格式输入正确的入库时间!并且该时间不能大于当前时间!
		fm.searchvalue.focus();
		return;
	  }
      fm.page.value = 0;
      fm.submit();
   }


   function ringInfo (ringid) {
      infoWin = window.open('ringInfo.jsp?ringid=' + ringid,'infoWin','width=400, height=380');
   }

   function confirm(ringid){
     window.returnValue = ringid;
     window.close();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0){
	var hei;
<%
	if(vet.size()<15 ){
%>
	hei = 550;
<%
	}else if(vet.size()>15 && vet.size()<=20){
%>
	hei = 650;
<%
	}else{
%>
	hei = 830;
<%
	}
%>
	}
<%
    if (!queryMode.equals("member")){
%>
		parent.document.all.main.style.height=hei;
<%} %>
</script>
<form name="inputForm" method="post" action="springSearch.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="sortby" value="<%= sortBy %>">
<input type="hidden" name="queryMode" value="<%= queryMode %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
     </td>
   </tr>
<%
             manSysRing sysring = new manSysRing();
             Vector ringLib = sysring.getRingLib();
%>
  <tr>
    <td width="100%">
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td>Select type
              <select size="1" name="searchkey" class="select-style5" style="width:130px">
              <option value="singgername" selected><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></option>
              <option value="ringid">Ringtone code</option>
              <option value="ringlabel">Ringtone name</option>
              <option value="uploadtime">Time into Lib.</option>
            </select>
          </td>
          <td>Keyword
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="40" class="input-style1" >
          </td>
		  <%if(isimage==1 || ismultimedia ==1){%>
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
          <td>Sort
            <select size="1" name="searchmodel" class="select-style5" onchange="javascript:document.inputForm.sortby.value = this.value" style="width:135px">
              <option value="singgername"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></option>
			  <option value="ringid">Ringtone code</option>
              <option value="ringlabel">Ringtone name</option>
               <%if("1".equals(issupportmultipleprice)){%>
              <option value="ringfee2">Daily Price</option><%}%>
              <option value="ringfee"> <%if("1".equals(issupportmultipleprice)){%>Monthly <%}%>Price</option>
              <option value="buytimes">Number of orders</option>
        <% if(largessflag!=1){%>
              <option value="largesstimes">Number of presents</option>
        <%}%>
              <option value="uploadtime">Time to Lib.</option>
            </select>
          </td>
          <td><img src="../button/search.gif" alt="Find ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
        </tr>
      </table>
    </td>
  </tr>
<script language="javascript">
   if ('<%= searchkey %>' != '-1')
      document.inputForm.searchkey.value = '<%= searchkey %>';
   if ('<%= sortBy %>' != '')
      document.inputForm.searchmodel.value = '<%= sortBy %>';
</script>
  <tr>
    <td width="100%">
      <table width="95%" border="0" cellspacing="1" cellpadding="3" align="left" class="table-style4">
         <tr class="tr-ringList">
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone code">Code</span></font></div>
                  </td>
                  <td height="30">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone name">Name</span></font></div>
                  </td>
                  <td height="30" >
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone Singer"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></span></font></div>
                  </td>
                   <%if("1".equals(issupportmultipleprice)){%>
                  <td height="30"  align="center">
                    <div align="center"><font color="#FFFFFF"><span title="Daily Price(<%=majorcurrency%>)">Daily Price(<%=majorcurrency%>)</span></font></div>
                  </td>
                  <%} %>
                  <td height="30"  align="center">
                    <div align="center"><font color="#FFFFFF"><span title=" <%if("1".equals(issupportmultipleprice)){%>Monthly <%} %>Price(<%=majorcurrency%>)"> <%if("1".equals(issupportmultipleprice)){%>Monthly <%}%>Price(<%=majorcurrency%>)</span></font></div>
                  </td>
                  <td height="30" align="center">
                    <div align="center"><font color="#FFFFFF"><span title="Number of orders">Orders</span></font></div>
                  </td>
       <% if(largessflag!=1){%>
                  <td height="30"  align="center">
                    <div align="center"><font color="#FFFFFF"><span title="Number of presents">Presents</span></font></div>
                  </td>
       <%}%>
                           <td height="30" width="20"  style="display: none">
                  <div align="center"><font color="#FFFFFF">Mediatype</font></div>
                </td>
            
				  <td height="30">
                  <div align="center"><font color="#FFFFFF"><span title="Listen the ringtone">Preview</span></font></div>
                </td>
                   <td height="30">
                  <div align="center"><font color="#FFFFFF"><span title="Ringtone Info">Info</span></font></div>
        </td>
        <% if (queryMode.equals("member")){%>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">Confirm</font></div>
                </td>
        <%} %>
              </tr>

<%
        int size =vet.size();
        if(size==0){
%>
	<!--	<tr><td colspan="8" align="center">暂时没有铃音记录!</td></tr> -->
<%
        }else{
        int count = vet.size() == 0 ? 25 : 0;

        for (int i = thepage * 25; i < thepage * 25 + 25 && i < size; i++) {
            hash = (Hashtable)vet.get(i);
            count++;
             String mediashow = (String)hash.get("mediatype");
            if(mediashow.equals("1")){
              mediashow = zte.zxyw50.util.CrbtUtil.getConfig("audioring","Audio");
            }
            if(mediashow.equals("2")){
              mediashow = zte.zxyw50.util.CrbtUtil.getConfig("videoring","Video");
            }
            if(mediashow.equals("4")){
              mediashow = zte.zxyw50.util.CrbtUtil.getConfig("photoring","Photo");
            }
%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td height="20"><%= (String)hash.get("ringid") %></td>
        <td height="20"><%= displayRingName((String)hash.get("ringlabel")) %></td>
        <td height="20"><%= displayRingAuthor((String)hash.get("ringauthor")) %></td>
         <%if("1".equals(issupportmultipleprice)){%>
        <td height="20">
          <div align="center"><%= displayFee((String)hash.get("ringfee2")) %></div></td>
          <%}%>
        <td height="20">
          <div align="center"><%= displayFee((String)hash.get("ringfee")) %></div></td>
        <td height="20">
          <div align="center"><%= (String)hash.get("buytimes") %></div></td>
     <% if(largessflag!=1){%>
        <td height="20">
          <div align="center"><%= (String)hash.get("largesstimes") %></div></td>
     <%}%>
                     <td height="30" width="20" style="display: none">
                  <div align="center"><%= mediashow%></div>
                </td>
   
     
        <td height="20">
          <div align="center"><font class="font-ring">
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
            <img src="<%= strPhoto %>"  height='15'  width='15' alt="Preview" onmouseover="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("ringauthor") %>','<%= (String)hash.get("mediatype") %>')">
            </font>
           </div></td>
                 <td height="20">
          <div align="center"><img src="../image/info.gif" height=15 width=15 alt="Details" onmouseover="this.style.cursor='hand'" onclick="javascript:ringInfo('<%= (String)hash.get("ringid") %>')"></div></td>
      <% if (queryMode.equals("member")){ %>
        <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/icon_search.gif" height=15 width=15 alt="select this ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:confirm('<%= (String)hash.get("ringid") %>')"></font></div></td>
<%
      }
%>
</tr>
<%
    }
    if (size > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="95%">
      <table border="0" cellspacing="1" cellpadding="1" align="left" class="table-style2">
        <tr>
          <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              &nbsp;<%= size %>&nbsp;entries in total&nbsp;<%= size%25==0?size/25:size/25+1%>&nbsp;pages&nbsp;You are now on page&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= size ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (size - 1) / 25 %>)"></td>
        </tr>
      </table>
    </td>
  </tr>
<%
        }
     }
%>


</table>
</form>
<%}else {
			errMsg = "Please log in to the system first!";
    alertflag=true;
  }if(alertflag==true){
%>
<script language="javascript">
   var errorMsg = '<%= operID!=null?errMsg:"Please log in to the system first!"%>';
   alert(errorMsg);
   document.URL = 'enter.jsp';
</script>
<%  }
    }
    catch (Exception e) {
    Vector vet1 = new Vector();
        sysInfo.add(sysTime + operName + ",Exception occurred in searching the ring back tone!");//铃音检索过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet1.add("Error occurred in searching the ring back tone!");//铃音检索过程出现错误
        vet1.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet1);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="springSearch.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
