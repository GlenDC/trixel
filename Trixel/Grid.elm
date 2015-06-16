module Trixel.Grid (updateGrid, renderMouse) where

import Trixel.Types exposing (..)
import Trixel.Constants exposing (..)

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

import Color exposing (lightGrey, red)

---

getCountX: Float -> TrixelMode -> Float
getCountX x mode =
  if mode == Horizontal then x else
    let a = toFloat ((round x) % 2)
    in ((x + (1 - a)) / 2) + (a * 0.5)

getCountY: Float -> TrixelMode -> Float
getCountY y mode =
  if mode == Vertical then y else
    let a = toFloat ((round y) % 2)
    in ((y + (1 - a)) / 2) + (a * 0.5)

---

updateGrid: State -> State
updateGrid state =
  let trixelInfo = state.trixelInfo

      workspace = state.html.dimensions.workspace

      count = trixelInfo.count
      (cx, cy) = ((toFloat count.x), (toFloat count.y))

      (sx, sy) = (workspace.w * trixelInfo.scale,
                  workspace.h * trixelInfo.scale)

      ts = (if (sx / cx * cy) > sy
            then (sy / cy)
            else (sx / cx)) / 2

      (w, h) = (ts * cx, ts * cy)

      (minX, minY) = (
        (state.dimensions.x - w) / 2,
        (state.dimensions.y - h) / 2
        )
  in
    { state |
      trixelInfo <- {
        trixelInfo |
          size <- ts,
          bounds <- {
            min = { x = (round minX), y = (round minY) },
            max = {
              x = round (minX + w),
              y = round (minY + h)
              } } } }
      |> generateGrid

---

weirdify: Float -> Float -> Float
weirdify offset coordinate =
  coordinate - (offset / 2)

getCoordinateFromIndex: Int -> Float -> Float -> Float
getCoordinateFromIndex c ts ws =
  c |> toFloat |> (*) ts |> weirdify ws

---

renderTriangle: Float -> Float -> Float -> Float -> Float -> Float -> Shape
renderTriangle x y x' y' x'' y'' =
  polygon [ (x, y), (x', y'), (x'', y'') ]

---

renderTrixel: TrixelOrientation -> Float -> Float -> Float -> (Shape -> Form) -> Form
renderTrixel orientation x y size styleFunction =
  let hh = (sqrt3 * size) / 2
      trixel = case orientation of
    Up -> renderTriangle x (y + hh) (x - size) (y - hh) (x + size) (y - hh)
    Down -> renderTriangle x (y - hh) (x - size) (y + hh) (x + size) (y + hh)
    {-Left -> renderTriangle x y x (y + size) (x + size) (y + (size / 2))
    Right -> renderTriangle x (y + (size / 2)) (x + size) (y + size) (x + size) y-}
  in styleFunction trixel

---

getTrixelOrientation: Int -> Int -> TrixelMode -> TrixelOrientation
getTrixelOrientation x y mode =
  if (x + y) % 2 == 0 then
    if mode == Horizontal then Left else Down
  else
    if mode == Horizontal then Right else Up

getSizePairFromTrixelMode: Float -> TrixelMode -> (Float, Float)
getSizePairFromTrixelMode size mode =
  if mode == Horizontal then (size * sqrt3, size) else (size, size * sqrt3)

---

renderTrixelRow: State -> Int -> Int -> Float -> Float -> Float -> List Form -> List Form
renderTrixelRow state cx cy w h size trixels =
  if cx == 0 then trixels else
    let (xs, ys) = getSizePairFromTrixelMode size state.trixelInfo.mode
        --offset = state.trixelInfo.offset
        x = getCoordinateFromIndex cx xs w--) + (offset.x * state.trixelInfo.scale)
        y = getCoordinateFromIndex cy ys h--) + (offset.y * state.trixelInfo.scale)
    in
      (renderTrixel (getTrixelOrientation cx cy state.trixelInfo.mode) x y size
        (\s -> outlined (solid lightGrey) s)) :: trixels
        |> renderTrixelRow state (cx - 1) cy w h size

renderGrid: State -> Int -> Int -> Float -> Float -> Float -> List Form -> List Form
renderGrid state cx cy w h size trixels =
  if cy == 0
    then trixels
    else
      renderTrixelRow state cx cy w h size trixels
        |> renderGrid state cx (cy - 1) w h size

---

generateGrid: State -> State
generateGrid state =
  let count = state.trixelInfo.count
      bounds = state.trixelInfo.bounds
      (w, h) = (
        toFloat (bounds.max.x - bounds.min.x),
        toFloat (bounds.max.y - bounds.min.y)
        )
  in
    { state |
        grid <- renderGrid state count.x count.y w h state.trixelInfo.size []
        }

---

{-renderTrixelOnPosition: State -> FloatVec2D -> Float -> Float -> Form
renderTrixelOnPosition state pos w h =
  let (xs, ys) = getSizePairFromTrixelMode state.trixelInfo.size state.trixelInfo.mode
      hsz = state.trixelInfo.size / 2
      cx = round ((pos.x + (xs - hsz)) / xs) |> clamp 1 state.trixelInfo.count.x
      cy = round ((h - pos.y + (ys - hsz)) / ys) |> clamp 1 state.trixelInfo.count.y
      
      x = (getCoordinateFromIndex cx xs w) + (state.trixelInfo.offset.x * state.trixelInfo.scale)
      y = (getCoordinateFromIndex cy ys h) + (state.trixelInfo.offset.y * state.trixelInfo.scale)
  in
    renderTrixel
      (getTrixelOrientation cx cy state.trixelInfo.mode)
      x y state.trixelInfo.size (\s -> filled red s)-}

renderMouse: State -> Float -> Float -> List Form -> List Form
renderMouse state w h trixels =
  trixels
  {-case state.mouseState of
    MouseNone -> trixels
    MouseHover pos -> (renderTrixelOnPosition state pos w h) :: trixels-}
