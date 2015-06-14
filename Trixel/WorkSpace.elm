module Trixel.WorkSpace where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Types exposing (..)

import Html exposing (Html, Attribute, div, fromElement)
import Html.Attributes exposing (style)
import Signal exposing (Address)

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

import Debug

view: Address TrixelAction -> DimensionContext -> State -> Html
view address ctx state =
  div [ createMainStyle ctx state ] [
    viewWorkSpace ctx.w ctx.h state
  ]

createMainStyle: DimensionContext -> State -> Attribute
createMainStyle ctx state  =
  style ((dimensionToHtml ctx) ++ [
    ("box-sizing", "inherit")
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

viewWorkSpace : Float -> Float -> State -> Html
viewWorkSpace x y state =
  let (x', y') = ((round x), (round y))
      (cx, cy) = (toFloat state.cx, toFloat state.cy)

      (cx', cy') = ((getCountX cx state.mode), (getCountY cy state.mode))
      ts = if x / cx' * cy' > y then
        (y / cy') else (x / cx')
  in
    collage x' y'
      (renderWorkSpace state.cx state.cy ts (ts * cx') (ts * cy')
        state.mode [])
      |> container x' y' middle |> fromElement
