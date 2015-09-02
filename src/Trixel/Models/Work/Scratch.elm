module Trixel.Models.Work.Scratch where

import Trixel.Models.Work.Document as TrDocument

import Math.Vector2 as Vector
import Maybe exposing (..)
import Result
import String


initialModel : Model
initialModel =
  { openDoc = initialDocumentSpecs
  }


type alias Model =
  { openDoc : DocumentSpecs
  }


initialDocumentSpecs : DocumentSpecs
initialDocumentSpecs =
  { title = Nothing
  , width = Just 10
  , height = Just 10
  }


type alias DocumentSpecs =
  { title : Maybe String
  , width : Maybe Int
  , height : Maybe Int
  }

computeOpenDocTitle : Model -> String
computeOpenDocTitle model =
  case model.openDoc.title of
    Just name -> name
    Nothing -> ""


computeWidthString : Model -> String
computeWidthString model =
  case model.openDoc.width of
    Just width -> toString width
    Nothing -> ""


computeHeightString : Model -> String
computeHeightString model =
  case model.openDoc.height of
    Just height -> toString height
    Nothing -> ""


newDocument : Model -> TrDocument.Model
newDocument model =
  let x = Maybe.withDefault 1 model.openDoc.width |> toFloat
      y = Maybe.withDefault 1 model.openDoc.height |> toFloat
  in
    { title = model.openDoc.title
    , dimensions = Vector.vec2 x y
    }


newTitle : DocumentSpecs -> String -> DocumentSpecs
newTitle model title =
  { model | title <- if title == "" then Nothing else Just title }


newWidth : DocumentSpecs -> String -> DocumentSpecs
newWidth model rawWidth =
  let width =
        if rawWidth == ""
          then Nothing
          else String.toInt rawWidth |> Result.toMaybe
  in { model | width <- width }


newHeight : DocumentSpecs -> String -> DocumentSpecs
newHeight model rawHeight =
  let height =
        if rawHeight == ""
          then Nothing
          else String.toInt rawHeight |> Result.toMaybe
  in { model | height <- height }
