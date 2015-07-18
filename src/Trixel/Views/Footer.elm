module Trixel.Views.Footer (view) where

import Trixel.Constants as TrConstants
import Trixel.Math.Vector as TrVector
import Trixel.Models.Model as TrModel
import Trixel.Types.Color as TrColor

import Trixel.Models.Model as TrModel

import Trixel.Graphics as TrGraphics
import Graphics.Element as Element

import Html
import Html.Attributes as Attributes


alignText : TrGraphics.TextAlignment -> (String, String)
alignText alignment =
  case alignment of
    TrGraphics.LeftAligned ->
      ("text-align", "left")

    TrGraphics.RightAligned ->
      ("text-align", "right")

    TrGraphics.CenterAligned ->
      ("text-align", "center")


viewText : String -> Bool -> TrVector.Vector -> TrModel.Model -> TrGraphics.TextAlignment -> Element.Element
viewText title italic dimensions model alignment =
  Html.div
    [ Attributes.style
        [ ("font-style", (if italic then "italic" else "normal"))
        , ("font-size", (toString (dimensions.y * 0.65)) ++ "px")
        , ("padding", (toString (dimensions.y * 0.175)) ++ "px")
        , ("color", (TrColor.toString model.colorScheme.primary.accentMid))
        , alignText alignment
        ]
    ]
    [ Html.text title]
  |> Html.toElement (round dimensions.x) (round dimensions.y)


viewLeftMenu : TrVector.Vector -> TrModel.Model -> Element.Element
viewLeftMenu dimensions model =
  Element.flow
    Element.right
    [ viewText
        (Maybe.withDefault "" model.footer.help)
        True
        dimensions
        model
        TrGraphics.LeftAligned
    ]
  |> TrGraphics.setDimensions dimensions


viewRightMenu : TrVector.Vector -> TrModel.Model -> Element.Element
viewRightMenu dimensions model =
  Element.flow
    Element.right
    [ viewText
        ("version " ++ TrConstants.version)
        False
        dimensions
        model
        TrGraphics.RightAligned
    ]


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  let rightMenuDimensions =
        TrVector.construct
          (dimensions.x * 0.3)
          dimensions.y

      leftMenuDimensions =
        TrVector.construct
          (dimensions.x * 0.7)
          dimensions.y
  in
    Element.flow
      Element.right
      [ viewLeftMenu leftMenuDimensions model
      , viewRightMenu rightMenuDimensions model
      ]
    |> TrGraphics.setDimensions dimensions