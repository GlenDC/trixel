module Trixel.Math.Float (compare) where


epsilon : Float
epsilon = 0.001


compare : Float -> Float -> Bool
compare a b =
  abs (a - b) < epsilon