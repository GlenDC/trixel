module Trixel.Views.Menu (view) where

import Trixel.Models.Model as TrModel
import Trixel.Types.Color as TrColor
import Trixel.Types.Input as TrInput
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Models.Work.Model as TrWorkModel

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

import Math.Vector2 as Vector


viewLeftMenu : Float -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> Bool -> TrModel.Model -> TrLayout.Generator
viewLeftMenu size padding color selectionColor showLabels model =
  TrLayout.autoGroup
    TrLayout.row
    TrLayout.noWrap
    (TrLayout.marginRight (padding * 0.45) [])
    [ TrLayoutInput.imgButton
        selectionColor
        "assets/logo.svg"
        size padding
      |> TrUserActions.view model TrUserActions.close
    , TrLayoutInput.svgResponsiveButton
        selectionColor
        ContentIcons.create
        color
        size padding
        showLabels
      |> TrUserActions.viewLabel model TrUserActions.gotoNew
    , TrLayoutInput.svgResponsiveButton
        selectionColor
        FileIcons.folder_open
        color
        size padding
        showLabels
      |> TrUserActions.viewLabel model TrUserActions.gotoOpen
    , if TrWorkModel.hasDocument model.work
        then
          TrLayoutInput.svgResponsiveButton
            selectionColor
            ContentIcons.save
            color
            size padding
            showLabels
          |> TrUserActions.viewLabel model TrUserActions.gotoSave
        else TrLayout.empty
    ]
  |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)


viewRightMenu : Float -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> Bool -> TrModel.Model -> TrLayout.Generator
viewRightMenu size padding color selectionColor showLabels model =
  let (fullscreenIcon, labelFullscreen, functionFullscreen, descriptionFullscreen, shortcutFullscreen) =
        if model.work.isFullscreen
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
        |> TrUserActions.viewLabel model TrUserActions.gotoAbout
      , TrLayoutInput.svgResponsiveButton
          selectionColor
          ActionIcons.help_outline
          color
          size padding
          showLabels
        |> TrUserActions.viewLabel model TrUserActions.gotoHelp
      , TrLayoutInput.svgResponsiveButton
          selectionColor
          ActionIcons.settings
          color
          size padding
          showLabels
        |> TrUserActions.viewLabel model TrUserActions.gotoSettings
      ]
  |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)


view : Float -> TrModel.Model -> TrLayout.Generator
view size' model =
  let selectionColor =
        model.colorScheme.selection.main.fill
      color =
        model.colorScheme.primary.accentHigh

      size = size' * 0.85
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
    |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)
    |> TrLayout.extend (Dimension.minHeight (size + (padding * 2)))
