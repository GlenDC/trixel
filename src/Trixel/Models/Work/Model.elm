module Trixel.Models.Work.Model where

import Trixel.Models.Work.Document as TrDocumentModel
import Trixel.Models.Work.Scratch as TrScratchModel
import Trixel.Models.Work.Input as TrInputModel

import Math.Vector2 exposing (vec2, Vec2)
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
  , scratch = TrScratchModel.initialModel
  , input = TrInputModel.initialModel
  , dimensions = (vec2 0 0)
  , isFullscreen = False
  , state = TrState.initialState
  }


type alias Model =
  { unsavedProgress : Bool
  , document : Maybe TrDocumentModel.Model
  , scratch: TrScratchModel.Model
  , input : TrInputModel.Model
  , dimensions : Vec2
  , isFullscreen : Bool
  , state : TrState.State
  }
