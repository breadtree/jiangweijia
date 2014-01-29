<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Prefix management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" onload="JavaScript:initform(document.forms[0])">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-16") != null) {
            Hashtable hash = new Hashtable();
            String  optSCP = "";
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
            String leftarea = request.getParameter("leftarea") == null ? "" : transferString((String)request.getParameter("leftarea")).trim();
            String rightarea = request.getParameter("rightarea") == null ? "" : transferString((String)request.getParameter("rightarea")).trim();
            String hlr = request.getParameter("hlr") == null ? "" : transferString((String)request.getParameter("hlr")).trim();
            String serareano = request.getParameter("serareano") == null ? "0" : transferString((String)request.getParameter("serareano")).trim();
            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            HashMap map1 = new HashMap();
            if (op.equals("edit")) {
		if(!leftarea.equals("-1")){
	    	  if(!purview.CheckOperatorFunction(session,3,16,leftarea,"-1","-1","-1")){
            	  	throw new Exception("You have no permission to operate the service area!");
          	  }
	    	}

	    	if(!rightarea.equals("-1")){
	    	  if(!purview.CheckOperatorFunction(session,3,16,rightarea,"-1","-1","-1")){
            	  	throw new Exception("You have no permission to operate the service area!");
          	  }
	    	}

                String[] cardmaps = null;
                if("0".equals(hlr)){
                  cardmaps = request.getParameterValues("leftlist");
                }else{
                  cardmaps = request.getParameterValues("rightlist");
                }
                if(cardmaps == null)
                  cardmaps = new String[0];
                for(int i=0;i<cardmaps.length;i++){
                  hlr = cardmaps[i];
                  map1.put("optype","3");
                  map1.put("scp",scp);
                  map1.put("hlr",hlr);
                  map1.put("newhlr","####");
                  map1.put("mrbmodel","-1");
                  map1.put("nettype","-1");
                  map1.put("activeid","-1");
                  map1.put("ipid","-1");
                  map1.put("opentype","-1");
                  if(serareano.equals("-1"))
                  serareano = "-2";
                  map1.put("serareano",serareano);
                  syspara.setHlr(map1);
                }
                sysInfo.add(sysTime + operName + " Service area code prefix modified successfully!");

                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","305");
                map.put("RESULT","1");
                map.put("PARA1",hlr);
                map.put("PARA2",scp);
                map.put("PARA3",serareano);
                map.put("PARA4","ip:"+request.getRemoteAddr());
                map.put("DESCRIPTION","Edit service area code prefix");
                purview.writeLog(map);
            }
            ArrayList scplist = syspara.getScpList();
            for (int i = 0; i < scplist.size(); i++) {
               if(i==0 && scp.equals(""))
                  scp = (String)scplist.get(i);
               optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
            }

            ArrayList serviceList =  new ArrayList();
            if(!scp.equals(""))
                serviceList = syspara.getServiceArea(scp);
            String    optAreaList = "";
            if(leftarea.equals(""))
                 leftarea  = "-1";
            if(serviceList.size()>0 && (leftarea.equals("") || rightarea.equals(""))){
               map = (HashMap)serviceList.get(0);
               if(rightarea.equals(""))
                 rightarea  = (String)map.get("serareano");
            }
            ArrayList leftlist = new ArrayList();
            ArrayList rightlist = new ArrayList();
            if(!leftarea.equals("") && !scp.equals(""))
                leftlist = syspara.getHlrByArea(scp,leftarea);
            if(!rightarea.equals("") && !scp.equals(""))
                rightlist = syspara.getHlrByArea(scp,rightarea);
            for(int i=0;i<serviceList.size();i++){
               map = (HashMap)serviceList.get(i);
               optAreaList = optAreaList +  "<option value=" + (String)map.get("serareano") + ">" +(String)map.get("serareaname") + "</option>";
            }
%>
<script language="javascript">
   function initform(fm){
      var value = "<%= leftarea %>";
      var len = fm.leftarea.length;
      for(var i=0;i<len;i++){
         if(fm.leftarea.options[i].value==value){
             fm.leftarea.selectedIndex = i;
             break;
         }
      }
      if(len==1){
        fm.leftarea.disabled = true;
        fm.rightarea.disabled = true;
        fm.moveright.disabled = true;
        fm.moveleft.disabled = true;
       }else{
         value = "<%= rightarea %>";
         len = fm.rightarea.length;
         for(var i=0;i<len;i++){
            if(fm.rightarea.options[i].value==value){
                fm.rightarea.selectedIndex = i;
                break;
            }
         }
         if(fm.rightlist.length==0 || fm.leftarea.value == fm.rightarea.value)
           fm.moveleft.disabled = true;
         if(fm.leftlist.length==0 || fm.leftarea.value == fm.rightarea.value)
           fm.moveright.disabled = true;
       }

      var temp = "<%= scp %>";
      for(var i=0; i<fm.scplist.length; i++){
        if(fm.scplist.options[i].value == temp){
           fm.scplist.selectedIndex = i;
           break;
        }
     }

   }
   function onProvinceChange(){
      document.forms[0].op.value = "";
      document.forms[0].submit();
   }

   function moveRight(){
       var fm = document.inputForm;
       if(fm.leftlist.selectedIndex==-1){
         alert("Please select the code prefix to be configured from the left-side list box!");//请在左边列表框中选择您要配置的号段
         return false;
       }
       if(fm.rightarea.value == fm.leftarea.value){
          alert("The service area with the code prefix you want to configure is the same as the current service area,Please re-select a service area! !");//您要配置的号段业务区同当前业务区相同,请重新选择业务区!
          return ;
       }
       var text = fm.rightarea.options[fm.rightarea.selectedIndex].text;
       if(!confirm("Are you sure to configure the service area to the prefix \""+text+"\"?" ))
          return false;
       fm.hlr.value =  "0";//left
       fm.serareano.value =  fm.rightarea.value;
       fm.op.value = "edit";
       fm.submit();
   }
   function moveLeft(){
       var fm = document.inputForm;
       if(fm.rightlist.selectedIndex==-1){
         alert("Please select the code prefix to be configured from the right-side list box!");//请在右边列表框中选择您要配置的号段
         return false;
       }
       if(fm.rightarea.value == fm.leftarea.value){
          alert("The service area with the code prefix you want to configure is the same as the current service area,Please re-select a service area!");//您要配置的号段业务区同当前业务区相同,请重新选择业务区!
          return ;
       }
       var text = fm.leftarea.options[fm.leftarea.selectedIndex].text;
       if(!confirm("Are you sure to configure the service area to the prefix \""+text+"\"?" ))
          return false;
       fm.hlr.value =  "1";//right
       fm.serareano.value =  fm.leftarea.value;
       fm.op.value = "edit";
       fm.submit();
   }
   function onSCPChange(){
       document.inputForm.op.value = "";
       document.inputForm.submit();
   }


</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="areaHlr.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="hlr" value="">
<input type="hidden" name="serareano" value="">
<table width="100%" height="400" border="0" align="center" class="table-style2">
<tr >
<td>
      <table width="90%" border="0" align="center" class="table-style2">
        <tr>
        <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Service area number prefix management</td>
        </tr>
		<tr>
        <td height="40" colspan="3" >
		      &nbsp;Please Select SCP&nbsp; <select name="scplist" size="1" onchange="javascript:onSCPChange()" class="input-style1" style="width:130px">
              <% out.print(optSCP); %>
             </select>
		</td>
        </tr>
        <tr>
        <td width="45%" align="right">
             <table border=0 align="right" class="table-style2">
             <tr>
             <td width="120" align="right"><span title="Please select a service area">Service area</span></td>
             <td width="130" >
             <select name="leftarea" size="1" onchange="javascript:onProvinceChange()" style="width:150px">
              <option value="-1" >No service area</option>
              <% out.print(optAreaList); %>
             </select>
             </td>
             </tr>
             <tr>
             <td colspan=2 align="right">
             <select name="leftlist" multiple="multiple" size="6"  style="width:200px">
             <%
                for(int i=0;i<leftlist.size();i++){
                   map = (HashMap)leftlist.get(i);
                   out.println("<option value=" + (String)map.get("hlr") + " >" + (String)map.get("hlr") + "</option>" );
                }
             %>
             </select>
             </td>
             </tr>
             </table>
        </td>
            <td width="10%" align="center" >

              <table width="94%" border=0  class="table-style2" height="106">
                <tr>
                  <td width="40" align="right" height="31">&nbsp; </td>
                </tr>
                <tr>
                  <td width="40" align="right" height="23">
                    <input type='button' value='-->'  onClick="javascript:moveRight()" name="moveright">
                  </td>
                </tr>
                <tr>
                  <td width="40" align="right" height="38">
                    <input type='button' value='<--'  onClick="javascript:moveLeft()" name="moveleft">
                  </td>
                </tr>
              </table>
            </td>
        <td width="45%">
             <table border=0  class="table-style2">
             <tr>
                  <td width="75" ><span title="Please select a service area">Service area</span></td>
                  <td width="151">
                    <select name="rightarea" size="1"  style="width:150px" onchange="javascript:onProvinceChange()" >
                    <option value="-1" >No service area</option>
              <% out.print(optAreaList); %>
             </select>
             </td>
             </tr>
             <tr>
             <td colspan=2>
             <select multiple="multiple" name="rightlist" size="6"    style="width:200px" >
             <%
                for(int i=0;i<rightlist.size();i++){
                   map = (HashMap)rightlist.get(i);
                   out.println("<option value=" + (String)map.get("hlr") + " >" + (String)map.get("hlr") + "</option>" );
                }
             %>
             </select>
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
<%
        }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
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
        e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in managing service area code prefix!");//业务区号段管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing service area code prefix!");//业务区号段管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="areaHlr.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
