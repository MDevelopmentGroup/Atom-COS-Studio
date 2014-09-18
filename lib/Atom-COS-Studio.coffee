AtomCOSStudioView = require './Atom-COS-Studio-view'
remote = require 'remote'
StudioAPI= require 'StudioAPI'
module.exports =
  configDefaults:
    UrlToConnect:'http://localhost:57772/'
    TempDir:'/home/victor/temp/'
  AtomCOSStudioView: null
  activate: (state) ->
    @atomCOSStudioView = new AtomCOSStudioView(state.atomCOSStudioViewState)
  deactivate: ->
    @atomCOSStudioView.destroy()

  serialize: ->
    atomCOSStudioViewState: @atomCOSStudioView.serialize()
