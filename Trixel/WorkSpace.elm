module Trixel.WorkSpace where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Types exposing (..)

import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (style)
import Signal exposing (Address)

view: Address TrixelAction -> DimensionContext -> State -> Html
view address ctx state =
  div [ createMainStyle ctx state ] []

createMainStyle: DimensionContext -> State -> Attribute
createMainStyle ctx state  =
  style ((dimensionToHtml ctx) ++ [
    ("box-sizing", "inherit"),
    ("border", "1px solid " ++ state.colorScheme.fg.html),
    ("background-color", state.colorScheme.bg.html)
  ])