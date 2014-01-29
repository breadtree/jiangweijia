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
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
     //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    //add end
   Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-2") != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            vet = sysring.getRingLibraryInfo();
%>


<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="style.css">

<style type="text/css">
<!--
body {
	margin-left: 2px;
}
-->
</style>
</head>
<script language="javascript">
    function doClick (srcObj,idForm,ringlibid,leaf) {
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
      if(leaf==1)
         parent.ringUpload.document.URL = "ringUpload.jsp?ringlibid=" + ringlibid;

      return;
   }

    function doChildClick (srcObj,idForm,ringlibid,leaf) {
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
      if(leaf==1)
         parent.ringUpload.document.URL = "ringUpload.jsp?ringlibid=" + ringlibid;

      return;
   }

    function doNodeClick(ringlibid,leaf){
       if(leaf==1)
          parent.ringUpload.document.URL = "ringUpload.jsp?ringlibid=" + ringlibid;
      return;
    }

</script>

<body class="body-style1">
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
   <tr>
    <td width="100%" onmouseover="this.style.cursor='hand'"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> library</td>
  </tr>
  <!--modify by gequanmin 2005-07-05 -->
  <%if("1".equals(usedefaultringlib)){%>
  <tr>
    <td width="100%" onclick="javascript:doClick(xxx,'0',503,1)" onmouseover="this.style.cursor='hand'"><img src="folder/midplus.gif"  id="xxx">Default <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> library</td>
  </tr>
 <%}
   Vector vectNode = getChildNode(vet,0);
   Vector  vetChild = null;
   Hashtable  hash1= null;
   //System.out.println("vetnode="+vectNode);
   for (int i=0; i< vectNode.size(); i++ ){
      hash  = (Hashtable)vectNode.get(i);
      String  ringlibid = (String)hash.get("ringlibid");
      String  nodeName = (String) hash.get("ringliblabel");
      int     isleaf  = 0;
      if(vetChild!=null && vetChild.size()>0)
         vetChild.clear();
      vetChild = getChildNode(vet,Integer.parseInt(ringlibid));
      String menuid = "ringfold_"+Integer.toString(i+1);
      String imageid = "image"+Integer.toString(i+1);
      //System.out.println("vetChild="+vetChild);
      if(vetChild.size()==0){
          isleaf = 1;
          menuid="0";
      }
 %>
  <tr>
    <td width="100%" onclick="javascript:doClick(<%= imageid %>,<%= menuid %>,<%= ringlibid %>,<%= isleaf %>)" onmouseover="this.style.cursor='hand'"><img src="folder/midplus.gif" id="<%= imageid %>" ><%= showLibName(nodeName)  %></td>
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

             Vector  vetGrandChild = null;
             Hashtable  hash2= null;
             if(vetGrandChild!=null && vetGrandChild.size()>0)
             vetGrandChild.clear();
             vetGrandChild = getChildNode(vet,Integer.parseInt(childRinglibid));
             String childmenuid = "ringfold_"+Integer.toString(i+1)+"_"+Integer.toString(j+1);
             String childimageid = "image"+Integer.toString(i+1)+"_"+Integer.toString(j+1);
            //System.out.println("vetChild="+vetChild);
            if(vetGrandChild.size()==0)
            {
            childmenuid="00";
            }
 if(vetGrandChild.size()==0){ %>
          <tr>
            <td width="100%" onClick="javascript:doNodeClick('<%= childRinglibid %>','<%=childLeaf%>')" onmouseover="this.style.cursor='hand'">&nbsp;&nbsp;&nbsp;&nbsp;<img src="folder/midblk.gif">&nbsp;<%=showLibName(childName)%>
           </td>
          </tr>

 <%} else {%>
  <tr>
    <td width="100%" onClick="javascript:doChildClick(<%= childimageid %>,<%= childmenuid %>, '<%= childRinglibid %>','<%=childLeaf%>')" onMouseOver="this.style.cursor='hand'">&nbsp;&nbsp;&nbsp;&nbsp;<img src="folder/midplus.gif" id="<%= childimageid %>" >
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
        int     grandChildLeaf = Integer.parseInt((String) hash2.get("isleaf"));
        %>
        <tr>
            <td width="100%" onClick="javascript:doNodeClick('<%= grandChildRinglibid %>','<%=grandChildLeaf%>')" onmouseover="this.style.cursor='hand'" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="folder/midblk.gif">&nbsp;<%=showLibName(grandChildName)%>
           </td>
        </tr>
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
        sysInfo.add(sysTime + operName + "Exception occurred in managing ringtone categories!");//铃音分类管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing ringtone categories!");//铃音分类管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="ringUpload.html">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
