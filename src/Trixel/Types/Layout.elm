module Trixel.Types.Layout where

import Math.Vector2 as Vector


type Type
  = Horizontal
  | Vertical


computeType : Vector.Vec2 -> Type
computeType dimensions =
  if (Vector.getX dimensions) <= 970
    then Vertical
    else Horizontal