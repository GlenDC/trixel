module Trixel.Types.String where

import String


toInt : String -> Int
toInt string =
  case (String.toInt string) of
    Ok value -> value
    Err error -> 0


toFloat : String -> Float
toFloat string =
  case (String.toFloat string) of
    Ok value -> value
    Err error -> 0