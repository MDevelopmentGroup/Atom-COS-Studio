{View, $} = require 'atom'

module.exports =
class ToolbarView extends View
  @content: ->
    @div class:'panel cache-panel', =>
      @div class:'panel-heading cache-panel-heading', =>
        @div class: 'block', outlet:'ButtonList', =>
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
          @button outlet:'AddDialog', class:'inline-block btn', =>
            @li class:'fa fa-file-o fa-lg'


  initialize: ->
    $('body').find('.vertical').prepend(this)
    @bind()
    @tooltip()
  serialize: ->
  add: (el) ->
    @ButtonList.append(el+'Button')
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
    @AddDialog.setTooltip('Create', {})
  # Button events
  bind: ->
    @Save.on 'click', ->
      atom.workspaceView.trigger('core:save')
    @Compile.on 'click', ->
      atom.workspaceView.trigger('Atom-COS-Studio:compile')
    @Config.on 'click', ->
      atom.workspaceView.trigger('Atom-COS-Studio:config')
    @NameSpace.on 'click', ->
      atom.workspaceView.trigger('Atom-COS-Studio:namespace')
    @Terminal.on 'click', ->
      atom.workspaceView.trigger('Atom-COS-Studio:terminal')
    @OutPutView.on 'click', ->
      atom.workspaceView.trigger('Atom-COS-Studio:output')
    @AddDialog.on 'click', ->
      atom.workspaceView.trigger('Atom-COS-Studio:add-dialog')
