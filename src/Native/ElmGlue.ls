# Inject a string message into an html node
this.tr-injectText = (id, text) ->
  if tr-state.tags != null
    element =
      document.getElementById id

    if element
      element.innerHTML = text

  void


this.tr-footerShowHelp = (message, shortcut) ->
  tr-injectText tr-state.tags.footerHelp, message
  tr-injectText tr-state.tags.footerShortcut, shortcut
  void


this.tr-footerHideHelp = ->
  tr-injectText tr-state.tags.footerHelp, ""
  tr-injectText tr-state.tags.footerShortcut, ""
  void


this.tr-goFullscreen = ->
  if document.body.requestFullScreen
    document.body.requestFullScreen!
  else if document.body.webkitRequestFullScreen
    document.body.webkitRequestFullScreen!
  else if document.body.mozRequestFullScreen
    document.body.mozRequestFullScreen!
  else if document.body.msRequestFullScreen
    document.body.msRequestFullScreen!

  void


this.tr-exitFullscreen = ->
  if document.exitFullscreen
    document.exitFullscreen!
  else if document.mozCancelFullScreen
    document.mozCancelFullScreen!
  else if document.webkitExitFullscreen
    document.webkitExitFullscreen!
  else if document.msExitFullscreen
    document.msExitFullscreen!

  void