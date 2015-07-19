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
    |> TrGraphics.hoverable "Return back to your workspace."
    |> Input.clickable
        (Signal.message TrModel.address
          (TrModel.UpdateState TrState.Default))


viewSvgButton render label help selected size model address action =
  TrGraphics.svgButton
    render
    label
    help
    selected
    size
    model.colorScheme.primary.accentHigh
    model.colorScheme.selection.accentHigh
    model.colorScheme.primary.main.fill
    model.colorScheme.selection.main.fill
    address
    action


viewLeftMenu : TrVector.Vector -> TrModel.Model -> Element.Element
viewLeftMenu dimensions model =
  let size =
        dimensions.y * 0.95
  in
    Element.flow
      Element.right
      [ viewLogo dimensions
      , viewSvgButton
          ContentIcons.create "New" "Create a new document."
          (model.work.state == TrState.New)
          size model TrModel.address
          (TrModel.UpdateState TrState.New)
      , viewSvgButton
          FileIcons.folder_open "Open" "Open an existing document."
          (model.work.state == TrState.Open)
          size model TrModel.address
          (TrModel.UpdateState TrState.Open)
      , viewSvgButton
          ContentIcons.save "Save" "Save current document."
          (model.work.state == TrState.Save)
          size model TrModel.address
          (TrModel.UpdateState TrState.Save)
      ]
    |> Element.container
          (round dimensions.x)
          (round dimensions.y)
          Element.topLeft


viewRightMenu : TrVector.Vector -> TrModel.Model -> Element.Element
viewRightMenu dimensions model =
  let size =
        dimensions.y * 0.95
  in
    Element.flow
      Element.left
      [ viewSvgButton
          ActionIcons.info_outline "About" "Information regarding this editor."
          (model.work.state == TrState.About)
          size model TrModel.address
          (TrModel.UpdateState TrState.About)
      , viewSvgButton
          ActionIcons.help_outline "Help" "Information regarding shortcuts and other relevant content."
          (model.work.state == TrState.Help)
          size model TrModel.address
          (TrModel.UpdateState TrState.Help)
      , viewSvgButton
          ActionIcons.settings "Settings" "View and modify your editor settings."
          (model.work.state == TrState.Settings)
          size model TrModel.address
          (TrModel.UpdateState TrState.Settings)
      ]
    |> Element.container
        (round dimensions.x)
        (round dimensions.y)
        Element.topRight


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  let leftMenuDimensions =
        TrVector.construct
          (dimensions.x * 0.45)
          dimensions.y

      rightMenuDimensions =
        TrVector.construct
          (dimensions.x * 0.55)
          dimensions.y
  in
    Element.flow
      Element.right
      [ viewLeftMenu leftMenuDimensions model
      , viewRightMenu rightMenuDimensions model
      ]
    |> TrGraphics.setDimensions dimensions