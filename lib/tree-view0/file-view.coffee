{View, EditorView, Workspace} = require 'atom'

module.exports =
class FileView extends View
  @content: ->
    @li class: 'file entry list-item', =>
      @span class: 'name icon', outlet: 'fileName'

  initialize: (@file) ->
    #atom.workspaceView.command 'core:save', => @save()
    @fileName.text(@file.name)

    relativeFilePath = atom.project.relativize(@file.path)
    @fileName.attr('data-name', @file.name)
    @fileName.attr('data-path', relativeFilePath)

    if @file.symlink
      @fileName.addClass('icon-file-symlink-file')
    else
      switch @file.type
        when 'binary'     then @fileName.addClass('icon-file-binary')
        when 'compressed' then @fileName.addClass('icon-file-zip')
        when 'image'      then @fileName.addClass('icon-file-media')
        when 'pdf'        then @fileName.addClass('icon-file-pdf')
        when 'readme'     then @fileName.addClass('icon-book')
        when 'text'       then @fileName.addClass('icon-file-text')

    @subscribe @file.$status.onValue (status) =>
      @removeClass('status-ignored status-modified status-added')
      @addClass("status-#{status}") if status?

  getPath: ->
    @file.path

  beforeRemove: ->
    @file.destroy()
  write: (text) ->
    console.log "ТУТ " + text
  save:->
    console.log atom.workspace.getActiveEditor()
    console.log @file
    console.log 'nnnn111111'
