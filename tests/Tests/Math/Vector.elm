module Tests.Math.Vector (tests) where

import Trixel.Math.Vector as TrVector
import Trixel.Math.Float as TrFloat

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assertEqual, assert, Assertion)


vectorA : TrVector.Vector
vectorA =
  TrVector.construct 4 8


vectorB : TrVector.Vector
vectorB =
  TrVector.construct 2 3


vectorC : TrVector.Vector
vectorC =
  TrVector.construct 6 8


assertEqualVector : TrVector.Vector -> TrVector.Vector -> Assertion
assertEqualVector a b =
  TrVector.compare a b
  |> assert


assertEqualFloat : Float -> Float -> Assertion
assertEqualFloat a b =
  TrFloat.compare a b
  |> assert


tests : Test
tests =
  suite "Math/Vector"
    [ test "compare"
        (assertEqualVector
          (TrVector.construct (5000 * 200) (-400 * 3000))
          (TrVector.construct (1000 * 1000) (-40 * 30000))
          )
    , test "add"
        (assertEqualVector
          (TrVector.construct 6 11)
          (TrVector.add vectorA vectorB)
          )
    , test "substract"
        (assertEqualVector
          (TrVector.construct 2 5)
          (TrVector.substract vectorA vectorB)
          )
    , test "computeLength"
        (assertEqualFloat
          10
          (TrVector.computeLength vectorC)
          )
    , test "computeDotProduct"
        (assertEqualFloat
          72
          (TrVector.computeDotProduct vectorA vectorB)
          )
    , test "scale"
        (assertEqualVector
          (TrVector.construct 40 80)
          (TrVector.scale vectorA 10)
          )
    ]