module Tests.Math.Bounds (tests) where

import Trixel.Math.Bounds as TrBounds

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assertEqual)

import Math.Vector2 as Vector


tests : Test
tests =
  suite "Math/Bounds"
    [ test "computeDimensions"
        (assertEqual
          (Vector.vec2 2 3)
          (TrBounds.computeDimensions
            (TrBounds.construct 1 2 3 5)
            )
          )
    ]