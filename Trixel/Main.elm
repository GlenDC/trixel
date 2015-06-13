module Trixel.Main where

import Trixel.ColorScheme exposing (ColorScheme, zenburnScheme)
import Trixel.Types exposing (..)
import Trixel.WorkSpace
import Trixel.Menu

import Html exposing (Html, Attribute, text, toElement, div, input)
import Html.Attributes exposing (style)
import Html.Events exposing (on, targetValue)
import Signal exposing (Address, Mailbox, mailbox)
import Window
import String

---

actionQuery : Mailbox TrixelAction
actionQuery = mailbox trixelAction

main : Signal Html
main =
  Signal.map2 view Window.dimensions
    (Signal.foldp update (createNewState 10 10) actionQuery.signal)

---

createNewState: Int -> Int -> State
createNewState cx cy =
  { cx = cx, cy = cy, colorScheme = zenburnScheme }

---

update: TrixelAction -> State -> State
update action state =
  state

---

view: (Int, Int) -> State -> Html
view (w', h') state =
  let w = toFloat w'
      h = toFloat h'

      menu = dimensionContext w (clamp 40 80 (h * 0.04)) (5, 5) (0, 0)
      workspace = dimensionContext w (h - menu.h) (0, 0) (20, 20)
  in
    div [ createMainStyle state ] [
      (Trixel.Menu.view actionQuery.address menu state),
      (Trixel.WorkSpace.view actionQuery.address workspace state)
    ]

---

createMainStyle: State -> Attribute
createMainStyle state  =
  style [
    ("width", "100%"),
    ("height", "100%"),
    ("padding", "0 0"),
    ("margin", "0 0"),
    ("background-color", state.colorScheme.subbg.html),
    ("position", "absolute"),
    ("box-sizing", "border-box")
  ]