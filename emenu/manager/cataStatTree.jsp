<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>

<%!
   

    private Vector getChildNode(Vector vet1, int ringlibid){
        Vector ret = new Vector();
        Hashtable table1 = null;
        if(vet1.size()==0)
          return ret;
        for(int i=0; i<vet1.size();i++){
           table1 = (Hashtable) vet1.get(i);
           if(Integer.parseInt((String)table1.get("parentidnex"))== ringlibid)
              ret.add(table1);
        }
        return ret;
    }

	public String showLibName(String str)
    {	
    	String tmpStr = str;
    	if(tmpStr.length()>18)
    		tmpStr=tmpStr.substring(0,16)+"..";
    	return tmpStr;
	}
%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
         String startday = request.getParameter("start") == null ? "" : (String)request.getParameter("start").trim();
         String endday = request.getParameter("end") == null ? "" : (String)request.getParameter("end").trim();

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("4-11") != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            vet = syspara.getRingLibraryInfo();
%>

<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="style.css">
  <SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<script language="javascript">
    function doClick (srcObj,idForm,ringlibid,pos,leaf) {
      var fm = document.inputForm;
            var vt = '0';
      if(window.parent.hideTitle.tit.bytime.checked)
        {
         vt = '1';
         if (trim(window.parent.hideTitle.tit.startday.value) == '') {
            alert('Please input the start time!');
            window.parent.hideTitle.tit.startday.focus();
            return false;
         }
         if (! checkDate2(window.parent.hideTitle.tit.startday.value)) {
           // alert('起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!');
            alert('Invalid start time entered. \r\n Please enter the start time in the YYYY.MM format');     
            window.parent.hideTitle.tit.startday.focus();
            return false;
         }
         if (! checktrue2(window.parent.hideTitle.tit.startday.value)) {
          //  alert('起始时间不能大于当前时间!');
            alert('Start time cannot be later than current time!');
            window.parent.hideTitle.tit.startday.focus();
            return false;
         }
         if (trim(window.parent.hideTitle.tit.endday.value) == '') {
          //  alert('请输入结束时间!');
            alert('Please input the end time!');
            window.parent.hideTitle.tit.endday.focus();
            return false;
         }
         if (! checkDate2(window.parent.hideTitle.tit.endday.value)) {
            //alert('结束时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!');
            alert('Invalid end time entered. \r\n Please enter the end time in the YYYY.MM format');     
            window.parent.hideTitle.tit.endday.focus();
            return false;
         }
         if (! checktrue2(window.parent.hideTitle.tit.endday.value)) {
           // alert('结束时间不能大于当前时间!');
            alert('End time cannot be later than current time!');
            window.parent.hideTitle.tit.endday.focus();
            return false;
         }
         if (! compareDate2(window.parent.hideTitle.tit.startday.value,window.parent.hideTitle.tit.endday.value)) {
            //alert('起始时间应该在结束时间之前!');
            alert('Start time  should be earlier than end time!');
            window.parent.hideTitle.tit.startday.focus();
            return false;
         }
         window.parent.hideTitle.tit.startday.value = trim(window.parent.hideTitle.tit.startday.value);
         window.parent.hideTitle.tit.endday.value = trim(window.parent.hideTitle.tit.endday.value);
      }
      else{
          window.parent.hideTitle.tit.endday.value = '';
          window.parent.hideTitle.tit.startday.value = '';
      }
      if(idForm!='0'){
          if (idForm.style.display == '') {
             srcObj.src = 'folder/midplus.gif';
             idForm.style.display = 'none';
          }
          else {
             srcObj.src = 'folder/midminus.gif';
             idForm.style.display = '';
          }
       }
//      if(leaf==1)
//        parent.cataStat.document.URL = "cataStat.jsp?ringlibid=" + ringlibid+"&Pos="+pos+"&start="+fm.startday.value +"&end="+fm.endday.value;
//      if(leaf==0)
         parent.cataStat.document.URL = "cataStat.jsp?ringlibid=" + ringlibid+"&Pos="+pos+"&start="+window.parent.hideTitle.tit.startday.value +"&end="+window.parent.hideTitle.tit.endday.value+"&cata="+vt;
      return;
   }
    function doNodeClick(ringlibid,pos,leaf){

      var fm = document.inputForm;
      var vt = '0';
      if(window.parent.hideTitle.tit.bytime.checked)
        {
         vt = '1';
         if (trim(window.parent.hideTitle.tit.startday.value) == '') {
            //alert('请输入起始时间!');
            alert('Please input end time!');
            window.parent.hideTitle.tit.startday.focus();
            return false;
         }
         if (! checkDate2(window.parent.hideTitle.tit.startday.value)) {
            //alert('起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!');
             alert('Invalid start time entered. \r\n Please input start time in the YYYY.MM format');     
             window.parent.hideTitle.tit.startday.focus();
            return false;
         }
         if (! checktrue2(window.parent.hideTitle.tit.startday.value)) {
           // alert('起始时间不能大于当前时间!');
            alert('Start time cannot be later than current time!');
            window.parent.hideTitle.tit.startday.focus();
            return false;
         }
         if (trim(window.parent.hideTitle.tit.endday.value) == '') {
           // alert('请输入结束时间!');
           alert("Please input the end time!");
            window.parent.hideTitle.tit.endday.focus();
            return false;
         }
         if (! checkDate2(window.parent.hideTitle.tit.endday.value)) {
            //alert('结束时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!');
            alert('Invalid end time entered. \r\n Please enter end time in the YYYY.MM format');     
            window.parent.hideTitle.tit.endday.focus();
            return false;
         }
//         if (! checktrue2(fm.endday.value)) {
//            alert('结束时间不能大于当前时间!');
//            fm.endday.focus();
//            return false;
//         }
         if (! compareDate2(window.parent.hideTitle.tit.startday.value,window.parent.hideTitle.tit.endday.value)) {
           // alert('起始时间应该在结束时间之前!');
            alert('Start time should be prior than end time!');
            window.parent.hideTitle.tit.startday.focus();
            return false;
         }
         window.parent.hideTitle.tit.startday.value = trim(window.parent.hideTitle.tit.startday.value);
         window.parent.hideTitle.tit.endday.value = trim(window.parent.hideTitle.tit.endday.value);
      }
      else{
          window.parent.hideTitle.tit.endday.value = '';
          window.parent.hideTitle.tit.startday.value = '';
      }
      if(leaf==1)
         parent.cataStat.document.URL = "cataStat.jsp?ringlibid=" + ringlibid+"&Pos="+pos+"&start="+window.parent.hideTitle.tit.startday.value +"&end="+window.parent.hideTitle.tit.endday.value+"&cata="+vt;
//      if(leaf==0)
//         parent.cataStat.document.URL = "cataStat.jsp?ringlibid=" + ringlibid+"&Pos="+pos+"&start="+fm.startday.value +"&end="+fm.endday.value+"&cata="+vt;
      return;
    }
 </script>

<body  class="body-style1">
<form name="inputForm" action="">
<input type="hidden" name="start" value="">
<input type="hidden" name="end" value="">
<table width="162" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
  <tr>
    <td><img src="image/001.gif" width="162" height="15"></td>
  </tr>
  <tr>
    <td background="image/003.gif"><table width="158" border="0" align="center" cellpadding="2" cellspacing="2" class="table-style2">
      <tr>
        <td>&nbsp;</td>
      </tr>
 <%
   Vector vectNode = getChildNode(vet,0);
   Vector  vetChild = null;
   Hashtable  hash1= null;
   //System.out.println("vetnode="+vectNode);
   for (int i=0; i< vectNode.size(); i++ ){
      hash  = (Hashtable)vectNode.get(i);
      String  ringlibid = (String)hash.get("ringlibid");
      String  nodeName = (String) hash.get("ringliblabel");
      int     isleaf  = 1;//0;
      if(vetChild!=null && vetChild.size()>0)
         vetChild.clear();
      vetChild = getChildNode(vet,Integer.parseInt(ringlibid));
      String menuid = "ringfold_"+Integer.toString(i+1);
      String imageid = "image"+Integer.toString(i+1);
     // System.out.println("vetChild="+vetChild);
      if(vetChild.size()==0){
          menuid="0";
          isleaf = 1;
      }
 %>
  <tr>
    <td width="100%" onclick="javascript:doClick(<%= imageid %>,<%= menuid %>,<%= ringlibid %>,'<%= nodeName %>',<%= isleaf %>)" onmouseover="this.style.cursor='hand'"><img src="folder/midplus.gif" id="<%= imageid %>" ><%= showLibName(nodeName)  %></td>
  </tr>
 <%
      if(vetChild.size()>0){
  %>
  <tr>
    <td id="<%= menuid  %>" style="DISPLAY:none">
      <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2">
 <%
          for(int j=0;j<vetChild.size(); j++ ){
             hash1 = (Hashtable)vetChild.get(j);
             String   childRinglibid =  (String)hash1.get("ringlibid");
             String  childName = (String) hash1.get("ringliblabel");
             int     childLeaf = Integer.parseInt((String) hash1.get("isleaf"));
 %>
         <tr><td width="100%" onclick="javascript:doNodeClick(<%= childRinglibid %>,'<%= childName %>',<%= childLeaf %>)" onmouseover="this.style.cursor='hand'"><img src="folder/line.gif"><img src="folder/midblk.gif"><%= showLibName(childName) %></a></td></tr>
<%         }
          out.print("</table>");
       }
      out.print("</td>");
      out.print("</tr>");
   }
%>
  </table>
  </td>
  </tr>
  <tr>
    <td><img src="image/002.gif" width="162" height="15"></td>
  </tr>
</table>
</form>
<%

        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in the statistics on ringtones in category libraries!");//分类库铃音统计出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in the statistics on ringtones in category libraries!");//分类库铃音统计出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="cataStat.html">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
