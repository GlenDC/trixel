module Trixel.Main where

import Trixel.ColorScheme exposing (ColorScheme, zenburnScheme)
import Color exposing (red)
import Trixel.Types exposing (..)
import Trixel.WorkSpace
import Trixel.Constants exposing (..)
import Trixel.Footer
import Trixel.Menu

import Html exposing (Html, Attribute, text, toElement, div, input)
import Html.Attributes exposing (style)
import Html.Events exposing (on, targetValue)
import Signal exposing (..)
import Window
import String
import Keyboard
import Mouse
import Debug

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

resetState: State -> State
resetState state =
  let trixelInfo = state.trixelInfo
  in { state | trixelInfo <- { trixelInfo |
        count <- { x = 1, y = 1 },
        mode <- Vertical } }

---

updateOffset: FloatVec2D -> State -> State
updateOffset offset state =
  if state.trixelInfo.scale <= 1 then state else
    let trixelInfo = state.trixelInfo
        {x, y} = trixelInfo.offset
        nox = x + (offset.x * moveSpeed)
        noy = y + (offset.y * moveSpeed)
    in
      { state | trixelInfo <-
        { trixelInfo | offset <- { x = nox, y = noy } } }

updateMousePosition: FloatVec2D -> State -> State
updateMousePosition point state =
  state

updateScale: Float -> State -> State
updateScale scale state =
  let trixelInfo = state.trixelInfo
  in
    { state | trixelInfo <-
      { trixelInfo |
        scale <- scale,
        offset <- if scale <= 1 then { x = 0, y = 0 }
                  else trixelInfo.offset } }

updateDimensions: FloatVec2D -> State -> State
updateDimensions dimensions state =
  state

updateGridX: Int -> State -> State
updateGridX x state =
  let trixelInfo = state.trixelInfo
  in
    { state | trixelInfo <-
      { trixelInfo |
        count <- { x = x, y = trixelInfo.count.y } } }

updateGridY: Int -> State -> State
updateGridY y state =
  let trixelInfo = state.trixelInfo
  in
    { state | trixelInfo <-
      { trixelInfo |
        count <- { x = trixelInfo.count.x, y = y } } }

updateMode: TrixelMode -> State -> State
updateMode mode state =
  let trixelInfo = state.trixelInfo
  in
    { state | trixelInfo <-
      { trixelInfo | mode <- mode } }

update action state =
  case action of
    SetGridX x -> updateGridX x state
    SetGridY y -> updateGridY y state
    SetScale scale -> updateScale scale state
    SetMode mode -> updateMode mode state
    Resize dimensions -> updateDimensions dimensions state
    MoveOffset point -> updateOffset point state
    MoveMouse point -> updateMousePosition point state
    NewDoc -> resetState state
    OpenDoc -> (Debug.log "todo, OpenDoc..." state)
    SaveDoc -> (Debug.log "todo, SaveDoc..." state)
    SaveDocAs -> (Debug.log "todo, SaveDocAs..." state)

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
