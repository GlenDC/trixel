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
      { workspace = "tr-workspace"
      , main = "tr-main"
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