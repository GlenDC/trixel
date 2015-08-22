module Trixel.Views.Footer (view) where

import Trixel.Constants as TrConstants
import Trixel.Models.Model as TrModel
import Trixel.Types.Color as TrColor

import Trixel.Models.Model as TrModel

import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Text as TrText

import Html
import Html.Attributes as Attributes

import Css.Border.Top as BorderTop
import Css.Border.Style as BorderStyle
import Css.Dimension as Dimension

view : Float -> TrModel.Model -> TrLayout.Generator
view size model =
  TrLayout.group
    TrLayout.row
    TrLayout.noWrap
    []
    [ (0, TrText.nativeText
            model.dom.tags.footerShortcut
            (size * 0.4)
            TrText.left
            model.colorScheme.primary.accentHigh
      )
    , (0, TrText.nativeText
            model.dom.tags.footerHelp
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
  |> TrLayout.extend (TrLayout.padding (size * 0.2))
  |> TrLayout.extend (BorderTop.width (max 2 (min (size * 0.065) 5)))
  |> TrLayout.extend (BorderTop.color (TrColor.toColor model.colorScheme.primary.main.stroke))
  |> TrLayout.extend (BorderTop.style BorderStyle.Solid)
  |> TrLayout.extend (Dimension.minHeight size)
  |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)
