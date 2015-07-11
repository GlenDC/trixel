module Trixel.Types.ColorScheme where

import Trixel.Types.RgbaColor as TrRgbaColor


type alias ColorScheme =
  { primary : ColorGroup
  , secondary : ColorGroup
  , selection : ColorGroup
  , document : TrRgbaColor.RgbaColor
  , logo : ColorPair
  }


type alias ColorGroup =
  { default : ColorPair
  , accentHigh : TrRgbaColor.RgbaColor
  , accentMid : TrRgbaColor.RgbaColor
  , accentLow : TrRgbaColor.RgbaColor
  }


type alias ColorPair =
  { fill : TrRgbaColor.RgbaColor
  , stroke : TrRgbaColor.RgbaColor
  }


constructColorPair : TrRgbaColor.RgbaColor -> TrRgbaColor.RgbaColor -> ColorPair
constructColorPair fill stroke =
  { fill = fill
  , stroke = stroke
  }


dayColorScheme : ColorScheme
dayColorScheme =
  { primary =
      { default =
          constructColorPair
            (TrRgbaColor.construct 214 214 214 1)
            (TrRgbaColor.construct 73 73 71 1)
      , accentHigh = TrRgbaColor.construct 0 0 0 1
      , accentMid = TrRgbaColor.construct 120 120 120 1
      , accentLow = TrRgbaColor.construct 236 236 236 1
      }
  , secondary =
      { default =
          constructColorPair
            (TrRgbaColor.construct 253 253 253 1)
            (TrRgbaColor.construct 174 174 176 1)
      , accentHigh = TrRgbaColor.construct 0 0 0 1
      , accentMid = TrRgbaColor.construct 171 171 173 1
      , accentLow = TrRgbaColor.construct 233 233 231 1
      }
  , selection =
      { default =
          constructColorPair
            (TrRgbaColor.construct 150 150 150 1)
            (TrRgbaColor.construct 75 75 75 1)
      , accentHigh = TrRgbaColor.construct 16 16 16 1
      , accentMid = TrRgbaColor.construct 86 86 86 1
      , accentLow = TrRgbaColor.construct 174 174 174 1
      }
  , document = TrRgbaColor.construct 255 255 255 1
  , logo =
      constructColorPair
        (TrRgbaColor.construct 64 120 182 1)
        (TrRgbaColor.construct 124 166 209 1)
  }


nightColorScheme : ColorScheme
nightColorScheme =
  { primary =
      { default =
          constructColorPair
            (TrRgbaColor.construct 83 83 83 1)
            (TrRgbaColor.construct 56 56 56 1)
      , accentHigh = TrRgbaColor.construct 233 233 233 1
      , accentMid = TrRgbaColor.construct 196 196 196 1
      , accentLow = TrRgbaColor.construct 112 112 112 1
      }
  , secondary =
      { default =
          constructColorPair
            (TrRgbaColor.construct 58 58 58 1)
            (TrRgbaColor.construct 48 48 48 1)
      , accentHigh = TrRgbaColor.construct 216 216 216 1
      , accentMid = TrRgbaColor.construct 177 177 177 1
      , accentLow = TrRgbaColor.construct 99 99 99 1
      }
  , selection =
      { default =
          constructColorPair
            (TrRgbaColor.construct 45 54 61 1)
            (TrRgbaColor.construct 35 42 48 1)
      , accentHigh = TrRgbaColor.construct 198 214 214 1
      , accentMid = TrRgbaColor.construct 177 177 183 1
      , accentLow = TrRgbaColor.construct 104 104 115 1
      }
  , document = TrRgbaColor.construct 38 38 38 1
  , logo =
      constructColorPair
        (TrRgbaColor.construct 64 120 182 1)
        (TrRgbaColor.construct 124 166 209 1)
  }