{View, Editor, $} = require 'atom'
url = require 'url'
path=require 'path'
fs= require 'fsplus' # JSON fsplus
fsp= require 'fs-plus'
StudioAPI= require './StudioAPI'
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
StatusPanelView=require './status-panel/status-panel-view'
module.exports =
class AtomCOSStudioView extends View
  @studioAPI:null
  @outputView:null
  @configView:null
  @addDialogView:null
  @addClassView:null
  @Config:null
  @NameSpace:null
  @content: ->
    @div ''
  initialize: (serializeState) ->
    @studioAPI=new StudioAPI(atom.config.get('Atom-COS-Studio.UrlToConnect'))
    atom.config.observe 'Atom-COS-Studio.UrlToConnect', =>
      @studioAPI.setURL(atom.config.get('Atom-COS-Studio.UrlToConnect'))
    @handleEvents() # events
    @treeView =new TreeView()
    atom.workspace.registerOpener (uriToOpen) ->

      #console.log path.extname(uriToOpen)
      if 'Atom-COS-Studio://terminal-view'==uriToOpen
        return new TerminalView()
      {protocol, host, pathname} = url.parse(uriToOpen)

      if 'atom-cos-studio-documatic:'==protocol
        return new DocumaticView(uriToOpen)
    @toolbarView=new ToolbarView()
    @loadPlugins(@toolbarView)

  serialize: ->
  destroy: ->
    @detach()
  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
  loadPlugins:(state) ->
    LoadedPlugins={}
    PluginsDir=atom.packages.resolvePackagePath('Atom-COS-Studio')+"/lib/plugins/"
    Plugins=fsp.readdirSync(PluginsDir,{})
    for PluginName, index in Plugins
      if fs.existsSync PluginsDir+"/#{PluginName}/package.json"
        pluginPackage=fs.readJSON PluginsDir+"/#{PluginName}/package.json"
        if atom.config.get("Atom-COS-Studio.Enable#{pluginPackage.name}Plugin")==undefined
          atom.config.set("Atom-COS-Studio.Enable#{pluginPackage.name}Plugin",true)
        if pluginPackage.main!='' and atom.config.get("Atom-COS-Studio.Enable#{pluginPackage.name}Plugin")
          tempPlg=require "./plugins/#{PluginName}#{pluginPackage.main}"
          LoadedPlugins[PluginName]=new tempPlg(state,LoadedPlugins)
        if index==Plugins.length-1
          atom.workspaceView.trigger('Atom-COS-Studio:plugins-loaded-state')

  handleEvents: ->
    atom.workspaceView.command "Atom-COS-Studio:toggle", => @toggle()
    atom.workspaceView.command "Atom-COS-Studio:namespace", => @namespace()
    atom.workspaceView.command "Atom-COS-Studio:compile", => @compile()
    atom.workspaceView.command "Atom-COS-Studio:terminal", => @terminal()
    atom.workspaceView.command "Atom-COS-Studio:output", => @output()
    atom.workspaceView.command "output-view:clearoutput", => @clearoutput()
    atom.workspaceView.command "output-view:closeoutput", => @closeoutput()
    atom.workspaceView.command "Atom-COS-Studio:search", => @searchdoc()
    atom.workspaceView.command 'core:save', => @save()
    atom.workspaceView.command 'window:save-all', => @saveall()
    atom.workspaceView.command 'Atom-COS-Studio:compile-all', => @compileall()
    atom.workspaceView.command "Atom-COS-Studio:config", => @config()
    atom.workspaceView.command "Atom-COS-Studio:add-dialog", => @adddialog()
    atom.workspaceView.command "Atom-COS-Studio:create-class-cache", => @CreateClassCache()
    atom.workspaceView.command "Atom-COS-Studio:tree-view-refresh", => @TreeViewRefresh()
    atom.workspaceView.command "Atom-COS-Studio:test", => @Test()

  Test: ->
    statusPanelView=new StatusPanelView([{title:'OutPut', icon:'fa fa-sign-out'},
    {title:'Terminal', icon:'fa fa-terminal'},
    {title:'Search', icon:'fa fa-search'}
    ])
  Output: ->
    if @outputView instanceof OutputView
      return @outputView
    else
      @outputView= new OutputView()
      @outputView.show()
      return @outputView
  namespace: ->
    selectNameSpaceView=new SelectNameSpaceView()
    selectNameSpaceView.success (namespace) =>
      @NameSpace=namespace
      @studioAPI.getpath {NameSpace:namespace,TempDir:atom.config.get('Atom-COS-Studio.TempDir') }, (fullpath) =>
        atom.project.setPath(fullpath.Path)
        @treeView.toggle()
      selectNameSpaceView.detach()
  save: ->
    if atom.workspace.getActiveEditor()?
      editor=atom.workspace.getActiveEditor()
      if @getProperties().type=='cls'
        @studioAPI.updateclass {namespace:@NameSpace,nameClass:@getProperties().name,text:editor.getText(),TempDir:atom.config.get('Atom-COS-Studio.TempDir')}, (status) =>
          @Output().save(status, status, @getProperties().file)
  compile: ->
    @save()
    if @getProperties().type=='cls'
      @studioAPI.compileclass {namespace:@NameSpace,nameClass:@getProperties().name}, (status) =>
        @Output().compile(status)
        @treeView.updateRoot()

  getProperties:  ->
    name = ''

    folder=''
    editor=atom.workspace.getActiveEditor()
    path=editor.getPath()
    file= path.substr((path.indexOf('Classes')+8), path.length).replace('\\', '.').replace('\\', '.').replace('\\', '.').replace('\\', '.').replace('/', '.').replace('/', '.')

    temp=path.substr(0, (path.indexOf('Classes')-1))
    temp=temp.split('\\')
    namespace=temp[ (temp.length-1) ]
    type=path.split('.')[(path.split('.').length-1)]
    name=file.substr(0, (file.length-(type.length+1)))


    'folder':folder
    'name':name
    'path': path
    'file':file
    'type':type
  terminal: ->
    uri='Atom-COS-Studio://terminal-view'
    #uri='http://localhost:57772/csp/sys/webterminal/index.csp'
    ###atom.workspace.open(uri, split: 'left', searchAllPanes: true).done (terminalView) ->
    ###
    BrowserWindow = require('remote').require 'browser-window'
    mainWindow = new BrowserWindow({width: 800, height: 600, frame: true, 'skip-taskbar':true, 'auto-hide-menu-bar':true });
    mainWindow.loadUrl(atom.config.get('Atom-COS-Studio.UrlToConnect')+'csp/sys/webterminal/index.csp')
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
      uri="Atom-COS-Studio-documatic://"+
      "#{atom.config.get('Atom-COS-Studio.UrlToConnect')}csp/documatic/%25CSP.Documatic.cls?LIBRARY=#{@NameSpace}&CLASSNAME=#{text}"
      atom.workspace.open(uri, split: 'left', searchAllPanes: false).done (documaticView) ->
        #if documaticView instanceof DocumaticView
          #documaticView.show(@getProperties().namespace,editor.getSelection().getText())

  config: ->
    if @configView instanceof ConfigView
      @configView.toggle()
    else
      @configView=new ConfigView()
      @configView.toggle()
  adddialog: ->
    if @addDialogView instanceof AddDialogView
      @addDialogView.toggle()
    else
      @addDialogView=new AddDialogView()
      @addDialogView.toggle()
  CreateClassCache: ->
    addClassView=new AddClassView(@NameSpace)
  TreeViewRefresh: ->
    @studioAPI.refresh {NameSpace:@NameSpace,Path:atom.project.getPath()}, (data) =>
  saveall: ->
    @studioAPI.saveall {NameSpace:@NameSpace,CurrentDir:atom.project.getPath()},(data) =>
      @Output().save(data.status,data.status, "All Classes")
  compileall: ->
    @studioAPI.saveall {NameSpace:@NameSpace,CurrentDir:atom.project.getPath()},(data) =>
      @Output().save(data.status,data.status, "All Classes")
      @studioAPI.compileall {NameSpace:@NameSpace,CurrentDir:atom.project.getPath()}, (status) =>
        @Output().compile(status)
