module Trixel.Main where

import Trixel.Types.Mouse as TrMouse
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Types.Input exposing (..)
import Trixel.Math.Vector exposing (Vector)
import Trixel.Models.Model as TrModel

-- Incoming Javascript Ports
port setMouseButtonsDown : Signal Buttons
port setKeyboardButtonsDown : Signal Buttons
port setMouseWheel : Signal Vector
port setMousePosition : Signal Vector

port setWindowSizeManual : Signal Vector


-- Outgoing Javascript Ports
port updateEditor : TrModel.ModelSignal
port updateEditor =
  mainSignal


-- Main Update Signal
mainSignal : TrModel.ModelSignal
mainSignal =
  Signal.foldp
    TrModel.update
    TrModel.initialModel
    (Signal.constant TrModel.initialModel)


-- Main Signal
main : TrModel.MainSignal
main =
  Signal.map
    TrModel.view
    mainSignal