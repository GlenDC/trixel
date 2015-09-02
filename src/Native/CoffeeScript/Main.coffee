trMain =
  setWindowInformation: (width, height, fullscreen) ->
    trState.editor.ports.setWindowInformation.send {
      dimensions: {
        x: width
        y: height
      }
      , fullscreen: fullscreen
    }
    null


  onResize: ->
    isFullscreen =
      window.fullScreen or
      ( window.innerWidth is screen.width \
        and window.innerHeight is screen.height
      )

    trMain.setWindowInformation window.innerWidth,
      window.innerHeight, isFullscreen

    null


  main: ->
    zeroVector =
      x: 0
      y: 0

    # Create Trixel Editor
    trState.editor = Elm.fullscreen(
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
    trMain.setWindowInformation window.innerWidth, window.innerHeight, false

    # Gets called when updating the editor from Elm
    trState.editor.ports.updateEditor.subscribe trUpdate.update

    null
