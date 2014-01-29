<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="zxyw50.Purview" scope="page" />
<%

    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String spIndex = (String)session.getAttribute("SPINDEX");
    String spCode = (String)session.getAttribute("SPCODE");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String serviceKey = (String)session.getAttribute("SERVICEKEY");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String strMsg = "";
    try {
       String  errmsg = "";
       boolean flag =true;
       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
       }
       else if (purviewList.get("5-4") == null) {
         errmsg = "You have no access to this function!";//You have no access to this function
         flag = false;
       }
       if(flag){

        int cmdint=-1;
        String  optOperGroup = "";
        String  optServiceList = "";
        //serviceKey = "all";
        String selectedServiceKey = (String)request.getParameter("serviceKey");
        if(request.getParameter("cmd")!=null){
          cmdint = Integer.parseInt(request.getParameter("cmd"));
        }
        String  Opergrpid = "";
        if(request.getParameter("opergrpid")!=null) Opergrpid=request.getParameter("opergrpid");
        String operate = request.getParameter("operate") == null ? "" : (String)request.getParameter("operate");        // 动作代号
        String grpScript = request.getParameter("grpScript") == null ? "" : (String)request.getParameter("grpScript");  // 要增加的操作员描述
        HashMap map = new HashMap();
        Vector vFgrp=new Vector();
        Vector lststr=new Vector();
        if(cmdint==2){
          if(db.grp_rightsmod(serviceKey,operID,operName,request)){
            strMsg="<font color='#0000FF'>";
          }else{
            strMsg="<font color='#FF0000'>";
          }
          strMsg=strMsg+ db.getStrmsg(db.geterrorCode()) + "</font>";
        }
  %>

<html>
<head>
<title>Operator group rights assignment</title>
<link rel="stylesheet" href="../style.css" type="text/css"></link>
</head>
<body topmargin="0" leftmargin="0" onload="initform(this.document.forms[0])">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inForm" method="POST" action="operGrpRight.jsp" onSubmit="return submitchk()">
   <input type="hidden" value="" name="cmd">
   <input type="hidden" value="" name="rgstr">
   <input type="hidden" name="servicekey" value="<%= serviceKey  %>">
   <table border=0 height="480" width="95%" align=center>
   <tr>
   <td>
   <table border="0"  width="100%" align=center  class="table-style1">
   <tr class="tr-ring">
      <td colspan="2" height="26" align="center" class="text-title" valign="middle" background="../image/n-9.gif" >Operator group rights configuration
   </td>
   <tr >
   <td class="table-style1"> Select operator group&nbsp;
    <select NAME="opergrpid" size="1" tabindex="4" onChange="getgrpinf()" style="width:200px">
    <%
      if(!serviceKey.equals("")){
        lststr=db.oper_grpscriptqry(serviceKey,operID);
        int k=db.oper_grpscriptqryrows();
        String strtmp = "";
        for(int i=0;i<lststr.size();i=i+k){
          if(i==0)
             strtmp = lststr.get(i).toString();
          out.print("<OPTION value='"+lststr.get(i)+"'> "+lststr.get(i+1)+" </OPTION>");
        }
       if(Opergrpid.equals("") && !strtmp.equals("")){
         Opergrpid = strtmp;
       }
       if(lststr.size()>0)
          lststr.clear();
      }
    %>
    </select>
   </td>
   <td>
     <input type="button" value="Assign" name="Add" onClick="actadd()" >
   </td>
   </tr>
   <tr>
   <td align="center" width="100%" colspan="2">
              <table align="center" class="table-style1" border="1" cellpadding="1" cellspacing="0" width="100%"  bordercolorlight="#000000" bordercolordark="#E0E0E0" height="398">
                <tr class="tr-ring">
                  <td width="50%" height="30" align="center"><font class="font"><strong>Function group list</strong></font>
                  </td>
                  <td width="50%" align="center"><font class="font"><strong>Rights configuration</strong></font></td>
      			</tr>

      			<tr width="50%">
      				<td align="left" valign="top">
      <select NAME="funcgrpid"  size="22" onChange="getfuncgrpinf()" style="width: 250px">
      <%
         if(serviceKey.equals("")){
            out.println("<OPTION value=''> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </OPTION>");
         }else{
          lststr=db.oper_funcgrpqry(serviceKey);
          int k = db.oper_funcgrpqryrows();
          for(int i=0;i<lststr.size();i=i+k){
            if(i==0)
              out.print("<OPTION value='"+lststr.get(i)+"' selected > "+lststr.get(i+1)+" </OPTION>");
           else
             out.print("<OPTION value='"+lststr.get(i)+"'> "+lststr.get(i+1)+" </OPTION>");
            vFgrp.addElement(lststr.get(i).toString());
          }
          lststr.clear();
         }
      %>
      </select></td>

      <td bgcolor="#FFFFFF" valign="top">
      <%
         Vector vFunc=new Vector();
         String sTmp="";
         if(serviceKey.equals("")){
         }else{
          int ii=0;
          int ik=db.oper_functionqryrows();
          String sTmp2="";
          for(int i=0;i<vFgrp.size();i++){
            sTmp=vFgrp.get(i).toString();
           out.println("<div id='Func_"+sTmp+"' STYLE='display:none;'>");
            out.println("<input type='checkbox' name='selectall_" +sTmp+"'  onclick='javascript:onSelectAll()'><font color='blue' >Select All</font><br>");
            lststr=db.oper_functionqry(serviceKey,sTmp);
            for(ii=0;ii<lststr.size();ii=ii+ik){
              String str = lststr.get(ii).toString()+"-"+lststr.get(ii+1).toString();
              if(purviewList.get(str) == null){
                sTmp2 = "disabled";
              }else{
                sTmp2="";
              }
             out.print(" <input type='checkbox' name='Func_"+lststr.get(ii)+"_"+lststr.get(ii+1)+"' value='0'"+sTmp2+">"+lststr.get(ii+2).toString()+"<br>");
              vFunc.addElement(lststr.get(ii).toString()+"_"+lststr.get(ii+1).toString());
            }
            lststr.clear();
            out.println("</div>");
          }
         }
      %>
      </td>

      </tr>
     </table>
  </td>
  </tr>
  </table>
  </td>
  </tr>
  </table>
</form>

<script language="JavaScript1.2">
function onSelectAll(){
      var fm = document.inForm;
      var sTmp=document.inForm.funcgrpid.value;
      if(document.all('selectall_'+sTmp).checked){
        <%
         for(int i=0;i<vFunc.size();i++){
           String fTmp=vFunc.get(i).toString();
           String f1 = fTmp.substring(0,fTmp.indexOf("_"));
           %>
           var tmp=<%=f1%>;
           if(sTmp==tmp)
           {
             var fid ='<%=fTmp%>';
             document.all('Func_'+fid).checked=true;
           }
        <% }%>
      }
      else {
         <%
         for(int i=0;i<vFunc.size();i++){
           String fTmp=vFunc.get(i).toString();
           String f1 = fTmp.substring(0,fTmp.indexOf("_"));
           %>
           var tmp=<%=f1%>;
           if(sTmp==tmp)
           {
             var fid ='<%=fTmp%>';
             document.all('Func_'+fid).checked=false;
           }
        <% }%>

          }

      return;
    }
function getfuncgrpinf(){
  var sTmp=document.inForm.funcgrpid.value;
  document.all('Func_'+sTmp).style.display='';
}

function actadd(){
  if(!(document.inForm.opergrpid.value==""||document.inForm.servicekey.value=="")){
    var sTmp1="";
    document.inForm.rgstr.value=sTmp1.substring(0,sTmp1.length-1);
    document.inForm.cmd.value="2";
    document.inForm.submit();
  }
}

function initform(pform){

}

function submitchk(){
  if(document.inForm.cmd.value==""){
    return false;
  }else{
    return true;
  }
}


function actadd(){
  if(!(document.inForm.opergrpid.value==""||document.inForm.servicekey.value=="")){
    var sTmp1="";
<%
  for(int i=0;i<vFunc.size();i++){
    sTmp=vFunc.get(i).toString();
    out.println(" if(document.all('Func_"+sTmp+"').checked==true&&document.all('Func_"+sTmp+"').disabled==false){");
    out.println("  sTmp1=sTmp1+'"+sTmp+"|';");
    out.println(" }");
  }
%>
    document.inForm.rgstr.value=sTmp1.substring(0,sTmp1.length-1);
    document.inForm.cmd.value="2";
    document.inForm.submit();
  }
}

function getfuncgrpinf(){
<%
  for(int i=0;i<vFgrp.size();i++){
    sTmp=vFgrp.get(i).toString();
    out.println("document.all('Func_"+sTmp+"').style.display='none';");
  }
%>
  var sTmp=document.inForm.funcgrpid.value;
  document.all('Func_'+sTmp).style.display='';
}


function getgrpinf(){
  if(document.inForm.opergrpid.value==""){
  }else{
    document.inForm.cmd.value="0";
    document.inForm.submit();
  }
}

document.inForm.Add.disabled=true;
<%
  if(vFgrp.size()>0)out.println("document.all('Func_"+vFgrp.get(0)+"').style.display='';");
  if(!serviceKey.equals(""))out.println("document.inForm.servicekey.value='"+serviceKey+"';");
  if(!Opergrpid.equals("")){
    lststr=db.oper_grpdef(Opergrpid,serviceKey);
    int k=db.oper_grpdefrows();
    for(int i=0;i<lststr.size();i=i+k){
      out.println("document.all('Func_"+lststr.get(i)+"_"+lststr.get(i+1)+"').value='1';");
      out.println("document.all('Func_"+lststr.get(i)+"_"+lststr.get(i+1)+"').checked=true;");
    }
    lststr.clear();
    if(db.opergrpinf(serviceKey,Opergrpid)){
      out.println("document.inForm.opergrpid.value="+Opergrpid+";");
      if(db.getCreatorid()==java.lang.Integer.parseInt(operID))out.println("document.inForm.Add.disabled=false;");
    }
  }
 %>

</script>
</BODY>
</HTML>
<%
        }
        else {
            if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.location.href = '../enter.jsp';
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
   catch (Exception e) {
%>
<html>
<body>
<table border="1" width="100%" bordercolorlight="#000000" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
  <tr>
    <td colspan="2">Error:<%= e.toString() %></td>
  </tr>
</table>
</body>
</html>
<%
    }
%>
</body>
</html>
