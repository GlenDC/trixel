module Trixel.Models.Work.Actions where

import Trixel.Types.Input as TrInput
import Trixel.Types.State as TrState
import Trixel.Math.Vector as TrVector


-- All action related to the work environment
type Action
  = None
  -- Input Actions
  | SetMouseWheel TrVector.Vector
  | SetMousePosition TrVector.Vector
  | SetMouseButtons TrInput.Buttons
  | SetKeyboardButtons TrInput.Buttons
  -- Undo/Redo
  | Undo
  | Redo
  -- Reset Work Progress
  | Reset
  -- Hide/Show Grid
  | SetGridVisibility Bool
  -- Move/Set Work Offset
  | MoveOffset TrVector.Vector
  | SetOffset TrVector.Vector
  -- Set Editor Window Size
  | SetWindowDimensions TrVector.Vector
  -- Set Editor State
  | SetState TrState.State