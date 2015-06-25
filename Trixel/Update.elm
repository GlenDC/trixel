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

    SetCondition condition ->
      updateCondition condition state

    ResizeWindow dimensions ->
      updateWindowDimensions dimensions state
      |> updateGrid

    MoveOffset point ->
      updateOffset point state
      |> updateGrid
      |> update (MoveMouse state.workState.lastMousePosition)

    MoveMouse point ->
      updateMousePosition point state
      |> applyBrushAction

    NewDocument ->
      resetState state
      |> updateGrid

    OpenDocument ->
      (Debug.log "todo, OpenDoc..." state)
      |> updateGrid

    SaveDocument ->
      (Debug.log "todo, SaveDoc..." state)
      |> updateGrid

    BrushSwitch isActive ->
      updateBrushAction isActive state
      |> applyBrushAction

    ErasingSwitch isErasing ->
      updateErasingAction isErasing state
      |> applyBrushAction

    ToggleGridVisibility ->
      toggleGridVisibility state

    SwitchAction actionState ->
      update actionState.action state

    None ->
      state


resetState : State -> State
resetState state =
  let trixelInfo =
        state.trixelInfo
  in
    { state
        | trixelInfo <-
            { trixelInfo
                | count <-
                    { x = 10, y = 10 }
                , scale <-
                    1
            }
        , currentLayer <-
            0
        , layers <-
            insertNewLayer 0 []
    }


updateOffset : Vector -> State -> State
updateOffset offset state =
  if state.trixelInfo.scale <= 1
    then state
    else
      let trixelInfo =
            state.trixelInfo
          {x, y} =
            trixelInfo.offset
          newOffsetX =
            x + (offset.x * workspaceOffsetMoveSpeed)
          newOffsetY =
            y + (offset.y * workspaceOffsetMoveSpeed)
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


applyBrushAction : State -> State
applyBrushAction state =
  (case state.mouseState of
    MouseNone ->
      state

    MouseHover position ->
      if state.actions.isBrushActive
        then
          let workState =
                state.workState
          in
            if state.actions.isErasing
              then -- Erase
                if comparePositions
                      workState.lastErasePosition
                      position
                then
                  state -- same position as last time
                else
                  { state
                      | layers <-
                          (eraseTrixel
                            position
                            state.currentLayer
                            state.layers)
                      , workState <-
                          { workState
                              | lastErasePosition <-
                                  position
                          }
                  }
              else -- Paint
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
                        | layers <-
                            (insertTrixel
                              (constructNewTrixel position state.trixelColor)
                              state.currentLayer
                              state.layers)
                        , workState <-
                            { workState
                                | lastPaintedTrixel <-
                                    newTrixel
                            }
                    }
        else
          state)
  |> updateLayers


updateBrushAction : Bool -> State -> State
updateBrushAction isActive state =
  let actions =
        state.actions
  in
    { state
        | actions <-
            { actions
                | isBrushActive <- isActive
            }
    }


toggleGridVisibility : State -> State
toggleGridVisibility state =
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


updateErasingAction : Bool -> State -> State
updateErasingAction isErasing state =
  let actions =
        state.actions
  in
    { state
        | actions <-
            { actions
                | isErasing <- isErasing
            }
    }


updateMousePosition : Vector -> State -> State
updateMousePosition point state =
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

      cursorX =
        point.x - padding.x - margin.x - offsetX - state.trixelInfo.offset.x
      cursorY =
        state.trixelInfo.dimensions.y
          - (point.y - padding.y - margin.y - menuOffsetY - offsetY)
          - state.trixelInfo.offset.y

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
  in
    { state
        | mouseState <-
          if pointX >= 0 && pointX < state.trixelInfo.count.x
            && pointY >= 0 && pointY < state.trixelInfo.count.y
            then MouseHover { x = pointX, y = pointY}
            else MouseNone
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
                , offset <-
                    if scale <= 1
                      then zeroVector
                      else trixelInfo.offset
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
  let trixelInfo =
        state.trixelInfo
  in
    { state
        | trixelInfo <-
            { trixelInfo
                | count <-
                    { x =
                        max 1 x |> min maxTrixelRowCount
                    , y =
                        trixelInfo.count.y
                    }
            }
    }
    |> updateWorkGridColumns


updateGridY : Float -> State -> State
updateGridY y state =
  let trixelInfo =
        state.trixelInfo
  in
    { state
        | trixelInfo <-
            { trixelInfo
                | count <-
                    { x = trixelInfo.count.x
                    , y = max 1 y |> min maxTrixelRowCount
                    }
            }
    }
    |> updateWorkGridRows


updateTrixelColor : Color -> State -> State
updateTrixelColor color state =
   { state
      | trixelColor <-
          color
    }



updateWorkGridRows : State -> State
updateWorkGridRows state =
  { state
      | layers <-
          (eraseLayerRowByPosition
            (round state.trixelInfo.count.y)
            state.layers)
  }


updateWorkGridColumns : State -> State
updateWorkGridColumns state =
  { state
      | layers <-
          (eraseLayerTrixelByPosition
            (round state.trixelInfo.count.x)
            state.layers)
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


updateCondition : Condition -> State -> State
updateCondition condition state =
  { state
      | condition <-
          condition
  }