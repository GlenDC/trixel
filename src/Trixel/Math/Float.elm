module Trixel.Math.Float (compareFloats) where


epsilon : Float
epsilon = 0.001


compareFloats : Float -> Float -> Bool
compareFloats a b =
  abs (a - b) < epsilon