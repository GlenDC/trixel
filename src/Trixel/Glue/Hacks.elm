module Trixel.Glue.Hacks where

import Native.GlueHacks


getViewportDimensions : String -> (Int, Int)
getViewportDimensions id =
  let dimensions = Native.GlueHacks.getViewportDimensions id
  in (round dimensions.x, round dimensions.y)
