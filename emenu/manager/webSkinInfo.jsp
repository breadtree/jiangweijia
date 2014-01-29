<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.WebSkinVO" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%   String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");

%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title><%= colorName %> System</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String itemno = request.getParameter("itemno") == null ? "" : transferString((String)request.getParameter("itemno"));

	  String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

    try {
      String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
      String itemname = request.getParameter("itemname") == null ? "" : transferString((String)request.getParameter("itemname")).trim();
      String urltype = request.getParameter("urltype") == null ? "" : transferString((String)request.getParameter("urltype")).trim();
      String urlcontent = request.getParameter("urlcontent") == null ? "" : transferString((String)request.getParameter("urlcontent")).trim();
      ArrayList rList  = new ArrayList();

        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
      if (operID != null && purviewList.get("3-31") != null) {


        if(itemno.trim().length()==0)
        {
        throw new Exception("Please choose one record to be edited");
        }

        String title="";
        if(op.equals("edit"))
        {
         rList = syspara.editWebSkinInfo(Integer.parseInt(itemno), Integer.parseInt(urltype), urlcontent);
         title = "Edit Web Skin Info";
         sysInfo.add(sysTime + operName + "Web Skin Info edited successfully!");//Edit成功


        }

       if(!op.equals("") && getResultFlag(rList)){
             // application 重新载入
             application.removeAttribute("webskin");

               zxyw50.Purview purview = new zxyw50.Purview();
               HashMap map = new HashMap();
              map.put("OPERID",operID);
             map.put("OPERNAME",operName);
             map.put("OPERTYPE","331");
             map.put("RESULT","1");
             map.put("PARA1",itemname);
             map.put("PARA2",urltype);
             map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
              purview.writeLog(map);
            }

        if(rList.size()>0){
              session.setAttribute("rList",rList);
              %>
    <form name="resultForm" method="post" action="result.jsp">
    <input type="hidden" name="historyURL" value="webSkinInfo.jsp?itemno=<%=itemno%>">
    <input type="hidden" name="title" value="<%= title %>">
    <script language="javascript">
    document.resultForm.submit();
    </script>
    </form>
     <%
     }

        WebSkinVO vo =new WebSkinVO();
        ArrayList vet = new ArrayList();
        vet = (ArrayList) syspara.getWebSkinInfo(Integer.parseInt(itemno));

        if(vet!=null&&vet.size()>0)
        {
        vo = (WebSkinVO)vet.get(0);
        }

       else
       {
        throw new Exception("Can not find infomation of choosed record");
       }
%>
<script language="javascript">


function selectinfo()
{
  var fm = document.inputForm;

  fm.urlcontent.value="";

if(fm.urltype.value=='0'||fm.urltype.value=='1')
  {

   fm.qrybtn.style.display='none';
  }
   else
   {
   fm.qrybtn.style.display='inline';
   }

  if(fm.urltype.value=='1')
  {
   fm.urlcontent.readOnly=false;
  }
  else
  {
   fm.urlcontent.readOnly=true;
  }
}
function backto()
{
window.location.href="webSkinEdit.jsp";
}

function choosecode()
{
  var fm = document.inputForm;
 if(fm.urltype.value=='2')
 {
var result =  window.showModalDialog('singersearch.jsp',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
 }
 if(fm.urltype.value=='3')
 {
var result =  window.showModalDialog('ringgroupsearch.jsp?grouptype=1',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
 }
 if(fm.urltype.value=='4')
 {
var result =  window.showModalDialog('ringgroupsearch.jsp?grouptype=2',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
 }

if(result){
       document.inputForm.urlcontent.value=result;
     }

}

function editinfo()
{
 var fm = document.inputForm;
 if(fm.urltype.value!='0')
 {
  if(trim(fm.urlcontent.value)=="")
  {
  alert("Please input the url or choose link code");
  return false;
  }
 }
  if(trim(fm.urlcontent.value).length>255)
  {
  alert("The content of url may not be more than 255 characters");
  return false;
  }

 fm.op.value="edit";
 fm.submit();
}
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="webSkinInfo.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="itemno" value="<%=itemno%>">
<table width="440" border="0" align="center" class="table-style2">
  <tr>
  <td>
<tr>
    <td width="100%" colspan="2">
    <table width="98%" border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Web Skin Info</td>
        </tr>
          <td colspan="2">
              &nbsp;
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
   <td width="35%" align="right">Name&nbsp;&nbsp; </td>
   <td align="left"><input type="text" name="itemname" value="<%=vo.getItemname()%>" readonly="readonly"  class="input-style1"  >
   </td>
  </tr>
   <tr>
     <td width="35%" align="right">URL type&nbsp;&nbsp; </td>
     <td align="left">
     <%
     int type = vo.getUrltype();
     %>
     <select name="urltype" class="input-style1"   onclick ="selectinfo()">
       <option value="0" <%if(type==0){%>
         selected="selected"
       <%}%>
       >No Link</option>
       <option value="1" <%if(type==1){%>
       selected="selected"
       <%}%>
       >Outer Link</option>
       <option value="2" <%if(type==2){%>
       selected="selected"
       <%}%>
       >Singer</option>
       <option value="3" <%if(type==3){%>
       selected="selected"
       <%}%>
       >Music Station</option>
       <option value="4" <%if(type==4){%>
       selected="selected"
       <%}%>
       >Music jukebox</option>

     </select>
   </td>

   </tr>
   <tr>
   <td width="35%" align="right">URL &nbsp;&nbsp; </td>
   <td align="left"><input type="text" name="urlcontent" value="<%=vo.getUrl()%>"
     <%if(type!=1){%>

     readonly="readonly"
     <%}%>
     maxlength="255" class="input-style1"  ><img src="../image/query.gif" name="qrybtn"
     style="<%if(type==0||type==1){%>
     display:none
     <%}%>
     " onMouseOver="this.style.cursor='hand'" onclick="javascript:choosecode()">
   </td>
   </tr>

   <tr>
   <td  align="center" colspan="2">
   <table border="0" width="100%" class="table-style2"  align="center">
     <tr>
      <td  align="center">
      <img src="button/sure.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:editinfo()">
      &nbsp;&nbsp;&nbsp;&nbsp;
      <img src="button/back.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:backto()">
      </td>
    </tr>
   </table>
   </td>
   </tr>


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
                    alert( "Please log in to the system first!");
                    parent.document.URL = 'enter.jsp';
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
        Vector vet = new Vector();
        sysInfo.add(sysTime + "Exception occourred in the management of Web Skin!");// 系统铃音管理过程出现异常!
        sysInfo.add(sysTime + e.toString());

        vet.add("Error occourred in the management of Web Skin!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="webSkinInfo.jsp?itemno=<%=itemno%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>
