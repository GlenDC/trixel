module Tests.Types.Work2D.Column (tests) where

import Tests.Types.Work2D.SharedTestVariables exposing (..)

import Trixel.Types.Work2D.Column as TrColumn
import Trixel.Types.Trixel as TrTrixel
import Trixel.Types.Color as TrColor

import Maybe exposing (..)

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assertEqual, assertNotEqual)


findTests : Test
findTests =
  suite "find"
    [ test "found column"
        (assertEqual
          (Just columnB)
          (TrColumn.find columnB.position columns)
          )
    , test "found nothing"
        (assertEqual
          (Nothing)
          (TrColumn.find 0 columns)
          )
    ]


insertTests : Test
insertTests =
  suite "insert"
    [ test "replacing existing value"
        (assertEqual
          [columnB, columnA, columnC']
          (TrColumn.insert trixelC' columns)
          )
    , test "adding new value"
        (assertEqual
          [columnD, columnA, columnB, columnC]
          (TrColumn.insert trixelD columns)
          )
    , test "adding value to empty list"
        (assertEqual
          [columnD]
          (TrColumn.insert trixelD [])
          )
    ]


eraseTests : Test
eraseTests =
  suite "erase"
    [ test "erase column"
        (assertEqual
          ([columnB, columnA], Just columnC)
          (TrColumn.erasePosition columnC'.position columns)
          )
    , test "erase nothing"
        (assertEqual
          ([columnA], Nothing)
          (TrColumn.erasePosition 42 [columnA])
          )
    , test "erase nothing from empty list"
        (assertEqual
          ([], Nothing)
          (TrColumn.erasePosition 42 [])
          )
    ]


tests : Test
tests =
  suite "Types/Work2D/Column"
    [ findTests
    , insertTests
    , eraseTests
    ]