module Trixel.Grid (updateGrid, renderMouse) where

import Trixel.Types exposing (..)
import Trixel.Constants exposing (..)

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

import Color exposing (red)

import Debug

---

pointInTriangle: FloatVec2D -> FloatVec2D -> FloatVec2D -> FloatVec2D -> Bool
pointInTriangle p p0 p1 p2 =
  let s = p0.y * p2.x - p0.x * p2.y + (p2.y - p0.y) * p.x + (p0.x - p2.x) * p.y
      t = p0.x * p1.y - p0.y * p1.x + (p0.y - p1.y) * p.x + (p1.x - p0.x) * p.y
  in
    if (s < 0) /= (t < 0)
      then False
      else
        let a = -p1.y * p2.x + p0.y * (p2.x - p1.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y
        in
          if a < 0
            then -s > 0 && -t > 0 && (-s - t) < -a
            else s > 0 && t > 0 && (s + t) < a

---

updateGrid: State -> State
updateGrid state =
  let workspace = state.html.dimensions.workspace
      trixelInfo = state.trixelInfo

      (sw, sh, cx, cy) = if trixelInfo.mode == Vertical
                    then ( workspace.w * trixelInfo.scale,
                           workspace.h * trixelInfo.scale,
                           toFloat trixelInfo.count.x,
                           toFloat trixelInfo.count.y )
                    else ( workspace.h * trixelInfo.scale,
                           workspace.w * trixelInfo.scale,
                           toFloat trixelInfo.count.y,
                           toFloat trixelInfo.count.x )

      (dx, dy) = (cx + 1, sqrt3 * cy)

      scale = min (sw / dx) (sh / dy)

      (w, h) = (scale * dx, scale * dy)
      (tw, th) = (w / dx, h / cy)

      (tox, toy, maxX, maxY) = if trixelInfo.mode == Vertical
                    then (w / 2, h / 2, w, h)
                    else (h / 2, w / 2, h, w)
  in
    { state |
      trixelInfo <- {
        trixelInfo |
          width <- tw,
          height <- th,
          extraOffset <- { x = tox - trixelInfo.offset.x, y = toy - trixelInfo.offset.y },
          bounds <- {
            min = { x = 0, y = 0 },
            max = {
              x = round (min (workspace.w) maxX),
              y = round (min (workspace.h) maxY)
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
    let (sx, sy, cx', cy') = if state.trixelInfo.mode == Vertical
          then (state.trixelInfo.width, state.trixelInfo.height, cx, cy)
          else (state.trixelInfo.height, state.trixelInfo.width, cy, cx)
        x = ((toFloat (cx' - 1)) * sx) - state.trixelInfo.extraOffset.x
        y = ((toFloat (cy' - 1)) * sy) - state.trixelInfo.extraOffset.y
    in
      (renderTrixel (getTrixelOrientation cx cy state.trixelInfo.mode) x y state.trixelInfo.width state.trixelInfo.height
        (\s -> outlined (solid state.colorScheme.bg.elm) s)) :: trixels
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
      {x, y} = calculateDimensionsFromBounds state.trixelInfo.bounds
      (cx, cy) = if state.trixelInfo.mode == Vertical
        then (count.x, count.y) else (count.y, count.x)
  in
    { state |
        grid <- renderGrid state cx cy x y []
        }

---

renderMouse: State -> Float -> Float -> List Form -> List Form
renderMouse state w h trixels =
  case state.mouseState of
    MouseNone -> trixels
    MouseHover pos -> 
      let (sx, sy) = if state.trixelInfo.mode == Vertical
            then (state.trixelInfo.width, state.trixelInfo.height)
            else (state.trixelInfo.height, state.trixelInfo.width)
          x = ((toFloat (pos.x)) * sx) - state.trixelInfo.extraOffset.x
          y = ((toFloat (pos.y)) * sy) - state.trixelInfo.extraOffset.y
      in 
        (renderTrixel
          (getTrixelOrientation pos.x pos.y state.trixelInfo.mode)
          x y state.trixelInfo.width state.trixelInfo.height
          (\s -> filled red s)) :: trixels
