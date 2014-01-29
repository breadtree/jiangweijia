<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
     public String display (Map map) throws Exception {
        try {
            String str = (String)map.get("rsubindex");
            for (; str.length() < 6; )
                str += "-";
            return str + (String)map.get("ringid");
        }
        catch (Exception e) {
            throw new Exception ("Incorrect data obtained!");//Obtain incorrect data
        }
    }
%>
<html>
<head>
<title>Manage latest recommended ringtones</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        ColorRing  colorring = new ColorRing();
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-50") != null) {
        //if (operID != null ) {
            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            HashMap map1= new HashMap();
            Map hash = null;
			Map hashDay = null;
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String oldrsubindex = request.getParameter("oldrsubindex") == null ? "" : transferString((String)request.getParameter("oldrsubindex")).trim();
            String oldringid = request.getParameter("oldringid") == null ? "" : transferString((String)request.getParameter("oldringid")).trim();
			String ringID = "";
			String ringLabel = "";
			String ringSubIndex = "";
            int optype = 0;

            String title = "";
            if (op.equals("add")){
                optype = 1;
                title = "Add recommended ringtone";
            }
            else if (op.equals("del")) {
                optype = 2;
                title = "Delete recommended ringtone";
            }
            else if (op.equals("edit")) {
                optype = 3;
                title = "Modify recommended ringtone";
            }

            if(optype>0){

               map1.put("optype",optype+"");
               map1.put("ringid",oldringid);
               map1.put("rsubindex",oldrsubindex);
	           map1.put("boardtype","156");
               rList = sysring.setRecommend(map1);

               if(getResultFlag(rList)){
                  zxyw50.Purview purview = new zxyw50.Purview();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","209");
                  map.put("RESULT","1");
                  map.put("PARA1",oldringid);
                  map.put("PARA2",oldrsubindex);
                  map.put("PARA3","ip:"+request.getRemoteAddr());
                  map.put("DESCRIPTION",title);
                  purview.writeLog(map);
               }

               if(rList.size()>0) {
                 session.setAttribute("rList",rList);
                 %>
				 <form name="resultForm" method="post" action="result.jsp">
				 <input type="hidden" name="historyURL" value="ivrDayRecommendRing.jsp">
				 <input type="hidden" name="title" value="<%= title %>">
				 <script language="javascript">
				   document.resultForm.submit();
				 </script>
				 </form>
                 <%
               }

            }
            List vet = null;
            vet = sysring.ringSortBoard(156);
			if(vet.size()>0) {
			    hashDay = (Map) vet.get(0);
                ringID = (String)hashDay.get("ringid");
			    ringLabel = (String)hashDay.get("ringlabel");
			    ringSubIndex = (String)hashDay.get("rsubindex");
			}
 %>
<script language="javascript">

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.ringid.value);
      if(value==''){
         alert("Please enter the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code!");//请输入Ringtone code
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code must be a digital number!');//Ringtone code必须是数字
         fm.ringid.focus();
         return flag;
      }
      var value = trim(fm.rsubindex.value);
      if(value==''){
         alert("Please enter the serial number of a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>!");//请输入铃音序号
         fm.rsubindex.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> No. must be a digital number!');//铃音序号必须是数字
         fm.rsubindex.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function addInfo () {
       window.open('ivrDayRecommendRingAdd.jsp','ivrDayRecommendRingAdd','width=400, height=280,top='+((screen.height-280)/2)+',left='+((screen.width-400)/2));
   }

   function editInfo () {
      var fm = document.inputForm;
      var editURL = 'ivrDayRecommendRingMod.jsp?ringid=' +fm.ringid.value +'&ringlabel='+fm.ringlabel.value + '&rsubindex='+fm.oldrsubindex.value;
      window.open(editURL,'ivrDayRecommendRingEdit','width=400, height=300,top='+((screen.height-300)/2)+',left='+((screen.width-400)/2));
   }

   function delInfo () {
      var fm = document.inputForm;
      fm.op.value = 'del';
      fm.submit();
   }

   function getAddInfo (ringid,subindex) {
     var fm = document.inputForm;
     fm.oldrsubindex.value = subindex;
     fm.oldringid.value = ringid;
     fm.op.value = 'add';
     fm.submit();
   }

   function getEditInfo (ringid,subindex) {
     var fm = document.inputForm;
     fm.oldrsubindex.value = subindex;
     fm.oldringid.value = ringid;
     fm.op.value = 'edit';
     fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="ivrDayRecommendRing.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldrsubindex" value="<%= ringSubIndex %>">
<input type="hidden" name="oldringid" value="<%= ringID %>">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
        <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">IVR Day Recommendation <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
        </tr>
		<tr>
		    <% if( vet.size() == 0 ) { %>
                <td align="center"> No IVR Day Recommendation is set </td>
	        <% } else { %>
                <td height='100%'>
                    <table width="100%" border =0 class="table-style2" height='100%'>
                    <tr>
                        <td width="30%" align=right ><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
                        <td><input type="text" name="ringlabel" value="<%= ringLabel %>" maxlength="6" class="input-style1"  disabled ></td>
                    </tr>
                    <tr>
                        <td width="30%" align=right><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
                        <td><input type="text" name="ringid" value="<%= ringID %>" maxlength="20" class="input-style1" disabled ></td>
                    </tr>
                    </table>
                </td>
	        <% } %>
       </tr>
       <tr>
           <td colspan="2" align="center">
               <table border="0" width="100%" class="table-style2"  align="center">
                   <tr>
				       <% if(vet.size() == 0) { %>
                              <td width="25%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'"  onclick="javascript:addInfo()"></td>
					   <% } else { %>
                              <td width="25%" align="right"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                              <td width="25%" align="left"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
					   <% } %>
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
        } else {
           if(operID == null) {
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = 'enter.jsp';
              </script>
              <%
           } else {
              %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
              </script>
              <%
           }
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in managing the IVR Dat Recommended ringtone!");//最新推荐铃音管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing the IVR Dat Recommended ringtone!");//最新推荐铃音管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
		%>
		<form name="errorForm" method="post" action="error.jsp">
		<input type="hidden" name="historyURL" value="ivrDayRecommendRing.jsp">
		</form>
		<script language="javascript">
		   document.errorForm.submit();
		</script>
	    <%  
	} %>
</body>
</html>
