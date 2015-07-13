module Trixel.Models.Work.Document
  ( initialModel
  , Model
  , computeFileName
  )
  where

import Maybe exposing (..)


initialModel : Model
initialModel =
  { title = Nothing
  }


type alias Model =
  { title : Maybe String
  }


computeFileName : Model -> String
computeFileName model =
  (case model.title of
    Just title ->
      title

    Nothing ->
      "untitled" -- todo: replace with localised version
  ) ++ ".trixel"