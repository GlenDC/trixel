module Trixel where

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Window

main : Signal Element
main =
  Signal.map render Window.dimensions

type TrixelOrientation = Up | Down | Left | Right
type TrixelMode = Horizontal | Vertical

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

render : (Int, Int) -> Element
render (x', y') =
  let x = toFloat x'
      y = toFloat y'

      w = (min x y) - 50
      h = w

      cx = 15
      cy = 8
      trixelSize = w / cy
  in
    collage x' y' [
      (filled darkGrey (rect x y)),
      (toForm
        (collage (round (w + 2)) (round (h + 2))
          (renderWorkSpace cx cy trixelSize w h Vertical [])
        ))]
