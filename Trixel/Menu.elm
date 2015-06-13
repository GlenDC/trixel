module Trixel.Menu where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Types exposing (State)

import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (style)
import Signal exposing (Address)

view : Address State -> State -> Html
view  address state =
  div [ createMainStyle state ] []

createMainStyle: State -> Attribute
createMainStyle state  =
  style [
    ("width", "100%"),
    ("height", "5%"),
    ("padding", "1% 1%"),
    ("float", "left"),
    ("background-color", state.colorScheme.subbg.html),
    ("box-sizing", "inherit"),
    ("border-bottom", "1px solid " ++ state.colorScheme.subfg.html)
  ]