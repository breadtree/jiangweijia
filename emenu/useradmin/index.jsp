<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page language="java" contentType="text/html;charset=ISO8859_1" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>
<body class="body-style1" background="../manager/image/bac.gif">
<%
    String operID = (String)session.getAttribute("OPERID")==null?"":(String)session.getAttribute("OPERID");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
	String prefix = (String)application.getAttribute("PREFIXCONF")==null?"0":(String)application.getAttribute("PREFIXCONF");
	String ifattendant = (String)application.getAttribute("IFATTENDANT")==null?"0":(String)application.getAttribute("IFATTENDANT");
	String ringcatalog = (String)application.getAttribute("RINGCATALOG")==null?"0":(String)application.getAttribute("RINGCATALOG");
	String ifsetfee = (String)application.getAttribute("IFSETFEE")==null?"0":(String)application.getAttribute("IFSETFEE");
	String ifexperience = "0";

    String img_path = "intl/"+ getZteLocale(request)+"/"; //add by chenxi 2007-03-01
%>
<script language="javascript">
   function isshow(aa){
var menu="";
for (var i=1;i<=2;i++)
{

    menu = window.eval('window.content'+ i)
	if (menu.id==aa)
	{
		continue;
	}
        menu.style.display ='none';
}
	aa= window.eval('window.'+ aa)

	if (aa.style.display=='none')
    {
        aa.style.display="";
    }
	else
    {
        aa.style.display='none';
    }
}

   function refresh () {
      document.URL = 'menu.jsp';
   }
</script>
<form name="inputForm" method="get" action="">
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="182"><img src="../<%=img_path%>image/home_r1_c1.gif" width="182" height="102"></td>
    <td background="../../manager/image/home_r1_cm.gif" width="576"><img src="../image/useradmin.gif" width="576" height="102"></td>
  </tr>
</table>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td background="../manager/image/home_r2_c1.gif" width="8"><img src="../manager/image/home_r2_c1.gif" width="8" height="38"></td>
    <td valign="top" width="170" background="../manager/image/home_r10_c2bg.gif">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
          <td background="../manager/image/ab.gif" height="24" valign="bottom">
            <div align="left">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2" onClick="<%= operID.length()==0?"":"javascript:isshow('content1')" %>" onMouseOver="this.style.cursor='hand'">
                <tr>
                  <td width="20">&nbsp;</td>
                  <td height="20" valign="bottom"><font class="font-man"><b><%= colorName %>System of log in/out</b></font>
                  </td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
              <table id='content1' width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" background="../manager/image/home_r6_c2.gif" style="DISPLAY:none">
				<tr>
                  <td width="100%"><img src="../manager/image/ac.gif" width="170" height="14"></td>
                </tr>
                 <tr>
                    <td width="100%" ><img src="../manager/folder/line.gif"><img src="../manager/folder/midblk.gif"><img src="../manager/image/n-8.gif" width="8" height="8" border="0"><a href="cardUse.jsp" target="main"><font class="font"><%= colorName%>Open an account</font></a></td>
                </tr>
               <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/midblk.gif"><img src="../manager/image/n-8.gif" width="8" height="8" border="0"><a href="cardErase.jsp" target="main"><font class="font"><%= colorName%>Destroy an account</font></a></td>
                </tr>
				<tr>
                  <td width="100%"><img src="../manager/image/ad.gif" width="170" height="7"></td>
                </tr>
         </table>
              <img src="../manager/image/ae.gif" width="170" height="13"></div>
          </td>
        </tr>
      </table>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr>
          <td background="../manager/image/ab.gif" height="24" valign="bottom">
            <div align="left">
              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style2" onClick="<%= operID.length()==0?"":"javascript:isshow('content2')" %>" onMouseOver="this.style.cursor='hand'">
                <tr>
                  <td width="20">&nbsp;</td>
                  <td height="20" valign="bottom"><font class="font-man"><b><%= colorName %>Manage operator</b></font>
                  </td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
        <tr>
          <td>
            <div align="center">
              <table id='content2' width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" background="../manager/image/home_r6_c2.gif" style="DISPLAY:none">

				<tr>
                  <td width="100%"><img src="../manager/image/ac.gif" width="170" height="14"></td>
                </tr>
                 <tr>
                    <td width="100%" ><img src="../manager/folder/line.gif"><img src="../manager/folder/midblk.gif"><img src="../manager/image/n-8.gif" width="8" height="8" border="0"><a href="operPwdChange.jsp" target="main"><font class="font">Modify password</font></a></td>
                </tr>
               <tr>
                  <td width="100%"><img src="../manager/folder/line.gif"><img src="../manager/folder/midblk.gif"><img src="../manager/image/n-8.gif" width="8" height="8" border="0"><a href="../manager/purview/operLog.jsp?operflag=3" target="main"><font class="font">Search log</font></a></td>
                </tr>
				<tr>
                  <td width="100%"><img src="../manager/image/ad.gif" width="170" height="7"></td>
                </tr>
         </table>
              <img src="../manager/image/ae.gif" width="170" height="13"></div>
          </td>
        </tr>
      </table>
     <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
        <tr>
          <td><img src="../manager/image/home_r10_c2bg.gif" width="170" height="8"></td>
        </tr>
      </table>

      <table width="165" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
        <tr>
          <td width="28"><img src="../manager/image/home_r14_c3.gif" width="28" height="31"></td>
          <td background="../manager/image/home_r14_c5bg.gif">
            <div align="center"><a href="<%= operID.length() == 0 ? "enter" : "logout" %>.jsp" target="main"><font class="font-man"><b><%= operID.length() == 0 ? "" : "Exit" %>Log in</b></font></a></div>
          </td>
          <td width="12"><img src="../manager/image/home_r14_c5.gif" width="12" height="31"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="5">
        <tr>
          <td><img src="../manager/image/home_r10_c2bg.gif" width="170" height="8"></td>
        </tr>
      </table>
      <p>&nbsp;</p>
    </td>
    <td width="11" valign="top" background="../manager/image/home_r4_c3bg.gif"><img src="../manager/image/home_r2_c3.gif" width="11" height="28"></td>
    <td bgcolor="#FFFFFF" valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../manager/image/home_r2_c5.gif" width="551" height="19"></td>
        </tr>
      </table>
      <iframe height="600" width="551" scrolling=no frameborder=0 src='<%= operID.length()==0?"enter.jsp":"../intro.html" %>' name="main"></iframe>
    </td>
    <td valign="top" background="../manager/image/home_r5_c6bg.gif" width="9"><img src="../manager/image/home_r2_c6.gif" width="9" height="31"></td>
    <td valign="top" background="../manager/image/home_r2_c7.gif" width="9"><img src="../manager/image/home_r2_c7.gif" width="9" height="31"></td>
  </tr>
</table>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td><img src="../manager/image/home_r16_c1.gif" width="758" height="17"></td>
  </tr>
</table>
<table width="758" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td><img src="../manager/image/home_r19_c1.gif" width="758" height="17"></td>
  </tr>
</table>
</form>
</body>
</html>
