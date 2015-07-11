module Trixel.Math.Vector where


zeroVector : Vector
zeroVector =
  constructVector 0 0


negativeUnitVector : Vector
negativeUnitVector =
  constructVector -1 -1


unitVector : Vector
unitVector =
  constructVector 1 1


addVectors : Vector -> Vector -> Vector
addVectors a b =
  computeVectorOperation (+) a b


substractVectors : Vector -> Vector -> Vector
substractVectors a b =
  computeVectorOperation (-) a b


computeVectorOperation : (Float -> Float -> Float) -> Vector -> Vector -> Vector
computeVectorOperation operation a b =
  { x = operation a.x b.x
  , y = operation a.y b.y
  }


computeVectorElementOperation : (Float -> Float -> Float) -> Vector -> Float -> Vector
computeVectorElementOperation operation a value =
  { x = operation a.x value
  , y = operation a.y value
  }


computeVectorLength : Vector -> Float
computeVectorLength vector =
  (vector.x ^ 2) + (vector.y ^ 2)
  |> sqrt


computeDotProduct : Vector -> Vector -> Float
computeDotProduct a b =
  (a.x * b.x) + (a.y * a.y)


constructVector : Float -> Float -> Vector
constructVector x y =
  { x = x
  , y = y
  }


type alias Vector =
  { x : Float
  , y : Float
  }