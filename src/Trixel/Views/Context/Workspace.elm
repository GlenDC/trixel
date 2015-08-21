module Trixel.Views.Context.Workspace (view) where

import Trixel.Models.Model as TrModel

import Trixel.Types.State as TrState
import Trixel.Types.Layout as TrLayout


viewEditor : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewEditor model mode =
  TrLayout.empty


viewHelp : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewHelp model mode =
  TrLayout.empty


viewAbout : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewAbout model mode =
  TrLayout.empty


viewSettings : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewSettings model mode =
  TrLayout.empty


view : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
view model mode =
  let viewFunction =
        case model.work.state of
          TrState.Default -> viewEditor
          TrState.Help -> viewHelp
          TrState.About -> viewAbout
          TrState.Settings -> viewSettings
          _ -> (\ a b -> TrLayout.empty)
  in
    TrLayout.equalGroup
      TrLayout.row
      TrLayout.wrap
      []
      [ viewFunction model mode ]