{$, ScrollView, View} = require 'atom'
DirectoryView = require './directory-view'
#LocalStorage = window.localStorage

module.exports =
class TreeView extends ScrollView
  @content: ->
    @div class: 'tree-view-resizer tool-panel', 'data-show-on-right-side': atom.config.get('tree-view.showOnRightSide'), =>
      @div class: 'tree-view-scroller', outlet: 'scroller', =>
        @ol class: 'tree-view-cache full-menu list-tree has-collapsable-children focusable-panel', tabindex: -1, =>
          @li class: 'directory entry list-nested-item ', =>
            @div outlet: 'header', class: 'header list-item', =>
              @span class: 'name icon icon-file-submodule', outlet: 'ScopeName'
            @ol class: 'entries list-tree', outlet: 'list'
      @div class: 'tree-view-resize-handle', outlet: 'resizeHandle'

  initialize:(Param={})->
    
    @ScopeName.html(Param.NS)
    if Param.Type=='scope'
      ClassView = new DirectoryView({isRoot:true,Type:'classes',name:"Class",NS:Param.NS,SubPackage:'', isExpanded: true})
      RoutineView = new DirectoryView({isRoot:true,Type:'routines',name:"Routine",NS:Param.NS,SubPackage:'', isExpanded: true})
      CSPView = new DirectoryView({isRoot:true,Type:'csp',name:"CSP",NS:Param.NS,SubPackage:'', isExpanded: true})
      @list.append(ClassView)
      @list.append(RoutineView)
      @list.append(CSPView)
    if Param.Type=='project'
      ProjectView = new DirectoryView({isRoot:true,Type:'project',name:"Projects",NS:Param.NS,SubPackage:'', isExpanded: true})
      @list.append(ProjectView)
