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
import Html.Events exposing (on, targetValue, onMouseEnter)
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
  Signal.map view
    (Signal.foldp update (createNewState 10 10)
      (mergeMany [
        actionQuery.signal,
        windowDimemensionsSignal,
        moveOffsetSignal,
        moveMouseSignal
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
      height = 0,
      width = 0,
      mode = Vertical,
      count = { x = cx, y = cy },
      scale = 1,
      offset = { x = 0, y = 0 },
      extraOffset = { x = 0, y = 0 }
    },
    trixelColor = red,
    colorScheme = zenburnScheme,
    html = {
      dimensions = {
        menu = dimensionContextDummy,
        footer = dimensionContextDummy,
        workspace = dimensionContextDummy
      }
    },
    dimensions = { x = 0, y = 0 },
    mouseState = MouseNone,
    grid = [],
    condition = CIdle
  }

---

view: State -> Html
view state =
  div [ createMainStyle state,
        onMouseEnter actionQuery.address (SetCondition CIdle) ] [
    (Trixel.Menu.view actionQuery.address state),
    (Trixel.Footer.view actionQuery.address state),
    (Trixel.WorkSpace.view actionQuery.address state)
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
