CacheStudioView = require './cache-studio-view'

module.exports =
  cacheStudioView: null

  activate: (state) ->
    @cacheStudioView = new CacheStudioView(state.cacheStudioViewState)

  deactivate: ->
    @cacheStudioView.destroy()

  serialize: ->
    cacheStudioViewState: @cacheStudioView.serialize()
