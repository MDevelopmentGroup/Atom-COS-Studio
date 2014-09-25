{View} = require 'atom'
ListView=require './list-view'
listView = new ListView()
StudioAPI= require '../StudioAPI'
module.exports =
class AddDialogView extends View

  @content: ->
      @div class: 'cache-modal-dialog overlay from-top', =>
        @div class: "panel", =>
          @h1 "Create", class: "panel-heading"
        @div outlet:'List'
        @div class: 'block', =>
          @div class: 'btn-group', =>
            @button "OK", outlet:'OKButton', class:'btn'
            @button "Cancel", outlet:'CancelButton', class:'btn'

  initialize: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
    listView.setItems([{name:'Class Cache\'', icon:'fa-file-text-o',trigger:'create-class-cache'}])
    @List.html(listView)
    @bind(this)
  serialize: ->
  destroy: ->
    @detach()
  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
  # Buttons events
  bind: (e) ->
    @OKButton.on 'click', ->
      if listView instanceof ListView
        atom.workspaceView.trigger('Atom-COS-Studio:'+listView.getSelectedItem().trigger)
        #listView.detach()
       e.destroy()
    @CancelButton.on 'click', ->
      e.destroy()
