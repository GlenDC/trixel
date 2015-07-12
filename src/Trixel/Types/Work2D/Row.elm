module Trixel.Types.Work2D.Row
  ( constructInitial
  , construct
  , findTrixel
  , insertTrixel
  , eraseTrixel
  )
  where

import Trixel.Math.Vector as TrVector
import Trixel.Math.Float as TrFloat
import Trixel.Types.Trixel as TrTrixel
import Trixel.Types.List as TrList

import Trixel.Types.Work2D.Column as TrColumn

import List
import Maybe exposing (..)


-- In a 2D environment Rows is the same as Grid
type alias Grid = Rows

type alias Rows = List Row

type alias Row =
  { position : Float
  , columns : TrColumn.Columns
  }


constructInitial : Float -> Row
constructInitial position =
  construct position []


construct: Float -> TrColumn.Columns -> Row
construct position columns =
  { position = position
  , columns = columns
  }


find : Float -> Rows -> Maybe Row
find position rows =
  TrList.find
    (\row ->
      TrFloat.isEqual row.position position)
    rows


findTrixel : TrVector.Vector -> Rows -> Maybe TrTrixel.Trixel
findTrixel position rows =
  let (rows', result) =
        erasePosition position.y rows
  in
    case result of
      -- Couldn't find row, early return
      Nothing ->
        Nothing

      Just row ->
        case TrColumn.find position.x row.columns of
      -- Couldn't find column in found row
          Nothing ->
            Nothing

          Just column ->
            TrTrixel.toTrixel column.content position
            |> Just


insertTrixel : TrTrixel.Trixel -> Rows -> Rows
insertTrixel trixel rows =
  let (rows', result) =
        erasePosition trixel.position.y rows
  in
    let row =
      case result of
        Nothing ->
          TrColumn.insert trixel []
          |> construct trixel.position.y

        Just row' ->
          { row'
              | columns <-
                  TrColumn.insert trixel row'.columns
          }
    in
      row :: rows'


eraseTrixel : TrVector.Vector -> Rows -> Rows
eraseTrixel position rows =
  let (rows', result) =
        erasePosition position.y rows
  in
    case result of
      -- Couldn't find row, returning original
      Nothing ->
        rows

      Just row ->
        -- Replacing column if possible
        let (columns', _) =
              TrColumn.erasePosition position.x row.columns
        in
          { row | columns <- columns'}
          :: rows'


erasePosition : Float -> Rows -> (Rows, Maybe Row)
erasePosition position rows =
  erase
    (\row ->
      TrFloat.isEqual row.position position)
    rows


erase : (Row -> Bool) -> Rows -> (Rows, Maybe Row)
erase predicate rows =
  TrList.erase
    predicate
    rows