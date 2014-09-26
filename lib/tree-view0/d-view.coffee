{$, View} = require 'atom'

#Directory = require './directory'
#FileView = require './file-view'
#File = require './file'
StudioAPI= require 'StudioAPI'
FileView = require './f-view'
module.exports =
class DirectoryView extends View
  @studioAPI:null
  @NS:null
  childrens:[]
  @collapsed:true
  @SubPackage:''
  @content: ->
    @li class: 'directory entry list-nested-item collapsed', =>
      @div outlet: 'header', class: 'header list-item', =>
        @span class: 'name icon', outlet: 'directoryName'
      @ol class: 'entries list-tree', outlet: 'entries'

  initialize: (Param={}) ->
    @studioAPI=new StudioAPI(atom.config.get('Atom-COS-Studio.UrlToConnect'))
    @NS=Param.NS
    @SubPackage=Param.SubPackage
    if Param.isRoot
      iconClass = 'icon-repo'
      @studioAPI.get Param.NS, @SubPackage, (children) =>
        #childrens=children.ClassList
        @Viewchildrens(children.ClassList)
    else
      iconClass = 'icon-file-directory'
    @setActive() if Param.isExpanded?

    @directoryName.addClass(iconClass)
    @directoryName.text(Param.name)



    @bind()

  show: ->
    @studioAPI.get @NS, @SubPackage, (children) =>
      #childrens=children.ClassList
      @Viewchildrens(children.ClassList)
  Viewchildrens:(childrens) ->
    for item in childrens
      if item.isFolder
        ex=new DirectoryView({isRoot:false, NS:@NS, name:item.DisplayName, SubPackage:item.Name})
      else
        ex=new FileView({name:item.DisplayName})
      @entries.append(ex)
  bind: ->
    ##$("li").click ->
    ##  name= $(this).attr('id')
    ##  cls.setActive(name)
    @header.on 'click', =>
      @setActive()
  setActive:  ->
    if @collapsed
      @removeClass("collapsed")
      @addClass('expanded')
      @collapsed=false
      @show()
    else
      @addClass("collapsed")
      @removeClass("expanded")
      @collapsed=true
      @entries.html('')
