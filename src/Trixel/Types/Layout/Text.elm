module Trixel.Types.Layout.Text where

import Trixel.Types.Layout exposing (Generator, extend)
import Trixel.Types.Color as TrColor

import Html
import Html.Attributes as Attributes

import Css
import Css.Text as Text
import Css.Dimension as Dimension

import Markdown


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


text : String -> Float -> Align -> TrColor.RgbaColor -> Bool -> Generator
text title px align color selectable =
  (\styles ->
    let style =
          Text.align align styles
          |> Text.color (TrColor.toColor color)
          |> size px
          |> Attributes.style
    in Html.div
        [ style
        , Attributes.class ( if selectable then "tr-menu-article" else "")
        ]
        [ Html.text title ]
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

markdown : String -> (number, number) -> (number, number) -> TrColor.RgbaColor -> Generator
markdown content (minWidth, maxWidth) (minHeight, maxHeight) color =
  (\styles ->
    let style =
          Dimension.minWidth minWidth styles
          |> Dimension.maxWidth maxWidth
          |> Dimension.minHeight minHeight
          |> Dimension.maxHeight maxHeight
          |> Text.color (TrColor.toColor color)
          |> Attributes.style
    in
      Html.div
        [ style
        , Attributes.class "tr-menu-article"
        ]
        [ Markdown.toHtml content
        ]
    )
