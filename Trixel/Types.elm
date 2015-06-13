module Trixel.Types where

import Trixel.ColorScheme exposing (ColorScheme)

type alias State = { cx: Int, cy: Int, colorScheme: ColorScheme }
