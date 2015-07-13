tr-setTitle = (model) ->
  document.title =
    model.dom.title

  void


this.tr-update = (model) ->
  tr-attachMouseEventsToWorkspace model.dom.tags.workspace, tr-state.editor.ports

  tr-attachKeyboardEventsToWorkspace model.dom.tags.workspace, tr-state.editor.ports

  # Set Document Title
  tr-setTitle model

  void