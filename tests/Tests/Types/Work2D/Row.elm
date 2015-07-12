module Tests.Types.Work2D.Row (tests) where

import Tests.Types.Work2D.SharedTestVariables exposing (..)

import Trixel.Types.Work2D.Row as TrRow
import Trixel.Types.Trixel as TrTrixel
import Trixel.Types.Color as TrColor
import Trixel.Math.Vector as TrVector


import Maybe exposing (..)

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assertEqual, assertNotEqual)


rowA = TrRow.construct 1 [columnA, columnB, columnC]
rowB = TrRow.construct 2 [columnA, columnB, columnC]
rowC = TrRow.construct 3 [columnA, columnB, columnC]
rowD = TrRow.construct 5 [columnD]

rowA' = TrRow.construct 1 [columnB, columnA, columnC']
rowA'' = TrRow.construct 1 [columnB, columnA]
rowC' = TrRow.construct 3 [columnE, columnA, columnB, columnC]
rowC'' = TrRow.construct 3 [columnC, columnB, columnA]

rows = [rowA, rowB, rowC]


findTrixelTests : Test
findTrixelTests =
  suite "findTrixel"
    [ test "found row"
        (assertEqual
          (Just trixelB)
          (TrRow.findTrixel (TrVector.construct 4 2) rows)
          )
    , test "found nothing because of row"
        (assertEqual
          (Nothing)
          (TrRow.findTrixel (TrVector.construct 2 0) rows)
          )
    , test "found nothing because of column"
        (assertEqual
          (Nothing)
          (TrRow.findTrixel (TrVector.construct 0 1) rows)
          )
    ]


insertTrixelTests : Test
insertTrixelTests =
  suite "insertTrixel"
    [ test "insert new Trixel because of column"
        (assertEqual
          [rowC', rowB, rowA]
          (TrRow.insertTrixel trixelE rows)
          )
    , test "insert new Trixel because of row"
        (assertEqual
          [rowD, rowC, rowB, rowA]
          (TrRow.insertTrixel trixelD rows)
          )
    , test "replacing Trixel because of column and row"
        (assertEqual
          [rowA', rowB, rowC]
          (TrRow.insertTrixel trixelC' rows)
          )
    ]


eraseTrixelTests : Test
eraseTrixelTests =
  suite "eraseTrixel"
    [ test "erase nothing because of row"
        (assertEqual
          rows
          (TrRow.eraseTrixel trixelD.position rows)
          )
    , test "erase nothing because of column"
        (assertEqual
          [rowC'', rowB, rowA]
          (TrRow.eraseTrixel trixelE.position rows)
          )
    , test "erase something"
        (assertEqual
          [rowA'', rowB, rowC]
          (TrRow.eraseTrixel trixelC.position rows)
          )
    ]


tests : Test
tests =
  suite "Types/Work2D/Row"
    [ findTrixelTests
    , insertTrixelTests
    , eraseTrixelTests
    ]