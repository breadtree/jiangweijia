    
if(!TableManager)
   var TableManager =  new TableManager_();

 //增加Array的删除属性
 Array.prototype.remove=function(obj){
 		var blFound = false;
    for(var i=0,n=0;i<this.length;i++){
        if(this[i].toString() == obj.toString()){
          blFound = true;
        }else{
					this[n++]=this[i];
        }
    }
    if (blFound){
   	 this.length-=1;
  	}
  }

function TableManager_(){
    this.List = new Array();
    this.Keys = new Array;
    this.push = function (aForm){
       this.List[aForm.name] = aForm;
       var k= this.Keys.length;
       this.Keys[k]=aForm.name;
    }
    this.get = function(name){
        var form = this.List[name];
        if(!form){
           form = new Table(name);
        }
        return form;
    }
    this.remove = function(key){
        this.List[key] = null;
    }
    this.upgrade = function(){
       var k= this.Keys.length;
       var msg="";
       for(i=0;i<k;i++){
          var table = this.List[this.Keys[i]];
          if(i>0)
             msg +="####";
          msg +=table.name+"!"+table.page+"!"+table.pages+"!"+table.pageRows+"!"+table.counts+"!"+table.startnum+"!"+table.endnum;
          var fm = eval("document."+this.Keys[i]);
          fm.$parameters.value=msg;
          fm.$STARTNUM.value=table.startnum;
          fm.$ENDNUM.value=table.endnum;
        }
    }
}
function Table(name)
{
	this.name = name;
        TableManager.push(this);
        this.page=1;
        this.pages=0;
        this.pageRows=20;
        this.counts=0;
        this.startnum=-1;
        this.endnum=-1;
        this.datas = new Array();
        this.checkFiledName = '';
        this.setCheckFiledName = function(checkFiledName){
        		this.checkFiledName = checkFiledName;
        }
        this.setPage = function(aPage){
            this.page = aPage;
        }
        this.setPages = function(aPages){
            this.pages = aPages;
        }
        this.setPageRows = function(rows){
            this.pageRows = rows;
        }
        this.setCounts = function(aCounts){
            this.counts = aCounts;
        }
        this.setStartnum = function(start){
            this.startnum = start;
        }
        this.setEndnum = function(end){
            this.endnum = end;
        }
        this.turnTo1 = function(){
             var fm = eval("document."+this.name);
             var sequence = parseInt(fm.$toPage.value);
             if (isNaN(sequence))
                alert('Invalid page!');
             else
                this.turnTo();
        }
        this.turnTo = function(){
            var fm = eval("document."+this.name);
            var pageRows = parseInt(this.pageRows);
            var current = parseInt(this.page);
            var count = parseInt(this.pages);
            var sequence = parseInt(fm.$toPage.value);
            if (!isNaN(sequence)){
              if (sequence <= 0 || sequence > count || current > count){
                alert('Invalid page!');
                return;
              }
            }else
              sequence = current;
              if(sequence==1){
              this.startnum = -1;
              this.endnum = -1;
            }else{
              this.startnum = pageRows * (sequence - 1);
              this.endnum = parseInt(this.startnum) + pageRows - 1;
            }
            if (sequence != '' && !isNaN(sequence)){
              this.page = sequence;
            }
            TableManager.upgrade();
            fm.submit();
        }
      this.first = function() {
          var fm = eval("document."+this.name);
          this.page = 1;
          fm.$toPage.value = '';
          this.turnTo();
      }
     this.last =function(){
        var fm = eval("document."+this.name);
        this.page = this.pages;
        fm.$toPage.value = '';
        this.turnTo();
      }
      this.prev =function(){
         var fm = eval("document."+this.name);
          if (this.page == 1){
            alert('Current page is the first page!');
            return;
          }
          this.page = this.page - 1;
          fm.$toPage.value = '';
          this.turnTo();
      }
      this.next =function(){
         var fm = eval("document."+this.name);
        if (parseInt(this.page) == parseInt(this.pages)){
          alert('Current page is the last page!');
          return;
        }
        if (this.page == '' || isNaN(this.page)){
          this.page = 1;
        }
        this.page = parseInt(this.page) + 1;
        fm.$toPage.value = '';
        this.turnTo();
      }

      //全选
     this.setSelectAll = function(){
     		var fm = eval("document."+this.name);
     		var checkBoxes = eval("fm." + this.checkFiledName);
     		var blChecked = eval("fm." + this.checkFiledName + "_0.checked");
     		if (checkBoxes){
                       this.datas = new Array();
     			if (checkBoxes.type && checkBoxes.type == 'checkbox'){
     					checkBoxes.checked = blChecked;
     					this.inspect(checkBoxes);
     				}else{
	     	 		for (i=0; i<checkBoxes.length; i++){
	      			checkBoxes[i].checked=blChecked;
	      			this.inspect(checkBoxes[i]);
	    			}
	    		}
	    	}
     	}

     	//解析执行函数
     	this.inspect = function(elm){
 			  for (var i in elm){
  				if (i == 'onclick'){
  				var methodName = elm.getAttribute(i).toString();
  				methodName = methodName.substring(methodName.indexOf('{')+1, methodName.lastIndexOf(',')) + ",'false')";
  				eval(methodName);
  				break;
  			}
  		}
		}

     	//获取指定列的选中的数据
     	this.getSelectedValue = function(){
     		return this.datas;
     	}

     	//单击事件的响应
       	this.checkBoxOnclick=function(checkIndex, obj, eventMethod, execEvent){
     		var fm = eval("document."+this.name);
     		var checkBoxes = eval("fm." + this.checkFiledName);
     		if (checkBoxes){
     			var chkbox;
     			if (checkBoxes.type && checkBoxes.type == 'checkbox'){
     				chkbox = checkBoxes;
     			}else if (checkIndex < checkBoxes.length){
	   				chkbox = checkBoxes[checkIndex];
    	 		}
    	 		if (chkbox){
    	 			if(chkbox.checked){
    				var nIndex = this.datas.length;
   					this.datas[nIndex] = obj;
  	   		}else{
     				this.datas.remove(obj);
     			}
     		}
     		}
     		//执行用户事件
     		if (eventMethod && eventMethod.length > 0 && (execEvent=='true')){
     			eval(eventMethod);
     		}
     	}
}
