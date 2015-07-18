module Trixel.Views.Menu (view) where

import Trixel.Constants as TrConstants
import Trixel.Math.Vector as TrVector
import Trixel.Types.Color as TrColor
import Trixel.Models.Model as TrModel

import Trixel.Models.Work as TrWork
import Trixel.Models.Work.Actions as TrActions

import Trixel.Graphics as TrGraphics
import Graphics.Element as Element
import Graphics.Collage as Collage

import Signal


viewLogo : TrVector.Vector -> Element.Element
viewLogo { y } =
  let dimensions =
        TrVector.construct y y
  in
    TrGraphics.image
      (TrVector.scale dimensions 0.8)
      (TrVector.scale dimensions 0.1)
      "assets/logo.svg"


viewButton : String -> TrVector.Vector -> TrModel.Model -> Signal.Address a -> a -> Element.Element
viewButton title { y } model address action =
  TrGraphics.button
    title
    (y * 0.5)
    (y * 0.125)
    model.colorScheme.primary.accentHigh
    model.colorScheme.selection.accentHigh
    address
    action


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  Element.flow
    Element.right
    [ viewLogo dimensions
    , viewButton "New" dimensions model TrWork.address TrActions.None
    , viewButton "Open" dimensions model TrWork.address TrActions.None
    , viewButton "Save" dimensions model TrWork.address TrActions.None
    ]