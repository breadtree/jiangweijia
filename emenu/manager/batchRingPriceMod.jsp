<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.ringAdm" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>


<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public String transferString(String str) throws Exception {
        try {
            return (new String(str.getBytes("ISO8859_1"),"ISO8859_1")).trim();
        }
        catch (UnsupportedEncodingException e) {
            throw new Exception (e.getMessage() + "\r\nUnsupported type of characters used!");//使用了不支持的字符类型!
        }
    }
    private Vector StrToVector(String str){
	  int index = 0;
	  String  temp = str;
	  String  temp1 ="";
	  Vector ret = new Vector();
	  if (str.length() ==0)
	      return ret;
	  index = str.indexOf("|");
   	  while(index >= 0){
	      if(index==0)
	         temp1 = "&nbsp;";
	      else
	         temp1 = temp.substring(0,index);
	      ret.addElement(temp1);
		  if(index < temp.length())
		     temp = temp.substring(index+1);
		  else
		     break;
		  index = 0;
		  if (temp.length() > 0)
		     index  = temp.indexOf("|");
	  }
	  return ret;
  }

%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<title>Order ringtones</title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>

<body topmargin="0" leftmargin="0" class="body-style1">
<%
String openprint = CrbtUtil.getConfig("openprint","0");
HashMap map = new HashMap();
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String url = "";
 try {
    
    String monthlyprice = request.getParameter("monthlyprice") == null ? "0" : ((String)request.getParameter("monthlyprice")).trim();
    String dailyprice = request.getParameter("dailyprice") == null ? "0" : ((String)request.getParameter("dailyprice")).trim();
    String searchvalue = request.getParameter("searchvalue") == null ? "" : ((String)request.getParameter("searchvalue"));
    String ringidtype = request.getParameter("ringidtype")==null?"1":(String)request.getParameter("ringidtype");
    String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
    String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
    String spindex = request.getParameter("spindex") == null ? "0" : (String)request.getParameter("spindex");
    int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
    url = request.getParameter("url") == null ? "batchRingPrice.jsp" : (String)request.getParameter("url");
    sysTime = SocketPortocol.getSysTime() + "--";
    String ringList = request.getParameter("ringList") == null ? "" : ((String)request.getParameter("ringList")).trim();
    String ringname = request.getParameter("ringLabel") == null ? "" : ((String)request.getParameter("ringLabel")).trim();
    Vector vetRing =  new Vector();
    vetRing = StrToVector(ringList);
    Vector vetName = StrToVector(ringname);
    manSysRing man = new manSysRing();
    HashMap logmap = new HashMap();
    ArrayList logList = new ArrayList();
    ArrayList reslist = null;
    boolean flag = false;
    if(operID!=null){
        String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
    
        if(!flag){
        Hashtable hash = null;
        Hashtable result = new Hashtable();
%>
<script language="javascript">
   var hei=450;
   if(parent.frames.length>0){

<%

	if(vetRing==null || vetRing.size()<=5 ){
%>
	hei = 500;
<%
	}else  {
%>
	hei = 500 + (<%= vetRing.size()%>-5)*40;

<%
	}
%>
	parent.document.all.main.style.height=hei;
	}
<%if(openprint.equalsIgnoreCase("1")){%>
function goPrint()
{
  var colURL = '../print.jsp?ringinfo=ringinfo';
  window.open(colURL,'Print','resizable=no,scrollbars=yes,width='+screen.width+', height='+screen.height+',top='+screen.top+',left='+screen.left);
}
<%}%>
</script>
<form name="inputForm" method="post" action="<%=url%>">
<input type="hidden" name="op" value="search" >
<input type="hidden" name="searchkey" value="<%= searchkey %>" >
<input type="hidden" name="searchvalue" value="<%= searchvalue %>" >
<input type="hidden" name="spindex" value="<%= spindex %>" >
<input type="hidden" name="sortby" value="<%= sortby %>" >
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="monthlyprice" value="<%= monthlyprice %>">
<input type="hidden" name="dailyprice" value="<%= dailyprice %>">
 <input type="hidden" value="<%= ringidtype %>" name="ringidtype">
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" height="200">
<tr>
   <td><img src="../image/pop013.gif" width="400" height="60"></td>
</tr>
<tr>
   <td><img src="../image/pop02.gif" width="400" height="26"></td>
</tr>
<tr>
   <td background="../image/pop03.gif" height="91">
   <table width="98%" cellspacing="1" cellpadding="2" border="0" class="table-style2" align="center">
   <tr>
       <td align="center" colspan=2  height=40>  <font class="font"><b><img src="../image/n-8.gif" width="8" height="8"> Result of Batch Ringtone Price Modify</b></font> </td>
   </tr>
   <tr>
        <td align="center" colspan=2>
        <table width="95%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
        <tr class="tr-ringlist">
        <td width="20%" align="center">Ringtone No.</td>
        <td width="40%" align="center" >Ringtone name</td>
        <td width="40%" align="center">The result of Modify</td>
        </tr>
        <%
         String ringid = "";
         ringAdm ringadm = null;
         String userringtype = "";
         Hashtable defaultRing =null;
         String defultID  = "";


         for(int i=0;i<vetRing.size()-1;i++){
            ringid = vetRing.get(i).toString();

           hash   = new Hashtable();
            hash.put("ringid",ringid);
            hash.put("ringfee",monthlyprice);
            hash.put("ringfee2",dailyprice);

            String  res = " successfully";
            try  {

                reslist = man.modifyRingPrice(hash);
                result = (Hashtable) reslist.get(0);
                if(!result.get("result").toString().equals("0")){
                    res = "Failure," + result.get("reason").toString();
                }
            }
            catch (Exception ex){
               res = "Failure," + ex.getMessage();
            }
            sysInfo.add(sysTime + operName + " order ringtone in manual plat for subscriber of" + monthlyprice + " " + ringid + res );
            String color = i == 0 ? "E6ECFF" :"#FFFFFF" ;
            out.print("<tr bgcolor='"+color+"'>");
            out.print("<td >"+ringid+"</td>");

            String tmpStr = vetName.get(i).toString();
            if(tmpStr.length()>20)
            	tmpStr = tmpStr.substring(0,20)+" "+tmpStr.substring(20,tmpStr.length());

            out.print("<td >"+tmpStr+"</td>");
            out.print("<td >" + res + "</td>");
            out.print("</tr>");
            logmap = new HashMap();
            logmap.put("reslist",reslist);
            logmap.put("operator",operName);
            logmap.put("ringid",ringid);
            logmap.put("ringlabel",tmpStr);
            logList.add(logmap);
        }
        man.writePriceLog(logList);
      %>

      </table>
      <tr>
      <td align="center" colspan=2>
          <img src="../button/back.gif" onmouseover="this.style.cursor='hand'" onclick="Javascript:submit()">
      </td>
      </tr>
    </table>
    </tr>
	    <tr>
      <td><img src="../image/pop04.gif" width="400" height="23"></td>
    </tr>
  </table>
  <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
    <tr>
      <td>&nbsp;</td>
  </tr>
</table>
</form>
<%
           }
%>

<%
        }
         else{
%>
<script language="javascript">
 	alert('Please log in first!');//请先登录
	document.location.href = 'enter.jsp';
</script>
<%
    }
   }
   catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime +  ",Exception occurred in batch modify ringtone price!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Errors occurred in batch modify ringtone price!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
                     if(url.toLowerCase().indexOf("manualsvc")==-1)

%>
</form>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="<%=url%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
 %>
</body>
</html>
