module Trixel.Main where

import Trixel.Types.Mouse as TrMouse
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Types.Input as TrInput

import Trixel.Math.Vector as TrVector

import Trixel.Models.Footer as TrFooterModel
import Trixel.Models.Dom as TrDomModel
import Trixel.Models.Model as TrModel
import Trixel.Models.Work as TrWorkModel

import Trixel.Views.View as TrView

import Window


-- Incoming Javascript Ports
port setMouseButtonsDown : Signal TrInput.Buttons
port setMousePosition : Signal TrVector.Vector
port setMouseWheel : Signal TrVector.Vector
port setKeyboardButtonsDown : Signal TrInput.Buttons

port setWindowSizeManual : Signal TrVector.Vector


-- Outgoing Javascript Ports
port updateEditor : Signal TrDomModel.Model
port updateEditor =
  Signal.map
    (\model -> model.dom)
    signal


setWindowDimensions : Signal TrVector.Vector
setWindowDimensions =
  (Signal.map
    (\(x, y) -> 
      TrVector.construct (toFloat x) (toFloat y))
    Window.dimensions)
  |> Signal.merge setWindowSizeManual


-- Work Signal
workSignal : TrModel.ModelSignal
workSignal =
  let workMailbox = TrWorkModel.mailbox
  in
    Signal.mergeMany
      [ TrWorkModel.mouseButtonsSignal setMouseButtonsDown
      , TrWorkModel.mousePositionSignal setMousePosition
      , TrWorkModel.keyboardButtonsSignal setKeyboardButtonsDown
      , TrWorkModel.mouseWheelSignal setMouseWheel
      , TrWorkModel.windowDimensionsSignal setWindowDimensions
      , workMailbox.signal
      ]
    |> Signal.foldp TrWorkModel.update TrWorkModel.initialModel
    |> Signal.map (\work -> TrModel.UpdateWork work)


-- Footer Signal
footerSignal : TrModel.ModelSignal
footerSignal =
  Signal.map
    (\footer -> TrModel.UpdateFooter footer)
    TrFooterModel.signal


-- Main Signal
signal : Signal TrModel.Model
signal =
  Signal.mergeMany
    [ workSignal
    , footerSignal
    , TrModel.signal
    ]
  |> Signal.foldp
    TrModel.update
    TrModel.initialModel


-- Main Function
main =
  Signal.map
    TrView.view
    signal