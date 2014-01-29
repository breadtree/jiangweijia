<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public String transferString(String str) throws Exception {
      return str;
    }
    public String operStatus(String statstr) {
        int stat = 0;
        stat = Integer.parseInt(statstr);
        String strTemp = "Normal";
        if (stat ==1)
            strTemp = "Lock";
        else if(stat == 2)
            strTemp = "Blacklist";
        else  if(stat == 3)
            strTemp = "Disable";
        else if(stat>9)
            strTemp = "Blacklist";
        return strTemp;
    }
%>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />

<%
    try {


        String noUseDays=(String)request.getParameter("noUseDays") == null ? "" : ((String)request.getParameter("noUseDays")).trim();
        HashMap map = new HashMap();
        String flag = (String)request.getParameter("flag") == null ? "" : (String)request.getParameter("flag");
        String creatorID = (String)session.getAttribute("OPERID");
        String operID = (String)request.getParameter("operID");
        String serflag2 = request.getParameter("serflag2");
        String opername = request.getParameter("opername")==null?"":request.getParameter("opername");;
        String opertype = (String)request.getParameter("operType");
        String updatename = request.getParameter("operName");
        if(!"".equals(updatename) && updatename!=null) {
          updatename = JspUtil.getParameter(updatename);
        }
        String statFlag = "0";
        String pid = (String)request.getParameter("pid");
        String stat = request.getParameter("stat")==null?"":request.getParameter("stat");
        String statstrs = "";
        if(!"".equals(stat)) {
           if(!"0".equals(stat)){
             statFlag = "1";
           }
           statstrs = operStatus(stat);
        }

        if (operID != null)
            map.put("OPERID",operID);
        if (flag.equalsIgnoreCase("add"))
            map.put("CREATORID",creatorID);
        map.put("OPERNAME",(String)request.getParameter("operName") == null ? "" : transferString(((String)request.getParameter("operName")).trim()));
        map.put("OPERALLNAME",(String)request.getParameter("operAllName") == null ? "" : transferString(((String)request.getParameter("operAllName")).trim()));
        map.put("OPERDESCRIPTION",(String)request.getParameter("operDescription") == null ? "" : transferString(((String)request.getParameter("operDescription")).trim()));
        map.put("OPERPWD",(String)request.getParameter("operPwd") == null ? "" : ((String)request.getParameter("operPwd")).trim());
        String nextUpdPwd = (String)request.getParameter("nextUpdPwd") == null ? "" : (String)request.getParameter("nextUpdPwd");
        if (nextUpdPwd.equalsIgnoreCase("on"))      // 下次登录时须更改密码
            map.put("NEXTUPDPWD","1");
        else
            map.put("NEXTUPDPWD","0");
        String pwdNeverUpd = (String)request.getParameter("pwdNeverUpd") == null ? "" : (String)request.getParameter("pwdNeverUpd");
        if (pwdNeverUpd.equalsIgnoreCase("on"))     // 用户不得更改密码
            map.put("PWDNEVERUPD","1");
        else
            map.put("PWDNEVERUPD","0");
        String pwdMustChange = (String)request.getParameter("pwdMustChange") == null ? "" : (String)request.getParameter("pwdMustChange");
	if (pwdMustChange.equalsIgnoreCase("on")) {  // If Pwd Never Expired is checked
            map.put("PWDMUSTCHANGE","0");
        }
        String pwdMustChange1 = (String)request.getParameter("pwdMustChange1") == null ? "" : ((String)request.getParameter("pwdMustChange1")).trim();
	if (pwdMustChange1.equalsIgnoreCase("on"))  // If Limit of Pwd Validity is checked
            try {
	            map.put("PWDMUSTCHANGE",Integer.parseInt(request.getParameter("passwordChange")) + "");
            }
            catch (Exception e) {
                map.put("PWDMUSTCHANGE","0");
            }
	if ((!pwdMustChange.equalsIgnoreCase("on"))&&(!pwdMustChange1.equalsIgnoreCase("on"))) {  // If Limit of Pwd Validity and Pwd never Expired is not checked
            map.put("PWDMUSTCHANGE","0");
        }
        int operStatus = 0;                        
        if (request.getParameter("userForbid") != null){
            operStatus = operStatus + 3;
          statFlag = "1";
          statstrs = operStatus(operStatus+"");
        }
        if (request.getParameter("userLocked") != null){
            operStatus = operStatus + 1;
          statFlag = "1";
          statstrs = operStatus(operStatus+"");
        }
        if (flag.equalsIgnoreCase("update"))
            if (purview.isBlacklist(operID))
                operStatus = 10;
        map.put("OPERSTATUS","" + operStatus);
        String maxNoUseDays = "0";                  // 帐号最大闲置时间
        if (request.getParameter("maxNoUseDays") != null)
            maxNoUseDays = (String)request.getParameter("noUseDays") == null ? "0" : ((String)request.getParameter("noUseDays")).trim();
        map.put("MAXNOUSEDAYS",maxNoUseDays);
        String maxWrgLog = "0";                     // 连续错误登录次数
        if (request.getParameter("maxWrongTimes") != null)
            maxWrgLog = (String)request.getParameter("wrongTimes") == null ? "0" : ((String)request.getParameter("wrongTimes")).trim();
        map.put("MAXWRGLOG",maxWrgLog);
        String useDate = "999";                     // 帐号有效期
        if (request.getParameter("useDate") != null)
            useDate = (String)request.getParameter("endDate") == null ? "999" : ((String)request.getParameter("endDate")).trim();
        map.put("USEDATE",useDate);
        // 登录时间
        String workDay = "1111111";
        String onLimit = (String)request.getParameter("onLimit") == null ? "0" : ((String)request.getParameter("onLimit")).trim();
        if (onLimit.equals("0")) {
            map.put("BEGINTIME","999");
            map.put("ENDTIME","23:59:59");
        }
        else {
            workDay = request.getParameter("sunday") == null ? "0" : "1";
            workDay = workDay + (request.getParameter("monday") == null ? "0" : "1");
            workDay = workDay + (request.getParameter("tuesday") == null ? "0" : "1");
            workDay = workDay + (request.getParameter("wednesday") == null ? "0" : "1");
            workDay = workDay + (request.getParameter("thursday") == null ? "0" : "1");
            workDay = workDay + (request.getParameter("friday") == null ? "0" : "1");
            workDay = workDay + (request.getParameter("saturday") == null ? "0" : "1");
            map.put("BEGINTIME",(String)request.getParameter("beginTime"));
            map.put("ENDTIME",(String)request.getParameter("endTime"));
        }
        map.put("WORKDAY",workDay);
        // 登录机器
        ArrayList ipList = new ArrayList();
        HashMap ipMap = new HashMap();
        String allowIP = (String)request.getParameter("allowIP");
        String noAllowIP = (String)request.getParameter("noAllowIP");
        // 登记允许登录的IP
        int index = allowIP.indexOf(";");
        while (index > 0) {
            ipMap = new HashMap();
            ipMap.put("IPADDR",(allowIP.substring(0,index)).trim());
            ipMap.put("ALLOWFLAG","1");
            if (index + 1 >= allowIP.length())
                allowIP = "";
            else
                allowIP = allowIP.substring(index + 1,allowIP.length());
            index = allowIP.indexOf(";");
            ipList.add(ipMap);
        }
        // 登记禁止登录的IP
        index = noAllowIP.indexOf(";");
        while (index > 0) {
            ipMap = new HashMap();
            ipMap.put("IPADDR",(noAllowIP.substring(0,index)).trim());
            ipMap.put("ALLOWFLAG","0");
            noAllowIP = noAllowIP.substring(index + 1,noAllowIP.length());
            index = noAllowIP.indexOf(";");
            ipList.add(ipMap);
        }

       //操作员业务信息
        int serindex = 0;
        String serflag = (String)request.getParameter("serflag") == null ? "0" : (String)request.getParameter("serflag");
        if (serflag.equals("1"))   //sp管理员
           serindex = Integer.parseInt(request.getParameter("spindex"));
        else if(serflag.equals("2")){  //集团管理员
            String groupid = (String)request.getParameter("groupid") == null ? "" : (String)request.getParameter("groupid");
            if(groupid.equals(""))
               throw new Exception("Please enter a group code!");
            serindex = 1;
        }
        map.put("SERFLAG",serflag);
        map.put("SERINDEX",serindex+"");
        map.put("IPLIST",ipList);
        if (flag.equalsIgnoreCase("add"))
            purview.addOper(map);
        else
            purview.updateOper(map);

      if("3".equals(stat) && request.getParameter("userForbid") == null){
        statstrs = operStatus("0");
        statFlag = "0";
      }
      if("1".equals(stat) && request.getParameter("userLocked") == null){
        statstrs = operStatus("0");
        statFlag = "0";
      }
      updatename = updatename+"("+statstrs+")";

%>
<html>
<head>
<title><%= flag.equalsIgnoreCase("add") ? "Add" : "Modify" %>&nbsp;Operator</title>
</head>
<body>
<script language="javascript">
<%
   if(flag.equalsIgnoreCase("add")){
%>
    window.opener.refresh();
<%
   } else {
     if("update".equals(opertype)){
%>
     window.opener.updateMember('<%=pid%>','<%=operID%>','<%=updatename%>','<%=statFlag%>');
   <%}else{%>
    window.opener.refresh2('<%=serflag2%>','<%=opername%>');
<% }%>
<% }%>
    window.close();
</script>
</body>
</html>
<%
    }
    catch (Exception e) {
        out.println(e.getMessage());
        e.printStackTrace();
    }
%>
