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

-- All info needed to draw the trixel-workspace
-- is stored within this rcord
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

-- The dimensions of the different zones of the editor
type alias HtmlDimensions = {
  menu: HtmlDimensionContext,
  footer: HtmlDimensionContext,
  workspace: HtmlDimensionContext
}

---

type alias HtmlInfo = { dimensions: HtmlDimensions }

---

-- Current Mouse State defines wether or not we
-- have to draw a mouse-action-preview within the workspace
type MouseState = MouseNone | MouseHover IntVec2D

---

-- Defining the current condition of the workspace
-- and optionally a message giving a more detailed context.
type Condition = CIdle | CActive Message
type Message = MsgEmpty | MsgString String

---

-- The entire editor state
-- Not sure if it's a good idea to have so much as a state, being passed around
-- We might want to check if there are options to store some stuff somewhere else
type alias State = {
  trixelInfo: TrixelInfo,
  trixelColor: Color,
  colorScheme: ColorScheme,
  html: HtmlInfo,
  dimensions: FloatVec2D,
  mouseState: MouseState,
  grid: List Form,
  condition: Condition
}

-- Possible UserActions:
-- All signals get translated into a TrixelAction,
-- which then goes to the global update-case to handle it appropriatly
type TrixelAction =
    None -- no action
    -- Resizing the main window
  | Resize FloatVec2D
    -- Setting the mode to either Horizontal or Vertical Mode
  | SetMode TrixelMode
    -- This will either be an idle state
    -- or an active state with optionally a context
  | SetCondition Condition
    -- Creating, opening, saving or saving the current trixel format
  | NewDoc
  | OpenDoc
  | SaveDoc
    -- Scaling the workspace
  | Scale -- used internally within Trixel.Menu
  | SetScale Float
    -- Set the x-count for the grid of the workspace
  | GridX
  | SetGridX Int -- used internally within Trixel.Menu
    -- Set the y-count for the grid of the workspace
  | GridY
  | SetGridY Int -- used internally within Trixel.Menu
    -- Moving the cursor
  | MoveMouse FloatVec2D
    -- Moving the offset of the workspace (only possible when zoomed-in)
  | MoveOffset FloatVec2D

---

type alias HtmlDimensionContext = {
  w: Float, h: Float,
  m: FloatVec2D,
  p: FloatVec2D
}

dimensionContext: Float -> Float -> Float -> Float -> Float -> Float -> HtmlDimensionContext
dimensionContext w h px py mx my =
  { w = w, h = h, p = { x = px, y = py }, m = { x = mx, y = my } }

dimensionContextDummy = dimensionContext 0 0 0 0 0 0

pxFromFloat: Float -> String
pxFromFloat value =
  (toString value) ++ "px"

pxFromVector: FloatVec2D -> String
pxFromVector vec =
  (pxFromFloat vec.y) ++ " " ++ (pxFromFloat vec.x)

dimensionToHtml: HtmlDimensionContext -> List (String, String)
dimensionToHtml ctx =
  [
    ("width", (pxFromFloat ctx.w)),
    ("height", (pxFromFloat ctx.h)),
    ("margin", (pxFromVector ctx.m)),
    ("padding", (pxFromVector ctx.p))
  ]

createConditionMessage: Condition -> String
createConditionMessage condition =
  case condition of
    CIdle -> "idle"
    CActive msg ->
      case msg of
        MsgEmpty -> "active"
        MsgString str -> "active: " ++ str

calculateDimensionsFromBounds: Bounds2D -> FloatVec2D
calculateDimensionsFromBounds bounds =
  { x = bounds.max.x - bounds.min.x |> toFloat,
    y = bounds.max.y - bounds.min.y |> toFloat }