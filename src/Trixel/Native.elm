module Trixel.Native
  ( mouseEnter
  , mouseLeave
  , mouseClick
  , hoverBackground
  )
  where

import Trixel.Types.Color as TrColor
import Trixel.Types.List as TrList
import List

import Html.Attributes as Attributes
import Html


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



mouseEnter : String -> List String -> Html.Attribute
mouseEnter function arguments =
  constructNativeCall function arguments
  |> Attributes.attribute "onmouseenter"


mouseLeave : String -> List String -> Html.Attribute
mouseLeave function arguments =
  constructNativeCall function arguments
  |> Attributes.attribute "onmouseleave"


mouseClick : String -> List String -> Html.Attribute
mouseClick function arguments =
  constructNativeCall function arguments
  |> Attributes.attribute "onclick"


hoverBackground : TrColor.RgbaColor -> Html.Html -> Html.Html
hoverBackground color element =
  let clojureGenerator =
        (\color -> "this.style.backgroundColor='" ++ color ++ "';")

      onMouseEnter =
        clojureGenerator (TrColor.toString color)
      onMouseLeave =
        clojureGenerator "rgba(0,0,0,0)"
  in
    Html.div
      [ Attributes.style [ ("background-color", "rgba(0,0,0,0)") ]
      , Attributes.attribute "onmouseenter" onMouseEnter
      , Attributes.attribute "onmouseleave" onMouseLeave
      ]
      [ element ]