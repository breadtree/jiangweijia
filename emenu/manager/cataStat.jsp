<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manStat" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public String transferString(String str) throws Exception {
      return str;
    }
%>
<html>
<head>
<title>Statistics on ringtones in category libraries</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script src="../pubfun/JsFun.js"></script>
</head>
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    try {
        String    errmsg = "";
        String    queryType = "";
        int       queryMode = 0;
        boolean   flag =true;
        if (purviewList.get("4-11") == null) {
          errmsg = "You have no access to this function!";//You have no access to this function
          flag = false;
         }
       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
       }
       if(flag){
         String craccount = request.getParameter("ringlibid") == null ? "" : transferString((String)request.getParameter("ringlibid"));
         String Pos = request.getParameter("Pos") == null ? "" : transferString((String)request.getParameter("Pos"));
         
         //pos should come from db,avoid charset problem
         {
         	zxyw50.manSysRing sysring = new zxyw50.manSysRing();
         	if(!"".equals(craccount))
         	{
         		Hashtable tmphash = sysring.getRingLibraryNode(craccount);
         		Pos = (String)tmphash.get("ringliblabel");
         	}
         }
         
         String type =  request.getParameter("cata") == null ? "null" : transferString((String)request.getParameter("cata"));

         String startday = request.getParameter("start") == null ? "" : (String)request.getParameter("start").trim();
         String endday = request.getParameter("end") == null ? "" : (String)request.getParameter("end").trim();
         boolean checkflag = startday.equals("") ? false : true;
         ArrayList arraylist = new ArrayList();
         HashMap map = new HashMap();
         int   total = 0,num=0;
         String sTmp = "";
         if(!craccount.equals("")){
           manStat  manstat = new manStat();
           sysTime = manstat.getSysTime() + "--";
//           if(type.trim().equalsIgnoreCase("null"))
//           {//System.out.println("type is null");
//             //total = manstat.cataRingStat(craccount);
//             if(startday.trim().equalsIgnoreCase("")||endday.trim().equalsIgnoreCase(""))
//                 total = manstat.cataRingStatByTimes(craccount,null,null);
//             else
//                 total = manstat.cataRingStatByTimes(craccount,startday,endday);
//             num = manstat.cataRingCataNumber(craccount,true);
//           }
//           else
//           {//System.out.println("type is not null");
              if(type.trim().equalsIgnoreCase(""))
                 type = "0";
              if(type.trim().equalsIgnoreCase("0"))
              {
                Date dt = new Date();
                dt.setTime(dt.getTime()-24*3600*1000);
                String tmp = "";
                tmp+=(dt.getYear() +1900)+".";
                if((dt.getMonth() +1) < 10)
                   tmp+="0"+(dt.getMonth() +1)+".";
                else
                   tmp+=(dt.getMonth() +1)+".";
                if(dt.getDate() < 10)
                   tmp+="0"+dt.getDate()+"";
                else
                   tmp+=dt.getDate()+"";
                   startday = endday = tmp ;
              }
                 map.put("ringlibid",craccount);
                 map.put("startday",startday);
                 map.put("endday",endday);
                 map.put("type",type);
//                 System.out.println(craccount+"|"+startday+"|"+endday+"|"+type);
             total =  manstat.cataRingCataStat(map);
             num = manstat.cataRingCataNumber(craccount,true);
//           }
//          System.out.println(craccount+"|"+startday+"|"+endday+"|"+type);
           if(total<0)
              sTmp ="Statistics not available now";//暂未统计
           else
              sTmp = String.valueOf(total);
         }
%>

<body background="background.gif" class="body-style1" >
<form name="inputForm" method="post" action="cataStat.jsp">
<input type="hidden" name="ringlibid" value="<%= craccount == null ? "" : craccount %>">
<input type="hidden" name="Pos" value="<%= Pos %>">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.parent.document.all.main.style.height="700";
</script>
  <table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
  <tr>
  <td align="center">
     <table border="0" align="center" cellspacing="2" cellpadding="2" class="table-style2">
     <tr height=40>
     <td align=center width="40%" >Ringtone library</td>
      <td><input type="text" name="ringlib" value="<%= Pos %>"  maxlength="40" class="input-style0" style="width:200px" disabled >
     </td>
     </tr>
     <tr height=40>
     <td align=center width="40%">Total number of ringtone orders
     </td>
     <td><input type="text" name="buytimes" value="<%= sTmp %>"  maxlength="40" class="input-style0" style="width:200px"  disabled >
     </td>
     </tr>
     <tr height=40>
     <td align=center width="40%">Total number of current ringtone category
     </td>
     <td><input type="text" name="num" value="<%= num+"" %>"  maxlength="40" class="input-style0" style="width:200px"  disabled >
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
%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   parent.document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in the statistics on ringtones in category libraries!");//分类库铃音统计过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in the statistics on ringtones in category libraries!");//分类库铃音统计过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="cataStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
