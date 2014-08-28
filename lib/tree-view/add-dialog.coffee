path = require 'path'
fs = require 'fs-plus'
Dialog = require './dialog'
StudioAPI= require 'StudioAPI'
module.exports =
class AddDialog extends Dialog
  constructor: (initialPath, isCreatingFile) ->
    @isCreatingFile = isCreatingFile
    #console.log initialPath
    if fs.isFileSync(initialPath)
      directoryPath = path.dirname(initialPath)
    else
      directoryPath = initialPath
    relativeDirectoryPath = atom.project.relativize(directoryPath)
    relativeDirectoryPath += '/' if relativeDirectoryPath.length > 0

    super
      prompt: "Enter the path for the new " + if isCreatingFile then "file." else "folder."
      initialPath: relativeDirectoryPath
      select: false
      iconClass: if isCreatingFile then 'icon-file-add' else 'icon-file-directory-create'

  onConfirm: (relativePath) ->
    endsWithDirectorySeparator = /\/$/.test(relativePath)
    pathToCreate = atom.project.resolve(relativePath)
    return unless pathToCreate

    try
      if fs.existsSync(pathToCreate)
        @showError("'#{pathToCreate}' already exists.")
      else if @isCreatingFile
        if endsWithDirectorySeparator
          @showError("File names must not end with a '/' character.")
        else
          temp=pathToCreate.split('.')
          type=temp[(temp.length-1)]
          if type=='cls'
            str=pathToCreate.substr(0, (pathToCreate.indexOf('Classes')-1))
            str=str.split('\\')
            namespace=str[ (str.length-1) ]
            file= pathToCreate.substr((pathToCreate.indexOf('Classes')+8), pathToCreate.length).replace('\\', '.')
            classname=file.substr(0, (file.length-4)).replace('\\', '.').replace('\\', '.').replace('\\', '.').replace('\\', '.').replace('\\', '.')
            StudioAPI.NewClass.data.namespace=namespace
            StudioAPI.NewClass.data.nameClass=classname
            StudioAPI.createclass (status) =>
              #console.log status

          fs.writeFileSync(pathToCreate, '')
          atom.project.getRepo()?.getPathStatus(pathToCreate)
          @trigger 'file-created', [pathToCreate]
          @close()
      else
        fs.makeTreeSync(pathToCreate)
        @trigger 'directory-created', [pathToCreate]
        @cancel()
    catch error
      @showError("#{error.message}.")
