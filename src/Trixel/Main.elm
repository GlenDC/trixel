module Trixel.Main where

import Trixel.Types.Mouse as Mouse
import Trixel.Math.Vector exposing (Vector)

import Html exposing (Html, Attribute, div, text)
import Html.Attributes exposing (style, id, class)


port setMouseButtonsDown : Signal Mouse.Buttons

port setWindowSizeManual : Signal Vector

port setMousePosition : Signal Vector


mainSignal : Signal Mouse.Buttons
mainSignal =
  Signal.foldp update [] setMouseButtonsDown


main : Signal Html
main =
  Signal.map view mainSignal


update : Mouse.Buttons -> Mouse.Buttons -> Mouse.Buttons
update new state =
  new


view : Mouse.Buttons -> Html
view buttons =
  div
    [ style
        [ ("position", "absolute")
        , ("width", "300px")
        , ("height", "300px")
        ]
    , id "canvas"
    , class "noselect"
    ]
    [ text (toString buttons)
    ]