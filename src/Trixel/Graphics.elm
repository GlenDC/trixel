module Trixel.Graphics where

import Trixel.Types.Color as TrColor
import Trixel.Math.Vector as TrVector

import Graphics.Collage as Collage
import Graphics.Element as Element
import Graphics.Input as Input
import Text

import Maybe exposing (..)
import Signal

import Html
import Html.Attributes as Attributes

import Svg exposing (Svg)
import Color exposing (Color)


import Trixel.Native as TrNative


type TextAlignment
  = LeftAligned
  | RightAligned
  | CenterAligned


alignText : TextAlignment -> (String, String)
alignText alignment =
  ( "text-align"
  , case alignment of
      LeftAligned ->
        "left"

      RightAligned ->
        "right"

      CenterAligned ->
        "center"
  )


decorateText : Maybe Text.Line -> (String, String)
decorateText maybeLine =
  ( "text-decoration"
  , case maybeLine of
      Nothing ->
        "none"

      Just line ->
        case line of
          Text.Under ->
            "underline"

          Text.Over ->
            "overline"

          Text.Through ->
            "line-through"
    )


text : String -> TrVector.Vector -> TrColor.RgbaColor -> Bool -> Bool -> Bool -> Maybe Text.Line -> TextAlignment -> Element.Element
text title dimensions color bold italic pointer line alignment =
  Html.div
    [ Attributes.style
        [ ("font-size", (toString (dimensions.y * 0.65)) ++ "px")
        , ("font-style", (if italic then "italic" else "normal"))
        , ("font-weight", (if bold then "bold" else "normal"))
        , ("padding", (toString (dimensions.y * 0.1)) ++ "px")
        , ("color", (TrColor.toString color))
        , ("cursor", (if pointer then "pointer" else "default"))
        , alignText alignment
        , decorateText line
        ]
    ]
    [ Html.text title]
  |> Html.toElement (round dimensions.x) (round dimensions.y)


computeDimensions : Element.Element -> TrVector.Vector
computeDimensions element =
  let (x, y) = Element.sizeOf element
  in TrVector.construct (toFloat x) (toFloat y)


hoverable : String -> Element.Element -> Element.Element
hoverable message element =
  let htmlElement =
        Html.fromElement element
  in
    Html.div
      [ Attributes.class "tr-hoverable"
      , TrNative.mouseEnter "trFooterShowHelp" [message]
      , TrNative.mouseLeave "trFooterHideHelp" []
      ]
      [ htmlElement ]
    |> Html.toElement -1 -1


button : String -> String -> Bool -> TrVector.Vector -> TrColor.RgbaColor -> TrColor.RgbaColor -> Signal.Address a -> a -> Element.Element
button title help selected dimensions normal select address action =
  let up = text
        title dimensions normal False False (not selected) Nothing CenterAligned
      hover = text
        title dimensions select False False (not selected) (Just Text.Under) CenterAligned
  in
    Input.customButton
      (Signal.message address action)
      (if selected then hover else up)
      hover hover
    |> hoverable help


svgButtonElement : (Color -> Int -> Svg) -> String -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> Element.Element
svgButtonElement render label size background color =
  let paddingVer =
        (toString (size * 0.15)) ++ "px "
      paddingHor =
        (toString (size * 0.10)) ++ "px "

      iconSize =
        size * 0.8
  in
    Html.div
      [ Attributes.style
          [ ("background-color", TrColor.toString background)
          , ("color", TrColor.toString color)
          , ("padding", "0 " ++ paddingHor)
          ]
      ]
      [ Svg.svg
        [ Attributes.style
            [ ("width", (toString iconSize) ++ "px")
            , ("height", (toString iconSize) ++ "px")
            , ("padding", (toString  ((size - iconSize) / 2)) ++ "px")
            , ("float", "left")
            ]
        ]
        [ render (TrColor.toColor color) (round iconSize) ]
      , Html.div
          [ Attributes.style
              [ ("font-size", (toString (size * 0.5)) ++ "px")
              , ("padding", paddingVer ++ " " ++ paddingHor)
              , ("float", "left")
              ]
          ] [ Html.text label ]
      ]
    |> Html.toElement -1 -1


svgVerticalButtonElement : (Color -> Int -> Svg) -> String -> TrVector.Vector -> TrColor.RgbaColor -> TrColor.RgbaColor -> Element.Element
svgVerticalButtonElement render label dimensions background color =
  let paddingVer =
        (toString (dimensions.y * 0.15)) ++ "px "
      paddingHor =
        (toString (dimensions.y * 0.10)) ++ "px "

      iconSize =
        dimensions.y * 0.8
  in
    Html.div
      [ Attributes.style
          [ ("background-color", TrColor.toString background)
          , ("color", TrColor.toString color)
          ]
      ]
      [ Html.div
          [ Attributes.style
              [ ("display", "flex" )
              , ("justify-content", "center")
              ]
          ]
          [ Svg.svg
            [ Attributes.style
                [ ("width", (toString iconSize) ++ "px")
                , ("height", (toString iconSize) ++ "px")
                , ("padding", (toString  ((dimensions.y - iconSize) / 2)) ++ "px")
                , ("float", "left")
                ]
            ]
            [ render (TrColor.toColor color) (round iconSize) ]
          , Html.div
              [ Attributes.style
                  [ ("font-size", (toString (dimensions.y * 0.5)) ++ "px")
                  , ("padding", paddingVer ++ " " ++ paddingHor)
                  , ("float", "left")
                  ]
              ] [ Html.text label ]
          ]
      ]
    |> Html.toElement (round dimensions.x) (round dimensions.y)


svgButton : (Color -> Int -> Svg) -> String -> String -> Bool -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrColor.RgbaColor -> Signal.Address a -> a -> Element.Element
svgButton render label help selected size normal select normalBackground selectBackground address action =
  let up = 
        svgButtonElement render label size normalBackground normal
      hover =
        svgButtonElement render label size selectBackground select
  in
    Input.customButton
      (Signal.message address action)
      (if selected then hover else up)
      hover hover
    |> hoverable help


svgVerticalButton : (Color -> Int -> Svg) -> String -> String -> Bool -> TrVector.Vector -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrColor.RgbaColor -> Signal.Address a -> a -> Element.Element
svgVerticalButton render label help selected dimensions normal select normalBackground selectBackground address action =
  let up = 
        svgVerticalButtonElement render label dimensions normalBackground normal
      hover =
        svgVerticalButtonElement render label dimensions selectBackground select
  in
    Input.customButton
      (Signal.message address action)
      (if selected then hover else up)
      hover hover
    |> hoverable help


image : TrVector.Vector -> TrVector.Vector -> String -> Element.Element
image dimensions padding src =
  Element.image (round dimensions.x) (round dimensions.y) src
  |> applyPadding dimensions padding


applyPadding : TrVector.Vector -> TrVector.Vector -> Element.Element -> Element.Element
applyPadding dimensions padding element =
  Collage.toForm element
  |> toElement (TrVector.add dimensions (TrVector.scale 2 padding))


toElement : TrVector.Vector -> Collage.Form -> Element.Element
toElement dimensions form =
  collage dimensions [form]


collage : TrVector.Vector -> List Collage.Form -> Element.Element
collage dimensions forms =
  Collage.collage
    (round dimensions.x)
    (round dimensions.y)
    forms


setDimensions : TrVector.Vector -> Element.Element -> Element.Element
setDimensions dimensions element =
  Element.size
    (round dimensions.x)
    (round dimensions.y)
    element


background : TrColor.RgbaColor -> TrVector.Vector -> Collage.Form
background color dimensions =
  Collage.rect dimensions.x dimensions.y
  |> Collage.filled (TrColor.toColor color)