module Trixel.Zones.WorkSpace (view) where

import Trixel.Types.ColorScheme exposing (ColorScheme)
import Trixel.Types.General exposing (..)
import Trixel.Types.Math exposing (..)
import Trixel.Types.Html exposing (..)
import Trixel.Zones.WorkSpace.Grid exposing (renderMouse)

import Html exposing (Html, Attribute, div, fromElement)
import Html.Attributes exposing (style)
import Html.Events exposing (onMouseEnter, onMouseLeave)

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)


view :  ActionAddress -> State -> Html
view address state =
  div
    [ constructMainStyle state
    , onMouseEnter address (SetCondition (ActiveCondition EmptyMessage))
    , onMouseLeave address (SetCondition IdleCondition)
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
  in
    computeBoxModelCSS boxModel
    |> style

---

viewWorkSpace : State -> Html
viewWorkSpace state =
  let {x, y} =
        computeDimensionsFromBounds state.trixelInfo.bounds
  in
    collage (round x) (round y) (renderMouse state x y state.grid)
    |> fromElement