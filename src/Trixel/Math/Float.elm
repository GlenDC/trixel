module Trixel.Math.Float
  ( isEqual
  , isNotEqual
  )
  where


epsilon : Float
epsilon = 0.001


isEqual : Float -> Float -> Bool
isEqual a b =
  abs (a - b) < epsilon


isNotEqual : Float -> Float -> Bool
isNotEqual a b =
  isEqual a b
  |> not