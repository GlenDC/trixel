module Trixel.Views.Context.Toolbar (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Models.Model as TrModel
import Trixel.Models.Work as TrWork
import Trixel.Models.Work.Actions as TrWorkActions
import Trixel.Types.Layout as TrLayout
import Trixel.Types.State as TrState
import Trixel.Graphics as TrGraphics

import Graphics.Element as Element
import Graphics.Collage as Collage

import Material.Icons.Hardware as HardwareIcons


viewButton render label help selected dimensions model address action =
  TrGraphics.svgVerticalButton
    render
    label
    help
    selected
    dimensions
    model.colorScheme.secondary.accentHigh
    model.colorScheme.selection.accentHigh
    model.colorScheme.secondary.main.stroke
    model.colorScheme.selection.main.fill
    address
    action


editorVertical : TrVector.Vector -> TrVector.Vector -> TrModel.Model -> Element.Element
editorVertical dimensions menuDimensions model =
  Element.empty --todo


subMenuVertical : TrVector.Vector -> TrModel.Model -> Element.Element
subMenuVertical dimensions model =
  Element.empty --todo


menuVertical : TrVector.Vector -> TrVector.Vector -> TrModel.Model -> Element.Element
menuVertical dimensions menuDimensions model =
  Element.empty -- todo


editorHorizontal : TrVector.Vector -> TrVector.Vector -> TrModel.Model -> Element.Element
editorHorizontal dimensions menuDimensions model =
  Element.empty --todo


subMenuHorizontal : TrVector.Vector -> TrModel.Model -> Element.Element
subMenuHorizontal dimensions model =
  Element.empty --todo


menuHorizontal : TrVector.Vector -> TrVector.Vector -> TrModel.Model -> Element.Element
menuHorizontal dimensions menuDimensions model =
  let buttonDimensions =
        TrVector.construct
          dimensions.x
          (menuDimensions.y * 1.25)
  in
    Element.flow
      Element.down
      [ viewButton
          HardwareIcons.keyboard_arrow_return "Return" "Return back to the editor."
          (model.work.state == TrState.Default)
          buttonDimensions model TrWork.address
          (TrWorkActions.SetState TrState.Default)
      , Element.spacer
          (round buttonDimensions.x)
          (round (buttonDimensions.y * 0.25))
      , subMenuHorizontal dimensions model
      ]
    |> TrGraphics.setDimensions dimensions


viewVertical : TrVector.Vector -> TrVector.Vector -> TrModel.Model -> Element.Element
viewVertical dimensions menuDimensions model =
  Collage.group
    [ TrGraphics.background model.colorScheme.secondary.main.fill dimensions
    , ( if model.work.state == TrState.Default
          then editorVertical dimensions menuDimensions model
          else menuVertical dimensions menuDimensions model
      ) |> Collage.toForm
    ]
  |> TrGraphics.toElement dimensions


viewHorizontal : TrVector.Vector -> TrVector.Vector -> TrModel.Model -> Element.Element
viewHorizontal dimensions menuDimensions model =
  Collage.group
    [ TrGraphics.background model.colorScheme.secondary.main.fill dimensions
    , ( if model.work.state == TrState.Default
          then editorHorizontal dimensions menuDimensions model
          else menuHorizontal dimensions menuDimensions model
      ) |> Collage.toForm
    ]
  |> TrGraphics.toElement dimensions


view : TrVector.Vector -> TrVector.Vector -> TrLayout.Type -> TrModel.Model -> Element.Element
view dimensions menuDimensions layout model =
  case layout of
    TrLayout.Horizontal ->
      viewHorizontal dimensions menuDimensions model

    TrLayout.Vertical ->
      viewVertical dimensions menuDimensions model