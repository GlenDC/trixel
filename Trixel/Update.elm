module Trixel.Update (update) where

import Trixel.Types.General exposing (..)
import Trixel.Types.Math exposing (..)
import Trixel.Types.Html exposing (..)
import Trixel.Zones.WorkSpace.Grid exposing (updateGrid)
import Trixel.Constants exposing (..)

import Debug

update action state =
  case action of
    SetGridX x ->
      updateGridX x state
      |> updateGrid

    SetGridY y ->
      updateGridY y state
      |> updateGrid

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

    MoveMouse point ->
      updateMousePosition point state

    NewDocument ->
      resetState state
      |> updateGrid

    OpenDocument ->
      (Debug.log "todo, OpenDoc..." state)
      |> updateGrid

    SaveDocument ->
      (Debug.log "todo, SaveDoc..." state)
      |> updateGrid

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
            { trixelInfo |
                count <- { x = 1, y = 1 },
                mode <- Vertical
            }
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


updateMousePosition : Vector -> State -> State
updateMousePosition point state =
  let padding =
        state.boxModels.workspace.padding
      margin =
        state.boxModels.workspace.margin

      bounds =
        state.trixelInfo.bounds

      width =
        bounds.max.x - bounds.min.x
      height =
        bounds.max.y - bounds.min.y

      offsetX =
        (state.boxModels.workspace.width - width) / 2
      offsetY =
        (state.boxModels.workspace.height - height) / 2

      (menuOffsetX, menuOffsetY) =
        computeDimensionsFromBoxModel state.boxModels.menu

      cursorX =
        point.x - padding.x - margin.x - offsetX
      cursorY =
        height - (point.y - padding.y - margin.y - menuOffsetY - offsetY)

      (triangleWidth, triangleHeight, cursorOffsetX, cursorOffsetY) =
        if state.trixelInfo.mode == Vertical
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
    { state |
        mouseState <-
          if pointX >= 0 && pointX < state.trixelInfo.count.x
            && pointY >= 0 && pointY < state.trixelInfo.count.y
            then MouseHover { x = pointX, y = pointY}
            else MouseNone
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