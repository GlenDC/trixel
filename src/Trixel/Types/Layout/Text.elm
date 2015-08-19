module Trixel.Types.Layout.Text where

import Trixel.Types.Layout exposing (Generator, extend)
import Trixel.Types.Color as TrColor

import Html
import Html.Attributes as Attributes

import Css
import Css.Text as Text


type alias Align = Text.Align
left = Text.Left
right = Text.Right
center = Text.Center


size : Float -> Css.Styles -> Css.Styles
size px styles =
  ("font-size", Css.px px) :: styles


bold : Css.Styles -> Css.Styles
bold styles =
  ("font-weight", "bold") :: styles


text : String -> Float -> Align -> TrColor.RgbaColor -> Generator
text title px align color =
  (\styles ->
    let style =
          Text.align align styles
          |> Text.color (TrColor.toColor color)
          |> size px
          |> Attributes.style
    in Html.div [ style ] [ Html.text title ]
    )


nativeText : String -> Float -> Align -> TrColor.RgbaColor -> Generator
nativeText id px align color =
  (\styles ->
    let style =
          Text.align align styles
          |> Text.color (TrColor.toColor color)
          |> size px
          |> Attributes.style
    in Html.div [ style, Attributes.id id ] []
    )
