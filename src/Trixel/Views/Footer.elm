module Trixel.Views.Footer (view) where

import Trixel.Constants as TrConstants
import Trixel.Models.Model as TrModel
import Trixel.Types.Color as TrColor

import Trixel.Models.Model as TrModel

import Trixel.Graphics as TrGraphics
import Graphics.Element as Element
import Math.Vector2 as Vector

import Html
import Html.Attributes as Attributes


viewLeftMenu : Vector.Vec2 -> TrModel.Model -> Html.Html
viewLeftMenu dimensions model =
  let dimensionsY =
        Vector.getY dimensions

      size =
        dimensionsY * 0.45

      padding =
        dimensionsY * 0.15
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


viewCenterMenu : Vector.Vec2 -> TrModel.Model -> Html.Html
viewCenterMenu dimensions model =
  let (dimensionsX, dimensionsY) =
        Vector.toTuple dimensions

      size =
        dimensionsY * 0.4

      padding =
        dimensionsY * 0.2
  in
    Html.div
      [ Attributes.style
          [ ( "float", "left")
          , ( "position", "absolute")
          , ( "left", "50%")
          , ( "height", (toString dimensionsY) ++ "px")
          , ( "width", (toString (dimensionsX * 0.2)) ++ "px")
          , ( "overflow", "initial")
          ]
      ]
      [ Html.div
          [ Attributes.style
              [ ( "float", "left" )
              , ( "height", (toString dimensionsY) ++ "px")
              , ( "width", (toString (dimensionsX * 0.2)) ++ "px")
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


viewRightMenu : Vector.Vec2 -> TrModel.Model -> Html.Html
viewRightMenu dimensions model =
  let dimensionsY =
        Vector.getY dimensions

      size =
        dimensionsY * 0.45

      padding =
        dimensionsY * 0.15
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


view : Vector.Vec2 -> TrModel.Model -> Element.Element
view dimensions model =
  let dimensionsX = Vector.getX dimensions
      dimensionsY = Vector.getY dimensions
  in
    Html.div
      [ Attributes.style
          [ ( "position", "absolute" )
          , ( "width", (toString dimensionsX) ++ "px")
          , ( "height", (toString dimensionsY) ++ "px")
          ]
      ]
      [ viewLeftMenu dimensions model
      , if dimensionsX < 560
          then Html.div [] []
          else viewCenterMenu dimensions model
      , viewRightMenu dimensions model
      ]
    |> Html.toElement (round dimensionsX) (round dimensionsY)