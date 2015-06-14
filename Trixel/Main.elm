module Trixel.Main where

import Trixel.ColorScheme exposing (ColorScheme, zenburnScheme)
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
import Debug

---

actionQuery : Mailbox TrixelAction
actionQuery = mailbox None

input = (,) <~ Keyboard.arrows ~ actionQuery.signal

main : Signal Html
main =
  Signal.map2 view Window.dimensions
    (Signal.foldp update (createNewState 10 10) input)

---

createNewState: Int -> Int -> State
createNewState cx cy =
  { cx = cx, cy = cy, scale = 1.0,
    offset = (0, 0), mode = Vertical,
    colorScheme = zenburnScheme }

resetState: State -> State
resetState oldState =
  { oldState | cx <- 1, cy <- 1, mode <- Vertical }

---

updateInput: Int -> Int -> State -> State
updateInput kh' kv' state =
  if state.scale <= 1
    then { state | offset <- (0, 0) }
    else
      let (ox, oy) = state.offset
          (kh, kv) = ((toFloat kh'), (toFloat kv'))
          nox = ox + (kh * moveSpeed)
          noy = oy + (kv * moveSpeed)
      in
        { state | offset <- (nox, noy) }

update ({x, y}, action) state =
  let state' =
    case action of
      SetGridX x -> { state | cx <- x }
      SetGridY y -> { state | cy <- y }
      SetScale scale -> { state | scale <- scale }
      SetMode mode -> { state | mode <- mode }
      NewDoc -> resetState state
      OpenDoc -> (Debug.log "todo, OpenDoc..." state)
      SaveDoc -> (Debug.log "todo, SaveDoc..." state)
      SaveDocAs -> (Debug.log "todo, SaveDocAs..." state)
  in updateInput x y state'

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
