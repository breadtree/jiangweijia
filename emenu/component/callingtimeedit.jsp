<%@include file="/base/i18n.jsp"%>
<link href="css/start/jquery-ui-1.7.3.custom.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min.js"></script>
<%
	int isfarsicalendar = CrbtUtil.getConfig("isfarsicalendar", 0);
	String img_path = "intl/" + getZteLocale(request) + "/"; //add by chenxi 2007-03-01
	String tmpnamegroup = getArgMsg(request, "UserMSG0053901", "1",	label);
	String tmpname = getArgMsg(request, "UserMSG0053900", "1", label);
	String tmpringdisplay = zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay", "CRBT")+ " " + getArgMsg(request, "UserMSG0053936", "1");
	int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0);
	String sEdit=request.getParameter("isedit")==null?"":(String)request.getParameter("isedit");
	int isSupportPlayTime = zte.zxyw50.util.CrbtUtil.getConfig("isSupportPlayTime",0);

	if(isfarsicalendar == 1){
%>
	<script type="text/javascript" src="js/jalaliCalendar.js"></script>
	<script type="text/javascript" src="js/ui.datepicker-fa.js"></script>
	<script type="text/javascript" src="js/jalali.js"></script>
	<%
}
%>
<script language="javascript">
	var isfarsicalendar = '<%=isfarsicalendar%>';	
	function editdate(){
		var fm = document.forms[0];
		var startdate_date = new Date();
		var startdate1 = new Date();
		var enddate1 = new Date();
		
		startdate_date = fm.startdate_date.value;	
		startdate1 = fm.startdate1.value;
		enddate1 = fm.enddate1.value;
		
		var date1 = startdate1.split(".");		
		var date2 = startdate_date.split(".");
		var date3 = enddate1.split(".");
		
		startdate1 = gregorian_to_jalali(date1);	
		startdate_date = gregorian_to_jalali(date2);
		enddate1 = gregorian_to_jalali(date3);	
			
		fm.startdate_date.value = startdate_date;
		fm.startdate1.value = startdate1;
		fm.enddate1.value = enddate1;		
	}
	
	$(document).ready(function(){
		if(isfarsicalendar == "1"){
			var isedit = '<%=sEdit%>'=="true"?'1':'0';
			if(isedit == "1"){
				editdate();
			}
			$.datepicker.setDefaults($.datepicker.regional['fa']) ;
			$(".calendar").datepicker({dateFormat: 'yy.mm.dd',yearRange:'1390:1440',changeMonth: true,changeYear: true,showAnim:'fadeIn',minDate:'0d'});
		}
		else{
		$.datepicker.setDefaults($.datepicker.regional['']) ;
			$(".calendar").datepicker({dateFormat: 'yy.mm.dd',yearRange:'2012:2020',changeMonth: true,changeYear: true,showAnim:'fadeIn',minDate:new Date()});
		}
	});
</script>

<zte:form name="form_monthringedit" dynamic="true"
	initial="ognl:$request.getParameter('isedit')"
	condition="allindex=$allindex and setno=$setno"
	model="ognl:@UserViewHelper@getCallingtimeModel($session)">
	 <table border="0" align="center"> <tr><td>
	<zte:formfield text="" type="hidden" fieldName="allindex" mappedName="allindex" />
	<zte:formfield type="hidden" fieldName="callingnumref" text="" mappedName="callingnum" />
	<zte:formfield text="" type="hidden" fieldName="ringidtype" />
	<zte:formfield type="hidden" fieldName="callingnum" text="" />
	<zte:formfield type="hidden" fieldName="startdate" />
	<zte:formfield type="hidden" fieldName="enddate" text="" />
	<zte:formfield text="" type="hidden" fieldName="callnum" />
	<zte:formfield type="hidden" fieldName="opertype" text="" />
	<input type="hidden" name="userringtype" />
	<input type="hidden" name="timetype" />
	<zte:formfield text="" type="hidden" fieldName="callingtype" mappedName="callingtype" />
	<zte:formfield type="hidden" fieldName="startmonthday_year" text="" mappedName="startmonday" />
	<zte:formfield type="hidden" fieldName="endmonthday_year" text="" mappedName="endmonday" />
	<zte:formfield text="" type="hidden" fieldName="enddate_date" mappedName="enddate" />
	
	<zte:formfield type="text" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053924','1')"
		fieldName="timedecrip" mappedName="timedescrip" maxSize="40" 
		editable="ognl:$request.getParameter('isedit')=='true'?'false':'true'" />
	<tr>
		<td colspan="2" align="center">
		<table><tr>
			<td><input type="radio"  onclick="firechange('2');" checked value="2" name="isgroup">
			<%=getArgMsg(request, "UserMSG0053944", "1",label)%>&nbsp;&nbsp;</td>
			<td><input type="radio"  onclick="firechange('0');" value="0" name="isgroup">
			<%=getArgMsg(request, "UserMSG0053900", "1",label)%>&nbsp;&nbsp;</td>
			<td><input type="radio" onclick="firechange('1');" name="isgroup" value="1"> <%=getArgMsg(request, "UserMSG0053901", "1",label)%></td>
		</tr></table>
		</td>
	</tr>

	<zte:formfield type="select"  fieldName="phonegroup" text="<%=tmpnamegroup%>" 
		datasource="ds_callinggroup(callinggroup,grouplabel)@allindex=$allindex" />

	<zte:formfield text="<%=tmpname%>" type="number"
		fieldName="callingnum1" minSize="8" maxSize="20" />

	<zte:formfield size="1" text="<%=tmpringdisplay%>" type="select"
		mappedName="ringid" fieldName="ringid">
		<%
			String strOption = "";
					List list = (List) request.getAttribute("userringlib");
	/*LinkedList row9 = new LinkedList();
					row9.add("0000000000");
					row9.add(getArgMsg(request, "UserMSG0053942", "1"));
					row9.add("1");
					ListDataSourceItem item9 = new ListDataSourceItemImpl(row9);
	list.add(item9);*/

					if (list != null && list.size() > 0) {
		%>
		<!--<script type="text/javascript" src="base/JsFun.js"></script>-->
		<!--<script type="text/javascript" src="pubfun/JsFun.js"></script>-->
		<%@include file="/pubfun/JsFun.jsp"%>
		<script language="javascript">
        var s_vRingid = new Array(<%=list.size() + ""%>);
        var s_vRingIdType = new Array(<%=list.size() + ""%>);
        <%for (int i = 0; i < list.size(); i++) {
							ListDataSourceItem item = (ListDataSourceItem) list
									.get(i);
							String value = item.getItem(0) == null ? "" : item
									.getItem(0).toString();
							String name = item.getItem(1) == null ? "" : item
									.getItem(1).toString();
							String type = item.getItem(2) == null ? "" : item
									.getItem(2).toString();
							strOption = strOption + "<option value=" + value
									+ ">" + name + "</option>";%>
        s_vRingid[<%=i + ""%>] = '<%=value%>';
        s_vRingIdType[<%=i + ""%>] = '<%=type%>';
                         <%}
					} %>
                 </script>
<%
		out.print(strOption);
%>
	</zte:formfield>
	<tr>
		<td colspan="2" align="right"><zte:formfield type="select"
			visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,4)"
			fieldName="startmonthday"  size="1"
			text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053925','1')"
			mappedName="startday">
			<%
				for (int j = 1; j <= 31; j++)
							out.println("<option value=" + j + ">"
									+ String.valueOf(j) + "</option>");
			%>
		</zte:formfield> &nbsp;&nbsp; <zte:formfield type="select"
			visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,4)"
			fieldName="endmonthday" size="1"
			text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053926','1')"
			mappedName="endday">
			<%
				for (int j = 1; j <= 31; j++)
							out.println("<option " + (j == 31 ? "selected " : "")
									+ "value=" + j + ">" + String.valueOf(j)
									+ "</option>");
			%>
		</zte:formfield></td>
	</tr>
	<tr>
		<td colspan="2" align="right"><zte:formfield type="select"
			
			visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,3)"
			fieldName="startweek" size="1"
			text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053927','1')"
			mappedName="startweek">
			<%!String weekDays[] = {"Monday", "Tuesday", "Wednasday","Thursday", "Friday", "Saturday","Sunday"};%>
			<%
			for (int j = 0; j <weekDays.length; j++)
				out.println("<option " + (j == 0 ? "selected " : "")
						+ " value=" + (j+1) + ">" + String.valueOf(weekDays[j])
						+ "</option>");	
			
			%>
		</zte:formfield> &nbsp;&nbsp; <zte:formfield type="select" 
			visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,3)"
			fieldName="endweek" size="1"
			text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053928','1')"
			mappedName="endweek">
			<%
			for (int j = 0; j <weekDays.length; j++)
				out.println("<option " + (j == 6 ? "selected " : "")
						+ " value=" + (j+1) + ">" + String.valueOf(weekDays[j])
						+ "</option>");	
			%>
		</zte:formfield></td>
	</tr>
	<tr id="tr_yearstartmonth">
		<td colspan="2" align="left"><i18n:message key="UserMSG0053902" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select
			name="startmonth" size="1" class="input-style5">
			<%
				for (int j = 1; j <= 12; j++)
						out.println("<option " + (j == 1 ? "selected " : "")
								+ " value=" + j + ">" + String.valueOf(j)
								+ "</option>");
			%>
		</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i18n:message key="UserMSG0053903" />&nbsp;<select
			name="startday" size="1" class="input-style5">
			<%
				for (int j = 1; j <= 31; j++)
						out.println("<option " + (j == 1 ? "selected " : "")
								+ " value=" + j + ">" + String.valueOf(j)
								+ "</option>");
			%>
		</select>
	</tr>
	<tr id="tr_yearendmonth">
		<td colspan="2" align="left"><i18n:message key="UserMSG0053904" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select
			name="endmonth" size="1" class="input-style5">
			<%
				for (int j = 1; j <= 12; j++)
						out.println("<option " + (j == 12 ? "selected " : "")
								+ " value=" + j + ">" + String.valueOf(j)
								+ "</option>");
			%>
		</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i18n:message key="UserMSG0053905" />&nbsp;<select
			name="endday" size="1" class="input-style5">
			<%
				for (int j = 1; j <= 31; j++)
						out.println("<option " + (j == 31 ? "selected " : "")
								+ " value=" + j + ">" + String.valueOf(j)
								+ "</option>");
			%>
		</select></td>
	</tr>
	<zte:formfield text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053929','1')" value="00:00:00" 
		visible="ognl:@UserViewHelper@isTimeCallingItemHidden($request,'2&6')"  type="time" fieldName="starttime" mappedName="starttime" />
	<zte:formfield text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053930','1')" value="23:59:58"
		visible="ognl:@UserViewHelper@isTimeCallingItemHidden($request,'2&6')" type="time" fieldName="endtime" mappedName="endtime" />
	<zte:formfield text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053931','1')"  
	    visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,2)" type="date" fieldName="startdate_date" mappedName="startdate"  css="calendar"/>
	<zte:formfield text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053932','1')" 
	    visible="ognl:@UserViewHelper@isTimeCallingItemHidden($request,'2&6')" type="date" fieldName="startdate1" mappedName="startdate"  css="calendar"/>
	<zte:formfield	text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053933','1')"
		visible="ognl:@UserViewHelper@isTimeCallingItemHidden($request,'2&6')"	type="date" fieldName="enddate1" mappedName="enddate"  css="calendar"/>
		
	<%if(isSupportPlayTime == 1){ %>
		<zte:formfield type="text" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053946','1')" fieldName="starttime1" mappedName="playstarttime" maxSize="40" />
		<zte:formfield type="text" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0053947','1')" fieldName="endtime1" mappedName="playendtime" maxSize="40"/>
	<%} %>
	
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center">
		<button class="submitBtn" onClick="javascript:doSubmit()"><span><i18n:message key="UserMSG0059952" /></span></button>
		<button class="submitBtn" onClick="javascript:goback()"><span><i18n:message key="UserMSG0059917" /></span></button>
		</td>
	</tr>
</table>
</zte:form>

<script>
	var userringtype = "<%=userRingType%>";
	var timetype = "<%=timeType%>";
	var callNum ="<%=callNum%>";
    var num = document.form_monthringedit.callingnumref.value;
    var type = document.form_monthringedit.callingtype.value;
    var phonegroup = document.form_monthringedit.phonegroup;
    var opertype = document.form_monthringedit.opertype;
    var callingnum2 = document.form_monthringedit.callingnum1;
    document.form_monthringedit.timetype.value = timetype;
    document.form_monthringedit.userringtype.value = userringtype;
    var isedit = <%=request.getParameter("isedit")%>;
    if(isedit && timetype =='5'){
      setDayOrWeek(document.form_monthringedit.startmonthday_year.value,1);
      setDayOrWeek(document.form_monthringedit.endmonthday_year.value,2);
    }
    if(isedit){
        opertype.value = '0';
    }else{
    	var currentTime = new Date();
    	var month = currentTime.getMonth() + 1;
    	var day = currentTime.getDate();
    	var year = currentTime.getFullYear();
    	var endyear = currentTime.getFullYear()+10;
        if(month < '10'){
    		month = '0'+month;        
    	}
    	if(day < '10'){
    		day = '0'+day;
        }
        document.form_monthringedit.startdate_date.value = year+"."+month+"."+day;
        document.form_monthringedit.startdate1.value = year+"."+month+"."+day;
        document.form_monthringedit.enddate1.value = year+"."+month+"."+day;
        opertype.value = '1';
        firechange(2); // Added for MobiTel
    }   
     if(type != null && type!=''){
        if(type=='2' || type == '102'|| type == '112'){
            document.form_monthringedit.isgroup[2].checked = true; // changed 1 to 2 for MobiTel
            phonegroup.value = num;
           firechange(1);
        }else {
            if(num=='')
            {
        	document.form_monthringedit.isgroup[0].checked = true;
            firechange(2);
            }
            else
            {
             document.form_monthringedit.isgroup[1].checked = true;// changed 0 to 1 for MobiTel
             callingnum2.value = num;
             firechange(0);
            }
        }
    }
    if(timetype =='5'){
      document.all("tr_yearstartmonth").style.display= 'block';
      document.all("tr_yearendmonth").style.display= 'block';
    }else{
      document.all("tr_yearstartmonth").style.display= 'none';
      document.all("tr_yearendmonth").style.display= 'none';
    }
    function firechange(n){
      if(n == 0){
         document.all("tr_phonegroup").style.display= 'none';
        //document.all("tr_callingnum1").style.display= 'block';     before
         document.all("tr_callingnum1").style.display= '';           //after
         document.all("tr_callingnum1").value=""; //Added for MobiTel
      }else if(n == 2) { // added newly for MobiTel
    	  document.all("tr_phonegroup").style.display= 'none';
    	  document.all("tr_callingnum1").style.display= 'none';
    	  document.all("tr_callingnum1").value=""; //Added for MobiTel
    	}else{
        //document.all("tr_phonegroup").style.display= 'block';      before
		  document.all("tr_phonegroup").style.display= '';          //after
         document.all("tr_callingnum1").style.display= 'none';
      }
    }

    function doSubmit(url){
        if(!checkinfo()){
            return;
        }               
      beforesubmit();
      var editable = '<%=request.getParameter("isedit")%>';
      if(editable&&editable=='true'){
          var url = '/colorring/callingtimemodifydemo.action';
      }
      else{
          var url = '/colorring/callingtimecreatedemo.action';
      }
      document.form_monthringedit.action=url;
      document.form_monthringedit.submit();
    }

    function beforesubmit(){
        var callnum = document.form_monthringedit.callnum;
        var callnum1 = document.form_monthringedit.callingnum;
        var ringidtype = document.form_monthringedit.ringidtype;
        var ringid = document.form_monthringedit.ringid.value;
        var j;
        for(j=0;j<s_vRingid.length;j++){
            if(s_vRingid[j+""]==ringid)
            break;
        }
        ringidtype.value = s_vRingIdType[j+""];
        callnum.value='<%=callNum%>';
        var isgroup;
        if(document.form_monthringedit.isgroup[2].checked==true){  //changed 1 to 2 for MobiTel System test Bug fixing.
           isgroup = 1; // changed 0 to 1 for MobiTel System test Bug fixing.
		}
       else {
           isgroup =0;  // changed 1 to 0 for MobiTel System test Bug fixing.
	   }
        if(isgroup){
            callnum1.value = document.form_monthringedit.phonegroup.value;
        }
        else{
            if(document.form_monthringedit.isgroup[1].checked==true)
            callnum1.value = document.form_monthringedit.callingnum1.value;
			else
				document.form_monthringedit.callingnum1.style.display='none';
        }
        if(timetype=='2'){
            document.form_monthringedit.startdate.value = document.form_monthringedit.startdate_date.value;
            document.form_monthringedit.enddate.value = document.form_monthringedit.startdate_date.value;
        }else{
            document.form_monthringedit.startdate.value = document.form_monthringedit.startdate1.value;
            document.form_monthringedit.enddate.value = document.form_monthringedit.enddate1.value;
        }
    }


     function checkinfo(){
         var ringdisplay = "<%=ringdisplay%>";
        var pform = document.form_monthringedit;
        var  name = "";
        var isgroup;

        if(document.form_monthringedit.isgroup[2].checked==true) //changed 1 to 2 for MobiTel System test Bug fixing.
           isgroup = 1; // changed 0 to 1 for MobiTel System test Bug fixing.
       else
           isgroup =0 ;  // changed 0 to 1 for MobiTel System test Bug fixing.
        name = trim(pform.timedecrip.value);
        if(name == ""){
            alert("<i18n:message key='UserMSG0053906' />");
            return false;
        }
        <%if (ifuseutf8 == 1) {%>
        if(!checkUTFLength(pform.timedecrip.value,40)){
            alert("<i18n:message key='UserMSG0053943' />");
            pform.timedecrip.focus();
            return;
          }
        <%}
			String strLan = com.zte.tao.config.TaoUtil.getZteLocale(request).toString().toLowerCase();
			if (!strLan.startsWith("ar")) {%>
       if (!CheckInputStr(pform.timedecrip,"<i18n:message key='UserMSG0053907' />"))
       return;
       <%}%>
      var numbervalue="";
      numbervalue=pform.callingnum1.value;
      if( (isgroup == 0) && (document.form_monthringedit.isgroup[1].checked==true) ) { // Added for MobiTel System test Bug fixing
                 
     if(numbervalue!=""){
          if (!checkstring('0123456789',numbervalue)){
       alert("<i18n:message key='UserMSG0053923' />");
       return;
       }
	   if (numbervalue == '<%=callNum%>'){
		   alert("<i18n:message key='UserMSG0053941' />");
		   return;
	   }
       if(isMobile(numbervalue)){
         if(numbervalue.length < 6){
        		alert("<i18n:message key='UserMSG0053908' />");
        	return;
      		 }
       }else{
         //固定电话号码
          if(numbervalue.length<8||numbervalue.length>13){
           alert("<i18n:message key='UserMSG0053908' />");
           return;
         }
       }
      }else{
    	  alert("<i18n:message key='UserMSG0053945' />");
    	  return;
      }
      }

        if(pform.ringid.length == 0){
            alert("<%=getArgMsg(request, "UserMSG0053909", "1", ringdisplay)%>" +"!");
            return false;
        }
        var str1 =  pform.starttime.value;
        var str2 =  pform.endtime.value;
        if(str1>str2){
            alert("<i18n:message key='UserMSG0053911' />");
            return false;
        }
        if(pform.callingnum1.value.length>8)//固定电话
        makePhone();
        var startday = pform.startdate1.value;
        var endday   = pform.enddate1.value;
        if(startday!=''&& endday=='' ){
            alert("<i18n:message key='UserMSG0053913' />");
            return false;
        }
        if(endday!=''&& startday=='' ){
            alert("<i18n:message key='UserMSG0053912' />");
            return false;
        }
        if(startday!='' && timetype != '2'){
			if(checktrue22(endday)){
                alert("<i18n:message key='UserMSG0053914' />");
                return false;
            }
            if(!compareDate2(startday,endday)){
                alert("<i18n:message key='UserMSG0053915' />");
                return false;
            }
        }
        if(pform.isgroup[2].checked && pform.phonegroup.value==''){ // changed 1 to 2 for MobiTel
              alert("<i18n:message key='UserMSG0053916' />");
              pform.isgroup[0].checked = true;
              firechange(2);
              return false;
          }
          if(timetype =='1'){//time segment

        }else if(timetype =='2'){//纪念日
        var startday = pform.startdate_date.value;
        if(trim(startday) == ""){
          alert("<i18n:message key='UserMSG0053917' />");
          pform.startdate_date.focus();
          return false;
        }
        if(checkdate(trim(startday))==2){
          alert("<i18n:message key='UserMSG0053918' />");
          pform.startdate_date.focus();
          return false;
        }
      }else if(timetype =='3'){//周time segment
      var startweek = pform.startweek.value;
      var endweek   = pform.endweek.value;
      if(startweek>endweek){
        alert("<i18n:message key='UserMSG0053919' />");
        return false;
      }
    }else if(timetype =='4'){//月time segment
      var startmonthday = eval(pform.startmonthday.value);
      var endmonthday   = eval(pform.endmonthday.value);
      if(startmonthday > endmonthday){
        alert("<i18n:message key='UserMSG0053920' />");
        return false;
      }
    }else if(timetype =='5'){//年time segment
      var startmonth = eval(pform.startmonth.value);
      var endmonth   = eval(pform.endmonth.value);
      var startdate = eval(pform.startday.value);
      var enddate = eval(pform.endday.value);
      if(startmonth>endmonth){
           alert("<i18n:message key='UserMSG0053921' />");
           return;
      }
      if(startmonth==endmonth && startdate>enddate){
        alert("<i18n:message key='UserMSG0053922' />");
        return;
      }
    }
    if(timetype=='5'){
          var frm = document.form_monthringedit;
          var d = new Date();
          var year = d.getFullYear();
          if(frm.startmonth.value ==2){
            if((year%4==0 && year%100 != 0)|| year%400 ==0){
              if(frm.startday.value > 29){
                alert("<i18n:message key='UserMSG0053938' />");
                return false;
              }
            }else{
              if(frm.startday.value > 28){
                alert("<i18n:message key='UserMSG0053938' />");
                return false;
              }
            }
          }
          if( frm.startmonth.value ==4 || frm.startmonth.value ==6 || frm.startmonth.value ==9 || frm.startmonth.value ==11 ){
            if(frm.startday.value > 30){
              alert("<i18n:message key='UserMSG0053938' />");
              return false;
            }
          }

          if(frm.endmonth.value ==2){
            if((year%4==0 && year%100 != 0)|| year%400 ==0){
              if(frm.endday.value > 29){
                alert("<i18n:message key='UserMSG0053939' />");
                return false;
              }
            }else{
              if(frm.endday.value > 28){
                alert("<i18n:message key='UserMSG0053939' />");
                return false;
              }
            }

          }
          if( frm.endmonth.value ==4 || frm.endmonth.value ==6 || frm.endmonth.value ==9 || frm.endmonth.value ==11 ){
            if(frm.endday.value > 30){
              alert("<i18n:message key='UserMSG0053939' />");
              return false;
            }
          }

    }
      return true;
    }

    function makePhone () {
      var fm = document.form_monthringedit;
      if(fm.isgroup[2].checked) // change from 1 to 2 for MobiTel           
         return;
/*
      var phone = trim(fm.callingnum1.value);
      if (isPhone(phone) == true && phone.substring(0,1) != '0'){
         phone  = 0 + phone ;
         fm.callingnum1.value = phone;
      }
*/
      return true;
   }
function setDayOrWeek(monthday,n){
     var month = monthday.substring(0,2);
     var day = monthday.substring(3,5);
     if(month.substring(0,1)=='0')
        month = month.substring(1,2);
    if(day.substring(0,1)=='0')
        day = day.substring(1,2);
     if(n ==1){
       document.form_monthringedit.startmonth.value = month;
       document.form_monthringedit.startday.value = day;
	 }else{
       document.form_monthringedit.endmonth.value = month;
       document.form_monthringedit.endday.value = day;
   }
   }
  function goback(){
      //document.location.href="/colorring/initcallingtimetable.action?timetype="+timetype+"&userringtype="+userringtype;
      var fm = document.form_monthringedit;
      fm.action = "/colorring/initcallingtimetable.action?timetype="+timetype+"&userringtype="+userringtype;
      fm.submit();
    }
</script>
