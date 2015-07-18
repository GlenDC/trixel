module Trixel.Models.Update.Shortcuts (update) where

import Trixel.Models.Work.Model as TrWorkModel

import Trixel.Types.State as TrState
import Trixel.Types.Input as TrInput
import Trixel.Types.Keyboard as TrKeyboard

import Debug

updateWorkspace : TrWorkModel.Model -> TrWorkModel.Model
updateWorkspace model =
  model


updateContextMenu : TrWorkModel.Model -> TrWorkModel.Model
updateContextMenu model =
  if | TrInput.containsButton
          TrKeyboard.escape
          (Debug.log "pressed: " model.input.keyboard.pressed) ->
        { model | state <- TrState.Default }



update : TrWorkModel.Model -> TrWorkModel.Model
update model =
  case model.state of
    TrState.Default ->
      updateWorkspace model

    _ ->
      updateContextMenu model