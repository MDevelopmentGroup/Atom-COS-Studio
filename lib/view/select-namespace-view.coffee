{View} = require 'atom'
NameSpaceListView=require './namespace-list-view'
#TreeView=require './tree-view'
NameSpaceListView= new NameSpaceListView()
fs= require 'fsplus' # JSON fsplus
StudioAPI= require 'StudioAPI'
module.exports =
class SelectNameSpaceView extends View
  @Config:null
  @content: ->
      @div class: 'cache-modal-dialog overlay from-top', =>
        @div class: "panel", =>
          @h1 "NameSpace", class: "panel-heading"
        @div class: 'select-list', =>
          @ol class: 'list-group', outlet : 'listName', =>
        @div outlet: 'Select'
        @div class: 'block', =>
          @div class: 'btn-group', =>
            @button "OK", outlet:'OKButton', class:'btn'
            @button "Cancel", outlet:'CancelButton', class:'btn'
  initialize:  ->
    @Config=fs.readJSON(atom.packages.resolvePackagePath('cache-studio')+'/.config');
    @bind()
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
    StudioAPI.namespace (NameSpaces) =>
      @SetItems(NameSpaces)
  serialize: ->
  destroy: ->
    @detach()
  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
  # Buttons events
  SetItems: (@values)->
    NameSpaceListView.SetItems(@values)
    @Select.html(NameSpaceListView)
  bind: () ->
    @OKButton.on 'click', ->
      #console. log NameSpaceListView.getSelectedItem()
  success: (call) ->
    @OKButton.on 'click', ->
      fs.updateJSON(atom.packages.resolvePackagePath('cache-studio')+'/.config', {
        NameSpace: NameSpaceListView.getSelectedItem()
      });

      call(NameSpaceListView.getSelectedItem())
  cancel: (call) ->
    @CancelButton.on 'click', (e)->
      call(e)
