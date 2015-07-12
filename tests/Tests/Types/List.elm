module Tests.Types.List (tests) where

import Trixel.Types.List as TrList

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assertEqual, assertNotEqual)


findTests : Test
findTests =
  suite "find"
    [ test "something"
        (assertEqual
          (Just 2)
          (TrList.find (\x -> x == 2) [1, 2, 2, 3])
          )
    , test "nothing"
        (assertEqual
          (Nothing)
          (TrList.find (\x -> x == 2) [1, 3])
          )
    ]


eraseTests : Test
eraseTests =
  suite "erase"
    [ test "something"
        (assertEqual
          ([1, 0, 2], Just 2)
          (TrList.erase (\x -> x == 2) [0, 1, 2, 2])
          )
    , test "stable something"
        (assertEqual
          ([0, 1, 2], Just 2)
          (TrList.eraseStable (\x -> x == 2) [0, 1, 2, 2])
          )
    , test "nothing"
        (assertEqual
          ([3, 1], Nothing)
          (TrList.erase (\x -> x == 2) [1, 3])
          )
    , test "stable nothing"
        (assertEqual
          ([1, 3], Nothing)
          (TrList.eraseStable (\x -> x == 2) [1, 3])
          )
    ]


headAndTailTests : Test
headAndTailTests =
  suite "head && erase"
    [ test "head value"
        (assertEqual
          (1)
          (TrList.head [1] 42)
          )
    , test "head default"
        (assertEqual
          (42)
          (TrList.head [] 42)
          )

    , test "tail something"
        (assertEqual
          [2, 3]
          (TrList.tail [1, 2, 3])
          )
    , test "tail nothing"
        (assertEqual
          []
          (TrList.tail [1])
          )
    ]


tests : Test
tests =
  suite "Types/List"
    [ findTests
    , eraseTests
    , headAndTailTests
    ]