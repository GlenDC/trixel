module Trixel.Models.Work.Scratch where

import Trixel.Models.Work.Document as TrDocument

import Math.Vector2 as Vector


initialModel : Model
initialModel =
  { openDoc = TrDocument.initialModel
  }


type alias Model =
  { openDoc : TrDocument.Model
  }


computeOpenDocTitle : Model -> String
computeOpenDocTitle model =
  case model.openDoc.title of
    Just name -> name
    Nothing -> "Untitled"


computeWidthString : Model -> String
computeWidthString model =
  Vector.getX model.openDoc.dimensions
  |> round |> toString


computeHeightString : Model -> String
computeHeightString model =
  Vector.getY model.openDoc.dimensions
  |> round |> toString
