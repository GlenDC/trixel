module Trixel.Types.Work2D.Layer where

import Trixel.Types.List as TrList
import Trixel.Types.Trixel as TrTrixel

import Trixel.Types.Work2D.Row as TrRow

import List
import Maybe exposing (..)
import Math.Vector2 as Vector


type alias Layers = List Layer

type alias Layer =
  { identifier : Int
  , title : Maybe String
  , grid : TrRow.Grid
  }


computeTitle : Layer -> String
computeTitle layer =
  case layer.title of
    Nothing ->
      -- todo: replace with correct localised version
      "Layer" ++ (toString layer.identifier)

    Just title ->
      title


construct : Int -> Maybe String -> Layer
construct identifier title =
  { identifier = identifier
  , title = title
  , grid = []
  }


findTrixel : Int -> Vector.Vec2 -> Layers -> (Maybe TrTrixel.Trixel)
findTrixel identifier position layers =
  case find identifier layers of
    Nothing ->
      Nothing

    Just layer ->
      TrRow.findTrixel position layer.grid


eraseTrixel : Int -> Vector.Vec2 -> Layers -> Layers
eraseTrixel identifier position layers =
  let (layers', result) =
        erase identifier layers
  in
    case result of
      -- Layer doesn't exist, so nothing to do here
      Nothing ->
        layers

      Just layer ->
        { layer
            | grid <-
                TrRow.eraseTrixel position layer.grid
        }
        :: layers'


insertTrixel : Int -> TrTrixel.Trixel -> Layers -> Layers
insertTrixel identifier trixel layers =
  let (layers', result) =
        erase identifier layers
  in
    case result of
      -- Layer doesn't exist, so nothing to do here
      Nothing ->
        layers

      Just layer ->
        { layer
            | grid <-
                TrRow.insertTrixel trixel layer.grid
        }
        :: layers'


erase : Int -> Layers -> (Layers, Maybe Layer)
erase identifier layers =
  TrList.erase
    (\layer ->
      layer.identifier == identifier)
    layers


find : Int -> Layers -> Maybe Layer
find identifier layers =
  TrList.find
    (\layer ->
      layer.identifier == identifier)
    layers


insert : Layer -> Layers -> Layers
insert layer layers =
  let (layers', result) =
        TrList.replace
          (\a b ->
            a.identifier == b.identifier)
          layer
          layers
  in
    case result of
      -- adding new layer to layers
      Nothing ->
        layer :: layers

      -- replaced existing layer with new layer
      Just _ ->
        layers'