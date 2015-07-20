module Trixel.Native
  ( mouseEnter
  , mouseLeave
  )
  where

import Trixel.Types.List as TrList
import List

import Html.Attributes as Attributes


sanitizeArgument : String -> String
sanitizeArgument argument =
  "'" ++ argument ++ "'"


constructNativeCall : String -> List String -> String
constructNativeCall function arguments =
  let aux = 
        TrList.head arguments ""
        |> sanitizeArgument

      argumentString =
        List.foldr
          (\item result ->
            result ++ "," ++ (sanitizeArgument item))
          aux
          (TrList.tail arguments)
  in
    function ++ "(" ++ argumentString ++ ");"



mouseEnter function arguments =
  constructNativeCall function arguments
  |> Attributes.attribute "onmouseenter"


mouseLeave function arguments =
  constructNativeCall function arguments
  |> Attributes.attribute "onmouseleave"