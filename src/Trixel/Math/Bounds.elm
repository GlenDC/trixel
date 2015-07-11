module Trixel.Math.Bounds where

import Trixel.Math.Vector as Vector


zeroBounds : Bounds
zeroBounds =
  constructBounds 0 0 0 0


computeDimensions : Bounds -> Vector.Vector
computeDimensions bounds =
  Vector.substractVectors bounds.max bounds.min


constructBounds : Float -> Float -> Float -> Float -> Bounds
constructBounds minX minY maxX maxY =
  { min = Vector.constructVector minX minY
  , max = Vector.constructVector maxX maxY
  }


type alias Bounds =
  { min : Vector.Vector
  , max : Vector.Vector
  }