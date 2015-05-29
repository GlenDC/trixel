module Trixel where

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Window
  
main : Signal Element
main =
  Signal.map render Window.dimensions

renderGridLine : Float -> Float -> Float -> Float -> Form
renderGridLine ax ay bx by =
  traced (solid grey) (path ([(ax, ay), (bx, by)]))

renderGridLines : Float -> Float -> Int -> (Float -> Float -> Form) -> List Form
renderGridLines gridsz cellsz i renderLine =
  if i == 0 then [] else
    let j = i - 1
        pos = j * cellsz 
    in (renderLine pos gridsz) :: (renderGridLines gridsz cellsz j renderLine)

renderGrid : Float -> Float -> Int -> Int -> Int -> Element
renderGrid gridsz cellsz gx gy padding =
  let renderHor = \pos sz -> renderGridLine pos 0.0 pos sz 
      renderVer = \pos sz -> renderGridLine 0.0 pos sz pos
      grid = (renderGridLines gridsz cellsz gy renderHor) ++
        (renderGridLines gridsz cellsz gx renderVer)
      collagesz = (round gridsz) + (padding * 2)
      trans = negate (gridsz / 2.0)
  in
    grid
      |> List.map (\x -> move (trans, trans) x)
      |> collage collagesz collagesz

render : (Int, Int) -> Element
render (x, y) =
  let padding = 50
      sz = toFloat ((min x y) - (padding*2))
      cx = 5
      ccx = sz / cx
  in renderGrid sz ccx (cx+1) (cx+1) 50
