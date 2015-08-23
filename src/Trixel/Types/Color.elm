module Trixel.Types.Color where

import Trixel.Math.Float as TrFloat
import Color exposing (Color)


red : RgbaColor
red =
  construct 255 0 0 1

green : RgbaColor
green =
  construct 0 255 0 1

blue : RgbaColor
blue =
  construct 0 0 255 1


initialColor : RgbaColor
initialColor =
  construct 0 0 0 0


construct : Int -> Int -> Int -> Float -> RgbaColor
construct red green blue alpha =
  { red = red
  , green = green
  , blue = blue
  , alpha = alpha
  }


isEqual : RgbaColor -> RgbaColor -> Bool
isEqual a b =
  (a.red == b.red)
  && (a.green == b.green)
  && (a.blue == b.blue)
  && (TrFloat.isEqual a.alpha b.alpha)


isNotEqual : RgbaColor -> RgbaColor -> Bool
isNotEqual a b =
  isEqual a b
  |> not


computeAlphaBlend : RgbaColor -> RgbaColor -> RgbaColor
computeAlphaBlend a b =
  let resultAlpha =
        a.alpha + (1 - a.alpha) * b.alpha

      alphaBlendValue valueA' valueB' =
        let valueA = toFloat valueA'
            valueB = toFloat valueB'
        in
          ((b.alpha * valueB) + ((1 - b.alpha) * valueA))
          |> round
  in
    construct
      (alphaBlendValue a.red b.red)
      (alphaBlendValue a.green b.green)
      (alphaBlendValue a.blue b.blue)
      (resultAlpha)


toColor : RgbaColor -> Color
toColor color =
  Color.rgba
    color.red
    color.green
    color.blue
    color.alpha


toString : RgbaColor -> String
toString color =
  "rgba("
    ++ (Basics.toString color.red)
    ++ ","
    ++ (Basics.toString color.green)
    ++ ","
    ++ (Basics.toString color.blue)
    ++ ","
    ++ (Basics.toString color.alpha)
    ++ ")"


type alias RgbaColor =
  { red : Int
  , green : Int
  , blue : Int
  , alpha : Float
  }
