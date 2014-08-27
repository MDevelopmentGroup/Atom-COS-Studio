{View} = require 'atom'

module.exports =
class OutputView extends View

  @content: ->
    @div class: 'output-view native-key-bindings tool-panel panel-bottom', outlet: 'runner', tabindex: -1, =>
      @pre class: 'stacktrace', outlet: 'output'


  initialize: ->

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  refresh: ->
    @output.empty()

  show: (state, stacktrace='')->
    if not @hasParent()
      atom.workspaceView.prependToBottom(this)
    @refresh()
  clear: ->
    @output.html('')
  save: (state, text) ->
    #pre = document.createElement('pre')
    #node = document.createTextNode(text)
    #pre.appendChild(node)
    state=parseInt(state)
    @output.append(text)


    status     = if state == 1 then '  ✓ saved \n' else '  × error saving \n'
    className  = if state == 1 then 'stdout' else 'stderr'

    result = document.createElement('span')
    result.className = className
    node = document.createTextNode(status)
    result.appendChild(node)
    #pre.appendChild(result)
    @output.append(result)
  compile: (text) ->
    text=text+'\n'
    @output.append(text)

  close: ->
    if @hasParent()
      @detach()
