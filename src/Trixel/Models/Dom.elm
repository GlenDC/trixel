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
  , title = "Trixel"
  , exceptionalKeys =
      [ TrKeyboard.escape
      ]
  , limitInput = True
  }


type alias Model =
  { tags : Tags
  , title : String
  , exceptionalKeys : TrInput.Buttons
  , limitInput : Bool
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
  }