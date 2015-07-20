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


viewLeftMenu : TrVector.Vector -> TrModel.Model -> Html.Html
viewLeftMenu dimensions model =
  let size =
        dimensions.y * 0.55

      padding =
        dimensions.y * 0.1
  in
    Html.div
      [ Attributes.style
          [ ( "float", "left" )
          , ( "font-size", (toString size) ++ "px")
          , ( "padding", (toString padding) ++ "px")
          , ( "position", "relative")
          , ( "color", TrColor.toString model.colorScheme.primary.accentMid )
          ]
      , Attributes.id model.dom.tags.footerHelp
      ] []


viewCenterMenu : TrVector.Vector -> TrModel.Model -> Html.Html
viewCenterMenu dimensions model =
  let size =
        dimensions.y * 0.4

      padding =
        dimensions.y * 0.2
  in
    Html.div
      [ Attributes.style
          [ ( "float", "left")
          , ( "position", "absolute")
          , ( "left", "50%")
          , ( "height", (toString dimensions.y) ++ "px")
          , ( "width", (toString (dimensions.x * 0.2)) ++ "px")
          , ( "overflow", "initial")
          , ( "display", if dimensions.x < 560 then "none" else "block")
          ]
      ]
      [ Html.div
          [ Attributes.style
              [ ( "float", "left" )
              , ( "height", (toString dimensions.y) ++ "px")
              , ( "width", (toString (dimensions.x * 0.2)) ++ "px")
              , ( "position", "relative")
              , ( "left", "-50%")
              , ( "font-size", (toString size) ++ "px")
              , ( "padding", (toString padding) ++ "px")
              , ( "color", TrColor.toString model.colorScheme.primary.accentMid )
              , ( "text-align", "center")
              ]
          , Attributes.id model.dom.tags.footerShortcut
          ] []
      ]


viewRightMenu : TrVector.Vector -> TrModel.Model -> Html.Html
viewRightMenu dimensions model =
  let size =
        dimensions.y * 0.55

      padding =
        dimensions.y * 0.1
  in
    Html.div
      [ Attributes.style
          [ ( "float", "right" )
          , ( "font-size", (toString size) ++ "px")
          , ( "font-weight", "bold" )
          , ( "padding", (toString padding) ++ "px")
          , ( "position", "relative")
          , ( "color", TrColor.toString model.colorScheme.primary.accentLow )
          ]
      ] [ Html.text ("v" ++ TrConstants.version) ]


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  Html.div
    [ Attributes.style
        [ ( "position", "absolute" )
        , ( "width", (toString dimensions.x) ++ "px")
        , ( "height", (toString dimensions.y) ++ "px")
        ]
    ]
    [ viewLeftMenu dimensions model
    , viewCenterMenu dimensions model
    , viewRightMenu dimensions model
    ]
  |> Html.toElement (round dimensions.x) (round dimensions.y)