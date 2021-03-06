var Client = require(__dirname+'/file_connect.js').Client;
//Создаем объект для обращения к серверу (Функции GET и POST)
client = new Client();
var Broker =function(url) {
  this.server = url; //'http://localhost:57772/mdg-dev/',
  this.webapp="mdg-dev/";
  /*NewClass : {
    data: { namespace: "",
            nameClass: "",
            Super: "",
            Abstract: "",
            Description: ""
            }
  },
  DeleteClass : {
    data: { namespace: "",
            nameClass: ""}
  },
  CompileClass : {
    data: { namespace: "",
            nameClass: ""}
  },
  UpdateClass : {
    data: { namespace: "",
            text: "",
            nameClass: ""}
  },
  Method : {
    data: { namespace: "",
            nameClass: "",
            ClassMethod: "",
            nameMethod: "",
            ReturnType: "",
            Private: "",
            Final: ""}
  },
  text : 'Class Example.Studio Extends (%Persistent,%Populate)'+'\r\n{'+'\r\n//hgjgjgjgh'+'\r\n}',
  Property : {
    data: { namespace: "",
            nameClass: "",
            nameProperty: "",
            Type: "",
            Relationship: "",
            Required: "",
            Calculated: "",
            Parameter: []//Parameter = [{ Name:"MAXLEN", Data:100},{Name:"MINLEN", Data:50}]
          }
  },
  Obj : {
    data:{
      NameSpace: "",
      ClassName: "",
      Parameters: "",
      TempDir:"",
      Path:""
    }
  },*/
  this.setURL=function(url){
    this.server=url;
  };
  this.setAPP=function(app){
    this.webapp=app;
  };
  this.compileall= function(Obj,CallBack){
  client.post( this.server+this.webapp + "compileall" ,{data:Obj}, function(data, response){
    CallBack(data);
  })};
  this.saveall= function(Obj,CallBack){
    client.post( this.server+this.webapp + "saveall" ,{data:Obj}, function(data, response){
      CallBack(JSON.parse(data));
  })};
  this.refresh= function(Obj,CallBack){
      client.post( this.server+this.webapp + "refresh" ,{data:Obj}, function(data, response){
        CallBack(JSON.parse(data));
  })};
  this.namespace= function(CallBack){
    client.post( this.server+this.webapp + "namespaces" ,{}, function(data, response){
     CallBack(JSON.parse(data));
  })};
  this.getpath= function(Obj,CallBack){
    client.post( this.server+this.webapp + "getpath" ,{data:Obj}, function(data, response){
      CallBack(JSON.parse(data));
    })};
  this.classlist= function(Obj, CallBack){
    client.post(this.server+this.webapp + "namespaces/classlist",{data:Obj}, function(data, response){
      CallBack(JSON.parse(data));
  })};
  this.sourcetext= function(Obj,CallBack){
    client.post(this.server+this.webapp + "namespaces/classname" , {data:Obj} , function(data, response){
      CallBack(JSON.parse(data));
  })};
  this.propertyparameter= function(Obj,CallBack){
    client.post(this.server+this.webapp+"getparameter/", {data:Obj}, function(data, response){
      CallBack(JSON.parse(data));
  })};
  this.createclass= function(Obj,CallBack){
      client.post(this.server+this.webapp+"createclass", {data:Obj}/*this.NewClass*/, function(data,response) {
    CallBack(data);
  })};
  this.compileclass=function(Obj,CallBack){
      client.post(this.server+this.webapp+"compilationclass", {data:Obj}/*this.CompileClass*/, function(data,response) {
    CallBack(data);
  })};
  this.deleteclass= function(Obj,CallBack){
      client.post(this.server+this.webapp + "deleteclass", {data:Obj}/*this.DeleteClass*/, function(data,response) {
    CallBack(data);
  })};
  this.updateclass= function(Obj, CallBack){
      client.post(this.server+this.webapp + "updateclass", {data:Obj}/*this.UpdateClass*/, function(data,response) {
    CallBack(data);
  })};
  this.method= function(Obj,CallBack){
      client.post(this.server+this.webapp + "createmethod", {data:Obj}/*this.Method*/, function(data,response) {
    CallBack(JSON.parse(data));
  })};
  this.property= function(Obj,CallBack){
      client.post(this.server+this.webapp + "createproperty", {data:Obj}/*this.Property*/, function(data,response) {
    CallBack(JSON.parse(data));
  })};
  return this;
};
module.exports = Broker;
