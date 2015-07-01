module Trixel.Main where

import Trixel.Types.ColorScheme exposing (ColorScheme, zenburnScheme)
import Trixel.Update exposing (update)
import Trixel.Types.General exposing (..)
import Trixel.Types.JSGlue exposing (..)
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
import Color exposing (red, rgba)

import Set

import Window

import Debug


windowDimemensionsSignal : ActionSignal
windowDimemensionsSignal =
  Signal.map
    (\(x, y) ->
      ResizeWindow { x = toFloat x, y = toFloat y })
    Window.dimensions


-- ingoing port that gets called with the initial window inner-dimensions
port startEditor : Signal Vector


-- ingoing port that gets called when color changes
port setTrixelColor : Signal JSColor

setTrixelcolorSignalJS : ActionSignal
setTrixelcolorSignalJS =
  Signal.map
    (\color ->
      SetColor
        (computeColorFromJSColor color))
    setTrixelColor


-- ingoing ports for adding and removing active input
-- adding input will block/freeze editor input
port triggerJSInput : Signal Bool

triggerJSInputSignal : Signal PostOfficeAction
triggerJSInputSignal =
  Signal.map
    (\active ->
      if active
        then EnteringHTMLInput
        else LeavingHTMLInput
    )
    triggerJSInput

-- outgoing port that sends the newest glueState so that
-- our javascript can react appropriate on it
port updateStateSignalPort : Signal GlueState
port updateStateSignalPort =
  Signal.map
    (\state ->
      state.glueState)
    updateStateSignal

startEditorSignal: ActionSignal
startEditorSignal = 
  Signal.map
    (\dimensions ->
      ResizeWindow dimensions)
    startEditor


workspaceSignals : Signal TrixelAction
workspaceSignals =
  mergeMany
    [ postOfficeQuery.signal
    , moveOffsetSignal
    , moveMouseSignal
    , keyboardSignal
    , mouseWheelSignal
    , mouseButtonSignal
    , triggerJSInputSignal
    ]
  |> Signal.foldp workspacePostOffice
      (SwitchAction
        { action = None
        , condition = NormalCondition
        , inputsActive = 0
        }
      )

postOfficeSignal : Signal TrixelAction
postOfficeSignal =
  filter
    filterPostOfficeSignal
    None
    workspaceSignals


updateStateSignal : Signal State
updateStateSignal =
  mergeMany
    [ actionQuery.signal
    , postOfficeSignal
    , windowDimemensionsSignal
    , startEditorSignal
    , setTrixelcolorSignalJS
    ]
  |> Signal.foldp update (constructNewState 10 10)


main : Signal Html
main =
  Signal.map view updateStateSignal


constructNewState : Float -> Float -> State
constructNewState countX countY =
  let freshTimeState =
        constructFreshTimeState countX countY
  in
    { trixelInfo =
        { height = 0
        , width = 0
        , mode = ClassicMode
        , scale = 1
        , offset = zeroVector
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
        { layers = []
        }
    , condition = NormalCondition
    , actions =
        { buttonsDown =
            Set.empty
        , keysDown =
            Set.empty
        , previousButtonsDown =
            Set.empty
        }
    , workState = cleanWorkState
    , timeState = freshTimeState
    , hasUserUpdatedTimeState = False
    , cachedTimeState = freshTimeState.present
    , glueState = emptyGlueState
    }


view : State -> Html
view state =
  div
    [ constructMainStyle state
    ]
    (if state.windowDimensions.x == 0
      then
        [div [] []]
      else
        [ (Trixel.Zones.Menu.view state)
        , (Trixel.Zones.Footer.view state)
        , (Trixel.Zones.WorkSpace.view state)
        ]
    )


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