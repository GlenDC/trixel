module Trixel.Views.View (view) where

import Math.Vector2 as Vector
import Html

import Trixel.Types.Color as TrColor
import Trixel.Models.Model as TrModel
import Trixel.Types.Layout as TrLayout

import Trixel.Views.Footer as TrFooterView

{-
computeMenuDimensions : Vector.Vec2 -> Vector.Vec2
computeMenuDimensions dimensions =
  let (dimX, dimY) = Vector.toTuple dimensions
  in
    Vector.vec2
      dimX
      (clamp 30 75 (dimY * 0.035))


computeFooterDimensions : Vector.Vec2 -> Vector.Vec2
computeFooterDimensions dimensions =
  let (dimX, dimY) = Vector.toTuple dimensions
  in
    Vector.vec2
      dimX
      (clamp 29 50 (dimY * 0.025))


viewChildren : Vector.Vec2 -> TrModel.Model -> List Element.Element
viewChildren dimensions model =
  let (dimX, dimY) = Vector.toTuple dimensions

      menuDimensions =
        computeMenuDimensions dimensions
      menuDimY = Vector.getY menuDimensions

      footerDimensions =
        computeFooterDimensions dimensions
      footerDimY = Vector.getY footerDimensions

      contextDimensions =
        Vector.vec2
          dimX
          (dimY - menuDimY - footerDimY)
  in
    [ TrMenuView.view menuDimensions model
    , TrContextView.view contextDimensions menuDimensions model
    , TrFooterView.view footerDimensions model
    ]
-}


view : TrModel.Model -> Html.Html
view model =
  let y = Vector.getY model.work.dimensions
  in
    TrLayout.group
      TrLayout.column
      TrLayout.noWrap
      [ (35, TrLayout.dummy TrColor.red)
      , (1000, TrLayout.dummy TrColor.blue)
      , (0, TrFooterView.view (y * 0.025) model)
      ]
    |> TrLayout.extend (TrLayout.background model.colorScheme.primary.main.fill)
    |> TrLayout.root
