module Trixel.Types.JSGlue where

import Color exposing (Color, rgba, toRgb)


type alias GlueState =
  { cssInfo : CSSInfo
  , trixelColor : String
  }


emptyGlueState : GlueState
emptyGlueState =
  { cssInfo = emptyCSSInfo
  , trixelColor = "rgb(255,0,0)"
  }


type alias CSSInfo =
  { colorPicker : String
  }


emptyCSSInfo : CSSInfo
emptyCSSInfo =
  { colorPicker = "ColorPicker"
  }


computeColorFromJSColor : JSColor -> Color
computeColorFromJSColor jscolor =
  (rgba
    (round jscolor.red)
    (round jscolor.green)
    (round jscolor.blue)
    jscolor.alpha
  )

computeJSColorFromColor : Color -> JSColor
computeJSColorFromColor color =
  let rgbaColor =
        toRgb color
  in
    { red = toFloat rgbaColor.red
    , green = toFloat rgbaColor.green
    , blue = toFloat rgbaColor.blue
    , alpha = rgbaColor.alpha
    }


emptyJSColor : JSColor
emptyJSColor =
  { red = 255
  , green = 0
  , blue = 0
  , alpha = 255
  }


type alias JSColor =
  { red : Float
  , green : Float
  , blue : Float
  , alpha : Float
  }