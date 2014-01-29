<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SpManage" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.zxywpub.*" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Discount Management</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
   String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);


    String sysringgrpcheck = "0";
    String sysTime = "";
    String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String SpModSysRingGrpPrice =(String)application.getAttribute("SpModSysRingGrpPrice")==null?"0":(String)application.getAttribute("SpModSysRingGrpPrice");
    String isshowischeck= "none";
    String spIndex = "";
    String spCode = "";
    String opertype = "";
    if(mode.equals("manager")){
      spIndex ="0";
      manSysPara syspara = new  manSysPara();
      Hashtable tmph = syspara.getSPCode(spIndex);
      spCode =(String)tmph.get("spcode");
      opertype = "222";
    }
    else{
      spIndex =(String)session.getAttribute("SPINDEX");
      spCode =(String)session.getAttribute("SPCODE");
      opertype = "1011";
    }
    HashMap opmap = new HashMap();
    try {
        SpManage sysring = new SpManage();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("10-11") != null) {
            ArrayList list  = new ArrayList();
            HashMap map1 = new HashMap();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();

            String discountname = request.getParameter("discountname") == null ? "" : transferString((String)request.getParameter("discountname")).trim();
            if(checkLen(discountname,20))
            	throw new Exception("The name of discount name is too long,please input again.");
            String freerings = request.getParameter("freerings") == null ? "" : transferString((String)request.getParameter("freerings")).trim();
            String rentfee = request.getParameter("rentfee") == null ? "" : transferString((String)request.getParameter("rentfee")).trim();
            String isshow  = request.getParameter("isshow") == null ? "0" : transferString((String)request.getParameter("isshow")).trim();
            String bflag  = request.getParameter("bflag") == null ? "0" : transferString((String)request.getParameter("bflag")).trim();
            String expiredate = request.getParameter("expiredate")==null?"":(String)request.getParameter("expiredate");
            String discountdesc = request.getParameter("discountdesc") == null ? "" : transferString((String)request.getParameter("discountdesc")).trim();
            if(checkLen(discountdesc,40))
            	throw new Exception("The description is too long, please input again.");

            String discountid = request.getParameter("discountid") == null ? "" : transferString((String)request.getParameter("discountid")).trim();
            String discountindex=request.getParameter("discountindex") == null ? "" : transferString((String)request.getParameter("discountindex")).trim();
            String title = "";
            ArrayList rList = new ArrayList();
            int  optype = 0;
            if (op.equals("add")){
                optype = 1;
                title = "Add discount:"+discountname;
            }
            if (op.equals("edit")){
                optype = 3;
                title = "Edit discount:"+discountname;
            }
            else if (op.equals("del")) {
                optype = 2;
                title = "Delete discount:"+discountname;

            }
            if(!op.equals("")){
                map1.put("spcode",spCode);
                map1.put("discountindex",discountindex);
                map1.put("discountid",discountid);
                map1.put("discountname",discountname);
                map1.put("rentfee",rentfee);
                map1.put("freerings",freerings);
                map1.put("discountdesc",discountdesc);
                map1.put("isshow",isshow);
                map1.put("bflag",bflag);
                map1.put("expiredate",expiredate );
    				int ischeckop = 0 ,grpcheck=0;
    				ischeckop = sysring.getDiscountOpercheck(spIndex);
    				grpcheck = sysring.getDiscountcheckStatus(spIndex,discountid);
    				if(ischeckop>0&&grpcheck>0)
        				sysringgrpcheck = "1";

    				if(optype==1) //增加套餐
               {
                  map1.put("opcode",optype+"");
    				 	rList=sysring.addSpDiscount(map1);
               }else if(optype==2) //删除套餐
               {
                 	if(sysringgrpcheck.equalsIgnoreCase("0"))
                  {
                  	map1.put("opcode",optype+"");
    				 		rList=sysring.modSpDiscount(map1);
                     String mess="";
                     Hashtable tmp = null;
                     for(int i=0;i<rList.size();i++)
                     {
                     	tmp = (Hashtable)rList.get(i);
                        if(!"0".equalsIgnoreCase(tmp.get("result").toString().trim()))
                        	mess+=tmp.get("scp").toString().trim()+"-"+tmp.get("reason").toString().trim()+" ";
                     }
                     if(mess.trim().equalsIgnoreCase(""))
                     	mess = "Delete discount successfully";
                     else
                     	mess = "Delete discount failure:("+mess+")";
%>
<script language="JavaScript">
               <%if(!mess.trim().equalsIgnoreCase("")){%>
                window.alert('<%=mess%>');
                <%}%>
                window.returnValue = "yes";
</script>
               <%
               }else{
                 String mess="";
                 manSysRing manring = new manSysRing();
                    ArrayList ls = null;
                    Hashtable tmp = null;
                   opmap.put("operid",spIndex);
                   opmap.put("opername",operName);
                   opmap.put("opertype","1");
                   opmap.put("status","0");
                   opmap.put("discountid",discountid);
                   //用作套餐描述
                   opmap.put("operdesc",discountdesc);
                   opmap.put("discountname",discountname);
                   opmap.put("rentfee",rentfee);
                   opmap.put("freerings",freerings);
                   opmap.put("bflag",bflag);
                   opmap.put("isshow",isshow);
                   opmap.put("expiredate",expiredate);
                   ls = manring.addDiscountoperCheck(opmap);
                   rList = ls ;
                 for(int i=0;i<ls.size();i++)
                 {
                   tmp = (Hashtable)ls.get(i);
                   if(!"0".equalsIgnoreCase(tmp.get("result").toString().trim()))
                        mess+=tmp.get("scp").toString().trim()+"-"+tmp.get("reason").toString().trim()+" ";
                 }
                 if(mess.trim().equalsIgnoreCase(""))
                    mess = "Add audit data OK";
                 else
                    mess = "Add audit data,SCP failure:("+mess+")";
              %>
                <script language="JavaScript">
               <%if(!mess.trim().equalsIgnoreCase("")){%>
                window.alert('<%=mess%>');
                <%}%>
                window.returnValue = "yes";
                </script>
              <%
               }
            }else if(optype==3) //修改套餐
            {
               if(sysringgrpcheck.equalsIgnoreCase("0"))
               {
                   map1.put("opcode",optype+"");
 						rList=sysring.modSpDiscount(map1);
               }else{
                 	String mess="";
                 	manSysRing manring = new manSysRing();
                   ArrayList ls = null;
                   Hashtable tmp = null;
                   opmap.put("operid",spIndex);
                   opmap.put("opername",operName);
                   opmap.put("opertype","0");
                   opmap.put("status","0");
                   opmap.put("discountid",discountid);
                   //用作套餐描述
                   opmap.put("operdesc",discountdesc);
                   opmap.put("discountname",discountname);
                   opmap.put("rentfee",rentfee);
                   opmap.put("freerings",freerings);
                   opmap.put("bflag",bflag);
                   opmap.put("isshow",isshow);
                   opmap.put("expiredate",expiredate);
                   ls = manring.addDiscountoperCheck(opmap);
                   rList = ls ;
                 for(int i=0;i<ls.size();i++)
                 {
                   tmp = (Hashtable)ls.get(i);
                   if(!"0".equalsIgnoreCase(tmp.get("result").toString().trim()))
                        mess+=tmp.get("scp").toString().trim()+"-"+tmp.get("reason").toString().trim()+" ";
                 }
                 if(mess.trim().equalsIgnoreCase(""))
                     mess = "Add audit data OK";
                 else
                    mess = "Add audit data,SCP failure:("+mess+")";
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


               if(getResultFlag(rList)){
                  // 准备写操作员日志
                  zxyw50.Purview purview = new zxyw50.Purview();
                  HashMap map = new HashMap();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE",opertype);
                  map.put("RESULT","1");
                  map.put("PARA1",discountid);
                  map.put("PARA2",discountname);
                  map.put("PARA3",freerings);
                  map.put("PARA4",rentfee);
                  map.put("PARA5",discountdesc);
                  map.put("PARA6","ip:"+request.getRemoteAddr());
                  map.put("DESCRIPTION",title);
                  purview.writeLog(map);
                }
               /**
                if(rList.size()>0){
                  session.setAttribute("rList",rList);
                  **/
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="discount.jsp">
<input type="hidden" name="title" value="<%= title %>">
<input type="hidden" name="mode" value="<%= mode %>">
</form>
            <%
             //  }


            }

            //返回所有套餐
            list = sysring.getSpDiscount(spIndex);

%>
<script language="javascript">
   var v_discountid = new Array(<%= list.size() + "" %>);
   var v_discountindex = new Array(<%= list.size() + "" %>);
   var v_discountname = new Array(<%= list.size() + "" %>);
   var v_freerings     = new Array(<%= list.size() + "" %>);
   var v_rentfee     = new Array(<%= list.size() + "" %>);
   var v_isshow  = new Array(<%= list.size() + "" %>);
   var v_bflag =new Array(<%= list.size() + "" %>);
   var v_expiredate  = new Array(<%= list.size() + "" %>);
   var v_ischeck  = new Array(<%= list.size() + "" %>);
   var v_discountdesc  = new Array(<%= list.size() + "" %>);
<%
            for (int i = 0; i < list.size(); i++) {
                map1 = (HashMap)list.get(i);
%>
   v_discountid[<%= i + "" %>] = '<%= (String)map1.get("discountid") %>';
   v_discountindex[<%= i + "" %>] = '<%= (String)map1.get("discountindex") %>';
   v_discountname[<%= i + "" %>] = '<%= (String)map1.get("discountname") %>';
   v_freerings[<%= i + "" %>] = '<%= (String)map1.get("freerings") %>';
   v_rentfee[<%= i + "" %>] = '<%= (String)map1.get("rentfee") %>';
   v_isshow[<%= i + "" %>] = '<%= (String)map1.get("isshow") %>';
   v_bflag[<%= i + "" %>] = '<%= (String)map1.get("bflag") %>';
   v_expiredate[<%= i + "" %>] = '<%= (String)map1.get("expiredate") %>';
   v_ischeck[<%= i + "" %>] = '<%= (String)map1.get("ischeck") %>';
   v_discountdesc[<%= i + "" %>] ="<%= JspUtil.convert((String)map1.get("discountdesc"))%>";
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
      fm.discountname.value = v_discountname[index];
      fm.isshow[v_isshow[index]].checked = true;
      fm.bflag[v_bflag[index]].checked = true;
      fm.rentfee.value = v_rentfee[index];
      <%if(SpModSysRingGrpPrice.equals("0")){%>
        fm.rentfee.readOnly=true;
      <%}%>
      fm.freerings.value = v_freerings[index];
      fm.expiredate.value = v_expiredate[index];
      document.all('check_id').style.display= 'block';
      if(v_ischeck[index]=='0')
      fm.ischeck.value='Not check';
      if(v_ischeck[index]=='2')
      fm.ischeck.value='Check OK';
      fm.discountdesc.value=v_discountdesc[index];
      fm.discountid.value = v_discountid[index];
      fm.discountindex.value=v_discountindex[index];
      fm.discountname.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.discountname.value) == '') {
         alert('Please input discount name!');
         fm.discountname.focus();
         return flag;
      }
      if (!CheckInputStr(fm.discountname,'Discount name')){
         fm.discountname.focus();
         return flag;
      }
      if (! checkfee(trim(fm.freerings.value))) {
         alert('The ringtone number in discount is wrong.');
         fm.freerings.focus();
         return;
      }
      if (! checkfee(trim(fm.rentfee.value))) {
         alert('The discount price is wrong.');
         fm.rentfee.focus();
         return;
      }
      if (!CheckInputStr(fm.discountdesc,'description')){
         fm.discountdesc.focus();
         return flag;
      }

   	var expiredate = trim(fm.expiredate.value);
        var bflag='0';
        if(fm.bflag[0].checked)
           bflag='0'
        else
           bflag='1';

        if(bflag=='1'){
          if(expiredate==''){
            alert('Please input discount expire time.');
            fm.expiredate.focus();
            return ;
          }
          if(!checkDate2(expiredate)){
            alert('The expiredate is invalid, please input again.');
            fm.expiredate.focus();
            return ;
          }
           if(checktrue2(expiredate)){
          alert('The expiredate can NOT less than today,please input again.');
          fm.expiredate.focus();
          return ;
         }
        }

       var discountdesc=trim(fm.discountdesc.value);
       if(discountdesc==''){
        alert('Please input discount description.');
        fm.discountdesc.focus();
        return;
       }
       if(strlength(discountdesc)>40){
              alert("The discount description is too long,please input again.");
              fm.discountdesc.focus();
              return;
          }
      flag = true;
      return flag;
   }

   function checkfee (fee) {
   	  if(fee.length==0)
			return false;
      var tmp = '';
      for (i = 0; i < fee.length; i++) {
         tmp = fee.substring(i, i + 1);
         if (tmp < '0' || tmp > '9')
            return false;
      }
      return true;
   }

   function checkName () {
      var fm = document.inputForm;
      var code = trim(fm.discountname.value);
      var optype = fm.op.value;
      if(optype=='add'){
        for (i = 0; i < v_discountname.length; i++)
           if (code == v_discountname[i])
             return true;
      }
      else if(optype=='edit'){
         var index = fm.infoList.selectedIndex;
         for (i = 0; i < v_discountname.length; i++)
           if (code == v_discountname[i] && i!=index)
             return true;
      }
	  else if(optype=='del')
	  	return true;
      return false;
   }


   function addInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'add';
      if (checkName()) {
         alert('The discount name exists.Please input again.');
         fm.discountname.focus();
         return;
      }
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please choose the discount to edit first.");
          return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      if (checkName()) {
         alert('The discount name exists.Please input again.');
         fm.discountname.focus();
         return;
      }
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please choose the discount you want to delete first.");
          return;
      }
     if (confirm('Are you sure to delete this discount?') == 0)
     	 return;
     fm.op.value = 'del';
     fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="discount.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="discountid" value="">
<input type="hidden" name="discountindex" value="">
<input type="hidden" name="mode" value="<%= mode %>">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Discount Management</td>
        </tr>
        <tr>
          <td rowspan=10>
            <select name="infoList" size="16" <%= list.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < list.size(); i++) {
                    map1 = (HashMap)list.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)map1.get("discountname") %></option>
<%
            }
%>
            </select>
           </td>
           <td align="right">Discount Name</td>
           <td><input type="text" name="discountname" value="" maxlength="40" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.areaname,'integer')"></td>
         </tr>

         <tr>
            <td align="right"><span title="The number of free ringtones">Ringtones</span></td>
            <td><input type="text" name="freerings" value="" maxlength="20" class="input-style1" ></td>
         </tr>
         <tr>
            <td align="right"><span title="Month rent">Month rent(<%=minorcurrency%>)</span></td>
            <td><input type="text" name="rentfee" value="" maxlength="5" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.outprefix,'integer')"></td>
         </tr>
        <tr style="display:block">
            <td align="right"><span title="Show this discount or not">Show</span></td>
            <td >
                <table border="0" width="100%" class="table-style2">
                  <tr align="center">
                    <td width="50%"><input type="radio" name="isshow" value="0" >No</td>
                    <td width="50%"><input type="radio" name="isshow" value="1" checked >Yes</td>
                  </tr>
                </table>
            </td>
         </tr>

            <tr style="display:block">
            <td align="right"><span title="This discount is enable or not">Enable</span></td>
            <td >
                <table border="0" width="100%" class="table-style2">
                  <tr align="center">
                    <td width="50%"><input type="radio" name="bflag" value="0" >No</td>
                    <td width="50%"><input type="radio" name="bflag" value="1" checked >Yes</td>
                  </tr>
                </table>
            </td>
         </tr>
        <tr>
          <td align="right"><span title="Discount expire date(yyyy.mm.dd)">Expire date(yyyy.mm.dd)</span></td>
          <td><input type="text" name="expiredate" value="" maxlength="10" class="input-style1"></td>
        </tr>
          <tr id="check_id" style="display:none" >
          <td align="right">Check State</td>
          <td><input type="text" name="ischeck" value="" maxlength="10" class="input-style1" readonly="readonly" ></td>
        </tr>
         <tr>
         <td align="right"><span title="Discount description">Description</span></td>
         <td colspan="2">
         <p>
         <textarea name="discountdesc"  rows="3"></textarea>
         </p>
         </td>
         <tr>
            <td colspan="2">
            <table border="0" width="100%" class="table-style2">
            <tr>
                 <td width="25%" align="center"><img src="../manager/button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                 <td width="25%" align="center"><img src="../manager/button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                 <!--<td width="25%" align="center"><img src="../button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>-->
                 <td width="25%" align="center"><img src="../manager/button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td><!--javascript:document.inputForm.reset()-->
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
                    alert( "Please log in to the system!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no access to this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Error in Discount manager!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error in Discount manager!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="discount.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
