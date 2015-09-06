module Trixel.Types.Layout.UserActions where

import Trixel.Types.Input as TrInput
import Trixel.Types.State as TrState
import Trixel.Types.Keyboard as TrKeyboard

import Trixel.Types.Layout as TrLayout

import Trixel.Models.Work.Model as TrWorkModel

import Trixel.Models.Work.Actions as TrWorkActions
import Trixel.Models.Work.Update as TrUpdateWork


{-| Nice constant interface for UserAction.
    This way the information needed for such an action
    can be shared accross the codebase for several layout elements
    and react to the shortcut as well.
-}

type alias UserAction =
  { action : TrWorkActions.Action
  , modelAction : TrWorkModel.Model -> TrWorkModel.Model
  , shortcut : TrInput.Shortcut
  , label : String
  , longLabel : String
  , description : String
  }


type alias UserActions = List UserAction


{-| Help functions to quickly map a list of shortcut-actions
-}

applyShortcut : UserAction -> TrWorkModel.Model -> TrWorkModel.Model
applyShortcut userAction model =
  if TrInput.shortcutPressed
        userAction.shortcut
        model.input.keyboard.down
        model.input.keyboard.pressed
  then userAction.modelAction model
  else model


{-| Help functions to use a userAction to render layout elements.
-}

view : Bool -> UserAction -> (TrWorkActions.Action -> TrInput.Shortcut -> String -> Bool -> TrLayout.Generator) -> TrLayout.Generator
view isToggled userAction function =
  function
    userAction.action
    userAction.shortcut
    userAction.description
    isToggled

viewLabel : Bool -> UserAction -> (TrWorkActions.Action -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator) -> TrLayout.Generator
viewLabel isToggled userAction function =
  function
    userAction.action
    userAction.shortcut
    userAction.description
    userAction.label
    isToggled

viewLongLabel : Bool -> UserAction -> (TrWorkActions.Action -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator) -> TrLayout.Generator
viewLongLabel isToggled userAction function =
  function
    userAction.action
    userAction.shortcut
    userAction.description
    userAction.longLabel
    isToggled


{-| State User Actions
-}

constructStateUserAction : TrState.State -> TrInput.Shortcut -> String -> String -> String -> UserAction
constructStateUserAction state shortcut label longLabel description =
  { action = TrWorkActions.SetState state
  , modelAction =
      (\model ->
        { model | state <- state }
        )
  , shortcut = shortcut
  , label = label
  , longLabel = longLabel
  , description = description
  }

close : UserAction
close =
  constructStateUserAction
    TrState.Default
    { optionKeys = [ TrKeyboard.alt ]
    , otherKeys = [ TrKeyboard.c ]
    }
    "Close"
    "Close"
    "Return back to the editor."

gotoNew : UserAction
gotoNew =
  constructStateUserAction
    TrState.New
    { optionKeys = [ TrKeyboard.alt ]
    , otherKeys = [ TrKeyboard.n ]
    }
    "New"
    "New Document"
    "Create a new document."

gotoOpen : UserAction
gotoOpen =
  constructStateUserAction
    TrState.Open
    { optionKeys = [ TrKeyboard.alt ]
    , otherKeys = [ TrKeyboard.o ]
    }
    "Open"
    "Open Document"
    "Open an existing document."

gotoSave : UserAction
gotoSave =
  constructStateUserAction
    TrState.Save
    { optionKeys = [ TrKeyboard.alt, TrKeyboard.shift ]
    , otherKeys = [ TrKeyboard.s ]
    }
    "Save As"
    "Save Document As"
    "Save current document as a new document."

gotoAbout : UserAction
gotoAbout =
  constructStateUserAction
    TrState.About
    TrInput.emptyShortcut
    "About"
    "About Trixel"
    "General information on Trixel."

gotoHelp : UserAction
gotoHelp =
  constructStateUserAction
    TrState.Help
    { optionKeys = [ TrKeyboard.alt ]
    , otherKeys = [ TrKeyboard.i ]
    }
    "Help"
    "Help"
    "Information on shortcuts and how to use Trixel."

gotoSettings : UserAction
gotoSettings =
  constructStateUserAction
    TrState.Settings
    { optionKeys = [ TrKeyboard.alt ]
    , otherKeys = [ TrKeyboard.p ]
    }
    "Settings"
    "Settings"
    "View and modify your editor editings."


{-| Document related user-actions
-}

saveDoc : UserAction
saveDoc =
  { action = TrWorkActions.SaveDocument
  , modelAction = TrUpdateWork.saveDocument
  , shortcut =
      { optionKeys = [ TrKeyboard.alt ]
      , otherKeys = [ TrKeyboard.s ]
      }
  , label = "Save"
  , longLabel = "Save Document"
  , description = "Save current document."
  }

newDoc : UserAction
newDoc =
  { action = TrWorkActions.NewDocument
  , modelAction = TrUpdateWork.newDocument
  , shortcut = TrInput.simpleShortcut [ TrKeyboard.enter ]
  , label = "Create"
  , longLabel = "Create Document"
  , description = "Create a new document."
  }

openDoc : UserAction
openDoc =
  { action = TrWorkActions.OpenDocument
  , modelAction = TrUpdateWork.openDocument
  , shortcut = TrInput.simpleShortcut [ TrKeyboard.enter ]
  , label = "Open"
  , longLabel = "Open Document"
  , description = "Open the selected document."
  }
