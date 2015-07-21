module Trixel.Models.Work
  ( WorkSignal
  , mouseButtonsSignal
  , mousePositionSignal
  , mouseWheelSignal
  , keyboardButtonsSignal
  , windowInformationSignal
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
    SetMouseButtons
    signal


mousePositionSignal : Signal TrVector.Vector -> Signal Action
mousePositionSignal signal =
  Signal.map
    SetMousePosition
    signal


mouseWheelSignal : Signal TrVector.Vector -> Signal Action
mouseWheelSignal signal =
  Signal.map
    SetMouseWheel
    signal


keyboardButtonsSignal : Signal Buttons -> Signal Action
keyboardButtonsSignal signal =
  Signal.map
    SetKeyboardButtons
    signal


windowInformationSignal : Signal WindowContext -> Signal Action
windowInformationSignal signal =
  Signal.map
    SetWindowInformation
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

    SetWindowInformation context ->
      { model
        | dimensions <- context.dimensions
        , isFullscreen <- context.fullscreen
      }

    SetState state ->
      { model | state <- state }

    None ->
      model


updateInput : Model -> TrInputModel.Model -> Model
updateInput model inputModel =
  { model | input <- inputModel }