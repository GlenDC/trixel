module Trixel.Models.Update.Shortcuts (update) where

import Trixel.Models.Work.Model as TrWorkModel

import Trixel.Types.State as TrState
import Trixel.Types.Input as TrInput
import Trixel.Types.Keyboard as TrKeyboard


updateWorkspace : TrWorkModel.Model -> TrWorkModel.Model
updateWorkspace model =
  model


updateContextMenuOptionKeys : TrInput.Buttons -> Maybe TrState.State
updateContextMenuOptionKeys buttons =
   if | TrInput.containsButton TrKeyboard.o buttons ->
          Maybe.Just TrState.Open

      | TrInput.containsButton TrKeyboard.n buttons ->
          Maybe.Just TrState.New

      | TrInput.containsButton TrKeyboard.i buttons ->
          Maybe.Just TrState.Help

      | TrInput.containsButton TrKeyboard.p buttons ->
          Maybe.Just TrState.Settings

      | otherwise ->
          Nothing


updateCommon : TrWorkModel.Model -> TrWorkModel.Model
updateCommon model =
  if | TrInput.containsButton
         TrKeyboard.alt
         model.input.keyboard.down ->
       case updateContextMenuOptionKeys model.input.keyboard.pressed of
         Maybe.Nothing -> model
         Maybe.Just newState -> { model | state <- newState }

     | otherwise ->
          model


updateContextMenu : TrWorkModel.Model -> TrWorkModel.Model
updateContextMenu model =
  if | TrInput.containsButton
          TrKeyboard.c
          model.input.keyboard.pressed ->
        { model | state <- TrState.Default }

      | otherwise ->
          model


update : TrWorkModel.Model -> TrWorkModel.Model
update model =
  ( case model.state of
      TrState.Default ->
        updateWorkspace model

      _ ->
        updateContextMenu model
  ) |> updateCommon
