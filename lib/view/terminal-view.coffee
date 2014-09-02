{$, $$$, ScrollView} = require 'atom'
##{BrowserWindow} = require 'atom-shell'
#BrowserWindow =require 'remote'.require 'browser-window'

module.exports =
class TerminalView extends ScrollView
  @content: ->
    @div class: 'ask-stack-result native-key-bindings', tabindex: -1, =>
      @iframe src:'http://localhost:57772/csp/sys/webterminal/index.csp', sandbox='allow-same-origin allow-scripts', width: '100%', height:'100%', frameborder:'0'



  initialize: ->
    super
    console.log '' #BrowserWindow
  destroy: ->
    @unsubscribe()

  getTitle: ->
    'terminal'

  getUri: ->
    'cache-studio://terminal-view'

  getIconName: ->
    'three-bars'

  handleEvents: ->
