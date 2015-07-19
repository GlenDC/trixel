tr-setTitle = (model) ->
  document.title =
    model.title

  void


this.tr-update = (model) ->
  tr-attachMouseEventsToWorkspace model.tags.workspace, tr-state.editor.ports

  tr-attachKeyboardEventsToWorkspace model.tags.workspace, tr-state.editor.ports

  # Attaching Mouse/Keyboard events to the Html Document
  tr-attachMouseEventsToHtmlDocument tr-state.editor.ports, model.limitInput
  tr-attachKeyboardEventsToHtmlDocument tr-state.editor.ports, model.limitInput, model.exceptionalKeys

  # Set Document Title
  tr-setTitle model

  void