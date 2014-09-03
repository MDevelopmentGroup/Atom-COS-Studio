{$$, SelectListView} = require 'atom'
module.exports =
class ListView extends SelectListView
  initialize: () ->
    super
    #@addClass('overlay from-top')
    #@setItems(@listOfItems)
  attach: ->
    atom.workspaceView.append(this)
    @focusFilterEditor()
  viewForItem: (item) ->
    $$ ->
      @li =>
        @div class: 'block', =>
          @span class: "inline-block fa #{item.icon} fa-3x"
          @div class:'inline-block', "#{item.name}"
  confirmed: (item) ->
    #console.log(item)
