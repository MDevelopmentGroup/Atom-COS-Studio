{View,EditorView,$$$, $, Emitter} = require 'atom'
NameSpaceListView=require './namespace-list-view'
#TreeView=require './tree-view'
NameSpaceListView= new NameSpaceListView()
fs= require 'fsplus' # JSON fsplus
StudioAPI= require '../studio-api/studio-api'
module.exports =
class SelectNameSpaceView extends View
  @Config:null
  @studioAPI:null
  @content: ->
      @div class: 'cache-modal-dialog overlay from-top', =>
        @div class: "panel", =>
          @h1 "NameSpace", class: "panel-heading"
        @div class: 'select-list', =>
          @ol class: 'list-group', outlet : 'listName', =>
        @div outlet: 'Select'
        @select style:'width:100%;max-height:20%!important', size:'12', outlet:'nSelect', class:'editor mini editor-colors native-key-bindings', =>

        @div class: 'block', =>
          @label 'Default Project: '
          @select style:'width:100%', outlet:'pSelect', class:'editor mini editor-colors native-key-bindings', =>
          @div '', outlet:'ProjectNameDiv', =>
            @label 'Name of New Project: '
            @input type:'text',style:'width:100%', outlet:'ProjectName', class:'editor mini editor-colors native-key-bindings'
        @div class: 'block', =>
          @div class: 'btn-group', =>
            @button "OK", outlet:'OKButton', class:'btn'
            @button "Cancel", outlet:'CancelButton', class:'btn'
  initialize:  ->
    @studioAPI=new StudioAPI(atom.config.get('Atom-COS-Studio.UrlToConnect'))


    @nSelect.on 'click', =>
      @getProjects()

    @pSelect.on 'click', =>
      @setProjectNameDiv()


    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)

    @studioAPI.namespace (NameSpaces) =>
      for item,index in NameSpaces
        @setnSelectItem(item, index)
      @getProjects()


    @CancelButton.on 'click', =>  @detach()

  serialize: ->
  getProjects: ->
    @pSelect.html("")
    @studioAPI.Project @getNamespace(), (projects) =>
      project_add=''
      project_add= projects.Count+1 if projects.Count?
      @ProjectName[0].value="Project_#{project_add}"
      @setpSelectItem({Name:1, DisplayName:'New Project',LastModified:'',selected:true})
      for item, index in projects.children
        @setpSelectItem(item,index)
      @setProjectNameDiv()

  setpSelectItem: (item,index) ->
    set=''
    if atom.config.get('Atom-COS-Studio.SelectDefaultProject')==true
      set='selected' if index==0
    else
      set='selected' if item.selected?
    @pSelect.append("<option value=#{item.Name} #{set}>#{item.DisplayName}</<option>")
  setProjectNameDiv: ->
    if @getProject()!="1"
      @ProjectNameDiv.hide()
    else
      @ProjectNameDiv.show()
  setnSelectItem: (item,index) ->
    set=""
    set='selected' if index==0
    @nSelect.append("<option value=#{item} #{set}>#{item}</<option>")
  destroy: ->
    @detach()
  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
  getNamespace: ->
    @nSelect.find(":selected")[0].value
  getProject: ->
    @pSelect.find(":selected")[0]?.value
  success: (call) ->
    @OKButton.on 'click', =>
      call(@getNamespace(),@getProject())
