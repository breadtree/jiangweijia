<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.SpManage" %>
<%@ page import="zxyw50.SpManage" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.*" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
     public String display (Map map) throws Exception {
        try {
            String str = (String)map.get("ringid");
            for (; str.length() < 16; )
                str += "-";
            return str + (String)map.get("ringlabel");
        }
        catch (Exception e) {
            throw new Exception ("Get the error data!");
        }
    }
%>
<html>
<head>
<title>Manage gift bag of SP</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" >
<%
String sysringgrpcheck = "0",ringoper="0";
ringoper=CrbtUtil.getConfig("musicringoper","0");
String spIndex = (String)session.getAttribute("SPINDEX");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String spcode = (String)session.getAttribute("SPCODE");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    String ringgroup  = request.getParameter("ringgroup") == null ? "" : transferString((String)request.getParameter("ringgroup")).trim();
    String grouplabel = request.getParameter("grouplabel") == null ? "" : transferString((String)request.getParameter("grouplabel")).trim();
	 String ringid1    = request.getParameter("ringid1") == null ? "" : transferString((String)request.getParameter("ringid1")).trim();
    String giftbag   = CrbtUtil.getConfig("giftname","giftbag");


    try {
        SpManage sysring = new SpManage();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("10-7") != null) {
        		SpManage  sysringgroup= new SpManage();

    			//将ringgroup,grouplabel放入session,以便ringGroupMemberEdit.jsp在增加铃音成员时能知道该值。
        		session.setAttribute("RINGGROUP",ringgroup);
         	session.setAttribute("GROUPLABEL",grouplabel);



            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            HashMap map1= new HashMap();
            Map hash = null;
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            int optype = 0;


            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("HOSTNAME",request.getRemoteAddr());
            map.put("SERVICEKEY",sysring.getSerkey());
            map.put("OPERTYPE","1008");
            map.put("RESULT","1");
            map.put("PARA1",ringgroup);
            map.put("PARA2",grouplabel);
            map.put("PARA3",ringid1);
            map.put("PARA4","ip:"+request.getRemoteAddr());
            String title = "";


            if (op.equals("del")) {
                optype = 2;
                title = "Delete the ringtone in gift bag:["+grouplabel+"]";
                map.put("DESCRIPTION","Delete the ringtone in gift bag:[" + grouplabel+"]");
            }


            if(optype>0){
                  int ischeckop = 0 ,grpcheck=0;
    ischeckop = sysring.getSpOperischeck(spIndex);
    grpcheck = sysring.getMusiccheckStatus(spIndex,ringgroup);
    if(ischeckop>0&&grpcheck>0)
        sysringgrpcheck = "1";
        //如果删除或增加铃音在配置项中无需审核的话,就改为不审核
        if(ringoper.trim().equalsIgnoreCase("0"))
           sysringgrpcheck = "0";
              if(sysringgrpcheck.equalsIgnoreCase("0"))
              {
               //目前只有删除功能。添加功能在ringGroupMember.html中
               map1.put("opcode",optype+"");
               map1.put("ringgroup",ringgroup);
               map1.put("ringid",ringid1);
               map1.put("newringid","0");  //该参数对删除无效
               rList = sysringgroup.modSysRingGroupMem(map1);
               purview.writeLog(map);
               if(rList.size()>0){
                	session.setAttribute("rList",rList);
                	String backurl="giftbagMember.jsp?ringgroup="+ringgroup+"&grouplabel="+grouplabel;
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="<%= backurl %>">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
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
                     opmap.put("opertype","104");
                     opmap.put("status","0");
                     opmap.put("ringid",ringid1);
                     opmap.put("operdesc","");
                     opmap.put("refusecomment","");
                     opmap.put("ringfee",request.getParameter("ringfee")==null?"0":(String)request.getParameter("ringfee"));
                     opmap.put("ringlabel",request.getParameter("ringlabel1")==null?"":transferString((String)request.getParameter("ringlabel1")));
                     opmap.put("singgername",request.getParameter("singgername")==null?"":transferString((String)request.getParameter("singgername")));
                     opmap.put("validdate",request.getParameter("validdate")==null?"":(String)request.getParameter("validdate"));
                     opmap.put("ringspell",request.getParameter("ringspell")==null?"":(String)request.getParameter("ringspell"));
                     opmap.put("uservalidday",request.getParameter("uservalidday")==null?"":(String)request.getParameter("uservalidday"));
                     opmap.put("ringgroup",ringgroup);
                     opmap.put("ringidnew","");
                     opmap.put("ringcnt","0");
                     ls = manring.addoperCheck(opmap);
session.setAttribute("rList",ls);
                   for(int i=0;i<ls.size();i++)
                   {
                     tmp = (Hashtable)ls.get(i);
                     if(!"0".equalsIgnoreCase(tmp.get("result").toString().trim()))
                          mess+=tmp.get("scp").toString().trim()+"-"+tmp.get("reason").toString().trim()+" ";
                   }
                   if(mess.trim().equalsIgnoreCase(""))
                      mess = "Insert approval data successfully";
                   else
                      mess = "Insert approval data,SCP failure:("+mess+")";
                %>
                  <script language="JavaScript">
                 <%if(!mess.trim().equalsIgnoreCase("")){%>
                  window.alert('<%=mess%>');
                  <%}%>
                  window.returnValue = "yes";
                  </script>
                <%
              }
            }

            List vet = null;
            vet=sysringgroup.getSysRingGroupMember(ringgroup);


 %>
<script language="javascript">
   var v_ringid = new Array(<%= vet.size() + "" %>);
   var v_ringindex = new Array(<%= vet.size() + "" %>);
   var v_ringlabel = new Array(<%= vet.size() + "" %>);
   var v_ringfee = new Array(<%= vet.size() + "" %>);
   var v_singgername = new Array(<%= vet.size() + "" %>);
   var v_ringspell = new Array(<%= vet.size() + "" %>);
   var v_validdate = new Array(<%= vet.size() + "" %>);
   var v_uservalidday = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Map)vet.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringindex[<%= i + "" %>] = '<%= (String)hash.get("ringindex") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
   v_ringfee[<%= i + "" %>] = '<%= (String)hash.get("ringfee") %>';
   v_singgername[<%= i + "" %>] = '<%= (String)hash.get("singgername") %>';
   v_ringspell[<%= i + "" %>] = '<%= (String)hash.get("ringspell") %>';
   v_validdate[<%= i + "" %>] = '<%= (String)hash.get("validdate") %>';
   v_uservalidday[<%= i + "" %>] = '<%= (String)hash.get("uservalidday") %>';
<%
            }
%>

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '')
         return;
      fm.ringid.value = v_ringid[index];
      fm.ringid1.value = v_ringid[index];
      fm.ringlabel.value = v_ringlabel[index];
      fm.ringlabel1.value = v_ringlabel[index];
      fm.ringindex.value = v_ringindex[index];
      fm.ringfee.value = v_ringfee[index];
      fm.singgername.value = v_singgername[index];
      fm.validdate.value = v_validdate[index];
      fm.ringspell.value = v_ringspell[index];
      fm.uservalidday.value = v_uservalidday[index];
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.ringid.value);
      if(value==''){
         alert("Please enter the code of ringtone");
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert("The code of ringtone must be a digital number!");
         fm.ringid.focus();
         return flag;
      }
      var value = trim(fm.ringindex.value);
      if(value==''){
         alert("Please enter the index of ringtone!");
         fm.ringindex.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert("The index of ringtone must be a digital number!");
         fm.ringindex.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function addInfo () {
     window.open('ringGroupAdd.jsp?grouptype=2','ringGroupAdd','width=400, height=240,top='+((screen.height-280)/2)+',left='+((screen.width-400)/2));
   }


   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the ringtone to delete!");
          return;
      }
     fm.op.value = 'del';
     fm.ringid1.value = fm.ringid.value ;
     fm.submit();
   }

   function getAddInfo (ringid) {
//     var fm = document.inputForm;
//
//     fm.op.value = 'add';
//     fm.submit();
      document.location.href = 'giftbagMemberAddEnd.jsp?ringidadd='+ringid+'&op=add';
   }

   function backInfo () {
    document.location.href = 'giftbag.jsp';
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="giftbagMember.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="ringgroup" value="<%=ringgroup%>">
<input type="hidden" name="grouplabel" value="<%=grouplabel%>">
<input type="hidden" name="ringid1" value="">
<input type="hidden" name="ringfee" value="">
<input type="hidden" name="ringlabel1" value="">
<input type="hidden" name="singgername" value="">
<input type="hidden" name="validdate" value="">
<input type="hidden" name="ringspell" value="">
<input type="hidden" name="uservalidday" value="">

<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Manage <%=giftbag%> of SP: <%=grouplabel%></td>
        </tr>
        <td align="center">
             <select name="infoList" size="8" <%= vet.size() == 0 ? "disabled " : "" %> class="input-style1" style="width:200px" onclick="javascript:selectInfo()">
             <%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Map)vet.get(i);
                    out.println("<option value="+Integer.toString(i)+" >" +display(hash)+" </option>");
              }
             %>
             </select>
        </td>
        <td height='100%'>
            <table width="100%" border =0 class="table-style2" height='100%'>
            <tr>
             <td width="30%" align=right >Index of ringtone</td>
             <td><input type="text" name="ringindex" value="" maxlength="6" class="input-style1"  disabled ></td>
            </tr>
            <tr>
             <td width="30%" align=right >Name of ringtone</td>
             <td><input type="text" name="ringlabel" value="" maxlength="6" class="input-style1"  disabled ></td>
            </tr>
            <tr>
             <td width="30%" align=right>Code of ringtone</td>
             <td><input type="text" name="ringid" value="" maxlength="20" class="input-style1" disabled ></td>
            </tr>
            <tr>
            <td colspan="2" align="center">
              <table border="0" width="100%" class="table-style2"  align="center">
              <tr>
                <td width="25%" align="center"><img src="../manager/button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="25%" align="center"><img src="../manager/button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                <td width="25%" align="right"> <img src="../manager/button/back.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:backInfo()"></td>
               <td width="25%" align="center"></td>
              </tr>
              </table>
            </td>
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
        }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in first!");
                    document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime + operName + " Exception occurred in managing gift bag of SP");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Errors occurred in managing gift bag of SP");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="giftbagMember.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
