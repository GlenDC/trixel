module Trixel.Types.Vector where

import Math.Vector2 as Vector


toNativeVector : Vector.Vec2 -> Vector
toNativeVector vec =
  let (x, y) = Vector.toTuple vec
  in Vector x y


type alias Vector =
  { x : Float
  , y : Float
  }