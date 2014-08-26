{SelectListView} = require 'atom'
module.exports =
class NameSpaceListView extends SelectListView

  initialize:(data)->
    super
    #@setItems(data)
    @focusFilterEditor()
  SetItems: (data)->
    @setItems(data)
  viewForItem: (item) ->
    "<li>#{item}</li>"
  confirmed: (item) ->
    #console.log("#{item} was selected")
