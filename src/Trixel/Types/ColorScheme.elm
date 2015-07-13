module Trixel.Types.ColorScheme where

import Trixel.Types.Color as TrColor


type alias ColorScheme =
  { primary : ColorGroup
  , secondary : ColorGroup
  , selection : ColorGroup
  , document : TrColor.RgbaColor
  , logo : ColorPair
  }


type alias ColorGroup =
  { main : ColorPair
  , accentHigh : TrColor.RgbaColor
  , accentMid : TrColor.RgbaColor
  , accentLow : TrColor.RgbaColor
  }


type alias ColorPair =
  { fill : TrColor.RgbaColor
  , stroke : TrColor.RgbaColor
  }


constructColorPair : TrColor.RgbaColor -> TrColor.RgbaColor -> ColorPair
constructColorPair fill stroke =
  { fill = fill
  , stroke = stroke
  }


dayColorScheme : ColorScheme
dayColorScheme =
  { primary =
      { main =
          constructColorPair
            (TrColor.construct 214 214 214 1)
            (TrColor.construct 73 73 71 1)
      , accentHigh = TrColor.construct 0 0 0 1
      , accentMid = TrColor.construct 120 120 120 1
      , accentLow = TrColor.construct 236 236 236 1
      }
  , secondary =
      { main =
          constructColorPair
            (TrColor.construct 253 253 253 1)
            (TrColor.construct 174 174 176 1)
      , accentHigh = TrColor.construct 0 0 0 1
      , accentMid = TrColor.construct 171 171 173 1
      , accentLow = TrColor.construct 233 233 231 1
      }
  , selection =
      { main =
          constructColorPair
            (TrColor.construct 150 150 150 1)
            (TrColor.construct 75 75 75 1)
      , accentHigh = TrColor.construct 16 16 16 1
      , accentMid = TrColor.construct 86 86 86 1
      , accentLow = TrColor.construct 174 174 174 1
      }
  , document = TrColor.construct 255 255 255 1
  , logo =
      constructColorPair
        (TrColor.construct 64 120 182 1)
        (TrColor.construct 124 166 209 1)
  }


nightColorScheme : ColorScheme
nightColorScheme =
  { primary =
      { main =
          constructColorPair
            (TrColor.construct 83 83 83 1)
            (TrColor.construct 56 56 56 1)
      , accentHigh = TrColor.construct 233 233 233 1
      , accentMid = TrColor.construct 196 196 196 1
      , accentLow = TrColor.construct 112 112 112 1
      }
  , secondary =
      { main =
          constructColorPair
            (TrColor.construct 58 58 58 1)
            (TrColor.construct 48 48 48 1)
      , accentHigh = TrColor.construct 216 216 216 1
      , accentMid = TrColor.construct 177 177 177 1
      , accentLow = TrColor.construct 99 99 99 1
      }
  , selection =
      { main =
          constructColorPair
            (TrColor.construct 45 54 61 1)
            (TrColor.construct 35 42 48 1)
      , accentHigh = TrColor.construct 198 214 214 1
      , accentMid = TrColor.construct 177 177 183 1
      , accentLow = TrColor.construct 104 104 115 1
      }
  , document = TrColor.construct 38 38 38 1
  , logo =
      constructColorPair
        (TrColor.construct 64 120 182 1)
        (TrColor.construct 124 166 209 1)
  }