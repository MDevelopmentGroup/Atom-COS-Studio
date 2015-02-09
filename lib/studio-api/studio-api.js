var Client = require(__dirname+'/file_connect.js').Client;
var http = require('http')
//Создаем объект для обращения к серверу (Функции GET и POST)
client = new Client();
var Broker =function(url) {
  this.server = url; //'http://localhost:57772/mdg-dev/',
  this.webapp="mdg-dev/";
  this.setURL=function(url){
    this.server=url;
  };
  this.setAPP=function(app){
    this.webapp=app;
  };
  this.tree= function(param,NS,SubPackage, CallBack){
    console.log(param,NS,SubPackage)
  client.get( this.server+this.webapp + param +"?NameSpace="+NS+"&SubPackage="+SubPackage,{}, function(data, response){
    console.log(JSON.parse(data))
    CallBack(JSON.parse(data));
  })};
  this.ItemExist= function(param,NS,SubPackage,Name,CallBack){
  client.get( this.server+this.webapp +"exist/"+ param +"?NameSpace="+NS+"&SubPackage="+SubPackage+"&Name="+Name ,{}, function(data, response){
    CallBack(JSON.parse(data));
  })};
  this.Project= function(NS,CallBack){
  client.get( this.server+this.webapp +"project"+ "?NameSpace="+NS ,{}, function(data, response){
    CallBack(JSON.parse(data));
  })};
  this.source= function(param,NS,Name,CallBack){
    console.log(param,NS,Name)
    http.get(this.server+this.webapp +"source/"+ param +"?NameSpace="+NS+"&Name="+Name , function(response){
      CallBack(response);
    });
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
      console.log(data)
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
