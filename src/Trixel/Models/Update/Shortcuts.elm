module Trixel.Models.Update.Shortcuts (update) where

import Trixel.Models.Work.Model as TrWorkModel

import Trixel.Types.Layout.UserActions as TrUserActions

import Trixel.Types.State as TrState


updateWorkspace : TrWorkModel.Model -> TrWorkModel.Model
updateWorkspace model =
  model


applyShortcuts : TrWorkModel.Model -> TrUserActions.UserActions -> TrWorkModel.Model
applyShortcuts model userActions =
  List.foldl
    (\userAction model ->
      TrUserActions.applyShortcut userAction model
      )
    model
    userActions


updateCommon : TrWorkModel.Model -> TrWorkModel.Model
updateCommon model =
  applyShortcuts
    model
    [ TrUserActions.gotoOpen
    , TrUserActions.gotoNew
    , TrUserActions.gotoHelp
    , TrUserActions.gotoSettings
    ]


updateContextMenu : TrWorkModel.Model -> TrWorkModel.Model
updateContextMenu model =
  applyShortcuts
    model
    [ TrUserActions.close
    ]


update : TrWorkModel.Model -> TrWorkModel.Model
update model =
  ( case model.state of
      TrState.Default ->
        updateWorkspace model

      _ ->
        updateContextMenu model
  ) |> updateCommon
