module Trixel.Grid (updateGrid, renderMouse) where

import Trixel.Types exposing (..)
import Trixel.Constants exposing (..)

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

import Color exposing (lightGrey, red)

import Debug

{-getCountX: Float -> TrixelMode -> Float
getCountX x mode =
  if mode == Horizontal then x else
    let a = toFloat ((round x) % 2)
    in ((x + (1 - a)) / 2) + (a * 0.5)

getCountY: Float -> TrixelMode -> Float
getCountY y mode =
  if mode == Vertical then y else
    let a = toFloat ((round y) % 2)
    in ((y + (1 - a)) / 2) + (a * 0.5)

weirdify: Float -> Float -> Float
weirdify coordinate offset =
  coordinate - (offset / 2)

getCoordinateFromIndex: Int -> Float -> Float -> Float
getCoordinateFromIndex c ts ws =
  weirdify (((toFloat c) - 1) * ts) ws -}

updateGrid: State -> State
updateGrid state =
  let workspace = state.html.dimensions.workspace
      trixelInfo = state.trixelInfo

      (cx, cy) = ( toFloat trixelInfo.count.x,
                   toFloat trixelInfo.count.y )

      (dx, dy) = (cx + 1, sqrt3 * cy)

      (sw, sh) = ( workspace.w * trixelInfo.scale,
                   workspace.h * trixelInfo.scale )

      scale = min (sw / dx) (sh / dy)

      (w, h) = (scale * dx, scale * dy)
      (tw, th) = (w / dx, h / cy)

      (tox, toy) = (w / 2, h / 2)

      (minX, minY) = (
        (state.dimensions.x - w) / 2,
        (state.dimensions.y - h) / 2
        )
  in
    { state |
      trixelInfo <- {
        trixelInfo |
          width <- tw,
          height <- th,
          extraOffset <- { x = tox, y = toy},
          bounds <- {
            min = { x = (round minX), y = (round minY) },
            max = {
              x = round (minX + w),
              y = round (minY + h)
              } } } }
      |> generateGrid

---

weirdify: Float -> Float -> Float
weirdify coordinate size =
  coordinate - (size / 2)

getCoordinateFromIndex: Int -> Float -> Float -> Float
getCoordinateFromIndex count size offset =
  count |> toFloat |> (*) size |> weirdify offset

---

renderTriangle: Float -> Float -> Float -> Float -> Float -> Float -> Shape
renderTriangle x y x' y' x'' y'' =
  polygon [ (x, y), (x', y'), (x'', y'') ]

---

renderTrixel: TrixelOrientation -> Float -> Float -> Float -> Float -> (Shape -> Form) -> Form
renderTrixel orientation x y tw th styleFunction =
  let dw = tw * 2
      trixel = case orientation of
    Up -> renderTriangle x y (x + dw) y (x + tw) (y + th)
    Down -> renderTriangle x (y + th) (x + dw) (y + th) (x + tw) y
    Left -> renderTriangle x (y + tw) (x + th) y (x + th) (y + dw)
    Right -> renderTriangle (x + th) (y + tw) x y x (y + dw)
  in styleFunction trixel

---

getTrixelOrientation: Int -> Int -> TrixelMode -> TrixelOrientation
getTrixelOrientation x y mode =
  if (x + y) % 2 == 0 then
    if mode == Horizontal then Left else Down
  else
    if mode == Horizontal then Right else Up

---

renderTrixelRow: State -> Int -> Int -> Float -> Float -> List Form -> List Form
renderTrixelRow state cx cy w h trixels =
  if cx == 0 then trixels else
    let (sx, sy) = if state.trixelInfo.mode == Vertical
          then (state.trixelInfo.width, state.trixelInfo.height)
          else (state.trixelInfo.height, state.trixelInfo.width)
        x = ((toFloat (cx - 1)) * sx) - state.trixelInfo.extraOffset.x
        y = ((toFloat (cy - 1)) * sy) - state.trixelInfo.extraOffset.y
    in
      (renderTrixel (getTrixelOrientation cx cy state.trixelInfo.mode) x y state.trixelInfo.width state.trixelInfo.height
        (\s -> outlined (solid lightGrey) s)) :: trixels
        |> renderTrixelRow state (cx - 1) cy w h

renderGrid: State -> Int -> Int -> Float -> Float -> List Form -> List Form
renderGrid state cx cy w h trixels =
  if cy == 0
    then trixels
    else
      renderTrixelRow state cx cy w h trixels
        |> renderGrid state cx (cy - 1) w h

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
        grid <- renderGrid state count.x count.y w h []
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
