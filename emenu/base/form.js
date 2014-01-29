/**
 * <p>Title: Tao Framework</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2004</p>
 * <p>Company: ZTE Corp.</p>
 * @author Jackie Lee
 * @version 1.0
 */
if(!FormManager)
   var FormManager =  new FormManager_();

    var TYPE_TEXT = "text"; //1
    var TYPE_NUMBER = "number";//2
    var TYPE_FLOAT = "float";//3
    var TYPE_INT = "int";//4
    var TYPE_MAIL = "mail";
    var  TYPE_DATE = "date";
    var TYPE_TIME = "time";
    var TYPE_PASSWORD = "password";

    var MODULE_NAME = "";

function FormManager_(){
    this.List = new Array();

    this.push = function (aForm){
       this.List[aForm.key] = aForm;
    }

    this.get = function(key){
        var form = this.List[key];
        if(!form){
            form  = new Form(key);
        }
        return form;
    }
    this.remove = function(key){
        this.List[key] = null;
    }
}



function Form(aName){

    this.key = aName;
    FormManager.push(this);
    this.contidion = "";
    this.current = -1;
    this.count = 0;
    this.fields = new Array();
    this.fieldValues = new Array();
    this.fieldnumber = 0;
    this.status = "new";// new,browser,modified,deleted

    this.setCondition = function(cond){
        this.contidion = cond;
        // do query
    }

    this.refresh = function(aUrl){
        var sequence = 0;
        var url = "";
        if(!aUrl||aUrl==null)
            url = MODULE_NAME+
            "/xmlloaddata.action?modelname="+this.key+"&startnum="+sequence+"&endnum="+sequence+"&"+this.contidion;
        else
            url = MODULE_NAME+aUrl+"?modelname="+this.key+"&startnum="+sequence+"&endnum="+sequence+"&"+this.contidion;
        var domdoc = PostInfotoServer(url,null);
        if(domdoc){
            var result = domdoc.getElementsByTagName("MSG");
            var failed = false;
            if(result){
                var size = result.length;
                var info = "";
                for(var i =0;i<size;i++){
                    var v = result.item(i).attributes.getNamedItem("TYPE");;
                    if(v.nodeValue=='ERROR')
                        failed = true;
                    info += result.item(i).text+"\n";
                }
                showMessage(info);
            }
            if(!failed){
                var result = domdoc.getElementsByTagName("DATA").item(0);
                var children = result.childNodes;
                var size = children.length;
                for(var i =0;i<size;i++){
                    var name = children.item(i).nodeName;
                    var value = children.item(i).text;
                    this.setFieldValue(name,value);
                }
            }
        }
        this.current = sequence;
        this.setStatus('browser');
    }
    this.turnTo = function(sequence){
        if(sequence<0||sequence>=this.count){
            showMessage("Irregular record number");//不合法的记录笔数
        }
        var url = MODULE_NAME+
            "/xmlloaddata.action?modelname="+
            this.key+"&startnum="+sequence+"&endnum="+sequence+"&"+this.contidion;
        var domdoc = PostInfotoServer(url,null);
        if(domdoc){
            var result = domdoc.getElementsByTagName("MSG");
            var failed = false;
            if(result){
                var size = result.length;
                var info = "";
                for(var i =0;i<size;i++){
                    var v = result.item(i).attributes.getNamedItem("TYPE");;
                    if(v.nodeValue=='ERROR')
                        failed = true;
                    info += result.item(i).text+"\n";
                }
                showMessage(info);
            }
            if(!failed){
                var result = domdoc.getElementsByTagName("DATA").item(0);
                var children = result.childNodes;
                var size = children.length;
                for(var i =0;i<size;i++){
                    var name = children.item(i).nodeName;
                    var value = children.item(i).text;
                    this.setFieldValue(name,value);
                }
            }
        }
        this.current = sequence;
        this.setStatus('browser');
    }

    this.addField = function(name){
        this.fields[this.fieldnumber]=name;
        this.fieldnumber++;
    }

    this.create = function(){
        for(var i=0;i<this.fields.length;i++){
              var name = this.fields[i];
              this.setFieldValue(name,"");
        }
        this.setStatus('new');
        clearMessage();
    }

    this.remove = function(){
        var state = this.getStatus();
        if(state == 'new'){
            // showMessage("新增表单不可删除!");
            showMessage("The new table sheet can't be deleted!");
             return;
        }
        this.setStatus('deleted');
        this.save('');
    }

    this.getFieldIndex = function(name){
       for(var i=0;i<this.fields.length;i++){
            if(this.fields[i] == name)
                return i;
       }
       showMessage("Table sheet:"+name+" don't exists!");
       return -1;
    }

    this.setFieldValue = function(name,value){
        var index= this.getFieldIndex(name);
        if(index == -1)
            return;
        this.fieldValues[name]=value;
        var item = eval("document."+this.key+"."+name);
        var type = item.fieldtype;
        if(type =="time")
           TimerManager.get1(name).setTime(value);
        else
           item.value=value;
    }
    this.getFieldValue = function(name){
        var item = eval("document."+this.key+"."+name);
        return item.value;
    }

    this.first = function(){
        if(this.count<=0||this.current<0){
            showMessage("No date for review!");//没有数据浏览
            return;
        }
        if(this.current==0){
            showMessage("Current is the first data!");//当前已经是第一笔数据
            return;
        }
        this.turnTo(0);
    }

    this.previous = function(){
        if(this.count<=0||this.current<0){
            showMessage("No data for review!");//没有数据浏览
            return;
        }
        if(this.current==0){
            showMessage("Current is the first data!");//当前已经是第一笔数据
            return;
        }
        this.turnTo(this.current-1);
    }

    this.next = function(){
        if(this.count<=0||this.current<0){
            showMessage("No data for review!");//没有数据浏览
            return;
        }
        if(this.current==this.count-1){
            showMessage("Current is the last data!");//当前已经是最后一笔数据
            return;
        }
        this.turnTo(this.current+1);
    }

    this.last = function(){
        if(this.count<=0||this.current<0){
            showMessage("No data for review!");//没有数据浏览
            return;
        }
        if(this.current==this.count-1){
            showMessage("Current is the last data!");//当前已经是最后一笔数据
            return;
        }
        this.turnTo(this.count-1);
    }

    this.setStatus = function(state){
        this.status = state;
    }
    this.getStatus = function(){
        return this.status;
    }

    this.setCount = function(count){
        this.count = count;
    }

    this.setCurrent= function(current){
        this.current = current;
    }

    this.save = function(url){
       var v =  this.validity();
       if(!v)
           return;
        this.checkModified();
        var state = this.getStatus();
        if(state == 'browser'){
             //showMessage("表单内容没有变动,无须保存!");
             showMessage("The table content doesn't change,no need to save!");
             return;
        }
        var list = new Array();
        list.push(this);
        var domdoc
        if(url!=null&&url!='')
            domdoc = saveRowSet(MODULE_NAME+url,list);
        else
            domdoc = saveRowSet(MODULE_NAME+'/xmlsave.action',list);
        if(domdoc){
            var result = domdoc.getElementsByTagName("MSG");
             var failed = false;
            if(result){
                var size = result.length;
                var info = "";
                for(var i =0;i<size;i++){
                    var v = result.item(i).attributes.getNamedItem("TYPE");;
                    if(v.nodeValue=='ERROR')
                        failed = true;
                    info += result.item(i).text+"\n";
                }
                //保存成功
                if(!failed){
                    var state = this.getStatus();
                    if(state == 'new'||state == 'modified'){
                        for(var i=0;i<this.fields.length;i++){
                                var name = this.fields[i];
                                var item = eval("document."+this.key+"."+name);
                                var realValue = item.value;
                                this.setFieldValue(name,realValue);
                        }
                         if(state == 'new') {
                            var result = domdoc.getElementsByTagName("DATA").item(1);
                            if(result){
                              var children = result.childNodes;
                              var size = children.length;
                              for(var i =0;i<size;i++){
                              var name = children.item(i).nodeName;
                              var value = children.item(i).text;
                              this.setFieldValue(name,value);
                              }
                            }
                         }
                        this.setStatus('browser');
                    }else if(state == 'deleted'){
                        this.create();
                    }

                }
                showMessage(info);
             }else{
                    var state = this.getStatus();
                    if(state == 'new'||state == 'modified'){
                        for(var i=0;i<this.fields.length;i++){
                                var name = this.fields[i];
                                var item = eval("document."+this.key+"."+name);
                                var realValue = item.value;
                                this.setFieldValue(name,realValue);
                        }
                         if(state == 'new') {
                            var result = domdoc.getElementsByTagName("DATA").item(1);
                            if(result){
                              var children = result.childNodes;
                              var size = children.length;
                              for(var i =0;i<size;i++){
                              var name = children.item(i).nodeName;
                              var value = children.item(i).text;
                              this.setFieldValue(name,value);
                              }
                            }
                         }
                        this.setStatus('browser');
                    }else if(state == 'deleted'){
                        this.create();
                    }
             }
        }
    }

    this.validity = function(){
        var message = "";
        for(var i=0;i<this.fields.length;i++){
            var item = eval("document."+this.key+"."+this.fields[i]);
            var type = item.fieldtype;
            var editable = item.editable;
            if(editable&&(editable=='false'))
                continue;
            var value = item.value;
            var name =this.fields[i];
            var oldvalue = this.fieldValues[name];
            if(oldvalue&&oldvalue!=null){
                if(value == oldvalue)
                    continue;
            }
            var nullable=item.nullable;
            if(nullable=='false'){
                if(!value||(value=='')){
                    message+="\n"+item.label+" cann't be null.";//不能为空
                }
            }
            if(type=="text"||type=="password"){//
                var min = item.minlength;
                if(!min)
                    min = -1;
                var max = item.maxlength;
                if(!max)
                    max = -1;
                  var msg = verifyText(value,min,max);
                  if(msg){
                    message+="\n"+item.label+":"+msg;
                  }
            }else if(type=='float'){
                var max = item.maxlength;
                if(!max)
                    max = -1;
                 var msg = verifyFloat(value,max);
                  if(msg){
                    message+="\n"+item.label+":"+msg;
                  }
            }else if(type=='int'){
                var max = item.maxlength;
                if(!max)
                    max = -1;
                 var msg = verifyInt(value,max);
                  if(msg){
                        message+="\n"+item.label+":"+msg;
                    mcount++;
                  }
            }
        }
        
        showMessage(message);
        		
//        if(document.all("messagearea")){
//            document.all("messagearea").innerHTML=message;
//        }else if(trim(message)!='')
//            alert(message);
        if(trim(message)=='')
            return true;
        return false;
    }

    this.checkModified = function(){
        var state = this.getStatus();
        if(state =='new'||state=='deleted')
            return null;
        var modified = new Array();
        for(var i=0;i<this.fields.length;i++){
            var name = this.fields[i];
            var oldvalue = this.fieldValues[name];
            var item = eval("document."+this.key+"."+name);
            var newValue = item.value;
            if(compare(oldvalue,newValue))
                continue;
//            alert("test");
            modified[name] = newValue;
            this.setStatus('modified');
        }
        return modified;
    }

    this.toXml = function(){
         var modified = this.checkModified();
        var state = this.getStatus();
        var str ="<DATA $FORMNAME='"+this.key+"' STATUS='"+this.getStatus()+"' >";
        for(var i=0;i<this.fields.length;i++){
            var name = this.fields[i];
            var value = this.fieldValues[name];
            if(state =='new'){
                var item = eval("document."+this.key+"."+name);
                var realValue = item.value;
                str +="<"+name+">"+realValue+"</"+name+">";
            }else if(modified!=null){
                var newValue = modified[name];
//                alert(newValue);
                if(newValue)
                    str +="<"+name+" OLD='"+value+"'>"+newValue+"</"+name+">";
                else
                    str +="<"+name+">"+value+"</"+name+">";
            }else
                    str +="<"+name+">"+value+"</"+name+">";
        }
        str +="</DATA>";
        return str;
    }
}

