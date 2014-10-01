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
  defProject:''
  @content: ->
    @li class: 'directory entry list-nested-item collapsed', =>
      @div outlet: 'header', class: 'header list-item', =>
        @span class: 'name icon', outlet: 'directoryName'
      @ol class: 'entries list-tree', outlet: 'entries'

  initialize: (Param={}) ->
    @studioAPI=new StudioAPI(atom.config.get('Atom-COS-Studio.UrlToConnect'))
    @NS=Param.NS
    @defProject=Param.defProject
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

      sort=(a, b)->
        if (a.DisplayName < b.DisplayName)
          return -1
        if (a.DisplayName > b.DisplayName)
          return 1
        return 0
      @Viewchildrens(children.children.sort(sort))
  Viewchildrens:(childrens) ->
    for item in childrens
      if item.isFolder
        ex=new DirectoryView({isRoot:false, Type:@Type, NS:@NS, name:item.DisplayName, SubPackage:item.Name, defProject:@defProject})
      else
        ex=new FileView(item, @defProject, @NS)
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
