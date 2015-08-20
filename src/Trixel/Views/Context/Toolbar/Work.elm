module Trixel.Views.Context.Toolbar.Work (view) where

import Trixel.Models.Model as TrModel

import Trixel.Types.Layout as TrLayout


view : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
view model mode =
  TrLayout.empty
