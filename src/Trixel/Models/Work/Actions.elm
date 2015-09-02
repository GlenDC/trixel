module Trixel.Models.Work.Actions where

import Trixel.Types.Input as TrInput
import Trixel.Types.State as TrState
import Trixel.Types.Vector as TrVector

import Trixel.Models.Work.Scratch as TrScratch

import Math.Vector2 as Vector


-- All action related to the work environment
type Action
  = None
  -- Input Actions
  | SetMouseWheel Vector.Vec2
  | SetMousePosition Vector.Vec2
  | SetMouseButtons TrInput.Buttons
  | SetKeyboardButtons TrInput.Buttons
  -- Undo/Redo
  | Undo
  | Redo
  -- Reset Work Progress
  | Reset
  -- new-/open-/save-document
  | NewDocument
  | OpenDocument
  | SaveDocument
  -- Hide/Show Grid
  | SetGridVisibility Bool
  -- Move/Set Work Offset
  | MoveOffset Vector.Vec2
  | SetOffset Vector.Vec2
  -- Set Editor Window dimensions and fullscreen state
  | SetWindowInformation WindowContext
  -- Set Editor State
  | SetState TrState.State
  -- Update Scratch
  | SetNewDocScratch TrScratch.DocumentForm


type alias WindowContext =
  { dimensions : TrVector.Vector
  , fullscreen : Bool
  }
