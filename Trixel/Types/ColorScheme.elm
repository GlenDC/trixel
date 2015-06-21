module Trixel.Types.ColorScheme where

import Color exposing (Color, rgba)


type alias ColorInfo =
  { elm : Color
  , html : String
  }


type alias ColorScheme =
  { bg : ColorInfo
  , fg : ColorInfo
  , subbg : ColorInfo
  , subfg : ColorInfo
  , selbg : ColorInfo
  , selfg : ColorInfo
  , text : ColorInfo
  , subText : ColorInfo
  }


constructColorInfo: Int -> Int -> Int -> Int -> ColorInfo
constructColorInfo red green blue alpha =
  { elm = rgba red green blue ((toFloat alpha) / 255)
  , html = "rgba("
      ++ (toString red)
      ++ ","
      ++ (toString green)
      ++ ","
      ++ (toString blue)
      ++ ","
      ++ (toString alpha)
      ++ ")"
  }


zenburnScheme: ColorScheme
zenburnScheme =
  { bg = constructColorInfo 64 64 64 255
  , fg = constructColorInfo 246 243 232 255
  , subbg = constructColorInfo 40 40 40 255
  , subfg = constructColorInfo 225 230 210 255
  , selbg = constructColorInfo 137 137 65 255
  , selfg = constructColorInfo 0 0 0 255
  , text = constructColorInfo 204 147 147 255
  , subText = constructColorInfo 172 193 172 255
  }