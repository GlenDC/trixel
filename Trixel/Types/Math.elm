module Trixel.Types.Math where

import String

import Color exposing (Color, toRgb, rgba)


zeroVector : Vector
zeroVector =
  constructVector 0 0


negativeUnitVector : Vector
negativeUnitVector =
  constructVector -1 -1


unitVector : Vector
unitVector =
  constructVector 1 1


zeroBounds : Bounds
zeroBounds =
  constructBounds 0 0 0 0


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


computeVectorLength : Vector -> Float
computeVectorLength vector =
  (vector.x ^ 2) + (vector.y ^ 2)
    |> sqrt


constructVector : Float -> Float -> Vector
constructVector x y =
  { x = x
  , y = y
  }


constructBounds : Float -> Float -> Float -> Float -> Bounds
constructBounds minX minY maxX maxY =
  { min = constructVector minX minY
  , max = constructVector maxX maxY
  }


type alias Vector =
  { x : Float
  , y : Float
  }


type alias Bounds =
  { min : Vector
  , max : Vector
  }


computeDimensionsFromBounds : Bounds -> Vector
computeDimensionsFromBounds bounds =
  { x = bounds.max.x - bounds.min.x
  , y = bounds.max.y - bounds.min.y
  }


stringToInt : String -> Int
stringToInt string =
  case (String.toInt string) of
    Ok value -> value
    Err error -> 0


stringToFloat : String -> Float
stringToFloat string =
  case (String.toFloat string) of
    Ok value -> value
    Err error -> 0


computeAlphaBlend : Color -> Color -> Color
computeAlphaBlend a b =
  let colorA =
        toRgb a
      colorB =
        toRgb b

      resultAlpha =
        colorA.alpha + (1 - colorA.alpha) * colorB.alpha

      alphaBlendValue valueA' valueB' =
        let valueA = toFloat valueA'
            valueB = toFloat valueB'
        in
          ((resultAlpha * valueB) + ((1 - resultAlpha) * valueA))
          |> round
  in
    rgba
      (alphaBlendValue colorA.red colorB.red)
      (alphaBlendValue colorA.green colorB.green)
      (alphaBlendValue colorA.blue colorB.blue)
      (resultAlpha)


compareColors: Color -> Color -> Bool
compareColors a b =
  let colorA =
        toRgb a
      colorB =
        toRgb b
  in
    colorA.red == colorB.red
      && colorA.green == colorB.green
      && colorA.blue == colorB.blue
      && abs colorA.alpha - colorB.alpha < 0.01


computeOffsetColor: Int -> Int -> Int -> Float -> Color -> Color
computeOffsetColor red green blue alpha color =
  let rgbaColor =
        toRgb color
  in
    rgba
      (rgbaColor.red + red)
      (rgbaColor.green + green)
      (rgbaColor.blue + blue)
      (rgbaColor.alpha + alpha)
