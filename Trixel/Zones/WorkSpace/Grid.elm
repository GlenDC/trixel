module Trixel.Zones.WorkSpace.Grid (updateGrid, renderMouse) where

import Trixel.Types.General exposing (..)
import Trixel.Types.Math exposing (..)
import Trixel.Constants exposing (..)

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

import Color exposing (Color, toRgb, rgba)


isPointInTriangle : Vector -> Vector -> Vector -> Vector -> Bool
isPointInTriangle p p0 p1 p2 =
  let s =
        p0.y * p2.x - p0.x * p2.y + (p2.y - p0.y) * p.x + (p0.x - p2.x) * p.y
      t =
        p0.x * p1.y - p0.y * p1.x + (p0.y - p1.y) * p.x + (p1.x - p0.x) * p.y
  in
    if (s < 0) /= (t < 0)
      then False
      else
        let a =
              -p1.y * p2.x + p0.y * (p2.x - p1.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y
        in
          if a < 0
            then -s > 0 && -t > 0 && (-s - t) < -a
            else s > 0 && t > 0 && (s + t) < a


updateGrid : State -> State
updateGrid state =
  let workspace =
        state.boxModels.workspace
      trixelInfo =
        state.trixelInfo

      (scaledWidth, scaledHeight, countX, countY) =
        if trixelInfo.mode == Vertical
          then
            ( workspace.width * trixelInfo.scale
            , workspace.height * trixelInfo.scale
            , trixelInfo.count.x
            , trixelInfo.count.y
            )
          else
            ( workspace.height * trixelInfo.scale
            , workspace.width * trixelInfo.scale
            , trixelInfo.count.y
            , trixelInfo.count.x
            )

      (deltaX, deltaY) =
        (countX + 1, sqrt3 * countY)

      scale =
        min (scaledWidth / deltaX) (scaledHeight / deltaY)

      (width, height) =
        (scale * deltaX, scale * deltaY)
      (triangleWidth, triangleHeight) =
        (width / deltaX, height / countY)

      (triangleOffsetX, triangleOffsetY, maxBoundsX, maxBoundsY) =
        if trixelInfo.mode == Vertical
          then (width / 2, height / 2, width, height)
          else (height / 2, width / 2, height, width)
  in
    { state
        | trixelInfo <-
            { trixelInfo
                | width <-
                    triangleWidth
                , height <-
                    triangleHeight
                , extraOffset <-
                    { x =
                        triangleOffsetX - trixelInfo.offset.x
                    , y =
                        triangleOffsetY - trixelInfo.offset.y
                    }
                , bounds <-
                    { min = zeroVector
                    , max =
                        { x = min workspace.width maxBoundsX
                        , y = min workspace.height maxBoundsY
                        }
                    }
                , dimensions <-
                    { x = maxBoundsX
                    , y = maxBoundsY
                    }
            }
    }
    |> generateGrid


normalizeCoordinates : Float -> Float -> Float
normalizeCoordinates coordinate size =
  coordinate - (size / 2)

getCoordinateFromIndex : Float -> Float -> Float -> Float
getCoordinateFromIndex count size offset =
  count
  |> (*) size
  |> normalizeCoordinates offset

renderTriangle : Float -> Float -> Float -> Float -> Float -> Float -> Shape
renderTriangle x y x' y' x'' y'' =
  polygon [ (x, y), (x', y'), (x'', y'') ]


renderTrixel: TrixelOrientation -> Float -> Float -> Float -> Float -> (Shape -> Form) -> Form
renderTrixel orientation x y triangleWidth triangleHeight styleFunction =
  let doubleWidth =
        triangleWidth * 2
      triangle =
        case orientation of
          Up ->
            renderTriangle
              x y
              (x + doubleWidth) y
              (x + triangleWidth) (y + triangleHeight)

          Down ->
            renderTriangle
              x (y + triangleHeight)
              (x + doubleWidth) (y + triangleHeight)
              (x + triangleWidth) y

          Left ->
            renderTriangle
              x (y + triangleWidth)
              (x + triangleHeight) y
              (x + triangleHeight) (y + doubleWidth)

          Right ->
            renderTriangle
              (x + triangleHeight) (y + triangleWidth)
              x y
              x (y + doubleWidth)
  in
    styleFunction triangle


getTrixelOrientation : Float -> Float -> TrixelMode -> TrixelOrientation
getTrixelOrientation x y mode =
  if (round (x + y)) % 2 == 0
    then
      if mode == Horizontal
        then Left
        else Down
    else
      if mode == Horizontal
        then Right
        else Up


renderTrixelRow: State -> Float -> Float -> Float -> Float -> List Form -> List Form
renderTrixelRow state countX countY width height trixels =
  if countX == 0
    then trixels
    else
      let x =
            ((countX - 1) * width) - state.trixelInfo.extraOffset.x
          y =
            ((countY - 1) * height) - state.trixelInfo.extraOffset.y
      in
        (renderTrixel
          (getTrixelOrientation countX countY state.trixelInfo.mode)
          x y
          state.trixelInfo.width state.trixelInfo.height
          (\triangle -> outlined (solid state.colorScheme.bg.elm) triangle)
        ) :: trixels
        |> renderTrixelRow state (countX - 1) countY width height


renderGrid : State -> Float -> Float -> Float -> Float -> List Form -> List Form
renderGrid state countX countY width height trixels =
  if countY == 0
    then
      trixels
    else
      renderTrixelRow state countX countY width height trixels
      |> renderGrid state countX (countY - 1) width height


generateGrid : State -> State
generateGrid state =
  let count =
        state.trixelInfo.count

      (triangleWidth, triangleHeight) =
        if state.trixelInfo.mode == Vertical
          then
            (state.trixelInfo.width, state.trixelInfo.height)
          else
            (state.trixelInfo.height, state.trixelInfo.width)
  in
    { state
        | grid <-
            renderGrid state count.x count.y triangleWidth triangleHeight []
    }


renderMouse: State -> Float -> Float -> List Form -> List Form
renderMouse state width height trixels =
  case state.mouseState of
    MouseNone ->
      trixels

    MouseHover position -> 
      if state.condition == IdleCondition
        then trixels
        else
          let (triangleWidth, triangleHeight) =
                  if state.trixelInfo.mode == Vertical
                    then
                      (state.trixelInfo.width, state.trixelInfo.height)
                    else
                      (state.trixelInfo.height, state.trixelInfo.width)
              x =
                (position.x * triangleWidth) - state.trixelInfo.extraOffset.x
              y =
                (position.y * triangleHeight) - state.trixelInfo.extraOffset.y
          in 
            (renderTrixel
              (getTrixelOrientation position.x position.y state.trixelInfo.mode)
              x y
              state.trixelInfo.width
              state.trixelInfo.height
              (\s -> filled (getHoverColor state) s)
            ) :: trixels


getHoverColor: State -> Color
getHoverColor state =
  let originalColor =
        toRgb state.colorScheme.subbg.elm
  in
    rgba
      (255 - originalColor.red)
      (255 - originalColor.green)
      (255 - originalColor.blue)
      0.5