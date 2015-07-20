# Global state of the native code
this.tr-state =
  mouse :
    buttonsDown : []
  keyboard :
    buttonsDown : []
  editor: null
  tags: null


this.tr-main = ->
  zeroVector =
    x : 0
    y : 0

  # Create Trixel Editor
  tr-state.editor := Elm.fullscreen(
    Elm.Trixel.Main
    {
      setMouseButtonsDown : []
      setKeyboardButtonsDown : []
      setMouseWheel : zeroVector
      setWindowSizeManual : zeroVector
      setMousePosition : zeroVector
    }
  )

  # Set initial window dimensions
  tr-state.editor.ports.setWindowSizeManual.send {
    x : window.innerWidth
    y : window.innerHeight
    }

  # Gets called when updating the editor from Elm
  tr-state.editor.ports.updateEditor.subscribe tr-update

  void