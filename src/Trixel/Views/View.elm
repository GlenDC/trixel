module Trixel.Views.View (view) where

import Trixel.Types.Color as TrColor
import Trixel.Models.Model as TrModel

import Trixel.Views.Menu as TrMenuView
import Trixel.Views.Toolbar as TrToolbarView
import Trixel.Views.Work as TrWorkView
import Trixel.Views.Footer as TrFooterView

import Html exposing (Html, div)
import Html.Attributes exposing (style, id)


view : TrModel.Model -> Html
view model =
  div
    [ style
        [ ("color", TrColor.toString model.colorScheme.primary.accentHigh)
        , ("background-color", TrColor.toString model.colorScheme.primary.main.fill)
        ]
    , id "tr-main"
    ]
    [ TrMenuView.view model
    , TrToolbarView.view model
    , TrWorkView.view model
    , TrFooterView.view model
    ]