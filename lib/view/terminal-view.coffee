{$, $$$, ScrollView} = require 'atom'
##{BrowserWindow} = require 'atom-shell'
#BrowserWindow =require 'browser-window'
BrowserWindow = require('remote').require 'browser-window'

module.exports =
class TerminalView extends ScrollView
  @content: ->
    @div class: 'ask-stack-result native-key-bindings', tabindex: -1, =>
      @iframe src:'http://localhost:57772/csp/sys/webterminal/index.csp', sandbox='allow-same-origin', width: '100%', height:'100%', frameborder:'0'
      @div outlet:'test'
      #, sandbox='allow-same-origin'
      # name:'gh-enable-node-integration'



  initialize: ->
    super
    console.log BrowserWindow
    mainWindow = new BrowserWindow({width: 800, height: 600, frame: true });
    mainWindow.loadUrl('http://localhost:57772/csp/sys/webterminal/index.csp')
    #@test.html(mainWindow)
    mainWindow.show()
    ###console.log @test.WebContents.getUrl()###
  destroy: ->
    @unsubscribe()

  getTitle: ->
    'terminal'

  getUri: ->
    'cache-studio://terminal-view'

  getIconName: ->
    'three-bars'

  handleEvents: ->
