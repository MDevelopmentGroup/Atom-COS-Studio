{View} = require 'atom'
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
        @div class: 'block', =>
          @input type:'text', class:'editor mini editor-colors native-key-bindings'
          @div class: 'btn-group', =>
            @button "OK", outlet:'OKButton', class:'btn'
            @button "Cancel", outlet:'CancelButton', class:'btn'
  initialize:  ->
    @studioAPI=new StudioAPI(atom.config.get('Atom-COS-Studio.UrlToConnect'))
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
    @studioAPI.namespace (NameSpaces) =>
      @SetItems(NameSpaces)
    @CancelButton.on 'click', =>  @detach()
  serialize: ->
  destroy: ->
    @detach()
  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
  SetItems: (@values)->
    NameSpaceListView.SetItems(@values)
    @Select.html(NameSpaceListView)
  success: (call) ->
    @OKButton.on 'click', ->
      call(NameSpaceListView.getSelectedItem())
