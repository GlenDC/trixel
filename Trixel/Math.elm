module Trixel.Math where


zeroVector : Vector
zeroVector =
  { x = 0
  , y = 0
  }


unitVector : Vector
unitVector =
  { x = 1
  , y = 1
  }

addVectors : Vector -> Vector -> Vector
addVectors a b =
  computeVectorOperation (+) a b


substractVectors : Vector -> Vector -> Vector
substractVectors a b =
  computeVectorOperation (-) a b


computeVectorOperation : (Float -> Float -> Float) -> Vector -> Vector -> Vector
computeVectorOperation operation a b =
  { x = operation a.x a.b
  , y = operation a.x a.b
  }

computeVectorLength : Vector -> Float
computeVectorLength vector =
  (vector.x ^ 2) + (vector.y ^ 2)
    |> sqrt


type alias Vector =
  { x : Float
  , y : Float
  }


type alias Bounds =
  { min : Vector
  , max : Vector
  }


computeDimensionsFromBounds: Bounds -> Vector
computeDimensionsFromBounds bounds =
  { x = bounds.max.x - bounds.min.x
  , y = bounds.max.y - bounds.min.y
  }