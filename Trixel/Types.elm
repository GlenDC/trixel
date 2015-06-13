module Trixel.Types where

import Trixel.ColorScheme exposing (ColorScheme)

---

type alias State = {
  cx: Int, cy: Int,
  colorScheme: ColorScheme
}

---

type TrixelAction = None | Resize |
  GridX | SetGridX Int |
  GridY | SetGridY Int

---

type alias DimensionContext = {
  w: Float, h: Float,
  m: (Float, Float),
  p: (Float, Float)
}

dimensionContext: Float -> Float -> (Float, Float) -> (Float, Float) -> DimensionContext
dimensionContext w h (px, py) (mx, my) =
  { w = w - (2 * mx), h = h - (2 * my), p = (px, py), m = (mx, my) }

toPx: Float -> String
toPx value =
  (toString value) ++ "px"

dimensionToHtml: DimensionContext -> List (String, String)
dimensionToHtml ctx =
  let (px, py) = ctx.p
      (mx, my) = ctx.m
  in [
    ("width", (toPx ctx.w)),
    ("height", (toPx ctx.h)),
    ("margin", (toPx my) ++ " " ++ (toPx mx)),
    ("padding", (toPx py) ++ " " ++ (toPx px))
  ]
