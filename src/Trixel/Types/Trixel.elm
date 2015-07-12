module Trixel.Types.Trixel where

import Trixel.Math.Vector as TrVector
import Trixel.Types.Color as TrColor


initialTrixel : Trixel
initialTrixel =
  construct
    TrColor.initialColor
    TrVector.negativeUnitVector


initialContent : Content
initialContent =
  constructContent
    TrColor.initialColor


toTrixel : Content -> TrVector.Vector -> Trixel
toTrixel content position =
  construct
    content.color
    position


toContent : Trixel -> Content
toContent trixel =
  constructContent
    trixel.color


construct : TrColor.RgbaColor -> TrVector.Vector -> Trixel
construct color position =
  { color = color
  , position = position
  }


constructContent : TrColor.RgbaColor -> Content
constructContent color =
  { color = color
  }


type alias Trixel =
  { position : TrVector.Vector
  , color : TrColor.RgbaColor
  }


type alias Content =
  { color : TrColor.RgbaColor
  }