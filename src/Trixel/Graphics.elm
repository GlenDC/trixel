module Trixel.Graphics where

import Trixel.Types.Color as TrColor
import Trixel.Types.List as TrList
import Trixel.Types.Input as TrInput
import Trixel.Types.Keyboard as TrKeyboard

import Math.Vector2 as Vector

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


text : String -> Vector.Vec2 -> TrColor.RgbaColor -> Bool -> Bool -> Maybe Text.Line -> TextAlignment -> Element.Element
text title dimensions color bold italic line alignment =
  let (dimensionsX, dimensionsY) = Vector.toTuple dimensions
  in
    Html.div
      [ Attributes.style
          [ ("font-size", (toString (dimensionsY * 0.65)) ++ "px")
          , ("font-style", (if italic then "italic" else "normal"))
          , ("font-weight", (if bold then "bold" else "normal"))
          , ("padding", (toString (dimensionsY * 0.1)) ++ "px")
          , ("color", (TrColor.toString color))
          , alignText alignment
          , decorateText line
          ]
      ]
      [ Html.text title]
    |> Html.toElement (round dimensionsX) (round dimensionsY)


computeDimensions : Element.Element -> Vector.Vec2
computeDimensions element =
  let (x, y) = Element.sizeOf element
  in Vector.vec2 (toFloat x) (toFloat y)


showShortcut : TrInput.Buttons -> String
showShortcut buttons =
  let descriptions =
        TrKeyboard.getDescriptions buttons

      aux = 
        TrList.head descriptions ""
  in
    List.foldr
      (\item result ->
        result ++ " + " ++ item)
      aux
      (TrList.tail descriptions)


hoverable : String -> TrInput.Buttons -> Element.Element -> Element.Element
hoverable message buttons element =
  let htmlElement =
        Html.fromElement element

      shortcut =
        if List.isEmpty buttons
          then ""
          else "[ " ++ (showShortcut buttons) ++ " ]"
  in
    Html.div
      [ Attributes.class "tr-hoverable"
      , Attributes.title message
      , TrNative.mouseEnter "trFooterShowHelp" [message, shortcut]
      , TrNative.mouseLeave "trFooterHideHelp" []
      ]
      [ htmlElement ]
    |> Html.toElement -1 -1


svgNativeButton : (Color -> Int -> Svg) -> String -> List String -> String -> TrInput.Buttons -> Maybe String -> Float -> TrColor.RgbaColor -> Element.Element
svgNativeButton render function arguments help shortcut maybeLabel size color =
  let paddingVer =
        (toString (size * 0.15)) ++ "px "
      paddingHor =
        (toString (size * 0.10)) ++ "px "

      iconSize =
        size * 0.8

      labelDiv =
        case maybeLabel of
          Nothing ->
            Html.div [] []

          Just label ->
            Html.div
            [ Attributes.style
                [ ("font-size", (toString (size * 0.5)) ++ "px")
                , ("padding", paddingVer ++ " " ++ paddingHor)
                , ("float", "left")
                ]
            ] [ Html.text label ]
  in
    Html.div
      [ Attributes.style
          [ ("color", TrColor.toString color)
          , ("padding", "0 " ++ paddingHor)
          ]
      , TrNative.mouseClick function arguments
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
      , labelDiv
      ]
    |> Html.toElement -1 -1
    |> hoverable help shortcut


svgButtonElement : (Color -> Int -> Svg) -> Maybe String -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> Element.Element
svgButtonElement render maybeLabel size background color =
  let paddingVer =
        (toString (size * 0.15)) ++ "px "
      paddingHor =
        (toString (size * 0.10)) ++ "px "

      iconSize =
        size * 0.8

      labelDiv =
        case maybeLabel of
          Nothing ->
            Html.div [] []

          Just label ->
            Html.div
            [ Attributes.style
                [ ("font-size", (toString (size * 0.5)) ++ "px")
                , ("padding", paddingVer ++ " " ++ paddingHor)
                , ("float", "left")
                ]
            ] [ Html.text label ]
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
      , labelDiv
      ]
    |> Html.toElement -1 -1


svgVerticalButtonElement : (Color -> Int -> Svg) -> String -> Vector.Vec2 -> TrColor.RgbaColor -> TrColor.RgbaColor -> Element.Element
svgVerticalButtonElement render label dimensions background color =
  let (dimensionsX, dimensionsY) =
        Vector.toTuple dimensions

      paddingVer =
        (toString (dimensionsY * 0.15)) ++ "px "
      paddingHor =
        (toString (dimensionsY * 0.10)) ++ "px "

      iconSize =
        dimensionsY * 0.8
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
                , ("padding", (toString  ((dimensionsY - iconSize) / 2)) ++ "px")
                , ("float", "left")
                ]
            ]
            [ render (TrColor.toColor color) (round iconSize) ]
          , Html.div
              [ Attributes.style
                  [ ("font-size", (toString (dimensionsY * 0.5)) ++ "px")
                  , ("padding", paddingVer ++ " " ++ paddingHor)
                  , ("float", "left")
                  ]
              ] [ Html.text label ]
          ]
      ]
    |> Html.toElement (round dimensionsX) (round dimensionsY)


svgButton : (Color -> Int -> Svg) -> Maybe String -> String -> TrInput.Buttons -> Bool -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrColor.RgbaColor -> Signal.Address a -> a -> Element.Element
svgButton render maybeLabel help shortcut selected size normal select normalBackground selectBackground address action =
  let up = 
        svgButtonElement render maybeLabel size normalBackground normal
      hover =
        svgButtonElement render maybeLabel size selectBackground select
  in
    Input.customButton
      (Signal.message address action)
      (if selected then hover else up)
      hover hover
    |> hoverable help shortcut


svgVerticalButton : (Color -> Int -> Svg) -> String -> String -> TrInput.Buttons -> Bool -> Vector.Vec2 -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrColor.RgbaColor -> Signal.Address a -> a -> Element.Element
svgVerticalButton render label help shortcut selected dimensions normal select normalBackground selectBackground address action =
  let up = 
        svgVerticalButtonElement render label dimensions normalBackground normal
      hover =
        svgVerticalButtonElement render label dimensions selectBackground select
  in
    Input.customButton
      (Signal.message address action)
      (if selected then hover else up)
      hover hover
    |> hoverable help shortcut


image : Vector.Vec2 -> Vector.Vec2 -> String -> Element.Element
image dimensions padding src =
  Element.image (round (Vector.getX dimensions)) (round (Vector.getY dimensions)) src
  |> applyPadding dimensions padding


applyPadding : Vector.Vec2 -> Vector.Vec2 -> Element.Element -> Element.Element
applyPadding dimensions padding element =
  Collage.toForm element
  |> toElement (Vector.add dimensions (Vector.scale 2 padding))


toElement : Vector.Vec2 -> Collage.Form -> Element.Element
toElement dimensions form =
  collage dimensions [form]


collage : Vector.Vec2 -> List Collage.Form -> Element.Element
collage dimensions forms =
  Collage.collage
    (round (Vector.getX dimensions))
    (round (Vector.getY dimensions))
    forms


setDimensions : Vector.Vec2 -> Element.Element -> Element.Element
setDimensions dimensions element =
  Element.size
    (round (Vector.getX dimensions))
    (round (Vector.getY dimensions))
    element


background : TrColor.RgbaColor -> Vector.Vec2 -> Collage.Form
background color dimensions =
  Collage.rect (Vector.getX dimensions) (Vector.getY dimensions)
  |> Collage.filled (TrColor.toColor color)