module Trixel.Models.Dom
  ( initialModel
  , Model
  , update
  )
  where

import Trixel.Models.Work.Model as TrWorkModel


initialModel : Model
initialModel =
  { tags =
      { workspace = "tr-workspace"
      }
  , title = "Trixel"
  }


type alias Model =
  { tags : Tags
  , title : String
  }


type alias Tags =
  { workspace : String
  }


update : TrWorkModel.Model -> Model -> Model
update workModel model =
  { model | title <-
    TrWorkModel.computeTitle workModel }