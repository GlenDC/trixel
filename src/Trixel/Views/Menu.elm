module Trixel.Views.Menu (view) where

import Trixel.Models.Lazy as TrLazy
import Trixel.Types.Color as TrColor
import Trixel.Types.Input as TrInput
import Trixel.Types.Keyboard as TrKeyboard

import Trixel.Types.State as TrState
import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Input as TrLayoutInput
import Trixel.Types.Layout.UserActions as TrUserActions

import Trixel.Native as TrNative

import Material.Icons.Action as ActionIcons
import Material.Icons.Content as ContentIcons
import Material.Icons.File as FileIcons
import Material.Icons.Navigation as NavigationIcons

import Css.Border.Bottom as BorderBottom
import Css.Border.Style as BorderStyle
import Css.Dimension as Dimension
import Css.Display as Display
import Css.Flex as Flex
import Css

import Html
import Html.Attributes as Attributes
import Html.Lazy


viewLeftMenu : Float -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> Bool -> TrLazy.LayoutModel -> TrLayout.Generator
viewLeftMenu size padding color selectionColor showLabels model =
  TrLayout.autoGroup
    TrLayout.row
    TrLayout.noWrap
    (TrLayout.marginRight (padding * 0.45) [])
    [ TrLayoutInput.imgButton
        selectionColor
        "assets/logo.svg"
        size padding
      |> TrUserActions.view False TrUserActions.close
    , TrLayoutInput.svgResponsiveButton
        selectionColor
        ContentIcons.create
        color
        size padding
        showLabels
      |> TrUserActions.viewLabel
          (model.state == TrState.New)
          TrUserActions.gotoNew
    , TrLayoutInput.svgResponsiveButton
        selectionColor
        FileIcons.folder_open
        color
        size padding
        showLabels
      |> TrUserActions.viewLabel
          (model.state == TrState.Open)
          TrUserActions.gotoOpen
    , if model.hasDocument
        then
          TrLayoutInput.svgResponsiveButton
            selectionColor
            ContentIcons.save
            color
            size padding
            showLabels
          |> TrUserActions.viewLabel
              (model.state == TrState.Save)
              TrUserActions.gotoSave
        else TrLayout.empty
    ]
  |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)


viewRightMenu : Float -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> Bool -> TrLazy.LayoutModel -> TrLayout.Generator
viewRightMenu size padding color selectionColor showLabels model =
  let (fullscreenIcon, labelFullscreen, functionFullscreen, descriptionFullscreen, shortcutFullscreen) =
        if model.isFullscreen
          then
            ( NavigationIcons.fullscreen_exit
            , "Windowed"
            , "exitFullscreen"
            , "Exit fullscreen mode."
            , TrInput.simpleShortcut [ TrKeyboard.escape ]
            )
          else
            ( NavigationIcons.fullscreen
            , "Fullscreen"
            , "goFullscreen"
            , "Enter fullscreen mode."
            , TrInput.emptyShortcut
            )
  in
    TrLayout.autoGroup
      TrLayout.rowReverse
      TrLayout.noWrap
      (TrLayout.marginLeft (padding * 0.45) [])
      [ TrLayoutInput.nativeSvgResponsiveButton
          selectionColor
          fullscreenIcon
          color
          size padding
          showLabels
          (TrNative.function functionFullscreen [])
          shortcutFullscreen
          descriptionFullscreen
          labelFullscreen
          False
      , TrLayoutInput.svgResponsiveButton
          selectionColor
          ActionIcons.info_outline
          color
          size padding
          showLabels
        |> TrUserActions.viewLabel
            (model.state == TrState.About)
            TrUserActions.gotoAbout
      , TrLayoutInput.svgResponsiveButton
          selectionColor
          ActionIcons.help_outline
          color
          size padding
          showLabels
        |> TrUserActions.viewLabel
            (model.state == TrState.Help)
            TrUserActions.gotoHelp
      , TrLayoutInput.svgResponsiveButton
          selectionColor
          ActionIcons.settings
          color
          size padding
          showLabels
        |> TrUserActions.viewLabel
            (model.state == TrState.Settings)
            TrUserActions.gotoSettings
      ]
  |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)


lazyView : Float -> TrLazy.LayoutModel -> Css.Styles -> Html.Html
lazyView size' model styles =
  let selectionColor =
        model.colorScheme.selection.main.fill
      color =
        model.colorScheme.primary.accentHigh

      size = size' * 0.85
      padding = size' * 0.25

      showLabels =
        model.width > 1024

      elements =
        List.map
          (\(generator) ->
            generator (Flex.grow 1 [])
            )
          [ viewLeftMenu size padding color selectionColor showLabels model
          , viewRightMenu size padding color selectionColor showLabels model
          ]

      style =
        Display.display Display.Flex styles
        |> Flex.flow TrLayout.row TrLayout.noWrap
        |> BorderBottom.width (clamp 3 (size * 0.1) 9)
        |> BorderBottom.color (TrColor.toColor model.colorScheme.primary.main.stroke)
        |> BorderBottom.style BorderStyle.Solid
        |> TrLayout.crossAlign TrLayout.Center
        |> Dimension.minHeight (size + (padding * 2))
        |> Attributes.style
  in
    Html.div [ style ] elements


view : Float -> TrLazy.LayoutModel -> Css.Styles -> Html.Html
view =
  Html.Lazy.lazy3 lazyView