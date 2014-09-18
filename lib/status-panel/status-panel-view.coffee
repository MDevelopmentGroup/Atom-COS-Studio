{View, $$$,$} = require 'atom'
DocumaticView=require '../view/documatic-view'
module.exports =
class StatusPanelView extends View

  @content: ->
    @div id:'panerrr', '', =>
      @div style:"cursor:s-resize; with:100%;height:2px", outlet:'rrr'
      @div class: 'output-view native-key-bindings tool-panel panel-bottom', tabindex: -1, =>
        @ul tabindex:-1, class:'list-inline tab-bar insertpanel',id:'TabMenu1', outlet:'TabMenu'
        @pre class: 'stacktrace', =>
          @div class:'stacktrace', outlet:'BodyHTML'

  initialize: (items)->
    @setTabMenuItems(items)
    if not @hasParent()
      atom.workspaceView.prependToBottom(this)
    @bind(this)

    #console.log documaticView=new DocumaticView("#{atom.config.get('Atom-COS-Studio.UrlToConnect')}csp/documatic/%25CSP.Documatic.cls?LIBRARY=ILDARSHOW&CLASSNAME=WEB.Broker")
    #@BodyHTML.html(documaticView)
    # onmousedown
    # onmousemove
    # onmouseup

  serialize: ->
  viewForItem: (item) ->
    out=$$$ ->
      @li class:'tab sortable', id:"#{item.title}", =>
        @div class:"title #{item.icon}", " #{item.title}"
        @div class:'close-icon'
    out
  setTabMenuItem: (item) ->
    @TabMenu.append @viewForItem item
  setTabMenuItems:(items) ->
    for item,index in items
      @TabMenu.append @viewForItem item
      if index==items.length-1
        @setActive(item.title)
  bodyItem: (item) ->
    $$$ ->
      @div class:'', outlet:'item', =>
        @div outlet:'content'
  setbodyItem: () ->
  setActive: (name) ->
    $('.active')?.removeClass("active")
    item=$(this).find("##{name}")
    item?.addClass('active')
  bind: (class1) ->
    $("#TabMenu1 li").click ->
      name= $(this).attr('id')
      class1.setActive(name)
