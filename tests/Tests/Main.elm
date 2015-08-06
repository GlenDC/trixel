module Tests.Main where

import Tests.Types.Input as TrInput
import Tests.Types.String as TrString
import Tests.Types.List as TrList

import Tests.Types.Work2D.Column as TrColumn
import Tests.Types.Work2D.Row as TrRow

import Tests.Math.Float as TrFloat
import Tests.Math.Bounds as TrBounds

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Runner.Element exposing (runDisplay)
import Graphics.Element exposing (..)


tests : Test
tests =
  suite "Trixel Unit Tests"
    [ TrInput.tests
    , TrString.tests
    , TrList.tests

    , TrColumn.tests
    , TrRow.tests

    , TrFloat.tests
    , TrBounds.tests
    ]

main : Element
main =
  runDisplay tests