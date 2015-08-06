module Trixel.Views.View (view) where

import Math.Vector2 as Vector

import Trixel.Types.Color as TrColor
import Trixel.Models.Model as TrModel

import Trixel.Views.Menu as TrMenuView
import Trixel.Views.Context as TrContextView
import Trixel.Views.Footer as TrFooterView

import Trixel.Graphics as TrGraphics
import Graphics.Element as Element
import Graphics.Collage as Collage


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


view : TrModel.Model -> Element.Element
view model =
  let dimensions =
        model.work.dimensions

      children =
        Element.flow
          Element.down
          (viewChildren dimensions model)
  in
    Collage.group
      [ TrGraphics.background model.colorScheme.primary.main.fill dimensions
      , Collage.toForm children
      ]
    |> TrGraphics.toElement dimensions