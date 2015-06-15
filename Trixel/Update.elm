module Trixel.Update (update) where

import Trixel.Types exposing (..)
import Trixel.Constants exposing (..)
import Trixel.Grid exposing (updateGrid)

import Debug

resetState: State -> State
resetState state =
  let trixelInfo = state.trixelInfo
  in { state | trixelInfo <- { trixelInfo |
        count <- { x = 1, y = 1 },
        mode <- Vertical } }

updateOffset: FloatVec2D -> State -> State
updateOffset offset state =
  if state.trixelInfo.scale <= 1 then state else
    let trixelInfo = state.trixelInfo
        {x, y} = trixelInfo.offset
        nox = x + (offset.x * moveSpeed)
        noy = y + (offset.y * moveSpeed)
    in
      { state | trixelInfo <-
        { trixelInfo | offset <- { x = nox, y = noy } } }

updateMousePosition: FloatVec2D -> State -> State
updateMousePosition point state =
  let bounds = state.trixelInfo.bounds
      (minX, minY) = (toFloat bounds.min.x, toFloat bounds.min.y)
      (maxX, maxY) = (toFloat bounds.max.x, toFloat bounds.max.y)
      (x, y) = (point.x - minX, point.y - minY)
  in
    { state |
      mouseState <- if x >= 0 && y >= 0 && x <= maxX - minX && y <= maxY - minY
      then MouseHover { x = x, y = y }
      else MouseNone
      }

updateScale: Float -> State -> State
updateScale scale state =
  let trixelInfo = state.trixelInfo
  in
    { state | trixelInfo <-
      { trixelInfo |
        scale <- scale,
        offset <- if scale <= 1 then { x = 0, y = 0 }
                  else trixelInfo.offset } }

updateDimensions: FloatVec2D -> State -> State
updateDimensions dimensions state =
  let menu = dimensionContext dimensions.x (clamp 40 80 (dimensions.y * 0.04)) (5, 5) (0, 0)
      footer = dimensionContext dimensions.x footerSize (0, 0) (5, 8)
      workspace = dimensionContext dimensions.x (dimensions.y - menu.h - footerSize) (0, 0) (20, 20)
  in
    { state |
      html <- {
        dimensions = {
          menu = menu,
          workspace = workspace,
          footer = footer
          } },
      dimensions <- dimensions }

updateGridX: Int -> State -> State
updateGridX x state =
  let trixelInfo = state.trixelInfo
  in
    { state | trixelInfo <-
      { trixelInfo |
        count <- { x = x, y = trixelInfo.count.y } } }

updateGridY: Int -> State -> State
updateGridY y state =
  let trixelInfo = state.trixelInfo
  in
    { state | trixelInfo <-
      { trixelInfo |
        count <- { x = trixelInfo.count.x, y = y } } }

updateMode: TrixelMode -> State -> State
updateMode mode state =
  let trixelInfo = state.trixelInfo
  in
    { state | trixelInfo <-
      { trixelInfo | mode <- mode } }

update action state =
  (case action of
    SetGridX x -> updateGridX x state |> updateGrid
    SetGridY y -> updateGridY y state |> updateGrid
    SetScale scale -> updateScale scale state |> updateGrid
    SetMode mode -> updateMode mode state |> updateGrid
    Resize dimensions -> updateDimensions dimensions state |> updateGrid
    MoveOffset point -> updateOffset point state |> updateGrid
    MoveMouse point -> updateMousePosition point state
    NewDoc -> resetState state  |> updateGrid
    OpenDoc -> (Debug.log "todo, OpenDoc..." state) |> updateGrid
    SaveDoc -> (Debug.log "todo, SaveDoc..." state) |> updateGrid
    SaveDocAs -> (Debug.log "todo, SaveDocAs..." state)) |> updateGrid
