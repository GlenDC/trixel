module Trixel.Views.Context.Toolbar.Vertical (view) where

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


viewMenuButton render label help shortcut selected size model address action =
  TrGraphics.svgButton
    render
    (Just label)
    help
    shortcut
    selected
    size
    model.colorScheme.secondary.accentHigh
    model.colorScheme.selection.accentHigh
    model.colorScheme.secondary.main.fill
    model.colorScheme.selection.main.fill
    address
    action


editorToolbar : TrVector.Vector -> TrModel.Model -> Element.Element
editorToolbar dimensions model =
  Element.empty


menuToolbar : TrVector.Vector -> TrModel.Model -> Element.Element
menuToolbar dimensions model =
  Element.flow
    Element.right
    [ viewMenuButton
        HardwareIcons.keyboard_arrow_return
        "Return"
        "Return back to the editor."
        [ TrKeyboard.escape ]
        False
        dimensions.y
        model
        TrWork.address
        (TrWorkActions.SetState TrState.Default)
    ]
  |> TrGraphics.setDimensions dimensions


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  Collage.group
    [ TrGraphics.background model.colorScheme.secondary.main.fill dimensions
    , (case model.work.state of
        TrState.Default ->
          editorToolbar dimensions model

        _ ->
          menuToolbar dimensions model
      ) |> Collage.toForm
    ]
    |> TrGraphics.toElement dimensions