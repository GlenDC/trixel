module Trixel.Zones.WorkSpace (view) where

import Trixel.Types.ColorScheme exposing (ColorScheme)
import Trixel.Types.General exposing (..)
import Trixel.Types.Math exposing (..)
import Trixel.Types.Html exposing (..)
import Trixel.PostOffice exposing (..)
import Trixel.Constants exposing (..)
import Trixel.Zones.WorkSpace.Grid exposing (renderMouse)

import Html exposing (Html, Attribute, div, fromElement)
import Html.Attributes exposing (style, class)

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)


view : State -> Html
view state =
  div
    [ constructMainStyle state
    , class "noselect"
    ]
    [ viewWorkSpace state ]


constructMainStyle : State -> Attribute
constructMainStyle state =
  let workspace =
        state.boxModels.workspace

      {x, y} =
        computeDimensionsFromBounds state.trixelInfo.bounds

      margin =
        { x = (workspace.width - x) / 2 |> (+) workspace.margin.x
        , y = (workspace.height - y) / 2 |> (+) workspace.margin.y
        }

      boxModel =
        constructBoxModel
          x y
          workspace.padding.x workspace.padding.y
          margin.x margin.y
          workspace.sizing

      cursor =
        if | state.mouseState == MouseNone ->
                "default"
           | isKeyCodeInSet keyCodeAlt state.actions.keysDown ->
                "copy"
           | isKeyCodeInSet keyCodeCtrl state.actions.keysDown ->
                "crosshair"
           | otherwise ->
                "pointer"

  in
    ("cursor", cursor) :: (computeBoxModelCSS boxModel)
    |> style


viewWorkSpace : State -> Html
viewWorkSpace state =
  let {x, y} =
        computeDimensionsFromBounds state.trixelInfo.bounds
  in
    state.renderCache.layers ++
      (renderMouse state x y
        ( if state.userSettings.showGrid
          then state.renderCache.grid
          else []
          )
        )
    |> collage (round x) (round y)
    |> fromElement