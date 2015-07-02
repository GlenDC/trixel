module Trixel.Update (update) where

import Trixel.Types.General exposing (..)
import Trixel.Types.JSGlue exposing (..)
import Trixel.Types.Layer exposing (..)
import Trixel.Types.Grid exposing (..)
import Trixel.Types.Math exposing (..)
import Trixel.Types.Html exposing (..)
import Trixel.Zones.WorkSpace.Grid exposing (updateGrid, updateLayers)
import Trixel.Constants exposing (..)

import Color exposing (Color, rgba)

import Debug

update action state =
  case action of
    SetColor color ->
      updateTrixelColor color state

    SetScale scale ->
      updateScale scale state
      |> updateGrid

    SetMode mode ->
      updateMode mode state
      |> updateGrid

    ResizeWindow dimensions ->
      updateWindowDimensions dimensions state
      |> updateGrid

    MoveOffset (direction, speed) ->
      updateOffset direction speed state
      |> updateGrid
      |> update (MoveMouse state.workState.lastMousePosition)

    MoveMouse point ->
      updateMousePosition point state
      |> applyBrushAction

    ClearState ->
      clearState state
      |> updateGrid

    NewDocument ->
      (Debug.log "todo, NewDoc..." state)
      |> updateGrid

    OpenDocument ->
      (Debug.log "todo, OpenDoc..." state)
      |> updateGrid

    SaveDocument ->
      (Debug.log "todo, SaveDoc..." state)
      |> updateGrid

    SetMouseButtonsDown buttonCodeSet ->
      updateMouseButtonsDown buttonCodeSet state
      |> applyBrushAction

    SetKeyboardKeysDown keyCodeSet ->
      updateKeyboardKeysDown keyCodeSet state
      |> applyBrushAction

    SetMouseWheel value ->
      updateMouseWheel value state

    SwitchAction actionState ->
      update actionState.action
        { state
            | condition <-
                actionState.condition
        }

    UndoAction ->
      undoTimeState state
      |> updateGrid

    RedoAction ->
      redoTimeState state
      |> updateGrid

    ResetOffset ->
      resetOffset state
      |> updateGrid

    None ->
      state


clearState : State -> State
clearState state =
  update (SetScale 1) state
  |> update ResetOffset
  |> resetTimeState


updateOffset : Vector -> Float -> State -> State
updateOffset offset speed state =
  let trixelInfo =
        state.trixelInfo
      {x, y} =
        trixelInfo.offset
      relativeSpeed =
        speed * trixelInfo.scale
      newOffsetX =
        x - (offset.x * relativeSpeed)
      newOffsetY =
        y - (offset.y * relativeSpeed)
  in
    { state
        | trixelInfo <-
            { trixelInfo |
                offset <-
                  { x =
                      newOffsetX
                  , y =
                      newOffsetY
                  }
            }
    }


comparePositions : Vector -> Vector -> Bool
comparePositions a b =
  (round a.x) == (round b.x)
    && (round a.y) == (round b.y)


compareTrixels : Trixel -> Trixel -> Bool
compareTrixels trixelA trixelB =
  (comparePositions trixelA.position trixelB.position)
    && compareColors trixelA.color trixelB.color


applyLeftButtonDownAction : Vector -> State -> State
applyLeftButtonDownAction position state =
  let timeState =
        getTimeState state

      workState =
          state.workState
  in
    if | isKeyCodeInSet keyCodeAlt state.actions.keysDown ->
          -- ColorPicker Brush
          let maybeTrixel =
                findTrixel
                  position
                  timeState.currentLayer
                  timeState.layers
          in
            { state
                | trixelColor <-
                    case maybeTrixel of
                      Just trixel ->
                        trixel.color

                      _ ->
                        state.colorScheme.workbg.elm
            }

      | otherwise ->
        -- Paint Brush
        let maybeTrixel =
              findTrixel
                position
                timeState.currentLayer
                timeState.layers

            currentTrixel =
              case maybeTrixel of
                Just trixel ->
                  trixel

                _ ->
                  constructNewTrixel
                    { x = 2 + position.x
                    , y = 0
                    }
                    (rgba 0 0 0 0)

            blendedColor =
              computeAlphaBlend currentTrixel.color state.trixelColor

            newTrixel =
              constructNewTrixel
                position
                blendedColor
        in
          if compareTrixels
                currentTrixel
                newTrixel
          then
            state -- same position as last time
          else
            updateCachedTimeState
               { timeState
                  | layers <-
                      insertTrixel
                        newTrixel
                        timeState.currentLayer
                        timeState.layers
               }
               state


applyLeftButtonPressedAction : Vector -> State -> State
applyLeftButtonPressedAction position state =
  applyCachedTimeState
    state
  |> updatePreviousButtonsDown


applyRightButtonDownAction : Vector -> State -> State
applyRightButtonDownAction position state =
  let timeState =
        getTimeState state

      workState =
          state.workState

      maybeTrixel =
        findTrixel
          position
          timeState.currentLayer
          timeState.layers
  in
    -- Erase Brush
    case maybeTrixel of
      Just _ ->
        updateCachedTimeState
           { timeState
              | layers <-
                  eraseTrixel
                    position
                    timeState.currentLayer
                    timeState.layers
           }
           state

      _ ->
        state


applyRightButtonPressedAction : Vector -> State -> State
applyRightButtonPressedAction position state =
  applyCachedTimeState
    state
  |> updatePreviousButtonsDown


updatePreviousButtonsDown : State -> State
updatePreviousButtonsDown state =
  let actions =
        state.actions
  in
    { state
        | actions <-
            { actions
                | previousButtonsDown <- actions.buttonsDown
            }
    }

applyButtonsAction : Vector -> State -> State
applyButtonsAction position state =
  case computeButtonState buttonCodeLeft state.actions.buttonsDown state.actions.previousButtonsDown of
    ButtonDown ->
      applyLeftButtonDownAction position state

    ButtonPressed ->
      applyLeftButtonPressedAction position state

    _ ->
      case computeButtonState buttonCodeRight state.actions.buttonsDown state.actions.previousButtonsDown of
        ButtonDown ->
          applyRightButtonDownAction position state

        ButtonPressed ->
          applyRightButtonPressedAction position state

        _ ->
          state  -- nothng to do...

applyMouseDragAction : MouseDragState -> State -> State
applyMouseDragAction mouseDragState state =
  if | isKeyCodeInSet keyCodeCtrl state.actions.keysDown ->
         updateScale
           (state.trixelInfo.scale + (0.005 * mouseDragState.difference.y))
           state

     | otherwise ->
         updateOffset
           mouseDragState.difference
           (workspaceOffsetMouseMoveSpeed * (state.trixelInfo.scale + (1 - state.trixelInfo.scale)))
           state


applyBrushAction : State -> State
applyBrushAction state =
  (case state.mouseState of
    MouseNone ->
      state

    MouseHover position ->
      applyButtonsAction position state

    MouseDrag mouseDragState ->
       (if isButtonCodeInSet buttonCodeLeft state.actions.buttonsDown
          then
             applyMouseDragAction mouseDragState state
             |> updateGrid
          else
             state -- nothng to do...
        )
  ) |> updateLayers


resetOffset : State -> State
resetOffset state =
  let trixelInfo =
        state.trixelInfo
  in
    { state
        | trixelInfo <-
            { trixelInfo
                | offset <- zeroVector
            }
    }


checkForSoloShortcuts : KeyCodeSet -> State -> State
checkForSoloShortcuts previousKeyCodeSet state =
  if  | isKeyCodeJustInSet shortcutR state.actions.keysDown previousKeyCodeSet ->
          update ResetOffset state

      | otherwise ->
          state


checkForCtrlShortcutCombinations : KeyCodeSet -> State -> State
checkForCtrlShortcutCombinations previousKeyCodeSet state =
   if | isKeyCodeJustInSet shortcutZ state.actions.keysDown previousKeyCodeSet ->
          update UndoAction state

      | otherwise ->
          state


checkForCtrlShiftShortcutCombinations : KeyCodeSet -> State -> State
checkForCtrlShiftShortcutCombinations previousKeyCodeSet state =
   if | isKeyCodeJustInSet shortcutZ state.actions.keysDown previousKeyCodeSet ->
          update RedoAction state

      | otherwise ->
          state


checkForCtrlAltShortcutCombinations : KeyCodeSet -> State -> State
checkForCtrlAltShortcutCombinations previousKeyCodeSet state =
   if | isKeyCodeJustInSet shortcutMinus state.actions.keysDown previousKeyCodeSet ->
          update
            (SetScale (state.trixelInfo.scale - 0.1))
            state

      | isKeyCodeJustInSet shortcutEqual state.actions.keysDown previousKeyCodeSet ->
          update
            (SetScale (state.trixelInfo.scale + 0.1))
            state


      | otherwise ->
          state


updateMouseButtonsDown : ButtonCodeSet -> State -> State
updateMouseButtonsDown buttonCodeSet state =
  let actions =
        state.actions
  in
    { state
        | actions <-
            { actions
                | buttonsDown <- buttonCodeSet
                , previousButtonsDown <- actions.buttonsDown
            }
    }


updateMouseWheel : Float -> State -> State
updateMouseWheel delta state =
  let scale =
        if | delta < 0 ->
              state.trixelInfo.scale + 0.05

           | delta > 0 ->
              state.trixelInfo.scale - 0.05

           | otherwise ->
              state.trixelInfo.scale
  in
    if isKeyCodeInSet keyCodeCtrl state.actions.keysDown
      then update (SetScale scale) state
      else state


updateKeyboardKeysDown : KeyCodeSet -> State -> State
updateKeyboardKeysDown keyCodeSet state =
  let actions =
        state.actions

      newState =
        { state
            | actions <-
                { actions
                    | keysDown <- keyCodeSet
                }
        }
  in
    if | isKeyCodeInSet keyCodeCtrl keyCodeSet ->
          if isKeyCodeInSet keyCodeShift keyCodeSet
            then
              checkForCtrlShiftShortcutCombinations state.actions.keysDown newState
            else
              if isKeyCodeInSet keyCodeAlt keyCodeSet
                then
                  checkForCtrlAltShortcutCombinations state.actions.keysDown newState
                else
                  checkForCtrlShortcutCombinations state.actions.keysDown newState

       | otherwise ->
          checkForSoloShortcuts state.actions.keysDown newState


updateMousePosition : Vector -> State -> State
updateMousePosition point state =
  if isKeyCodeInSet keyCodeSpace state.actions.keysDown
    then
      let mousePointDifference =
            case state.mouseState of
              MouseDrag mouseDragState ->
                { x = point.x - mouseDragState.position.x
                , y = mouseDragState.position.y - point.y
                }

              _ ->
                zeroVector
      in
        { state
            | mouseState <-
                MouseDrag
                  { position = point
                  , difference = mousePointDifference
                  }
        }
    else
      let padding =
            state.boxModels.workspace.padding
          margin =
            state.boxModels.workspace.margin

          (menuOffsetX, menuOffsetY) =
            computeDimensionsFromBoxModel state.boxModels.menu

          cursorMinX =
            padding.x + margin.x
          cursorMinY =
            padding.y + margin.y + menuOffsetY

          cursorMaxX =
            cursorMinX + state.boxModels.workspace.width
          cursorMaxY =
            cursorMinY + state.boxModels.workspace.height

          workState =
            state.workState
      in
        if not
            (point.x >= cursorMinX && point.x <= cursorMaxX
              && point.y >= cursorMinY && point.y <= cursorMaxY)
        then
          { state
                | mouseState <-
                    MouseNone
                , workState <-
                    { workState
                      | lastMousePosition <-
                          point
                    }
            }
        else
          let trixelInfo =
                state.trixelInfo

              trixelOffset =
                { x = (trixelInfo.dimensions.x / 2) - trixelInfo.offset.x
                , y = (trixelInfo.dimensions.y / 2) - trixelInfo.offset.y }

              cursorX =
                point.x - cursorMinX - trixelOffset.x
              cursorY =
                trixelInfo.dimensions.y - (point.y - cursorMinY) - trixelOffset.y

              (triangleWidth, triangleHeight, cursorOffsetX, cursorOffsetY) =
                if state.trixelInfo.mode == ClassicMode
                  then
                    ( state.trixelInfo.width
                    , state.trixelInfo.height
                    , state.trixelInfo.width
                    , state.trixelInfo.height / 2
                    )
                  else
                    ( state.trixelInfo.height
                    , state.trixelInfo.width
                    , state.trixelInfo.height / 2
                    , state.trixelInfo.width
                    )

              pointX =
                (cursorX - cursorOffsetX) / triangleWidth
                |> round |> toFloat
              pointY =
                (cursorY - cursorOffsetY) / triangleHeight
                |> round |> toFloat
          in
            { state
                | mouseState <-
                    MouseHover
                      { x = pointX
                      , y = pointY
                      }
                , workState <-
                    { workState
                      | lastMousePosition <-
                          point
                    }
            }


updateScale : Float -> State -> State
updateScale scale state =
  let trixelInfo =
        state.trixelInfo
  in
    { state
        | trixelInfo <-
            { trixelInfo
                | scale <-
                    max 0.05 scale
            }
    }


updateWindowDimensions : Vector -> State -> State
updateWindowDimensions dimensions state =
  let menu =
        constructBoxModel
          dimensions.x (clamp 40 80 (dimensions.y * 0.04))
          5 5
          0 0
          BorderBox
      footer =
        constructBoxModel
          (dimensions.x - 10) footerSize
          5 8
          0 0
          ContentBox
      workspace =
        constructBoxModel
          (dimensions.x - 40) (dimensions.y - menu.height - footerSize - 16 - 40)
          20 20
          0 0
          ContentBox
  in
    { state
        | boxModels <-
            { menu =
                menu
            , workspace =
                workspace
            , footer =
                footer
            }
        , windowDimensions <-
            dimensions
    }


updateTrixelColor : Color -> State -> State
updateTrixelColor color state =
  let glueState =
        state.glueState
  in
    { state
      | trixelColor <-
          color
      , glueState <-
          { glueState
              | trixelColor <-
                  elmToHtmlColor color
          }
    }


updateMode : TrixelMode -> State -> State
updateMode mode state =
  let trixelInfo =
        state.trixelInfo
  in
    { state
        | trixelInfo <-
            { trixelInfo
                | mode <-
                    mode
            }
    }