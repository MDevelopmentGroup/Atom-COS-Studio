{View} = require 'atom'
StudioAPI= require 'StudioAPI'
SelectNameSpaceView=require './view/select-namespace-view'
TreeView=require './tree-view/tree-view'
TerminalView=require './view/terminal-view'
#File=require './tree-view/file'
#FileView=require './tree-view/file-view'
module.exports =
class CacheStudioView extends View
  @content: ->
    @div class: 'cache-studio overlay from-top', =>
      @div "The CacheStudio package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "cache-studio:toggle", => @toggle()
    atom.workspaceView.command "cache-studio:namespace", => @namespace()
    atom.workspaceView.command "cache-studio:compile", => @compile()
    atom.workspaceView.command "cache-studio:termilal", => @termilal()
    atom.workspaceView.command 'core:save', => @save()
    #atom.
#    atom.project.setPath('C:/InterSystems/Cache/CSP/dance')
    @treeView =new TreeView()
    atom.workspace.registerOpener (uriToOpen) ->
      if 'cache-studio://terminal-view'==uriToOpen
        return new TerminalView()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
  namespace: ->
    #TreeView =new TreeView({directoryExpansionStates:'C:/temp/ILDARSHOW'})
    #TreeView.show()
    #console.log TreeView
    selectNameSpaceView=new SelectNameSpaceView()
    selectNameSpaceView.success (namespace) =>
      @NameSpace=namespace
      StudioAPI.Obj.data.NameSpace=namespace
      StudioAPI.getpath (fullpath) =>
        atom.project.setPath(fullpath.Path)
        @treeView.toggle()
        #atom.project.relativize(namespace)
      selectNameSpaceView.detach()
    selectNameSpaceView.cancel (call) =>
      selectNameSpaceView.detach()
  save: ->
    editor=atom.workspace.getActiveEditor()
    if @getProperties().type=='cls'
      StudioAPI.UpdateClass.data.namespace=@getProperties().namespace
      StudioAPI.UpdateClass.data.nameClass=@getProperties().name
      StudioAPI.UpdateClass.data.text=editor.getText()
      StudioAPI.updateclass (status) =>
        console.log status
  saveall: ->
  compile: ->
    @save()
    if @getProperties().type=='cls'
      StudioAPI.CompileClass.data.namespace=@getProperties().namespace
      StudioAPI.CompileClass.data.nameClass=@getProperties().name
      StudioAPI.compileclass (status) =>
        console.log status
        @treeView.updateRoot()
  compileall: ->
  getProperties:  ->
    name = ''
    namespace=''
    editor=atom.workspace.getActiveEditor()
    path=editor.getPath()
    file= path.substr((path.indexOf('Classes')+8), path.length).replace('\\', '.')
    temp=path.substr(0, (path.indexOf('Classes')-1))
    temp=temp.split('\\')
    namespace=temp[ (temp.length-1) ]
    type=file.substr((file.length-3), file.length)
    name=file.substr(0, (file.length-4))

    'namespace': namespace
    'name':name
    'path': path
    'file':file
    'type':type
  termilal: ->
    uri='cache-studio://terminal-view'
    atom.workspace.open(uri, split: 'left', searchAllPanes: false).done (terminalView) ->
