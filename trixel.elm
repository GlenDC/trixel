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

-- fromElement : Element -> Html

-- todo: use proper MVC and make this the main file
-- workspace stuff move to workspace.elm (main function returns html containing the workspace)
-- menu move to menu.elm (main function returns the menu)

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

renderMenu: Float -> Float -> Form
renderMenu w h =
  toForm (collage (round w) (round h) [
    (filled grey (rect w h)),
    (outlined (solid lightGrey) (rect w (h - 2)))
    ])

render : (Int, Int) -> Element
render (x', y') =
  let x = toFloat x'
      y = toFloat y'

      mode = Vertical
      cx = 20
      cy = 20

      menuHeight = clamp 25 50 (y * 0.04)

      (ccx, ccy) = if mode == Vertical then ((cx / 1.5), cy) else (cx, (cy / 1.5))
      (rcx, rcy) = if mode == Vertical then ((cx * 2), cy) else (cx, (cy * 2))

      mx = max ccx ccy

      ts = ((min x (y - menuHeight)) * 0.95) / mx
      w = ts * cx
      h = ts * cy

  in
    collage x' y' [
      (filled darkGrey (rect x y)),                                     -- bg
      (move (0, (y / 2) - (menuHeight / 2)) (renderMenu x menuHeight)), -- menu
      (move (0, (-menuHeight / 2)) (toForm                              -- workspace
        (collage (round (w + ts)) (round (h + ts))
          (renderWorkSpace (round rcx) (round rcy) ts w h mode [])
        )))]
