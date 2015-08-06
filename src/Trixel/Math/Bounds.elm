module Trixel.Math.Bounds where

import Math.Vector2 as Vector


zeroBounds : Bounds
zeroBounds =
  construct 0 0 0 0


computeDimensions : Bounds -> Vector.Vec2
computeDimensions bounds =
  Vector.sub bounds.max bounds.min


construct : Float -> Float -> Float -> Float -> Bounds
construct minX minY maxX maxY =
  { min = Vector.vec2 minX minY
  , max = Vector.vec2 maxX maxY
  }


type alias Bounds =
  { min : Vector.Vec2
  , max : Vector.Vec2
  }