trNative =
  injectText: (id, text) ->
    if trState.tags and element = document.getElementById id
      element.innerHTML = text
    null

  footerShowHelp: (message, shortcut) ->
    if trState and trState.tags
      trNative.injectText trState.tags.footerHelp, message
      trNative.injectText trState.tags.footerShortcut, shortcut
    null

  footerHideHelp: ->
    if trState and trState.tags
      trNative.injectText trState.tags.footerHelp, ""
      trNative.injectText trState.tags.footerShortcut, ""
    null

  goFullscreen: ->
    el = document.body
    if el.requestFullscreen
      el.requestFullscreen()
    else if el.webkitRequestFullScreen
      el.webkitRequestFullScreen()
    else if el.mozRequestFullScreen
      el.mozRequestFullScreen()
    else if el.msRequestFullScreen
      el.msRequestFullScreen()
    null

  exitFullscreen: ->
    el = document
    if el.exitFullscreen
      el.exitFullscreen()
    else if el.webkitExitFullscreen
      el.webkitExitFullscreen()
    else if el.mozCancelFullScreen
      el.mozCancelFullScreen()
    else if el.msExitFullscreen
      el.msExitFullscreen()
    null

  showFileChooser: (attributes = {}) ->
    new Promise (resolve, reject) ->
      fileChooser = document.createElement "input"
      clickEvent  = document.createEvent "MouseEvents"

      fileChooser.setAttribute "type", "file"
  
      for name, value of attributes
        fileChooser.setAttribute name, value

      fileChooser.addEventListener "change", (event) ->
        files = fileChooser.files

        # Self-destruct now that we're no longer needed.
        document.body.removeChild fileChooser

        resolve files

      document.body.appendChild fileChooser

      clickEvent.initMouseEvent "click", true, true, window, 1, 0, 0, 0, 0, false, false, false, false, 0, null

      fileChooser.dispatchEvent clickEvent

  readTextFromFile: (file) ->
    new Promise (resolve, reject) ->
      reader = new FileReader

      reader.onerror = reject
      reader.onabort = reject
      reader.onload  = resolve

      reader.readAsText file