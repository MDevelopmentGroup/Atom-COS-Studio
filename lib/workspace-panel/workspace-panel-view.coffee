{View, $$$,$} = require 'atom'
RemoteTreeView=require '../remote-tree-view/tree-view'
TreeView=require '../tree-view/tree-view'
Tree=require '../tree-view/tree'
fsp= require 'fs-plus'
module.exports =
class WorkSpacePanelView extends View
  TempDir:''
  SudioAPI:null
  @content: ->
    @div class: 'workspace-panel-view tool-panel native-key-bindings ', tabindex: -1, =>
      @ul tabindex:-1, class:'list-inline tab-bar insertpanel',id:'TabMenu1', outlet:'TabMenu'
      @div style:'height:100%', outlet:'BodyHTML', =>
        @div style:'height:93%', id:'ScopeTree', outlet:'ScopeTree'
        @div '',id:'ProjectTree', outlet:'ProjectTree'
        @div '',id:'ProjectsTree', outlet:'ProjectsTree'
      @div style:'height:50px', ''

  initialize: (Param={},studioApi)->
    @SudioAPI=studioApi
    items=[{title:'Project'},{title:'Scope'}]
    @setTabMenuItems(items)
    @TempDir=atom.config.get('Atom-COS-Studio.TempDir')
    if not @hasParent()
      atom.workspaceView.prependToLeft(this)
      @bind(this)

    remoteTreeView =new RemoteTreeView({NS:Param.NS, Type:'scope', defProject:Param.PRJ},@SudioAPI)
    @ScopeTree.html remoteTreeView

    @treeView =new TreeView()
    @Path="#{@TempDir}#{Param.NS}\\#{Param.PRJ}"
    fsp.mkdir @Path, (e) =>
      atom.project.setPath(@Path)
      @ProjectTree.html @treeView
      @treeView.toggle()


  serialize: ->
  viewForItem: (item) ->
    out=$$$ ->
      @li class:'tab sortable', id:"#{item.title}", =>
        @div class:"title #{item.icon}", " #{item.title}"
        #@div class:'close-icon'
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
    itemMenu=$(this).find("##{name}")
    itemMenu?.addClass('active')
    for item in @BodyHTML[0].children
      if $(item)[0].id=="#{name}Tree"
        $(item).removeClass('hide')
      else
        $(item).addClass('hide')
    #itemBody=$(this).find("##{name}Tree")
    #itemBody?.removeClass("hide").addClass('show')
  bind: (class1) ->
    $("#TabMenu1 li").click ->
      name= $(this).attr('id')
      class1.setActive(name)
