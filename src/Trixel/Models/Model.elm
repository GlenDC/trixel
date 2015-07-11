module Trixel.Models.Model where

import Trixel.Models.HtmlModel as HtmlModel
import Trixel.Types.ColorScheme as ColorScheme

import Html exposing (Html, Attribute, div, text)
import Html.Attributes exposing (style, id, class)


type alias ModelSignal = Signal Model

type alias MainSignal = Signal Html


initialModel : Model
initialModel =
  { html = HtmlModel.initialModel
  , colorScheme = ColorScheme.nightColorScheme
  }


type alias Model =
  { html : HtmlModel.Model
  , colorScheme : ColorScheme.ColorScheme
  }


update : Model -> Model -> Model
update new old =
  new


view : Model -> Html
view model =
  div
    [ style
        [ ("color", ColorScheme.constructHtmlColor model.colorScheme.primary.accentHigh)
        , ("background-color", ColorScheme.constructHtmlColor model.colorScheme.primary.default.fill)
        , ("font-family", "'Open Sans', sans-serif")
        , ("position", "absolute")
        , ("overflow", "hidden")
        , ("margin", "0")
        , ("padding", "0")
        , ("width", "100%")
        , ("height", "100%")
        ]
    , id model.html.identifiers.main
    ]
    [ div
        [ style
            [ ("position", "absolute")
            , ("width", "300px")
            , ("height", "300px")
        , ("background-color", ColorScheme.constructHtmlColor model.colorScheme.document)
            ]
        , id model.html.identifiers.workspace
        , class "noselect"
        ]
        [ text (toString "Hello, World!")
        ]
    ]
      