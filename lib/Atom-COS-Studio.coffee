AtomCOSStudioView = require './Atom-COS-Studio-view'
remote = require 'remote'
module.exports =
  config:
    UrlToConnect:
      type: 'string'
      default: 'http://localhost:57772/'
      description:''
      title: 'Url to connect'
    TempDir:
      type: 'string'
      default: '/home/user/temp/'
      description:'path to the directory where the files will be stored'
      title: 'Temp dir'
    SelectDefaultProject:
      type: 'boolean'
      default: true
      description:'open the default project created last'
      title: 'Open last project'

  AtomCOSStudioView: null
  activate: (state) ->
    @atomCOSStudioView = new AtomCOSStudioView(state.atomCOSStudioViewState)
  deactivate: ->
    @atomCOSStudioView.destroy()

  serialize: ->
    atomCOSStudioViewState: @atomCOSStudioView.serialize()
