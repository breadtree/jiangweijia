<%@page import="java.io.*"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Hashtable"%>
<%@include file="../pubfun/JavaFun.jsp"%>
<%@page import="zxyw50.JspUtil"%>
<%@page import="zxyw50.SocketPortocol"%>
<%@page import="zxyw50.bulletin.*"%>
<%@ page import="zxyw50.group.util.DateUtil" %>
<%@page import="zxyw50.group.util.*"%>


<%
  response.addHeader("Cache-Control", "no-cache");
  response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script language="Javascript1.2" src="calendar.js"></script><html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Manage bulletin info</title>
</head>
<body  background="background.gif" topmargin="0" leftmargin="0" >
<%
   String sysTime = "";
   int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
  Vector sysInfo = (Vector) application.getAttribute("SYSINFO");
  String operID = (String) session.getAttribute("OPERID");
  String operName = (String) session.getAttribute("OPERNAME");
  Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable) session.getAttribute("PURVIEW");
  List arraylist = null;
  String edit = null;
  try {
    String errmsg = "";
String btype =  "";
    boolean flag = true;
    if (purviewList.get("4-15") == null) {
      errmsg = "You have no access to this function!";//You have no access to this function
      flag = false;
    }
    if (operID == null) {
      errmsg = "Please log in to the system first!";//Please log in to the system
      flag = false;
    }
    if (flag) {
      DefaultBulletinContext context = new DefaultBulletinContext();
      edit = JspUtil.getParameter(request.getParameter("edit"));
      String delete = JspUtil.getParameter(request.getParameter("delete"));
      String create = JspUtil.getParameter(request.getParameter("create"));
      String validdate = DateUtil.toString(DateUtil.getCurrentDate(),DateUtil.DEFAULT_DATE_FORMAT);
      List spinfo = SPInfoCached.getInstance().load();
      StringBuffer strOption=new StringBuffer("");
      String currentdate = validdate;
      String expiredate = "2999.12.31";
      BulletinObj currentobj = null;
      String index = "";
      // 准备写操作员日志
      zxyw50.Purview purview = new zxyw50.Purview();
      HashMap map = new HashMap();
      map.put("OPERID",operID);
      map.put("OPERNAME",operName);
      map.put("OPERTYPE","318");
      map.put("RESULT","1");
      if(delete.equals("1")){//delete
          String bindex = JspUtil.getParameter(request.getParameter("index"));
          context.deleteBulletin(new BulletinObj(bindex,null,null,null,null,null,null,null,null,null));
          sysInfo.add(sysTime + operName + " delete bulletin info:" + bindex + " successfully!");
          map.put("PARA1",bindex);
          map.put("PARA2","Delete");
          map.put("PARA3","ip:"+request.getRemoteAddr());
          purview.writeLog(map);
          %>
          <script  language="javascript">
          alert("Bulletin info :"+ <%=bindex%> + ",deleted successfully!");//删除公告信息  成功!
          </script>
      <%}
      if(edit.equals("1")){
          index = JspUtil.getParameter(request.getParameter("index"));
          currentobj = context.loadBulletin(index);
      }
      else if (create.equals("1")) {//新增orEdit
        String date = JspUtil.getParameter(request.getParameter("validdate"));
        if(date!=null&&!date.equals(""))
            validdate = date;
        date = JspUtil.getParameter(request.getParameter("expiredate"));
        if(date!=null&&!date.equals(""))
            expiredate = date;
        String bindex = JspUtil.getParameter(request.getParameter("bindex"));
        String reader = JspUtil.getParameter(request.getParameter("readercode"));
        if(reader.equals(""))
           reader = "u";
        String title = JspUtil.getParameter(request.getParameter("title"));
        String content = JspUtil.getContent(request.getParameter("content"));
        btype =  JspUtil.getParameter(request.getParameter("btype"));
        String strOp = request.getParameter("op") == null ? "" : request.getParameter("op");

//        if(bindex.equals(""))
        if ("create".equals(strOp))
        {
           if("".equals(btype))
               reader = "u";

            BulletinObj obj = new BulletinObj("",btype,"",validdate,expiredate,operID,reader,title,content,"");
            context.createBulletin(obj);
            sysInfo.add(sysTime + operName + " New bulletin info:" + title + ",added successfully!");
             map.put("PARA1",bindex);
             map.put("PARA2","Add");
             map.put("PARA3","ip:"+request.getRemoteAddr());
             map.put("DESCRIPTION",title);
             purview.writeLog(map);
            %>
            <script  language="javascript">
            alert("New bulletin info added successfully!");//新增公告信息成功
            </script>
          <%
        }
        else if ("edit".equals(strOp))
        {
            reader = JspUtil.getParameter(request.getParameter("bulletinobj"));
            btype = JspUtil.getParameter(request.getParameter("bulletintype"));
            BulletinObj obj = new BulletinObj(bindex,btype,"",validdate,expiredate,operID,reader,title,content,"");
            context.modifyBulletin(obj);
            sysInfo.add(sysTime + operName + " Bulletin info:" + title + ",modified successfully!");//修改公告信息  成功!
            map.put("PARA1",bindex);
            map.put("PARA2","Edit");
            map.put("PARA3","ip:"+request.getRemoteAddr());
            map.put("DESCRIPTION",title);
            purview.writeLog(map);

            %>
            <script  language="javascript">
            alert("Bulletin info modified successfully!");//修改公告信息成功
            </script>
          <%
        }
      }
      for(int i=0;i<spinfo.size();i++){
          String[] str = (String[])spinfo.get(i);
          strOption.append("<option  value='");
          strOption.append(str[0]+"'");
          if(currentobj!=null){
              if(str[0].equals(currentobj.getReadercode()))
              strOption.append(" selected");
          }else{
              if(str[0].equals("0"))
              strOption.append(" selected ");
          }
          strOption.append(">");
          strOption.append(str[1]);
          strOption.append("</option>");
      }
      String allIndex = request.getParameter("index") == null ? "" : (String) request.getParameter("index");
      int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String) request.getParameter("page"));
      List vet = context.loadValidBulletins();
      int records = 10;
      int pages = vet.size() / records;
      if (vet.size() % records > 0)
        pages = pages + 1;
%>
<script language="javascript">
 function modeChange(){
     var disabled = document.liuyanForm.readercode.disabled;
      if(disabled){
         document.liuyanForm.readercode.disabled= '';
      }else
         document.liuyanForm.readercode.disabled= 'disabled';
   }
  function createbulletin(blEdit){
               if(document.liuyanForm.title.value==''||document.liuyanForm.title.value==null){
                   alert("Subject of the bulletin cannot be blank!");//公告主题不能为空
                   document.liuyanForm.title.focus();
                   return;
               }
               <%
               if(ifuseutf8 == 1){
                 %>
                 if(!checkUTFLength(document.liuyanForm.title.value,100)){
                   alert("Subject of the bulletin cannot exceed 100 characters.!");
                   document.liuyanForm.title.focus();
                   return;
                 }
                 <%
               }
               else{
                 %>
               if(strlength(trim(document.liuyanForm.title.value))>100){
                   alert("Subject of the bulletin cannot exceed 100 characters.!");//公告主题不能超过50个汉字长度
                   document.liuyanForm.title.focus();
                   return;
               }
                 <%}%>
               if(trim(document.liuyanForm.content.value)==''||document.liuyanForm.content.value==null){
                   alert("Content of the bulletin cannot be blank!");//公告内容不能为空
                   document.liuyanForm.content.focus();
                   return;
               }
               <%
               if(ifuseutf8 == 1){
                 %>
                 if(!checkUTFLength(document.liuyanForm.content.value,1000)){
                   alert("Content of the bulletin cannot exceed 1000 characters!");
                   document.liuyanForm.content.focus();
                   return;
                 }
                 <%
               }
               else{
                 %>
               if(strlength(trim(document.liuyanForm.content.value.length))>1000){
                   alert("Content of the bulletin cannot exceed 1000 characters!");//公告内容的长度不能超过1000个汉字
                   document.liuyanForm.content.focus();
                   return;
       }
                 <%}%>
       if (document.liuyanForm.ifedit.value==1)
       {
         document.liuyanForm.op.value = 'edit';
       }
       else
       {
         document.liuyanForm.op.value = 'create';
       }
       var validdate = document.liuyanForm.validdate.value;
       var expiredate = document.liuyanForm.expiredate.value;
       if(!compareDate2(validdate,expiredate)){
            alert("Start date cannot be later than End date!");//生效日期不能比失效日期晚
            return;
       }
   	document.inputForm.page.value=0;
	document.liuyanForm.submit();
   }
   function compareDate2 (beginDate, endDate) {
      beginDate = beginDate.substring(0,4) + beginDate.substring(5,7)+beginDate.substring(8,10) ;
      endDate = endDate.substring(0,4) + endDate.substring(5,7)+endDate.substring(8,10);
       if ((beginDate - endDate) >0)
         return false;
      return true;
   }

   function searchRing(){
   	document.inputForm.page.value=0;
	document.inputForm.submit();
   }

   function doCancel(){
       document.liuyanForm.bindex.value="";
       document.liuyanForm.btype.disabled="";
       if(document.liuyanForm.btype.value==0)
       {
       document.liuyanForm.readercode.disabled="";
       }
       else
       {
       document.liuyanForm.readercode.disabled=true;
       }

       document.liuyanForm.title.value='';
       document.liuyanForm.content.value="";
       document.liuyanForm.ifedit.value=0;
   }
   function doDelete(url){
       if (confirm("Are you sure you want to delete this bulletin?")){//你确定要删除该公告吗
           document.URL = url;
       }
   }
  function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }
   function goPage(){
      var fm = document.inputForm;
      var pages = parseInt(fm.pages.value);
      var thepage =parseInt(trim(fm.gopage.value));
      if(thepage==''){
         alert("Please specify the value of the page to go to!")//Please specify the value of the page to go to!
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
         alert("The value of the page to go to can only be a digital number!")//The value of the page to go to can only be a digital number
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!")//alert("转到的页码值范围不正确  页）!
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      toPage(thepage);
   }
</script><script language="JavaScript">
	var hei=900;
	parent.document.all.main.style.height=hei;
</script>
<form name="inputForm" method="post" action="spbulletin.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2">
  <tr>
    <td height="26" align="center" class="text-title" background="image/n-9.gif">Manage bulletin info</td>
  </tr>
  <tr>
    <td width="100%" align="center">
      <table width="100%" border="0" cellpadding="1" cellspacing="1" class="table-style1">
          <% if(vet.size()>0){ %>
          <tr class="table-title1">
              <td height="20" width="200">Bulletin title</td>
              <td height="20" width="100">Bulletin objects</td>
              <td height="20" width="80">Start date</td>
              <td height="20" width="80">End date</td>
              <td height="20" width="80">Operation</td>
          </tr>
          <%
          }
        int count = vet.size() == 0 ? records : 0;
        for (int i = thepage * records; i < thepage * records + records && i < vet.size(); i++) {
            String strcolor= i % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
          BulletinObj obj = (BulletinObj) vet.get(i);
          count++;
      %>
        <tr bgcolor="<%=strcolor %>" >
          <td  align="center" height="20" ><%=getLimitString(obj.getTitle(),50)%></td>
          <td align="center" height="20" ><%=SPInfoCached.getInstance().getSPName(obj.getReadercode())%></td>
          <td height="20" align="center" ><%=obj.getValiddate()%> </td>
          <td height="20" align="center" ><%=obj.getExpiredate() %></td>
          <td height="20" align="center" ><span  onmouseover="this.style.cursor='hand'" onclick="doDelete('spbulletin.jsp?delete=1&index=<%=obj.getIndex()%>')" >Delete</span>
              <a href="spbulletin.jsp?edit=1&index=<%=obj.getIndex()%>">Edit</a> </td>
        </tr>
      <%}      %>
      </table>
    </td>
  </tr>
<%if (vet.size() > records) {%>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td> &nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%records==0?vet.size()/records:vet.size()/records+1 %>&nbsp;pages&nbsp;&nbsp;You are now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * records + records >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / records %>)"></td>
        </tr>
        <tr>
          <td colspan="5" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >Page&nbsp;</td>
             <td> <input style=text  value="<%= String.valueOf(thepage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
             <td ><img src="../button/go.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:goPage()"  ></td>
            </tr>
            </table>
          </td>
       </tr>
      </table>
    </td>
  </tr>
<%}%>

</form>
<tr>
  <td width="100%">
    <table border="0" cellPadding="0" cellSpacing="0" width="100%" class="table-style1">
      <tr>
        <td>
            <table border="0" cellPadding="0" cellSpacing="0" width="526">
            <tr>
              <td align="middle">
                <a name="leaveword">
                    <br>
                <form method="post" name="liuyanForm" action="spbulletin.jsp">
                  <input type="hidden" name="create" value="1">
                  <input type="hidden" name="bindex" value="<%=index%>">
                  <input type="hidden" name="op" value="">
                  <input type="hidden" name="bulletintype" value="<%=currentobj == null ? "" : currentobj.getType()%>">
                  <input type="hidden" name="bulletinobj" value="<%=currentobj == null ? "" : currentobj.getReadercode()%>">
                  <input type="hidden" name="ifedit" value="<%=edit%>">
                  <table align="center" border="0" cellPadding="0" cellSpacing="0" class="table-style2">
                      <tr>
                        <td  valign="top">
                            Bulletin Type:
                            <select <%=(currentobj==null?"":"disabled")%>  style="width:160" onchange="modeChange()" name="btype" size="1"  >
                                    <option  value='0' <%=(currentobj==null?"selected":(currentobj.getType().equals("0")?"selected":""))%> >Provider</option>
                                    <option  value='1'  <%=(currentobj==null?"":(currentobj.getType().equals("1")?"selected":""))%> >Subscriber</option>
                            </select>
                        </td>
                        <td   valign="top"><div id="sptype">Bulletin Object
                          <select   <%=(currentobj==null?"":"disabled")%>  style="width:160" name="readercode" size="1"  >
                            <%=strOption%>
                          </select>
                        </div>
                        </td>
                        </tr>
                        <tr>
                        <td valign="top">
                          Start date:
                          <input style="width:160" type="text" name="validdate" value="<%=(currentobj==null?currentdate:currentobj.getValiddate())%>" maxlength="10"  readonly onclick="OpenDate(validdate);">
                          </td>
                          <td valign="top" >
                          End date:
                          <input style="width:160" type="text" name="expiredate" value="<%=(currentobj==null?"2999.12.31":currentobj.getExpiredate()) %>" maxlength="10"   readonly onclick="OpenDate(expiredate);">
                         </td>
                        </tr>
                        <tr>
                        <td colspan="2"> Bulletin subject(No more than 100 characters):
                          <input  value="<%=(currentobj==null?"":currentobj.getTitle())%>"  style="width:350" type="text" name="title"  maxlength="100" >
                          </td>
                        </tr>
                        <tr>
                            <td   height="26" colspan="2"  >Bulletin content: (Newlines required. The content cannot exceed 1000 characters.)</td>
                        </tr>
                        <tr>
                            <td colspan="2">
                        <p>
                          <textarea cols="70"     name="content"  rows="20"><%=(currentobj==null?"":currentobj.getContent())%></textarea>
                       </p>
                        <p>    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          <img alt="OK" src="button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="createbulletin();" />
                          &nbsp;&nbsp;&nbsp;
                          <img alt="Cancel" src="button/cancel.gif" onmouseover="this.style.cursor='hand'" onclick="doCancel();" />
                          <br>
                            </td>
                        </tr>
                  </table>
                </form>
                </a>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </td>
</tr>
</table><%} else {%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   document.URL = 'enter.jsp';
</script><%
  }
  } catch (Exception e) {
    Vector vet = new Vector();
    sysInfo.add(sysTime + operName + "Exception occurred in managing bulletin info!");//公告信息管理过程出现异常
    sysInfo.add(sysTime + operName + e.toString());
    vet.add("Error occurred in managing bulletin info!");//公告信息管理过程出现错误
    vet.add(e.getMessage());
    session.setAttribute("ERRORMESSAGE", vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="spbulletin.jsp">
</form>
<script language="javascript">
    document.errorForm.submit();
</script><%}%>
</body>
</html>
