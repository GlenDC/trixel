module Trixel.Views.Context.Toolbar.Menu (view) where

import Trixel.Models.Model as TrModel

import Trixel.Types.State as TrState
import Trixel.Types.Color as TrColor
import Trixel.Types.Layout as TrLayout
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Types.Layout.Input as TrLayoutInput

import Trixel.Models.Work.Actions as TrWorkActions

import Material.Icons.Hardware as HardwareIcons

import Math.Vector2 as Vector


computeSettingsChildren : TrModel.Model -> TrColor.RgbaColor -> TrColor.RgbaColor -> Float -> Float -> List TrLayout.Generator -> List TrLayout.Generator
computeSettingsChildren model color selectionColor size padding children =
  children


computeMenuChildren : TrModel.Model -> TrColor.RgbaColor -> TrColor.RgbaColor -> Float -> Float -> List TrLayout.Generator
computeMenuChildren model color selectionColor size padding =
  let commonChildren =
        [ TrLayoutInput.svgResponsiveButton
            (TrWorkActions.SetState TrState.Default)
            selectionColor
            HardwareIcons.keyboard_arrow_return
            color
            "Return back to the editor."
            "Return"
            size padding
            [ TrKeyboard.escape ]
            True
            False
        ]
  in
    if model.work.state == TrState.Settings
      then computeSettingsChildren model color selectionColor size padding commonChildren
      else commonChildren


view : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
view model mode =
  let color = model.colorScheme.secondary.accentHigh
      selectionColor = model.colorScheme.selection.main.fill

      y = Vector.getY model.work.dimensions

      size = min (max (y * 0.03) 35) 100
      padding = size * 0.1

      flow =
        case mode of
          TrLayout.Portrait ->
            TrLayout.column

          TrLayout.Landscape ->
            TrLayout.row
  in
    computeMenuChildren model color selectionColor size padding
    |> TrLayout.equalGroup flow TrLayout.wrap []
    |> TrLayout.extend (TrLayout.background model.colorScheme.secondary.main.fill)
