module Trixel.Views.Context.Toolbar (view) where

import Trixel.Models.Model as TrModel

import Trixel.Types.State as TrState
import Trixel.Types.Layout as TrLayout

import Trixel.Views.Context.Toolbar.Menu as TrMenu
import Trixel.Views.Context.Toolbar.Work as TrWork

view : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
view model mode =
  if model.work.state == TrState.Default
    then TrWork.view model mode
    else TrMenu.view model mode
