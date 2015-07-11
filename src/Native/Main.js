// Global state for the manual native code
var nativeState = {
  mouse: {
    buttonsDown: [],
  },
}

// Global namespace for the manual native code
var nativeTrixel = {

// Method to attach all wanted mouse events for the workspace of the editor
attachMouseEventsToWorkspace: function(id, editorPorts) {
  var workspace = document.getElementById(id);

  function remove(arr, item) {
    for(var i = arr.length; i--;) {
      if(arr[i] === item) {
        arr.splice(i, 1);
      }
    }
  }

  function isArrayNonEmpty(array) {
    return array.length > 0;
  }

  workspace.onmousemove = function(event) {
    var mouseX = event.pageX - workspace.offsetLeft;
    var mouseY = event.pageY - workspace.offsetTop;

    editorPorts.setMousePosition.send(
      { x: mouseX , y: mouseY }
    );
  };

  workspace.onmousedown = function(event) {
    nativeState.mouse.buttonsDown.push(event.button);
    editorPorts.setMouseButtonsDown.send(nativeState.mouse.buttonsDown);
  };

  // we sould always listen to onMouseUp
  document.onmouseup = function(event) {
    if(isArrayNonEmpty(nativeState.mouse.buttonsDown)) {
      remove(nativeState.mouse.buttonsDown, event.button);
      editorPorts.setMouseButtonsDown.send(nativeState.mouse.buttonsDown);
    }
  };

  // we sould always listen to onMouseUp
  document.wheel = function(event) {
    event.preventDefault();
    event.stopPropagation();
    editorPorts.setMouseButtonsDown.send(
      { x: event.deltaX
      , y: event.deltaY
      }
    );
  };
},

update: function(model) {
  this.attachMouseEventsToWorkspace(
    model.html.identifiers.workspace,
    this.trixelEditor.ports
    );
},

// Main function starting the entire editor
main: function() {
  var zeroVector = { x: 0, y: 0 };

  var trixelEditor = Elm.fullscreen(Elm.Trixel.Main, {
    setMouseButtonsDown: [],
    setMouseWheel: zeroVector,
    setWindowSizeManual: zeroVector,
    setMousePosition: zeroVector,
  });

  this.trixelEditor = trixelEditor
  
  // Set initial window dimensions
  trixelEditor.ports.setWindowSizeManual.send(
    { x: window.innerWidth
    , y: window.innerHeight
    }
  );

  // Gets called when updating the editor
  trixelEditor.ports.updateEditor.subscribe(this.update);

   // Disabling Context Menu (as it interferes with right click)
  document.addEventListener('contextmenu', function(event) {
    event.preventDefault();
  }, false);
},

};