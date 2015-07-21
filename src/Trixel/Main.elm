module Trixel.Main where

import Trixel.Types.Mouse as TrMouse
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Types.Input as TrInput

import Trixel.Math.Vector as TrVector

import Trixel.Models.Dom as TrDomModel
import Trixel.Models.Model as TrModel
import Trixel.Models.Work as TrWork
import Trixel.Models.Work.Actions as TrWorkActions
import Trixel.Models.Work.Model as TrWorkModel

import Trixel.Views.View as TrView


-- Incoming Javascript Ports
port setMouseButtonsDown : Signal TrInput.Buttons
port setMousePosition : Signal TrVector.Vector
port setMouseWheel : Signal TrVector.Vector
port setKeyboardButtonsDown : Signal TrInput.Buttons

port setWindowInformation : Signal TrWorkActions.WindowContext


-- Outgoing Javascript Ports
port updateEditor : Signal TrDomModel.Model
port updateEditor =
  Signal.map
    (\model -> model.dom)
    signal


-- Work Signal
workSignal : TrModel.ModelSignal
workSignal =
  let workMailbox = TrWork.mailbox
  in
    Signal.mergeMany
      [ TrWork.mouseButtonsSignal setMouseButtonsDown
      , TrWork.mousePositionSignal setMousePosition
      , TrWork.keyboardButtonsSignal setKeyboardButtonsDown
      , TrWork.mouseWheelSignal setMouseWheel
      , TrWork.windowInformationSignal setWindowInformation
      , workMailbox.signal
      ]
    |> Signal.foldp TrWork.update TrWorkModel.initialModel
    |> Signal.map (\work -> TrModel.UpdateWork work)


-- Main Signal
signal : Signal TrModel.Model
signal =
  Signal.mergeMany
    [ workSignal
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