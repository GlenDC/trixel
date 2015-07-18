module Trixel.Math.Vector where

import Trixel.Math.Float as TrFloat


zeroVector : Vector
zeroVector =
  construct 0 0


negativeUnitVector : Vector
negativeUnitVector =
  construct -1 -1


unitVector : Vector
unitVector =
  construct 1 1


add : Vector -> Vector -> Vector
add a b =
  computeOperation (+) a b


substract : Vector -> Vector -> Vector
substract a b =
  computeOperation (-) a b


computeOperation : (Float -> Float -> Float) -> Vector -> Vector -> Vector
computeOperation operation a b =
  { x = operation a.x b.x
  , y = operation a.y b.y
  }


scale : Float -> Vector -> Vector
scale scale vector =
  computeFloatOperation (*) vector scale


computeFloatOperation : (Float -> Float -> Float) -> Vector -> Float -> Vector
computeFloatOperation operation a value =
  { x = operation a.x value
  , y = operation a.y value
  }


computeLength : Vector -> Float
computeLength vector =
  (vector.x ^ 2) + (vector.y ^ 2)
  |> sqrt


computeDotProduct : Vector -> Vector -> Float
computeDotProduct a b =
  (a.x * b.x) + (a.y * a.y)


construct : Float -> Float -> Vector
construct x y =
  { x = x
  , y = y
  }


isEqual : Vector -> Vector -> Bool
isEqual a b =
  (TrFloat.isEqual a.x b.x)
  && (TrFloat.isEqual a.y b.y)


isNotEqual : Vector -> Vector -> Bool
isNotEqual a b =
  isEqual a b
  |> not


type alias Vector =
  { x : Float
  , y : Float
  }