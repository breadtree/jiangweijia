<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    //是否将特别专区铃音显示为无线排行榜　1:显示为无线排行榜 0:保持不变 默认:0
    String showWireless = CrbtUtil.getConfig("showWireless","0");
	String showboardtitle = zte.zxyw50.util.CrbtUtil.getConfig("Showboardtitle","Other new rings");
	String isMobitel= CrbtUtil.getConfig("isMobitel","0");
%>
<%!
     public String display (Map map) throws Exception {
        try {
            String str = ((String)map.get("rsubindex")).concat("-----").concat((String)map.get("ringid"));// + "--" + (String)map.get("ringlabel");
            return str;
        }
        catch (Exception e) {
            throw new Exception ("Incorrect data obtained!");//Obtain incorrect data
        }
    }
%>
<html>
<head>
<title><%=showboardtitle%></title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" >
<%
    String sysTime = "";
    //是否使用批量增加功能
    String isshowbatchspecialring= CrbtUtil.getConfig("isshowbatchspecialring","0");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String strBoardType = request.getParameter("boardType")==null?"162":request.getParameter("boardType");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        ColorRing  colorring = new ColorRing();
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-10") != null) {
            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            HashMap map1= new HashMap();
            Map hash = null;
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
//            String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
//            String rsubindex = "-1";
            String oldrsubindex = request.getParameter("oldrsubindex") == null ? "" : transferString((String)request.getParameter("oldrsubindex")).trim();
            String oldringid = request.getParameter("oldringid") == null ? "" : transferString((String)request.getParameter("oldringid")).trim();
            // 4.12.02
			StringBuffer boardOption = new StringBuffer();
			String show_board = CrbtUtil.getConfig("Showboard", "162:Express Copier IVR ringtone");
			String[] board_array = show_board.split(";");
			for(int i = 0; i < board_array.length; i ++) {
				int split_no = board_array[i].indexOf(":");
				String boardNum = board_array[i].substring(0, split_no).trim();
				String boardName = board_array[i].substring(split_no + 1, board_array[i].length()).trim();
				boardOption.append("<option value='");
				boardOption.append(boardNum);
				boardOption.append("'");
				if(strBoardType.equals(boardNum)){
					boardOption.append(" selected ");
				}
				boardOption.append(">");
				boardOption.append(boardName);
				boardOption.append("</option>");
			}
			int optype = 0;
            String title = null;
            if (op.equals("add")){
                optype = 1;
                title = showWireless.equals("1") ? "Add wireless ringtones board" :"Add special area ringtone";
            }
            else if (op.equals("del")) {
                optype = 2;
//                ringid  = oldringid;
//                rsubindex = oldrsubindex;
                title = showWireless.equals("1") ? "Delete wireless ringtones board" :"Delete special area ringtone";
            }
            else if (op.equals("edit"))
            {
              optype = 3;
              title = showWireless.equals("1") ? "Edit wireless ringtones board" :"Edit special area ringtone";
            }
            else if (op.equals("insert"))
            {
              optype = 4;
              title = showWireless.equals("1") ? "Edit wireless ringtones board" :"Edit special area ringtone";
            }
            if(optype>0){
               map1.put("optype",optype+"");
               map1.put("ringid",oldringid);
               map1.put("rsubindex",oldrsubindex);
               map1.put("boardtype",strBoardType);
               rList = sysring.setSpecialArea(map1);
               // 准备写操作员日志
               if(getResultFlag(rList)){
                 zxyw50.Purview purview = new zxyw50.Purview();
                 map.put("OPERID",operID);
                 map.put("OPERNAME",operName);
                 map.put("OPERTYPE","210");
                 map.put("RESULT","1");
                 map.put("PARA1", oldringid);//ringid);
                 map.put("PARA2", oldrsubindex);//rsubindex);
                 map.put("PARA3", strBoardType);
                 map.put("PARA4","ip:"+request.getRemoteAddr());
                 map.put("DESCRIPTION",title);
                 purview.writeLog(map);
               }
               if(rList.size()>0){
                session.setAttribute("rList",rList);
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="ringSpecailArea.jsp?boardType=<%=strBoardType%>">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
            }
            //manSysRing中的特殊处理,当排行类型为4时需要传入值为5
            String strTmp = "4".equals(strBoardType) ? "5" : strBoardType;
            //查询铃音排行榜
            List vet = sysring.ringSortBoard(Integer.parseInt(strTmp));
 %>
<script language="javascript">
   var v_ringid = new Array(<%= vet.size() %>);
   var v_ringlabel = new Array(<%= vet.size() %>);
   var v_rsubindex = new Array(<%= vet.size() %>);

<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Map)vet.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
   v_rsubindex[<%= i + "" %>] = '<%= (String)hash.get("rsubindex") %>';
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
      fm.ringlabel.value = v_ringlabel[index];
      fm.rsubindex.value = v_rsubindex[index];
      fm.oldrsubindex.value =v_rsubindex[index];
      fm.oldringid.value = v_ringid[index];
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.ringid.value);
      if(value==''){
         alert("Please enter the ringtone code!");//请输入Ringtone code
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The Ringtone code must be a digital number!');//Ringtone code必须是数字
         fm.ringid.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

//   function addInfo () {
//      var fm = document.inputForm;
//      if(!checkInfo())
//        return;
//      fm.op.value = 'add';
//      fm.submit();
//   }
    function setRingInfo (ringid, subindex)
    {
      var fm = document.inputForm;
      fm.oldrsubindex.value = subindex;
      fm.oldringid.value = ringid;
      fm.op.value = 'add';
      //fm.boardType.value = <//%=showWireless.equals("1")?"fm.boardSelect.value":"4"%>;
	  fm.boardType.value = fm.boardSelect.value;
      fm.submit();
    }

    function addInfo ()
    {
      window.open('ringSpecailAreaAdd.jsp','ringSpecailAreaAdd','width=400, height=280,top='+((screen.height-280)/2)+',left='+((screen.width-400)/2));
    }

   function queryInfo() {
     var result =  window.open('ringSearchforliantong.jsp','ringSearchforliantong',"width=560,height=600,left="+((screen.width-560)/2)+",top="+((screen.height-600)/2)+",resizable=yes,scrollbars=yes,status=no,toolbar=no,menubar=no,location=no");
     if(result){
       document.inputForm.ringlist.value=result;
     }
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the special area ringtone to be edited");//请选择您要Edit的特别专区铃音
          return;
      }
      //fm.boardType.value = <//%=showWireless.equals("1")?"fm.boardSelect.value":"4"%>;
	  fm.boardType.value = fm.boardSelect.value;
     var editURL = 'ringSpecailAreaMod.jsp?boardType='+ fm.boardType.value + '&ringid=' +fm.ringid.value +'&ringlabel='+fm.ringlabel.value + '&rsubindex='+fm.oldrsubindex.value;
     window.open(editURL,'ringSpecailAreaMod','width=400, height=300,top='+((screen.height-300)/2)+',left='+((screen.width-400)/2));
   }

   function insertInfo ()
    {
      window.open('ringSpecailAreaIns.jsp','ringSpecailAreaAdd','width=400, height=280,top='+((screen.height-280)/2)+',left='+((screen.width-400)/2));
    }
   function setInsertInfo (ringid, subindex)
    {
      var fm = document.inputForm;
      fm.oldrsubindex.value = subindex;
      fm.oldringid.value = ringid;
      fm.op.value = 'insert';
      //fm.boardType.value = <//%=showWireless.equals("1")?"fm.boardSelect.value":"4"%>;
	  fm.boardType.value = fm.boardSelect.value;
      fm.submit();
    }

    function setEditInfo (ringid, subindex) {
     var fm = document.inputForm;
     fm.oldrsubindex.value = subindex;
     fm.oldringid.value = ringid;
     fm.op.value = 'edit';
     fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the special area ringtone to be deleted");//请选择您删除的特别专区铃音
          return;
      }
     fm.op.value = 'del';
     //fm.boardType.value = <//%=showWireless.equals("1")?"fm.boardSelect.value":"4"%>;
	 fm.boardType.value = fm.boardSelect.value;
     fm.submit();
   }

   //查询铃音信息
   function queryRings()
   {
     var fm = document.inputForm;
     fm.boardType.value = fm.boardSelect.value;
     fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="ringSpecailArea.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldrsubindex" value="">
<input type="hidden" name="ringlist" value="">
<input type="hidden" name="oldringid" value="">
<input type="hidden" name="boardType" value="4"><!--默认排行类型为4-->
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
          <tr >
            <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif"><%=showboardtitle%></td>
          </tr>

            <tr>
              <td colspan="2">
              <table width="100%" border =0 class="table-style2">
                <tr>
                <td width="45" align="left">Type</td>
                <td align="left">
                  <select name="boardSelect" class="input-style1" style="width=180px" onchange="javascript:queryRings()">
                    <%=boardOption%>
                  </select>
                </td>
                </tr>
              </table>
              </td>
            </tr>
          <td align="center"> <select name="infoList" size="8" <%= vet.size() == 0 ? "disabled " : "" %> class="input-style1" style="width:200px" onclick="javascript:selectInfo()">
              <%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Map)vet.get(i);
                    out.println("<option value="+Integer.toString(i)+" >" +display(hash)+" </option>");
              }
             %>
            </select> </td>
          <td height='100%'> <table width="100%" border =0 class="table-style2" height='100%'>
              <tr>
                <td width="30%" align=right >Sort number</td>
                <td><input type="text" name="rsubindex" value="" maxlength="6" class="input-style1"  disabled ></td>
              </tr>
              <tr>
             <td width="30%" align=right><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
                <td><input type="text" name="ringlabel" value="" maxlength="40" class="input-style1"  disabled ></td>
              </tr>
              <tr>
                <td width="30%" align=right><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
                <td><input type="text" name="ringid" value="" maxlength="20" class="input-style1"  disabled>
                  <!--img src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo()"-->
                </td>
              </tr>
              <tr>
                <!--
             <td  style="color: #FF0000" colspan=2 height=30> &nbsp;&nbsp;注意:“排列序号”是数字型字符串</td>
             -->
              </tr>
              <tr>
                <td colspan="2" align="center"> <table border="0" width="100%" class="table-style2"  align="center">
                    <tr>
                      <td width="20%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                      <td width="20%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                      <%if(isMobitel.equals("0")){ %>
                      <td width="20%" align="center"><img src="button/refresh.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:insertInfo()"></td>
                      <%} %>
                      <td width="20%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                      <td width="20%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
                     <% String typeDisplay = "none";
                      if("1".equals(isshowbatchspecialring))
                       typeDisplay = "";
                      %>
                    </tr>
                    <tr  style="display:<%= typeDisplay %>"><td width="20%" align="center"><img src="button/piliang.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo()"></td>
                   </tr>
                  </table></td>
              </tr>
            </table></td>
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
                    alert( "Please log in first!");//Please log in to the system
                    document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime + operName + " Exception occurred in managing special area ringtones!");//特别专区铃音管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing special area ringtones!");//特别专区铃音管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="ringSpecailArea.jsp?boardType=<%=strBoardType%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
