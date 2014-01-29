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
<title>Movie management</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%

   int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
   String movieName  = CrbtUtil.getConfig("movieName","Movie");
   String sysTime = "";
   Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
   String operID = (String)session.getAttribute("OPERID");
   String operName = (String)session.getAttribute("OPERNAME");
   Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
   String SpModSysRingGrpPrice =(String)application.getAttribute("SpModSysRingGrpPrice")==null?"0":(String)application.getAttribute("SpModSysRingGrpPrice");

   int isMovieAlias1 =  zte.zxyw50.util.CrbtUtil.getConfig("moviealias1",0);
   int isMovieAlias2 =  zte.zxyw50.util.CrbtUtil.getConfig("moviealias2",0);
   String imgDir = (String)CrbtUtil.getConfig("moviepath","C:/zxin10/Was/tomcat/webapps/colorring/image/movie/");
   String sLangLabel1 = CrbtUtil.getConfig("langlabel1","Arabic");
   String sLangLabel2 = CrbtUtil.getConfig("langlabel2","French");

   try {
        SpManage sysring = new SpManage();
        manSysPara syspara = new manSysPara();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-65") != null) {
            ArrayList list  = new ArrayList();
            HashMap map1 = new HashMap();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
          
	    String movielabel = request.getParameter("movielabel") == null ? "" : transferString((String)request.getParameter("movielabel")).trim();
            if(checkLen(movielabel,100))
            	throw new Exception("You enter the name of movie label is too long,please re-enter!");
            String funcid = request.getParameter("funcid") == null ? "" : transferString((String)request.getParameter("funcid")).trim();
            String aliasName1 = request.getParameter("aliasName1") == null ? "" : transferString((String)request.getParameter("aliasName1")).trim();
            String aliasName2 = request.getParameter("aliasName2") == null ? "" : transferString((String)request.getParameter("aliasName2")).trim();
			String director = request.getParameter("director") == null ? "" : transferString((String)request.getParameter("director")).trim();
			String actor_list = request.getParameter("actor_list") == null ? "" : transferString((String)request.getParameter("actor_list")).trim();
			String actress_list = request.getParameter("actress_list") == null ? "" : transferString((String)request.getParameter("actress_list")).trim();
            String Company = request.getParameter("Company") == null ? "" : transferString((String)request.getParameter("Company")).trim();
			String movieType = request.getParameter("movieType") == null ? "" : transferString((String)request.getParameter("movieType")).trim();
            String Image = request.getParameter("Image") == null ? "" : transferString((String)request.getParameter("Image")).trim();
            String region = request.getParameter("region") == null ? "" : transferString((String)request.getParameter("region")).trim();
            String PubDate = request.getParameter("PubDate") == null ? "" : transferString((String)request.getParameter("PubDate")).trim();
			String description = request.getParameter("description") == null ? "" : transferString((String)request.getParameter("description")).trim();
            
           	String searchType = request.getParameter("searchType") == null ? "" : transferString((String)request.getParameter("searchType")).trim();
           	String searchCon = request.getParameter("searchCon") == null ? "" : transferString((String)request.getParameter("searchCon")).trim();
            
			String sDisp=imgDir;
	        sDisp=sDisp.substring(sDisp.indexOf("colorring")+9); 
			
            String title = "";
            ArrayList rList = new ArrayList();
            int  optype = 0;
            if (op.equals("add")){
                optype = 1;
				funcid="";
                title = "Add Movie:"+movielabel;
            }
            if (op.equals("edit")){
                optype = 3;
                title = "Edit Movie:"+movielabel;
            }
            else if (op.equals("del")) {
                optype = 2;
                title = "Delete Movie:"+movielabel;
            }else if(op.equals("publish")){
                optype = 6;
                title = "Issues Movie:"+movielabel;
            }
            if(!op.equals("") && !op.equals("search")){
            	map1.put("funcid",funcid);            	
            	map1.put("movielabel",movielabel);
            	map1.put("description",description);
            	map1.put("searchType",searchType);
            	map1.put("searchCon",searchCon);
            	map1.put("aliasName1",aliasName1);
            	map1.put("aliasName2",aliasName2);
            	map1.put("director",director);
                map1.put("Company",Company);
                map1.put("movieType",movieType);
                map1.put("Image",Image);
                map1.put("region",region);
                map1.put("PubDate",PubDate);
				map1.put("imgdir",imgDir);
				map1.put("optype",optype+"");
				map1.put("director",director);
				map1.put("actor_list",actor_list);
				map1.put("actress_list",actress_list);
				//System.out.println("FUNCID----------->"+funcid);
				rList=sysring.addEditDeletePublishMovie(map1);
				//System.out.println("RLIST-------------->"+rList);
				/*if(optype==3) {
					rList = sysring.publishAlbum(funcid);
				}  */

               if(rList.size()>0){
                      session.setAttribute("rList",rList);
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="movie.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">

document.resultForm.submit();

</script>
</form>
            <%
               }
            }
            if(op.equals("search")) {
				list = sysring.getAlbumMovieGroup(searchType,searchCon,"2");
			} else {
            list = sysring.getAlbumMovieGroup(searchType,searchCon,"2");
			}

%>
<script language="javascript">

   var v_funcid = new Array(<%= list.size() + "" %>);
   var v_movielabel = new Array(<%= list.size() + "" %>);
<%if(isMovieAlias1==1){%>
   var v_aliasName1  = new Array(<%= list.size() + "" %>);
<%}%>
<%if(isMovieAlias2==1){%>
   var v_aliasName2  = new Array(<%= list.size() + "" %>);
<%}%>
   var v_Director     = new Array(<%= list.size() + "" %>);
   var v_Company  = new Array(<%= list.size() + "" %>);
   var v_movieType  = new Array(<%= list.size() + "" %>);
   var v_Image = new Array(<%= list.size() + "" %>);
   var v_region  = new Array(<%= list.size() + "" %>);
   var v_PubDate  = new Array(<%= list.size() + "" %>);
   var v_updatedate  = new Array(<%= list.size() + "" %>);
   var v_description  = new Array(<%= list.size() + "" %>);
   var v_checkstatus = new Array(<%= list.size() + "" %>);
   var v_Actor_List = new Array(<%= list.size() + "" %>);
   var v_Actress_List = new Array(<%= list.size() + "" %>);
 

<%
            for (int i = 0; i < list.size(); i++) {
                map1 = (HashMap)list.get(i);
%>
   v_funcid[<%= i + "" %>] = '<%= (String)map1.get("funcid") %>';
   v_movielabel[<%= i + "" %>] = '<%= (String)map1.get("funcname") %>';
   <%if(isMovieAlias1==1){%>
   v_aliasName1[<%= i + "" %>] = '<%= (String)map1.get("Alias1") %>';
   <%}%>
   <%if(isMovieAlias2==1){%>
   v_aliasName2[<%= i + "" %>] = '<%= (String)map1.get("Alias2") %>';
    <%}%>
   v_Director[<%= i + "" %>] = '<%= (String)map1.get("para1") %>';
    v_Actor_List[<%= i + "" %>] = '<%= (String)map1.get("Para2") %>';
   v_Actress_List[<%= i + "" %>] = '<%= (String)map1.get("Para3") %>';
   v_Company[<%= i + "" %>] = '<%= (String)map1.get("Para4") %>';
   v_movieType[<%= i + "" %>] = '<%= (String)map1.get("Para5") %>';
   v_Image[<%= i + "" %>] = '<%= (String)map1.get("Para6") %>';
   v_region[<%= i + "" %>] = '<%= (String)map1.get("Para7") %>';  
   v_PubDate[<%= i + "" %>] = '<%= (String)map1.get("Para8") %>';  
   v_updatedate[<%= i + "" %>] = '<%= (String)map1.get("operdate") %>';  
   v_description[<%= i + "" %>] = '<%= JspUtil.convert((String)map1.get("comment"))%>';
   v_checkstatus[<%= i + "" %>] = '<%= (String)map1.get("checkstatus") %>';
  
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
      fm.funcid.value = v_funcid[index];   
      fm.movielabel.value = v_movielabel[index];
	  <%if(isMovieAlias1==1){%>
      fm.aliasName1.value=v_aliasName1[index];
	  <%}%>
      <%if(isMovieAlias2==1){%>
      fm.aliasName2.value = v_aliasName2[index];
	  <%}%>
      fm.director.value = v_Director[index];
      fm.Company.value = v_Company[index];
      fm.movieType.value = v_movieType[index];     
      fm.Image.value = v_Image[index];
      fm.region.value = v_region[index];
      fm.PubDate.value = v_PubDate[index];    
      fm.updatedate.value= v_updatedate[index];
      fm.description.value = v_description[index];
	  fm.checkstatus.value = v_checkstatus[index];
	  fm.actor_list.value = v_Actor_List[index];
	  fm.actress_list.value = v_Actress_List[index];
	  if(fm.Image.value=='') {
		document.getElementById('movieimg').src='image/no_img.jpg';
	  }else {
		document.getElementById('movieimg').src='..<%=sDisp%>'+v_Image[index];
	  }
   }
  function mpublish()
  {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select <%=movieName%> you want to issues.");
          return;
      }
      if(trim(fm.checkstatus.value)!='0')
      {
          alert("You can't issues <%=movieName%> again.");
          return;
      }
      fm.op.value = 'publish';
      fm.submit();
  }
   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.movielabel.value) == '') {
         alert('Please enter the name of <%=movieName%>.');
         fm.movielabel.focus();
         return flag;
      }
      if (!CheckInputStr(fm.movielabel,'name of <%=movieName%>')){
         fm.movielabel.focus();
         return flag;
      }
      if (!CheckInputStr(fm.description,'description')){
         fm.description.focus();
         return flag;
      }
      <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.movielabel.value,100)){
            alert("The <%=movieName%> name should not exceed 100 bytes!");
             fm.movielabel.focus();
            return;
          }
        <%
        }
        %>
     var description=trim(fm.description.value);
      <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(description,256)){
            alert("It is too long the <%=movieName%> description you input, please input again!");
            fm.description.focus();
            return;
          }
        <%
        }
        else{
        %>
        if(strlength(description)>256){
          alert("It is too long the <%=movieName%> description you input, please input again!");
          fm.description.focus();
          return;
        }
     <%}%>
      var pubDate=trim(fm.PubDate.value);
      if(!checkDate2(pubDate)) {
           alert("Please enter the correct publish date.\r\nThe correct format is YYYY.MM.DD");
           fm.PubDate.focus();
           return false;
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
      var code = trim(fm.movielabel.value);
      var optype = fm.op.value;
      if(optype=='add'){
        for (i = 0; i < v_movielabel.length; i++)
           if (code == v_movielabel[i])
             return true;
      }
      else if(optype=='edit'){
         var index = fm.infoList.selectedIndex;
         for (i = 0; i < v_movielabel.length; i++)
           if (code == v_movielabel[i] && i!=index)
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
         alert("The name of <%=movieName%> which you want to add already exist!");
         fm.movielabel.focus();
         return;
      }
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;

      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select <%=movieName%> first!");
          return;
      }
      if(! checkInfo())
         return;
      fm.op.value = 'edit';
      if (checkName()) {
         alert("The name of <%=movieName%> already exist!");
         fm.movieType.focus();
         return;
      }
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;

      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select <%=movieName%> to delete!");
          return;
      }
     if (confirm("Are you sure to delete this <%=movieName%>?") == 0)
     	 return;
     fm.op.value = 'del';
     fm.submit();
   }

   function memberInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select <%=movieName%> to manage!");
          return;
      }
      document.location.href = 'albumMovieRingEdit.jsp?ringgroup='+v_funcid[index]+'&grouplabel='+v_movielabel[index]+'&grpType=2';
   }


   function f_c(){
    	var ss = document.inputForm.description.value;
     	var ii= ss.length;
     	if(ii>256)
     	{
       		alert('The allowed length is only 256 characters!');
       		document.inputForm.description.value = ss.substring(0,255);
     	}

  	}

  function selectFile ()
  {
	var fm = document.inputForm;
	var filename = trim(fm.Image.value);
	var uploadURL = 'uploadAlbumImage.jsp?frompage=movie&filename='+filename;
	uploadRing = window.open(uploadURL,'upload','width=400, height=250');
  }
  function getListName(label) {
	var fm = document.inputForm;
	fm.Image.value = label;
	if(fm.Image.value=='') {
		document.getElementById('movieimg').src='image/no_img.jpg';
	}else {
		document.getElementById('movieimg').src='..<%=sDisp%>'+label;
  }
  }
function searchInfo() {
	var fm=document.inputForm;
	fm.op.value='search';
		fm.submit();
}
function delFile() {
	document.inputForm.Image.value="";
}
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="movie.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="funcid" value="">
<input type="hidden" name="checkstatus" value=""%>
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Manage Movie</td>
        </tr>
        
          <tr>
          <td >
            <select name="searchType"  class="input-style1" value=<%= searchType%>>
              <option  <%if(searchType.equals("movieName")) {%> selected <%}%> value="movieName">Movie Name</option>
            </select>
           </td>
           <td >
           	<input type="text" name="searchCon" value="<%= searchCon%>" maxlength="100" class="input-style1">
           </td>
		     <td><img src="../manager/button/search.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:searchInfo()"></td>
         </tr>       
        <tr>
          <td rowspan=14>
            <select name="infoList" size="20" <%= list.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < list.size(); i++) {
                    map1 = (HashMap)list.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)map1.get("funcname") %></option>
<%
            }
%>
            </select>
           </td>
           <td align="right"><%=movieName%> name</td>
           <td><input type="text" name="movielabel" value="" maxlength="100" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.areaname,'integer')">&nbsp;&nbsp;<%if(!Image.equals("")) {%><img src="..<%=sDisp%><%=Image%>" border="0" width="64" height="64" alt="<%=Image%>" id="movieimg" style="float:right;position:absolute;" /><%}else{%><img src="image/no_img.jpg" border="0" width="64" height="64"  id="movieimg" style="float:right;position:absolute;" /><%}%> </td>
         </tr>
         <tr <%if(isMovieAlias1==1){%> style="display:block" <%}else{%> style="display:none" <%}%>>
            <td align="right"><%=sLangLabel1+" "+movieName%> name</td>
            <td><input type="text" name="aliasName1" value="" maxlength="100" class="input-style1" ></td>
         </tr>
         <tr <%if(isMovieAlias2==1){%> style="display:block" <%}else{%> style="display:none" <%}%>>
            <td align="right"><%=sLangLabel2+" "+movieName%> name</td>
            <td><input type="text" name="aliasName2" value="" maxlength="100" class="input-style1" ></td>
         </tr>
         <tr >
            <td align="right">Director</td>
            <td><input type="text" name="director" value="" maxlength="100" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.outprefix,'integer')"></td>
         </tr>
                  <tr >
            <td align="right">Actor List</td>
            <td><input type="text" name="actor_list" value="" maxlength="256" class="input-style1" ></td>
         </tr>
         <tr>
            <td align="right">Actress List</td>
            <td><input type="text" name="actress_list" value="" maxlength="256" class="input-style1" ></td>
         </tr>
        <tr style="display:block">
            <td align="right">Company</td>
            <td ><input type="text" name="Company" value="" maxlength="100" class="input-style1"/>
            </td>
         </tr>
        <tr>
          <td align="right">Type of movie</td>
          <td><input type="text" name="movieType" value="" maxlength="100" class="input-style1"></td>
        </tr>
                
        <tr>
          <td align="right">Image</td>
          <td><input type="text" name="Image" value=""  class="input-style0" readonly />&nbsp;<img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()" width="45" height="19" />&nbsp;<img src="button/del_img.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delFile()" width="62" height="19"></td>
        </tr>
        
        <tr>
          <td align="right">Published region</td>
          <td><input type="text" name="region" value="" maxlength="100" class="input-style1"></td>
        </tr>
        
         <tr>
          <td align="right">Published date</td>
          <td><input type="text" name="PubDate" value="" maxlength="10" class="input-style1"></td>
        </tr>        
        <tr>
          <td align="right">Movie Description</td>
          <td><textarea name="description" class="input-style1" rows="2"  onkeydown="f_c()"></textarea></td>
        </tr>
        <tr>
          <td align="right">Update date(yyyy.mm.dd)</td>
          <td><input type="text" name="updatedate" readOnly value="" maxlength="10" class="input-style1"></td>
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
                 <td width="35%" align="center"><img src="../manager/button/member.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:memberInfo()"></td>
                 <td width="35%" align="center"><img src="../manager/button/publish.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:mpublish()"></td>
                 <td width="30%" align="center"><img src="../manager/button/again.gif" onmouseover="this.style.cursor='hand'" onclick="window.location.href='movie.jsp'"></td><!--javascript:document.inputForm.reset()-->
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
        sysInfo.add(sysTime + operName + "Exception occurred in managing movie!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Errors occurred in managing album!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
		%>
		<form name="errorForm" method="post" action="error.jsp">
		<input type="hidden" name="historyURL" value="movie.jsp">
		</form>
		<script language="javascript">
		   document.errorForm.submit();
		</script>
		<%
    }
%>
</body>
</html>
