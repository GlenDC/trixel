module Tests.Types.Work2D.SharedTestVariables where

import Trixel.Types.Work2D.Column as TrColumn
import Trixel.Types.Trixel as TrTrixel
import Trixel.Types.Color as TrColor

import Math.Vector2 as Vector


red = TrColor.construct 255 0 0 1
green = TrColor.construct 0 255 0 1
blue = TrColor.construct 0 0 255 1
white = TrColor.construct 255 255 255 1

trixelA = TrTrixel.construct blue (Vector.vec2 2 1)
trixelB = TrTrixel.construct red (Vector.vec2 4 2)
trixelC = TrTrixel.construct green (Vector.vec2 6 1)
trixelD = TrTrixel.construct green (Vector.vec2 8 5)
trixelE = TrTrixel.construct green (Vector.vec2 10 3)

trixelA' = TrTrixel.construct red (Vector.vec2 2 1)
trixelB' = TrTrixel.construct green (Vector.vec2 4 1)
trixelC' = TrTrixel.construct blue (Vector.vec2 6 1)

columnA = TrColumn.construct trixelA
columnB = TrColumn.construct trixelB
columnC = TrColumn.construct trixelC
columnD = TrColumn.construct trixelD
columnE = TrColumn.construct trixelE

columnA' = TrColumn.construct trixelA'
columnB' = TrColumn.construct trixelB'
columnC' = TrColumn.construct trixelC'

columns = [columnA, columnB, columnC]