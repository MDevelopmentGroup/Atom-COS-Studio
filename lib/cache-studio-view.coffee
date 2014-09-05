{View, Editor, $} = require 'atom'
url = require 'url'
path=require 'path'
fs= require 'fsplus' # JSON fsplus
StudioAPI= require 'StudioAPI'
SelectNameSpaceView=require './view/select-namespace-view'
Tree=require './tree-view/tree'
TreeView=require './tree-view/tree-view'
TerminalView=require './view/terminal-view'
DocumaticView=require './view/documatic-view'
OutputView=require './view/output-view'
ConfigView=require './view/config-view'
ToolbarView=require './view/toolbar-view'
AddDialogView=require './add/add-dialog-view'
AddClassView=require './add/add-class-view'
module.exports =
class CacheStudioView extends View
  @outputView:null
  @configView:null
  @addDialogView:null
  @addClassView:null
  @Config:null
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
    atom.workspaceView.command 'window:save-all', => @saveall()
    atom.workspaceView.command 'cache-studio:compile-all', => @compileall()
    atom.workspaceView.command "cache-studio:config", => @config()
    atom.workspaceView.command "cache-studio:add-dialog", => @adddialog()
    atom.workspaceView.command "cache-studio:create-class-cache", => @CreateClassCache()
    atom.workspaceView.command "cache-studio:tree-view-refresh", => @TreeViewRefresh()

    #atom.workspaceView.command "application:open-folder", => @test()
    @treeView =new TreeView()

    atom.workspace.registerOpener (uriToOpen) ->
      #console.log path.extname(uriToOpen)
      if 'cache-studio://terminal-view'==uriToOpen
        return new TerminalView()
      {protocol, host, pathname} = url.parse(uriToOpen)
      if 'cache-studio-documatic:'==protocol
        return new DocumaticView(uriToOpen)

    @toolbarView=new ToolbarView()
    @Config=fs.readJSON(atom.packages.resolvePackagePath('cache-studio')+'/.config');


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



    StudioAPI.server=@Config.UrlToConnect
    selectNameSpaceView=new SelectNameSpaceView()
    selectNameSpaceView.success (namespace) =>
      @NameSpace=namespace
      StudioAPI.Obj.data.TempDir=@Config.Dir
      StudioAPI.Obj.data.NameSpace=namespace
      StudioAPI.getpath (fullpath) =>
        fs.updateJSON(atom.packages.resolvePackagePath('cache-studio')+'/.config', {
          CurrentDir: fullpath.Path
        });
        atom.project.setPath(fullpath.Path)
        @treeView.toggle()
      selectNameSpaceView.detach()
    selectNameSpaceView.cancel (call) =>
      selectNameSpaceView.detach()
  save: ->

    StudioAPI.server=@Config.UrlToConnect
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

  compile: ->

    StudioAPI.server=@Config.UrlToConnect
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
  adddialog: ->
    if @addDialogView instanceof AddDialogView
      @addDialogView.toggle()
    else
      @addDialogView=new AddDialogView()
      @addDialogView.toggle()
  CreateClassCache: ->
    #if @addClassView instanceof AddClassView
    addClassView=new AddClassView()
  TreeViewRefresh: ->
    StudioAPI.server=@Config.UrlToConnect
    StudioAPI.Obj.data.NameSpace=@Config.NameSpace
    StudioAPI.Obj.data.Path=@Config.CurrentDir
    StudioAPI.refresh (data) =>
  saveall: ->
    StudioAPI.server=@Config.UrlToConnect
    StudioAPI.Obj.data.NameSpace=@Config.NameSpace
    StudioAPI.Obj.data.CurrentDir=@Config.CurrentDir
    StudioAPI.saveall (data) =>
      if @outputView instanceof OutputView
        @outputView.save(data.status,data.status, "All Classes")
      else
        @outputView= new OutputView()
        @outputView.show()
        @outputView.save(data.status,data.status,"All Classes")
  compileall: ->
    StudioAPI.server=@Config.UrlToConnect
    StudioAPI.Obj.data.NameSpace=@Config.NameSpace
    StudioAPI.Obj.data.CurrentDir=@Config.CurrentDir
    StudioAPI.saveall (data) =>
      if @outputView instanceof OutputView
        @outputView.save(data.status,data.status, "All Classes")
      else
        @outputView= new OutputView()
        @outputView.show()
        @outputView.save(data.status,data.status,"All Classes")
      StudioAPI.server=@Config.UrlToConnect
      StudioAPI.Obj.data.NameSpace=@Config.NameSpace
      StudioAPI.Obj.data.CurrentDir=@Config.CurrentDir
      StudioAPI.compileall (status) =>
        if @outputView instanceof OutputView
          @outputView.compile(status)
        else
          @outputView= new OutputView()
          @outputView.show()
          @outputView.compile(status)
