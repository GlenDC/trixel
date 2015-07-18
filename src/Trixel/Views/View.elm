module Trixel.Views.View (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Types.Color as TrColor
import Trixel.Models.Model as TrModel

import Trixel.Views.Menu as TrMenuView
import Trixel.Views.Toolbar as TrToolbarView
import Trixel.Views.Work as TrWorkView

import Trixel.Graphics as TrGraphics
import Graphics.Element as Element
import Graphics.Collage as Collage

computeMenuDimensions : TrVector.Vector -> TrVector.Vector
computeMenuDimensions dimensions =
  TrVector.construct
    dimensions.x
    (clamp 30 75 (dimensions.y * 0.035))


viewChildren : TrVector.Vector -> TrModel.Model -> List Element.Element
viewChildren dimensions model =
  [ TrMenuView.view (computeMenuDimensions dimensions) model
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