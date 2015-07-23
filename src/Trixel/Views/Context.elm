module Trixel.Views.Context (view) where

import Trixel.Math.Vector as TrVector
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


computetePadding : TrVector.Vector -> TrVector.Vector -> (TrVector.Vector, TrVector.Vector)
computetePadding global dimensions =
  let paddingValue =
        (min ((max global.x global.y) * 0.005) 5)
  in
    ( TrVector.construct
        (dimensions.x - (paddingValue * 2))
        (dimensions.y - (paddingValue * 2))
    , TrVector.construct paddingValue paddingValue
    )


computeToolbarDimensions : TrLayout.Type -> TrModel.Model -> TrVector.Vector -> (TrVector.Vector, TrVector.Vector)
computeToolbarDimensions layout model dimensions =
  let baseHeight =
        clamp 30 75 (dimensions.y * 0.035)
  in
    case layout of
      TrLayout.Horizontal ->
        let width =
              max (dimensions.x * 0.125) 200
        in
          ( TrVector.construct
              width
              dimensions.y
          , TrVector.construct
              width
              baseHeight
          )

      TrLayout.Vertical ->
        ( TrVector.construct
            dimensions.x
            (if model.work.state == TrState.Default
              then (baseHeight * 2)
              else baseHeight
            )
        , TrVector.zeroVector
        )


computeWorkspaceDimensions : TrLayout.Type -> TrVector.Vector -> TrVector.Vector -> (TrVector.Vector, TrVector.Vector)
computeWorkspaceDimensions layout dimensions toolDimensions  =
  ( case layout of
      TrLayout.Horizontal ->
        TrVector.construct
          (dimensions.x - toolDimensions.x)
          dimensions.y

      TrLayout.Vertical ->
        TrVector.construct
          dimensions.x
          (dimensions.y - toolDimensions.y)
  )
  |> computetePadding dimensions


computeFlow : TrLayout.Type -> Element.Direction
computeFlow layout =
  case layout of
    TrLayout.Horizontal ->
      Element.right

    TrLayout.Vertical ->
      Element.down


view : TrVector.Vector -> TrVector.Vector -> TrModel.Model -> Element.Element
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