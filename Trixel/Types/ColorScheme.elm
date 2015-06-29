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
  , workbg : ColorInfo
  }


constructColorInfo: Int -> Int -> Int -> Float -> ColorInfo
constructColorInfo red green blue alpha =
  { elm = rgba red green blue alpha
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
  { bg = constructColorInfo 64 64 64 1
  , fg = constructColorInfo 246 243 232 1
  , subbg = constructColorInfo 40 40 40 1
  , subfg = constructColorInfo 225 230 210 1
  , selbg = constructColorInfo 137 137 65 1
  , selfg = constructColorInfo 0 0 0 1
  , text = constructColorInfo 204 147 147 1
  , subText = constructColorInfo 172 193 172 1
  , workbg = constructColorInfo 40 40 40 1
  }