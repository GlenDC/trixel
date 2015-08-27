trInput =
  disableBehaviour: (event) ->
    event.preventDefault()
    event.stopPropagation()
    null

  dummyBehaviour: (event) ->
    null

  # attach all wanted mouse events for
  # the workspace of the editor
  attachMouseEventsToWorkspace: (id, editorPorts) ->
    if workspace = document.getElementById id
      workspace.onmousemove = (event) ->
        editorPorts.setMousePosition.send {
          x: event.pageX - workspace.offsetLeft
          y: event.pageY - workspace.offsetTop
        }
        null

      workspace.onmousedown = (event) ->
        trState.mouse.buttonsDown.push event.button
        editorPorts.setMouseButtonsDown.send trState.mouse.buttonsDown
        null

      workspace.onwheel = (event) ->
        editorPorts.setMouseWheel.send {
          x: event.deltaX
          y: event.deltaY
        }
        null

    null


  # attach all wanted mouse events for the html document
  attachMouseEventsToHtmlDocument: (editorPorts, limitInput) ->
    document.onmouseup = (event) ->
      trInput.disableBehaviour event if limitInput

      if trState.mouse.buttonsDown.length > 0
        buttons =
          trState.mouse.buttonsDown.filter (button) ->
            button isnt event.button

        editorPorts.setMouseButtonsDown.send buttons
        trState.mousee.buttonsDown = buttons

      null

    # disabling global mouse wheel (as it allows zooming)
    document.onwheel =
      if limitInput then trInput.disableBehaviour else trInput.dummyBehaviour

    # disabling Context Menu (as it interferes with right click)
    document.oncontextmenu = trInput.disableBehaviour

    null


  optionKeyIsDown: (keys, key) ->
    return true if key in keys

    for x in keys
      return true if x in trState.keyboard.buttonsDown

    false


  normalKeyDownBehaviour: (editorPorts, exceptionalKeys, optionKeys) ->
    (event) ->
      optionKeyIsDown = trInput.optionKeyIsDown optionKeys, event.keyCode
      if optionKeyIsDown or event.keyCode in exceptionalKeys
        trInput.disableBehaviour event if optionKeyIsDown
        trState.keyboard.buttonsDown.push event.keyCode
        editorPorts.setKeyboardButtonsDown.send trState.keyboard.buttonsDown
      null


  limitKeyDownBehaviour: (editorPorts, exceptionalKeys, optionKeys) ->
    (event) ->
      trInput.disableBehaviour event
      if trInput.optionKeyIsDown optionKeys, event.keyCode
        trState.keyboard.buttonsDown.push event.keyCode
        editorPorts.setKeyboardButtonsDown.send trState.keyboard.buttonsDown


  # attach all wanted keyboard events for the html document
  attachKeyboardEventsToHtmlDocument: (editorPorts, limitInput, exceptionalKeys, optionKeys) ->
    onKeyDown = if limitInput then trInput.limitKeyDownBehaviour else trInput.normalKeyDownBehaviour
    document.onkeydown = onKeyDown editorPorts, exceptionalKeys, optionKeys

    document.onkeyup = (event) ->
      if limitInput or trInput.optionKeyIsDown optionKeys, event.keyCode
        trInput.disableBehaviour event

      if trState.keyboard.buttonsDown.length > 0
        buttons =
          trState.keyboard.buttonsDown.filter (button) ->
            button isnt event.keyCode

        editorPorts.setKeyboardButtonsDown.send buttons
        trState.keyboard.buttonsDown = buttons

      null

    null

  # attach all wanted keyboard events for the workspace
  attachKeyboardEventsToWorkspace: (id, editorPorts) ->
    if workspace = document.getElementById id
      workspace.onkeydown = (event) ->
        trState.keyboard.buttonsDown.push event.keyCode
        editorPorts.setKeyboardButtonsDown.send trState.keyboard.buttonsDown
        null

    null