module Trixel.Types.Grid
  ( TrixelGrid
  , GridColumns
  , GridRows
  , GridRow
  , Trixel
  , findTrixelInGrid
  , insertTrixelInGrid
  , eraseTrixelInGrid
  , constructNewTrixel
  , eraseGridTrixelByPredicate
  , eraseGridRowByPredicate
  )
  where

import Trixel.Types.Math exposing (..)

import Color exposing (Color)
import List exposing (..)
import Maybe exposing (..)


type alias TrixelGrid = GridRows


type alias GridColumns = List GridTrixel
type alias GridRows = List GridRow


type alias Trixel =
  { color : Color
  , position : Vector
  }


type alias TrixelContent =
  { color : Color
  }


type alias GridTrixel =
  { position : Int
  , content : TrixelContent
  }


type alias GridRow =
  { position : Int
  , columns : GridColumns
  }


eraseTrixelInGrid : Vector -> TrixelGrid -> TrixelGrid
eraseTrixelInGrid position grid =
  let y = round position.y
      x = round position.x
  in
    case findRow y grid of
      Nothing ->
        grid

      Just row ->
        let filteredGrid =
              eraseGridRow y grid

            filteredRow =
              eraseGridTrixel x row
        in
           { position = y
           , columns = filteredRow
           }
           :: filteredGrid


insertTrixelInGrid : Trixel -> TrixelGrid -> TrixelGrid
insertTrixelInGrid trixel grid =
  let x = round trixel.position.x
      y = round trixel.position.y

  in
      case findRow y grid of
        -- as we don't have the row
        -- we can just create it from scratch
        Nothing ->
          let gridRow =
                constructGridTrixel trixel
                |> constructGridRow y
          in
            gridRow :: grid

        -- we found row, now logic is the same no mather what
        -- we always want to override, so let's just do that
        Just row ->
          let gridTrixel =
                constructGridTrixel trixel

              filteredGrid =
                eraseGridRow y grid

              filteredRow =
                eraseGridTrixel x row
          in
             { position = y
             , columns = gridTrixel :: filteredRow
             }
             :: filteredGrid


findTrixelInGrid : Vector -> TrixelGrid -> Maybe Trixel
findTrixelInGrid position grid =
  case findRow (round position.y) grid of
    Nothing ->
      Nothing

    Just row ->
      case findColumn (round position.x) row of
        Nothing ->
          Nothing

        Just content ->
          constructTrixel position content
          |> Just


eraseGridTrixel : Int -> GridColumns -> GridColumns
eraseGridTrixel position columns =
  filter
    (\gridTrixel ->
      gridTrixel.position /= position)
    columns


eraseGridTrixelByPredicate : (GridTrixel -> Bool) -> GridColumns -> GridColumns
eraseGridTrixelByPredicate predicate columns =
  filter predicate columns


eraseGridRow : Int -> GridRows -> GridRows
eraseGridRow position rows =
  filter
    (\row ->
      row.position /= position)
    rows


eraseGridRowByPredicate : (GridRow -> Bool) -> GridRows -> GridRows
eraseGridRowByPredicate predicate rows =
  filter predicate rows


constructGridRow : Int -> GridTrixel -> GridRow
constructGridRow position gridTrixel =
  { position = position
  , columns = [gridTrixel]
  }


constructGridTrixel : Trixel -> GridTrixel
constructGridTrixel trixel =
  { position = round trixel.position.x
  , content = constructTrixelContent trixel
  }


findRow : Int -> GridRows -> Maybe GridColumns
findRow position rows =
  let filteredRows =
        filter
          (\gridRow ->
            gridRow.position == position)
          rows
  in
    case head filteredRows of
      Nothing ->
        Nothing

      Just row ->
        Just row.columns


findColumn : Int -> GridColumns -> Maybe TrixelContent
findColumn position columns =
  let filteredColumns =
        filter
          (\gridTrixel ->
            gridTrixel.position == position)
          columns
  in
    case head filteredColumns of
      Nothing ->
        Nothing

      Just column ->
        Just column.content


constructTrixel : Vector -> TrixelContent -> Trixel
constructTrixel position content =
  constructNewTrixel position content.color


constructTrixelContent : Trixel -> TrixelContent
constructTrixelContent trixel =
  { color = trixel.color
  }

constructNewTrixel : Vector -> Color -> Trixel
constructNewTrixel position color =
  { color = color
  , position = position
  }