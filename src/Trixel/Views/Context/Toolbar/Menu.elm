module Trixel.Views.Context.Toolbar.Menu (view) where

import Trixel.Models.Lazy as TrLazy

import Trixel.Types.State as TrState
import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Input as TrLayoutInput
import Trixel.Types.Layout.Graphics as TrGraphics
import Trixel.Types.Layout.UserActions as TrUserActions

import Material.Icons.Navigation as NavigationIcons

import Css
import Css.Flex as Flex
import Css.Display as Display
import Css.Dimension as Dimension

import Html
import Html.Attributes as Attributes


responsiveButton : TrUserActions.UserAction -> TrGraphics.SvgGenerator -> Float -> Float -> Bool -> TrLazy.LayoutModel -> TrLayout.Mode -> TrLayout.Generator
responsiveButton userAction generator size padding toggled model mode =
  case mode of
    TrLayout.Portrait ->
      TrLayoutInput.svgLabelButton
        model.colorScheme.selection.main.fill
        generator
        model.colorScheme.secondary.accentHigh
        size
        padding
      |> TrUserActions.viewLabel toggled userAction

    TrLayout.Landscape ->
      TrLayoutInput.verticalSvgButton
        model.colorScheme.selection.main.fill
        generator
        model.colorScheme.secondary.accentHigh
        size
        (size * 0.2)
        padding
      |> TrUserActions.viewLabel toggled userAction


computeSettingsChildren : TrLazy.LayoutModel -> TrLayout.Mode -> Float -> Float -> List TrLayout.Generator -> List TrLayout.Generator
computeSettingsChildren model mode size padding children =
  children


computeMenuChildren : TrLazy.LayoutModel -> TrLayout.Mode -> Float -> Float -> List TrLayout.Generator
computeMenuChildren model mode size padding =
  let commonChildren =
        [ responsiveButton
            TrUserActions.close
            NavigationIcons.close
            size
            padding
            False
            model
            mode
        ]
  in
    if model.state == TrState.Settings
      then computeSettingsChildren model mode size padding commonChildren
      else commonChildren


view : TrLazy.LayoutModel -> TrLayout.Mode -> Css.Styles -> Html.Html
view model mode styles =
  let (flow, size, minFunc) =
        case mode of
          TrLayout.Portrait ->
            ( TrLayout.row
            , clamp 30 80 (model.width * 0.025)
            , Dimension.minHeight
            )

          TrLayout.Landscape ->
            ( TrLayout.column
            , clamp 80 200 (model.height * 0.075)
            , Dimension.minWidth
            )

      padding = size * 0.1

      elements =
        List.map
          (\generator ->
            generator (Flex.grow 1 [])
          )
        (computeMenuChildren model mode size padding)

      style =
        Display.display Display.Flex styles
        |> Flex.flow flow TrLayout.wrap
        |> TrLayout.background model.colorScheme.secondary.main.fill
        |> minFunc (size + (padding * 2))
        |> Attributes.style
  in
    Html.div [ style ] elements
