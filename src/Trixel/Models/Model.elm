module Trixel.Models.Model where

import Trixel.Models.Native as TrNative
import Trixel.Models.Work as TrWork
import Trixel.Types.ColorScheme as TrColorScheme
import Trixel.Types.Color as TrColor

import Html exposing (Html, Attribute, div, text)
import Html.Attributes exposing (style, id, class)


type alias ModelSignal = Signal Model

type alias MainSignal = Signal Html


initialModel : Model
initialModel =
  { native = TrNative.initialModel
  , work = TrWork.initialModel
  , colorScheme = TrColorScheme.nightColorScheme
  }


type alias Model =
  { native : TrNative.Model
  , work : TrWork.Model
  , colorScheme : TrColorScheme.ColorScheme
  }


update : Model -> Model -> Model
update new old =
  new


view : Model -> Html
view model =
  div
    [ style
        [ ("color", TrColor.toString model.colorScheme.primary.accentHigh)
        , ("background-color", TrColor.toString model.colorScheme.primary.default.fill)
        , ("font-family", "'Open Sans', sans-serif")
        , ("position", "absolute")
        , ("overflow", "hidden")
        , ("margin", "0")
        , ("padding", "0")
        , ("width", "100%")
        , ("height", "100%")
        ]
    , id model.native.identifiers.main
    ]
    [ div
        [ style
            [ ("position", "absolute")
            , ("width", "300px")
            , ("height", "300px")
        , ("background-color", TrColor.toString model.colorScheme.document)
            ]
        , id model.native.identifiers.workspace
        , class "noselect"
        ]
        [ text (toString "Hello, World!")
        ]
    ]
      