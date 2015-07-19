module Trixel.Models.Work
  ( WorkSignal
  , mouseButtonsSignal
  , mousePositionSignal
  , mouseWheelSignal
  , keyboardButtonsSignal
  , windowDimensionsSignal
  , mailbox
  , address
  , update
  )
  where

import Trixel.Models.Work.Input as TrInputModel
import Trixel.Models.Work.Actions exposing (..)
import Trixel.Models.Work.Model exposing (..)

import Trixel.Models.Update.Shortcuts as TrShortcuts

import Trixel.Types.State as TrState
import Trixel.Types.Input exposing (Buttons)
import Trixel.Math.Vector as TrVector

import Signal exposing (Signal)


type alias WorkSignal = Signal Model 


mouseButtonsSignal : Signal Buttons -> Signal Action
mouseButtonsSignal signal =
  Signal.map
    (\buttons -> SetMouseButtons buttons)
    signal


mousePositionSignal : Signal TrVector.Vector -> Signal Action
mousePositionSignal signal =
  Signal.map
    (\position -> SetMousePosition position)
    signal


mouseWheelSignal : Signal TrVector.Vector -> Signal Action
mouseWheelSignal signal =
  Signal.map
    (\wheel -> SetMouseWheel wheel)
    signal


keyboardButtonsSignal : Signal Buttons -> Signal Action
keyboardButtonsSignal signal =
  Signal.map
    (\buttons -> SetKeyboardButtons buttons)
    signal


windowDimensionsSignal : Signal TrVector.Vector -> Signal Action
windowDimensionsSignal signal =
  Signal.map
    (\dimensions -> SetWindowDimensions dimensions)
    signal


mailbox : Signal.Mailbox Action
mailbox =
  Signal.mailbox None


address =
  mailbox.address


update : Action -> Model -> Model
update action model =
  case action of
    SetMouseWheel wheel ->
      TrInputModel.setMouseWheel wheel model.input
      |> updateInput model

    SetMousePosition position ->
      TrInputModel.setMousePosition position model.input
      |> updateInput model

    SetMouseButtons buttons ->
      TrInputModel.setMouseButtons buttons model.input
      |> updateInput model

    SetKeyboardButtons buttons ->
      TrInputModel.setKeyboardButtons buttons model.input
      |> updateInput model
      |> TrShortcuts.update

    Undo ->
      model -- todo

    Redo ->
      model -- todo

    Reset ->
      model -- todo

    SetGridVisibility isVisible ->
      model -- todo

    MoveOffset move ->
      model -- todo

    SetOffset position ->
      model -- todo

    SetWindowDimensions dimensions ->
      { model | dimensions <- dimensions }

    SetState state ->
      { model | state <- state }

    None ->
      model


updateInput : Model -> TrInputModel.Model -> Model
updateInput model inputModel =
  { model | input <- inputModel }