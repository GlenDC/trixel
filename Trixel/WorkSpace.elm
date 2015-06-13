module Trixel.WorkSpace where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Types exposing (..)

import Html exposing (Html, Attribute, div, fromElement)
import Html.Attributes exposing (style)
import Signal exposing (Address)

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

view: Address TrixelAction -> DimensionContext -> State -> Html
view address ctx state =
  div [ createMainStyle ctx state ] [
    viewWorkSpace ctx.w ctx.h state
  ]

createMainStyle: DimensionContext -> State -> Attribute
createMainStyle ctx state  =
  style ((dimensionToHtml ctx) ++ [
    ("box-sizing", "inherit"),
    ("border", "1px solid white")
  ])

---

weirdify: Float -> Float -> Float
weirdify coordinate offset =
  coordinate - (offset / 2)

renderTriangle: Float -> Float -> Float -> Float -> Float -> Float -> Shape
renderTriangle x y x' y' x'' y'' =
  polygon [ (x, y), (x', y'), (x'', y'') ]

renderTrixel: TrixelOrientation -> Float -> Float -> Float -> Form
renderTrixel orientation x y size =
  let trixel = case orientation of
    Up -> renderTriangle x y (x + (size / 2)) (y + size) (x + size) y
    Down -> renderTriangle x (y + size) (x + (size / 2)) y (x + size) (y + size)
    Left -> renderTriangle x y x (y + size) (x + size) (y + (size / 2))
    Right -> renderTriangle x (y + (size / 2)) (x + size) (y + size) (x + size) y
  in outlined (solid grey) trixel

getTrixelOrientation: Int -> Int -> TrixelMode -> TrixelOrientation
getTrixelOrientation x y mode =
  if (x + y) % 2 == 0 then
    if mode == Horizontal then Left else Down
  else
    if mode == Horizontal then Right else Up

getSizePairFromTrixelMode: Float -> TrixelMode -> (Float, Float)
getSizePairFromTrixelMode size mode =
  if mode == Horizontal then (size, (size /2)) else ((size / 2), size)

getCoordinateFromIndex: Int -> Float -> Float -> Float
getCoordinateFromIndex c ts ws =
  weirdify (((toFloat c) - 1) * ts) ws

renderTrixelRow: Int -> Int -> Float -> Float -> Float -> TrixelMode -> List Form -> List Form
renderTrixelRow cx cy size w h mode trixels =
  if cx == 0 then trixels else
    let (xs, ys) = getSizePairFromTrixelMode size mode
        x = getCoordinateFromIndex cx xs w
        y = getCoordinateFromIndex cy ys h
    in
      (renderTrixel (getTrixelOrientation cx cy mode) x y size) :: trixels
        |> renderTrixelRow (cx - 1) cy size w h mode

renderWorkSpace: Int -> Int -> Float -> Float -> Float -> TrixelMode -> List Form -> List Form
renderWorkSpace cx cy size w h mode trixels =
  if cy == 0 then trixels else
    renderTrixelRow cx cy size w h mode trixels
      |> renderWorkSpace cx (cy - 1) size w h mode

viewWorkSpace : Float -> Float -> State -> Html
viewWorkSpace x y state =
  let mode = Vertical

      (cx, cy) = (toFloat state.cx, toFloat state.cy)

      (ccx, ccy) =
        if mode == Vertical
          then ((cx / 1.5), cy)
          else (cx, (cy / 1.5))
      (rcx, rcy) =
        if mode == Vertical
          then ((cx * 2), cy)
          else (cx, (cy * 2))

      mx = max ccx ccy

      ts = ((min x y) * 0.95) / mx
      w = ts * cx
      h = ts * cy
  in
    collage (round x) (round y) [
      (toForm
        (collage (round (w + ts)) (round (h + ts))
          (renderWorkSpace (round rcx) (round rcy) ts w h mode [])
        ))]
      |> fromElement
