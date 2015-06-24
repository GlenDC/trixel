module Trixel.Types.General where

import Trixel.Types.ColorScheme exposing (ColorScheme)
import Trixel.Types.Layer exposing (TrixelLayers, LayerPosition)
import Trixel.Types.Math exposing (..)
import Trixel.Types.Html exposing (..)

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Color exposing (Color)
import Signal exposing (Signal, Address, Mailbox, mailbox)


actionQuery : Mailbox TrixelAction
actionQuery = mailbox None


computeConditionString : Condition -> String
computeConditionString condition =
  case condition of
    IdleCondition
      -> "idle"

    ActiveCondition message
      -> case message of
        EmptyMessage
          -> "active"

        StringMessage string
          -> "active: " ++ string


-- Orientation of a trixel: 2 directions x 2 modes == 4 orientations
type TrixelOrientation
  = Up -- used in Vertical Mode
  | Down
  | Left -- used in Horizontal Mode
  | Right


-- There are 2 different modes in which we draw trixels
-- The horizontal one gives a more isometric feeling,
-- while the vertical better highlights the triangle in all its glory.
type TrixelMode
  = Horizontal
  | Vertical


-- All info needed to draw the trixel-workspace
-- is stored within this rcord
type alias TrixelInfo =
  { bounds : Bounds -- bounds of workspace
  , height : Float -- height of a trixel
  , width : Float -- width of a trixel
  , mode : TrixelMode -- mode of trixels, defining the layout
  , count : Vector -- amount of trixels in the grid
  , scale : Float -- scale of the workspace
  , offset : Vector -- offset of the workspace, not used when .scale <= 1
  , extraOffset : Vector -- extra offset
  , dimensions : Vector -- dimensions of the grid
  }


-- The Box Models for all the main zones of the editor
type alias EditorBoxModels =
  { menu : BoxModel
  , footer : BoxModel
  , workspace : BoxModel
  }


-- Current Mouse State defines wether or not we
-- have to draw a mouse-action-preview within the workspace
type MouseState
  = MouseNone
  | MouseHover Vector


-- Defining the current condition of the workspace
-- and optionally a message giving a more detailed context.

type Condition
  = IdleCondition
  | ActiveCondition Message


type Message
  = EmptyMessage
  | StringMessage String


type alias WorkSpaceActions =
  { isBrushActive : Bool
  , isErasing : Bool
  }


type alias RenderCache =
  { grid : List Form
  , layers : List Form
  }


type alias WorkState =
  { lastMousePosition : Vector
  , lastErasePosition : Vector
  , lastPaintPosition : Vector
  }


cleanWorkState : WorkState
cleanWorkState =
  { lastMousePosition = negativeUnitVector
  , lastErasePosition = negativeUnitVector
  , lastPaintPosition = negativeUnitVector
  }


-- The entire editor state
-- Not sure if it's a good idea to have so much as a state, being passed around
-- We might want to check if there are options to store some stuff somewhere else
type alias State =
  { trixelInfo : TrixelInfo
  , trixelColor : Color
  , colorScheme : ColorScheme
  , boxModels : EditorBoxModels
  , windowDimensions : Vector
  , mouseState : MouseState
  , renderCache : RenderCache
  , condition : Condition
  , actions : WorkSpaceActions
  , workState : WorkState
  , layers : TrixelLayers
  , currentLayer : LayerPosition
  }


type alias PostOfficeState =
  { active : Bool
  , action : TrixelAction
  }


-- All Possible UserActions.
-- The used signals get translated into a TrixelAction,
-- which then goes to the global update-case to handle it appropriatly
type TrixelAction
  = None -- no action
  | ResizeWindow Vector -- Resizing the main window
  | SetMode TrixelMode -- Setting the mode to either Horizontal or Vertical Mode
  | SetCondition Condition -- This will either be an idle state or an active state with optionally a context
  | NewDocument -- Start of the process to create a new document
  | OpenDocument -- Start of the process to open an existing document
  | SaveDocument -- Start of the process to save the current document
  | SetScale Float -- setting the scale of the workspace
  | SetGridX Float -- Set the x-count for the grid of the workspace
  | SetGridY Float -- Set the y-count for the grid of the workspace
  | MoveMouse Vector -- Moving the cursor
  | MoveOffset Vector -- Moving the offset of the workspace (only possible when zoomed-in)
  | SwitchAction PostOfficeState -- used for a filtered post-office action
  | BrushSwitch Bool
  | ErasingSwitch Bool


-- Used to create the correct gui-input for a specific TrixelAction
type TrixelActionInput
  = GridX -- Used to create the input that sets the Grid on the x-axis
  | GridY -- Used to create the input that sets the Grid on the y-axis
  | Scale -- Used to create the scaling input menu


type alias ActionAddress = Address TrixelAction
type alias ActionSignal = Signal TrixelAction