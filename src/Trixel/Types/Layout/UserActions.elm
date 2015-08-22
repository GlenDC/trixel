module Trixel.Types.Layout.UserActions where

import Trixel.Types.Input as TrInput
import Trixel.Types.State as TrState
import Trixel.Types.Keyboard as TrKeyboard

import Trixel.Types.Layout as TrLayout

import Trixel.Models.Model as TrModel

import Trixel.Models.Work.Actions as TrWorkActions


{-| Nice constant interface for UserAction.
    This way the information needed for such an action
    can be shared accross the codebase for several layout elements
    and react to the shortcut as well.
-}

type alias UserAction =
  { action : TrWorkActions.Action
  , shortcut : TrInput.Buttons
  , label : String
  , longLabel : String
  , description : String
  , toggleCheck : TrModel.Model -> Bool
  }


{-| Help functions to use a userAction to render layout elements.
-}

view : TrModel.Model -> UserAction -> (TrWorkActions.Action -> TrInput.Buttons -> String -> Bool -> TrLayout.Generator) -> TrLayout.Generator
view model userAction function =
  function
    userAction.action
    userAction.shortcut
    userAction.description
    (userAction.toggleCheck model)

viewLabel : TrModel.Model -> UserAction -> (TrWorkActions.Action -> TrInput.Buttons -> String -> String -> Bool -> TrLayout.Generator) -> TrLayout.Generator
viewLabel model userAction function =
  function
    userAction.action
    userAction.shortcut
    userAction.description
    userAction.label
    (userAction.toggleCheck model)

viewLongLabel : TrModel.Model -> UserAction -> (TrWorkActions.Action -> TrInput.Buttons -> String -> String -> Bool -> TrLayout.Generator) -> TrLayout.Generator
viewLongLabel model userAction function =
  function
    userAction.action
    userAction.shortcut
    userAction.description
    userAction.longLabel
    (userAction.toggleCheck model)


{-| Common UserActions
-}

close : UserAction
close =
  { action = TrWorkActions.SetState TrState.Default
  , shortcut = [ TrKeyboard.c ]
  , label = "Close"
  , longLabel = "Close"
  , description = "Return back to the editor."
  , toggleCheck =
      (\model -> model.work.state == TrState.Default)
  }


{-| Main Menu UserActions
-}

newDoc : UserAction
newDoc =
  { action = TrWorkActions.SetState TrState.New
  , shortcut = [ TrKeyboard.alt, TrKeyboard.n ]
  , label = "New"
  , longLabel = "New Document"
  , description = "Create a new document."
  , toggleCheck =
      (\model -> model.work.state == TrState.New)
  }

openDoc : UserAction
openDoc =
  { action = TrWorkActions.SetState TrState.Open
  , shortcut = [ TrKeyboard.alt, TrKeyboard.o ]
  , label = "Open"
  , longLabel = "Open Document"
  , description = "Open an existing document."
  , toggleCheck =
      (\model -> model.work.state == TrState.Open)
  }

saveDoc : UserAction
saveDoc =
  { action = TrWorkActions.SetState TrState.Save
  , shortcut = [ TrKeyboard.alt, TrKeyboard.s ]
  , label = "Save"
  , longLabel = "Save Document"
  , description = "Save current document."
  , toggleCheck =
      (\model -> model.work.state == TrState.Save)
  }

gotoAbout : UserAction
gotoAbout =
  { action = TrWorkActions.SetState TrState.About
  , shortcut = []
  , label = "About"
  , longLabel = "About"
  , description = "General information on Trixel."
  , toggleCheck =
      (\model -> model.work.state == TrState.About)
  }

gotoHelp : UserAction
gotoHelp =
  { action = TrWorkActions.SetState TrState.Help
  , shortcut = [ TrKeyboard.alt, TrKeyboard.i ]
  , label = "Help"
  , longLabel = "Help"
  , description = "Information on shortcuts and how to use Trixel."
  , toggleCheck =
      (\model -> model.work.state == TrState.Help)
  }

gotoSettings : UserAction
gotoSettings =
  { action = TrWorkActions.SetState TrState.Settings
  , shortcut = [ TrKeyboard.alt, TrKeyboard.p ]
  , label = "Settings"
  , longLabel = "Settings"
  , description = "View and modify your editor settings."
  , toggleCheck =
      (\model -> model.work.state == TrState.Settings)
  }
