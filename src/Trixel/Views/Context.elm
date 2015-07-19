module Trixel.Views.Context (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Models.Model as TrModel
import Trixel.Graphics as TrGraphics

import Graphics.Element as Element


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  TrGraphics.background
    model.colorScheme.secondary.main.fill
    dimensions
  |> TrGraphics.toElement dimensions