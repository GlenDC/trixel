# Inject a string message into an html node
this.tr-injectText = (id, text) ->
  if tr-state.tags != null
    footerHelp =
      document.getElementById id

    if footerHelp
      footerHelp.innerHTML = text

  void


this.tr-footerShowHelp = (message) ->
  tr-injectText tr-state.tags.footerHelp, message
  void


this.tr-footerHideHelp = ->
  tr-injectText tr-state.tags.footerHelp, ""
  void


this.tr-footerShowShortcut = (message) ->
  tr-injectText tr-state.tags.footerShortcut, message
  void


this.tr-footerHideShortcut = ->
  tr-injectText tr-state.tags.footerShortcut, ""
  void