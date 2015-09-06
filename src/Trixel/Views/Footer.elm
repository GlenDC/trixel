module Trixel.Views.Footer (view) where

import Trixel.Constants as TrConstants
import Trixel.Types.Color as TrColor

import Trixel.Models.Lazy as TrLazy

import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Text as TrText

import Css.Border.Top as BorderTop
import Css.Border.Style as BorderStyle
import Css.Dimension as Dimension
import Css.Display as Display
import Css.Flex as Flex
import Css

import Html
import Html.Lazy
import Html.Attributes as Attributes


lazyView : Float -> TrLazy.LayoutModel -> Css.Styles -> Html.Html
lazyView size model styles =
  let children = 
        [ (0, TrText.nativeText
                model.tags.footerShortcut
                (size * 0.4)
                TrText.left
                model.colorScheme.primary.accentHigh
          )
        , (0, TrText.nativeText
                model.tags.footerHelp
                (size * 0.45)
                TrText.left
                model.colorScheme.primary.accentHigh
              |> TrLayout.extend (TrLayout.paddingLeft (size * 0.25))
          )
        , (1, TrText.text
                ("v" ++ TrConstants.version)
                (size * 0.45)
                TrText.right
                model.colorScheme.primary.accentMid
                True
          )
        ]

      elements =
        List.map
          (\(grow, generator) ->
            generator (Flex.grow grow [])
          )
        children

      style =
        Display.display Display.Flex styles
        |> Flex.flow TrLayout.row TrLayout.noWrap
        |> TrLayout.padding (size * 0.2) 
        |> BorderTop.width (max 2 (min (size * 0.065) 5))
        |> BorderTop.color (TrColor.toColor model.colorScheme.primary.main.stroke)
        |> BorderTop.style BorderStyle.Solid
        |> Dimension.minHeight (size * 0.6)
        |> TrLayout.crossAlign TrLayout.Center
        |> Attributes.style
  in
    Html.div [ style ] elements


view : Float -> TrLazy.LayoutModel -> Css.Styles -> Html.Html
view =
  Html.Lazy.lazy3 lazyView