module Trixel.Views.Context (view) where

import Trixel.Models.Model as TrModel
import Trixel.Models.Work.Model as TrWorkModel
import Trixel.Graphics as TrGraphics
import Trixel.Types.Layout as TrLayout
import Trixel.Types.State as TrState

import Trixel.Views.Context.Toolbar as TrToolbar
import Trixel.Views.Context.Workspace as TrWorkspace
import Trixel.Views.Context.Home as TrHome

import Graphics.Element as Element
import Graphics.Collage as Collage

import Math.Vector2 as Vector


computetePadding : Vector.Vec2 -> Vector.Vec2 -> (Vector.Vec2, Vector.Vec2)
computetePadding global dimensions =
  let (globalX, globalY) =
        Vector.toTuple global

      (dimensionsX, dimensionsY) =
        Vector.toTuple dimensions

      paddingValue =
        (min ((max globalX globalY) * 0.005) 5)
  in
    ( Vector.vec2
        (dimensionsX - (paddingValue * 2))
        (dimensionsY - (paddingValue * 2))
    , Vector.vec2 paddingValue paddingValue
    )


computeToolbarDimensions : TrLayout.Type -> TrModel.Model -> Vector.Vec2 -> (Vector.Vec2, Vector.Vec2)
computeToolbarDimensions layout model dimensions =
  let (dimensionsX, dimensionsY) =
        Vector.toTuple dimensions

      baseHeight =
        clamp 30 75 (dimensionsY * 0.035)
  in
    case layout of
      TrLayout.Horizontal ->
        let width =
              max (dimensionsX * 0.125) 200
        in
          ( Vector.vec2
              width
              dimensionsY
          , Vector.vec2
              width
              baseHeight
          )

      TrLayout.Vertical ->
        ( Vector.vec2
            dimensionsX
            (if model.work.state == TrState.Default
              then (baseHeight * 2)
              else baseHeight
            )
        , (Vector.vec2 0 0)
        )


computeWorkspaceDimensions : TrLayout.Type -> Vector.Vec2 -> Vector.Vec2 -> (Vector.Vec2, Vector.Vec2)
computeWorkspaceDimensions layout dimensions toolDimensions  =
  let (dimensionsX, dimensionsY) =
        Vector.toTuple dimensions

      (toolDimensionsX, toolDimensionsY) =
        Vector.toTuple toolDimensions
  in
    ( case layout of
        TrLayout.Horizontal ->
          Vector.vec2
            (dimensionsX - toolDimensionsX)
            dimensionsY

        TrLayout.Vertical ->
          Vector.vec2
            dimensionsX
            (dimensionsY - toolDimensionsY)
    )
    |> computetePadding dimensions


computeFlow : TrLayout.Type -> Element.Direction
computeFlow layout =
  case layout of
    TrLayout.Horizontal ->
      Element.right

    TrLayout.Vertical ->
      Element.down


view : Vector.Vec2 -> Vector.Vec2 -> TrModel.Model -> Element.Element
view dimensions menuDimensions model =
  -- We don't have to render the toolbar/workspace when no document is open and we're in the default state
  if TrWorkModel.hasDocument model.work || model.work.state /= TrState.Default
    then
      let layout =
            TrLayout.computeType dimensions

          (toolDimensions, toolElementDimensions) =
            computeToolbarDimensions layout model dimensions
          (workDimensions, workPadding) =
            computeWorkspaceDimensions layout dimensions toolDimensions
      in
        TrGraphics.collage dimensions
          [ TrGraphics.background
              model.colorScheme.secondary.main.stroke
              dimensions
          , Element.flow
              (computeFlow layout)
              [ TrToolbar.view toolDimensions toolElementDimensions layout model
              , TrWorkspace.view workDimensions layout model
                  |> TrGraphics.applyPadding workDimensions workPadding
              ]
            |> Collage.toForm
          ]
    else
      -- Home screen is placed over the entire context as a toolbar doens't make sense in this situation
      TrGraphics.collage dimensions
        [ TrGraphics.background
            model.colorScheme.secondary.main.stroke
            dimensions
        , TrHome.view dimensions model
          |> Collage.toForm
        ]