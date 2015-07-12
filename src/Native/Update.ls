tr-setTitle = (model) ->
  document.title =
    Elm.Trixel.Models.Work.computTitle model.work

  void


this.tr-update = (model) ->
  tr-attachMouseEventsToWorkspace model.native.identifiers.workspace tr-state.editor.ports

  tr-attachKeyboardEventsToWorkspace model.native.identifiers.workspace tr-state.editor.ports

  # Set Document Title
  tr-setTitle model

  void