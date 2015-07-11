module Trixel.Main where

import Trixel.Types.Mouse as Mouse
import Trixel.Types.Keyboard as Keyboard
import Trixel.Types.Input exposing (..)
import Trixel.Math.Vector exposing (Vector)
import Trixel.Models.Model as Model

-- Incoming Javascript Ports
port setMouseButtonsDown : Signal Buttons
port setKeyboardButtonsDown : Signal Buttons
port setMouseWheel : Signal Vector
port setMousePosition : Signal Vector

port setWindowSizeManual : Signal Vector


-- Outgoing Javascript Ports
port updateEditor : Model.ModelSignal
port updateEditor =
  mainSignal


-- Main Update Signal
mainSignal : Model.ModelSignal
mainSignal =
  Signal.foldp
    Model.update
    Model.initialModel
    (Signal.constant Model.initialModel)


-- Main Signal
main : Model.MainSignal
main =
  Signal.map
    Model.view
    mainSignal