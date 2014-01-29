<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
   
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<html>
<head>
<title>Authorize</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<script language="javascript">
   function changeServiceKey () {
      document.view.param1.value = -1;
      document.view.param2.value = -1;
      document.view.param3.value = -1;
      document.view.param4.value = -1;
      document.view.submit();
   }

   function paramChanged (paramOrder) {
      if (paramOrder == 1) {
         document.view.param1.value = document.view.param1List.value;
         document.view.param2.value = -1;
         document.view.param3.value = -1;
         document.view.param4.value = -1;
      }
      else if (paramOrder == 2) {
         document.view.param2.value = document.view.param2List.value;
         document.view.param3.value = -1;
         document.view.param4.value = -1;
      }
      else if (paramOrder == 3) {
         document.view.param4.value = -1;
         document.view.param3.value = document.view.param3List.value;
      }
      else if (paramOrder == 4)
         document.view.param4.value = document.view.param4List.value;
      else {
         alert("Invalid parameter selection!");//参数选择错误
         return;
      }
      document.view.submit();
   }

   function authorizeGrp () {
      if (document.view.allOperGroup.selectedIndex >= 0) {
         document.view.operGrpID.value = document.view.allOperGroup.value;
         document.view.operate.value = 'authorize';
         document.view.submit();
      }
      else
         alert("Please select the right to be assigned!");//请先选择要分配的权限
   }

   function dismissGrp () {
      if (document.view.allowOperGroup.selectedIndex >= 0) {
         document.view.operate.value = 'dismiss';
         if (confirm("Are you sure to take back the right?"))//确定要收回权限
         {
  			   <!--document.view.operGrpID.value = document.view.allowOperGroup.value; -->
  			  	var idx=document.view.allowOperGroup.value.indexOf("|");
         	document.view.operGrpID.value =  document.view.allowOperGroup.value.substr(0,idx);
         	var str=document.view.allowOperGroup.value.substr(idx+1);
         	idx=str.indexOf("_");
         	document.view.param1.value=str.substr(0,idx);
         	str=str.substr(idx+1);
         	idx=str.indexOf("_");
         	document.view.param2.value=str.substr(0,idx);
         	str=str.substr(idx+1);
         	idx=str.indexOf("_");
         	document.view.param3.value=str.substr(0,idx);
         	str=str.substr(idx+1);
         	idx=str.indexOf("_");
         	document.view.param4.value=str.substr(0,idx);
            document.view.submit();
      }
 }
      else
         alert("Please select the right to be taken back!");
   }

   function detail(){
     m1.style.display = 'none';
     b1.style.display = 'block';
   }
</script>
</head>
<body class="body-style1">
<%
    try {
            String creatorID = (String)session.getAttribute("OPERID");
      String enablegrphallno = CrbtUtil.getConfig("enablegrphallno","0");
      String operID1 = (String)session.getAttribute("OPERID");
      Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
      if(operID1!=null && purviewList.get("5-2") != null){
        String serviceKey = (String)session.getAttribute("SERVICEKEY");
        //serviceKey = "all";
        ArrayList serviceList = purview.getServiceList(serviceKey);
        String selectedServiceKey = (String)request.getParameter("serviceKey");
        String operID = request.getParameter("operID") == null ? "" : (String)request.getParameter("operID");
        String operName = request.getParameter("operName") == null ? "" : (String)request.getParameter("operName");
        operName = JspUtil.getParameter(operName);
        String operGrpID = request.getParameter("operGrpID") == null ? "" : (String)request.getParameter("operGrpID");
        String operate = request.getParameter("operate") == null ? "" : (String)request.getParameter("operate");
        int param1 = request.getParameter("param1") == null ? -1 : Integer.parseInt((String)request.getParameter("param1"));
        int param2 = request.getParameter("param2") == null ? -1 : Integer.parseInt((String)request.getParameter("param2"));
        int param3 = request.getParameter("param3") == null ? -1 : Integer.parseInt((String)request.getParameter("param3"));
        int param4 = request.getParameter("param4") == null ? -1 : Integer.parseInt((String)request.getParameter("param4"));
        HashMap map = new HashMap();
        String flagString = "";
        // 判断选定的业务键,如果没有,赋初值
        if (selectedServiceKey == null)
            if (serviceList.size() > 0)
                selectedServiceKey = (String)((HashMap)serviceList.get(0)).get("SERVICEKEY");
            else
                selectedServiceKey = serviceKey;
        if (selectedServiceKey.equalsIgnoreCase("all"))
            selectedServiceKey = (String)((HashMap)serviceList.get(0)).get("SERVICEKEY");
        // 授予权限
        if (operate.equalsIgnoreCase("authorize")) {
            map.put("OPERID",operID);
            map.put("SERVICEKEY",selectedServiceKey);
            map.put("OPERGRPID",operGrpID);
            map.put("PARAM1",param1 + "");
            map.put("PARAM2",param2 + "");
            map.put("PARAM3",param3 + "");
            map.put("PARAM4",param4 + "");
            if (purview.authorizeOperGrp(map))
                flagString = "Right assigned successfully!";//授予权限成功
            else
                flagString = "Failed to assign the right:exceeded range of rights!";//授予权限失败
        }
        // 收回权限
        else if (operate.equalsIgnoreCase("dismiss")) {
        		int gparam1 = request.getParameter("param1") == null ? -1 : Integer.parseInt((String)request.getParameter("param1"));
        		int gparam2 = request.getParameter("param2") == null ? -1 : Integer.parseInt((String)request.getParameter("param2"));
        		int gparam3 = request.getParameter("param3") == null ? -1 : Integer.parseInt((String)request.getParameter("param3"));
        		int gparam4 = request.getParameter("param4") == null ? -1 : Integer.parseInt((String)request.getParameter("param4"));
            purview.dismissOperGrp(Integer.parseInt(operID),selectedServiceKey,Integer.parseInt(operGrpID),
                                   gparam1,gparam2,gparam3,gparam4);
            flagString = "Take back the right of " + operName + " group index of "+operGrpID;
        }
        ArrayList paramList = purview.getServiceParamList(selectedServiceKey);   // 权限范围列表
        ArrayList paramInfoList = new ArrayList();
        ArrayList allOperGroup = purview.getGroupByService(selectedServiceKey);  // 所有的操作员组
        ArrayList allowOperGroup = new ArrayList();                         // 已经分配的操作员组
        if (! operID.equals(""))
            allowOperGroup = purview.getGroupByService(operID,selectedServiceKey);
        // 把已分配的操作员组从所有可分配的操作员组中删除
       if (allowOperGroup.size() > 0 && purview.getOperSerType(operID)!=0) {
            int allowOperGrpID = 0;
            for (int i = 0; i < allowOperGroup.size(); i++) {
                allowOperGrpID = Integer.parseInt((String)((HashMap)allowOperGroup.get(i)).get("OPERGRPID"));
                for (int j = allOperGroup.size() - 1; j >= 0; j--)
                    if (allowOperGrpID == Integer.parseInt((String)((HashMap)allOperGroup.get(j)).get("OPERGRPID")))
                        allOperGroup.remove(j);
            }
        }
        String paramName = "";
        int value = 0;
%>
<form name="view" method="post" action="allotRights.jsp">
<table border="0" width="100%">
  <tr>
    <td width="100%">
      <table border="0" width="100%" bordercolorlight="#ffffff" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
        <tr class="tr-ring">
          <td width="30%" align="center">Management system</td>
          <td width="70%" class="tr-ring">
            <select name="serviceKey" <%= serviceList.size() < 2 ? "disabled" : "" %> onChange="javascript:changeServiceKey()" class="input-style1">
<%
        for(int i = 0; i < serviceList.size(); i++) {
            map = (HashMap)serviceList.get(i);
%>
              <option value="<%= (String)map.get("SERVICEKEY") %>" <%= selectedServiceKey.equals((String)map.get("SERVICEKEY")) ? "selected" : "" %>><%= (String)map.get("DESCRIPTION") %></option>
<%
        }
%>
            </select></td>
        </tr>
        <tr height="80" align="center" class="tr-ring">
          <td>Range of rights <%= operID.equals("") ? "" : "<br><br><font color=\"yellow\"><B>Operator<br>" + operName + "</B></font>" %></td>
<%
        if (paramList.size() == 0 || ((operID!=null) && (!operID.equals("")) && (purview.getOperSerType(operID)!=0))) {
%>
          <td class="tr-ring">Entire management system</td>
<%
        }
        else {
            if(param1 == -1)
                param1 = 0;
            map = (HashMap)paramList.get(0);
            paramInfoList = purview.getServiceParamInfo(map);
            paramName = (String)map.get("PCFIELDNAME");
%>
          <td>
            <table width="100%" border="0" class="table-style1">
              <tr height="20" class="tr-ring">
                <td width="30%" align="right"><%= paramName %></td>
                <td width="70%">
                  <select name="param1List" onChange="javascript:paramChanged(1)" class="input-style1">
<%
            for (int i = 0; i < paramInfoList.size(); i++) {
                map = (HashMap)paramInfoList.get(i);
                value = Integer.parseInt((String)map.get("VALUE"));
%>
                    <option value="<%= value %>" <%= param1 == value ? "selected" : "" %>><%= (String)map.get("NAME") %></option>
<%
            }
%>
                  </select>
                </td>
              </tr>
              <tr height="20" class="tr-ring">
<%
            if (paramList.size() < 2||(!"1".equals(enablegrphallno))) {
%>
                <td colspan="2"></td>
<%
            }
            else {
                map = (HashMap)paramList.get(1);
                paramName = (String)map.get("PCFIELDNAME");
                map.put("PARAM1",param1 + "");
                paramInfoList = purview.getServiceParamInfo(map);
                if (param1 != 0 && param2 == -1)
                    param2 = 0;
%>
                <td align="right"><%= paramName %></td>
                <td>
                  <select name="param2List" <%= param1 == 0 ? "disabled" : "" %> onChange="javascript:paramChanged(2)" class="input-style1">
<%
                for (int i = 0; i < paramInfoList.size(); i++) {
                    map = (HashMap)paramInfoList.get(i);
                    value = Integer.parseInt((String)map.get("VALUE"));
%>
                    <option value="<%= value %>" <%= param2 == value ? "selected" : "" %>><%= (String)map.get("NAME") %></option>
<%
            }
%>
                  </select>
                </td>
<%
            }
%>
              </tr>
              <tr height="20">
<%
            if (paramList.size() < 3) {
%>
                <td colspan="2"></td>
<%
            }
            else {
                map = (HashMap)paramList.get(1);
                paramName = (String)map.get("PCFIELDNAME");
                map.put("PARAM1",param1 + "");
                map.put("PARAM2",param2 + "");
                paramInfoList = purview.getServiceParamInfo(map);
                if (param2 != 0 && param3 == -1)
                    param3 = 0;
%>
                <td align="right"><%= paramName %></td>
                <td>
                  <select name="param3List" <%= param1 * param2 == 0 ? "disabled" : "" %> onChange="javascript:paramChanged(3)" class="input-style1">
<%
                for (int i = 0; i < paramInfoList.size(); i++) {
                    map = (HashMap)paramInfoList.get(i);
                    value = Integer.parseInt((String)map.get("VALUE"));
%>
                    <option value="<%= value %>" <%= param3 == value ? "selected" : "" %>><%= (String)map.get("NAME") %></option>
<%
            }
%>
                  </select>
                </td>
<%
            }
%>
              </tr>
              <tr height="20">
<%
            if (paramList.size() < 3) {
%>
                <td colspan="2"></td>
<%
            }
            else {
                map = (HashMap)paramList.get(1);
                paramName = (String)map.get("PCFIELDNAME");
                map.put("PARAM1",param1 + "");
                map.put("PARAM2",param2 + "");
                map.put("PARAM3",param3 + "");
                paramInfoList = purview.getServiceParamInfo(map);
                if (param3 != 0 && param4 == -1)
                    param4 = 0;
%>
                <td align="right"><%= paramName %></td>
                <td>
                  <select name="param4List" <%= param1 * param2 * param3 == 0 ? "disabled" : "" %> onChange="javascript:paramChanged(4)" class="input-style1">
<%
                for (int i = 0; i < paramInfoList.size(); i++) {
                    map = (HashMap)paramInfoList.get(i);
                    value = Integer.parseInt((String)map.get("VALUE"));
%>
                    <option value="<%= value %>" <%= param4 == value ? "selected" : "" %>><%= (String)map.get("NAME") %></option>
<%
            }
%>
                  </select>
                </td>
<%
            }
%>
              </tr>
            </table>
          </td>
<%
        }
%>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>
      <table border="0" width="98%" class="body-style1">
        <tr class="table-title1">
          <td height="24" align="left" class="tr-ring">Assignable rights group


</td>
          </tr>
        <tr class="table-title1">
          <td align="left">
            <select name="allOperGroup" size="6" <%= operID.equals("") ? "disabled" : "" %> class="input-style3">
  <%
        for (int i = 0; i < allOperGroup.size(); i++) {
            map = (HashMap)allOperGroup.get(i);
%>
                <option value="<%= (String)map.get("OPERGRPID") %>"><%= (String)map.get("GRPSCRIPT") %></option>
  <%
        }
%>
            </select>          </td>
          </tr>
        <tr>
          <td>
            <table width="100%" border="0" class="body-style1">
              <tr align="center">
                <td width="50%"><input type="button" name="authorize" value="Assign" onClick="javascript:authorizeGrp()" <%= operID.equals("") ? "disabled" : "" %> class="button-style4"></td>
                <td width="50%"><input type="button" name="dismiss" value="Take back" onClick="javascript:dismissGrp()" <%= operID.equals("") ? "disabled" : "" %> class="button-style4"></td>
              </tr>
            </table>
          </td>
        <tr class="table-title1">
          <td height="24" align="right" class="tr-ring"><div align="left">Assigned rights group


</div></td>
          </tr>
        <tr>
          <td align="right" class="tr-ring">
            <div align="left">
              <select name="allowOperGroup" size="11" <%= (operID.equals("")||operID.equals(operID1)) ? "disabled" : "" %> class="input-style3" >
      <%
        for (int i = 0; i < allowOperGroup.size(); i++) {
            map = (HashMap)allowOperGroup.get(i);
   			String[] pnames = new String[4];
    		   pnames[0]=(String)map.get("PARAM1NAME");
            pnames[1]=(String)map.get("PARAM2NAME");
            pnames[2]=(String)map.get("PARAM3NAME");
            pnames[3]=(String)map.get("PARAM4NAME");
    		   String[] grpparams = new String[4];
            grpparams[0]=(String)map.get("PARAM1");
            grpparams[1]=(String)map.get("PARAM2");
            grpparams[2]=(String)map.get("PARAM3");
            grpparams[3]=(String)map.get("PARAM4");



            String strTmp="|"+grpparams[0]+"_"+grpparams[1]+"_"+grpparams[2]+"_"+grpparams[3]+"_";
%>
						<option value="<%
						out.println((String)map.get("OPERGRPID")+strTmp);%>">
                  	<%
                  	   String s=(String)map.get("GRPSCRIPT");

                  	   if( ((operID!=null) && (!operID.equals("")) && (purview.getOperSerType(operID)==0))){
                  	   	int k;
                  	   	s+="     :";
                  	   	for(k=0;k<4;k++)
                  	   		s+=pnames[k]+" &nbsp; ";
                  	   }
                  		out.println(s);
                  	%>
                  </option>
                  <%
        }
%>
              </select>
            </div></td>
          </tr>
      </table>
    </td>
  </tr>
</table>
<input type="hidden" name="param1" value="<%= param1 %>">
<input type="hidden" name="param2" value="<%= param2 %>">
<input type="hidden" name="param3" value="<%= param3 %>">
<input type="hidden" name="param4" value="<%= param4 %>">
<input type="hidden" name="operID" value="<%= operID %>">
<input type="hidden" name="operName" value="<%= operName %>">
<input type="hidden" name="operGrpID" value="">
<input type="hidden" name="operate" value="">
</form>
<%
        if (flagString.length() > 0) {
%>
<script>
   alert('<%= flagString %>');
</script>
<%
        }

        }
        else {

          if(operID1 == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    parent.document.location.href = '../enter.jsp';
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
%>
<table border="1" width="100%" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
  <tr>
    <td>Error:<%= e.toString() %></td>
  </tr>
</table>
<%
    }
%>
</body>
</html>
