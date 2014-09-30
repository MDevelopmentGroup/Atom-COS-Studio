{$, View} = require 'atom'
StudioAPI= require '../studio-api/studio-api'
FileView = require './file-view'
module.exports =
class DirectoryView extends View
  studioAPI:null
  NS:null
  childrens:[]
  collapsed:true
  SubPackage:''
  Type:''
  @content: ->
    @li class: 'directory entry list-nested-item collapsed', =>
      @div outlet: 'header', class: 'header list-item', =>
        @span class: 'name icon', outlet: 'directoryName'
      @ol class: 'entries list-tree', outlet: 'entries'

  initialize: (Param={}) ->
    @studioAPI=new StudioAPI(atom.config.get('Atom-COS-Studio.UrlToConnect'))
    @NS=Param.NS
    @SubPackage=Param.SubPackage
    @Type=Param.Type
    if Param.isRoot
      iconClass = 'icon-repo'
      #@show()
    else
      iconClass = 'icon-file-directory'
    #@setActive() if Param.isExpanded?

    @directoryName.addClass(iconClass)
    @directoryName.text(Param.name)



    @bind()

  show: ->
    @studioAPI.tree @Type, @NS, @SubPackage, (children) =>
      #childrens=children.ClassList
      @Viewchildrens(children.children)
  Viewchildrens:(childrens) ->
    for item in childrens
      if item.isFolder
        ex=new DirectoryView({isRoot:false, Type:@Type, NS:@NS, name:item.DisplayName, SubPackage:item.Name})
      else
        ex=new FileView(item)
      @entries.append(ex)
  bind: ->
    ##$("li").click ->
    ##  name= $(this).attr('id')
    ##  cls.setActive(name)
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
