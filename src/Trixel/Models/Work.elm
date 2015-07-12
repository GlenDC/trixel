module Trixel.Models.Work
  ( initialModel
  , Model
  , computeTitle
  )
  where

import Trixel.Models.Document as TrDocument


initialModel : Model
initialModel =
  { unsavedProgress = False
  , document = TrDocument.initialModel
  }


type alias Model =
  { unsavedProgress : Bool
  , document : TrDocument.Model
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