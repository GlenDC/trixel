module Trixel.Models.Work.Scratch where

import Trixel.Models.Work.Document as TrDocument


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
