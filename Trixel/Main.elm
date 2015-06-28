module Trixel.Main where

import Trixel.Types.ColorScheme exposing (ColorScheme, zenburnScheme)
import Trixel.Update exposing (update)
import Trixel.Types.General exposing (..)
import Trixel.Types.Layer exposing (TrixelLayers, insertNewLayer)
import Trixel.Types.Math exposing (..)
import Trixel.Types.Html exposing (..)
import Trixel.Constants exposing (..)
import Trixel.PostOffice exposing (..)
import Trixel.Zones.WorkSpace
import Trixel.Zones.Footer
import Trixel.Zones.Menu

import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (style)
import Signal exposing (..)
import Color exposing (red)

import Set

import Window


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
    , postOfficeSignal
    , windowDimemensionsSignal
    ]
  |> Signal.foldp update (constructNewState 10 10)
  |> Signal.map view


constructNewState : Float -> Float -> State
constructNewState countX countY =
  { trixelInfo =
      { bounds = zeroBounds
      , height = 0
      , width = 0
      , mode = ClassicMode
      , scale = 1
      , offset = zeroVector
      , extraOffset = zeroVector
      , dimensions = zeroVector
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
  , renderCache =
      { grid = []
      , layers = []
      }
  , condition = NormalCondition
  , actions =
      { buttonsDown =
          Set.empty
      , keysDown =
          Set.empty
      }
  , workState = cleanWorkState
  , timeState = constructFreshTimeState countX countY
  , userSettings = defaultUserSettings
  }
  |> update
      ( ResizeWindow
         { x = 4200, y = 4200 }
      )


view : State -> Html
view state =
  div
    [ constructMainStyle state
    ]
    [ (Trixel.Zones.Menu.view state)
    , (Trixel.Zones.Footer.view state)
    , (Trixel.Zones.WorkSpace.view state)
    ]


constructMainStyle: State -> Attribute
constructMainStyle state  =
  let cursor =
        case state.mouseState of
          MouseDrag _ ->
            "move"

          _ ->
            "default"
  in
    style
      [ ("width", "100%")
      , ("height", "100%")
      , ("padding", "0 0")
      , ("margin", "0 0")
      , ("background-color", state.colorScheme.subbg.html)
      , ("position", "absolute")
      , ("cursor", cursor)
      , computeBoxSizingCSS BorderBox
      ]