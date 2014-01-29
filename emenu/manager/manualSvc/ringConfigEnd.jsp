<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.manSysPara" %>

<%
    response.addHeader("Cache-Control", "no-cache");

    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Personal setting</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String sysTime = "";
     String craccount ="";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
    try {
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    craccount = request.getParameter("craccount") == null ? "" : ((String)request.getParameter("craccount")).trim();
    if(ringdisplay.equals(""))  ringdisplay = "ringtone";
        sysTime = userAdm.getSysTime() + "--";
        userAdm useradm = new userAdm();
         if (operID != null && purviewList.get("13-14") != null){
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
            manSysPara msp = new manSysPara();
            if(!msp.isAdUser(craccount)){
            zxyw50.Purview purview = new zxyw50.Purview();
            if(!purview.CheckOperatorRight(session,"13-14",craccount)){
            	throw new Exception("You have no right to manage this subsciber!");
            }

            if(op.equals("set")){
                hash.put("phone",craccount);
                	String ifringcopy = request.getParameter("ifringcopy") == null ? "0" : (String)request.getParameter("ifringcopy");

                	String lockid_sub0 = request.getParameter("lockid_sub0") == null ? "0" : (String)request.getParameter("lockid_sub0");
                	String lockid_sub1 = request.getParameter("lockid_sub1") == null ? "0" : (String)request.getParameter("lockid_sub1");
                	String lockid_sub2 = request.getParameter("lockid_sub2") == null ? "0" : (String)request.getParameter("lockid_sub2");
                    String lockid_sub4 = request.getParameter("lockid_sub4") == null ? "0" : (String)request.getParameter("lockid_sub4");
                	String ringplaymode_sub0 = request.getParameter("ringplaymode_sub0") == null ? "" : (String)request.getParameter("ringplaymode_sub0");
                	String ringplaymode_sub1 = request.getParameter("ringplaymode_sub1") == null ? "" : (String)request.getParameter("ringplaymode_sub1");
                	String ringplaymode_sub2 = request.getParameter("ringplaymode_sub2") == null ? "" : (String)request.getParameter("ringplaymode_sub2");
                    String ringplaymode_sub4 = request.getParameter("ringplaymode_sub4") == null ? "" : (String)request.getParameter("ringplaymode_sub4");
                	String ringgrpplaymode_sub0 = request.getParameter("ringgrpplaymode_sub0") == null ? "" : (String)request.getParameter("ringgrpplaymode_sub0");
                	String ringgrpplaymode_sub1 = request.getParameter("ringgrpplaymode_sub1") == null ? "" : (String)request.getParameter("ringgrpplaymode_sub1");
                	String ringgrpplaymode_sub2 = request.getParameter("ringgrpplaymode_sub2") == null ? "" : (String)request.getParameter("ringgrpplaymode_sub2");
                	String ringgrpplaymode_sub4 = request.getParameter("ringgrpplaymode_sub4") == null ? "" : (String)request.getParameter("ringgrpplaymode_sub4");


                	hash.put("ifringcopy",ifringcopy);
                	String strDesc = "";
                	if(!"".equals(ringplaymode_sub0))
                	{
                		hash.put("lockid_sub0",         lockid_sub0);
                		hash.put("ringplaymode_sub0",   ringplaymode_sub0);
                		hash.put("ringgrpplaymode_sub0",ringgrpplaymode_sub0);
                		strDesc += " Modify the called party setting ";
                	}
                	if(!"".equals(ringplaymode_sub1))
                	{
                		hash.put("lockid_sub1",         lockid_sub1);
                		hash.put("ringplaymode_sub1",   ringplaymode_sub1);
                		hash.put("ringgrpplaymode_sub1",ringgrpplaymode_sub1);
                		strDesc += " Modify the calling party setting ";
                	}
                	if(!"".equals(ringplaymode_sub2))
                	{
                		hash.put("lockid_sub2",         lockid_sub2);
                		hash.put("ringplaymode_sub2",   ringplaymode_sub2);
                		hash.put("ringgrpplaymode_sub2",ringgrpplaymode_sub2);
                		strDesc += " Modify the group setting ";
                	}
                    if(!"".equals(ringplaymode_sub4))
                	{
                		hash.put("lockid_sub4",         lockid_sub4);
                		hash.put("ringplaymode_sub4",   ringplaymode_sub4);
                		hash.put("ringgrpplaymode_sub4",ringgrpplaymode_sub4);
                		strDesc += " Modify the image setting ";
                	}

                useradm.setUserSetting(hash);


                HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","514");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            		map.put("PARA2",ifringcopy);
            		map.put("PARA3",strDesc);
            		map.put("PARA4","");
            sysInfo.add(sysTime + operName + " modify the subscriber " + craccount + "\'s personal setting successfully!" );
            map.put("DESCRIPTION","edit"+" ip:"+request.getRemoteAddr() );
            purview.writeLog(map);

                %>
                <script language="JavaScript">
	              alert('Edit personal setting successfully!');
                </script>
<%
            }
            hash = useradm.getUserSetting(craccount);

%>
<script language="javascript">
    function setConfig () {
      var fm = document.inputForm;
      fm.op.value = 'set';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>

<form name="inputForm" method="post" action="ringConfigEnd.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="craccount" value="<%= craccount %>">
<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
 <tr >
      <td height="26"  align="center" class="text-title" background="../image/n-9.gif"><%= craccount %>--Personal setting</td>
</tr>
 <tr >
     <td height="10"  align="center" class="text-title" >&nbsp;</td>
</tr>
<tr>
     <td valign="top" bgcolor="#FFFFFF">
              <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
              <tr valign="top" align="center" >
                <td >
                    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="table-style3">
                    <tr>
                      <td align="right" width="45%"><%=  colorName  %>Subscriber number</td>
                      <td  width="55%"><%= craccount %></td>
                    </tr>

                    <tr>
                      <td align="right">Allow to copy ringtone?</td>
                      <td>
                        <select   style="width: 117" size="1" name="ifringcopy"   >
                          <option  value="1"
                              <% if(((String)hash.get("ifringcopy")).equals("1"))
                                     out.print("selected"); %>
                          >No</option>
                          <option value="0" <% if(((String)hash.get("ifringcopy")).equals("0"))
                          out.print("selected"); %> >Yes</option>
                        </select>
                      </td>
                    </tr>

<%
         String ringplaymode    = (String)hash.get("ringplaymode_sub0");
         String ringgrpplaymode = (String)hash.get("ringgrpplaymode_sub0");
         String lockid_sub      = (String)hash.get("lockid_sub0");

  			if((ringplaymode!=null) && !"".equals(ringplaymode))
  			{

%>
<%--
		  <tr>
          	<td height="22" align="right">Called <%=ringdisplay%> status</td>
          	<td height="22">
          		<select  name="lockid_sub0" class="input-style1" readonly >
						<option value="0" <%="0".equals("lockid_sub")?" selected ":""%>>Normal</option>
						<option value="1" <%="1".equals("lockid_sub")?" selected ":""%>>Suspended</option>
		   		</select>
		   	</td>
        </tr>
--%>
                    <tr>
          	<td height="22" align="right">Called <%=ringdisplay%> play mode</td>
          	<td height="22">
          		<select  name="ringplaymode_sub0" class="input-style1" >
						<option value="1" <%="1".equals(ringplaymode)?" selected ":""%>>Default Only</option>
						<option value="2" <%="2".equals(ringplaymode)?" selected ":""%>>Randomly</option>
						<%--<option value="3" <%="3".equals(ringplaymode)?" selected ":""%>>Day random</option>--%>
		   		</select>
		   	</td>
        </tr>
        <tr>
          	<td height="22" align="right">Called <%=ringdisplay%> group play mode</td>
          	<td height="22">
          		<select  name="ringgrpplaymode_sub0" class="input-style1" >
						<option value="1" <%="1".equals(ringgrpplaymode)?" selected ":""%>>In order</option>
						<option value="2" <%="2".equals(ringgrpplaymode)?" selected ":""%>>Randomly</option>
		   		</select>
		   	</td>
        </tr>

<%		}
%>

<%
         ringplaymode    = (String)hash.get("ringplaymode_sub1");
         ringgrpplaymode = (String)hash.get("ringgrpplaymode_sub1");
      	lockid_sub      = (String)hash.get("lockid_sub1");
  			if((ringplaymode!=null) && !"".equals(ringplaymode))
  			{

%>
<%--
                    <tr>
          	<td height="22" align="right">Calling <%=ringdisplay%> status</td>
          	<td height="22">
          		<select  name="lockid_sub0" class="input-style1" >
						<option value="0" <%="0".equals("lockid_sub")?" selected ":""%>>Normal</option>
						<option value="1" <%="1".equals("lockid_sub")?" selected ":""%>>Suspended</option>
                        </select>
                      </td>
                    </tr>
--%>
                    <tr>
          	<td height="22" align="right">Calling <%=ringdisplay%> play mode</td>
          	<td height="22">
          		<select  name="ringplaymode_sub1" class="input-style1" >
						<option value="1" <%="1".equals(ringplaymode)?" selected ":""%>>Default Only</option>
						<option value="2" <%="2".equals(ringplaymode)?" selected ":""%>>Randomly</option>
						<%--<option value="3" <%="3".equals(ringplaymode)?" selected ":""%>>Daily Randomly</option>--%>
                        </select>
                      </td>
                    </tr>
                    <tr>
          	<td height="22" align="right">Calling <%=ringdisplay%> group play mode</td>
          	<td height="22">
          		<select  name="ringgrpplaymode_sub1" class="input-style1" >
						<option value="1" <%="1".equals(ringgrpplaymode)?" selected ":""%>>In order</option>
						<option value="2" <%="2".equals(ringgrpplaymode)?" selected ":""%>>Randomly</option>
		   		</select>
		   	</td>
        </tr>

<%		}
%>

<%
         ringplaymode    = (String)hash.get("ringplaymode_sub4");
         ringgrpplaymode = (String)hash.get("ringgrpplaymode_sub4");
      	lockid_sub      = (String)hash.get("lockid_sub4");
  			if((ringplaymode!=null) && !"".equals(ringplaymode))
  			{

%>
                    <tr>
          	<td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("colorphotoname","Color Photo Show")%> play mode</td>
          	<td height="22">
          		<select  name="ringplaymode_sub4" class="input-style1" >
						<option value="1" <%="1".equals(ringplaymode)?" selected ":""%>>Default Only</option>
						<option value="2" <%="2".equals(ringplaymode)?" selected ":""%>>Randomly</option>
						<%--<option value="3" <%="3".equals(ringplaymode)?" selected ":""%>>Daily Randomly</option>--%>
                        </select>
                      </td>
                    </tr>
                    <tr>
          	<td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("colorphotoname","Color Photo Show")%> group play mode</td>
          	<td height="22">
          		<select  name="ringgrpplaymode_sub4" class="input-style1" >
						<option value="1" <%="1".equals(ringgrpplaymode)?" selected ":""%>>In order</option>
						<option value="2" <%="2".equals(ringgrpplaymode)?" selected ":""%>>Randomly</option>
		   		</select>
		   	</td>
        </tr>

<%		}
%>


                      <td colspan="2"> <table border="0" width="100%" class="table-style2">
                          <tr>
                            <td width="55%" align="right"><img src="../../button/change.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:setConfig()">&nbsp;&nbsp;</td>
                            <td width="45%" >&nbsp;&nbsp;<img src="../../button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
                          </tr>
                        </table>
                    </td>
              </tr>
                <tr valign="top">
                  <td width="100%" colspan=2 > <table width="100%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
                      <tr>
                        <td class="table-styleshow" background="../image/n-9.gif" height="26">
                          Help information:</td>
                      </tr>

                      <tr>
                        <td>1.The option of "Allow to copy ringtone"'s function is decide subscriber's <%=  ringdisplay  %> can copy by other subscriber;</td>
                      </tr>
                      <tr>
                  		<td>2.The option of '<%=  ringdisplay  %> play mode''s function is set <%=  ringdisplay  %> play mode.</td>
                      </tr>
                      <tr>
                  		<td>3.The option of "<%=  ringdisplay  %> group play mode"'s function is set <%=  ringdisplay  %> play mode in the <%=  ringdisplay  %> group.</td>
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
        </table>
        <p>&nbsp;</p></td>
    </tr>
  </table>
  </form>
<%

         }else{
%>
           <script language="javascript">
                   var str = 'Sorry! the number ' +<%= craccount %>+' you entered is ad subscriber,can not use the system!';
                   alert(str);
                   document.URL = 'ringConfig.jsp';
             </script>
<%
        }
        }
        else {
            if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in first!");
                    document.URL = '../enter.jsp';
              </script>
            <%
             }
             else{
             %>
                  <script language="javascript">
                       alert( "Sorry,you have no right to access this function!");
                  </script>
                <%

            }
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount + " Exception occurred in setting personal "  +   ringdisplay);
        sysInfo.add(e.toString());
        vet.add("Personal "  +   ringdisplay + " errors occurred in setting personal ringtone");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/ringConfig.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

