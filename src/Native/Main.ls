# Global state of the native code
this.tr-state =
  mouse :
    buttonsDown : []
  keyboard :
    buttonsDown : []
  editor: null
  tags: null


this.tr-setWindowInformation = (width, height, fullscreen) ->
  tr-state.editor.ports.setWindowInformation.send {
    dimensions: {
      x: width
      y: height
    }
    , fullscreen: fullscreen
  }
  void


this.tr-onResize = ->
  isFullscreen =
    (window.fullScreen) || (window.innerWidth == screen.width && window.innerHeight == screen.height)

  tr-setWindowInformation window.innerWidth, window.innerHeight, isFullscreen

  void


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
      setWindowInformation : { dimensions: zeroVector, fullscreen: false }
      setMousePosition : zeroVector
    }
  )

  # Set initial window dimensions
  tr-setWindowInformation window.innerWidth, window.innerHeight, false

  # Gets called when updating the editor from Elm
  tr-state.editor.ports.updateEditor.subscribe tr-update

  void