module Trixel.Types.Trixel where

import Math.Vector2 as Vector
import Trixel.Types.Color as TrColor


initialTrixel : Trixel
initialTrixel =
  construct
    TrColor.initialColor
    (Vector.vec2 0 0)


initialContent : Content
initialContent =
  constructContent
    TrColor.initialColor


toTrixel : Content -> Vector.Vec2 -> Trixel
toTrixel content position =
  construct
    content.color
    position


toContent : Trixel -> Content
toContent trixel =
  constructContent
    trixel.color


construct : TrColor.RgbaColor -> Vector.Vec2 -> Trixel
construct color position =
  { color = color
  , position = position
  }


constructContent : TrColor.RgbaColor -> Content
constructContent color =
  { color = color
  }


type alias Trixel =
  { position : Vector.Vec2
  , color : TrColor.RgbaColor
  }


type alias Content =
  { color : TrColor.RgbaColor
  }