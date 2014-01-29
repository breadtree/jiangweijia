<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page language="java" contentType="text/html;" errorPage="errorHandler.jsp" %>
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
<title>Pre-listen system ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
     //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    //add end
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String craccount = (String)request.getParameter("ringlibid")==null?"":(String)request.getParameter("ringlibid");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysRing manring = new manSysRing();
        sysTime = manring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-4") != null) {
            String strPos = request.getParameter("Pos") == null ? "" : transferString((String)request.getParameter("Pos")).trim();

            String parentindex = request.getParameter("parentindex") == null ? null : transferString((String)request.getParameter("parentindex")).trim();

//             if((parentindex!=null)&& !"0".equals(parentindex))
//            {
//               		//来自查询，以避免字符集转换问题
//               		Hashtable tmphash = manring.getRingLibraryNode(parentindex);
//               		strPos = "Ringtone library-->"+(String)tmphash.get("ringliblabel");
//            }
//


            Vector vetRing = new Vector();
            Hashtable hash = new Hashtable();
             // modify by gequanmin 2005-07-05
//           if("1".equals(usedefaultringlib)){
//            if (craccount.equals("")){
//                strPos = zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" library<br>->Default "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" library";
//                craccount = "503";
//            }
//            }
            //else{
             if((craccount!=null)&&(!craccount.equalsIgnoreCase(""))){
               vetRing = manring.getSysRing(craccount);

               //来自查询，以避免字符集转换问题
               	Hashtable tmphash = manring.getRingLibraryNode(craccount);

                if(strPos.equals(""))
                {
                  strPos = strPos + zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone") +" library-->"+(String)tmphash.get("ringliblabel");;
                }else{
                   strPos = strPos + "-->"+(String)tmphash.get("ringliblabel");
                }

             }
           //}
%>
    <script language="javascript">
   //铃音库铃音
   var v_ringlabel = new Array(<%= vetRing.size() + "" %>);
   var v_ringauthor = new Array(<%= vetRing.size() + "" %>);
   var v_mediatype = new Array(<%= vetRing.size() + "" %>);
<%
            for (int i = 0; i < vetRing.size(); i++) {
                hash = (Hashtable)vetRing.get(i);
%>
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
   v_ringauthor[<%= i + "" %>] = '<%= (String)hash.get("singername") %>';
   v_mediatype[<%= i + "" %>] = '<%= (String)hash.get("mediatype") %>';
<%
            }
%>
   function selectPersonalRing () {
      var fm = document.inputForm;
      var index = fm.personalRing.selectedIndex;
      if (fm.personalRing.value == null) {
         fm.usernumber.focus();
         return;
      }
      if (fm.personalRing.value == '')
         return;
      fm.crid.value = fm.personalRing.value;
      fm.ringname.value   = v_ringlabel[index];
      fm.ringauthor.value = v_ringauthor[index];
      fm.mediatype.value = v_mediatype[index];
   }

   function searchRing () {
      fm = document.inputForm;
      fm.submit();
   }
<%--
   function tryListen () {
      fm = document.inputForm;
      if (fm.craccount.value == '')
         return;
      if (fm.crid.value == '') {
         alert('Please select a ringtone before pre-listening!');//请先选择铃音,再试听!
         return;
      }
      var tryURL = 'tryListen.jsp?ringid=' + fm.crid.value +'&ringname=' + fm.ringname.value+'&ringauthor='+fm.ringauthor.value;
      preListen = window.open(tryURL,'try','width=400, height=240,top='+((screen.height-240)/2)+',left='+((screen.width-400)/2));
   }
--%>
   function tryListen () {
      fm = document.inputForm;
      if (fm.craccount.value == '')
         return;
      if (fm.crid.value == '') {
	 alert('Please select a ringtone before pre-listening!');
         return;
      }
      var tryURL = 'tryListen.jsp?ringid=' + fm.crid.value +'&ringname=' + fm.ringname.value+'&ringauthor='+fm.ringauthor.value+'&mediatype='+fm.mediatype.value;
      if(fm.mediatype.value=='1'){
        preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(fm.mediatype.value=='2'){
        preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(fm.mediatype.value=='4'){
      	tryURL = 'tryView.jsp?ringid=' + fm.crid.value +'&ringname=' + fm.ringname.value+'&ringauthor='+fm.ringauthor.value+'&mediatype='+fm.mediatype.value;
        preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }
   }
</script>
<form name="inputForm" method="post" action="sysRing.jsp">
<input type="hidden" name="crid" value="">
<input type="hidden" name="ringname" value="">
<input type="hidden" name="ringauthor" value="">
<input type="hidden" name="mediatype" value="">
<input type="hidden" name="craccount" value="<%= craccount == null ? "" : craccount %>">
<table width="346"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
    <tr>
    <td><img src="image/004.gif" width="346" height="15"></td>
  </tr>
  <tr >
    <td background="image/006.gif">
    <table width="340" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
    <td>
      <table  border="0" align="center" class="table-style2">
       <tr valign="top">
          <td colspan=2 align="center" >Current category:&nbsp;<%= strPos %></td>
        </tr>
         <tr>
          <td colspan="2" align="center">
            <select name="personalRing" size="10" <%= vetRing.size() == 0 ? "disabled " : "" %> onchange="javascript:selectPersonalRing()" class="input-style1" style="width: 240;">
<%
                Hashtable tmp = new Hashtable();
                for (int i = 0; i < vetRing.size(); i++) {
                    tmp = (Hashtable)vetRing.get(i);
%>
              <option value="<%= (String)tmp.get("ringid") %>"><%= (String)tmp.get("ringid") + "---" + (String)tmp.get("ringlabel") %></option>
<%
                }
%>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan="2" align="center">
              <img src="button/trylisten.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:tryListen()">
          </td>
      </tr>
     </table>
      </td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td><img src="image/005.gif" width="346" height="15"></td>
  </tr>
  </table>
</form>
<%
        }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    parent.document.URL = 'enter.jsp';
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
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in pre-listening the system ringtone!");//试听系统铃音过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + "Error occurred in pre-listening the system ringtone!");//试听系统铃音过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="sysRing.html">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
