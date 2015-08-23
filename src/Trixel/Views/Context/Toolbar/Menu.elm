module Trixel.Views.Context.Toolbar.Menu (view) where

import Trixel.Models.Model as TrModel

import Trixel.Types.State as TrState
import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Input as TrLayoutInput
import Trixel.Types.Layout.Graphics as TrGraphics
import Trixel.Types.Layout.UserActions as TrUserActions

import Material.Icons.Navigation as NavigationIcons

import Math.Vector2 as Vector

import Css.Dimension as Dimension


responsiveButton : TrUserActions.UserAction -> TrGraphics.SvgGenerator -> Float -> Float -> TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
responsiveButton userAction generator size padding model mode =
  case mode of
    TrLayout.Portrait ->
      TrLayoutInput.svgLabelButton
        model.colorScheme.selection.main.fill
        generator
        model.colorScheme.secondary.accentHigh
        size
        padding
      |> TrUserActions.viewLabel model userAction

    TrLayout.Landscape ->
      TrLayoutInput.verticalSvgButton
        model.colorScheme.selection.main.fill
        generator
        model.colorScheme.secondary.accentHigh
        size
        (size * 0.2)
        padding
      |> TrUserActions.viewLabel model userAction


computeSettingsChildren : TrModel.Model -> TrLayout.Mode -> Float -> Float -> List TrLayout.Generator -> List TrLayout.Generator
computeSettingsChildren model mode size padding children =
  children


computeMenuChildren : TrModel.Model -> TrLayout.Mode -> Float -> Float -> List TrLayout.Generator
computeMenuChildren model mode size padding =
  let commonChildren =
        [ responsiveButton
            TrUserActions.close
            NavigationIcons.close
            size
            padding
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

      (flow, size, minFunc) =
        case mode of
          TrLayout.Portrait ->
            ( TrLayout.row
            , min (max (y * 0.025) 30) 80
            , Dimension.minHeight
            )

          TrLayout.Landscape ->
            ( TrLayout.column
            , min (max (y * 0.075) 80) 200
            , Dimension.minWidth
            )

      padding = size * 0.1
  in
    computeMenuChildren model mode size padding
    |> TrLayout.equalGroup flow TrLayout.wrap []
    |> TrLayout.extend (TrLayout.background model.colorScheme.secondary.main.fill)
    |> TrLayout.extend (minFunc (size + (padding * 2)))
