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


replaceTests : Test
replaceTests =
  let a = ("Void", 0)
      a' = ("Nop", 0)

      b = ("Foo", 1)

      c = ("Bar", 2)
      c' = ("Baz", 2)

      d = ("Inf", 3)

      list = [a, b, c]


      predicate =
        (\(_, x) (_, y) -> x == y)
  in
    suite "replace"
      [ test "something"
          (assertEqual
            ([b, a, c'], Just c)
            (TrList.replace predicate c' list)
            )
      , test "stable something"
          (assertEqual
            ([a, b, c'], Just c)
            (TrList.replaceStable predicate c' list)
            )
      , test "nothing"
          (assertEqual
            ([c, b, a], Nothing)
            (TrList.replace predicate d list)
            )
      , test "stable nothing"
          (assertEqual
            (list, Nothing)
            (TrList.replaceStable predicate d list)
            )
      , test "`something` can be equal to `stable something`"
          (assertEqual
            (TrList.replace predicate a' list)
            (TrList.replaceStable predicate a' list)
            )
      , test "`nothing` can be equal to `stable nothing`"
          (assertEqual
            (TrList.replace predicate a [b])
            (TrList.replaceStable predicate a [b])
            )
      , test "nothing found in an empty list"
          (assertEqual
            ([], Nothing)
            (TrList.replace predicate a [])
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
    , replaceTests
    , eraseTests
    , headAndTailTests
    ]