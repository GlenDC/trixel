module Trixel.Types.Layer
  ( LayerPosition
  , TrixelLayers
  , Layer
  , insertNewLayer
  , insertLayer
  , eraseLayer
  , findLayer
  , findTrixel
  , eraseTrixel
  , insertTrixel
  , eraseLayerRowByPosition
  , eraseLayerTrixelByPosition
  )
  where

import Trixel.Types.Math exposing (..)
import Trixel.Types.Grid exposing (..)

import List exposing (..)
import Maybe exposing (..)


type alias LayerPosition = Int

type alias TrixelLayers = List Layer


type alias Layer =
  { position : LayerPosition
  , grid : TrixelGrid
  }


insertNewLayer : LayerPosition -> TrixelLayers -> TrixelLayers
insertNewLayer position layers =
  insertLayer
    { position = position
    , grid = []
    }
    layers


insertLayer : Layer -> TrixelLayers -> TrixelLayers
insertLayer layer layers =
  case findLayer layer.position layers of
    Nothing ->
      layer :: layers

    _ ->
      layers


eraseLayer : LayerPosition -> TrixelLayers -> TrixelLayers
eraseLayer position layers =
  filter
    (\layer ->
      layer.position /= position)
    layers


findLayer : LayerPosition -> TrixelLayers -> Maybe Layer
findLayer position layers =
  filter
    (\layer ->
      layer.position == position)
    layers
  |> head


findTrixel : Vector -> LayerPosition -> TrixelLayers -> Maybe Trixel
findTrixel position layerPosition layers =
  case findLayer layerPosition layers of
    Nothing ->
      Nothing

    Just layer ->
      findTrixelInGrid position layer.grid


eraseTrixel : Vector -> LayerPosition -> TrixelLayers -> TrixelLayers
eraseTrixel position layerPosition layers =
  case findLayer layerPosition layers of
    Nothing ->
      layers

    Just layer ->
      let filteredLayers =
            eraseLayer layerPosition layers
      in
        { position = layerPosition
        , grid = eraseTrixelInGrid position layer.grid
        }
        :: filteredLayers


insertTrixel : Trixel -> LayerPosition -> TrixelLayers -> TrixelLayers
insertTrixel trixel layerPosition layers =
  case findLayer layerPosition layers of
    Nothing ->
      let grid =
            insertTrixelInGrid trixel []
      in
        { position = layerPosition
        , grid = grid
        }
        :: layers

    Just layer ->
      let grid =
            insertTrixelInGrid trixel layer.grid
      in
        { position = layerPosition
        , grid = grid
        }
        :: (eraseLayer layerPosition layers)


-- will erase the row when the y-position is to big
eraseLayerRowByPosition : Int -> TrixelLayers -> TrixelLayers
eraseLayerRowByPosition position layers =
  List.map
    (\layer ->
      { layer
          | grid <-
              eraseGridRowByPredicate
                (\row ->
                  row.position < position)
                layer.grid
      })
    layers

-- will erase the trixel when the x-position is to big
eraseLayerTrixelByPosition : Int -> TrixelLayers -> TrixelLayers
eraseLayerTrixelByPosition position layers =
  List.map
    (\layer ->
      { layer
          | grid <-
              List.map
                (\row ->
                  { row
                      | columns <-
                          eraseGridTrixelByPredicate
                          (\column ->
                            column.position < position)
                          row.columns

                  }
                )
                layer.grid
        }
    )
    layers