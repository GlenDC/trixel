// Global state for the manual native code
var nativeState = {
  mouse: {
    buttonsDown: [],
  },
  keyboard: {
    buttonsDown: [],
  },
}

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

// Global namespace for the manual native code
var nativeTrixel = {

// Method to attach all wanted mouse events for the workspace of the editor
attachMouseEventsToWorkspace: function(id, editorPorts) {
  var workspace = document.getElementById(id);

  if (workspace) {
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
  }
},

// Method to attach all wanted mouse events for the html document
attachMouseEventsToHtmlDocument: function(editorPorts) {
  // we sould always listen to onMouseUp
  document.onmouseup = function(event) {
    if(isArrayNonEmpty(nativeState.mouse.buttonsDown)) {
      remove(nativeState.mouse.buttonsDown, event.button);
      editorPorts.setMouseButtonsDown.send(nativeState.mouse.buttonsDown);
    }
  };

  // we sould always listen to onMouseUp
  document.onwheel = function(event) {
    event.preventDefault();
    event.stopPropagation();

    editorPorts.setMouseWheel.send(
      { x: event.deltaX
      , y: event.deltaY
      }
    );
  };

   // Disabling Context Menu (as it interferes with right click)
  document.oncontextmenu = function(event) {
    event.preventDefault();
    event.stopPropagation();
  };
},

// Method to attach all wanted keyboard events for the html document
attachKeyboardEventsToHtmlDocument: function(editorPorts) {
  document.onkeydown = function(event) {
    event.preventDefault();
    event.stopPropagation();
  };

  // we sould always listen to onMouseUp
  document.onkeyup = function(event) {
    event.preventDefault();
    event.stopPropagation();

    if(isArrayNonEmpty(nativeState.keyboard.buttonsDown)) {
      remove(nativeState.keyboard.buttonsDown, event.keyCode);
      editorPorts.setKeyboardButtonsDown.send(nativeState.keyboard.buttonsDown);
    }
  };
},

// Method to attach all wanted keyboard events for the workspace
attachKeyboardEventsToWorkspace: function(id, editorPorts) {
  var workspace = document.getElementById(id);

  if (workspace) {
    workspace.onkeydown = function(event) {
      event.preventDefault();
      event.stopPropagation();

      nativeState.keyboard.buttonsDown.push(event.keyCode);
      editorPorts.setKeyboardButtonsDown.send(nativeState.keyboard.buttonsDown);
    };
  }
},

updateModel: function(model) {
  this.attachMouseEventsToWorkspace(
    model.html.identifiers.workspace,
    this.trixelEditor.ports
    );


  this.attachKeyboardEventsToWorkspace(
    model.html.identifiers.workspace,
    this.trixelEditor.ports
    );
},

// Main function starting the entire editor
main: function() {
  var zeroVector = { x: 0, y: 0 };

  var trixelEditor = Elm.fullscreen(Elm.Trixel.Main, {
    setMouseButtonsDown: [],
    setKeyboardButtonsDown: [],
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
  trixelEditor.ports.updateEditor.subscribe(this.updateModel);

  // Attaching Mouse/Keyboard events to the Html Document
  this.attachMouseEventsToHtmlDocument(this.trixelEditor.ports);
  this.attachKeyboardEventsToHtmlDocument(this.trixelEditor.ports);
},

};