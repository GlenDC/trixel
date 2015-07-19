module Trixel.Views.Footer (view) where

import Trixel.Constants as TrConstants
import Trixel.Math.Vector as TrVector
import Trixel.Models.Model as TrModel
import Trixel.Types.Color as TrColor

import Trixel.Models.Model as TrModel

import Trixel.Graphics as TrGraphics
import Graphics.Element as Element


viewLeftMenu : TrVector.Vector -> TrModel.Model -> Element.Element
viewLeftMenu dimensions model =
  Element.flow
    Element.right
    [ TrGraphics.text
        (Maybe.withDefault "" model.footer.help)
        dimensions
        model.colorScheme.primary.accentMid
        False
        False
        False
        Nothing
        TrGraphics.LeftAligned
    ]
  |> TrGraphics.setDimensions dimensions


viewRightMenu : TrVector.Vector -> TrModel.Model -> Element.Element
viewRightMenu dimensions model =
  Element.flow
    Element.right
    [ TrGraphics.text
        ("version " ++ TrConstants.version)
        dimensions
        model.colorScheme.primary.accentLow
        False
        False
        False
        Nothing
        TrGraphics.RightAligned
    ]


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  let rightMenuDimensions =
        TrVector.construct
          (dimensions.x * 0.3)
          (dimensions.y * 0.85)

      leftMenuDimensions =
        TrVector.construct
          (dimensions.x * 0.7)
          (dimensions.y * 0.85)
  in
    Element.flow
      Element.right
      [ viewLeftMenu leftMenuDimensions model
      , viewRightMenu rightMenuDimensions model
      ]
    |> TrGraphics.setDimensions dimensions