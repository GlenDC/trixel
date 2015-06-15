module Trixel.Grid (updateGrid) where

import Trixel.Types exposing (..)
import Trixel.Constants exposing (..)

---

getCountX: Float -> TrixelMode -> Float
getCountX x mode =
  if mode == Horizontal then x else
    let a = toFloat ((round x) % 2)
    in ((x + (1 - a)) / 2) + (a * 0.5)

getCountY: Float -> TrixelMode -> Float
getCountY y mode =
  if mode == Vertical then y else
    let a = toFloat ((round y) % 2)
    in ((y + (1 - a)) / 2) + (a * 0.5)

---

updateGrid: State -> State
updateGrid state =
  let trixelInfo = state.trixelInfo

      workspace = state.html.dimensions.workspace

      count = trixelInfo.count
      (cx, cy) = ((toFloat count.x), (toFloat count.y))

      (sx, sy) = (workspace.w * trixelInfo.scale,
                  workspace.h * trixelInfo.scale)

      (cx', cy') = ((getCountX cx trixelInfo.mode),
                    (getCountY cy trixelInfo.mode))
      ts = if (sx / cx' * cy') > sy
        then (sy / cy')
        else (sx / cx')

      (w, h) = (ts * cx', ts * cy')

      (minX, minY) = (
        (state.dimensions.x - w) / 2,
        (state.dimensions.y - w) / 2
        )
  in
    { state | trixelInfo <- {
      trixelInfo |
        size <- ts,
        bounds <- {
          min = { x = (round minX), y = (round minY) },
          max = {
            x = round (minX + w),
            y = round (minY + h)
            } } } }