module Trixel.Types.Work2D.Row
  ( Grid
  , Rows
  , Row
  , constructInitial
  , construct
  , findTrixel
  , insertTrixel
  , eraseTrixel
  )
  where

import Trixel.Math.Float as TrFloat
import Trixel.Types.Trixel as TrTrixel
import Trixel.Types.List as TrList

import Trixel.Types.Work2D.Column as TrColumn

import List
import Maybe exposing (..)
import Math.Vector2 as Vector


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


findTrixel : Vector.Vec2 -> Rows -> Maybe TrTrixel.Trixel
findTrixel position rows =
  let (posX, posY) = Vector.toTuple position

      (rows', result) =
        erasePosition posY rows
  in
    case result of
      -- Couldn't find row, early return
      Nothing ->
        Nothing

      Just row ->
        case TrColumn.find posX row.columns of
      -- Couldn't find column in found row
          Nothing ->
            Nothing

          Just column ->
            TrTrixel.toTrixel column.content position
            |> Just


insertTrixel : TrTrixel.Trixel -> Rows -> Rows
insertTrixel trixel rows =
  let posY = Vector.getY trixel.position

      (rows', result) =
        erasePosition posY rows
  in
    let row =
      case result of
        Nothing ->
          TrColumn.insert trixel []
          |> construct posY

        Just row' ->
          { row'
              | columns <-
                  TrColumn.insert trixel row'.columns
          }
    in
      row :: rows'


eraseTrixel : Vector.Vec2 -> Rows -> Rows
eraseTrixel position rows =
  let (posX, posY) = Vector.toTuple position

      (rows', result) =
        erasePosition posY rows
  in
    case result of
      -- Couldn't find row, returning original
      Nothing ->
        rows

      Just row ->
        -- Replacing column if possible
        let (columns', _) =
              TrColumn.erasePosition posX row.columns
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