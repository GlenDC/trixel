module Trixel.Views.Context (view) where

import Trixel.Models.Model as TrModel
import Trixel.Models.Work.Model as TrWorkModel

import Trixel.Types.Layout as TrLayout
import Trixel.Types.State as TrState

import Trixel.Views.Context.Home as TrHome
import Trixel.Views.Context.Toolbar as TrToolbar
import Trixel.Views.Context.Workspace as TrWorkspace

import Math.Vector2 as Vector


computeMode : TrModel.Model -> TrLayout.Mode
computeMode model =
  if (Vector.getX model.work.dimensions) <= 1080
    then TrLayout.Portrait
    else TrLayout.Landscape


isNotOnHomeScreen : TrModel.Model -> Bool
isNotOnHomeScreen model =
  TrWorkModel.hasDocument model.work || model.work.state /= TrState.Default


viewContext : TrModel.Model -> TrLayout.Generator
viewContext model =
  let mode = computeMode model
      flow =
        case mode of
          TrLayout.Portrait -> TrLayout.column
          TrLayout.Landscape -> TrLayout.row
  in
    TrLayout.group
      flow
      TrLayout.noWrap
      []
      [ (0, TrToolbar.view model mode)
      , (1, TrWorkspace.view model mode)
      ]


view : TrModel.Model -> TrLayout.Generator
view model =
  if isNotOnHomeScreen model
    then viewContext model
    else TrHome.view model
