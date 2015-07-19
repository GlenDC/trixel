module Trixel.Views.Context (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Models.Model as TrModel
import Trixel.Graphics as TrGraphics
import Trixel.Types.Layout as TrLayout

import Trixel.Views.Context.Toolbar as TrToolbar
import Trixel.Views.Context.Workspace as TrWorkspace

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


computeToolbarDimensions : TrLayout.Type -> TrVector.Vector -> TrVector.Vector
computeToolbarDimensions layout dimensions =
  ( case layout of
      TrLayout.Horizontal ->
        TrVector.construct
          (max (dimensions.x * 0.125) 200)
          dimensions.y

      TrLayout.Vertical ->
        TrVector.construct
          dimensions.x
          (dimensions.y * 0.1)
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


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  let layout =
        TrLayout.computeType dimensions

      toolDimensions =
        computeToolbarDimensions layout dimensions
      (workDimensions, workPadding) =
        computeWorkspaceDimensions layout dimensions toolDimensions
  in
    TrGraphics.collage dimensions
      [ TrGraphics.background
          model.colorScheme.secondary.main.stroke
          dimensions
      , Element.flow
          (computeFlow layout)
          [ TrToolbar.view toolDimensions layout model
          , TrWorkspace.view workDimensions layout model
              |> TrGraphics.applyPadding workDimensions workPadding
          ]
        |> Collage.toForm
      ]