<% 
	String sysTime = "";
	Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
	String jName = (String)application.getAttribute("JNAME");
	String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String sortby =  "" ;
    String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
    int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
	ArrayList vet = new ArrayList();
    HashMap hash = new HashMap();
	int rcount=0;

    try {
            if (operID != null && purviewList.get("4-23") != null) {
				sysTime = SocketPortocol.getSysTime() + "--";
				ColorRing  colorring = new ColorRing();
				Hashtable h = new Hashtable();
				h.put("libid",ringlib);
				h.put("sortby",sortby);
				h.put("searchkey",searchkey);

				vet = colorring.searchRingToManager(h);
				rcount = vet.size();

	            int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
				int pages = rcount/25;
				if(rcount%25>0)
				  pages = pages + 1;

%>
	<script type="text/javascript">
		<!--
		  function trim(str) {
				return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
		  }

		  function isInt(num){
			  var objRegExp = /(^\d+$)/; //(only integers. cnnot be zero length)
			  return objRegExp.test(num);
		  }

		  function toPage (page) {
			  document.inputForm.page.value = page;
			  document.inputForm.submit();
		   }

		   function goPage(){
			  var fm = document.inputForm;
			  var pages = parseInt(fm.pages.value);
			  var thispage = parseInt(fm.page.value);
			  var thepage =parseInt(trim(fm.gopage.value));

			  if(thepage==''){
				 alert("Please specify the value of the page to go to!")//Please specify the value of the page to go to!
				 fm.gopage.focus();
				 return;
			  }
			  if(!isInt(fm.gopage.value)){
				 alert("The value of the page to go to can only be a whole number!")//The value of the page to go to can only be a digital number
				 fm.gopage.focus();
				 return;
			  }
			  if(thepage<=0 || thepage>pages ){
				 alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!")//alert("转到的页码值范围不正确  页）!
				 fm.gopage.focus();
				 return;
			  }
			  thepage = thepage -1;
			  if(thepage==thispage){
				 alert("This page has been displayed currently. Please re-specify a page!")//This page has been displayed currently. Please re-specify a page!
				 fm.gopage.focus();
				 return;
			  }
			  toPage(thepage);
		   }
		   function ringInfo(ringID,buytimes,largesstimes){
		   var rurl = 'ringDetail.jsp?ringid=' + ringID + '&buytimes=' + buytimes + '&largesstimes=' + largesstimes ;
  	
           window.open(rurl,'infoWin','width=400, height=300, top='+(screen.height-355)/2 + ',left='+(screen.width-400)/2);
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
		//-->
	var hei=600;
	if(parent.frames.length>0){
	<%
		if(vet==null || rcount<15 || rcount==15){
	%>
		hei = 600;
	<%
		}else if(rcount>15 && rcount<25){
	%>
		hei = 600 + (<%= rcount%>-15)*20;

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
<style>
	.nodata{
		font-family:arial,verdana,sans;
		font-size:12px;
		color:#000000;
		font-weight:bold;
		text-align:center;
    }
</style>
	<input type="hidden" name="page" value="<%= thepage %>">
	<input type="hidden" name="pages" value="<%= pages %>">


<table width="98%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style2">
         <tr class="tr-ring">
                <td height="30" >Ringtone Name</td>
				<td height="30" align="center">Ringtone Code</td>
				<td height="30" >Artist</td>
				<%if(issupportmultipleprice == 1){%>
				<td height="30"  align="center">Daily Price(<%= majorcurrency %>)</td><%}%>
				<td height="30"  align="center"><%if(issupportmultipleprice == 1){%>Monthly <%}%>Price(<%= majorcurrency %>)</td>
				<td height="30"  align="center">Buy Times</td>
				<td height="30"  align="center">Preview</td>
				<td height="30"  align="center">Info</td>
		</tr>
<%
       if (rcount == 0 ) { %>
		<tr>
			<td class="nodata" colspan="5">No Records Founds! </td>
		</tr>
<%     }
		int count = rcount == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < rcount; i++) {
            hash = (HashMap)vet.get(i);
            count++;
%>

        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">

        <td height="25"><span title="<%=hash.get("ringlabel")%>" ><%= displayRingName((String)hash.get("ringlabel")) %></span></td>
		<td height="25" align="center"><%= hash.get("ringid") %></td>
        <td height="25"><span title="<%= hash.get("ringauthor") %>" ><%= displayRingAuthor((String)hash.get("ringauthor")) %></span></td>
        <%if(issupportmultipleprice == 1){%>
		<td height="25" align="center"><%= displayFee((String)hash.get("ringfee2")) %></td><%}%>
		<td height="25" align="center"><%= displayFee((String)hash.get("ringfee")) %></td>
		<td height="25" align="center"><%= hash.get("buytimes") %></td>
		<td height="25">
          <div align="center">
            <font class="font-ring"">
              <%
                  String strPhoto="../image/play.gif";
                  String strMediatype="1";//(String)hash.get("mediatype");
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
            <img src="<%= strPhoto %>"  height='15'  width='15' alt="Preview" onMouseOver="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("ringauthor") %>','<%= strMediatype %>')">
            </font>
          </div>
        </td>
		<td height="25" align="center"> <img src="../image/info.gif"  height='15'  width='15' alt="Info" onMouseOver="this.style.cursor='hand'" onClick="javascript:ringInfo('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("buytimes") %>','<%= (String)hash.get("largesstimes") %>')"></td>
		</tr>
		<% } %>
	</table>
	<%	if (rcount > 25) { %>
			<table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
			<tr>
			  <td>&nbsp;Total:<%= rcount %>,&nbsp;&nbsp;<%= rcount%25==0?rcount/25:rcount/25+1%>&nbsp;page(s)&nbsp;&nbsp;Now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
			  <td><img src="../button/firstpage.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:toPage(0)"></td>
			  <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
			  <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= rcount ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
			  <td><img src="../button/endpage.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:toPage(<%= (rcount - 1) / 25 %>)"></td>
			</tr>
			<tr>
			  <td colspan="5" align="right" >
				<table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
				<tr>
				 <td >Page&nbsp;</td>
				 <td> <input type="text" value="<%= String.valueOf(thepage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
				 <td ><img src="../button/go.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:goPage()"  ></td>
				</tr>
				</table>
			  </td>
		   </tr>
		  </table>
<% } 
	} else {
          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in first!");//Please log in to the system
                    parent.document.URL = 'enter.jsp';
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
        Vector vetor = new Vector();
        sysInfo.add(sysTime + " Exception occurred in managing ringboards!");//系统铃音管理过程出现异常
        sysInfo.add(sysTime + e.toString());
        vetor.add("Error occurred in managing ringboards!");//系统铃音管理过程出现错误
        vetor.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vetor);
%>
</form>
<script language="javascript">
   document.location.href="error.jsp?historyURL=mringcatasearch.jsp";
</script>
<%
    }
%>
</body>
</html>
