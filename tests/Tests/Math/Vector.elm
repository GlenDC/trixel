module Tests.Math.Vector (tests) where

import Trixel.Math.Vector as Vector

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assertEqual)


vectorA : Vector.Vector
vectorA =
  Vector.constructVector 4 8


vectorB : Vector.Vector
vectorB =
  Vector.constructVector 2 3


vectorC : Vector.Vector
vectorC =
  Vector.constructVector 6 8


tests : Test
tests =
  suite "Math/Vector"
    [ test "addVectors"
        (assertEqual
          (Vector.constructVector 6 11)
          (Vector.addVectors vectorA vectorB)
          )
    , test "substractVectors"
        (assertEqual
          (Vector.constructVector 2 5)
          (Vector.substractVectors vectorA vectorB)
          )
    , test "computeVectorLength"
        (assertEqual
          10
          (Vector.computeVectorLength vectorC)
          )
    , test "computeDotProduct"
        (assertEqual
          72
          (Vector.computeDotProduct vectorA vectorB)
          )
    , test "computeVectorElementOperation -> scale"
        (assertEqual
          (Vector.constructVector 40 80)
          (Vector.computeVectorElementOperation (*) vectorA 10)
          )
    ]