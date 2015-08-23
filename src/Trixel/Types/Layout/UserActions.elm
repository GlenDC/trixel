module Trixel.Types.Layout.UserActions where

import Trixel.Types.Input as TrInput
import Trixel.Types.State as TrState
import Trixel.Types.Keyboard as TrKeyboard

import Trixel.Types.Layout as TrLayout

import Trixel.Models.Model as TrModel
import Trixel.Models.Work.Model as TrWorkModel

import Trixel.Models.Work.Actions as TrWorkActions


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
  , toggleCheck : TrModel.Model -> Bool
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

view : TrModel.Model -> UserAction -> (TrWorkActions.Action -> TrInput.Shortcut -> String -> Bool -> TrLayout.Generator) -> TrLayout.Generator
view model userAction function =
  function
    userAction.action
    userAction.shortcut
    userAction.description
    (userAction.toggleCheck model)

viewLabel : TrModel.Model -> UserAction -> (TrWorkActions.Action -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator) -> TrLayout.Generator
viewLabel model userAction function =
  function
    userAction.action
    userAction.shortcut
    userAction.description
    userAction.label
    (userAction.toggleCheck model)

viewLongLabel : TrModel.Model -> UserAction -> (TrWorkActions.Action -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator) -> TrLayout.Generator
viewLongLabel model userAction function =
  function
    userAction.action
    userAction.shortcut
    userAction.description
    userAction.longLabel
    (userAction.toggleCheck model)


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
  , toggleCheck =
      (\model ->
        model.work.state == state
        )
  }


close : UserAction
close =
  constructStateUserAction
    TrState.Default
    (TrInput.simpleShortcut [ TrKeyboard.c ])
    "Close"
    "Close"
    "Return back to the editor."

newDoc : UserAction
newDoc =
  constructStateUserAction
    TrState.New
    { optionKeys = [ TrKeyboard.alt ]
    , otherKeys = [ TrKeyboard.n ]
    }
    "New"
    "New Document"
    "Create a new document."

openDoc : UserAction
openDoc =
  constructStateUserAction
    TrState.Open
    { optionKeys = [ TrKeyboard.alt ]
    , otherKeys = [ TrKeyboard.o ]
    }
    "Open"
    "Open Document"
    "Open an existing document."

saveDoc : UserAction
saveDoc =
  constructStateUserAction
    TrState.Save
    { optionKeys = [ TrKeyboard.alt ]
    , otherKeys = [ TrKeyboard.s ]
    }
    "Save"
    "Save Document"
    "Save current document."

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
    , otherKeys = [ TrKeyboard.o ]
    }
    "Settings"
    "Settings"
    "View and modify your editor editings."
