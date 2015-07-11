module Tests.Math.Vector (tests) where

import Trixel.Math.Vector as Vector
import Trixel.Math.Float exposing (compareFloats)

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assertEqual, assert, Assertion)


vectorA : Vector.Vector
vectorA =
  Vector.constructVector 4 8


vectorB : Vector.Vector
vectorB =
  Vector.constructVector 2 3


vectorC : Vector.Vector
vectorC =
  Vector.constructVector 6 8


assertEqualVector : Vector.Vector -> Vector.Vector -> Assertion
assertEqualVector a b =
  Vector.compareVectors a b
  |> assert


assertEqualFloat : Float -> Float -> Assertion
assertEqualFloat a b =
  compareFloats a b
  |> assert


tests : Test
tests =
  suite "Math/Vector"
    [ test "compareVectors"
        (assertEqualVector
          (Vector.constructVector (5000 * 200) (-400 * 3000))
          (Vector.constructVector (1000 * 1000) (-40 * 30000))
          )
    , test "addVectors"
        (assertEqualVector
          (Vector.constructVector 6 11)
          (Vector.addVectors vectorA vectorB)
          )
    , test "substractVectors"
        (assertEqualVector
          (Vector.constructVector 2 5)
          (Vector.substractVectors vectorA vectorB)
          )
    , test "computeVectorLength"
        (assertEqualFloat
          10
          (Vector.computeVectorLength vectorC)
          )
    , test "computeDotProduct"
        (assertEqualFloat
          72
          (Vector.computeDotProduct vectorA vectorB)
          )
    , test "scaleVector"
        (assertEqualVector
          (Vector.constructVector 40 80)
          (Vector.scaleVector vectorA 10)
          )
    ]