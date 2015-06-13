module Trixel.Main where

import Trixel.ColorScheme exposing (ColorScheme, zenburnScheme)
import Trixel.Types exposing (State)
import Trixel.WorkSpace
import Trixel.Menu

import Html exposing (Html, Attribute, text, toElement, div, input)
import Html.Attributes exposing (style)
import Html.Events exposing (on, targetValue)
import Signal exposing (Address)
import StartApp
import String
import Debug

---

---

createNewState: Int -> Int -> State
createNewState cx cy =
  { cx = cx, cy = cy, colorScheme = zenburnScheme }

---

main =
  StartApp.start { model = createNewState 10 10, view = view, update = update }

---

update newState oldState =
  newState

---

view : Address State -> State -> Html
view address state =
  div [ createMainStyle state ] [
    (Trixel.Menu.view address state),
    (Trixel.WorkSpace.view address state)
  ]

---

createMainStyle: State -> Attribute
createMainStyle state  =
  style [
    ("width", "100%"),
    ("height", "100%"),
    ("padding", "0 0"),
    ("margin", "0 0"),
    ("background-color", state.colorScheme.bg.html),
    ("position", "absolute"),
    ("box-sizing", "border-box")
  ]