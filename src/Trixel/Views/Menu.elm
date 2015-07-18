module Trixel.Views.Menu (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Types.State as TrState
import Trixel.Models.Model as TrModel

import Trixel.Graphics as TrGraphics
import Graphics.Element as Element
import Graphics.Input as Input

import Signal


viewLogo : TrVector.Vector -> Element.Element
viewLogo { y } =
  let dimensions =
        TrVector.construct y y
  in
    TrGraphics.image
      (TrVector.scale 0.8 dimensions)
      (TrVector.scale 0.1 dimensions)
      "assets/logo.svg"
    |> TrGraphics.hoverable "Return back to your workspace." dimensions
    |> Input.clickable
        (Signal.message TrModel.address
          (TrModel.UpdateState TrState.Default))


viewButton : String -> String -> Bool -> TrVector.Vector -> TrModel.Model -> Signal.Address a -> a -> Element.Element
viewButton title help selected { y } model address action =
  TrGraphics.button
    title
    help
    selected
    (y * 0.5)
    (y * 0.125)
    model.colorScheme.primary.accentHigh
    model.colorScheme.selection.accentHigh
    address
    action


viewLeftMenu : TrVector.Vector -> TrModel.Model -> Element.Element
viewLeftMenu dimensions model =
  Element.flow
    Element.right
    [ viewLogo dimensions
    , viewButton
        "New" "Create a new document."
        (model.work.state == TrState.New)
        dimensions model TrModel.address
        (TrModel.UpdateState TrState.New)
    , viewButton
        "Open" "Open an existing document."
        (model.work.state == TrState.Open)
        dimensions model TrModel.address
        (TrModel.UpdateState TrState.Open)
    , viewButton
        "Save" "Save current document."
        (model.work.state == TrState.Save)
        dimensions model TrModel.address
        (TrModel.UpdateState TrState.Save)
    ]
  |> TrGraphics.setDimensions dimensions


viewRightMenu : TrVector.Vector -> TrModel.Model -> Element.Element
viewRightMenu dimensions model =
  Element.flow
    Element.left
    [ viewButton
        "Settings" "View and modify your editor settings."
        (model.work.state == TrState.Settings)
        dimensions model TrModel.address
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