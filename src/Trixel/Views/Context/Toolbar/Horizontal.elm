module Trixel.Views.Context.Toolbar.Horizontal (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Models.Model as TrModel
import Trixel.Models.Work as TrWork
import Trixel.Models.Work.Actions as TrWorkActions
import Trixel.Types.Layout as TrLayout
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Types.State as TrState
import Trixel.Graphics as TrGraphics

import Graphics.Element as Element
import Graphics.Collage as Collage

import Material.Icons.Hardware as HardwareIcons


viewButton render label help shortcuts selected dimensions model address action =
  TrGraphics.svgVerticalButton
    render
    label
    help
    shortcuts
    selected
    dimensions
    model.colorScheme.secondary.accentHigh
    model.colorScheme.selection.accentHigh
    model.colorScheme.secondary.main.stroke
    model.colorScheme.selection.main.fill
    address
    action


editorToolbar : TrVector.Vector -> TrVector.Vector -> TrModel.Model -> Element.Element
editorToolbar dimensions elementDimensions model =
  Element.empty


menuToolbar : TrVector.Vector -> TrVector.Vector -> TrModel.Model -> Element.Element
menuToolbar dimensions elementDimensions model =
  Element.flow
    Element.down
    [ viewButton
        HardwareIcons.keyboard_arrow_return
        "Return"
        "Return back to the editor."
        [ TrKeyboard.escape ]
        (model.work.state == TrState.Default)
        elementDimensions model TrWork.address
        (TrWorkActions.SetState TrState.Default)
    , Element.spacer
        (round elementDimensions.x)
        (round (elementDimensions.y * 0.25))
    ]
  |> TrGraphics.setDimensions dimensions


view : TrVector.Vector -> TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions elementDimensions model =
  Collage.group
    [ TrGraphics.background model.colorScheme.secondary.main.fill dimensions
    , (case model.work.state of
        TrState.Default ->
          editorToolbar dimensions elementDimensions model

        _ ->
          menuToolbar dimensions elementDimensions model
      ) |> Collage.toForm
    ]
    |> TrGraphics.toElement dimensions