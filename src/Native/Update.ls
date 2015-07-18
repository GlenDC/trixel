tr-setTitle = (model) ->
  document.title =
    model.title

  void


this.tr-update = (model) ->
  tr-attachMouseEventsToWorkspace model.tags.workspace, tr-state.editor.ports

  tr-attachKeyboardEventsToWorkspace model.tags.workspace, tr-state.editor.ports

  # Set Document Title
  tr-setTitle model

  void