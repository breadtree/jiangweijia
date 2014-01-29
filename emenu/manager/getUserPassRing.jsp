<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Personal ringtone audit</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" onload="initform(document.forms[0])">
<%!
public static final int START_NO = 0;
public static final int END_NO = 24;
%>
<%
    String sysTime = "";
    String jName = (String)application.getAttribute("JNAME");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    //3.17.07
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"Ringtone":(String)application.getAttribute("RINGDISPLAY");
    String searchkey = request.getParameter("searchkey") == null ? "" : request.getParameter("searchkey");
    String searchvalue = request.getParameter("searchvalue") == null ? "" : request.getParameter("searchvalue");
    String validtype = request.getParameter("validtype") == null ? "" : request.getParameter("validtype");
    String oper_mode = request.getParameter("oper_mode") == null ? "search" : request.getParameter("oper_mode");
    int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
    int rowcount = request.getParameter("rowcount") == null ? 0 : Integer.parseInt((String)request.getParameter("rowcount"));;
    String startNo = request.getParameter("startNo");
    String endNo = request.getParameter("endNo");

    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        int operflag = 0; //0:无权限 1:内容审核,2:资费审核 3:内容审核和资费审核
        if (purviewList.get("6-3") != null)
           operflag = 1;
        if (purviewList.get("6-4") != null)
           operflag = operflag + 2;
        if(operflag ==0 || operID==null){
%>
<script language="javascript">
    alert('<%= operID == null ? "Please log in to the system first!" : "You have no access to this function!" %>');
	document.URL = 'enter.jsp';
</script>
<%
        }
        else if (operID != null) {
            String ringindex = request.getParameter("ringindex") == null ? "" : ((String)request.getParameter("ringindex")).trim();
            String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String ringname = request.getParameter("ringname") == null ? "" : transferString((String)request.getParameter("ringname")).trim();
            String usernumber = request.getParameter("caranumber") == null ? "" : (String)request.getParameter("caranumber");

           String  optSCP = "";
           manSysPara  syspara = new manSysPara();
           ArrayList scplist = syspara.getScpList();
           for (int i = 0; i < scplist.size(); i++) {
              if(i==0 && scp.equals(""))
                 scp = (String)scplist.get(i);
              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
           }

            Vector vetSysLib = sysring.getRingLib();
            Hashtable ht  = new  Hashtable();

            if(oper_mode.equals("del")){
              String ringid = request.getParameter("del_ringid") == null ? "" : (String)request.getParameter("del_ringid");
              String ringlabel = request.getParameter("del_ringlabel") == null ? "" : transferString((String)request.getParameter("del_ringlabel")).trim();
              String number = request.getParameter("del_usernumber") == null ? "" : (String)request.getParameter("del_usernumber");
              Hashtable hash2 = new Hashtable();
              Hashtable result = new Hashtable();
              hash2.put("opcode", "01010203");
              hash2.put("craccount", number);
              hash2.put("crid", ringid);
              hash2.put("ret1", "");
              hash2.put("opmode", "1");
              hash2.put("ipaddr", request.getRemoteAddr());
              hash2.put("ringidtype", "1");
              result = SocketPortocol.send(pool, hash2);
              sysInfo.add(sysTime + operName + " delete " + number + "'s " +ringdisplay + "successfully!");

              // 准备写操作员日志
              zxyw50.Purview purview = new zxyw50.Purview();
              HashMap map = new HashMap();
              map.put("OPERID",operID);
              map.put("OPERNAME",operName);
              map.put("OPERTYPE","203");
              map.put("RESULT","1");
              map.put("PARA1",ringid);
              map.put("PARA2",ringlabel);
              map.put("PARA3","ip:"+request.getRemoteAddr());
              purview.writeLog(map);
              oper_mode = "search";
            }

            Hashtable map_in = new Hashtable();
            //查询审核通过铃音
            map_in.put("operflag","2");
            map_in.put("ringtype","1");
            map_in.put("scp",scp);
            //查询参数
            map_in.put("searchkey",searchkey);
            map_in.put("searchvalue",searchvalue);
            if(searchkey.equals("uploadtime")){
              map_in.put("validtype",validtype);
            }else{
              map_in.put("validtype","");
            }
            if(startNo!=null&&endNo!=null){
              map_in.put("startno",startNo);
              map_in.put("endno",endNo);
            }

            if(!scp.equals("") && oper_mode.equals("search"))
               ht = sysring.getDIYCheckRing2(map_in);

            if(rowcount == 0)
            rowcount = Integer.parseInt((String)ht.get("rowcount"));
            Vector vet = (Vector)ht.get("data");
            int pages = rowcount/25;
            if(rowcount%25>0)
              pages = pages + 1;
            Hashtable hash = new Hashtable();

%>
<script language="javascript">
   var v_ringindex = new Array(<%= vet.size() + "" %>);
   var v_number = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_ringindex[<%= i + "" %>] = '<%= (String)hash.get("ringindex") %>';
   v_number[<%= i + "" %>] = '<%= (String)hash.get("usernumber") %>';
<%
            }
%>
   function initform(pform){
       var value = parseInt(pform.operflag.value);
//       disableButton(value);
       var temp = "<%= scp %>";
       for(var i=0; i<pform.scplist.length; i++){
        if(pform.scplist.options[i].value == temp){
           pform.scplist.selectedIndex = i;
           break;
        }
     }
   }

   function delRing () {
     var ringid = document.inputForm.del_ringid.value;
     if (ringid == ''){
       alert('Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> you want to delete!');//请选择要删除的铃音!
       return;
     }
     if (! confirm('Are you sure to delete this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>?'))//您是否确认删除这条铃音？
         return;
     document.inputForm.oper_mode.value = 'del';
     document.inputForm.submit();
   }

   function tryListen (ringindex,ringname,usernumber,mediatype) {
      fm = document.inputForm;
      var tryURL = 'listenCheck.jsp?ringindex=' + ringindex + '&ringname='+ringname+ '&usernumber='+usernumber+'&mediatype='+ mediatype;
      if(trim(mediatype)=='1'){
      preListen =  window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='4'){
        tryURL = 'viewCheck.jsp?ringindex=' + ringindex + '&ringname='+ringname+ '&usernumber='+usernumber+'&mediatype='+ mediatype;
            preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));;
   		}
   }

   function ringInfo (ringid) {
      infoWin = window.open('checkRingInfo.jsp?ringid=' + ringid,'infoWin','width=400, height=340');
   }

   function onSCPChange(){
       document.inputForm.op.value = "";
       document.inputForm.submit();
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

   //3.17.07
   function modeChange(){
     if(document.forms[0].searchkey.value=='uploadtime'){
       document.all('id_dateshow').style.display= 'block';
     }
     else{
       document.all('id_dateshow').style.display= 'none';
     }
   }
   function searchRing () {
     fm = document.inputForm;
     /**
     if (sortby.length > 0)
     fm.sortby.value = sortby;
     **/
     if (trim(fm.searchvalue.value) != '') {
       if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
        // alert('请按照YYYY.MM.DD的格式输入正确的入库时间!并且该时间不能大于当前时间!');
         alert('Please input the upload time with the format of YYYY.MM.DD,and the time cannot be later than current time!');
         fm.searchvalue.focus();
         return;
       }
       if (trim(fm.searchkey.value)=='uploadtime'){
         var value_search = trim(fm.searchvalue.value);
         if (fm.validtype.value == '0'){
           fm.searchvalue.value = value_search + ' 00:00:00';
         }else{
           fm.searchvalue.value = value_search + ' 23:59:59';
         }
       }
     }
     var check_value = fm.searchvalue.value;
     for (var i = 0;i<check_value.length;i++){
       var ch = check_value.charAt(i);
       if("'".indexOf(ch) == 0){
        // alert("输入的信息不能包含'号,请重新输入!");
          alert("The input information cannot include\"'\",please re-enter!");
         fm.searchvalue.value = '';
         fm.searchvalue.focus();
         return;
         break;
       }
     }
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
       alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!");
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
   function toPage (page) {
     var fm = document.inputForm;
     var rowcount = fm.rowcount.value;
     if(page == 0){
       fm.startNo.value = <%=START_NO%>;
       fm.endNo.value = <%=END_NO%>;
     }else if(page == (rowcount-1)/25) {
       fm.startNo.value = page*25;
       fm.endNo.value = rowcount-1;
     }else{
       fm.startNo.value = page*25;
       fm.endNo.value = (page+1)*25-1;
     }

     fm.page.value = page;
     fm.submit();
   }
   function oncheckbox(ringindex,ringlabel,number){
     document.inputForm.del_ringid.value= ringindex;
     document.inputForm.del_ringlabel.value= ringlabel;
     document.inputForm.del_usernumber.value= number;
   }
</script>
<script language="JavaScript">
if(parent.frames.length>0)
  parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="getUserPassRing.jsp">
<input type="hidden" name="ringindex" value="">
<input type="hidden" name="operflag" value="<%= operflag %>">
<input type="hidden" name="ringname" value="">
<input type="hidden" name="reasontext" value="">
<input type="hidden" name="caranumber" value="">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="op" value="">
<input type="hidden" name="del_ringid" value="">
<input type="hidden" name="del_ringlabel" value="">
<input type="hidden" name="del_usernumber" value="">
<input type="hidden" name="oper_mode" value="<%=oper_mode%>">
<input type="hidden" name="startNo" value="">
<input type="hidden" name="endNo" value="">
<input type="hidden" name="rowcount" value="<%=rowcount%>">

<script language="JavaScript">
  if(parent.frames.length>0)
    parent.document.all.main.style.height="880";
</script>
<table border="0" width="377" align="center" cellspacing="0" cellpadding="0" class="table-style2">
  <tr valign="center">
    <td>
      <table width="490" border="0" align="center" cellpadding="1" cellspacing="1" class="table-style2">
        <tr>
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">The auditing of personal <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> query passes</td>
        </tr>
        <tr>
          <td height="15" colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr>
          <td height="35" colspan="2" >Please select SCP&nbsp; <select name="scplist" size="1" onchange="javascript:onSCPChange()" class="input-style1" style="width:120px">
              <% out.print(optSCP); %>
             </select>
          </td>
        </tr>
        <tr>
          <td width="100%" >
          <table width="100%" border="0" cellpadding="1" cellspacing="1" class="table-style2">
          <tr>
            <td width="100%" >
              <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="100%">
                <tr>
                  <td>Select type&nbsp;
                    <select size="1" name="searchkey" class="select-style5"  onchange="modeChange();" style="width:150px">
                      <option value="ringlabel"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</option>
                      <option value="usernumber">Subscriber number</option>
                      <option value="uploadtime">Upload time</option>
                    </select>
                  </td>
                  <td>Keyword
                    <input type="text" size="10" name="searchvalue" value="<%= transferString(searchvalue) %>" maxlength="30" class="input-style7" >
                  </td>
                  <td id="id_dateshow" style="display:none" width="20%">
                    <select name="validtype" size="1">
                    <%if(validtype.equals("0")){%>
                    <option value=0  selected="selected"> Date before</option>
                    <option value=2> Date after</option>
                    <%}else if(validtype.equals("2")){%>
                    <option value=0> Date before</option>
                    <option value=2 selected="selected"> Date after</option>
                    <%}else{%>
                    <option value=0> Date before</option>
                    <option value=2> Date after</option>
                    <%}%>
                    </select>
                  </td>
                </tr>
              </table>
            </td>
          <td width="51"><img src="button/search.gif" alt="Search <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> for audit" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing()"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td >
      <table width="100%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style4">
        <tr class="tr-ringlist">
          <td height="30">
            <div align="center"><font color="#FFFFFF">DIY <%=ringdisplay%> name</font></div>
          </td>
          <td height="30" width="70">
            <div align="center"><font color="#FFFFFF">Mobile phone number</font></div>
          </td>
          <td height="30" >
            <div align="center"><font color="#FFFFFF">Upload source</font></div>
          </td>
          <td height="30" >
            <div align="center"><font color="#FFFFFF">Audit time</font></div>
          </td>
          <td height="30" width="20">
            <div align="center"><font color="#FFFFFF">Preview</font></div>
          </td>
          <td style="display:none" height="30" width="40">
            <div align="center"><font color="#FFFFFF">Delete</font></div>
          </td>
        </tr>
<%
        for (int i = 0; i < 25&& i < vet.size(); i++) {
          hash = (Hashtable)vet.get(i);
          String  bgcl = i % 2 == 0 ? "#FFFFFF" : "E6ECFF" ;
          out.println("<tr bgcolor="+bgcl + ">");
          out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("ringlabel")+"</font></td>");
          out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("usernumber")+"</font></td>");
          out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("spname")+"</font></td>");
          out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("uploadtime")+"</font></td>");
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
          <td height="20" align="center">
            <div align="center"> <font color="#CC9900"><font class="font-ring"><img src="<%=strPhoto%>" alt="preview this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>" onMouseOver="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("ringindex") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("usernumber") %>','<%= (String)hash.get("mediatype") %>')"></font></font></div>
          </td>
<%
        //  out.println("<td align=center> <input type='radio' name='delRingIndex'  onclick='oncheckbox(\"" + (String)hash.get("ringid") + "\",\""+(String)hash.get("ringlabel")+"\",\""+(String)hash.get("usernumber")+"\")' ></font></td>");
%>
          </tr>
<%
        }
        if (vet.size() == 0 && !oper_mode.equals("")){
%>
        <tr bgcolor="E6ECFF">
          <td class="table-style2" align="center" colspan="10">There are NO records meeting conditions!</td>
        </tr>
<%
        }
        if (vet.size() > 0) {
%>
      </table>
    </td>
  </tr>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;Total:<%= rowcount %>,&nbsp;&nbsp;<%= rowcount%25==0?rowcount/25:rowcount/25+1%>&nbsp;page(s),&nbsp;Now on page<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= rowcount ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (rowcount - 1) / 25 %>)"></td>
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
 <tr style="display:none" colspan="10">
          <td align="center" colspan=2 height=40>
            <table border="0" width="100%" class="table-style2" align="center">
              <tr >
                <td align="center" ><input type='button'  name="checkpass1" value="Delete" onclick="javascript:delRing()"></td>
              </tr>
            </table>
          </td>
        </tr>
<%
        }
%>
      </table>
    </td>
  </tr>
  <tr>
    <td align="center" height=40>
      <table border="0" width="100%" class="table-style2" align="center">

      </table>
    </td>
  </tr>
 </table>
</form>
<script language="javascript">
var v_value = document.inputForm.searchvalue.value;
if ('<%= searchkey %>' != '-1'){
  document.inputForm.searchkey.value = '<%= searchkey == "" ? "ringlabel" : searchkey%>';
  if ('<%= searchkey%>' == 'uploadtime'){
    modeChange();
    if (v_value != ""){
      document.inputForm.searchvalue.value = v_value.substring(0,10);
    }
  }
}
</script>
<%
        }
        else {
              if(operID== null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system please!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no access to this function!");
              </script>
              <%

                   }

        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occourred in query audit of person ringtone audit!");//查询审核通过个人铃音过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + "Exception occourred in query audit of person ringtone audit!");//查询审核通过个人铃音过程出现异常!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="getUserPassRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
