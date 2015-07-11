module Trixel.Types.ColorScheme where

import Color exposing (Color, rgba)


type alias ColorScheme =
  { primary : ColorGroup
  , secondary : ColorGroup
  , selection : ColorGroup
  , document : RgbaColor
  , logo : ColorPair
  }


type alias ColorGroup =
  { default : ColorPair
  , accentHigh : RgbaColor
  , accentMid : RgbaColor
  , accentLow : RgbaColor
  }


type alias ColorPair =
  { fill : RgbaColor
  , stroke : RgbaColor
  }


type alias RgbaColor =
  { red : Int
  , green : Int
  , blue : Int
  , alpha : Float
  }


constructColorPair : RgbaColor -> RgbaColor -> ColorPair
constructColorPair fill stroke =
  { fill = fill
  , stroke = stroke
  } 


constructElmColor : RgbaColor -> Color
constructElmColor color =
  rgba color.red color.green color.blue color.alpha


constructHtmlColor : RgbaColor -> String
constructHtmlColor color =
  "rgba("
    ++ (toString color.red)
    ++ ","
    ++ (toString color.green)
    ++ ","
    ++ (toString color.blue)
    ++ ","
    ++ (toString color.alpha)
    ++ ")"


constructRgbaColor : Int -> Int -> Int -> Float -> RgbaColor
constructRgbaColor red green blue alpha =
  { red = red
  , green = green
  , blue = blue
  , alpha = alpha
  }

dayColorScheme : ColorScheme
dayColorScheme =
  { primary =
      { default =
          constructColorPair
            (constructRgbaColor 214 214 214 1)
            (constructRgbaColor 73 73 71 1)
      , accentHigh = constructRgbaColor 0 0 0 1
      , accentMid = constructRgbaColor 120 120 120 1
      , accentLow = constructRgbaColor 236 236 236 1
      }
  , secondary =
      { default =
          constructColorPair
            (constructRgbaColor 253 253 253 1)
            (constructRgbaColor 174 174 176 1)
      , accentHigh = constructRgbaColor 0 0 0 1
      , accentMid = constructRgbaColor 171 171 173 1
      , accentLow = constructRgbaColor 233 233 231 1
      }
  , selection =
      { default =
          constructColorPair
            (constructRgbaColor 150 150 150 1)
            (constructRgbaColor 75 75 75 1)
      , accentHigh = constructRgbaColor 16 16 16 1
      , accentMid = constructRgbaColor 86 86 86 1
      , accentLow = constructRgbaColor 174 174 174 1
      }
  , document = constructRgbaColor 255 255 255 1
  , logo =
      constructColorPair
        (constructRgbaColor 64 120 182 1)
        (constructRgbaColor 124 166 209 1)
  }


nightColorScheme : ColorScheme
nightColorScheme =
  { primary =
      { default =
          constructColorPair
            (constructRgbaColor 83 83 83 1)
            (constructRgbaColor 56 56 56 1)
      , accentHigh = constructRgbaColor 233 233 233 1
      , accentMid = constructRgbaColor 196 196 196 1
      , accentLow = constructRgbaColor 112 112 112 1
      }
  , secondary =
      { default =
          constructColorPair
            (constructRgbaColor 58 58 58 1)
            (constructRgbaColor 48 48 48 1)
      , accentHigh = constructRgbaColor 216 216 216 1
      , accentMid = constructRgbaColor 177 177 177 1
      , accentLow = constructRgbaColor 99 99 99 1
      }
  , selection =
      { default =
          constructColorPair
            (constructRgbaColor 45 54 61 1)
            (constructRgbaColor 35 42 48 1)
      , accentHigh = constructRgbaColor 198 214 214 1
      , accentMid = constructRgbaColor 177 177 183 1
      , accentLow = constructRgbaColor 104 104 115 1
      }
  , document = constructRgbaColor 38 38 38 1
  , logo =
      constructColorPair
        (constructRgbaColor 64 120 182 1)
        (constructRgbaColor 124 166 209 1)
  }