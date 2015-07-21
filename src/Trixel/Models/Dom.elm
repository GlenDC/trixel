module Trixel.Models.Dom
  ( initialModel
  , Model
  , update
  )
  where

import Trixel.Models.Work.Model as TrWorkModel
import Trixel.Types.State as TrState
import Trixel.Types.Input as TrInput
import Trixel.Types.Keyboard as TrKeyboard


initialModel : Model
initialModel =
  { tags =
      { workspace = "tr-workspace"
      , footerHelp = "tr-help-description"
      , footerShortcut = "tr-help-shortcut"
      }
  , messages =
      { unsavedProgress = "You have unsaved progress in your Trixel work. In case you choose to continue you will lose that progress."
      }
  , title = "Trixel"
  , exceptionalKeys =
      [ TrKeyboard.escape
      ]
  , limitInput = True
  , isDirty = False
  }


type alias Model =
  { tags : Tags
  , messages : Messages
  , title : String
  , exceptionalKeys : TrInput.Buttons
  , limitInput : Bool
  , isDirty : Bool
  }


type alias Messages =
  { unsavedProgress : String
  }


type alias Tags =
  { workspace : String
  , footerHelp : String
  , footerShortcut : String
  }


update : TrWorkModel.Model -> Model -> Model
update workModel model =
  { model
      | title <- TrWorkModel.computeTitle workModel
      , limitInput <- (workModel.state == TrState.Default)
      , isDirty <- workModel.unsavedProgress
  }