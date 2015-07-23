module Trixel.Models.Work.Model where

import Trixel.Models.Work.Document as TrDocumentModel
import Trixel.Models.Work.Input as TrInputModel

import Trixel.Math.Vector as TrVector
import Trixel.Types.State as TrState

import Maybe exposing (..)


computeTitle : Model -> String
computeTitle model =
  case model.document of
    Just document ->
      let title =
            TrDocumentModel.computeFileName
              document
      in
        if model.unsavedProgress
          then title ++ " *"
          else title

    Nothing ->
      "Trixel"


hasDocument : Model -> Bool
hasDocument model =
  model.document /= Nothing


initialModel : Model
initialModel =
  { unsavedProgress = False
  , document = Nothing
  , input = TrInputModel.initialModel
  , dimensions = TrVector.zeroVector
  , isFullscreen = False
  , state = TrState.initialState
  }


type alias Model =
  { unsavedProgress : Bool
  , document : Maybe TrDocumentModel.Model
  , input : TrInputModel.Model
  , dimensions : TrVector.Vector
  , isFullscreen : Bool
  , state : TrState.State
  }