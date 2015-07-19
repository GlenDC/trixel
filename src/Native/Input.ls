# disable default behaviour
tr-disableBehaviour = (event) ->
  event.preventDefault!
  event.stopPropagation!
  void

tr-dummyBehaviour = (event) ->
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
this.tr-attachMouseEventsToHtmlDocument = (editorPorts, limitInput) ->
  document.onmouseup = (event) ->
    if limitInput
      tr-disableBehaviour event

    if tr-isArrayNonEmpty tr-state.mouse.buttonsDown
      tr-remove tr-state.mouse.buttonsDown, event.button
      editorPorts.setMouseButtonsDown.send tr-state.mouse.buttonsDown
    void

  # disabling global mouse wheel (as it allows zooming)
  document.onwheel =
    if limitInput then tr-disableBehaviour else tr-dummyBehaviour

  # disabling Context Menu (as it interferes with right click)
  document.oncontextmenu = tr-disableBehaviour

  void


# check for exceptional key
this.tr-isExceptionalKey = (key, keys) ->
  for x in keys
    if x == key
      return true
  false


# attach all wanted keyboard events for the html document
this.tr-attachKeyboardEventsToHtmlDocument = (editorPorts, limitInput, exceptionalKeys) ->
  document.onkeydown =
    if limitInput
      then tr-disableBehaviour
      else (event) ->
        if (tr-isExceptionalKey event.keyCode, exceptionalKeys)
          tr-state.keyboard.buttonsDown.push event.keyCode
          editorPorts.setKeyboardButtonsDown.send tr-state.keyboard.buttonsDown

        void

  document.onkeyup = (event) ->
    if limitInput
      tr-disableBehaviour event

    if tr-isArrayNonEmpty tr-state.keyboard.buttonsDown
      if limitInput || (tr-isExceptionalKey event.keyCode, exceptionalKeys)
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