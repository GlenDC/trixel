module Trixel.WorkSpace (view) where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Types exposing (..)

import Html exposing (Html, Attribute, div, fromElement)
import Html.Attributes exposing (style)
import Signal exposing (Address)

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

view: State -> Html
view state =
  div [ createMainStyle state ] [ viewWorkSpace state ]

createMainStyle: State -> Attribute
createMainStyle state  =
  style ((dimensionToHtml state.html.dimensions.workspace) ++ [
    ("box-sizing", "inherit")
  ])

---

weirdify: Float -> Float -> Float
weirdify coordinate offset =
  coordinate - (offset / 2)

getCoordinateFromIndex: Int -> Float -> Float -> Float
getCoordinateFromIndex c ts ws =
  weirdify (((toFloat c) - 1) * ts) ws

renderTriangle: Float -> Float -> Float -> Float -> Float -> Float -> Shape
renderTriangle x y x' y' x'' y'' =
  polygon [ (x, y), (x', y'), (x'', y'') ]

renderTrixel: TrixelOrientation -> Float -> Float -> Float -> (Shape -> Form) -> Form
renderTrixel orientation x y size styleFunction =
  let trixel = case orientation of
    Up -> renderTriangle x y (x + (size / 2)) (y + size) (x + size) y
    Down -> renderTriangle x (y + size) (x + (size / 2)) y (x + size) (y + size)
    Left -> renderTriangle x y x (y + size) (x + size) (y + (size / 2))
    Right -> renderTriangle x (y + (size / 2)) (x + size) (y + size) (x + size) y
  in styleFunction trixel

getTrixelOrientation: Int -> Int -> TrixelMode -> TrixelOrientation
getTrixelOrientation x y mode =
  if (x + y) % 2 == 0 then
    if mode == Horizontal then Left else Down
  else
    if mode == Horizontal then Right else Up

getSizePairFromTrixelMode: Float -> TrixelMode -> (Float, Float)
getSizePairFromTrixelMode size mode =
  if mode == Horizontal then (size, (size /2)) else ((size / 2), size)

renderTrixelRow: State -> Int -> Int -> Float -> Float -> Float -> List Form -> List Form
renderTrixelRow state cx cy size w h trixels =
  if cx == 0 then trixels else
    let (xs, ys) = getSizePairFromTrixelMode size state.trixelInfo.mode
        offset = state.trixelInfo.offset
        x = (getCoordinateFromIndex cx xs w) + (offset.x * state.trixelInfo.scale)
        y = (getCoordinateFromIndex cy ys h) + (offset.y * state.trixelInfo.scale)
    in
      (renderTrixel (getTrixelOrientation cx cy state.trixelInfo.mode) x y size
        (\s -> outlined (solid lightGrey) s)) :: trixels
        |> renderTrixelRow state (cx - 1) cy size w h

---

renderTrixelOnPosition: State -> FloatVec2D -> Float -> Float -> Form
renderTrixelOnPosition state pos w h =
  let hs = state.trixelInfo.size / 2
      cx = round ((pos.x) / (state.trixelInfo.size / 2))
      cy = round ((h - pos.y + hs) / state.trixelInfo.size)
      
      (xs, ys) = getSizePairFromTrixelMode state.trixelInfo.size state.trixelInfo.mode
      x = (getCoordinateFromIndex cx xs w) + (state.trixelInfo.offset.x * state.trixelInfo.scale)
      y = (getCoordinateFromIndex cy ys h) + (state.trixelInfo.offset.y * state.trixelInfo.scale)
  in
    renderTrixel
      (getTrixelOrientation cx cy state.trixelInfo.mode)
      x y state.trixelInfo.size (\s -> filled red s)


renderMouse: State -> Float -> Float -> List Form -> List Form
renderMouse state w h trixels =
  case state.mouseState of
    MouseNone -> trixels
    MouseHover pos -> (renderTrixelOnPosition state pos w h) :: trixels

---

renderWorkSpace: State -> Int -> Int -> Float -> Float -> Float -> List Form -> List Form
renderWorkSpace state cx cy size w h trixels =
  if cy == 0
    then renderMouse state w h trixels
    else
      renderTrixelRow state cx cy size w h trixels
        |> renderWorkSpace state cx (cy - 1) size w h

---

viewWorkSpace : State -> Html
viewWorkSpace state =
  let count = state.trixelInfo.count
      dimensions = state.html.dimensions.workspace
      bounds = state.trixelInfo.bounds
      (w, h) = (
        toFloat (bounds.max.x - bounds.min.x),
        toFloat (bounds.max.y - bounds.min.y)
        )
  in
    collage (round dimensions.w) (round dimensions.h)
      (renderWorkSpace state count.x count.y
        state.trixelInfo.size w h [])
      |> fromElement
