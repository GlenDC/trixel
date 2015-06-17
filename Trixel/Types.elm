module Trixel.Types where

import Trixel.ColorScheme exposing (ColorScheme)

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Color exposing (Color)

---

type alias IntVec2D = { x: Int, y: Int }
type alias FloatVec2D = { x: Float, y: Float }
type alias Bounds2D = { min: IntVec2D, max: IntVec2D }

---

-- Orientation of a trixel: 2 directions x 2 modes == 4 orientations
type TrixelOrientation =
  Up | Down |   -- used in Vertical Mode
  Left | Right  -- used in Horizontal Mode

-- There are 2 different modes in which we draw trixels
-- The horizontal one gives a more isometric feeling,
-- while the vertical better highlights the triangle in all its glory.
type TrixelMode = Horizontal | Vertical

---

type alias TrixelInfo = {
  bounds: Bounds2D,   -- bounds of workspace
  height: Float,      -- height of a trixel
  width: Float,       -- width of a trixel
  mode: TrixelMode,   -- mode of trixels, defining the layout
  count: IntVec2D,    -- amount of trixels in the grid
  scale: Float,       -- scale of the workspace
  offset: FloatVec2D, -- offset of the workspace
                      -- note that this shouldn't be used when `scale <= 1`
  extraOffset: FloatVec2D -- extra offset
}

---

type alias HtmlDimensions = {
  menu: HtmlDimensionContext,
  footer: HtmlDimensionContext,
  workspace: HtmlDimensionContext
}

---

type alias HtmlInfo = { dimensions: HtmlDimensions }

---

type MouseState = MouseNone | MouseHover FloatVec2D

---

type alias State = {
  trixelInfo: TrixelInfo,
  trixelColor: Color,
  colorScheme: ColorScheme,
  html: HtmlInfo,
  dimensions: FloatVec2D,
  mouseState: MouseState,
  grid: List Form
}

---

type TrixelAction =
  None | Resize FloatVec2D |
  SetMode TrixelMode |
  NewDoc | OpenDoc | SaveDoc | SaveDocAs |
  Scale | SetScale Float |
  GridX | SetGridX Int |
  GridY | SetGridY Int |
  MoveMouse FloatVec2D | MoveOffset FloatVec2D

---

type alias HtmlDimensionContext = {
  w: Float, h: Float,
  m: (Float, Float),
  p: (Float, Float)
}

dimensionContext: Float -> Float -> (Float, Float) -> (Float, Float) -> HtmlDimensionContext
dimensionContext w h (px, py) (mx, my) =
  { w = w - (2 * mx), h = h - (2 * my), p = (px, py), m = (mx, my) }

dimensionContextDummy = dimensionContext 0 0 (0, 0) (0, 0)

toPx: Float -> String
toPx value =
  (toString value) ++ "px"

dimensionToHtml: HtmlDimensionContext -> List (String, String)
dimensionToHtml ctx =
  let (px, py) = ctx.p
      (mx, my) = ctx.m
  in [
    ("width", (toPx ctx.w)),
    ("height", (toPx ctx.h)),
    ("margin", (toPx my) ++ " " ++ (toPx mx)),
    ("padding", (toPx py) ++ " " ++ (toPx px))
  ]
