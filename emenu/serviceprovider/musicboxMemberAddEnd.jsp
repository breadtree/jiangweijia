<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.zxywpub.*" %>
<%@ page import="zxyw50.SpManage" %>
<%@ page import="zxyw50.CrbtUtil" %>


<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    String sysringgrpcheck = "0",ringoper="0";
    ringoper=CrbtUtil.getConfig("musicringoper","0");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String spIndex = (String)session.getAttribute("SPINDEX");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String errMsg="";
    boolean alertflag=false;
    if(operID==null){
      errMsg = "Please log in first!";
      alertflag=true;
    }
    else if (spIndex  == null || spIndex.equals("-1")){
		errMsg = "Sorry,you are not SP manager!";
      alertflag=true;
    }
    else if (purviewList.get("10-7") == null)  {
		errMsg = "Sorry,you have no right to access this function!";
      alertflag=true;
    }
    if(alertflag==true){
%>
<script language="javascript1.2">
  alert(errMsg);
</script>
<%
	return;
    }
    try {
  	String ringgroup=(String)session.getAttribute("RINGGROUP");
    	String grouplabel=(String)session.getAttribute("GROUPLABEL");
        ColorRing cr = new ColorRing();
        //3.17.07
    	String ringid =(String)request.getParameter("ringidadd") == null ? "0" : (String)request.getParameter("ringidadd");
        Map hMap = (Map)cr.getRingInfo(ringid);
        String ringfee =(String)hMap.get("ringfee");
        String ringlabel =(String)hMap.get("ringlabel");
        String singgername =(String)hMap.get("ringauthor");
        String validdate =(String)hMap.get("validtime");
        String ringspell =(String)hMap.get("ringspell");
        String uservalidday =(String)hMap.get("uservalidday");
        if(uservalidday == null || uservalidday.trim().equalsIgnoreCase(""))
           uservalidday = "0" ;
        int ischeckop = 0 ,grpcheck=0;
        SpManage sysringgroup = new SpManage();
        ischeckop = sysringgroup.getSpOperischeck(spIndex);
        grpcheck = sysringgroup.getMusiccheckStatus(spIndex,ringgroup);
        if(ischeckop>0&&grpcheck>0)
          sysringgrpcheck = "1";
        //如果删除或增加铃音在配置项中无需审核的话,就改为不审核
        if(ringoper.trim().equalsIgnoreCase("0"))
          sysringgrpcheck = "0";
        if(sysringgrpcheck.equalsIgnoreCase("0")){
          HashMap  map = new HashMap();
          map.put("opcode","1");
          map.put("ringgroup",ringgroup);
          map.put("ringid",ringid);
          map.put("newringid","newringid"); //该参数无用

          ArrayList rList = new ArrayList();
          rList=sysringgroup.modSysRingGroupMem(map);

          map = new HashMap();
          zxyw50.Purview purview = new zxyw50.Purview();
          String serviceKey = (String)session.getAttribute("SERVICEKEY");
          map.put("OPERID",operID);
          map.put("OPERNAME",operName);
          map.put("OPERTYPE","1007");
          map.put("RESULT","1");
        map.put("DESCRIPTION","Add member of ringtone group "+ringgroup+" is:"+ringid);
          map.put("PARA1",ringgroup);
          map.put("PARA2",grouplabel);
          map.put("PARA3",ringid);
        map.put("PARA4","ip:"+request.getRemoteAddr());
          purview.writeLog(map);

          if(rList.size()>0){
            session.setAttribute("rList",rList);

%>
<html>
<head>
<title>Add member in music box of SP</title>
</head>
<body>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="musicboxMember.jsp?ringgroup=<%=ringgroup%>&grouplabel=<%=grouplabel%>">
<input type="hidden" name="title" value="Add member in music box of SP">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
</body>
</html>
<%
		}
              }else{
                String mess="";
                HashMap opmap = new HashMap();
                manSysRing manring = new manSysRing();
                ArrayList ls = null;
                Hashtable tmp = null;
                opmap.put("operid",spIndex);
                opmap.put("opername",operName);
                opmap.put("opertype","102");
                opmap.put("status","0");
                opmap.put("ringid",ringid);
                opmap.put("operdesc","");
                opmap.put("refusecomment","");
                opmap.put("ringfee",ringfee);
                opmap.put("ringlabel",ringlabel);
                opmap.put("singgername",singgername);
                opmap.put("validdate",validdate);
                opmap.put("ringspell",ringspell);
                opmap.put("uservalidday",uservalidday);
                opmap.put("ringgroup",ringgroup);
                opmap.put("ringidnew","");
                opmap.put("ringcnt","0");
                ls = manring.addoperCheck(opmap);
                session.setAttribute("rList",ls);
                for(int i=0;i<ls.size();i++){
                  tmp = (Hashtable)ls.get(i);
                  if(!"0".equalsIgnoreCase(tmp.get("result").toString().trim()))
                  mess+=tmp.get("scp").toString().trim()+"-"+tmp.get("reason").toString().trim()+" ";
                }
                if(mess.trim().equalsIgnoreCase(""))
                  mess = "Insert approval data successfully";
                else
                  mess = "Insert approval data,SCP failure:("+mess+")";
%>
<html>
  <head>
    <title>add SP music box members</title>
    <script language="JavaScript">
    <%if(!mess.trim().equalsIgnoreCase("")){%>
    window.alert('<%=mess%>');
    <%}%>
    window.returnValue = "yes";
    </script>
  </head>
  <body>
    <form name="resultForm" method="post" action="result.jsp">
      <input type="hidden" name="historyURL" value="musicboxMember.jsp?ringgroup=<%=ringgroup%>&grouplabel=<%=grouplabel%>">
        <input type="hidden" name="title" value="add SP music box members">
          <script language="javascript">
          document.resultForm.submit();
          </script>
    </form>
  </body>
</html>
<%
  }
}
catch (Exception e) {
  out.println(e.getMessage());
}
%>
