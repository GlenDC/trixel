module Trixel.Types.Layout where

import Trixel.Math.Vector as TrVector


type Type
  = Horizontal
  | Vertical


computeType : TrVector.Vector -> Type
computeType dimensions =
  if dimensions.x <= 970
    then Vertical
    else Horizontal