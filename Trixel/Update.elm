module Trixel.Update (update) where

import Trixel.Types.General exposing (..)
import Trixel.Types.Layer exposing (..)
import Trixel.Types.Grid exposing (..)
import Trixel.Types.Math exposing (..)
import Trixel.Types.Html exposing (..)
import Trixel.Zones.WorkSpace.Grid exposing (updateGrid, updateLayers)
import Trixel.Constants exposing (..)

import Color exposing (Color)

import Debug

update action state =
  case action of
    SetGridX x ->
      updateGridX x state
      |> updateGrid

    SetGridY y ->
      updateGridY y state
      |> updateGrid

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
        x + (offset.x * relativeSpeed)
      newOffsetY =
        y + (offset.y * relativeSpeed)
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
  && (trixelA.color == trixelB.color)


applyLeftButtonDownAction : Vector -> State -> State
applyLeftButtonDownAction position state =
  let timeState =
        getTimeState state

      workState =
          state.workState
  in
    if | isKeyCodeInSet keyCodeCtrl state.actions.keysDown ->
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
        let newTrixel =
              constructNewTrixel position state.trixelColor
        in
          if compareTrixels
                workState.lastPaintedTrixel
                newTrixel
          then
            state -- same position as last time
          else
            { state
                | workState <-
                    { workState
                        | lastPaintedTrixel <-
                            newTrixel
                    }
            }
            |> updateCachedTimeState
                 { timeState
                    | layers <-
                        insertTrixel
                          (constructNewTrixel position state.trixelColor)
                          timeState.currentLayer
                          timeState.layers
                 }


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
  in
    -- Erase Brush
    if comparePositions
        workState.lastErasePosition
        position
    then
      state -- same position as last time
    else
      { state
          | workState <-
              { workState
                  | lastErasePosition <-
                      position
              }
      }
      |> updateCachedTimeState
           { timeState
              | layers <-
                  eraseTrixel
                    position
                    timeState.currentLayer
                    timeState.layers
           }


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
  let count =
        getTrixelCount state
  in
    if position.x >= 0 && position.x < count.x
         && position.y >= 0 && position.y < count.y
      then
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
        else
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
             (updateOffset
                mouseDragState.difference
                workspaceOffsetMouseMoveSpeed
                state
             |> updateGrid)
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
  if | isKeyCodeJustInSet shortcutG state.actions.keysDown previousKeyCodeSet ->
          let userSettings =
              state.userSettings
          in
            { state
                | userSettings <-
                    { userSettings
                        | showGrid <-
                            not userSettings.showGrid
                    }
            }

      | isKeyCodeJustInSet shortcutR state.actions.keysDown previousKeyCodeSet ->
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
            (SetScale (max 0.05 (state.trixelInfo.scale - 0.1)))
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

          offsetX =
            (state.boxModels.workspace.width - state.trixelInfo.dimensions.x) / 2
          offsetY =
            (state.boxModels.workspace.height - state.trixelInfo.dimensions.y) / 2

          (menuOffsetX, menuOffsetY) =
            computeDimensionsFromBoxModel state.boxModels.menu

          trixelOffset =
            state.trixelInfo.offset

          cursorX =
            point.x - padding.x - margin.x - offsetX - trixelOffset.x
          cursorY =
            state.trixelInfo.dimensions.y
              - (point.y - padding.y - margin.y - menuOffsetY - offsetY)
              - trixelOffset.y

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

          workState =
            state.workState

          trixelCount =
            getTrixelCount state
      in
        { state
            | mouseState <-
              if pointX >= 0 && pointX < trixelCount.x
                    && pointY >= 0 && pointY < trixelCount.y
                then
                  MouseHover
                    { x = pointX
                    , y = pointY
                    }
                else
                  MouseNone
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
                    |> min 2
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


updateGridX : Float -> State -> State
updateGridX x state =
  let timeState =
        getTimeState state

      newCountX =
        max 1 x |> min maxTrixelRowCount
  in
    updateTimeState
      { timeState
          | trixelCount <-
              { x =
                  newCountX
              , y =
                  timeState.trixelCount.y
              }
          , layers <-
              eraseLayerTrixelByPosition
                (round newCountX)
                timeState.layers
      }
      state


updateGridY : Float -> State -> State
updateGridY y state =
  let timeState =
        getTimeState state

      newCountY =
        max 1 y |> min maxTrixelRowCount
  in
    updateTimeState
      { timeState
          | trixelCount <-
              { x =
                  timeState.trixelCount.x
              , y =
                  newCountY
              }
          , layers <-
              eraseLayerRowByPosition
                (round newCountY)
                timeState.layers
      }
      state


updateTrixelColor : Color -> State -> State
updateTrixelColor color state =
   { state
      | trixelColor <-
          color
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