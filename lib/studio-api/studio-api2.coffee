http = require 'http'
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
  getRemoteTree:(target,namespace,subpackage,callback) ->
    http.get @ServerURL + @WebAPP + target +"?NameSpace=" + namespace + "&SubPackage="+ subpackage, (response) =>
      callback(JSON.parse(response))
