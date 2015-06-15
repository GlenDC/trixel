module Trixel.Main where

import Trixel.ColorScheme exposing (ColorScheme, zenburnScheme)
import Trixel.Update exposing (update)
import Trixel.Types exposing (..)
import Trixel.WorkSpace
import Trixel.Constants exposing (..)
import Trixel.Footer
import Trixel.Menu

import Html exposing (Html, Attribute, text, toElement, div, input)
import Html.Attributes exposing (style)
import Html.Events exposing (on, targetValue)
import Signal exposing (..)
import Color exposing (red)
import Window
import String
import Keyboard
import Mouse

---

actionQuery : Mailbox TrixelAction
actionQuery = mailbox None

---

moveOffsetSignal =
  Signal.map (\{x, y} -> MoveOffset {
    x = toFloat x,
    y = toFloat y
    }) Keyboard.arrows

moveMouseSignal =
  Signal.map (\(x, y) -> MoveMouse {
    x = toFloat x,
    y = toFloat y
    }) Mouse.position

windowDimemensionsSignal =
  Signal.map (\(x, y) -> Resize {
    x = toFloat x,
    y = toFloat y
    }) Window.dimensions

---

main : Signal Html
main =
  Signal.map2 view Window.dimensions
    (Signal.foldp update (createNewState 10 10)
      (mergeMany [
        actionQuery.signal,
        moveOffsetSignal,
        moveMouseSignal,
        windowDimemensionsSignal
        ]))

---

createNewState: Int -> Int -> State
createNewState cx cy =
  {
    trixelInfo = { 
      bounds = {
        min = { x = 0, y = 0 },
        max = { x = 0, y = 0 }
      },
      size = 0,
      mode = Vertical,
      count = { x = cx, y = cy },
      scale = 1,
      offset = { x = 0, y = 0 }
    },
    trixelColor = red,
    colorScheme = zenburnScheme
  }

---

view: (Int, Int) -> State -> Html
view (w', h') state =
  let w = toFloat w'
      h = toFloat h'

      menu = dimensionContext w (clamp 40 80 (h * 0.04)) (5, 5) (0, 0)
      footer = dimensionContext w footerSize (0, 0) (5, 8)
      workspace = dimensionContext w (h - menu.h - footerSize) (0, 0) (20, 20)
  in
    div [ createMainStyle state ] [
      (Trixel.Menu.view actionQuery.address menu state),
      (Trixel.Footer.view actionQuery.address footer state),
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
