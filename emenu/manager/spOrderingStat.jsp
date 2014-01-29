<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara"%>
<%@ page import="zxyw50.manStat"%>
<%@ page import="zxyw50.SpManage"%>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="java.io.File" %>
<%@ page import="jxl.*"%>
<%@ page import="jxl.write.*"%>
<%@ include file="../pubfun/JavaFun.jsp" %>
<script src="../pubfun/JsFun.js"></script>
<%!
private String getLastMonthString()
{
  StringBuffer str = new StringBuffer();
  java.util.Calendar cal = new GregorianCalendar().getInstance();
  //cal.add(Calendar.MONTH,-1);
  int maxday=31;
  if(cal.get(cal.MONTH)%2==0)
  {
    maxday=30;
    if(cal.get(cal.MONTH)==2)
    {
      if ( (cal.get(cal.YEAR) % 4 == 0 && cal.get(cal.YEAR) % 100 != 0) || (cal.get(cal.YEAR) % 400 == 0))
      {
        maxday=29;
      }
      else
      {
        maxday=28;
      }
    }
  }
  //str.append(""+cal.get(cal.YEAR)+"."+cal.get(cal.MONTH)+"."+1);
  //str.append(" TO "+cal.get(cal.YEAR)+"."+cal.get(cal.MONTH)+"."+maxday);
  str.append( cal.get(cal.YEAR)+"."+cal.get(cal.MONTH)+"."+maxday);
  return str.toString();
}
%>
<%
response.addHeader("Cache-Control", "no-cache");
response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
String sysTime = "";
Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
String operID = (String)session.getAttribute("OPERID");
String operName = (String)session.getAttribute("OPERNAME");
Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
String ringdisplay = CrbtUtil.getConfig("ringdisplay","ringtone");
try {
  String  errmsg = "";
  boolean flag =true;
  zxyw50.Purview purview = new zxyw50.Purview();
  if (operID  == null){
    errmsg = "Please log in to the system first!";
    flag = false;
  }
  else if (purviewList.get("4-36") == null  || (!purview.CheckOperatorRightAllSerno(session,"4-36"))) {
    errmsg = "You have no access to this function!";
    flag = false;
  }
  if(!flag)
  {
%>
  <script language="javascript">
    alert("<%=  errmsg  %>");
    document.URL = 'enter.jsp';
  </script>
<%
  }
  else{
    String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
    String scp = (String)request.getParameter("scplist")==null?"133":(String)request.getParameter("scplist");
    String sp = (String)request.getParameter("sp")==null?"*":(String)request.getParameter("sp");
    String spName  = "All SP";
    String spcode ="";
    manSysPara  syspara = new manSysPara();
    ArrayList arraylist = new ArrayList();
    HashMap hash = new HashMap();

    ArrayList spInfo = syspara.getSPInfo();
    if(!(sp.equals("*"))){
       Hashtable tmph = new Hashtable();
       tmph = syspara.getSPCode(sp);
       spcode = (String)tmph.get("spcode");
       spName = (String)tmph.get("spname");
    }
    String optSCP = "";
    ArrayList scplist = syspara.getScpList();
    for (int i = 0; i < scplist.size(); i++)
    {
      optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
    }

    if(op.equals("bakdata") || op.equals(""))
    {
      if(!(sp.equals("*")) && spcode.length()!=0 )
      {
        hash.put("scp",scp);
        hash.put("spcode",spcode);
        hash.put("spindex",sp);
        hash.put("spname",spName);
        SpManage spman = new SpManage();
        arraylist = spman.spOrderingStat(hash);
      }
      else
      {
        hash.put("scp",scp);
        manStat manstat = new manStat();
        arraylist = manstat.spOrderStatAll(hash);
      }
      WritableWorkbook workbook =null;
      WritableSheet sheet =null;
      try
      {
        String filename = application.getRealPath("temp")+"/StatReport"+spcode+".xls";
        File file = new File(filename);
        if(file.exists())
        {
          file.delete();
        }
        workbook = Workbook.createWorkbook(file);
        sheet = workbook.createSheet("First Sheet", 0);
        sheet.setColumnView(0,15);
        sheet.setColumnView(1,35);
        sheet.setColumnView(2,25);
        sheet.setColumnView(3,15);
        sheet.setColumnView(4,15);
        sheet.setColumnView(5,15);
        sheet.setColumnView(6,25);
        Label label= null;
        //写入一级标题
        label = new Label(0, 1, "End Date:");
        sheet.addCell(label);
        label = new Label(1, 1, getLastMonthString());
        sheet.mergeCells(1,1,5,1);
        sheet.addCell(label);
        label = new Label(0, 2, "CP:");
        sheet.addCell(label);
        label = new Label(1, 2, spName);
        sheet.mergeCells(1,2,5,2);
        sheet.addCell(label);

        //写入二级标题（列名）
        label = new Label(0, 4, "Ring ID");
        sheet.addCell(label);
        label = new Label(1, 4, "Song Title");
        sheet.addCell(label);
        label = new Label(2, 4, "Artist");
        sheet.addCell(label);
        label = new Label(3, 4, "Category");
        sheet.addCell(label);
        label = new Label(4, 4, "Charge");
        sheet.addCell(label);
        label = new Label(5, 4, "Count");
        sheet.addCell(label);
        label = new Label(6, 4, "Total Price");
        sheet.addCell(label);
        int total=0;
        //写入数据
        for(int i=0;i<arraylist.size();i++){
          HashMap tmpMap = (HashMap) arraylist.get(i);
          label = new Label(0,i+5,tmpMap.get("RingID").toString());
          sheet.addCell(label);
          label = new Label(1,i+5,tmpMap.get("SongTitle").toString());
          sheet.addCell(label);
          label = new Label(2,i+5,tmpMap.get("Artist").toString());
          sheet.addCell(label);
          label = new Label(3,i+5,tmpMap.get("Category").toString());
          sheet.addCell(label);
          label = new Label(4,i+5,tmpMap.get("Charge").toString());
          sheet.addCell(label);
          label = new Label(5,i+5,tmpMap.get("Count").toString());
          sheet.addCell(label);
          label = new Label(6,i+5,tmpMap.get("TotalPrice").toString());
          sheet.addCell(label);
          try{
            total += Integer.parseInt(tmpMap.get("TotalPrice").toString());
          }
          catch(Exception e)
          {
            total += 0;
          }
        }

        //写入总和
        label = new Label(0, arraylist.size()+5, "Total Count");
        sheet.addCell(label);
        label = new Label(6, arraylist.size()+5, "$    "+String.valueOf(total));
        sheet.addCell(label);
      }
      catch(Exception ex)
      {
        System.out.println(ex.getMessage());
        System.out.println("Error occurs during the writting date to the excel file "+application.getRealPath("temp"));
      }
      finally{
        workbook.write();
        workbook.close();
      }
    }
%>
<html>
  <head>
    <title>Orderring statistics by SP</title>
    <link rel="stylesheet" type="text/css" href="style.css"/>
    <script language="javascript">
      function ReSearch()
      {
        var fm = document.InputForm;
        fm.op.value = 'bakdata';
        fm.submit();
      }
      function WriteDataInExcel1()
      {
        <% if(arraylist==null || arraylist.size()<1){ %>
        alert("You need not export data because there are no statistic data.");
        return;
        <% }else{%>
        var fm = document.InputForm;
        fm.op.value = 'bakdata';
        fm.target="top";
        fm.submit();
        <%}%>
      }

      function WriteDataInExcel()
      {
        <%-- if(arraylist==null || arraylist.size()<1){ --%>
        <% if(arraylist==null){ %>
        alert("No Stat.data for export!");
        return;
        <% }else{%>
        parent.location.href="downloadPic.jsp?filename=StatReport<%=spcode%>.xls&filepath=<%=application.getRealPath("temp").replace('\\','/')+"/"%>";
        <%}%>
      }
    </script>
    <script language="JavaScript">
      if(parent.frames.length>0)
        parent.document.all.main.style.height=600;
    </script>
  </head>
  <body background="background.gif" class="body-style1">
    <form name="InputForm" method="post" action="spOrderingStat.jsp">
      <input type="hidden" name="op" value="<%= op%>" />
      <table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2" height=500 align="center">
        <tr>
          <td valign="top" height="35">
            <table class="table-style2" width="100%">
              <tr>
                <td height="30" align="center" class="text-title" >SP <%=ringdisplay%> Order Statistics</td>
              </tr>
              <tr>
                <td height="30" align="center" class="text-title" ></td>
              </tr>
              <tr>
                <td height="26" align="center"  >Please select SCP&nbsp;
                  <select name="scplist" size="1" class="input-style1" onchange="javascript:ReSearch()">
                    <% out.print(optSCP); %>
                  </select>
                </td>
              </tr>
              <tr>
                <td align="center">Please select SP &nbsp;&nbsp;
                  <select name="sp" class="select-style1" onchange="javascript:ReSearch()">
                    <option value="*">-All SP-</option>
                    <%
                    for (int i = 0; i < spInfo.size(); i++) {
                      HashMap map1 = (HashMap)spInfo.get(i);
                      String spindex = (String)map1.get("spindex");
                      if (sp.equals(spindex)){
                        %>
                        <option value="<%= (String)map1.get("spindex") %>" selected><%= (String)map1.get("spname") %></option>
                        <%
                        }else
                        {
                          %>
                          <option value="<%= (String)map1.get("spindex") %>" ><%= (String)map1.get("spname") %></option>
                          <%
                          }
                        }
                        %>
                        </select>
                </td>
              </tr>
              <tr>
                <td height="15" align="center" class="text-title" ></td>
              </tr>
              <tr>
                <td align="center">
                  <img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()" alt=""/>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </form>
  </body>
</html>
<%
    }
  }
  catch(Exception e)
  {
  e.printStackTrace();
  Vector vet = new Vector();
  sysInfo.add(sysTime + operName + "It is abnormal during the query of SP order!");
  sysInfo.add(sysTime + operName + e.toString());
  vet.add("Error occurs during the query of SP order!");
  vet.add(e.getMessage());
  session.setAttribute("ERRORMESSAGE",vet);
  %>
  <html>
    <head>
      <title>Orderring statistics by SP</title>
    </head>
    <body>
      <form name="errorForm" method="post" action="error.jsp">
        <input type="hidden" name="historyURL" value="spOrderingStat.jsp">
      </form>
      <script language="javascript">
        document.errorForm.submit();
      </script>
    </body>
  </html>
<%
  }
%>
