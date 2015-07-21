tr-setTitle = (model) ->
  document.title =
    model.title

  void


this.tr-set-warning = (model) ->
  window.onbeforeunload =
    if model.isDirty
      then -> model.messages.unsavedProgress
      else null
  void


this.tr-update = (model) ->
  tr-attachMouseEventsToWorkspace model.tags.workspace, tr-state.editor.ports

  tr-attachKeyboardEventsToWorkspace model.tags.workspace, tr-state.editor.ports

  # Attaching Mouse/Keyboard events to the Html Document
  tr-attachMouseEventsToHtmlDocument tr-state.editor.ports, model.limitInput
  tr-attachKeyboardEventsToHtmlDocument tr-state.editor.ports, model.limitInput, model.exceptionalKeys

  # Set Document Title
  tr-setTitle model

  # Store shared DOM Tags (id's)
  tr-state.tags = model.tags

  tr-set-warning model

  void