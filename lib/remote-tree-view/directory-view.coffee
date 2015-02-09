{$, View} = require 'atom'
FileView = require './file-view'
module.exports =
class DirectoryView extends View
  SudioAPI:null
  NS:null
  childrens:[]
  collapsed:true
  SubPackage:''
  Type:''
  defProject:''
  @content: ->
    @li class: 'directory entry list-nested-item collapsed', =>
      @div outlet: 'header', class: 'header list-item', =>
        @span class: 'name icon', outlet: 'directoryName'
      @ol class: 'entries list-tree', outlet: 'entries'
  initialize: (Param={},studioApi) ->
    @SudioAPI=studioApi
    @NS=Param.NS
    @defProject=Param.defProject
    @SubPackage=Param.SubPackage
    @Type=Param.Type
    if Param.isRoot
      @setActive()
      iconClass = 'icon-repo'
    else
      iconClass = 'icon-file-directory'

    @directoryName.addClass(iconClass)
    @directoryName.text(Param.name)

    @bind()

  show: ->
    @SudioAPI.getRemoteTree @Type, @NS, @SubPackage, (children) =>
      @Viewchildrens(children.children)
  Viewchildrens:(childrens) ->
    for item in childrens
      if item.isFolder
        ex=new DirectoryView({isRoot:false, Type:item.Target, NS:@NS, name:item.DisplayName, SubPackage:item.Name, defProject:@defProject},@SudioAPI)
      else
        ex=new FileView(item, @defProject, @NS, @SudioAPI)
      @entries.append(ex)
  bind: ->
    @header.on 'click', =>
      @setActive()
  setActive:  ->
    if @collapsed
      @removeClass("collapsed").addClass('expanded')
      @show()
      @collapsed=false
    else
      @addClass("collapsed").removeClass("expanded")
      @entries.html('')
      @collapsed=true
