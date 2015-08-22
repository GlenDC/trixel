module Trixel.Glue.Random where

import Native.GlueRandom


randomFloat : Float -> Float -> Float
randomFloat =
  Native.GlueRandom.randomFloat


randomInt : Int -> Int -> Int
randomInt =
  Native.GlueRandom.randomInt
