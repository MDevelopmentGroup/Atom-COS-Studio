path = require 'path'

{Model} = require 'theorist'
_ = require 'underscore-plus'

File = require './file'

module.exports =
class Directory extends Model
  @properties
    directory: null
    isRoot: false
    isExpanded: false
    status: null # Either null, 'added', 'ignored', or 'modified'
    entries: -> {}
    expandedEntries: -> {}

  @::accessor 'name', -> @directory.getBaseName() or @path
  @::accessor 'path', -> @directory.getPath()

  constructor: ->
    super
    repo = atom.project.getRepo()
    if repo?
      @subscribeToRepo(repo)
      @updateStatus(repo)

  # Called by theorist.
  destroyed: ->
    @unwatch()
    @unsubscribe()



  # Create a new model for the given atom.File or atom.Directory entry.
  createEntry: (entry, index) ->
    if entry.getEntriesSync?
      expandedEntries = @expandedEntries[entry.getBaseName()]
      isExpanded = expandedEntries?
      entry = new Directory({directory: entry, isExpanded, expandedEntries})
    else
      entry = new File(file: entry)
    entry.indexInParentDirectory = index
    entry


  reload: ->
    newEntries = []
    removedEntries = _.clone(@entries)
    index = 0

    for entry in @directory.getEntriesSync()
      name = entry.getBaseName()
      if @entries.hasOwnProperty(name)
        delete removedEntries[name]
        index++
      else if not @isPathIgnored(entry.path)
        newEntries.push([entry, index])
        index++

    for name, entry of removedEntries
      entry.destroy()
      delete @entries[name]
      delete @expandedEntries[name]
      @emit 'entry-removed', entry

    for [entry, index] in newEntries
      entry = @createEntry(entry, index)
      @entries[entry.name] = entry
      @emit 'entry-added', entry

  # Public: Collapse this directory and stop watching it.
  collapse: ->
    @isExpanded = false
    @expandedEntries = @serializeExpansionStates()
    @unwatch()

  # Public: Expand this directory, load its children, and start watching it for
  # changes.
  expand: ->
    @isExpanded = true
    @reload()
    @watch()

  serializeExpansionStates: ->
    expandedEntries = {}
    for name, entry of @entries when entry.isExpanded
      expandedEntries[name] = entry.serializeExpansionStates()
    expandedEntries
