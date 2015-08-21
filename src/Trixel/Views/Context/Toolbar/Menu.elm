module Trixel.Views.Context.Toolbar.Menu (view) where

import Trixel.Models.Model as TrModel

import Trixel.Types.State as TrState
import Trixel.Types.Color as TrColor
import Trixel.Types.Layout as TrLayout
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Types.Input as TrInput
import Trixel.Types.Layout.Input as TrLayoutInput
import Trixel.Types.Layout.Graphics as TrGraphics

import Trixel.Models.Work.Actions as TrWorkActions

import Material.Icons.Navigation as NavigationIcons

import Math.Vector2 as Vector


responsiveButton : TrWorkActions.Action -> TrGraphics.SvgGenerator -> String -> String -> Float -> Float -> TrInput.Buttons -> TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
responsiveButton action generator message labelText size padding buttons model mode =
  case mode of
    TrLayout.Portrait ->
      TrLayoutInput.svgLabelButton
        action
        model.colorScheme.selection.main.fill
        generator
        model.colorScheme.secondary.accentHigh
        message
        labelText
        size
        padding
        buttons
        False

    TrLayout.Landscape ->
      TrLayoutInput.verticalSvgButton
        action
        model.colorScheme.selection.main.fill
        generator
        model.colorScheme.secondary.accentHigh
        message
        labelText
        size
        (size * 0.2)
        padding
        buttons
        False


computeSettingsChildren : TrModel.Model -> TrLayout.Mode -> Float -> Float -> List TrLayout.Generator -> List TrLayout.Generator
computeSettingsChildren model mode size padding children =
  children


computeMenuChildren : TrModel.Model -> TrLayout.Mode -> Float -> Float -> List TrLayout.Generator
computeMenuChildren model mode size padding =
  let commonChildren =
        [ responsiveButton
            (TrWorkActions.SetState TrState.Default)
            NavigationIcons.close
            "Return back to the editor."
            "Close"
            size
            padding
            [ TrKeyboard.escape ]
            model
            mode
        ]
  in
    if model.work.state == TrState.Settings
      then computeSettingsChildren model mode size padding commonChildren
      else commonChildren


view : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
view model mode =
  let y = Vector.getY model.work.dimensions

      (flow, size) =
        case mode of
          TrLayout.Portrait ->
            ( TrLayout.row
            , min (max (y * 0.03) 35) 100
            )

          TrLayout.Landscape ->
            ( TrLayout.column
            , min (max (y * 0.075) 80) 200
            )

      padding = size * 0.1
  in
    computeMenuChildren model mode size padding
    |> TrLayout.equalGroup flow TrLayout.wrap []
    |> TrLayout.extend (TrLayout.background model.colorScheme.secondary.main.fill)
