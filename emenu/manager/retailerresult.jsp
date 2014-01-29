<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.JspUtil" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
   public String transferString(String str) throws Exception {
     return str;
    }
%>
<%
//request.setCharacterEncoding("gbk");
   String url = request.getParameter("historyURL") == null ? "" : (String)request.getParameter("historyURL");
   url = JspUtil.getParameter(url);
   String title = request.getParameter("title") == null ? "" : transferString((String)request.getParameter("title"));
   ArrayList rList = (ArrayList)session.getAttribute("rList");
   Hashtable hash = new Hashtable();
   String op = request.getParameter("op") == null ? "" : transferString((String) request.getParameter("op")).trim();
   String optype = request.getParameter("optype") == null ? "" : transferString((String)request.getParameter("optype"));


    if(op.equals("saveasfile"))
	  {
        response.reset();
        response.setContentType("text/plain");
    	response.setHeader("Content-Disposition","attachment; filename=\"account_result.txt\"");
        List arra=(ArrayList)session.getAttribute("rList");
		String dump="";
        Map tmap=null;
    	   for(int k=0;k<arra.size();k++)
		{
		 dump="";
          tmap=(Hashtable)arra.get(k);
         String sResult = (String)tmap.get("result");
		 if(sResult.equals("0")) 
			{
              sResult = "Succsess";
			}
			else
			{
              sResult = "Failure";
			}
			if(k!=0)
			{
		  out.println((String)tmap.get("scp")+",     "+tmap.get("acctnum").toString()+",           "+sResult+",    "+(String)tmap.get("reason"));
              dump=(String)tmap.get("scp")+",     "+tmap.get("acctnum").toString()+",           "+sResult+",    "+(String)tmap.get("reason")+"\n";
	    }
			else
			{
			  out.println("SCP    Subscriber Number        Result     Reason          ");
			  out.println((String)tmap.get("scp")+",     "+tmap.get("acctnum").toString()+",           "+sResult+",    "+(String)tmap.get("reason"));
			  dump="SCP    Subscriber Number        Result     Reason          \n";
              dump+=(String)tmap.get("scp")+",     "+tmap.get("acctnum").toString()+",           "+sResult+",    "+(String)tmap.get("reason")+"\n";
			}
        byte requestBytes[] = dump.getBytes();
          ByteArrayInputStream bis = new ByteArrayInputStream(requestBytes);
          byte[] buf = new byte[1024];
          int len;
          while ((len = bis.read(buf)) > 0){
          response.getOutputStream().write(buf, 0, len);
          }
          bis.close();
         
	}
	response.getOutputStream().flush(); 
        return;
      }
%>
<html>
<head>
<title>Operation result</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<script>
function saveasfile()
{
  document.inputForm.target="_parent";
  document.inputForm.op.value="saveasfile";
  document.inputForm.submit();
}
function f_return()
{
  window.location.href="retailerlist.jsp";
}
</script>
<form name="inputForm" method="post" action="retailerresult.jsp">
<input type="hidden" name="op" value="">
<body topmargin="0" leftmargin="0" class="body-style1">
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" >
  <tr>
    <td width="100%"><img src="../image/pop013.gif" width="400" height="60"></td>
  </tr>
  <tr>
    <td><img src="../image/pop02.gif" width="400" height="26"></td>
  </tr>
  <tr>
    <td height=40  align=center background="../image/pop03.gif" class="font-man" ><B><%= title  %></B></td>
  </tr>
  <tr>
    <td background="../image/pop03.gif"  width="80%" > <div align="center">
        <table width="80%" cellspacing="1" cellpadding="2" border="1" class="table-style2" align="center">
		<tr>
		<td align=center width="10%">SCP</td>
		<td align=center width="20%">UserNumber</td>
		<td align=center width="20%">Operation result </td>
        <td align=center width="50%">Failure cause </td>
        </tr>
		 <%
           for (int i = 0; i < rList.size(); i++) {
		     hash = (Hashtable)rList.get(i);
		     %>
		    <tr>
			<td align="center" width="10%" > <%= (String)hash.get("scp") %> </td>
			<td align="center" width="20%" > <%= (String)hash.get("acctnum") %> </td>
			<td align="center" width="20%" > <%= ((String)hash.get("result")).equals("0")?"Success":"Failure" %> </td>
			<td width="50%" >&nbsp; <%= (String)hash.get("reason") %> </td>
		    </tr>
		<%
		   }

         %>
		<tr>
        <td colspan="4" align="center">
		   <%
		  if(optype.equals("4"))
			{
			%>
            <input type="button" name="saveas" value="Save as file" onclick="saveasfile()">
			<%
			}
			%>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" value="Back" onclick="f_return()">
        </td>
         </tr>
        </table>
	    </div>
	  </td>
     </tr>
   <tr>
    <td><img src="../image/pop04.gif" width="400" height="23"></td>
  </tr>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
    <td>&nbsp; </td>
  </tr>
  <tr>
    <td>&nbsp; </td>
  </tr>
</table>
</body>
</form>
</html>
