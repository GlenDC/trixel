module Trixel.WorkSpace where

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
    ("width", "95%"),
    ("height", "90%"),
    ("margin", "2.5% 2.5% 2.5% 2.5%"),
    ("float", "left"),
    ("box-sizing", "inherit"),
    ("border", "1px solid " ++ state.colorScheme.subfg.html)
  ]