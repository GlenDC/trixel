module Tests.Main where

import Tests.Types.Input as Input
import Tests.Math.Float as Float
import Tests.Math.Vector as Vector

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Runner.Element exposing (runDisplay)
import Graphics.Element exposing (..)


tests : Test
tests =
  suite "Trixel Unit Tests"
    [ Input.tests
    , Float.tests
    , Vector.tests
    ]

main : Element
main =
  runDisplay tests