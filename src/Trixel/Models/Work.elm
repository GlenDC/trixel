module Trixel.Models.Work
  ( initialModel
  , Model
  , computeTitle
  )
  where

import Trixel.Models.Work.Document as TrDocument
import Trixel.Models.Work.Input as TrInput


initialModel : Model
initialModel =
  { unsavedProgress = False
  , document = TrDocument.initialModel
  , input = TrInput.initialModel
  }


type alias Model =
  { unsavedProgress : Bool
  , document : TrDocument.Model
  , input : TrInput.Model
  }


computeTitle : Model -> String
computeTitle model =
  let title =
        TrDocument.computeFileName
          model.document
  in
    if model.unsavedProgress
      then title ++ "*"
      else title