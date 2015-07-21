module Trixel.Models.Work.Model where

import Trixel.Models.Work.Document as TrDocumentModel
import Trixel.Models.Work.Input as TrInputModel

import Trixel.Math.Vector as TrVector
import Trixel.Types.State as TrState


computeTitle : Model -> String
computeTitle model =
  let title =
        TrDocumentModel.computeFileName
          model.document
  in
    if model.unsavedProgress
      then title ++ " *"
      else title


initialModel : Model
initialModel =
  { unsavedProgress = True
  , document = TrDocumentModel.initialModel
  , input = TrInputModel.initialModel
  , dimensions = TrVector.zeroVector
  , isFullscreen = False
  , state = TrState.initialState
  }


type alias Model =
  { unsavedProgress : Bool
  , document : TrDocumentModel.Model
  , input : TrInputModel.Model
  , dimensions : TrVector.Vector
  , isFullscreen : Bool
  , state : TrState.State
  }