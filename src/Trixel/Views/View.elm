module Trixel.Views.View (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Types.Color as TrColor
import Trixel.Models.Model as TrModel

import Trixel.Views.Menu as TrMenuView
import Trixel.Views.Context as TrContextView
import Trixel.Views.Footer as TrFooterView

import Trixel.Graphics as TrGraphics
import Graphics.Element as Element
import Graphics.Collage as Collage


computeMenuDimensions : TrVector.Vector -> TrVector.Vector
computeMenuDimensions dimensions =
  TrVector.construct
    dimensions.x
    (clamp 30 75 (dimensions.y * 0.035))


computeFooterDimensions : TrVector.Vector -> TrVector.Vector
computeFooterDimensions dimensions =
  TrVector.construct
    dimensions.x
    (clamp 29 50 (dimensions.y * 0.025))


viewChildren : TrVector.Vector -> TrModel.Model -> List Element.Element
viewChildren dimensions model =
  let menuDimensions =
        computeMenuDimensions dimensions

      footerDimensions =
        computeFooterDimensions dimensions

      contextDimensions =
        TrVector.construct
          dimensions.x
          (dimensions.y - menuDimensions.y - footerDimensions.y)
  in
    [ TrMenuView.view menuDimensions model
    , TrContextView.view contextDimensions model
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