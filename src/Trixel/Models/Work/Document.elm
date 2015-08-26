module Trixel.Models.Work.Document
  ( initialModel
  , Model
  , computeFileName
  , updateTitle
  , resetTitle
  , updateWidth
  , updateHeight
  )
  where

import Maybe exposing (..)

import Math.Vector2 as Vector


initialModel : Model
initialModel =
  { title = Nothing
  , dimensions =
      Vector.vec2 10 10
  }


type alias Model =
  { title : Maybe String
  , dimensions : Vector.Vec2
  }


computeFileName : Model -> String
computeFileName model =
  (case model.title of
    Just title ->
      title

    Nothing ->
      "untitled" -- todo: replace with localised version
  ) ++ ".trixel"


updateTitle : Model -> String -> Model
updateTitle model title =
  { model | title <- Just title }


resetTitle : Model -> Model
resetTitle model =
  { model | title <- Nothing }


updateWidth : Model -> Float -> Model
updateWidth model x =
  let y = Vector.getY model.dimensions
  in { model | dimensions <- Vector.vec2 x y }


updateHeight : Model -> Float -> Model
updateHeight model y =
  let x = Vector.getX model.dimensions
  in { model | dimensions <- Vector.vec2 x y }
