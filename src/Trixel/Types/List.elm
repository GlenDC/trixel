module Trixel.Types.List
  ( find
  , replace
  , replaceStable
  , erase
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


{-| Returns the first found item in a list, if any.

    find (\x -> x == 2) [1, 2, 2, 3] == Just 2
    find (\x -> x == 2) [1, 3] == Nothing
-}
find : (a -> Bool) -> List a -> Maybe a
find predicate list =
  case List.head list of
    -- Empty list or couldn't find it.
    Nothing ->
      Nothing 

    Just item ->
      if predicate item
        -- item has been found
        then Just item
        else
          tail list
          |> find predicate


{-| Replace the first item for which the predicate is valid.
    Returning the new list paired with the original item, if it exists.
    Note that the returned list doeesn't respects the order of  the original list.

    replace (\(_, x) (_, y) -> x == y) ("Nop", 2) [("Foo", 1), ("Bar", 2)]
      == ([("Foo", 1), ("Nop", 2)], Just ("Bar", 2))
    replace (\(_, x) (_, y) -> x == y) ("Nop", 0) [("Foo", 1), ("Bar", 2)]
      == ([("Bar", 2), ("Foo", 1)], Nothing)
-}
replace : (a -> a -> Bool) -> a -> List a -> (List a, Maybe a)
replace predicate item list =
  let (listA, listB, result) =
        replaceRecursive predicate item [] list
  in
    ((listA ++ listB), result)


{-| Replace the first item for which the predicate is valid.
    Returning the new list paired with the original item, if it exists.
    The returned list respects the order of  the original list.

    replaceStable (\(_, x) (_, y) -> x == y) ("Nop", 2) [("Foo", 1), ("Bar", 2)]
      == ([("Foo", 1), ("Nop", 2)], Just ("Bar", 2))
    replaceStable (\(_, x) (_, y) -> x == y) ("Nop", 0) [("Foo", 1), ("Bar", 2)]
      == ([("Foo", 1), ("Bar", 2)], Nothing)
-}
replaceStable : (a -> a -> Bool) -> a -> List a -> (List a, Maybe a)
replaceStable predicate item list =
  let (listA, listB, result) =
        replaceRecursive predicate item [] list

      listA' =
        List.reverse listA
  in
    ((listA' ++ listB), result)


-- Function internally used as the common logic to erase an element from a list
replaceRecursive : (a -> a -> Bool) -> a -> List a -> List a -> (List a, List a, Maybe a)
replaceRecursive predicate item newList oldList =
  case List.head oldList of
    -- Empty list or couldn't find it.
    Nothing ->
      (newList, oldList, Nothing)

    Just item' ->
      let oldList' = tail oldList
      in
        if predicate item' item
          -- Found & Replaced Item
          then (newList, item::oldList', Just item')
          else
            -- Item not found yet, but search continues
            replaceRecursive
              predicate
              item
              (item'::newList)
              oldList'


{-| Returns a list excluding the first-found item in the list, if any.
    Note that the order of elements in the list is not respected.

    erase (\x -> x == 2) [0, 1, 2] == ([1, 0], Just 2)
    erase (\x -> x == 2) [1, 3] == ([3, 1], Nothing)
-}
erase : (a -> Bool) -> List a -> (List a, Maybe a)
erase predicate list =
  let (listA, listB, result) =
        eraseRecursive predicate [] list
  in
    ((listA ++ listB), result)


{-| Returns a list excluding the first-found item in the list, if any.
    The order of the elements in the new list is equal to that of the original list.

    eraseStable (\x -> x == 2) [0, 1, 2] == ([0, 1], Just 2)
    eraseStable (\x -> x == 2) [1, 3] == ([1, 3], Nothing)
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
  case List.head oldList of
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
          else
            eraseRecursive
              predicate
              (item::newList)
              oldList'


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