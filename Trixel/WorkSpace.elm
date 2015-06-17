module Trixel.WorkSpace (view) where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Types exposing (..)
import Trixel.Grid exposing (renderMouse)

import Html exposing (Html, Attribute, div, fromElement)
import Html.Attributes exposing (style)
import Signal exposing (Address)

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

view: State -> Html
view state =
  div [ createMainStyle state ] [ viewWorkSpace state ]

createMainStyle: State -> Attribute
createMainStyle state  =
  style ((dimensionToHtml state.html.dimensions.workspace) ++ [
    ("box-sizing", "inherit"),
    ("border", "1px solid white")
  ])

---

viewWorkSpace : State -> Html
viewWorkSpace state =
  let dimensions = state.html.dimensions.workspace
      bounds = state.trixelInfo.bounds
      (w, h) = (
        toFloat (bounds.max.x - bounds.min.x),
        toFloat (bounds.max.y - bounds.min.y)
        )
  in
    collage (round dimensions.w) (round dimensions.h)
      (renderMouse state w h state.grid)
      |> fromElement
