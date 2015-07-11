module Tests.Math.Bounds (tests) where

import Trixel.Math.Bounds as TrBounds

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assertEqual)


tests : Test
tests =
  suite "Math/Bounds"
    [ test "computeDimensions"
        (assertEqual
          { x = 2, y = 3 }
          (TrBounds.computeDimensions
            (TrBounds.construct 1 2 3 5)
            )
          )
    ]