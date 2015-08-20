module Trixel.Views.Footer (view) where

import Trixel.Constants as TrConstants
import Trixel.Models.Model as TrModel
import Trixel.Types.Color as TrColor

import Trixel.Models.Model as TrModel

import Html
import Html.Attributes as Attributes

import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Text as TrText


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
            model.colorScheme.primary.accentMid
      )
    , (0, TrText.nativeText
            model.dom.tags.footerHelp
            (size * 0.45)
            TrText.left
            model.colorScheme.primary.accentMid
          |> TrLayout.extend (TrLayout.paddingLeft (size * 0.25))
      )
    , (1, TrText.text
            ("v" ++ TrConstants.version)
            (size * 0.45)
            TrText.right
            model.colorScheme.primary.accentLow
          |> TrLayout.extend TrText.bold
      )
    ]
  |> TrLayout.extend (TrLayout.padding (size * 0.2))
