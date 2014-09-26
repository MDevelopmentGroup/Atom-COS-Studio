{$, ScrollView, View} = require 'atom'
StudioAPI= require 'StudioAPI'
DirectoryView = require './d-view'
DirectoryView1 = require './directory-view'
Directory = require './directory'
#LocalStorage = window.localStorage

module.exports =
class TreeView extends ScrollView
  @content: ->
    @div class: 'tree-view-resizer tool-panel', 'data-show-on-right-side': atom.config.get('tree-view.showOnRightSide'), =>
      @div class: 'tree-view-scroller', outlet: 'scroller', =>
        @ol class: 'tree-view-cache full-menu list-tree has-collapsable-children focusable-panel', tabindex: -1, outlet: 'list'
      @div class: 'tree-view-resize-handle', outlet: 'resizeHandle'

  initialize:(NS)->
    #super
    @root = new DirectoryView({isRoot:true,name:NS,NS:NS,SubPackage:'', isExpanded: true})
    @list.html(@root)
###
    focusAfterAttach = false
    scrollLeftAfterAttach = -1
    scrollTopAfterAttach = -1
    selectedPath = null

  afterAttach: (onDom) ->
    @focus() if @focusAfterAttach
    @scroller.scrollLeft(@scrollLeftAfterAttach) if @scrollLeftAfterAttach > 0
    @scrollTop(@scrollTopAfterAttach) if @scrollTopAfterAttach > 0
  serialize: ->
    #directoryExpansionStates: @root?.directory.serializeExpansionStates()
    #selectedPath: @selectedEntry()?.getPath()
    hasFocus: @hasFocus()
    attached: @hasParent()
    scrollLeft: @scroller.scrollLeft()
    scrollTop: @scrollTop()
    width: @width()
  detach: ->
    @scrollLeftAfterAttach = @scroller.scrollLeft()
    @scrollTopAfterAttach = @scrollTop()
  scrollTop: (top) ->
    if top?
      @scroller.scrollTop(top)
    else
      @scroller.scrollTop()

  scrollBottom: (bottom) ->
    if bottom?
      @scroller.scrollBottom(bottom)
    else
      @scroller.scrollBottom()###
