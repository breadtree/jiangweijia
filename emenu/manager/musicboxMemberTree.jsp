<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.manSysRing" %>

<%!
    public String transferString(String str) throws Exception {
      return str;
    }

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

    String spindex = request.getParameter("spindex")==null ? "":(String)request.getParameter("spindex");
    String ringgroup=request.getParameter("ringgroup")==null ? "":(String)request.getParameter("ringgroup");
    String grouplabel= request.getParameter("grouplabel")==null ? "":transferString((String)request.getParameter("grouplabel"));
    //区分组类型:1:音乐盒 2:大礼包
    String grouptype = request.getParameter("grouptype")==null ? "1":request.getParameter("grouptype");

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
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<script language="javascript">
    function doClick (srcObj,idForm,ringlibid,pos,leaf) {
      //alert('id:'+srcObj.value+' idform:'+idForm+'  ringlibid:'+ringlibid+ ' pos:'+pos+ ' leaf:'+leaf);
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
      {
        parent.musicboxMemberEdit.document.URL = "musicboxMemberEdit.jsp?grouptype=<%=grouptype%>&ringlibid=" + ringlibid+"&pos="+pos+
        "&spindex=<%=spindex%>" + "&ringgroup=<%=ringgroup%>" + "&grouplabel=<%=grouplabel%>";
      }
      return;
   }

   function doChildClick (srcObj,idForm,ringlibid,pos,leaf) {
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
      {
         parent.musicboxMemberEdit.document.URL = "musicboxMemberEdit.jsp?grouptype=<%=grouptype%>&ringlibid=" + ringlibid+"&pos="+pos+
        "&spindex=<%=spindex%>" + "&ringgroup=<%=ringgroup%>" + "&grouplabel=<%=grouplabel%>";

      }

      return;
   }


    function doNodeClick(ringlibid,pos,leaf){
//      alert('ringlibid:'+ringlibid + ' pos:'+pos+' leaf:'+leaf);
      if(leaf==1)
         parent.musicboxMemberEdit.document.URL =  "musicboxMemberEdit.jsp?grouptype=<%=grouptype%>&ringlibid=" + ringlibid+"&pos="+pos+
        "&spindex=<%=spindex%>" + "&ringgroup=<%=ringgroup%>" + "&grouplabel=<%=grouplabel%>";
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
    	<td width="100%"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category</td>
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
    <td width="100%" onclick="javascript:doClick(<%= imageid %>,<%= menuid %>,<%= ringlibid %>,'<%= nodeName %>',<%= isleaf %>)" onmouseover="this.style.cursor='hand'"><img src="../manager/folder/midplus.gif" width="16" height="16" id="<%= imageid %>" ><%= showLibName(nodeName)  %></td>
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
            <td width="100%" onClick="javascript:doNodeClick('<%= childRinglibid %>','<%= childName %>','<%=childLeaf%>')" onmouseover="this.style.cursor='hand'">&nbsp;&nbsp;&nbsp;&nbsp;<img src="folder/midblk.gif">&nbsp;<%=showLibName(childName)%>
           </td>
          </tr>

 <%} else {%>
  <tr>
    <td width="100%" onClick="javascript:doChildClick(<%= childimageid %>,<%= childmenuid %>, '<%= childRinglibid %>','<%= childName %>','<%=childLeaf%>')" onMouseOver="this.style.cursor='hand'">&nbsp;&nbsp;&nbsp;&nbsp;<img src="folder/midplus.gif" id="<%= childimageid %>" >
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
            <td width="100%" onClick="javascript:doNodeClick('<%= grandChildRinglibid %>','<%= grandChildName %>','<%=grandChildLeaf%>')" onmouseover="this.style.cursor='hand'" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="folder/midblk.gif">&nbsp;<%=showLibName(grandChildName)%>
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
        sysInfo.add(sysTime + operName + "Exception occourred in the management of ringtone category!");//铃音分类管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        //vet.add("铃音分类管理过程出现错误!");
        vet.add("Error occourred in the management of ringtone category!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<table border="1" width="100%" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5" height=400>
  <tr>
    <td>Error occourred in the management of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category:<%= e.toString() %></td>
  </tr>
</table>
<%
    }
%>
</body>
</html>
