{$, $$$, ScrollView} = require 'atom'
module.exports =
class TerminalView extends ScrollView
  @content: ->
    @div class: 'ask-stack-result native-key-bindings', tabindex: -1, =>
      @iframe src:'http://localhost:57772/csp/sys/webterminal/index.csp', width: '100%', height:'100%', frameborder:'0'



  initialize: ->
    super

  destroy: ->
    @unsubscribe()

  getTitle: ->
    'terminal'

  getUri: ->
    'cache-studio://terminal-view'

  getIconName: ->
    'three-bars'

  handleEvents: ->
