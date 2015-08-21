module Trixel.Views.Menu (view) where

import Trixel.Models.Model as TrModel
import Trixel.Types.State as TrState
import Trixel.Types.Color as TrColor
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Models.Work.Model as TrWorkModel
import Trixel.Models.Work.Actions as TrWorkActions

import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Input as TrLayoutInput

import Material.Icons.Action as ActionIcons
import Material.Icons.Content as ContentIcons
import Material.Icons.File as FileIcons
import Material.Icons.Navigation as NavigationIcons

import Css.Border.Bottom as BorderBottom
import Css.Border.Style as BorderStyle

import Math.Vector2 as Vector


viewLeftMenu : Float -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> Bool -> TrModel.Model -> TrLayout.Generator
viewLeftMenu size padding color selectionColor showLabels model =
  TrLayout.autoGroup
    TrLayout.row
    TrLayout.noWrap
    (TrLayout.marginRight (padding * 0.45) [])
    [ TrLayoutInput.imgButton
        (TrWorkActions.SetState TrState.Default)
        selectionColor
        "assets/logo.svg"
        "Return back to your workspace."
        size padding
        [ TrKeyboard.escape ]
        False
    , TrLayoutInput.svgResponsiveButton
        (TrWorkActions.SetState TrState.New)
        selectionColor
        ContentIcons.create
        color
        "Create a new document."
        "New"
        size padding
        [ TrKeyboard.alt, TrKeyboard.n ]
        showLabels
        (model.work.state == TrState.New)
    , TrLayoutInput.svgResponsiveButton
        (TrWorkActions.SetState TrState.Open)
        selectionColor
        FileIcons.folder_open
        color
        "Open an existing document."
        "Open"
        size padding
        [ TrKeyboard.alt, TrKeyboard.o ]
        showLabels
        (model.work.state == TrState.Open)
    , if TrWorkModel.hasDocument model.work
        then
          TrLayoutInput.svgResponsiveButton
            (TrWorkActions.SetState TrState.Save)
            selectionColor
            ContentIcons.save
            color
            "Save current document."
            "Save"
            size padding
            [ TrKeyboard.alt, TrKeyboard.s ]
            showLabels
            (model.work.state == TrState.Save)
          else TrLayout.empty
    ]


viewRightMenu : Float -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> Bool -> TrModel.Model -> TrLayout.Generator
viewRightMenu size padding color selectionColor showLabels model =
  let (fullscreenIcon, labelFullscreen, functionFullscreen, descriptionFullscreen, shortcutFullscreen) =
        if model.work.isFullscreen
          then (NavigationIcons.fullscreen_exit, "Windowed", "trExitFullscreen", "Exit fullscreen mode.", [ TrKeyboard.escape ])
          else (NavigationIcons.fullscreen, "Fullscreen", "trGoFullscreen", "Enter fullscreen mode.", [ TrKeyboard.alt, TrKeyboard.enter ])
  in
    TrLayout.autoGroup
      TrLayout.rowReverse
      TrLayout.noWrap
      (TrLayout.marginLeft (padding * 0.45) [])
      [ TrLayoutInput.nativeSvgResponsiveButton
          (functionFullscreen, [])
          selectionColor
          fullscreenIcon
          color
          descriptionFullscreen
          labelFullscreen
          size padding
          shortcutFullscreen
          showLabels
          False
      , TrLayoutInput.svgResponsiveButton
          (TrWorkActions.SetState TrState.About)
          selectionColor
          ActionIcons.info_outline
          color
          "General information on Trixel."
          "About"
          size padding
          [] showLabels
          (model.work.state == TrState.About)
      , TrLayoutInput.svgResponsiveButton
          (TrWorkActions.SetState TrState.Help)
          selectionColor
          ActionIcons.help_outline
          color
          "Information on shortcuts and how to use Trixel."
          "Help"
          size padding
          [ TrKeyboard.alt, TrKeyboard.i ]
          showLabels
          (model.work.state == TrState.Help)
      , TrLayoutInput.svgResponsiveButton
          (TrWorkActions.SetState TrState.Settings)
          selectionColor
          ActionIcons.settings
          color
          "View and modify your editor settings."
          "Settings"
          size padding
          [ TrKeyboard.alt, TrKeyboard.s ]
          showLabels
          (model.work.state == TrState.Settings)
      ]


view : Float -> TrModel.Model -> TrLayout.Generator
view size' model =
  let selectionColor =
        model.colorScheme.selection.main.fill
      color =
        model.colorScheme.primary.accentHigh

      size = size' * 0.7
      padding = size' * 0.25

      showLabels =
        (Vector.getX model.work.dimensions) > 1024
  in
    TrLayout.equalGroup
      TrLayout.row
      TrLayout.noWrap
      []
      [ viewLeftMenu size padding color selectionColor showLabels model
      , viewRightMenu size padding color selectionColor showLabels model
      ]
    |> TrLayout.extend (BorderBottom.width (max 3 (min (size * 0.1) 9)))
    |> TrLayout.extend (BorderBottom.color (TrColor.toColor model.colorScheme.primary.main.stroke))
    |> TrLayout.extend (BorderBottom.style BorderStyle.Solid)
