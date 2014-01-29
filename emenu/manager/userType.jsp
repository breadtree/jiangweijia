<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Manage subscriber types</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    //法电彩像版本新增
    //String ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia","0");
    String isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage","0");
    // add in 4.11.02
    String ifspecifyusertype = zte.zxyw50.util.CrbtUtil.getConfig("ifspecifyusertype","0");
	 String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	 String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	 String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	 int ratio = Integer.parseInt(currencyratio);
     int  isMobitel = zte.zxyw50.util.CrbtUtil.getConfig("isMobitel",0);
     int  isCMPak = zte.zxyw50.util.CrbtUtil.getConfig("isCMPak",0);
    int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
    String sysTime = "";
    boolean ifGreetingTone =false;
    boolean userTypeCharge = false;
    //ColorRing colorRing = (ColorRing)application.getAttribute("COLORRING");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    zxyw50.Purview purview = new zxyw50.Purview();
    Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
   String subservice="";
   String ifShowMusixBox = zte.zxyw50.util.CrbtUtil.getConfig("ifShowMusixBox", "0");


    try {
        manSysPara syspara = new manSysPara();
        ifGreetingTone = syspara.getIfGreetingTone();
        String charge =syspara.getPara(20109); // 获取20109是否用户类型计费的开关 for starhub in 4.12.02
        if(charge!=null&&charge.trim().equals("1"))
        {
         userTypeCharge =true;
        }
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-5") != null) {

            Vector vet = new Vector();
            ArrayList rList  = new ArrayList();
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String usertype = request.getParameter("usertype") == null ? "" : transferString((String)request.getParameter("usertype")).trim();
            String monthfee = request.getParameter("monthfee") == null ? "" : transferString((String)request.getParameter("monthfee")).trim();
            String monthfee1 = request.getParameter("monthfee") == null ? "" : transferString((String)request.getParameter("monthfee")).trim();
            String customring = request.getParameter("customring") == null ? "" : transferString((String)request.getParameter("customring")).trim();
            String totalring = request.getParameter("totalring") == null ? "" : transferString((String)request.getParameter("totalring")).trim();
            String totalcnum = request.getParameter("totalcnum") == null ? "" : transferString((String)request.getParameter("totalcnum")).trim();
            String totalcnum1 = request.getParameter("totalcnum") == null ? "" : transferString((String)request.getParameter("totalcnum")).trim();
            String blacknum = request.getParameter("blacknum") == null ? "" : transferString((String)request.getParameter("blacknum")).trim();
            String recordprice = request.getParameter("recordprice") == null ? "" : transferString((String)request.getParameter("recordprice")).trim();
            String uploadprice = request.getParameter("uploadprice") == null ? "" : transferString((String)request.getParameter("uploadprice")).trim();
             String uploadprice2 = request.getParameter("uploadprice2") == null ? "" : transferString((String)request.getParameter("uploadprice2")).trim();
            String callinggroups = request.getParameter("callinggroups") == null ? "" : transferString((String)request.getParameter("callinggroups")).trim();
            String callingnumber = request.getParameter("callingnumber") == null ? "" : transferString((String)request.getParameter("callingnumber")).trim();
            String ringgroups = request.getParameter("ringgroups") == null ? "" : transferString((String)request.getParameter("ringgroups")).trim();
            String ringnumber = request.getParameter("ringnumber") == null ? "" : transferString((String)request.getParameter("ringnumber")).trim();
            String favornum = request.getParameter("favornum") == null ? "0" : transferString((String)request.getParameter("favornum")).trim();
            String buytimes = request.getParameter("buytimes") == null ? "0" : transferString((String)request.getParameter("buytimes")).trim();
            String getpasstimes = request.getParameter("getpasstimes") == null ? "0" : transferString((String)request.getParameter("getpasstimes")).trim();
            String utlabel = request.getParameter("utlabel") == null ? "" : transferString((String)request.getParameter("utlabel")).trim();

            // specifyusertype
            String specifyusertype = request.getParameter("specifyusertype") == null ? "" : transferString((String)request.getParameter("specifyusertype")).trim();
            // greeting tone
            String ringid = request.getParameter("ringid") == null ? "0" : transferString((String)request.getParameter("ringid")).trim();
            // 由于传到后台处理需要ringid内容不空
            if(ringid.equals(""))
            {
            ringid ="0";
            }

            //子业务表
            Vector vetSubservice = syspara.getSubService();
                   subservice    = request.getParameter("subservice") == null ? "" : transferString((String)request.getParameter("subservice")).trim();
            String nrentfee      = request.getParameter("nrentfee") == null ? "0" : transferString((String)request.getParameter("nrentfee")).trim();
				String renttype      = request.getParameter("renttype") == null ? "1" : transferString((String)request.getParameter("renttype")).trim();
				String freeday       = request.getParameter("freeday") == null ?  "0" : transferString((String)request.getParameter("freeday")).trim();
				String rentstartdate = request.getParameter("rentstartdate") == null ?"1900.01.01" : transferString((String)request.getParameter("rentstartdate")).trim();


            if("".equals(subservice))
            {
            	//取第一个子业务
            	Hashtable tmpHash = (Hashtable)vetSubservice.get(0);
            	subservice = (String)tmpHash.get("subservice");
            }


            if(checkLen(utlabel,20))
				throw new Exception("The length of subscriber level you entered has exceeded the limit. Please re-enter!");//您输入的用户等级名称长度超出限制,请重新输入!
            String freenum = request.getParameter("freenum")==null?"":transferString((String)request.getParameter("freenum")).trim();
            hash.put("usertype",usertype);
            hash.put("monthfee",monthfee);
            hash.put("monthfee1",monthfee1);
            hash.put("customring",customring);
            hash.put("totalring",totalring);
            hash.put("totalcnum",totalcnum);
            hash.put("totalcnum1",totalcnum1);
            hash.put("blacknum",blacknum);
            hash.put("recordprice",recordprice);
            hash.put("uploadprice",uploadprice);
            hash.put("uploadprice2",uploadprice2);
            hash.put("callinggroups",callinggroups);
            hash.put("callingnumber",callingnumber);
            hash.put("ringgroups",ringgroups);
            hash.put("ringnumber",ringnumber);
            hash.put("utlabel",utlabel);
            hash.put("freenum",freenum);
            hash.put("favornum",favornum);
            hash.put("buytimes",buytimes);
            hash.put("getpasstimes",getpasstimes);

				//增加新属性
				hash.put("subservice",   subservice);
				hash.put("nrentfee",     nrentfee);
				hash.put("renttype",     renttype);
				hash.put("freeday",      freeday);
				hash.put("rentstartdate",rentstartdate);

                                // greeting tone
                                hash.put("ringid",ringid);
                                //
                                hash.put("specifyusertype",specifyusertype);


            String title = "";
            String sDEsc = "";
            if (op.equals("add")) {
                usertype = "";
                rList = syspara.addUserType(hash);
                title = "Add subscriber type:" + utlabel;
                sDEsc = "Add";
                sysInfo.add(sysTime + operName + "Subscriber type added successfully!");//增加用户类型成功
            }
            else if (op.equals("edit")) {
                rList = syspara.editUserType(hash);
                title = "Edit subscriber type:" + utlabel;
                sDEsc = "Edit";
                sysInfo.add(sysTime + operName + "Subscriber type edited successfully!");//Edit用户类型成功
            }
            else if (op.equals("del")) {
                rList = syspara.delUserType(subservice,usertype);
                title = "Delete subscriber type:" + utlabel;
                sDEsc = "Delete";
                sysInfo.add(sysTime + operName + "Subscriber type deleted successfully!");

            }

             // 准备写操作员日志
            if(!op.equals("") && getResultFlag(rList)){
               HashMap map = new HashMap();
               map.put("OPERID",operID);
               map.put("OPERNAME",operName);
               map.put("OPERTYPE","308");
               map.put("RESULT","1");
               map.put("PARA1",usertype);
               map.put("PARA2",utlabel);
               map.put("PARA3",monthfee);
               map.put("PARA4",uploadprice);
               map.put("PARA5",recordprice);
               map.put("PARA6",freenum);
               map.put("PARA7",uploadprice2);               
               map.put("DESCRIPTION","ip:"+request.getRemoteAddr()+",subservice="+subservice);
               purview.writeLog(map);
            }
            if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="userType.jsp?subservice=<%=subservice%>">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
            vet = syspara.getUserTypeInfo(subservice);
%>
<script language="javascript">
   var v_usertype = new Array(<%= vet.size() + "" %>);
   var v_monthfee = new Array(<%= vet.size() + "" %>);
   var v_monthfee1 = new Array(<%= vet.size() + "" %>);
   var v_customring = new Array(<%= vet.size() + "" %>);
   var v_totalring = new Array(<%= vet.size() + "" %>);
   var v_totalcnum = new Array(<%= vet.size() + "" %>);
   var v_totalcnum1 = new Array(<%= vet.size() + "" %>);
   var v_blacknum = new Array(<%= vet.size() + "" %>);
   var v_recordprice = new Array(<%= vet.size() + "" %>);
   var v_uploadprice = new Array(<%= vet.size() + "" %>);
   var v_uploadprice2 = new Array(<%= vet.size() + "" %>);
   var v_callinggroups = new Array(<%= vet.size() + "" %>);
   var v_callingnumber = new Array(<%= vet.size() + "" %>);
   var v_ringgroups = new Array(<%= vet.size() + "" %>);
   var v_ringnumber = new Array(<%= vet.size() + "" %>);
   var v_utlabel = new Array(<%= vet.size() + "" %>);
   var v_freenum = new Array(<%= vet.size() + "" %>);
   var v_favornum = new Array(<%= vet.size() + "" %>);
   var v_buytimes = new Array(<%= vet.size() + "" %>);
   var v_getpasstimes = new Array(<%= vet.size() + "" %>);


   var v_nrentfee      = new Array(<%= vet.size() + "" %>);
   var v_renttype      = new Array(<%= vet.size() + "" %>);
   var v_freeday       = new Array(<%= vet.size() + "" %>);
   var v_rentstartdate = new Array(<%= vet.size() + "" %>);

   var v_ringid        = new Array(<%= vet.size() + "" %>);

<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_usertype[<%= i + "" %>] = '<%= (String)hash.get("usertype") %>';
   v_monthfee[<%= i + "" %>] = '<%= (String)hash.get("monthfee") %>';
   v_monthfee1[<%= i + "" %>] = '<%= (String)hash.get("monthfee1") %>';
   v_customring[<%= i + "" %>] = '<%= (String)hash.get("customring") %>';
   v_totalring[<%= i + "" %>] = '<%= (String)hash.get("totalring") %>';
   v_totalcnum[<%= i + "" %>] = '<%= (String)hash.get("totalcnum") %>';
   v_totalcnum1[<%= i + "" %>] = '<%= (String)hash.get("totalcnum1") %>';
   v_blacknum[<%= i + "" %>] = '<%= (String)hash.get("blacknum") %>';
   v_recordprice[<%= i + "" %>] = '<%= (String)hash.get("recordprice") %>';
   v_uploadprice[<%= i + "" %>] = '<%= (String)hash.get("uploadprice") %>';
   v_uploadprice2[<%= i + "" %>] = '<%= (String)hash.get("uploadprice2") %>';
   v_callinggroups[<%= i + "" %>] = '<%= (String)hash.get("callinggroups") %>';
   v_callingnumber[<%= i + "" %>] = '<%= (String)hash.get("callingnumber") %>';
   v_ringgroups[<%= i + "" %>] = '<%= (String)hash.get("ringgroups") %>';
   v_ringnumber[<%= i + "" %>] = '<%= (String)hash.get("ringnumber") %>';
   v_utlabel[<%= i + "" %>] = '<%= (String)hash.get("utlabel") %>';
   v_freenum[<%= i + ""%>] = '<%= (String)hash.get("freenum")%>';
   v_favornum[<%= i + ""%>] = '<%= (String)hash.get("favornum")%>';
   v_buytimes[<%= i + ""%>] = '<%= (String)hash.get("buytimes")%>';
   v_getpasstimes[<%= i + ""%>] = '<%= (String)hash.get("getpasstimes")%>';

   v_nrentfee[<%= i + ""%>]      = '<%= (String)hash.get("nrentfee")%>';
   v_renttype[<%= i + ""%>]      = '<%= (String)hash.get("renttype")%>';
   v_freeday[<%= i + ""%>]       = '<%= (String)hash.get("freeday")%>';
   v_rentstartdate[<%= i + ""%>] = '<%= (String)hash.get("rentstartdate")%>';

   v_ringid[<%= i + ""%>] = '<%= (String)hash.get("ringid")%>';

<%
            }
%>

    function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '') {
        // fm.monthfee.focus();
         return;
      }
      fm.usertype.value = v_usertype[index];
      fm.monthfee.value = v_monthfee[index];
      fm.monthfee1.value = v_monthfee1[index];
      fm.customring.value = v_customring[index];
      fm.totalring.value = v_totalring[index];
      fm.totalcnum.value = v_totalcnum[index];
      fm.totalcnum1.value = v_totalcnum1[index];
      fm.blacknum.value = v_blacknum[index];
      fm.recordprice.value = v_recordprice[index];
      fm.uploadprice.value = v_uploadprice[index];
       fm.uploadprice2.value = v_uploadprice2[index];
      fm.callinggroups.value = v_callinggroups[index];
      fm.callingnumber.value = v_callingnumber[index];
      fm.ringgroups.value = v_ringgroups[index];
      fm.ringnumber.value = v_ringnumber[index];
      fm.utlabel.value = v_utlabel[index];
      fm.freenum.value = v_freenum[index];
      fm.favornum.value = v_favornum[index];
      fm.buytimes.value = v_buytimes[index];
      fm.getpasstimes.value = v_getpasstimes[index];


      fm.nrentfee.value      = v_nrentfee[index];
      var isCmpak=<%=String.valueOf(isCMPak)%>
      var ifShowMusixBox=<%=ifShowMusixBox%>
      if(v_renttype[index]==1)
      	fm.renttype[0].checked = true;
      else  if(v_renttype[index]==2)
       	fm.renttype[1].checked = true;
      else  if(isCmpak==1&& v_renttype[index]==4)
    	  fm.renttype[2].checked = true;
      else  if(isCmpak==1&& v_renttype[index]==11 && ifShowMusixBox==1)
    	  fm.renttype[3].checked = true;
      else  if(isCmpak==1&& v_renttype[index]==12&&ifShowMusixBox==1)
    	  fm.renttype[4].checked = true;

      fm.freeday.value       = v_freeday[index];

      fm.freemonth.value    = parseInt((fm.freeday.value)/30);


      fm.rentstartdate.value = v_rentstartdate[index];

      fm.ringid.value = v_ringid[index];
   //   fm.monthfee.focus();
   }

	function selectSub()
	{
	 	var fm = document.inputForm;
	 	if(fm.subservice.value=='<%=subservice%>')
	 		return false;
		fm.submit();
	}


   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var tmp;
      tmp = trim(fm.monthfee.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The monthly rental can only be a digital number!');//月租费只能为数字
         fm.monthfee.focus();
         return flag;
      }
      if(tmp<0){
         alert('The monthly rental cannot be negative!');//月租费不能为负数
         fm.monthfee.focus();
         return flag;
      }
      tmp = trim(fm.customring.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The number of ringtones to be customized can only be a digital number!');//可定制铃声数目只能为数字
         fm.customring.focus();
         return flag;
      }
      tmp = trim(fm.totalring.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The number of available ringtones can only be a digital number!');//可使用铃声数目只能为数字
         fm.totalring.focus();
         return flag;
      }
      tmp = trim(fm.totalcnum.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The number of time length that can be set can only be a digital number!');//可设主叫号码数目只能为数字
         fm.totalcnum.focus();
         return flag;
      }
      tmp = trim(fm.blacknum.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The number of blacklists that can be set can only be a digital number!');//可设黑名单数目只能为数字
         fm.blacknum.focus();
         return flag;
      }
      tmp = trim(fm.recordprice.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The price of a subscriber-recorded ringtone can only be a digital number!');//自录铃音价格只能为数字
         fm.recordprice.focus();
         return flag;
      }
      tmp = trim(fm.uploadprice.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The price of an uploaded ringtone can only be a digital number!');//上传铃音价格只能为数字
         fm.uploadprice.focus();
         return flag;
      }
       tmp = trim(fm.uploadprice2.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The price of an uploaded ringtone can only be a digital number!');//上传铃音价格只能为数字
         fm.uploadprice.focus();
         return flag;
      }
      tmp = trim(fm.callinggroups.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The number of calling number groups can only be a digital number!');//主叫号码组数只能为数字
         fm.callinggroups.focus();
         return flag;
      }
      tmp = trim(fm.callingnumber.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The number of calling number group members can only be a digital number!');//主叫号码组成员数量只能为数字
         fm.callingnumber.focus();
         return flag;
      }
      tmp = trim(fm.ringgroups.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The number of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> groups can only be a digital number!');//铃音组数只能为数字
         fm.ringgroups.focus();
         return flag;
      }
      tmp = trim(fm.ringnumber.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The number of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group members can only be a digital number!');//铃音组成员数量只能为数字
         fm.ringnumber.focus();
         return flag;
      }
      tmp = trim(fm.favornum.value);
       if (tmp == '') {
         alert("The number of favitor ring can't be null");
         fm.favornum.focus();
         return flag;
      }
      if (!checkstring('0123456789',tmp) ) {
         alert('The number of favitor ring can only be a digital number!');
         fm.favornum.focus();
         return flag;
      }

      tmp = trim(fm.buytimes.value);
       if (tmp == '') {
         alert("The max-number of day's ring back tone orders can't be null");
         fm.buytimes.focus();
         return flag;
      }
      if (!checkstring('-0123456789',tmp) ) {
         alert("The number of day's ring back tone orders can only be a digital number!");//日订购铃音最大次数只能为数字!
         fm.buytimes.focus();
         return flag;
      }

      tmp = trim(fm.getpasstimes.value);
      if (tmp == '') {
         alert("The max-number of get password in one day can't be null");//日获取密码最大次数不能为空!
         fm.getpasstimes.focus();
         return flag;
      }
      if (!checkstring('-0123456789',tmp) ) {
         alert('The number of get password in one day can only be a digital number!');//日获取密码最大次数只能为数字
         fm.getpasstimes.focus();
         return flag;
      }
      if (trim(fm.utlabel.value) == '') {
         alert('Please enter the name of subscriber type!');//请输入用户类型名称
         fm.utlabel.focus();
         return flag;
      }
      if (!CheckInputStr(fm.utlabel,'name of subscriber type')){
         fm.utlabel.focus();
         return flag;
      }
       <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.utlabel.value,20)){
            alert("The name of subscriber type should not exceed 20 bytes!");
            fm.utlabel.focus();
            return;
          }


        <%
        }
        %>
      tmp = trim(fm.freenum.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The number of free presented ringtones can only be a digital number!');//免费赠送铃音条数只能为数字
         fm.freenum.focus();
         return flag;
      }

      //新加的判断
      tmp = trim(fm.nrentfee.value);
      if (tmp == '') {
         alert('The next monthly rental cannot be null!');//下月租费数不能为空!
         fm.nrentfee.focus();
         return flag;
      }
      if (!checkstring('0123456789',tmp) ) {
         alert('The next monthly rental must be a digital number!');//下月租费必须为数字!
         fm.nrentfee.focus();
         return flag;
      }
      if(fm.renttype.value == '')
      	fm.renttype.value ='1';

      tmp = trim(fm.freemonth.value);
      if (tmp == '') {
         alert('The free month cannot be null!');//免费日期不能为空!
         fm.freemonth.focus();
         return flag;
      }
      if (!checkstring('0123456789',tmp) ) {
         alert('The free month should be a digital number!');//免费日期必须为数字!
         fm.freemonth.focus();
         return flag;
      }
      tmp = tmp *30;
      fm.freeday.value = tmp;


      if (trim(fm.rentstartdate.value) == '') {
      	 //alert('请输入开始收租日期!');
         alert("Please input the start rent date!");
         fm.rentstartdate.focus();
         return false;
      }
      if (! checkDate2(fm.rentstartdate.value)) {
        //alert('开始收租日期输入错误,\r\n请按YYYY.MM.DD输入起始时间!');
        alert("Start rent date input error,\r\n please input start time in the YYYY.MM.DD format!");
        fm.rentstartdate.focus();
         return false;
      }



      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      <%if(ifspecifyusertype.equals("1")){%>
        if (trim(fm.specifyusertype.value) == '') {
         alert("Please input the specify user type");
         fm.specifyusertype.focus();
         return false;
      }
       if (!checkstring('0123456789',trim(fm.specifyusertype.value)) ) {
         alert('The specify user type should be a digital number!');//免费日期必须为数字!
         fm.specifyusertype.focus();
         return false;
      }
      for (i = 0; i < v_usertype.length; i++){
        if (trim(fm.specifyusertype.value) == v_usertype[i])
        {
        alert('The user type specified exists, please specify another value');
         return false;
        }
      }
    <%}%>
      if (! checkInfo())
         return;
      fm.op.value = 'add';
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
	  if (trim(fm.usertype.value) == '') {
         alert('Please select the subscriber type to Edit!');//请先选择要删除的用户类型
         return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      fm.submit();
   }

  function delInfo () {
      var fm = document.inputForm;
      if (trim(fm.usertype.value) == '') {
         alert('Please select the subscriber type to be deleted!');//请先选择要删除的用户类型
         return;
      }
      fm.op.value = 'del';
      fm.submit();
   }

   function queryInfo() {
     var result =  window.showModalDialog('greetingToneSearch.jsp',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
       document.inputForm.ringid.value=result;
     }
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="800";
</script>
<form name="inputForm" method="post" action="userType.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="freeday" value="">

<table width="440" height="400" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Sub service type</td>
        </tr>
        <tr>
          <td colspan="3" align="center">
          	<select name="subservice" size="1" <%= vetSubservice.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectSub()">
<%
                for (int i = 0; i < vetSubservice.size(); i++) {
                    hash = (Hashtable)vetSubservice.get(i);
                  //法电彩像版本在此处增加判断
                  if(isimage.equals("0") && ((String)hash.get("subservice")).trim().equals("16"))
                      continue;
%>
              <option value="<%=(String)hash.get("subservice") %>"
              <%=((String)hash.get("subservice")).equals(subservice)?" selected ":""%>
              ><%= (String)hash.get("description") %></option>
<%
            }
%>
            </select>
          </td>
        </tr>

        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">User type management</td>
        </tr>
        <tr>
        <%
          int rows = 24;
         if(userTypeCharge)
           rows= 23;
        %>
          <td rowspan="<%=rows%>" valign="top">
            <select name="infoList" size="34" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Hashtable)vet.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)hash.get("utlabel") %></option>
<%
            }
%>
            </select>
          </td>
          <td height="22" align="right">User type</td>
          <td height="22"><input type="text" name="usertype" value="" maxlength="6" readonly="readonly" class="input-style1" ></td>
        </tr>
         <%
          String chargeDisplay = "";
        if(userTypeCharge) // only called can set greeting tone
           chargeDisplay="none";
        %>
        <tr style="display:<%= chargeDisplay %>">
          <td height="22" align="right">Rental(<%=minorcurrency%>)</td>
          <td height="22"><input type="text" name="monthfee" value="" maxlength="9" class="input-style1" ></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="Upload/self ringtone number">Upload/self number</span></td>
          <td height="22"><input type="text" name="customring" value="" maxlength="5" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="Ringtone number that can be used">Available number</span></td>
          <td height="22"><input type="text" name="totalring" value="" maxlength="5" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="Ringtone number that can be set">Setting number</span></td>
          <td height="22"><input type="text" name="totalcnum" value="" maxlength="5" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="Ringtone number that can be set in blacklist">Blacklist number</span></td>
          <td height="22"><input type="text" name="blacknum" value="" maxlength="5" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="Price of self-record ringtone (<%=minorcurrency%>)">Self-Record price</span></td>
          <td height="22"><input type="text" name="recordprice" value="" maxlength="9" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="Price of uploaded ringtone (<%=minorcurrency%>)">Upload price</span></td>
          <td height="22"><input type="text" name="uploadprice" value="" maxlength="9" class="input-style1"></td>
        </tr>
        <%if(sysfunction.get("2-71-0")== null){%>
        <tr>
          <td height="22" align="right"><span title="Price of uploaded ringtone (<%=minorcurrency%>)">Video price</span></td>
          <td height="22"><input type="text" name="uploadprice2" value="" maxlength="9" class="input-style1"></td>
        </tr>
		<!-- Added for Montnegro by Srinivas on 29-03-2011-->
	  <% }else {%> 
		<input type="hidden" name="uploadprice2" value="0">
		<!-- End of added-->
		<%} %>
        <tr>
          <td height="22" align="right"><span title="Number of calling number groups">Calling number groups</span></td>
          <td height="22"><input type="text" name="callinggroups" value="" maxlength="3" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="Number of calling number group members">Calling number group members</span></td>
          <td height="22"><input type="text" name="callingnumber" value="" maxlength="3" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="Number of ringtone groups"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> groups</span></td>
          <td height="22"><input type="text" name="ringgroups" value="" maxlength="3" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="Number of ringtone group members"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group members</span></td>
          <td height="22"><input type="text" name="ringnumber" value="" maxlength="3" class="input-style1"></td>
        </tr>
       <tr>
          <td height="22" align="right"><span title="Number of presented ringtones free of charge">Free present</span></td>
          <td height="22"><input type="text" name="freenum" value="" maxlength="2" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="The number of favorite ringtone">Favorite num.</span></td>
          <td height="22"><input type="text" name="favornum" value="" maxlength="2" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="The max-number of day's ringtone orders">Day order num.</span></td>
          <td height="22"><input type="text" name="buytimes" value="" maxlength="6" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="The max-number of get password in one day">Day get password</span></td>
          <td height="22"><input type="text" name="getpasstimes" value="" maxlength="6" class="input-style1"></td>
        </tr>
	 <tr>
          <td height="22" align="right"><span title="Name of subscriber type">Usertype Name</span></td>
          <td height="22"><input type="text" name="utlabel" value="" maxlength="20" class="input-style1"></td>
        </tr>
	 <tr style="display:none">
          <td height="22" align="right"><span title="Calling subscriber monthly rental(<%=minorcurrency%>)">Calling monthly rental</span></td>
          <td height="22"><input type="text" name="monthfee1" value="" maxlength="9" class="input-style1" ></td>
        </tr>
	 <tr style="display:none">
          <td height="22" align="right"><span title="Calling subscriber ringtone number that can be setting">Calling set num.</span></td>
          <td height="22"><input type="text" name="totalcnum1" value="" maxlength="5" class="input-style1" ></td>
        </tr>


         <tr style="display:<%= chargeDisplay %>">
          <td height="22" align="right">Next monthly rental</td>
          <td height="22"><input type="text" name="nrentfee" value="" maxlength="9" class="input-style1"></td>
   	</tr>
		<tr>
          <td height="22" align="right"><span title="Rental type,Monthly rental or Daily rental">Rental type</span></td>
          <td height="22">
           <%String rent="";
            if(isMobitel == 1){
            rent = "disabled";}%>
          	<input type="radio" name="renttype" value="1" <%=rent%>><font class="text-default">Monthly</font>
            <input type="radio" name="renttype" value="2" <%=rent%>><font class="text-default">Daily</font>
           <% if (isCMPak==1){  %>
              <input type="radio" name="renttype" value="4" ><font class="text-default">Quarterly</font>
	      <% if(ifShowMusixBox.equals("1")){%>
		<input type="radio" name="renttype" value="11" ><font class="text-default">JukeBox 1 User</font><br/>
		<input type="radio" name="renttype" value="12" ><font class="text-default">JukeBox 3 User</font>
	      <%}%>
           <%}%>
          </td>
   	</tr>
   	<tr>
          <td height="22" align="right">Free month</td>
          <td height="22"><input type="text" name="freemonth" value="" maxlength="20" class="input-style1"></td>
   	</tr>
   	<tr>
          <td height="22" align="right">Start date to rent</td>
          <td height="22"><input type="text" name="rentstartdate" value="" maxlength="20" class="input-style1"></td>
   	</tr>
        <%
          String usertypeDisplay = "none";
        if(ifspecifyusertype.equals("1"))
           usertypeDisplay="";
        %>
        <tr style="display:<%= usertypeDisplay %>">
          <td height="22" align="right">Specify user type while add</td>
          <td height="22"><input type="text" name="specifyusertype" value="" maxlength="9" class="input-style1"></td>
   	</tr>
         <%
          String isDisplay = "none";
        if(ifGreetingTone&&subservice.equals("1")) // only called can set greeting tone
           isDisplay="";
        %>
        <tr style="display:<%= isDisplay %>">
          <td height="22" align="right">Greeting Tone code</td>
          <td height="22"><input type="text" name="ringid"  readonly="readonly" value="" maxlength="20" class="input-style1"><img src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo()">
          </td>
   	</tr>

        <tr align="center">
          <td colspan="3">
            <table border="0" width="100%" class="table-style2">
              <tr align="center">
               <td width="25%" align="center" style="display:<%= chargeDisplay %>"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                <%if(isMobitel == 0){%>
                <td width="25%" align="center" style="display:<%= chargeDisplay %>"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
               <%}%>
                <td width="25%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td colspan="3" > <table border="0" width="100%" class="table-style2">
              <tr><td height=10 > &nbsp;&nbsp;</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;Notes:</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. The modified month-rent will take effect in NEXT month.</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. The max-number of day's ringtone orders,-1:No limit,0:Means can't order;</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. The max-number of getting password in one day,-1:No limit,0:Means can't get password;</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. Cannot modify rental type when modify user type.</td></tr>
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
                    alert( "Please log in to the system first!");//Please log in to the system
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
        sysInfo.add(sysTime + operName + "Exception occurred in managing subscriber types!");//用户类型管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing subscriber types!");//用户类型管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="userType.jsp?subservice=<%=subservice%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
