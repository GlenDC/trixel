module Trixel.Zones.Footer (view) where

import Trixel.Types.ColorScheme exposing (ColorScheme)
import Trixel.Types.General exposing (..)
import Trixel.Types.Html exposing (..)
import Trixel.Constants exposing (..)
import Trixel.PostOffice exposing (..)

import Html exposing (Html, Attribute, div, text, footer, a)
import Html.Attributes exposing (style, class, href)

view : State -> Html
view state =
  footer
    [ constructMainStyle state
    , class "noselect"
    ]
    [ div
        [ style
            [ ("text-align", "right")
            , ("float", "right")
            , ("cursor", "default")
            ]
        ]
        [ text ("Trixel v" ++ version) ]
    , div
        [ style
            [ ("text-align", "left")
            , ("float", "left")
            , ("cursor", "default")
            , ( "color", "lightGrey")
            ]
        ]
        [ constructURL githubRepositoryURL "GitHub Repository"
        , text " | "
        , constructURL newsletterSubscribeURL "Subscribe to newsletter"
        ]
    ]

constructURL : String -> String -> Html
constructURL url description =
  a
    [ href url
    , style [ ( "color", "lightGrey") ]
    ]
    [ text description
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