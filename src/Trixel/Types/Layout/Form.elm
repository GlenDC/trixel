module Trixel.Types.Layout.Form
  ( isValid
  , stringValue
  , IntegerField
  , integerField
  , setInteger
  , getInteger
  , TextField
  , textField
  , setText
  , getText
  ) where

import Maybe exposing (..)
import String
import Result


type alias Field valueType =
  { value : Maybe valueType
  , required : Bool
  , isValid : valueType -> Bool
  }


setValue : Field valueType -> Maybe valueType -> Field valueType
setValue field value =
  { field | value <- value }


isValid : Field valueType -> Bool
isValid field =
  case field.value of
    Nothing ->
      not field.required

    Just value ->
      field.isValid value


stringValue : Field valueType -> String
stringValue field =
  case field.value of
    Nothing -> ""
    Just value -> toString value


{-| An IntegerField contains a number and has range-validation -}
type alias IntegerField = Field Int


integerField : Maybe Int -> Int -> Int -> Bool -> IntegerField
integerField value min max required =
  { value = value
  , isValid = \x -> x >= min && x <= max
  , required = required
  }


setInteger : IntegerField -> String -> IntegerField
setInteger field string =
  let value =
        if string == ""
          then Nothing
          else String.toInt string |> Result.toMaybe
  in setValue field value


getInteger : IntegerField -> Int
getInteger field =
  withDefault 0 field.value


{-| A TxtField contains a text and has no validation -}
type alias TextField = Field String


textField : Maybe String -> Bool -> TextField
textField value required =
  { value = value
  , required = required
  , isValid = \_ -> True
  }


setText : TextField -> String -> TextField
setText field string =
  let value =
        if string == ""
          then Nothing
          else Just string
  in setValue field value


getText : TextField -> String
getText field =
  withDefault "" field.value
