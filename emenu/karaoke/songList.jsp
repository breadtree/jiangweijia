<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%

	HashMap map = new HashMap();
	map.put("category","0"); //s50ring.subindex = s50catalog.allindex =0 for background music songs

	ArrayList result = new ArrayList();
	ArrayList data = new ArrayList();
	result = new zxyw50.RingQuery().getRingCategory(map);
	if(result.size()>0)
		data = (ArrayList)result.get(0);
	System.out.println("*****data size="+data.size());
	
	%>
	
	 <table cellpadding="2" cellspacing="0" border=0 style="margin-top:0">
	
	<% 
	for(int i=0; i<data.size();i++)
	{
		HashMap map1 = (HashMap) data.get(i);
	%>
		<tr <%= i%2!=0?"class='odd'":"" %>>
		<td width="82%"><%= map1.get("ringLabel")%></td>
		<td align="center" class="mic" title="Record" onclick="initRecord('<%=map1.get("ringId") %>','1','<%= map1.get("ringLabel")%>')"></td>
		</tr>
	 <%}%>
	</table> 	
	
		
