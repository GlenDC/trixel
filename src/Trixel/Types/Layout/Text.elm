module Trixel.Types.Layout.Text where

import Trixel.Types.Layout as TrLayout
import Trixel.Types.Color as TrColor

import Html
import Html.Attributes as Attributes

import Css
import Css.Text as Text
import Css.Dimension as Dimension

import Markdown


type alias Align = Text.Align

left : Align
left = Text.Left

right : Align
right = Text.Right

center : Align
center = Text.Center


size : Float -> Css.Styles -> Css.Styles
size px styles =
  ("font-size", Css.px px) :: styles


bold : Css.Styles -> Css.Styles
bold styles =
  ("font-weight", "bold") :: styles


text : String -> Float -> Align -> TrColor.RgbaColor -> Bool -> TrLayout.Generator
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


centerVertically : TrLayout.Generator -> TrLayout.Generator
centerVertically generator =
  TrLayout.autoGroup
    TrLayout.column
    TrLayout.noWrap
    []
    [ generator ]
  |> TrLayout.extend (TrLayout.justifyContent TrLayout.Center)
  |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)


nativeText : String -> Float -> Align -> TrColor.RgbaColor -> TrLayout.Generator
nativeText id px align color =
  (\styles ->
    let style =
          Text.align align styles
          |> Text.color (TrColor.toColor color)
          |> size px
          |> Attributes.style
    in Html.div [ style, Attributes.id id ] []
    )

markdown : String -> (number, number) -> (number, number) -> TrColor.RgbaColor -> TrLayout.Generator
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
