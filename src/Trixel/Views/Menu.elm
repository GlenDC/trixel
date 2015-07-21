module Trixel.Views.Menu (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Types.State as TrState
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Models.Model as TrModel
import Trixel.Models.Work as TrWork
import Trixel.Models.Work.Actions as TrWorkActions

import Trixel.Native as TrNative
import Trixel.Graphics as TrGraphics
import Graphics.Element as Element
import Graphics.Input as Input

import Signal

import Material.Icons.Action as ActionIcons
import Material.Icons.Content as ContentIcons
import Material.Icons.File as FileIcons
import Material.Icons.Navigation as NavigationIcons

import Html
import Html.Attributes as Attributes


viewLogo : TrVector.Vector -> Element.Element
viewLogo { y } =
  let dimensions =
        TrVector.construct y y
  in
    TrGraphics.image
      (TrVector.scale 0.7 dimensions)
      (TrVector.construct
        (dimensions.x * 0.2)
        (dimensions.y * 0.15)
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


viewLeftMenu : TrVector.Vector -> Bool -> TrModel.Model -> Element.Element
viewLeftMenu dimensions showLabels model =
  let size =
        dimensions.y * 0.95
  in
    Element.flow
      Element.right
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
      , viewSvgButton
          ContentIcons.save
          (viewLabel showLabels "Save")
          "Save current document."
          [ TrKeyboard.alt, TrKeyboard.s ]
          (model.work.state == TrState.Save)
          size model TrWork.address
          (TrWorkActions.SetState TrState.Save)
      ]
    |> Element.container -1 (round dimensions.y) Element.topLeft
    |> makeFlowRelative


viewRightMenu : TrVector.Vector -> Bool -> TrModel.Model -> Element.Element
viewRightMenu dimensions showLabels model =
  let size =
        dimensions.y * 0.95

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
    |> Element.container -1 (round dimensions.y) Element.topRight
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


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  let leftMenuDimensions =
        TrVector.construct
          (dimensions.x * 0.4495)
          dimensions.y

      rightMenuDimensions =
        TrVector.construct
          (dimensions.x * 0.5495)
          dimensions.y

      showLabels =
        dimensions.x > 640
  in
    groupMenus
      (viewLeftMenu leftMenuDimensions showLabels model)
      (viewRightMenu rightMenuDimensions showLabels model)
    |> TrGraphics.setDimensions dimensions