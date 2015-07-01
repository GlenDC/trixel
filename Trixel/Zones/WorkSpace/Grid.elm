module Trixel.Zones.WorkSpace.Grid
  ( updateGrid
  , updateLayers
  , renderMouse
  )
  where

import Trixel.Types.General exposing (..)
import Trixel.Types.Math exposing (..)
import Trixel.Constants exposing (..)

import Trixel.Types.Layer exposing (..)
import Trixel.Types.Grid exposing (..)

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

import Color exposing (Color, toRgb, rgba)

import List exposing (..)


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

      baseSize =
        (min state.windowDimensions.x state.windowDimensions.y) / 20

      triangleWidth =
        baseSize * trixelInfo.scale
      triangleHeight =
        sqrt3 * baseSize * trixelInfo.scale

  in
    { state
        | trixelInfo <-
            { trixelInfo
                | width <-
                    triangleWidth
                , height <-
                    triangleHeight
                , dimensions <-
                    { x = workspace.width
                    , y = workspace.height
                    }
            }
    }
    |> updateLayers


updateLayers : State -> State
updateLayers state =
  let renderCache =
        state.renderCache
  in
    { state
        | renderCache <-
            { renderCache
                | layers <- renderGridLayers state
            }
    }


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
      if mode == IsometricMode
        then Left
        else Down
    else
      if mode == IsometricMode
        then Right
        else Up


renderMouse : State -> Float -> Float -> List Form -> List Form
renderMouse state width height trixels =
  case state.mouseState of
    MouseHover position -> 
      if state.condition /= NormalCondition
        then trixels
        else
          let (triangleWidth, triangleHeight) =
                  if state.trixelInfo.mode == ClassicMode
                    then
                      (state.trixelInfo.width, state.trixelInfo.height)
                    else
                      (state.trixelInfo.height, state.trixelInfo.width)
              x =
                (position.x * triangleWidth) - state.trixelInfo.offset.x
              y =
                (position.y * triangleHeight) - state.trixelInfo.offset.y
          in 
            (renderTrixel
              (getTrixelOrientation position.x position.y state.trixelInfo.mode)
              x y
              state.trixelInfo.width
              state.trixelInfo.height
              (\s -> filled (getHoverColor state) s)
            ) :: trixels

    _ ->
      trixels


type alias StaticTrixelRenderInfo =
  { offset : Vector
  , dimensions : Vector
  , positionDimensions : Vector
  , mode : TrixelMode
  }


renderGridTrixel : Float -> Float -> StaticTrixelRenderInfo -> Color -> List Form -> List Form
renderGridTrixel x y renderInfo color trixels =
  let xPosition =
        (x * renderInfo.positionDimensions.x) - renderInfo.offset.x
      yPosition =
        (y * renderInfo.positionDimensions.y) - renderInfo.offset.y
  in
    (renderTrixel
      (getTrixelOrientation x y renderInfo.mode)
      xPosition yPosition
      renderInfo.dimensions.x
      renderInfo.dimensions.y
      (\s -> filled color s)
    ) :: trixels

renderColumn : GridColumns -> Float -> StaticTrixelRenderInfo -> List Form -> List Form
renderColumn columns y renderInfo trixels =
  case head columns of
    Nothing ->
      trixels

    Just gridTrixel ->
      renderGridTrixel
        (toFloat gridTrixel.position)
        y
        renderInfo
        gridTrixel.content.color
        trixels
      |> renderColumn (drop 1 columns) y renderInfo


renderLayer : GridRows -> StaticTrixelRenderInfo -> List Form -> List Form
renderLayer rows renderInfo trixels =
  case head rows of
    Nothing ->
      trixels

    Just row ->
      renderColumn row.columns (toFloat row.position) renderInfo trixels
      |> renderLayer (drop 1 rows) renderInfo


renderLayers : TrixelLayers -> StaticTrixelRenderInfo -> List Form -> List Form
renderLayers layers renderInfo trixels =
  case head layers of
    Nothing ->
      trixels

    Just layer ->
      renderLayer layer.grid renderInfo trixels
      |> renderLayers (drop 1 layers) renderInfo


renderGridLayers : State -> List Form
renderGridLayers state =
  let (width, height) =
        if state.trixelInfo.mode == ClassicMode
          then
            (state.trixelInfo.width, state.trixelInfo.height)
          else
            (state.trixelInfo.height, state.trixelInfo.width)

      layers =
        getLayers state
  in
    renderLayers
      layers
      { offset =
          state.trixelInfo.offset
      , dimensions =
          { x = state.trixelInfo.width
          , y = state.trixelInfo.height
          }
      , positionDimensions =
          { x = width
          , y = height
          }
      , mode = state.trixelInfo.mode
      }
      []


getHoverColor : State -> Color
getHoverColor state =
  let originalColor =
        toRgb state.trixelColor

      red = toFloat originalColor.red
      green = toFloat originalColor.green
      blue = toFloat originalColor.blue
  in
    rgba
      (round ((255 - red) * 0.1 + red * 0.8 + 255 * 0.1))
      (round ((255 - green) * 0.1 + green * 0.9))
      (round ((255 - blue) * 0.1 + blue * 0.9))
      0.85