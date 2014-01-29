<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
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
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";

         if (operID != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            vet = sysring.getRingLibraryInfo();
%>


<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<script language="javascript">
    function doClick (srcObj,idForm,ringlibid,pos,leaf) {
      //alert("idform="+idForm);
      var fm = document.inputForm;
      if(idForm!='0'){
          if (idForm.style.display == '') {
             srcObj.src = '../manager/folder/midplus.gif';
             idForm.style.display = 'none';
          }
          else {
             srcObj.src = '../manager/folder/midminus.gif';
             idForm.style.display = '';
          }
       }
      if(leaf==1)
        parent.ringEdit.document.URL = "ringEdit.jsp?ringlibid=" + ringlibid+"&Pos="+pos;
      return;
   }
    function doNodeClick(ringlibid,pos,leaf){
      if(leaf==1)
         parent.ringEdit.document.URL = "ringEdit.jsp?ringlibid=" + ringlibid+"&Pos="+pos;
      return;
    }

</script>

<body background="bgww.gif" class="body-style1">
<form name="inputForm" action="">
<table width="162" border="0" cellspacing="0" cellpadding="0" class="table-style2" style="color: #0000FF">
  <tr>
    <td><img src="../manager/image/001.gif" width="162" height="8"></td>
  </tr>
  <tr>
    <td background="../manager/image/003.gif">
	<table width="158" border="0" align="center" cellpadding="2" cellspacing="2" class="table-style2">
      <tr>
        <td>&nbsp;</td>
      </tr>
	  <tr>
    	<td width="100%" >Ringtone  library</td>
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
      int     isleaf  = Integer.parseInt((String) hash.get("isleaf"));
      if(vetChild!=null && vetChild.size()>0)
         vetChild.clear();
      vetChild = getChildNode(vet,Integer.parseInt(ringlibid));
      String menuid = "ringfold_"+Integer.toString(i+1);
      String imageid = "image"+Integer.toString(i+1);
      if(vetChild.size()==0)
          menuid="0";
 %>
  <tr>
    <td width="100%" onclick="javascript:doClick(<%= imageid %>,<%= menuid %>,<%= ringlibid %>,'<%= nodeName %>',<%= isleaf %>)" onmouseover="this.style.cursor='hand'"><img src="../manager/folder/midplus.gif" width="16" height="16" id="<%= imageid %>" ><%= nodeName  %></td>
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
         <tr><td width="100%" onclick="javascript:doNodeClick(<%= childRinglibid %>,'<%= childName %>',<%= childLeaf %>)" onmouseover="this.style.cursor='hand'"><img src="../manager/folder/line.gif" width="16" height="16"><img src="../manager/folder/midblk.gif" width="16" height="16"><%= childName %></a></td></tr>
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
    <td><img src="../manager/image/002.gif" width="162" height="15"></td>
  </tr>
</table>
</table>
</form>
<%

        }
        else {

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
<table border="1" width="100%" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5" height=400>
  <tr>
    <td>Error occurred in managing ringtone categories:<%= e.toString() %></td>
  </tr>
</table>
<%
    }
%>
</body>
</html>
