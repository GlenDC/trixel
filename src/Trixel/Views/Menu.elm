module Trixel.Views.Menu (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Types.State as TrState
import Trixel.Models.Model as TrModel

import Trixel.Graphics as TrGraphics
import Graphics.Element as Element
import Graphics.Input as Input

import Signal

import Material.Icons.Action as ActionIcons
import Material.Icons.Content as ContentIcons
import Material.Icons.File as FileIcons


viewLogo : TrVector.Vector -> Element.Element
viewLogo { y } =
  let dimensions =
        TrVector.construct y y
  in
    TrGraphics.image
      (TrVector.scale 0.8 dimensions)
      (TrVector.construct
        (dimensions.x * 0.2)
        (dimensions.y * 0.1)
      )
      "assets/logo.svg"
    |> TrGraphics.hoverable "Return back to your workspace." dimensions
    |> Input.clickable
        (Signal.message TrModel.address
          (TrModel.UpdateState TrState.Default))


viewSvgButton render label help selected dimensions model address action =
  TrGraphics.svgButton
    render
    label
    help
    selected
    dimensions
    model.colorScheme.primary.accentHigh
    model.colorScheme.selection.accentHigh
    model.colorScheme.primary.main.fill
    model.colorScheme.selection.main.fill
    address
    action


viewLeftMenu : TrVector.Vector -> TrModel.Model -> Element.Element
viewLeftMenu dimensions model =
  let buttonDimensions =
        TrVector.construct
          (dimensions.y * 3.35)
          (dimensions.y * 0.95)
  in
    Element.flow
      Element.right
      [ viewLogo dimensions
      , viewSvgButton
          ContentIcons.create "New" "Create a new document."
          (model.work.state == TrState.New)
          buttonDimensions model TrModel.address
          (TrModel.UpdateState TrState.New)
      , viewSvgButton
          FileIcons.folder_open "Open" "Open an existing document."
          (model.work.state == TrState.Open)
          buttonDimensions model TrModel.address
          (TrModel.UpdateState TrState.Open)
      , viewSvgButton
          ContentIcons.save "Save" "Save current document."
          (model.work.state == TrState.Save)
          buttonDimensions model TrModel.address
          (TrModel.UpdateState TrState.Save)
      ]
    |> TrGraphics.setDimensions dimensions


viewRightMenu : TrVector.Vector -> TrModel.Model -> Element.Element
viewRightMenu dimensions model =
  let buttonDimensions =
        TrVector.construct
          (dimensions.y * 4)
          (dimensions.y * 0.95)
  in
    Element.flow
      Element.left
      [ viewSvgButton
          ActionIcons.info_outline "About" "Information regarding this editor."
          (model.work.state == TrState.About)
          buttonDimensions model TrModel.address
          (TrModel.UpdateState TrState.About)
      , viewSvgButton
          ActionIcons.help_outline "Help" "Information regarding shortcuts and other relevant content."
          (model.work.state == TrState.Help)
          buttonDimensions model TrModel.address
          (TrModel.UpdateState TrState.Help)
      , viewSvgButton
          ActionIcons.settings "Settings" "View and modify your editor settings."
          (model.work.state == TrState.Settings)
          buttonDimensions model TrModel.address
          (TrModel.UpdateState TrState.Settings)
      ]


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  let rightMenu =
        viewRightMenu dimensions model

      rightMenuDimensions =
        TrGraphics.computeDimensions rightMenu

      leftMenuDimensions =
        TrVector.construct
          (dimensions.x - rightMenuDimensions.x)
          dimensions.y
  in
    Element.flow
      Element.right
      [ viewLeftMenu leftMenuDimensions model
      , rightMenu
      ]
    |> TrGraphics.setDimensions dimensions