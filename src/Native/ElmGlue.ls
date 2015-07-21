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


this.tr-footerShowShortcut = (message, shortcut) ->
  tr-injectText tr-state.tags.footerShortcut, message
  tr-injectText tr-state.tags.footerShortcut, shortcut
  void


this.tr-footerHideShortcut = ->
  tr-injectText tr-state.tags.footerShortcut, ""
  tr-injectText tr-state.tags.footerShortcut, ""
  void