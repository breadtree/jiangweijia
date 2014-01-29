<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
	//String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
        int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String isCatalogAlias1 = CrbtUtil.getConfig("catalogalias1","0");
	String isCatalogAlias2 = CrbtUtil.getConfig("catalogalias2","0");
	String isExtraCatalogInfo = CrbtUtil.getConfig("extra_cataloginfo","0");
	String sLangLabel1 = CrbtUtil.getConfig("langlabel1","Arabic");
	String sLangLabel2 = CrbtUtil.getConfig("langlabel2","French");
    try {
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-1") != null) {
            Vector vet = new Vector();
            Vector mrb = new Vector();
            Hashtable hash = new Hashtable();
			HashMap map1 = new HashMap();
            String curclass="";
            String strPos = request.getParameter("Pos") == null ? "" : transferString((String)request.getParameter("Pos")).trim();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();

            String parentindex = request.getParameter("parentindex") == null ? "" : transferString((String)request.getParameter("parentindex")).trim();
            String ringlibid = request.getParameter("ringlibid") == null ? "" : transferString((String)request.getParameter("ringlibid")).trim();
            String ringfee = request.getParameter("ringfee") == null ? "" : transferString((String)request.getParameter("ringfee")).trim();
            String ringliblabel = request.getParameter("ringliblabel") == null ? "" : transferString((String)request.getParameter("ringliblabel")).trim();
            String maxnumber = request.getParameter("maxnumber") == null ? "" : transferString((String)request.getParameter("maxnumber")).trim();
            String ringlibcode = request.getParameter("ringlibcode") == null ? "" : transferString((String)request.getParameter("ringlibcode")).trim();
			String sExtraCatID= request.getParameter("funcid") == null ? "" : transferString((String)request.getParameter("funcid")).trim();
			System.out.println("ExtraCatID------------------->"+sExtraCatID);
			String cat_alias1 = request.getParameter("cat_alias1") == null ? "" : transferString((String)request.getParameter("cat_alias1")).trim();
			String cat_alias2 = request.getParameter("cat_alias2") == null ? "" : transferString((String)request.getParameter("cat_alias2")).trim();
			int iDispOpcode = 0;
            String imgDir = (String)CrbtUtil.getConfig("singerpath","C:/zxin10/Was/tomcat/webapps/colorring/image/singer/");

            if(checkLen(ringliblabel,40))
        	  throw new Exception("The length of the" + zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone") +" category name you entered has exceeded the limit. Please re-enter!");//您输入的铃音分类名称长度超出限制,请重新输入!
            hash.put("ringlibid",ringlibid);
            hash.put("ringfee",ringfee);
            hash.put("ringliblabel",ringliblabel);
            hash.put("maxnumber",maxnumber);
            hash.put("parentindex",parentindex);
            hash.put("ringlibcode",ringlibcode);
            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","201");
            map.put("RESULT","1");
            String  title = "";
            ArrayList rList = new ArrayList();

			
			map1.put("name",ringliblabel);
			map1.put("opflag","5");
			map1.put("alias1",cat_alias1);
			map1.put("alias2",cat_alias2);
			map1.put("imgdir",imgDir);

            if (op.equals("add")) {
                ringlibid ="";
                rList = sysring.addRingLibrary(hash);
				Hashtable sDispHash=new Hashtable();
			
				if(getResultFlag(rList) && isExtraCatalogInfo.equals("1") && (isCatalogAlias1.equals("1") || isCatalogAlias2.equals("1"))) {
	                                sDispHash=(Hashtable)rList.get(0);
				        ringlibid=sDispHash.get("ringlibid")==null?"":(String)sDispHash.get("ringlibid");
				        map1.put("funcid",ringlibid);
					iDispOpcode=1;
					map1.put("extrainfooptype",iDispOpcode+"");
					rList=sysring.setAliasInfo(map1);
				}
                sysInfo.add(sysTime + operName + "Ringtone category added successfully!");
                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
                title  =  "Add ringtone category--" + ringliblabel;
            }
            else if (op.equals("edit")) {
                rList = sysring.editRingLibrary(hash);
				if(getResultFlag(rList) && isExtraCatalogInfo.equals("1") && (isCatalogAlias1.equals("1") || isCatalogAlias2.equals("1"))) {
					iDispOpcode=sExtraCatID.equals("")?1:3;
					map1.put("extrainfooptype",iDispOpcode+"");
					map1.put("funcid",ringlibid);
					rList=sysring.setAliasInfo(map1);
				}
                sysInfo.add(sysTime + operName + "Ringtone category edited successfully!");
                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                title  =  "Edit ringtone category--" + ringliblabel;
            }
            else if (op.equals("del")) {
                rList =  sysring.delRingLibrary(ringlibid);
				map1.put("funcid",ringlibid);
                ringlibid = "";
				if(getResultFlag(rList) && isExtraCatalogInfo.equals("1") && (isCatalogAlias1.equals("1") || isCatalogAlias2.equals("1"))) {
					iDispOpcode=2;
					map1.put("extrainfooptype",iDispOpcode+"");
					rList=sysring.setAliasInfo(map1);
				}
                sysInfo.add(sysTime + operName + "Ringtone category deleted successfully!");
                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                title  =  "Delete ringtone category--" + ringliblabel;
            }
            if(!op.equals("") && getResultFlag(rList)){
                map.put("PARA1",ringlibid);
                map.put("PARA2",ringlibcode);
                map.put("PARA3",ringliblabel);
                map.put("PARA4",maxnumber);
                purview.writeLog(map);
            }
            if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp" target="_parent">
  <input type="hidden" name="title" value="<%= title %>" />
  <input type="hidden" name="historyURL" value="ringLib.html"/>
<script language="javascript">
//  parent.document.location.href="result.jsp?title=<%= title %>&historyURL=ringLib.html";
document.resultForm.submit();
</script>
</form>
            <%
               }
            if(ringlibid.length()>0 && !ringlibid.equals("0")){
             if(isExtraCatalogInfo.equals("1") && (isCatalogAlias1.equals("1") || isCatalogAlias2.equals("1"))){
               hash = sysring.getRingLibraryNodeCategory(ringlibid);
               cat_alias1 = (String)hash.get("alias1");
	       cat_alias2 = (String)hash.get("alias2");
	       sExtraCatID = (String)hash.get("funcid");
              }else{
               hash = sysring.getRingLibraryNode(ringlibid);
               }
               maxnumber = (String)hash.get("maxnumber");
               ringliblabel = (String)hash.get("ringliblabel");
               ringlibid = (String)hash.get("ringlibid");
               ringlibcode = (String)hash.get("ringlibcode");
               curclass = (String)hash.get("curclass");

//               if((parentindex!=null)&& !"0".equals(parentindex))
//               {
//               		//父名来自查询，以避免字符集转换问题
//               		Hashtable tmphash = sysring.getRingLibraryNode(parentindex);
//               		strPos = zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone") +" library-->"+(String)tmphash.get("ringliblabel");
//               }

               if(strPos.equals(""))
                  strPos = strPos + zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone") +" library-->"+ringliblabel;
               else
                   strPos = strPos + "-->"+ringliblabel;
            }
            if(strPos.equals("")){
                strPos = zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone") +" library";
                ringlibid = "0";
            }
            %>

<html>
<head>
<title>Manage ringtone categories</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script src="../base/common.js"></script>
<script language="javascript">
    function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var tmp;
      tmp = trim(fm.ringlibcode.value);
      if (tmp=='') {
         alert('Please enter the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category code!');//请输入铃音分类编码
         fm.ringlibcode.focus();
         return flag;
      }
      if (!checkstring('0123456789',tmp)) {
         alert('<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category code can only contain digits!');//铃音分类编码只能为数字!
         fm.ringlibcode.focus();
         return flag;
      }
      tmp = trim(fm.ringliblabel.value);
      if (tmp == '') {
         alert('Please enter the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category name!');//请输入铃音分类名称
         fm.ringliblabel.focus();
         return flag;
      }
      <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(tmp,40)){
          alert('The length of the ringtone category name you entered has exceeded the limit. Please re-enter!');//请输入铃音分类名称
          fm.ringliblabel.focus();
          return flag;
        }
        <%
        }
        %>
       if (!CheckInputStr(fm.ringliblabel,'<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category name')){
         fm.ringliblabel.focus();
         return  flag;
      }

      tmp = trim(fm.maxnumber.value);
      if(tmp==''){
         alert('Please enter the maximum number of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s!');//请输入最大铃音数目
         fm.maxnumber.focus();
         return flag;
      }

      if (!checkstring('0123456789',tmp)) {
         alert('The maximum number of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s can only be a digital number!');//最大铃音数目只能为数字!
         fm.maxnumber.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
//      if(fm.parentindex.value>0){
  <%if(curclass!=null&&curclass.equals("3")){%>
         alert("Sorry. The system only supports 3 levels of directories. Please add the category under the upper directory!");//对不起系统只支持三级目录,请到上一级目录下增加分类
         return ;
     <% }%>
      if(fm.ringlibid.value !='')
         fm.parentindex.value = fm.ringlibid.value;
      fm.op.value = 'add';
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      if (trim(fm.ringlibid.value) == '') {
         alert('Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category to be deleted!');//请先选择要删除的铃音分类
         return;
      }
      fm.op.value = 'del';
      fm.submit();
   }
 </script>
</head>
<body  class="body-style1">
<script language="JavaScript">
    var optype = "<%= op %>";
    if(optype=='del' || optype =='add' || optype=='edit')
       parent.libTree.document.location.href = "ringLibTree.jsp";
</script>

 <form name="inputForm" method="post" action="ringLibInfo.jsp">
 <input type="hidden" name="ringlibid" value="<%= ringlibid %>">
 <input type="hidden" name="parentindex" value="<%= parentindex %>">
 <input type="hidden" name="op" value="">
 <input type="hidden" name="funcid" value="<%=sExtraCatID%>" />
<table width="346" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="image/004.gif" width="346" height="15"></td>
  </tr>
  <tr>
    <td background="image/006.gif"><table width="340" border="0" align="center" cellpadding="2" cellspacing="2">
      <tr>
        <td>
            <table  border="0" align="center" class="table-style2">
              <tr valign="top">
                <td>
                  <table width="100%" border="0" align="center" class="table-style2">
                    <tr>
                      <td colspan=2 >Current position:<%= strPos %></td>
                    </tr>
                    <tr>
                      <td colspan=2 >&nbsp;</td>
                    </tr>
                    <tr>
                      <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category code</td>
                      <td><input type="text" name="ringlibcode" value="<%= ringlibcode %>" maxlength="4" class="input-style1"></td>
                    </tr>
                    <tr>
                      <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category name</td>
                      <td><input type="text" name="ringliblabel" value="<%= ringliblabel %>" maxlength="40" class="input-style1"></td>
                    </tr>
					 <tr <%if(isExtraCatalogInfo.equals("1") && isCatalogAlias1.equals("1")) {%> style="display:block" <%}else{%> style="display:none" <%}%>>
                      <td align="right"><%=sLangLabel1%> category name</td>
                      <td><input type="text" name="cat_alias1" value="<%= cat_alias1 %>" maxlength="100" class="input-style1"></td>
                    </tr>
					 <tr <%if(isExtraCatalogInfo.equals("1") && isCatalogAlias2.equals("1")) {%> style="display:block" <%}else{%> style="display:none" <%}%>>
                      <td align="right"><%=sLangLabel2%> category name</td>
                      <td><input type="text" name="cat_alias2" value="<%= cat_alias2 %>" maxlength="100" class="input-style1"></td>
                    </tr>
                    <tr style="display:none">
                      <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> price (<%=minorcurrency%>)</td>
                      <td><input type="text" name="ringfee" value="0" maxlength="6" class="input-style1"></td>
                    </tr>
                    <tr>
                      <td align="right">Maximum number of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s</td>
                      <td><input type="text" name="maxnumber" value="<%= maxnumber %>" maxlength="6" class="input-style1"></td>
                    </tr>
                    <tr>
                      <td colspan="2">
                        <table border="0" width="100%" class="table-style2">
                          <tr>
                            <td width="25%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:addInfo()"></td>
                            <td width="25%" align="center"><img src="button/edit.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:editInfo()"></td>
                            <td width="25%" align="center"><img src="button/del.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:delInfo()"></td>
                            <td width="25%" align="center"><img src="button/again.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:document.inputForm.reset()"></td>
                          </tr>
                      </table></td>
                    </tr>
                </table></td>
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
                   parent.document.location.href = 'enter.jsp';
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
        sysInfo.add(sysTime + operName + "Exception occurred in managing ringtone categories!");//铃音分类管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing ringtone categories!");//铃音分类管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
          <form name="errorForm" method="post" action="error.jsp" target="_parent">
            <input type="hidden" name="historyURL" value="ringLib.html">
          </form>
          <script language="javascript">
            document.errorForm.submit();
          </script>
          <%
    }
%>
</body>
</html>
