module Trixel.Views.Menu (view) where


import Trixel.Models.Model as TrModel
import Trixel.Types.State as TrState
import Trixel.Types.Color as TrColor
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Models.Work.Actions as TrWorkActions

import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Input as TrLayoutInput

import Material.Icons.Action as ActionIcons
import Material.Icons.Content as ContentIcons
import Material.Icons.File as FileIcons
import Material.Icons.Navigation as NavigationIcons

{-viewLogo : Vector.Vec2 -> Element.Element
viewLogo dimensions' =
  let y = Vector.getY dimensions'
      dimensions = Vector.vec2 y y
  in
    TrGraphics.image
      (Vector.scale 0.7 dimensions)
      (Vector.vec2
        (y * 0.2)
        (y * 0.15)
      )
      "assets/logo.svg"
    |> TrGraphics.hoverable "Return back to your workspace." [ TrKeyboard.escape ]
    |> Input.clickable
        (Signal.message TrWork.address
          (TrWorkActions.SetState TrState.Default))


addBackgroundHover : TrModel.Model -> Element.Element -> Element.Element
addBackgroundHover model node =
  Html.fromElement node 
  |> TrNative.hoverBackground model.colorScheme.selection.main.fill
  |> Html.toElement -1 -1



viewSvgButton render maybeLabel help shortcut selected size model address action =
  TrGraphics.svgButton
    render
    maybeLabel
    help
    shortcut
    selected
    size
    model.colorScheme.primary.accentHigh
    model.colorScheme.selection.accentHigh
    model.colorScheme.primary.main.fill
    model.colorScheme.selection.main.fill
    address
    action


makeFlowRelative : Element.Element -> Element.Element
makeFlowRelative flowElement =
  Html.div
    [ Attributes.class "tr-force-position-relative" ]
    [ Html.fromElement flowElement ]
  |> Html.toElement -1 -1


viewLabel : Bool -> String -> Maybe String
viewLabel showLabel label =
  if showLabel
    then Just label
    else Nothing


viewLeftMenu : Vector.Vec2 -> Bool -> TrModel.Model -> Element.Element
viewLeftMenu dimensions showLabels model =
  let size =
        (Vector.getY dimensions) * 0.95

      buttons =
        [ viewLogo dimensions
          |> addBackgroundHover model
        , viewSvgButton
            ContentIcons.create
            (viewLabel showLabels "New")
            "Create a new document."
            [ TrKeyboard.alt, TrKeyboard.n ]
            (model.work.state == TrState.New)
            size model TrWork.address
            (TrWorkActions.SetState TrState.New)
        , viewSvgButton
            FileIcons.folder_open
            (viewLabel showLabels "Open")
            "Open an existing document."
            [ TrKeyboard.alt, TrKeyboard.o ]
            (model.work.state == TrState.Open)
            size model TrWork.address
            (TrWorkActions.SetState TrState.Open)
        ]
  in
    Element.flow
      Element.right
      ( if TrWorkModel.hasDocument model.work
          then 
            buttons ++
              [ viewSvgButton
                  ContentIcons.save
                  (viewLabel showLabels "Save")
                  "Save current document."
                  [ TrKeyboard.alt, TrKeyboard.s ]
                  (model.work.state == TrState.Save)
                  size model TrWork.address
                  (TrWorkActions.SetState TrState.Save)
              ]
          else
           buttons
      )
    |> Element.container -1 (round (Vector.getY dimensions)) Element.topLeft
    |> makeFlowRelative


viewRightMenu : Vector.Vec2 -> Bool -> TrModel.Model -> Element.Element
viewRightMenu dimensions showLabels model =
  let size =
        (Vector.getY dimensions) * 0.95

      (renderFullscreen, labelFullscreen, functionFullscreen, descriptionFullscreen, shortcutFullscreen) =
        if model.work.isFullscreen
          then (NavigationIcons.fullscreen_exit, "Windowed", "trExitFullscreen", "Exit fullscreen mode.", [ TrKeyboard.escape ])
          else (NavigationIcons.fullscreen, "Fullscreen", "trGoFullscreen", "Enter fullscreen mode.", [ TrKeyboard.alt, TrKeyboard.enter ])
  in
    Element.flow
      Element.left
      [ TrGraphics.svgNativeButton
          renderFullscreen
          functionFullscreen []
          descriptionFullscreen
          shortcutFullscreen
          (viewLabel showLabels labelFullscreen)
          size
          model.colorScheme.primary.accentHigh
        |> addBackgroundHover model
      , viewSvgButton
          ActionIcons.info_outline
          (viewLabel showLabels "About")
          "General information on Trixel."
          []
          (model.work.state == TrState.About)
          size model TrWork.address
          (TrWorkActions.SetState TrState.About)
      , viewSvgButton
          ActionIcons.help_outline
          (viewLabel showLabels "Help")
          "Information on shortcuts and how to use Trixel."
          [ TrKeyboard.alt, TrKeyboard.i ]
          (model.work.state == TrState.Help)
          size model TrWork.address
          (TrWorkActions.SetState TrState.Help)
      , viewSvgButton
          ActionIcons.settings
          (viewLabel showLabels "Settings")
          "View and modify your editor settings."
          [ TrKeyboard.alt, TrKeyboard.s ]
          (model.work.state == TrState.Settings)
          size model TrWork.address
          (TrWorkActions.SetState TrState.Settings)
      ]
    |> Element.container -1 (round (Vector.getY dimensions)) Element.topRight
    |> makeFlowRelative


makeFloat : String -> Element.Element -> Html.Html
makeFloat float element =
  Html.div
    [ Attributes.style [ ("float", float) ] ]
    [ Html.fromElement element ]


groupMenus : Element.Element -> Element.Element -> Element.Element
groupMenus leftElement rightElement =
  Html.div []
    [ makeFloat "left" leftElement
    , makeFloat "right" rightElement
    ]
  |> Html.toElement -1 -1


view : Vector.Vec2 -> TrModel.Model -> Element.Element
view dimensions model =
  let leftMenuDimensions =
        Vector.vec2
          ((Vector.getX dimensions) * 0.4495)
          (Vector.getY dimensions)

      rightMenuDimensions =
        Vector.vec2
          ((Vector.getX dimensions) * 0.5495)
          (Vector.getY dimensions)

      showLabels =
        (Vector.getX dimensions) > 640
  in
    groupMenus
      (viewLeftMenu leftMenuDimensions showLabels model)
      (viewRightMenu rightMenuDimensions showLabels model)
    |> TrGraphics.setDimensions dimensions
-}


viewLeftMenu : Float -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrLayout.Generator
viewLeftMenu size padding color selectionColor =
  TrLayout.equalGroup
    TrLayout.row
    TrLayout.noWrap
    [ TrLayoutInput.imgButton
        (TrWorkActions.SetState TrState.Default)
        selectionColor
        "assets/logo.svg"
        "Return back to your workspace."
        size padding
        [ TrKeyboard.escape ]
    , TrLayoutInput.svgButton
        (TrWorkActions.SetState TrState.New)
        selectionColor
        ContentIcons.create
        color
        "Create a new document."
        size padding
        [ TrKeyboard.alt, TrKeyboard.n ]
    , TrLayoutInput.svgButton
        (TrWorkActions.SetState TrState.Open)
        selectionColor
        FileIcons.folder_open
        color
        "Open an existing document."
        size padding
        [ TrKeyboard.alt, TrKeyboard.o ]
    ]


viewRightMenu : Float -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrLayout.Generator
viewRightMenu size padding color selectionColor =
  TrLayout.equalGroup
    TrLayout.rowReverse
    TrLayout.noWrap
    [ TrLayoutInput.svgButton
        (TrWorkActions.SetState TrState.About)
        selectionColor
        ActionIcons.info_outline
        color
        "General information on Trixel."
        size padding
        []
    , TrLayoutInput.svgButton
        (TrWorkActions.SetState TrState.Help)
        selectionColor
        ActionIcons.help_outline
        color
        "Information on shortcuts and how to use Trixel."
        size padding
        [ TrKeyboard.alt, TrKeyboard.i ]
    , TrLayoutInput.svgButton
        (TrWorkActions.SetState TrState.Settings)
        selectionColor
        ActionIcons.settings
        color
        "View and modify your editor settings."
        size padding
        [ TrKeyboard.alt, TrKeyboard.s ]
    ]


view : Float -> TrModel.Model -> TrLayout.Generator
view size' model =
  let selectionColor =
        model.colorScheme.selection.main.fill
      color =
        model.colorScheme.primary.accentHigh

      size = size' * 0.8
      padding = size' * 0.2
  in
    TrLayout.equalGroup
      TrLayout.row
      TrLayout.noWrap
      [ viewLeftMenu size padding color selectionColor
      , viewRightMenu size padding color selectionColor
      ]
