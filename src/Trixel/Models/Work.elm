module Trixel.Models.Work
  ( initialModel
  , Model
  , WorkSignal
  , mouseButtonsSignal
  , mousePositionSignal
  , mouseWheelSignal
  , keyboardButtonsSignal
  , windowDimensionsSignal
  , mailbox
  , update
  , computeTitle
  )
  where

import Trixel.Models.Work.Document as TrDocument
import Trixel.Models.Work.Input as TrInput
import Trixel.Models.Work.Actions exposing (..)

import Trixel.Types.Input exposing (Buttons)
import Trixel.Math.Vector as TrVector

import Signal exposing (Signal)

import Debug


initialModel : Model
initialModel =
  { unsavedProgress = True
  , document = TrDocument.initialModel
  , input = TrInput.initialModel
  , dimensions = TrVector.zeroVector
  }


type alias Model =
  { unsavedProgress : Bool
  , document : TrDocument.Model
  , input : TrInput.Model
  , dimensions : TrVector.Vector
  }


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


computeTitle : Model -> String
computeTitle model =
  let title =
        TrDocument.computeFileName
          model.document
  in
    if model.unsavedProgress
      then title ++ " *"
      else title


mailbox : Signal.Mailbox Action
mailbox =
  Signal.mailbox None


update : Action -> Model -> Model
update action model =
  case action of
    SetMouseWheel wheel ->
      TrInput.setMouseWheel wheel model.input
      |> updateInput model

    SetMousePosition position ->
      TrInput.setMousePosition position model.input
      |> updateInput model

    SetMouseButtons buttons ->
      TrInput.setMouseButtons buttons model.input
      |> updateInput model

    SetKeyboardButtons buttons ->
      TrInput.setKeyboardButtons buttons model.input
      |> updateInput model

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


updateInput : Model -> TrInput.Model -> Model
updateInput model inputModel =
  { model | input <- inputModel }