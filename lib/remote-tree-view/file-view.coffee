{View, EditorView, Workspace} = require 'atom'
StudioAPI= require '../studio-api/studio-api'
fs= require 'fsplus' # JSON fsplus
fsp= require 'fs-plus'
http = require 'http'
module.exports =
class FileView extends View
  namespace:''
  name:''
  defProject:''
  relativePath:''
  path:''
  TempDir:''
  Target:''
  @content: ->
    @li class: 'file entry list-item', =>
      @span class: 'name icon', outlet: 'fileName'

  initialize: (@file={},defProject,namespace,WebAPP) ->
    @studioAPI=new StudioAPI(atom.config.get('Atom-COS-Studio.UrlToConnect'))
    @TempDir=atom.config.get('Atom-COS-Studio.TempDir')
    @fileName.text(@file.DisplayName)
    @fileName.addClass('icon-file-text')
    @defProject=defProject
    @namespace=namespace
    @name=@file.Name
    @Target=@file.Target
    @relativePath=@file.relativePath

    @on 'click', => @check()
  getPath: ->
    @file.path

  #beforeRemove: ->
    #@file.destroy()
  fsExist: ->
    fs.existsSync "#{@TempDir} #{@namespace}/#{@defProject}/#{@relativePath}"
  open: ->
    atom.workspaceView.open(@path, split: 'left', searchAllPanes: true).done (editorView) ->
      #if editorView instanceof EditorView
      editorView.Parampapam={Test:'ttt'}
      console.log editorView

  check: ->
    @studioAPI.ItemExist 'project', @namespace, @defProject, @name, (result) =>
      if result.Status
        if @fsExist()
          @open()
        else
          @pDownload (result) =>
            @open()
      else
        @sDownload (result) =>
          @open()

  pDownload : (result) ->
    @path="#{@TempDir} #{@namespace}/#{@defProject}/#{@relativePath}"
    @write (st) =>
      result('')

  sDownload : (result) ->
    @path="#{@TempDir}#{@namespace}/#{@relativePath}"
    @write (st) =>
      result('')
  write:(st) ->

    @studioAPI.source @Target, @namespace, @name, (response) =>
      fsp.writeFile @path, '' , (status) =>
        file = fsp.createWriteStream(@path)
        response.pipe(file)
        st()

      #file = fs.createWriteStream(@path)
      #response.pipe(file)
      #st('')
    #  console.log @path
      #fsp.writeFile @path, result.Source , (status) =>

  ###  request = http.get "http://localhost:57772/mdg-dev/source/csp?NameSpace=SAMPLES&Name="+@name , (response) =>
      console.log response
      file = fs.createWriteStream(@path)
      response.pipe(file)
      st('') ###