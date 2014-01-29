<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.ringAdm" %>
<%@ page import="zxyw50.group.dataobj.*" %>
<%@ page import="zxyw50.group.context.*" %>
<%@ page import="zxyw50.group.util.*" %>
<%@ page import="zxyw50.SocketPortocol" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Set group guidance ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String sysTime = "";
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
     //change by wxq 2005.06.14 for version 3.16.01
    String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
    String groupindex,groupid;
    if (mode.equals("manager")){
        groupindex = request.getParameter("groupindex") == null ? "" : request.getParameter("groupindex");
        groupid = request.getParameter("groupid") == null ? "" : request.getParameter("groupid");
    }else{
        groupindex = (String)session.getAttribute("GROUPINDEX");
        groupid = (String)session.getAttribute("GROUPID");
    }
    //end
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String allowUp = (String)application.getAttribute("ALLOWUP")==null?"0":(String)application.getAttribute("ALLOWUP");
	boolean flagm = (Integer.parseInt(allowUp) == 1)?true:false;
	String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
	if(ringdisplay.equals(""))  ringdisplay = "Ringtone";
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String crid = StringUtil.isEmpty(request.getParameter("crid"))? "" : (String)request.getParameter("crid");
        String starttime = request.getParameter("starttime") == null ? "" : (String)request.getParameter("starttime");
        String endtime = request.getParameter("endtime") == null ? "" : (String)request.getParameter("endtime");
        String oldprering=StringUtil.isEmpty(request.getParameter("oldprering"))? "" : (String)request.getParameter("oldprering");
      String errMsg = "";
      boolean blexist = false;
	if (purviewList.get("12-3") == null||(!Resource.getInstance().getConfig("grpprering","0").trim().equals("1")))  {
	  //如果mode的值为manager,表明是管理员进入,并且已经通过了审核,允许进入
            if (mode.equals("manager")){
                blexist = false;
            }
            else{
                errMsg = "You have no access to this function!";
                blexist = true;
        }
}
        if (!blexist&&groupid != null) {
            Group grp = new Group();
            grp.setGroupIndex(groupindex);
            grp.setGroupId(groupid);
            // 如果是修改默认铃声
            if (op.equals("0")) {
                RingDescInfo ring = new RingDescInfo();
                ring.setRingid(crid);
                int action = 0;
                if(oldprering.trim().equals("")){//no old
                	if(crid.trim().equals("")){//do nothing
                	}else{
                            action = 1;
                	}
                }else{
                	if(crid.trim().equals("")){//do nothing
                		ring.setRingid(oldprering);
                                action = 2;
                	}else{
                            action = 3;
                	}
                }
                if(action!=0){
	                grp.getGroupContext().modifyGroupPreRings(new RingDescInfo[]{ring},action);
                        oldprering=ring.getRingid();
                }
%>
<script language="JavaScript">
	alert('The group guidance ringtone is set successfully!');
</script>
<%
           sysInfo.add(sysTime + groupid + " succeeded in modifying the group guidance tone!");
	       zxyw50.Purview purview = new zxyw50.Purview();
           HashMap map = new HashMap();
           map.put("OPERID",operID);
           map.put("OPERNAME",operName);
           map.put("OPERTYPE","2002");
           map.put("RESULT","1");
           map.put("PARA1",crid);
           map.put("PARA2","ip:"+request.getRemoteAddr());
           purview.writeLog(map);
            }
            else
                op = "0";
            // 查询前导音
            grp.getGroupContext().loadGroupRingLibrary();
            grp.getGroupContext().loadGroupPreRings();
            RingDescInfo[] rings = grp.getRingLibrary();
            if(rings==null)
            	rings = new RingDescInfo[0]  ;
            RingDescInfo[] pres = grp.getPreRings();
            String currentpre = "";
            if(pres!=null&&pres.length>0)
            	currentpre = pres[0].getRingid();
            oldprering=currentpre;
            String  strOption = "<option value=''  >Do not set the group guidance tone temporarily</option>" ;
            if(currentpre.equals(""))
            	strOption = "<option value='' selected >Do not set the group guidance tone temporarily</option>" ;
	    String defultID = currentpre;
            for (int i = 0; i < rings.length; i++) {
               String crid11 = rings[i].getRingid();
               if(currentpre.equals(crid11)){
                  strOption  = strOption + "<option value="+ crid11 + " selected >" + rings[i].getFileName() +"</option>";
               }
               else
                 strOption  = strOption + "<option value="+ crid11 + " >" + rings[i].getFileName() +"</option>";
           }

%>

<script language="javascript">
   var v_ringlabel = new Array(<%= rings.length + "" %>);
   var v_ringauthor = new Array(<%= rings.length + "" %>);
   var v_mediatype = new Array(<%= rings.length + "" %>);
<%
            for (int i = 0; i < rings.length; i++) {
%>
   v_ringlabel[<%= i + "" %>] = '<%= rings[i].getFileName() %>';
   v_ringauthor[<%= i + "" %>] = '<%= "" %>';
   v_mediatype[<%= i + "" %>] = '<%= rings[i].getMediatype() %>';
<%
            }
%>

   var   ringdisplay = "<%=  ringdisplay  %>";
      // 删除字符串的左边空格
   function leftTrim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = str;
      var i = 0;
      for (i = 0; i < str.length; i++) {
         if (tmp.substring(0,1) == ' ')
            tmp = tmp.substring(1,tmp.length);
         else
            return tmp;
      }
   }

   // 删除字符串的右边空格
   function rightTrim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = str;
      var i = 0;
      for (i = str.length - 1; i >= 0; i--) {
         if (tmp.substring(tmp.length - 1,tmp.length) == ' ')
            tmp = tmp.substring(0,tmp.length - 1);
         else
            return tmp;
      }
   }

   // 删除字符串的两边空格
   function trim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = leftTrim(str);
      return rightTrim(tmp);
   }


   function doSure() {
      fm = document.inputForm;
      if(fm.defultID.value ==fm.crid.value){
         alert('Select the new guidance tone, and then set the guidance ringtone!');
         return;
      }
      fm.submit();
   }
   function tryListen () {
      fm = document.inputForm;
      var index  = fm.crid.selectedIndex-1;
      if (trim(fm.crid.value) == '') {
         alert('Please choose '+ringdisplay+' first,then listen.');
         return ;
      }
      var tryURL = '../manager/tryListen.jsp?ringid=' + fm.crid.value+'&ringname='+v_ringlabel[index]+'&ringauthor='+v_ringauthor[index] + '&usernumber=&mediatype='+v_mediatype[index];
      if(trim(v_mediatype[index])=='1'){
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(v_mediatype[index])=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(v_mediatype[index])=='4'){
        tryURL = '../tryView.jsp?ringid=' + fm.crid.value+'&ringname='+v_ringlabel[index]+'&ringauthor='+v_ringauthor[index] + "'&usernumber=&mediatype="+v_mediatype[index];
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }
   }
</script>
<form name="inputForm" method="post" action="preRing.jsp">
<input type="hidden" name="op" value="<%= op %>">
<input type="hidden" name="oldprering" value="<%= oldprering %>">
<input type="hidden" name="defultID" value="<%= defultID %>" >
 <!--change by wxq 2005.06.16-->
<input type="hidden" name="mode" value="<%= mode %>"/>
<input type="hidden" name="groupid" value="<%= groupid %>"/>
<input type="hidden" name="groupindex" value="<%= groupindex %>"/>
<!--end-->
 <table width="551" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td valign="top" bgcolor="#FFFFFF">
              <table width="95%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
                <tr>
                  <td width="28"><img src="../image/home_r14_c3.gif" width="28" height="31"></td>
                  <td background="../image/home_r14_c5bg.gif"><font color="#006600"><b></b>
                    <b><font class="font"> Set the group guidance ringtone</font></b></font></td>
                  <td width="12"><img src="../image/home_r14_c5.gif" width="12" height="31"></td>
                </tr>
              </table>
              <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
                <tr valign="top">
                  <td width="100%" align="center"><table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="table-style3">
                        <td align="right" width="30%">group guidance ringtone&nbsp;</td>
                        <td> <select name="crid" class="select-style3" style="width:300px" >
                            <%  out.print(strOption); %>
                          </select> </td>
                      </tr>

                      <tr>
                        <td colspan="2" align="center"> <table border="0" align="center" width="100%" class="table-style2">
                            <tr>
                              <td align="right"><img src="../manager/button/sure.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:doSure()">&nbsp;&nbsp;</td>
                              <td>&nbsp;&nbsp;<img src="../manager/button/trylisten.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:tryListen()"></td>
                            </tr>
                          </table></td>
                    </table> </td>
                </tr>
                <tr valign="top">
                  <td width="100%"><table width="100%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
                      <tr>
                        <td class="table-styleshow" background="../image/n-9.gif" height="26">
                          Help information:</td>
                      </tr>

                      <tr>
                        <td>1.  After the setting of group guidance tone, play the guidance tone for all group members before the incoming calls, then, play the ringtone of the time period.</td>
                      </tr>
                      <tr>

                 <td>2.  The system does not set the group guidance tone before the provision of group services <%= colorName%>;</td>
                      </tr>
                      <tr>

                  <td>3.  You can select any one <%=ringdisplay%> from the group <%=ringdisplay%> library as the group guidance tone;</td>
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
        }
        else {
%>
<script language="javascript">
   var errorMsg = '<%= groupid!=null?errMsg:"Please log in to the system first!"%>';
	alert(errorMsg);
	parent.document.location.href = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + groupid + " is abnormal during the setting of the group guidance tone!");
        sysInfo.add(e.toString());
        vet.add("Error occurs during the setting of the group guidance tone!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="preRing.jsp?mode=<%=mode%>&amp;groupid=<%=groupid%>&amp;groupindex=<%=groupindex%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

