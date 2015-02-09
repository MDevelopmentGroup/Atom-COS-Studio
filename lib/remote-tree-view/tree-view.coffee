{$, ScrollView, View} = require 'atom'
DirectoryView = require './directory-view'
#LocalStorage = window.localStorage

module.exports =
class TreeView extends ScrollView
  defProject:''
  SudioAPI:null
  @content: ->
    @div class: 'tree-view-resizer tool-panel', 'data-show-on-right-side': atom.config.get('tree-view.showOnRightSide'), =>
      @div class: 'tree-view-scroller', outlet: 'scroller', =>
        @ol class: 'tree-view-cache full-menu list-tree has-collapsable-children focusable-panel', tabindex: -1, =>
          @ol class: 'entries list-tree', outlet: 'list'
          #@li class: 'directory entry list-nested-item ', =>
            #@div outlet: 'header', class: 'header list-item', =>
            #  @span class: 'name icon icon-file-submodule', outlet: 'ScopeName'
            #@ol class: 'entries list-tree', outlet: 'list'
      @div class: 'tree-view-resize-handle', outlet: 'resizeHandle'

  initialize:(Param={},studioApi) ->
    @SudioAPI=studioApi
    @defProject=Param.defProject
    @on 'mousedown', '.tree-view-resize-handle', (e) => @resizeStarted(e)
  #  @ScopeName.html(Param.NS)
    RemoteTree = new DirectoryView({isRoot:true,Type:'Tree',name:Param.NS,NS:Param.NS,SubPackage:'', isExpanded: true, defProject:@defProject},@SudioAPI)
    @list.append(RemoteTree)


  resizeStarted: =>
    $(document).on('mousemove', @resizeTreeView)
    $(document).on('mouseup', @resizeStopped)

  resizeStopped: =>
    $(document).off('mousemove', @resizeTreeView)
    $(document).off('mouseup', @resizeStopped)

  resizeTreeView: ({pageX, which}) =>
    return @resizeStopped() unless which is 1

    if atom.config.get('tree-view.showOnRightSide')
      width = $(document.body).width() - pageX
    else
      width = pageX
    @width(width)
  resizeToFitContent: ->
    @width(1) # Shrink to measure the minimum width of list
    @width(@list.outerWidth())
