{View, EditorView, PackageManager} = require 'atom'

fs= require 'fsplus'
module.exports =
class ConfigView extends View
  @Config:null
  @content: ->
      @div class: 'cache-modal-dialog overlay from-top', =>
        @div class: "panel", =>
          @h1 "Config", class: "panel-heading"
        @div class: 'block', =>
          @label 'Url to connect'
          @subview 'UrlToConnect', new EditorView(mini:true, placeholderText: 'Example: http://localhost:57772/mdg-dev/')
          @label 'Temp Dir'
          @subview 'TempDir', new EditorView(mini:true, placeholderText: 'Example: C:/temp/')
        @div class: 'block', =>
          @div class: 'btn-group', =>
            @button "OK", outlet:'OKButton', class:'btn'
            @button "Cancel", outlet:'CancelButton', class:'btn'
  initialize:  ->
    @UrlToConnect.getEditor().setText(atom.config.get('Atom-COS-Studio.UrlToConnect'))
    @TempDir.getEditor().setText(atom.config.get('Atom-COS-Studio.TempDir'))
    @OKButton.on 'click', => @set()
    @CancelButton.on 'click', => @detach()
  serialize: ->
  destroy: ->
    @detach()
  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
  set: ->
    atom.config.set('Atom-COS-Studio.UrlToConnect',@UrlToConnect.getEditor().getText())
    atom.config.set('Atom-COS-Studio.TempDir',@TempDir.getEditor().getText())
    @detach()
