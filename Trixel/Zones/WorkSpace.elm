module Trixel.Zones.WorkSpace (view) where

import Trixel.Types.ColorScheme exposing (ColorScheme)
import Trixel.Types.General exposing (..)
import Trixel.Types.Math exposing (..)
import Trixel.Types.Html exposing (..)
import Trixel.PostOffice exposing (..)
import Trixel.Constants exposing (..)
import Trixel.Zones.WorkSpace.Grid exposing (renderMouse)

import Html exposing (Html, Attribute, div, fromElement)
import Html.Attributes exposing (style, class)

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)


view : State -> Html
view state =
  div
    [ constructMainStyle state
    , class "noselect"
    ]
    [ viewWorkSpace state ]


constructMainStyle : State -> Attribute
constructMainStyle state =
  let workspace =
        state.boxModels.workspace

      cursor =
        case state.mouseState of
          MouseHover _ ->
            if isKeyCodeInSet keyCodeCtrl state.actions.keysDown
              then "copy"
              else "pointer"

          MouseDrag _ ->
            "move"

          _ ->
            "default"

  in
    ("cursor", cursor) :: (computeBoxModelCSS workspace)
    |> style


viewWorkSpace : State -> Html
viewWorkSpace state =
  let workspace =
        state.boxModels.workspace
  in
    state.renderCache.layers ++
      (renderMouse state workspace.width workspace.height
        ( if state.userSettings.showGrid
          then state.renderCache.grid
          else []
          )
        )
    |> collage (round workspace.width) (round workspace.height)
    |> fromElement