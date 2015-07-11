module Trixel.Math.Color where

import Trixel.Types.RgbaColor as TrRgbaColor

import Color exposing (Color)


computeAlphaBlend : Color -> Color -> Color
computeAlphaBlend a b =
  TrRgbaColor.computeAlphaBlend
    (Color.toRgb a)
    (Color.toRgb b)
  |> TrRgbaColor.toColor


compare: Color -> Color -> Bool
compare a b =
  TrRgbaColor.compare
    (Color.toRgb a)
    (Color.toRgb b)