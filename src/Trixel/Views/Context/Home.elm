module Trixel.Views.Context.Home (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Models.Model as TrModel
import Trixel.Types.Layout as TrLayout

import Graphics.Element as Element

import Trixel.Views.Context.Toolbar.Horizontal as TrHorizontalToolbar
import Trixel.Views.Context.Toolbar.Vertical as TrVerticalToolbar


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  Element.empty