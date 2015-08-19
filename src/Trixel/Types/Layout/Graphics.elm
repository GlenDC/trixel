module Trixel.Types.Layout.Graphics where

import Trixel.Types.Layout as TrLayout
import Trixel.Types.Color as TrColor

import Html
import Html.Attributes as Attributes

import Css
import Css.Dimension as Dimension

import Svg exposing (Svg)
import Color exposing (Color)


type alias SvgGenerator = Color -> Int -> Svg


image : String -> String -> Float -> Float -> TrLayout.Generator
image src alt size padding =
  (\styles ->
    let style =
          Dimension.height size styles
          |> TrLayout.padding padding
          |> Attributes.style
    in
      Html.img
        [ style
        , Attributes.src src
        , Attributes.alt alt
        ] []
    )


svg : SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> TrLayout.Generator
svg generator color size padding =
  (\styles ->
    let style =
            Dimension.height size styles
            |> Dimension.width size
            |> TrLayout.padding padding
            |> Attributes.style
    in
       Svg.svg
        [ style ]
        [ generator (TrColor.toColor color) (round size) ]
    )