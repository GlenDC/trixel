module Tests.Types.String (tests) where

import Trixel.Types.String as TrString

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assertEqual, assertNotEqual)


tests : Test
tests =
  suite "Types/String"
    [ test "toInt"
        (assertEqual
          42
          (TrString.toInt "42")
          )
    , test "toInt giving error"
        (assertNotEqual
          42
          (TrString.toInt "42.5")
          )
    , test "toFloat"
        (assertEqual
          123.456
          (TrString.toFloat "123.456")
          )
    , test "toFloat giving Int"
        (assertEqual
          123.0
          (TrString.toFloat "123")
          )
    , test "toFloat giving invalid Float"
        (assertNotEqual
          123.456
          (TrString.toFloat "123,456")
          )
    ]