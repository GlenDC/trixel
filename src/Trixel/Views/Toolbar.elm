module Trixel.Views.Toolbar (view) where

import Trixel.Types.Color as TrColor
import Trixel.Models.Model as TrModel

import Html exposing (Html, div)
import Html.Attributes exposing (style, id)


view : TrModel.Model -> Html
view model =
  div
    [ style
        [ ("color", TrColor.toString model.colorScheme.secondary.accentHigh)
        , ("background-color", TrColor.toString model.colorScheme.secondary.main.fill)
        , ("border-color", TrColor.toString model.colorScheme.secondary.main.stroke)
        ]
    , id "tr-toolbar"
    ]
    []