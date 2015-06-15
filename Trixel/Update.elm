module Trixel.Update (update) where

import Trixel.Types exposing (..)
import Trixel.Constants exposing (..)

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
  state

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
  state

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
  case action of
    SetGridX x -> updateGridX x state
    SetGridY y -> updateGridY y state
    SetScale scale -> updateScale scale state
    SetMode mode -> updateMode mode state
    Resize dimensions -> updateDimensions dimensions state
    MoveOffset point -> updateOffset point state
    MoveMouse point -> updateMousePosition point state
    NewDoc -> resetState state
    OpenDoc -> (Debug.log "todo, OpenDoc..." state)
    SaveDoc -> (Debug.log "todo, SaveDoc..." state)
    SaveDocAs -> (Debug.log "todo, SaveDocAs..." state)