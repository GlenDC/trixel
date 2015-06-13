module Trixel.Footer where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Constants exposing (version, footerSize)
import Trixel.Types exposing (..)

import Html exposing (Html, Attribute, div, text)
import Html.Attributes exposing (style)
import Signal exposing (Address)

---

view : Address TrixelAction -> DimensionContext -> State -> Html
view  address ctx state =
  div [ createMainStyle ctx state ] [
    text ("Trixel v" ++ version)
  ]

---

createMainStyle: DimensionContext -> State -> Attribute
createMainStyle ctx state  =
  style ((dimensionToHtml ctx) ++ [
    ("color", state.colorScheme.subText.html),
    ("text-align", "right"),
    ("position", "absolute"),
    ("font-size", (toPx (footerSize * 1.25))),
    ("bottom", "0"),
    ("box-sizing", "border-content")
  ])