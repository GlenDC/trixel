module Trixel.Views.Context.Workspace (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Models.Model as TrModel
import Trixel.Types.Layout as TrLayout
import Trixel.Graphics as TrGraphics

import Graphics.Element as Element


view : TrVector.Vector -> TrLayout.Type -> TrModel.Model -> Element.Element
view dimensions layout model =
  TrGraphics.background
    model.colorScheme.document
    dimensions
  |> TrGraphics.toElement dimensions