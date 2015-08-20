module Trixel.Views.View (view) where

import Math.Vector2 as Vector
import Html

import Trixel.Types.Color as TrColor
import Trixel.Models.Model as TrModel
import Trixel.Types.Layout as TrLayout

import Trixel.Views.Footer as TrFooterView
import Trixel.Views.Menu as TrMenuView


view : TrModel.Model -> Html.Html
view model =
  let y = Vector.getY model.work.dimensions
  in
    TrLayout.group
      TrLayout.column
      TrLayout.noWrap
      []
      [ (0, TrMenuView.view (max (y * 0.03) 35) model)
      , (1, TrLayout.dummy TrColor.blue)
      , (0, TrFooterView.view (max (y * 0.025) 30) model)
      ]
    |> TrLayout.extend (TrLayout.background model.colorScheme.primary.main.fill)
    |> TrLayout.root
