module Trixel.Views.Context.Toolbar (view) where

import Trixel.Models.Model as TrModel
import Trixel.Types.Layout as TrLayout

import Graphics.Element as Element
import Math.Vector2 as Vector

import Trixel.Views.Context.Toolbar.Horizontal as TrHorizontalToolbar
import Trixel.Views.Context.Toolbar.Vertical as TrVerticalToolbar



view : Vector.Vec2 -> Vector.Vec2 -> TrLayout.Type -> TrModel.Model -> Element.Element
view dimensions elementDimensions layout model =
  case layout of
    TrLayout.Horizontal ->
      TrHorizontalToolbar.view dimensions elementDimensions model

    TrLayout.Vertical ->
      TrVerticalToolbar.view dimensions model