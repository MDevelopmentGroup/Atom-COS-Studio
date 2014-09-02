{View, Editor, $} = require 'atom'
url = require 'url'
fs= require 'fsplus' # JSON fsplus
StudioAPI= require 'StudioAPI'
SelectNameSpaceView=require './view/select-namespace-view'
Tree=require './tree-view/tree'
TreeView=require './tree-view/tree-view'
TerminalView=require './view/terminal-view'
DocumaticView=require './view/documatic-view'
OutputView=require './view/output-view'
#BrowserWindow = require 'browser-window'
ConfigView=require './view/config-view'
ToolbarView=require './view/toolbar-view'
module.exports =
class CacheStudioView extends View
  @outputView:null
  @configView:null
  @content: ->
    @div class: 'cache-studio overlay from-top', =>
      @div "The CacheStudio package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "cache-studio:toggle", => @toggle()
    atom.workspaceView.command "cache-studio:namespace", => @namespace()
    atom.workspaceView.command "cache-studio:compile", => @compile()
    atom.workspaceView.command "cache-studio:terminal", => @terminal()
    atom.workspaceView.command "cache-studio:output", => @output()
    atom.workspaceView.command "output-view:clearoutput", => @clearoutput()
    atom.workspaceView.command "output-view:closeoutput", => @closeoutput()
    atom.workspaceView.command "cache-studio:search", => @searchdoc()
    atom.workspaceView.command 'core:save', => @save()
    atom.workspaceView.command "cache-studio:config", => @config()
    @treeView =new TreeView()

    atom.workspace.registerOpener (uriToOpen) ->
      if 'cache-studio://terminal-view'==uriToOpen
        return new TerminalView()
      {protocol, host, pathname} = url.parse(uriToOpen)
      if 'cache-studio-documatic:'==protocol
        return new DocumaticView(uriToOpen)

    @toolbarView=new ToolbarView()

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


    configs = fs.readJSON(atom.packages.resolvePackagePath('cache-studio')+'/lib/configs.json');
    StudioAPI.server=configs.UrlToConnect
    selectNameSpaceView=new SelectNameSpaceView()
    selectNameSpaceView.success (namespace) =>
      @NameSpace=namespace
      StudioAPI.Obj.data.TempDir=configs.TempDir
      StudioAPI.Obj.data.NameSpace=namespace
      StudioAPI.getpath (fullpath) =>
        atom.project.setPath(fullpath.Path)
        @treeView.toggle()
      selectNameSpaceView.detach()
    selectNameSpaceView.cancel (call) =>
      selectNameSpaceView.detach()
  save: ->
    configs = fs.readJSON(atom.packages.resolvePackagePath('cache-studio')+'/lib/configs.json');
    StudioAPI.server=configs.UrlToConnect
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
    configs = fs.readJSON(atom.packages.resolvePackagePath('cache-studio')+'/lib/configs.json');
    StudioAPI.server=configs.UrlToConnect
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
    file= path.substr((path.indexOf('Classes')+8), path.length).replace('\\', '.').replace('\\', '.').replace('\\', '.')

    temp=path.substr(0, (path.indexOf('Classes')-1))
    temp=temp.split('\\')
    namespace=temp[ (temp.length-1) ]
    type=path.split('.')[(path.split('.').length-1)]
    name=file.substr(0, (file.length-(type.length+1)))

    'namespace':namespace
    'folder':folder
    'name':name
    'path': path
    'file':file
    'type':type
  terminal: ->
    uri='cache-studio://terminal-view'
    #uri='http://localhost:57772/csp/sys/webterminal/index.csp'
    ###atom.workspace.open(uri, split: 'left', searchAllPanes: true).done (terminalView) ->
    ###
    BrowserWindow = require('remote').require 'browser-window'
    mainWindow = new BrowserWindow({width: 800, height: 600, frame: true, 'skip-taskbar':true, 'auto-hide-menu-bar':true });
    mainWindow.loadUrl('http://localhost:57772/csp/sys/webterminal/index.csp')
    mainWindow.show()
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
  searchdoc: ->
    editor=null
    editor=atom.workspace.getActiveEditor()
    if editor!=null
      text= editor.getSelection().getText()
      ns= @getProperties().namespace
      uri="cache-studio-documatic://"+
      "http://localhost:57772/csp/documatic/%25CSP.Documatic.cls?LIBRARY=#{ns}&CLASSNAME=#{text}"
      atom.workspace.open(uri, split: 'left', searchAllPanes: false).done (documaticView) ->
        #if documaticView instanceof DocumaticView
          #documaticView.show(@getProperties().namespace,editor.getSelection().getText())

  config: ->
    if @configView instanceof ConfigView
      @configView.toggle()
      @configView.success (call) =>
        @configView.detach()
    else
      @configView=new ConfigView()
      @configView.toggle()
      @configView.success (call) =>
        @configView.detach()
