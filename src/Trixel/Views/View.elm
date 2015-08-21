module Trixel.Views.View (view) where

import Math.Vector2 as Vector
import Html

import Trixel.Types.Color as TrColor
import Trixel.Models.Model as TrModel
import Trixel.Types.Layout as TrLayout

import Trixel.Views.Menu as TrMenuView
import Trixel.Views.Context as TrContext
import Trixel.Views.Footer as TrFooterView


view : TrModel.Model -> Html.Html
view model =
  let y = Vector.getY model.work.dimensions
  in
    TrLayout.group
      TrLayout.column
      TrLayout.noWrap
      []
      [ (0, TrMenuView.view (min (max (y * 0.03) 30) 80) model)
      , (1, TrContext.view model)
      , (0, TrFooterView.view (min (max (y * 0.025) 28) 70) model)
      ]
    |> TrLayout.extend (TrLayout.background model.colorScheme.primary.main.fill)
    |> TrLayout.root
