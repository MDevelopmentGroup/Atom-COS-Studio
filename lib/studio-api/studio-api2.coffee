#http = require 'http'
#http = require 'http'
{Client}= require './file_connect'
http=new Client()
module.exports =
class StudioAPI
  ServerURL:''
  WebAPP:'mdg-dev/'
  Login:null
  Password:null
  isAuth:false
  CSPCHD:''
  # initialise current module
    # Required ServerURL; for example 'http://localhost:57772/'
  constructor: (Params={}) ->
    @ServerURL=Params.ServerURL
    @WebAPP=Params.WebAPP if Params.WebAPP?
    @Login=Params.Login if Params.Login?
    @Password=Params.Password if Params.Password?
    @isAuth=Params.isAuth if Params.isAuth?
  destroy: ->
    # Public: [refactor ServerURL on current module]
    #
    # url - The [url] as {[string]}.
    #
    # Returns the [void] as `[]`.
  setURL:(url) ->
    @ServerURL=url
    # refactor WebAPP on current module
  setAPP:(app) ->
    @WebAPP=app

    # Public: [return current level of subpackage on target namespace]
    #
    # target     - [webpath (class, routine, csp or other)] as {[string]}.
    # namespace  - [target namespace] as {[string]}.
    # subpackage - [current level] as {[string]}.
    # callback   - [return current level of subpackage on target namespace] as {[function]}.
    #
    # Returns the [example {'children':[{'Name':'..'}]}] as {[object]}.
  getRemoteTree: (target,namespace,subpackage,callback) ->
    http.post @ServerURL + @WebAPP + 'Tree', {data:{namespace:namespace,target:target,subpackage:subpackage}}, (data,response) =>
      callback(JSON.parse(data))
  getSource: (target,namespace,name,callback) ->
    http.post @ServerURL + @WebAPP + 'Source', {data:{namespace:namespace,target:target,name:name}}, (data,response) =>
      callback(data)
  ItemExist: (param,NS,SubPackage,Name,callBack) ->
    callBack({Status:0})
  downloadProject: (namespace,project,callback) ->
    http.post @ServerURL + @WebAPP + 'downloadProject', {data:{namespace:namespace,project:project}}, (data,response) =>
      callback(JSON.parse(data))
  save:(data,callback) ->
    console.log data
    http.post @ServerURL + @WebAPP + 'Save', {data:data}, (data,response) =>
      console.log data
      callback(JSON.parse(data))
  complile:(data,callback) ->
    http.post @ServerURL + @WebAPP + 'Compile', {data:data}, (data,response) =>
      callback(JSON.parse(data))
