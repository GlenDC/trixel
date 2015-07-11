module Tests.Math.Float (tests) where

import Trixel.Math.Float as TrFloat

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assertEqual, assert, Assertion)


assertEqualFloat : Float -> Float -> Assertion
assertEqualFloat a b =
  TrFloat.compare a b
  |> assert


tests : Test
tests =
  suite "Math/Float"
    [ test "compareFloats ~1.000.000"
        (assertEqualFloat
          (5000 * 200)
          (1000 * 1000)
          )
    , test "compareFloats ~1.200.000"
        (assertEqualFloat
          (-400 * 3000)
          (-40 * 30000)
          )
    ]