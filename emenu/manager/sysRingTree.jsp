<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.manSysRing" %>

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
    String sysTime = "";
     //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    //add end
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
          manSysRing manring = new manSysRing();
          sysTime = manring.getSysTime() + "--";
          Vector vet = new Vector();
          Hashtable hash = new Hashtable();
          if (operID != null && purviewList.get("2-4") != null) {
            vet = manring.getRingLibraryInfo();
%>


<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<script language="javascript">
    function doClick (srcObj,idForm,ringlibid) {
      //alert("idform="+idForm);
      var fm = document.inputForm;
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
      parent.sysRingInfo.document.URL = "sysRingInfo.jsp?ringlibid=" + ringlibid;
      return;
   }

   function doChildClick (srcObj,idForm,ringlibid, parentnodename) {
      var fm = document.inputForm;
      if(idForm!='00'){
          if (idForm.style.display == '') {
             srcObj.src = 'folder/midplus.gif';
             idForm.style.display = 'none';
          }
          else {
             srcObj.src = 'folder/midminus.gif';
             idForm.style.display = '';
          }
       }
      parent.sysRingInfo.document.URL = "sysRingInfo.jsp?ringlibid=" + ringlibid+"&Pos=Ringtone library-->"+parentnodename;
      return;
   }

   function rootClick() {
      parent.sysRingInfo.document.URL = "sysRingInfo.jsp?ringlibid=0";
      return;
   }
</script>

<body  class="body-style1">
<form name="inputForm" action="">
<table width="162" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
  <tr>
    <td><img src="image/001.gif" width="162" height="15"></td>
  </tr>
  <tr>
    <td background="image/003.gif"><table width="158" border="0" align="center" cellpadding="2" cellspacing="2" class="table-style2">
      <tr>
        <td>&nbsp;</td>
      </tr>
    <!--modify by gequanmin 2005-07-05 -->
  <%if("1".equals(usedefaultringlib)){%>
   <tr>
    <td width="100%" onclick="javascript:doClick(this,'0',503)" onmouseover="this.style.cursor='hand'"><img src="folder/midplus.gif"  >Default <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> library</td>
  </tr>
 <%}
   Vector vectNode = getChildNode(vet,0);
   Vector  vetChild = null;
   Hashtable  hash1= null;
   for (int i=0; i< vectNode.size(); i++ ){
      hash  = (Hashtable)vectNode.get(i);
      String   ringlibid = (String)hash.get("ringlibid");
      String  nodeName = (String) hash.get("ringliblabel");
      if(vetChild!=null && vetChild.size()>0)
         vetChild.clear();
      vetChild = getChildNode(vet,Integer.parseInt(ringlibid));
      String menuid = "ringfold_"+Integer.toString(i+1);
      String imageid = "image"+Integer.toString(i+1);
      if(vetChild.size()==0) menuid="0";
      String  nodePos = "Ringtone library-->"+nodeName;
 %>
  <tr>
    <td width="100%" onclick="javascript:doClick(<%= imageid %>,<%= menuid %>,<%= ringlibid %>)" onmouseover="this.style.cursor='hand'"><img src="folder/midplus.gif" id="<%= imageid %>" ><%= showLibName(nodeName)  %></td>
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
             String  ref = "sysRingInfo.jsp?ringlibid=" + childRinglibid + "&parentindex="+ringlibid+"&Pos="+"Ringtone library-->"+nodeName;;
             //System.out.println("ref="+ref);
             Vector  vetGrandChild = null;
             Hashtable  hash2= null;
             if(vetGrandChild!=null && vetGrandChild.size()>0)
             vetGrandChild.clear();
             vetGrandChild = getChildNode(vet,Integer.parseInt(childRinglibid));
             String childmenuid = "ringfold_"+Integer.toString(i+1)+"_"+Integer.toString(j+1);
             String childimageid = "image"+Integer.toString(i+1)+"_"+Integer.toString(j+1);
            //System.out.println("vetChild="+vetChild);
            if(vetGrandChild.size()==0) childmenuid="00";

 if(vetGrandChild.size()==0){ %>
         <tr><td width="100%" >&nbsp;&nbsp;&nbsp;&nbsp;<img src="folder/midblk.gif"><a href="<%= ref %>" target="sysRingInfo">&nbsp;<%= showLibName(childName) %></a></td></tr>

 <%} else {%>
  <tr>
    <td width="100%" onClick="javascript:doChildClick(<%= childimageid %>,<%= childmenuid %>, '<%= childRinglibid %>','<%=nodeName%>')" onMouseOver="this.style.cursor='hand'">&nbsp;&nbsp;&nbsp;&nbsp;<img src="folder/midplus.gif" id="<%= childimageid %>" >
    <%=showLibName(childName)%>
    </td>
  </tr>
 <%}%>
  <% if(vetGrandChild.size()>0) {%>

<tr>
  <td id="<%= childmenuid  %>" style="DISPLAY:none">
    <table  width="100%" border="0" cellspacing="0" cellpadding="1" class="table-style2">

      <%
      for(int m=0; m<vetGrandChild.size(); m++ ){
        hash2 = (Hashtable)vetGrandChild.get(m);
        String  grandChildRinglibid =  (String)hash2.get("ringlibid");
        String  grandChildName = (String) hash2.get("ringliblabel");
        String  ref2 = "sysRingInfo.jsp?ringlibid=" + grandChildRinglibid+"&parentindex=" + childRinglibid + "&Pos="+"Ringtone library-->"+nodeName+"-->"+childName;//铃音分类库
        //System.out.println("ref="+ref);
        %>
        <tr><td width="100%" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="folder/midblk.gif"><a href="<%= ref2 %>" target="sysRingInfo">&nbsp;<%= showLibName(grandChildName) %></a></td></tr>
    <% }%>
    </table>
    </td>
   </tr>
   <%}%>

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
        sysInfo.add(sysTime + operName + "Exception occurred in pre-listening the system ringtone!");//系统铃音试听过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in pre-listening the system ringtone!");//系统铃音试听过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="sysRing.html">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
