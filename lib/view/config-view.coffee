{View, EditorView, PackageManager} = require 'atom'

StudioAPI= require 'StudioAPI'
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

    @Config=fs.readJSON(atom.packages.resolvePackagePath('cache-studio')+'/.config');

    if @Config.UrlToConnect
      @UrlToConnect.getEditor().setText(@Config.UrlToConnect)
    if @Config.TempDir
      @TempDir.getEditor().setText(@Config.TempDir)
    p =
      'UrlToConnect':@UrlToConnect
      'TempDir':@TempDir
    @bind(p)
  serialize: ->
  destroy: ->
    @detach()
  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
  # Buttons events
  bind: (p) ->
    @OKButton.on 'click', ->
      fs.updateJSON(atom.packages.resolvePackagePath('cache-studio')+'/.config', {
        UrlToConnect:p.UrlToConnect.getEditor().getText(),
        TempDir:p.TempDir.getEditor().getText()
      });
  success: (call) ->
    @OKButton.on 'click', (e)->
      call(e)
    @CancelButton.on 'click', (e)->
      call(e)
