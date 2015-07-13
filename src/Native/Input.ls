# disable default behaviour
tr-disableBehaviour = (event) ->
  event.preventDefault!
  event.stopPropagation!
  void


# attach all wanted mouse events for the workspace of the editor
this.tr-attachMouseEventsToWorkspace = (id, editorPorts) ->
  workspace = document.getElementById id

  if workspace
    workspace.onmousemove = (event) ->
      editorPorts.setMousePosition.send {
        x : event.pageX - workspace.offsetLeft
        y : event.pageY - workspace.offsetTop
        }
      void

    workspace.onmousedown = (event) ->
      tr-state.mouse.buttonsDown.push event.button
      editorPorts.setMouseButtonsDown.send tr-state.mouse.buttonsDown
      void

    workspace.onwheel = (event) ->
      editorPorts.setMouseWheel.send {
        x : event.deltaX
        y : event.deltaY
        }
      void

  void


# attach all wanted mouse events for the html document
this.tr-attachMouseEventsToHtmlDocument = (editorPorts) ->
  document.onmouseup = (event) ->
    tr-disableBehaviour event
    if tr-isArrayNonEmpty tr-state.mouse.buttonsDown
      tr-remove tr-state.mouse.buttonsDown, event.button
      editorPorts.setMouseButtonsDown.send tr-state.mouse.buttonsDown
    void

  # disabling global mouse wheel (as it allows zooming)
  document.onwheel = tr-disableBehaviour

  # disabling Context Menu (as it interferes with right click)
  document.oncontextmenu = tr-disableBehaviour

  void

# attach all wanted keyboard events for the html document
this.tr-attachKeyboardEventsToHtmlDocument = (editorPorts) ->
  document.onkeydown = tr-disableBehaviour

  document.onkeyup = (event) ->
    tr-disableBehaviour event
    if tr-isArrayNonEmpty tr-state.keyboard.buttonsDown
      tr-remove tr-state.keyboard.buttonsDown, event.keyCode
      editorPorts.setKeyboardButtonsDown.send tr-state.keyboard.buttonsDown

    void

  void


# attach all wanted keyboard events for the workspace
this.tr-attachKeyboardEventsToWorkspace = (id, editorPorts) ->
  workspace = document.getElementById id

  if workspace
    workspace.onkeydown = (event) ->
      tr-state.keyboard.buttonsDown.push event.keyCode
      editorPorts.setKeyboardButtonsDown.send tr-state.keyboard.buttonsDown
      void

  void