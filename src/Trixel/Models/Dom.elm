module Trixel.Models.Dom
  ( initialModel
  , Model
  , update
  )
  where

import Trixel.Models.Work as TrWork


initialModel : Model
initialModel =
  { tags =
      { workspace = "ws-canvas"
      , main = "uv-main"
      }
  , title = "Trixel"
  }


type alias Model =
  { tags : Tags
  , title : String
  }


type alias Tags =
  { workspace : String
  , main : String
  }


update : TrWork.Model -> Model -> Model
update workModel model =
  { model | title <-
    TrWork.computeTitle workModel }