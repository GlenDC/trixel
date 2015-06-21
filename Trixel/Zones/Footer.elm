module Trixel.Zones.Footer (view) where

import Trixel.Types.ColorScheme exposing (ColorScheme)
import Trixel.Types.General exposing (..)
import Trixel.Types.Html exposing (..)
import Trixel.Constants exposing (..)

import Html exposing (Html, Attribute, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onMouseEnter)

view : ActionAddress -> State -> Html
view address state =
  div
    [ constructMainStyle state
    , onMouseEnter address (SetCondition IdleCondition)
    ]
    [ div
        [ style
            [ ("text-align", "right")
            , ("float", "right")
            ]
        ]
        [ text ("Trixel v" ++ version) ]
    , div
        [ style
            [ ("text-align", "left")
            , ("float", "left")
            ]
        ]
        [ computeConditionString state.condition |> text ]
    ]


constructMainStyle: State -> Attribute
constructMainStyle state  =
  style (
    (computeBoxModelCSS state.boxModels.footer) ++
    [ ("color", state.colorScheme.subText.html)
    , ("position", "absolute")
    , ("font-size", toPixels (footerSize * 1.25))
    , ("bottom", "0px")
    ])