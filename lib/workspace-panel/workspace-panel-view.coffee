{View, $$$,$} = require 'atom'
TreeView=require '../tree-view0/tree-view1'
module.exports =
class WorkSpacePanelView extends View

  @content: ->
    @div id:'pane', '', =>
      @div class: 'workspace-panel-view native-key-bindings ', tabindex: -1, =>
        @ul tabindex:-1, class:'list-inline tab-bar insertpanel',id:'TabMenu1', outlet:'TabMenu'
        @div outlet:'BodyHTML'

  initialize: (items)->
    @setTabMenuItems(items)
    if not @hasParent()
      atom.workspaceView.prependToLeft(this)
      @bind(this)
    @treeView =new TreeView('MDG-DEV')
    @BodyHTML.html @treeView
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
