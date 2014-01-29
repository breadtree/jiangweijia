<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SpManage" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.zxywpub.*" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String DIYmscBoxDisp =zte.zxyw50.util.CrbtUtil.getDbStr(request,"DIYmscBoxDisp","DIY Music Box");
%>
<html>
<head>
<title>Manage <%=DIYmscBoxDisp%></title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    //String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
    int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
    String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
    String musicbox  = CrbtUtil.getConfig("ringBoxName","DIY Music Box");
	String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");

    String musicgrpoper = CrbtUtil.getConfig("musicgrpoper","1");
    String musicvaliddate = CrbtUtil.getConfig("musicvaliddate","0");
    String musicprice = CrbtUtil.getConfig("musicprice","0");
    String musicringnum = CrbtUtil.getConfig("musicringnum","0");
    String sysringgrpcheck = "0";
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String SpModSysRingGrpPrice =(String)application.getAttribute("SpModSysRingGrpPrice")==null?"0":(String)application.getAttribute("SpModSysRingGrpPrice");

	
    // Modified by Suman, 17-July-2009. Description: To solve the session problem when the user login in Manager as well as SP from the same ie with different tabs.
    //String operName = (String)session.getAttribute("OPERNAME");
    //String spCode = (String)session.getAttribute("SPCODE"); 
    //String spIndex = (String)session.getAttribute("SPINDEX"); // TO-DO Where do we actually set this SPINDEX ?
    String spCode = (String)session.getAttribute("SPCODE_Manager");
    String spIndex = (String)session.getAttribute("SPINDEX_Manager");
    String operName = (String)session.getAttribute("OPERNAME_Manager");


	 manSysPara  syspara1 = new manSysPara();
     ArrayList spInfo = syspara1.getSPInfo();

    // Modification end: Suman 

	String sisdefaultringprice = "0";
	String smusicboxfixedprice = "";

	session.removeAttribute("RINGGROUP");
	session.removeAttribute("GROUPLABEL");
    HashMap opmap = new HashMap();
    String m1="0",m2="0",m3="0"; // TO-DO can remove these and use 'curcnt' variable for max no of rings allowed for DIY Musicbox. 

    try {
        SpManage sysring = new SpManage();
         manSysPara syspara = new manSysPara();
		 manSysRing ring1 = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
		Vector ringLibrary = ring1.getRingLibraryInfo();
        if (operID != null && (purviewList.get("2-42") != null)) { 
			//TO-DO Add purviewList.get() cto the above If condition:  purviewList.get("10-7") != null
			// Added by Suman Gonuguntla, 18-Feb-2009, V4.22.01(M1), ZTE India R&D Center, Bangalore.
			Hashtable spInfoHash = new Hashtable();
			// TO-DO getting SPInfo...
			spInfoHash = sysring.getSPConf("0"); //spIndex
			sisdefaultringprice = spInfoHash.get("isdefaultringprice").toString();
			smusicboxfixedprice = spInfoHash.get("musicboxfixedprice").toString();
			// End of modification by Suman Gonuguntla
            HashMap map2 = new HashMap();
            map2 = syspara.getSysRingGrpParaInfo();
            if(map2!=null)
            {
               m1=map2.get("m1")==null?"0":(String)map2.get("m1");
               m2=map2.get("m2")==null?"0":(String)map2.get("m2");
               m3=map2.get("m3")==null?"0":(String)map2.get("m3");
            }
            ArrayList list  = new ArrayList();
            HashMap map1 = new HashMap();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String grouplabel = request.getParameter("grouplabel") == null ? "" : transferString((String)request.getParameter("grouplabel")).trim();
            
			if(checkLen(grouplabel,40))
            	throw new Exception("DIY Music Box name is too long,please re-enter the name for your DIY Music Box!");

            String ringcnt = request.getParameter("ringcnt") == null ? "0" : transferString((String)request.getParameter("ringcnt")).trim();
            
			if(ringcnt.trim().equals(""))
               ringcnt = "0";

            if(musicringnum.trim().equalsIgnoreCase("1"))
               ringcnt = m2 ; // TO-DO setting default ringcount for DIY Musicbox

            String ringfee = request.getParameter("ringfee") == null ? "0" : transferString((String)request.getParameter("ringfee")).trim();

	    String sp_code = request.getParameter("sp_code") == null ? "00" : transferString((String)request.getParameter("sp_code")).trim();
	    String sp_index = request.getParameter("sp_index") == null ? "0" : transferString((String)request.getParameter("sp_index")).trim();
            String isshow  = request.getParameter("isshow") == null ? "0" : transferString((String)request.getParameter("isshow")).trim();
			String cataindex  = request.getParameter("cataindex") == null ? "1" : transferString((String)request.getParameter("cataindex")).trim();
            if(isshow.trim().equals(""))
               isshow = "0";
            String validdate = request.getParameter("validdate")==null?"":(String)request.getParameter("validdate");
            if(musicvaliddate.trim().equalsIgnoreCase("1")&&!validdate.trim().equalsIgnoreCase(""))
            {
             Calendar ca = new GregorianCalendar(Integer.parseInt(validdate.substring(0,4)),Integer.parseInt(validdate.substring(5,7))-1,1);
             validdate = validdate+"."+ca.getActualMaximum(ca.DAY_OF_MONTH);
            }
            String ringgroup = request.getParameter("ringgroup") == null ? "" : transferString((String)request.getParameter("ringgroup")).trim();
            String description = request.getParameter("description") == null ? "" : transferString((String)request.getParameter("description")).trim();
            String title = "";
            ArrayList rList = new ArrayList();
            int  optype = 0;
            if (op.equals("add")){
                isshow = "1";
                optype = 0;
                title = "Add "+DIYmscBoxDisp+":"+grouplabel;
            }
            if (op.equals("edit")){
                optype = 2;
                title = "Edit "+DIYmscBoxDisp+":"+grouplabel;
            }
            else if (op.equals("del")) {
                optype = 1;
                title = "Delete "+DIYmscBoxDisp+":"+grouplabel;
            }else if(op.equals("publish")){
                optype = 3;
                title = "Issues "+DIYmscBoxDisp+":"+grouplabel;
            }
            if(!op.equals("")){
            	map1.put("spcode",sp_code);
		map1.put("sp_index",sp_index);
		map1.put("grouptype","3");
            	map1.put("grouplabel",grouplabel);
                map1.put("ringcnt",ringcnt);
                map1.put("ringfee",ringfee);
                map1.put("isshow",isshow);
                map1.put("validdate",validdate );
                map1.put("ringgroup",ringgroup);
				map1.put("cataindex",cataindex);
                map1.put("description",description);
				// TO-DO- need to add ringgrptype and new cataindex value (selected category index value) to map1 for add operation
                int ischeckop = 0 ,grpcheck=0;
                ischeckop = sysring.getSpOperischeck(spIndex);
                grpcheck = sysring.getMusiccheckStatus(spIndex,ringgroup);
                if(ischeckop>0&&grpcheck>0)
                   sysringgrpcheck = "1";
    			if(optype==0) //add 
				{
    			    rList=sysring.addNewSysRingGroup(3,map1);
                }
				else if(optype==1) //delete
                {
                    if(sysringgrpcheck.equalsIgnoreCase("0"))
                    {
    				 	rList=sysring.delSysRingGroup(ringgroup);
                    }else{
                        String mess="";
                        manSysRing manring = new manSysRing();
                        ArrayList ls = null;
                        Hashtable tmp = null;
                        opmap.put("operid",spIndex);
                        opmap.put("opername",operName);
                        opmap.put("opertype","101");
                        opmap.put("status","0");
                        opmap.put("ringid","");
                        opmap.put("operdesc","");
                        opmap.put("refusecomment","");
                        opmap.put("ringfee",ringfee);
                        opmap.put("ringlabel",grouplabel);
                        opmap.put("singgername","");
                        opmap.put("validdate",validdate);
                        opmap.put("ringspell","");
                        opmap.put("uservalidday","0");
                        opmap.put("ringgroup",ringgroup);
                        opmap.put("ringidnew","");
                        opmap.put("ringcnt",ringcnt);
                        opmap.put("cataindex",cataindex); 
                        ls = manring.addoperCheck(opmap);
						// TO-Do do we need to pass cataindex or anyother values to opmap in this case?
                        rList = ls ;
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
                        <%
						if(!mess.trim().equalsIgnoreCase("")){%>
                              window.alert('<%=mess%>');
                        <%}%>
                        window.returnValue = "yes";
                        </script>
                        <%
                    }
                }
				else if(optype==2) //edit
                {
                     if(sysringgrpcheck.equalsIgnoreCase("0"))
                     {
    				 	 rList=sysring.modSysRingGroup(map1);
                     }else{
                         String mess="";
                         manSysRing manring = new manSysRing();
                         ArrayList ls = null;
                         Hashtable tmp = null;
                         opmap.put("operid",spIndex);
                                       opmap.put("opername",operName);
                                       opmap.put("opertype","100");
                                       opmap.put("status","0");
                                       opmap.put("ringid","");
                                       opmap.put("operdesc","");
                                       opmap.put("refusecomment","");
                                       opmap.put("ringfee",ringfee);
                                       opmap.put("ringlabel",grouplabel);
                                       opmap.put("singgername","");
                                       opmap.put("validdate",validdate);
                                       opmap.put("ringspell","");
                                       opmap.put("uservalidday","0");
                                       opmap.put("ringgroup",ringgroup);
                                       opmap.put("ringidnew","");
                                       opmap.put("ringcnt",ringcnt);
                                       opmap.put("isshow",isshow);
									   opmap.put("cataindex",cataindex);
									   // TO-Do Need to add spindex and cataindex value to above opmap
                                       ls = manring.addoperCheck(opmap);
                                       rList = ls ;
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
				else if(optype==3) // publish
                {
                     rList = sysring.publishRingGroup(ringgroup);
                }

				if(getResultFlag(rList)){
                  zxyw50.Purview purview = new zxyw50.Purview();
                  HashMap map = new HashMap();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","1007");
                  map.put("RESULT","1");
                  map.put("PARA1",ringgroup);
                  map.put("PARA2",grouplabel);
                  map.put("PARA3",ringcnt);
                  map.put("PARA4","ip:"+request.getRemoteAddr());
                  map.put("DESCRIPTION",title);
                  purview.writeLog(map);
                }

                if(rList.size()>0){
                   session.setAttribute("rList",rList);
                   %>
                   <form name="resultForm" method="post" action="result.jsp">
                   <input type="hidden" name="historyURL" value="diyMusicbox.jsp">
                   <input type="hidden" name="title" value="<%= title %>">
                   <script language="javascript">
                   <%if(sysringgrpcheck.equalsIgnoreCase("0")){%>
                          document.resultForm.submit();
                   <%}%>
                   </script>
                   </form>
                   <%
                }
            }

            //get the DIY Music Box data
            //list = sysring.getSysRingGroup(spIndex,3);
			list = sysring.getSysRingGroup("",3);
			// To-Do Need to get ringgrptype, currcount and cataindex values from above method

%>
<script language="javascript">
	var datasource;
   var v_ringgroup = new Array(<%= list.size() + "" %>);
   var v_grouplabel = new Array(<%= list.size() + "" %>);
   var v_sp_code    = new Array(<%= list.size() + "" %>);  // Added on 19-Aug-2009,
   var v_ringcnt     = new Array(<%= list.size() + "" %>);
   var v_ringfee     = new Array(<%= list.size() + "" %>);
   var v_isshow  = new Array(<%= list.size() + "" %>);
   var v_validdate  = new Array(<%= list.size() + "" %>);
   var v_updatetime  = new Array(<%= list.size() + "" %>);
   var v_description  = new Array(<%= list.size() + "" %>);
   var v_cataindex  = new Array(<%= list.size() + "" %>);
   var v_ringlibid  = new Array(<%= list.size() + "" %>);
   var v_curcnt  = new Array(<%= list.size() + "" %>);

      var v_ischeck  = new Array(<%= list.size() + "" %>);
<%
            for (int i = 0; i < list.size(); i++) {
                map1 = (HashMap)list.get(i);
          	String modifytime=((String)map1.get("modifytime")).trim();
          	String addtime=((String)map1.get("addtime")).trim();
          	String deletetime=((String)map1.get("deletetime")).trim();
          	if(modifytime.compareTo(addtime)<0)modifytime=addtime;
          	if(modifytime.compareTo(deletetime)<0)modifytime=deletetime;
%>
   v_ringgroup[<%= i + "" %>] = '<%= (String)map1.get("ringgroup") %>';
   v_grouplabel[<%= i + "" %>] = '<%= (String)map1.get("grouplabel") %>';
   v_sp_code[<%= i + "" %>] = '<%= (String)map1.get("sp_code") %>';    // Added on 19-Aug-2009
   v_ringcnt[<%= i + "" %>] = '<%= (String)map1.get("ringcnt") %>';
   v_ringfee[<%= i + "" %>] = '<%= (String)map1.get("ringfee") %>';
   v_isshow[<%= i + "" %>] = '<%= (String)map1.get("isshow") %>';
   v_validdate[<%= i + "" %>] = '<%= (String)map1.get("validdate") %>';
   v_updatetime[<%= i + "" %>] = '<%= modifytime %>';
   v_description[<%= i + "" %>] = "<%= JspUtil.convert((String)map1.get("description"))%>";
   v_ischeck[<%= i + "" %>] = '<%= (String)map1.get("ischeck") %>';
   v_cataindex[<%= i + "" %>] = '<%= (String)map1.get("cataindex") %>';
   v_ringlibid[<%= i + "" %>] = '<%= (String)map1.get("ringlibid") %>';
   v_curcnt[<%= i + "" %>] = '<%= (String)map1.get("curcnt") %>';
<%
            }
%>
//========== Category Related Code START ========
//TO-DO
 //modify by gequanmin 2005-07-05

   datasource = new Array(<%=ringLibrary.size()+1%>);
 
  var root = new Array("0","-1","All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category","0","0");//全部铃音类别
  datasource[0] = root;
  <%
   for(int j= 0;j<ringLibrary.size();j++){
      Hashtable table = (Hashtable)ringLibrary.get(j);
    %>
     var data = new Array('<%=(String)table.get("ringlibid")%>','<%=((String)table.get("parentidnex"))%>','<%=(String)table.get("ringliblabel")%>','<%=(String)table.get("isleaf")%>','<%=(String)table.get("allindex")%>');
      datasource[<%=j+1%>] = data;
    <%}%>
// ========== Category Related Code END ===========

//document.inputForm.ringfee.readOnly=false;
   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '')
         return;
      fm.grouplabel.value = v_grouplabel[index];
      //fm.isshow[v_isshow[index]].checked = true;
      fm.isshow.value=v_isshow[index];
      if(trim(v_isshow[index])=='1')
        fm.isshow1.innerText='Yes';
      else
        fm.isshow1.innerText='No';
      fm.ringfee.value = v_ringfee[index];
      <%if(SpModSysRingGrpPrice.equals("0")){%>
        fm.ringfee.readOnly=true;
      <%}%>
      fm.ringgroup.value = v_ringgroup[index];
      fm.sp_code.value = v_sp_code[index];   // Added on 19-Aug-2009
      fm.ringcnt.value = v_ringcnt[index];
      fm.validdate.value = v_validdate[index];
      fm.updatetime.value= v_updatetime[index];
      fm.description.value = v_description[index];
      fm.icheck.value=v_ischeck[index];
	  fm.cataindex.value=v_cataindex[index];
	  var name = getRingLibbyIndex(v_cataindex[index]);
      document.inputForm.ringcatalog.value=name;
      changeSpIndex();
      fm.grouplabel.focus();

   }

  function changeSpIndex(){
      var fm = document.inputForm;
      fm.sp_index.selectedIndex = fm.sp_code.selectedIndex;
  }

  function mpublish()
  {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select <%=DIYmscBoxDisp%> you want to issues.");
          return;
      }
      if(trim(fm.icheck.value)!='3')
      {
          alert("You can't issues <%=DIYmscBoxDisp%> again.");
          return;
      }
      fm.op.value = 'publish';
      fm.submit();
  }

  function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.grouplabel.value) == '') {
         alert('Please enter the name of <%=DIYmscBoxDisp%>.');
         fm.grouplabel.focus();
         return flag;
      }
      if (!CheckInputStr(fm.grouplabel,'name of <%=DIYmscBoxDisp%>')){
         fm.grouplabel.focus();
         return flag;
      }
      if (!CheckInputStr(fm.description,'description')){
         fm.description.focus();
         return flag;
      }
      <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.grouplabel.value,40)){
            alert("The <%=DIYmscBoxDisp%> name should not exceed 40 bytes!");
             fm.grouplabel.focus();
            return;
          }
        <%
        }
        %>
<%if(!musicringnum.trim().equalsIgnoreCase("1")){%>
		 if (! checkfee(trim(fm.ringcnt.value))) {
         alert("The number in the <%=DIYmscBoxDisp%> is wrong!");
         fm.ringcnt.focus();
         return;
      }
<%}%>
      <% //TO-DO Below code need to be cleaned. Max/Min/Cur no of ringtones have to be confirmed.
	if(musicringnum.trim().equalsIgnoreCase("0")
          &&(!m2.trim().equalsIgnoreCase("0")||!m3.trim().equalsIgnoreCase("0"))){%>
         var maxNum = <%=m2.trim()%>;
         var minNum = <%=m3.trim()%>;
         var curNum = trim(fm.ringcnt.value);
         if(eval(curNum+'-'+minNum)<0||eval(curNum+'-'+maxNum)>0)
         {
         alert("The ringtone number in the <%=DIYmscBoxDisp%> should be between "+minNum+" - "+maxNum+" !");
         fm.ringcnt.focus();
         return;
        }
      <%}%>
      if (! checkfee(trim(fm.ringfee.value))) {
         alert("The price of <%=DIYmscBoxDisp%> is wrong!");
         fm.ringfee.focus();
         return;
      }
      <%if(!"0".equalsIgnoreCase(m1.trim())){%>
         var maxPrice = <%=m1.trim()%>;
         var curPrice = trim(fm.ringfee.value);
         if(eval(maxPrice+'-'+curPrice)<0)
         {
           alert("The <%=DIYmscBoxDisp%> price surpasses the system upper limit!");
           fm.ringfee.focus();
           return ;
         }
      <%}%>
      <%if("1".equalsIgnoreCase(musicprice.trim())){%>
          var vprice = trim(fm.ringfee.value);
          if(vprice%50!=0||vprice==0)
          {
            alert("The <%=DIYmscBoxDisp%> price should be 50 multiples");
            fm.ringfee.focus();
            return;
          }
      <%}%>
   	var validdate = trim(fm.validdate.value);
      if(validdate==''){
          alert("Please enter the validate of <%=DIYmscBoxDisp%>!");//请输入音乐盒有效期!
          fm.validdate.focus();
          return ;
      }
      <%if("0".equalsIgnoreCase(musicvaliddate.trim())){%>
      if(!checkDate2(validdate)){
          alert("The validate of <%=DIYmscBoxDisp%> you entered is not correct,please re-enter!");//音乐盒有效期输入不正确,请重新输入
        fm.validdate.focus();
        return ;
      }
      if(checktrue2(validdate)){
          alert("The validate of <%=DIYmscBoxDisp%> can not earlier than current date,please re-enter!");//音乐盒有效期不能低于当前时间,请重新输入
        fm.validdate.focus();
        return ;
      }
     <%}else{
       %>
      if(!checkDate1(validdate)){
        alert("The validate of <%=DIYmscBoxDisp%> you entered is not correct,please re-enter!");
        fm.validdate.focus();
        return ;
      }
      if(checktrue1(validdate)){
        alert("The validate of <%=DIYmscBoxDisp%> can not earlier than current date,please re-enter!");
        fm.validdate.focus();
        return ;
      }
     <%}%>
     var description=trim(fm.description.value);
      <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(description,50)){
            alert("It is too long the <%=DIYmscBoxDisp%> description you input, please input again!");
            fm.description.focus();
            return;
          }
        <%
        }
        else{
        %>
        if(strlength(description)>50){
          alert("It is too long the <%=DIYmscBoxDisp%> description you input, please input again!");
          fm.description.focus();
          return;
        }
     <%}%>
      if(fm.cataindex.value=='')
	  {
		  alert("Please select one Ringtone Category!");
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
		  {
            return false;
		  }
      }
      return true;
   }

   function checkName () {
      var fm = document.inputForm;
      var code = trim(fm.grouplabel.value);
      var optype = fm.op.value;
      if(optype=='add'){
        for (i = 0; i < v_grouplabel.length; i++)
           if (code == v_grouplabel[i])
             return true;
      }
      else if(optype=='edit'){
         var index = fm.infoList.selectedIndex;
         for (i = 0; i < v_grouplabel.length; i++)
           if (code == v_grouplabel[i] && i!=index)
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
         alert("The name of <%=DIYmscBoxDisp%> which you want to add already exist!");//要增加的音乐盒名称已经存在!
         fm.grouplabel.focus();
         return;
      }
	  fm.ringgroup.value = '';	 
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      if(trim(fm.icheck.value)!='3')
      {
           alert("Cannot modify the <%=DIYmscBoxDisp%> which is already published!");
           return;
      }
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select <%=DIYmscBoxDisp%> first!");
          return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      if (checkName()) {
         alert("The name of <%=DIYmscBoxDisp%> already exist!");//音乐盒名称已经存在!
         fm.grouplabel.focus();
         return;
      }
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      <%if("0".equalsIgnoreCase(musicgrpoper.trim())){%>
         if(trim(fm.icheck.value)=='2')
         {
           alert("Cannot delete the <%=DIYmscBoxDisp%> which already verified passes!");
           return;
         }
      <%}%>
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select <%=DIYmscBoxDisp%> to delete!");//请选择您要删除的音乐盒。
          return;
      }
     if (confirm("Are you sure to delete this <%=DIYmscBoxDisp%>?") == 0)//您确认要删除这个音乐盒吗？
     	 return;
     fm.op.value = 'del';
     fm.submit();
   }

	function memberInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select <%=DIYmscBoxDisp%> to manage!");//请选择您要管理的音乐盒。
          return;
      }
   document.location.href = 'musicboxMember.jsp?ringgroup='+v_ringgroup[index]+'&grouplabel='+v_grouplabel[index];
   }


   function f_c(){
    	var ss = document.inputForm.description.value;
     	var ii= ss.length;
     	if(ii>50)
     	{
       		alert('The allowed length is only 50 characters!');
       		document.inputForm.description.value = ss.substring(0,49);
     	}

  	}

 function searchCatalog(){
     var dlgLeft = event.screenX;
     var dlgTop = event.screenY;
     var result =  window.showModalDialog("treeDlg1.html",window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+dlgLeft+";dialogTop:"+dlgTop+";dialogHeight:250px;dialogWidth:215px");

     if(result){
         var name = getRingLibName(result);
         var catindex=getRingLibIndex(result)
         document.inputForm.ringcatalog.value=name;
		 document.inputForm.cataindex.value=catindex;
     }
  }

 function getRingLibName(id){
     for(var i = 0;i<datasource.length;i++){
        var row =  datasource[i];
        if(row[0] == id)
           return row[2];
     }
     return "All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category";//全部铃音类别
 }

 function getRingLibIndex(id){
     for(var i = 0;i<datasource.length;i++){
        var row =  datasource[i];
        if(row[0] == id)
		 {
           return row[4];
		 }
     }
     return "All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category";//全部铃音类别
 }

 function getRingLibbyIndex(id){
     for(var i = 0;i<datasource.length;i++){
        var row =  datasource[i];
        if(row[4] == id)
		 {
           return row[2];
		 }
     }
     return "All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category";//全部铃音类别
 }
</script>

<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="diyMusicbox.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="ringgroup" value="">
<input type="hidden" name="icheck" value="0">
<input type="hidden" name="isshow" value="">
<input type="hidden" name="cataindex" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="../manager/image/n-9.gif">Manage <%=DIYmscBoxDisp%></td>
        </tr>
        <tr>
		 	<td>&nbsp;</td>
		 </tr>
		 <tr>
		  <td rowspan=9>
            <select name="infoList" size="10" <%= list.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < list.size(); i++) {
                    map1 = (HashMap)list.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)map1.get("grouplabel") %></option>
<%
            }
%>
            </select>
           </td>
		 <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","RingTone")%> category </td>
		 
         <td>
			  <input type="text" name="ringcatalog" readonly value="All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category" maxlength="20" class="input-style1"  onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()" >
          </td>
		 
		 </tr>
        <tr>
           <td align="right">Name of <%=DIYmscBoxDisp%></td>
           <td><input type="text" name="grouplabel" value="" maxlength="40" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.areaname,'integer')"></td>
         </tr>
		   <tr>
                 <td height="22" align="right">SP</td>
                 <td height="22">
                 <select name="sp_code" class="input-style1" onchange="javascript:changeSpIndex()">
                    <!--option value="00">ALL SP</option-->
<%
            for (int i = 0; i < spInfo.size(); i++) {
			   HashMap map5 = new HashMap();
               map5  = (HashMap)spInfo.get(i);
%>
                    <option value="<%= (String)map5.get("spcode") %>"><%= (String)map5.get("spname") %></option>
<%
                    }
%>
                 </select>

                 <select name="sp_index" style="display:none">
                    <%
                    for (int i = 0; i < spInfo.size(); i++) {
			           HashMap map5 = new HashMap();
                       map5  = (HashMap)spInfo.get(i);
                       %>
                       <option value="<%= (String)map5.get("spindex") %>"><%= (String)map5.get("spindex") %></option>
                       <%
                    }
                    %>
                 </select>

                 </td>
         </tr>
        <tr >
            <td align="right">Number of ringtones in <%=DIYmscBoxDisp%></td>
            <td><input type="text" name="ringcnt" value="" maxlength="20" class="input-style1" <%=musicringnum.trim().equalsIgnoreCase("1")?"readonly":""%>></td>
         </tr>
         <tr>
            <td align="right">Month fee(<%=minorcurrency%>)</td>
            <td><input type="text" name="ringfee" value="<%=smusicboxfixedprice%>" maxlength="5" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.outprefix,'integer')"></td>
         </tr>
        <tr style="display:block">
            <td align="right">If show</td>
            <td ><input type="text" name="isshow1" value="" readonly class="input-style1"/>
                    <!--
                    <td width="50%"><input type="radio" name="isshow" value="0" >No</td>
                    <td width="50%"><input type="radio" name="isshow" value="1" checked >Yes</td>
                      -->
            </td>
         </tr>
        <tr>
          <td align="right">Validity<%="0".equalsIgnoreCase(musicvaliddate.trim())?"(yyyy.mm.dd)":"(yyyy.mm)"%></td>
          <td><input type="text" name="validdate" value="" maxlength="10" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Update time(yyyy.mm.dd)</td>
          <td><input type="text" name="updatetime" readOnly value="" maxlength="10" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Description</td>
          <td><textarea name="description" class="input-style1" rows="2" onkeydown="f_c()"></textarea></td>
        </tr>

         <tr>
            <td colspan="2">
            <table border="0" width="100%" class="table-style2">
            <tr>
                 <td width="35%" align="center"><img src="../manager/button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                 <td width="35%" align="center"><img src="../manager/button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                 <td width="30%" align="center"><img src="../manager/button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
            </tr>
            <tr>
                 <td width="35%" align="center"><!--img src="../manager/button/member.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:memberInfo()"--></td>
                 <td width="35%" align="center"><img src="../manager/button/publish.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:mpublish()"></td>
                 <td width="30%" align="center"><img src="../manager/button/again.gif" onmouseover="this.style.cursor='hand'" onclick="window.location.href='diyMusicbox.jsp'"></td><!--javascript:document.inputForm.reset()-->
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
        sysInfo.add(sysTime + operName + "Exception occurred in managing music box!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Errors occurred in managing music box!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="diyMusicbox.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
<script language="javascript">
    if(<%=sisdefaultringprice%> != '0') {
        document.inputForm.ringfee.readOnly = true;
    }else{
        document.inputForm.ringfee.readOnly = false;
    }
</script>

</body>
</html>
