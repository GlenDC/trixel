module Trixel.Main where

import Trixel.Types.ColorScheme exposing (ColorScheme, zenburnScheme)
import Trixel.Update exposing (update)
import Trixel.Types.General exposing (..)
import Trixel.Types.Math exposing (..)
import Trixel.Types.Html exposing (..)
import Trixel.Constants exposing (..)
import Trixel.Zones.WorkSpace
import Trixel.Zones.Footer
import Trixel.Zones.Menu

import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (style)
import Html.Events exposing (onMouseEnter)
import Signal exposing (..)
import Color exposing (red)

import Window
import Keyboard
import Mouse


actionQuery : Mailbox TrixelAction
actionQuery = mailbox None


moveOffsetSignal : ActionSignal
moveOffsetSignal =
  Signal.map
    (\{x, y} ->
      MoveOffset { x = toFloat x, y = toFloat y })
    Keyboard.arrows


moveMouseSignal : ActionSignal
moveMouseSignal =
  Signal.map
    (\(x, y) ->
      MoveMouse { x = toFloat x, y = toFloat y })
    Mouse.position


windowDimemensionsSignal : ActionSignal
windowDimemensionsSignal =
  Signal.map
    (\(x, y) ->
      ResizeWindow { x = toFloat x, y = toFloat y })
    Window.dimensions


main : Signal Html
main =
  mergeMany
    [ actionQuery.signal
    , windowDimemensionsSignal
    , moveOffsetSignal
    , moveMouseSignal
    ]
  |> Signal.foldp update (constructNewState 10 10)
  |> Signal.map view


constructNewState : Float -> Float -> State
constructNewState countX countY =
  { trixelInfo =
      { bounds = zeroBounds
      , height = 0
      , width = 0
      , mode = Vertical
      , count = { x = countX, y = countY }
      , scale = 1
      , offset = zeroVector
      , extraOffset = zeroVector
      }
  , trixelColor = red
  , colorScheme = zenburnScheme
  , boxModels =
      { menu = zeroBoxModel
      , footer = zeroBoxModel
      , workspace = zeroBoxModel
      }
  , windowDimensions = zeroVector
  , mouseState = MouseNone
  , grid = []
  , condition = IdleCondition
  }


view : State -> Html
view state =
  div
    [ constructMainStyle state
    , onMouseEnter actionQuery.address (SetCondition IdleCondition)
    ]
    [ (Trixel.Zones.Menu.view actionQuery.address state)
    , (Trixel.Zones.Footer.view actionQuery.address state)
    , (Trixel.Zones.WorkSpace.view actionQuery.address state)
    ]


constructMainStyle: State -> Attribute
constructMainStyle state  =
  style
    [ ("width", "100%")
    , ("height", "100%")
    , ("padding", "0 0")
    , ("margin", "0 0")
    , ("background-color", state.colorScheme.subbg.html)
    , ("position", "absolute")
    , computeBoxSizingCSS BorderBox
    ]