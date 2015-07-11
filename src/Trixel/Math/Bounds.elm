module Trixel.Math.Bounds where

import Trixel.Math.Vector as TrVector


zeroBounds : Bounds
zeroBounds =
  construct 0 0 0 0


computeDimensions : Bounds -> TrVector.Vector
computeDimensions bounds =
  TrVector.substract bounds.max bounds.min


construct : Float -> Float -> Float -> Float -> Bounds
construct minX minY maxX maxY =
  { min = TrVector.construct minX minY
  , max = TrVector.construct maxX maxY
  }


type alias Bounds =
  { min : TrVector.Vector
  , max : TrVector.Vector
  }