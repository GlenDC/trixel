module Trixel.Types.List
  ( erase
  , eraseStable
  , head
  , tail
  )
  where

{-| Wrapper functions for Core.List functionality.
    todo: eraseAll;
-}

import List
import Maybe exposing (..)

{-| Returns a list excluding the first-found item in the list, if any.
    Note that the order of elements in the list is not respected.

    erase (\x -> x == 2) [1, 2, 3] == ([1, 3], Just 2)
    erase (\x -> x == 2) [1, 3] == ([1, 3], Nothing)
-}
erase : (a -> Bool) -> List a -> (List a, Maybe a)
erase predicate list =
  let (listA, listB, result) =
        eraseRecursive predicate [] list
  in
    ((listA ++ listB), result)


{-| Returns a list excluding the first-found item in the list, if any.
    The order of the elements in the new list is equal to that of the original list.
-}
eraseStable : (a -> Bool) -> List a -> (List a, Maybe a)
eraseStable predicate list =
  let (listA, listB, result) =
        eraseRecursive predicate [] list

      listA' =
        List.reverse listA
  in
    ((listA' ++ listB), result)


-- Function internally used as the common logic to erase an element from a list
eraseRecursive : (a -> Bool) -> List a -> List a -> (List a, List a, Maybe a)
eraseRecursive predicate newList oldList =
  case List.head oldList of ->
    Nothing ->
      -- Item was not in the list
      (newList, oldList, Nothing)

    Just item ->
      let oldList' = tail oldList
      in
        if predicate item
          -- Found Item and returning
          then (newList, oldList', Just item) 
          -- Item not Found yet, but we'll keep looking
          else eraseRecursive predicate newList oldList'


{-| Returns either the head of the given list or the given default value.

    head [1, 2, 3] 0 == 1
    head [] 0 == 0
-}
head : List a -> a -> a
head list default =
  case List.head list of
    Nothing ->
      default

    Just item ->
      item


{-| Returns the tail of the given list or an empty list of the same type.

    tail [1, 2, 3] == [2, 3]
    tail [1] == []
-}
tail : List a -> List a
tail list =
  case List.tail list of
    Nothing ->
      []

    Just list' ->
      list'