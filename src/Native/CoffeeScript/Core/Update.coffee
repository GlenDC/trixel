trUpdate =
  setTitle: (model) ->
    document.title = model.title
    null


  setWarning: (model) ->
    window.onbeforeunload =
      if model.isDirty
        -> model.messages.unsavedProgress
      else
        null
    null


  update: (model) ->
    trInput.attachMouseEventsToWorkspace model.tags.workspace, trState.editor.ports
    trInput.attachKeyboardEventsToWorkspace model.tags.workspace, trState.editor.ports

    # Attaching Mouse/Keyboard events to the Html Document
    trInput.attachMouseEventsToHtmlDocument trState.editor.ports, model.limitInput
    trInput.attachKeyboardEventsToHtmlDocument trState.editor.ports, model.limitInput, model.exceptionalKeys, model.optionKeys

    # Set Document Title
    trUpdate.setTitle model

    # Store shared DOM Tags (id's)
    trState.tags = model.tags

    trUpdate.setWarning model

    null