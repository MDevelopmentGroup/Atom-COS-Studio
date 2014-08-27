{View} = require 'atom'
StudioAPI= require 'StudioAPI'
SelectNameSpaceView=require './view/select-namespace-view'
Tree=require './tree-view/tree'
TreeView=require './tree-view/tree-view'
TerminalView=require './view/terminal-view'
OutputView=require './view/output-view'
#File=require './tree-view/file'
#FileView=require './tree-view/file-view'
module.exports =
class CacheStudioView extends View
  @outputView:null
  @content: ->
    @div class: 'cache-studio overlay from-top', =>
      @div "The CacheStudio package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "cache-studio:toggle", => @toggle()
    atom.workspaceView.command "cache-studio:namespace", => @namespace()
    atom.workspaceView.command "cache-studio:compile", => @compile()
    atom.workspaceView.command "cache-studio:termilal", => @termilal()
    atom.workspaceView.command "cache-studio:output", => @output()
    atom.workspaceView.command "output-view:clearoutput", => @clearoutput()
    atom.workspaceView.command "output-view:closeoutput", => @closeoutput()
    #atom.workspaceView.command "tree-view:termilal", => @termilal()
    atom.workspaceView.command 'core:save', => @save()

    @treeView =new TreeView()
    Tree.activate({})
    atom.workspace.registerOpener (uriToOpen) ->
      if 'cache-studio://terminal-view'==uriToOpen
        return new TerminalView()
      #if 'cache-studio://output-view'==uriToOpen
      #  return new OutputView({})

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
    selectNameSpaceView=new SelectNameSpaceView()
    selectNameSpaceView.success (namespace) =>
      @NameSpace=namespace
      StudioAPI.Obj.data.NameSpace=namespace
      StudioAPI.getpath (fullpath) =>
        atom.project.setPath(fullpath.Path)
        @treeView.toggle()
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
        if @outputView instanceof OutputView
          @outputView.save(status,status,@getProperties().file)
        else
          @outputView= new OutputView()
          @outputView.show()
          @outputView.save(status,status)

  saveall: ->
  compile: ->
    @save()
    if @getProperties().type=='cls'
      StudioAPI.CompileClass.data.namespace=@getProperties().namespace
      StudioAPI.CompileClass.data.nameClass=@getProperties().name
      StudioAPI.compileclass (status) =>
        if @outputView instanceof OutputView
          @outputView.compile(status)
        else
          @outputView= new OutputView()
          @outputView.show()
          @outputView.compile(status)
        @treeView.updateRoot()
  compileall: ->
  getProperties:  ->
    name = ''
    namespace=''
    folder=''
    editor=atom.workspace.getActiveEditor()
    path=editor.getPath()
    file= path.substr((path.indexOf('Classes')+8), path.length).replace('\\', '.')
    temp=path.substr(0, (path.indexOf('Classes')-1))
    temp=temp.split('\\')
    namespace=temp[ (temp.length-1) ]
    type=file.substr((file.length-3), file.length)
    name=file.substr(0, (file.length-4))

    'namespace':namespace
    'folder':folder
    'name':name
    'path': path
    'file':file
    'type':type
  termilal: ->
    uri='cache-studio://terminal-view'
    atom.workspace.open(uri, split: 'left', searchAllPanes: false).done (terminalView) ->
  output: ->
    if @outputView instanceof OutputView
      @outputView.detach()
      @outputView=null
    else
      @outputView= new OutputView()
      @outputView.show()
  clearoutput: ->
    if @outputView instanceof OutputView
      @outputView.clear()
  closeoutput: ->
    if @outputView instanceof OutputView
      @outputView.detach()
      @outputView=null
