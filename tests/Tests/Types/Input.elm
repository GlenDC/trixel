module Tests.Types.Input (tests) where

import Trixel.Types.Input as Input

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assertEqual)


pressedButtonTestSuite : Test
pressedButtonTestSuite =
  suite "computePressedButtonList"
    [ test "One Key Press"
        (assertEqual
          [42]
          (Input.computePressedButtonList [42] [])
          )
    , test "Empty Impossible Situation"
        (assertEqual
          []
          (Input.computePressedButtonList [] [])
          )
    , test "Only Keys Down"
        (assertEqual
          []
          (Input.computePressedButtonList [] [1, 3, 4, 5])
          )
    , test "Multiple Key Presses"
        (assertEqual
          [2, 4]
          (Input.computePressedButtonList [1, 2, 3, 4, 5] [1, 3, 5])
          )
    ]


tests : Test
tests =
  suite "Types/Input"
    [ pressedButtonTestSuite
    ]