    <html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="keywords" content="jquery,ui,easy,easyui,web">
    <meta name="description" content="easyui help you build your web page easily!">
    <title>Expand row in DataGrid to show details - jQuery EasyUI Demo</title>
    <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/demo/demo.css">
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="http://www.jeasyui.com/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="http://www.jeasyui.com/easyui/datagrid-detailview.js"></script>
    </head>
    <body>
    <h2>Expand row in DataGrid to show details</h2>
    <div class="demo-info" style="margin-bottom:10px">
    <div class="demo-tip icon-tip">&nbsp;</div>
    <div>Click the expand button to expand row and view details.</div>
    </div>
    
    <table id="dg" style="width:700px;height:250px" url="datagrid8_getdata.jsp"pagination="true" sortName="itemid" sortOrder="desc"
    title="DataGrid - Expand Row" singleSelect="true" fitColumns="true">    
    <thead>
    <tr>
    <th field="itemid" width="80">Item ID</th>
    <th field="productid" width="100">Product ID</th>
    <th field="listprice" align="right" width="80">List Price</th>
    <th field="unitcost" align="right" width="80">Unit Cost</th>
    <th field="attr1" width="220">Attribute</th>
    <th field="status" width="60" align="center">Status</th>
    </tr>
    </thead>    
    </table>
    
    
    <script type="text/javascript">
    $(function(){
	    $('#dg').datagrid({
	    view: detailview,
	    detailFormatter:function(index,row){
	    	return '<div class="ddv" style="padding:5px 0"></div>';
	    },
	    onExpandRow: function(index,row){
		    var ddv = $(this).datagrid('getRowDetail',index).find('div.ddv');
		    ddv.panel({
			    height:80,
			    border:false,
			    cache:false,
			    href:'datagrid21_getdetail.php?itemid='+row.itemid,
			    onLoad:function(){
			    	$('#dg').datagrid('fixDetailRowHeight',index);
			    }
		    });
		    $('#dg').datagrid('fixDetailRowHeight',index);
	    }
	    });
    });
    </script>
    </body>
    </html>