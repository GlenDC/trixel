module Trixel.Types.Work2D.Column where

import Trixel.Math.Float as TrFloat
import Trixel.Types.Trixel as TrTrixel
import Trixel.Types.List as TrList

import List
import Maybe exposing (..)


type alias Columns = List Column

type alias Column =
  { position : Float
  , content : TrTrixel.Content
  }


construct : TrTrixel.Trixel -> Column
construct trixel =
  { position = trixel.position.x
  , content = TrTrixel.toContent trixel
  }


find : Float -> Columns -> Maybe Column
find position columns =
  TrList.find
    (\column ->
      TrFloat.isEqual column.position position)
    columns


insert : TrTrixel.Trixel -> Columns -> Columns
insert trixel columns =
  let column =
        construct trixel

      (columns', result) =
        TrList.replace
          (\a b ->
            TrFloat.isEqual a.position b.position)
          column
          columns
  in
    case result of
      -- adding new column to columns
      Nothing ->
        column :: columns

      -- replaced existing column with new column
      Just _ ->
        columns'


erasePosition : Float -> Columns -> (Columns, Maybe Column)
erasePosition position columns =
  erase
    (\column ->
      TrFloat.isEqual column.position position)
    columns


erase : (Column -> Bool) -> Columns -> (Columns, Maybe Column)
erase predicate columns =
  TrList.erase
    predicate
    columns