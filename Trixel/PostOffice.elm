module Trixel.PostOffice where

import Trixel.Types.General exposing (..)
import Trixel.Constants exposing (..)

import Signal exposing (..)
import EditorKeyboard
import Mouse

import MouseExtra


moveOffsetSignal : Signal PostOfficeAction
moveOffsetSignal =
  Signal.map
    (\{x, y} ->
      PostAction (MoveOffset ({ x = toFloat x, y = toFloat y }, workspaceOffsetMoveSpeed)))
    EditorKeyboard.arrows


moveMouseSignal : Signal PostOfficeAction
moveMouseSignal =
  Signal.map
    (\(x, y) ->
      PostAction (MoveMouse { x = toFloat x, y = toFloat y }))
    Mouse.position


mouseButtonSignal : Signal PostOfficeAction
mouseButtonSignal =
  Signal.map
    (\buttonCodeSet ->
      PostAction (SetMouseButtonsDown buttonCodeSet))
    MouseExtra.buttonsDown


keyboardSignal : Signal PostOfficeAction
keyboardSignal =
  Signal.map
    (\keyCodeSet ->
      PostAction (SetKeyboardKeysDown keyCodeSet))
    EditorKeyboard.keysDown


mouseWheelSignal : Signal PostOfficeAction
mouseWheelSignal =
  Signal.map
    (\(deltaX, deltaY) ->
      PostAction (SetMouseWheel deltaY))
    MouseExtra.mouseWheel


postOfficeTrashQuery : Mailbox TrixelAction
postOfficeTrashQuery = mailbox None


postOfficeQuery : Mailbox PostOfficeAction
postOfficeQuery = mailbox PostNoAction


handlePostedAction : PostOfficeAction -> PostOfficeState -> TrixelAction
handlePostedAction action state =
  case action of
    PostAction trixelAction ->
      SwitchAction
        { state
            | action <-
                trixelAction
        }

    EnteringHTMLInput ->
      let inputsActive =
            1 + state.inputsActive
      in
        SwitchAction
          { state
              | inputsActive <-
                  inputsActive
              , condition <-
                  AntiUserInputCondition
          }

    LeavingHTMLInput ->
      let inputsActive =
            max 0 (state.inputsActive - 1)
      in
        SwitchAction
          { state
              | inputsActive <-
                  inputsActive
              , condition <-
                  if inputsActive > 0
                    then AntiUserInputCondition
                    else NormalCondition
          }

    PostNoAction ->
      SwitchAction state


workspacePostOffice : PostOfficeAction -> TrixelAction -> TrixelAction
workspacePostOffice action cachedAction =
  case cachedAction of
    SwitchAction state ->
      handlePostedAction action state

    _ ->
      cachedAction


workspaceSignals : Signal TrixelAction
workspaceSignals =
  mergeMany
    [ postOfficeQuery.signal
    , moveOffsetSignal
    , moveMouseSignal
    , keyboardSignal
    , mouseWheelSignal
    , mouseButtonSignal
    ]
  |> Signal.foldp workspacePostOffice
      (SwitchAction
        { action = None
        , condition = NormalCondition
        , inputsActive = 0
        }
      )


filterPostOfficeSignal : TrixelAction -> Bool
filterPostOfficeSignal trixelAction =
  case trixelAction of
    SwitchAction state ->
      state.condition == NormalCondition

    _ ->
      True

postOfficeSignal : Signal TrixelAction
postOfficeSignal =
  filter
    filterPostOfficeSignal
    None
    workspaceSignals


-- Different actions for the workspace 'post-office'
type PostOfficeAction
  = PostNoAction
  | PostAction TrixelAction
  | EnteringHTMLInput
  | LeavingHTMLInput