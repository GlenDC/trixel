Elm.Native.EditorKeyboard = {};
Elm.Native.EditorKeyboard.make = function(localRuntime) {

  localRuntime.Native = localRuntime.Native || {};
  localRuntime.Native.EditorKeyboard = localRuntime.Native.EditorKeyboard || {};
  if (localRuntime.Native.EditorKeyboard.values)
  {
    return localRuntime.Native.EditorKeyboard.values;
  }

  var NS = Elm.Native.Signal.make(localRuntime);


  function keyEvent(event)
  {
    event.preventDefault();
    event.stopPropagation();

    return {
      _: {},
      alt: event.altKey,
      meta: event.metaKey,
      keyCode: event.keyCode
    };
  }


  function keyStream(node, eventName, handler)
  {
    var stream = NS.input(eventName, '\0');

    localRuntime.addListener([stream.id], node, eventName, function(e) {
      localRuntime.notify(stream.id, handler(e));
    });

    return stream;
  }

  var downs = keyStream(document, 'keydown', keyEvent);
  var ups = keyStream(document, 'keyup', keyEvent);
  var presses = keyStream(document, 'keypress', keyEvent);
  var blurs = keyStream(window, 'blur', function() { return null; });


  return localRuntime.Native.EditorKeyboard.values = {
    downs: downs,
    ups: ups,
    blurs: blurs,
    presses: presses
  };

};