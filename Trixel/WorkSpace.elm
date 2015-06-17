module Trixel.WorkSpace (view) where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Types exposing (..)
import Trixel.Grid exposing (renderMouse)

import Html exposing (Html, Attribute, div, fromElement)
import Html.Attributes exposing (style)
import Html.Events exposing (onMouseEnter, onMouseLeave, onMouseMove)
import Signal exposing (Address)

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

view:  Address TrixelAction -> State -> Html
view address state =
  div [ createMainStyle state,
        onMouseEnter address (SetCondition (CActive MsgEmpty)),
        onMouseLeave address (SetCondition CIdle)
    ] [ viewWorkSpace state ]

createMainStyle: State -> Attribute
createMainStyle state  =
  let workspace = state.html.dimensions.workspace
      {x, y} = calculateDimensionsFromBounds state.trixelInfo.bounds
      margin = { x = (workspace.w - x) / 2 + workspace.m.x,
                 y = (workspace.h - y) / 2 + workspace.m.y }
  in
    style [
      ("box-sizing", "inherit"),
      ("padding", (pxFromVector workspace.p)),
      ("margin", (pxFromVector margin)),
      ("width", (pxFromFloat x)),
      ("height", (pxFromFloat y))
    ]

---

viewWorkSpace : State -> Html
viewWorkSpace state =
  let {x, y} = calculateDimensionsFromBounds state.trixelInfo.bounds
  in
    collage (round x) (round y)
      (renderMouse state x y state.grid)
      |> fromElement
