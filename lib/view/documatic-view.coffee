{$, $$$, ScrollView} = require 'atom'
url = require 'url'
module.exports =
class DocumaticView extends ScrollView
  @content:  ->
    @div class: 'ask-stack-result native-key-bindings', tabindex: -1, =>
      #@div outlet:'Output'
      @iframe outlet:'Src', width: '100%', height:'100%', frameborder:'0'



  initialize:(uri) ->
    url= uri.substr(25, uri.length)
    @Src[0].src=url
    #@content(namespace)
    super
  show: () ->
    #@Output.html("<iframe src='http://localhost:57772/csp/documatic/%25CSP.Documatic.cls?LIBRARY=mdg-dev&CLASSNAME=%25File' width= '100%', height='100%', frameborder='0'></iframe>")
    #@Output.html("<iframe src='http://localhost:57772/csp/documatic/%25CSP.Documatic.cls?LIBRARY=#{namespace}&CLASSNAME=#{classname}' width= '100%', height='100%', frameborder='0'></iframe>")
  destroy: ->
    @unsubscribe()

  getTitle: ->
    'documatic'

  getUri: ->
    'cache-studio://documatic-view'

  getIconName: ->
    'three-bars'

  handleEvents: ->
