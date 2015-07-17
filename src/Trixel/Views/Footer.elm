module Trixel.Views.Footer (view) where

import Trixel.Types.Color as TrColor
import Trixel.Models.Model as TrModel
import Trixel.Constants as TrConstants

import Html exposing (Html, div, text)
import Html.Attributes exposing (style, id)


view : TrModel.Model -> Html
view model =
  div
    [ style
        [ ("color", TrColor.toString model.colorScheme.primary.accentHigh)
        , ("background-color", TrColor.toString model.colorScheme.primary.main.fill)
        , ("border-color", TrColor.toString model.colorScheme.primary.main.stroke)
        ]
    , id "tr-footer"
    ]
    [ div [ id "tr-footer-right" ] [ text ("version " ++ TrConstants.version) ] ]