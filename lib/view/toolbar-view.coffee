{View, $} = require 'atom'

module.exports =
class ToolbarView extends View
  @content: ->
    @div class:'panel cache-panel', =>
      @div class:'panel-heading cache-panel-heading', =>
        @div class: 'block', =>
          @button  outlet:'Config', class:'inline-block btn', =>
            @li class:'fa fa-cogs fa-lg'
          @button  outlet:'NameSpace', class:'inline-block btn', =>
            @li class:'fa fa-folder-o fa-lg'
          @button  outlet:'Terminal', class:'inline-block btn', =>
            @li class:'fa fa-tumblr fa-lg'
          @button  outlet:'OutPutView', class:'inline-block btn', =>
            @li class:'fa fa-bars fa-lg'
          @button  outlet:'Save', class:'inline-block btn', =>
            @li class:'fa fa-floppy-o fa-lg'
          @button outlet:'Compile', class:'inline-block btn', =>
            @li class:'fa fa-play fa-lg'


  initialize: ->
    $('body').find('.vertical').prepend(this)
    @bind()
    @tooltip()
  serialize: ->

  close: ->
    if @hasParent()
      @detach()
  # Tooltip events
  tooltip: ->
    @Save.setTooltip('Save', {})
    @Compile.setTooltip('Compile', {})
    @Config.setTooltip('Config', {})
    @NameSpace.setTooltip('Select NameSpace', {})
    @Terminal.setTooltip('Terminal', {})
    @OutPutView.setTooltip('OutPut', {})
  # Button events
  bind: ->
    @Save.on 'click', ->
      atom.workspaceView.trigger('core:save')
    @Compile.on 'click', ->
      atom.workspaceView.trigger('cache-studio:compile')
    @Config.on 'click', ->
      atom.workspaceView.trigger('cache-studio:config')
    @NameSpace.on 'click', ->
      atom.workspaceView.trigger('cache-studio:namespace')
    @Terminal.on 'click', ->
      atom.workspaceView.trigger('cache-studio:terminal')
    @OutPutView.on 'click', ->
      atom.workspaceView.trigger('cache-studio:output')
