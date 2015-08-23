module Trixel.Native
  ( Function
  , function
  , mouseEnter
  , mouseLeave
  , mouseClick
  , drop
  , dragOver
  , dragStart
  , dragEnd
  , dragEnter
  , dragLeave
  , hoverBackground
  )
  where

import Trixel.Types.Color as TrColor
import Trixel.Types.List as TrList
import List

import Html.Attributes as Attributes
import Html


type alias Function =
  { name : String
  , arguments : List String
  }

function : String -> List String -> Function
function name arguments =
  { name = name
  , arguments = arguments
  }


sanitizeArgument : String -> String
sanitizeArgument argument =
  "'" ++ argument ++ "'"


constructNativeCall : Function -> String
constructNativeCall function =
  let aux = 
        TrList.head function.arguments ""
        |> sanitizeArgument

      argumentString =
        List.foldr
          (\item result ->
            result ++ "," ++ (sanitizeArgument item))
          aux
          (TrList.tail function.arguments)
  in
    function.name ++ "(" ++ argumentString ++ ");"


functionAttribute : String -> (Function -> Html.Attribute)
functionAttribute name =
  (\function ->
    constructNativeCall function
    |> Attributes.attribute name
  )

mouseEnter : Function -> Html.Attribute
mouseEnter =
  functionAttribute "onmouseenter"


mouseLeave : Function -> Html.Attribute
mouseLeave =
  functionAttribute "onmouseleave"


mouseClick : Function -> Html.Attribute
mouseClick =
  functionAttribute "onmouseleave"


drop : Function -> Html.Attribute
drop =
  functionAttribute "ondrop"


dragOver : Function -> Html.Attribute
dragOver =
  functionAttribute "ondragover"


dragStart : Function -> Html.Attribute
dragStart =
  functionAttribute "ondragstart"


dragEnd : Function -> Html.Attribute
dragEnd =
  functionAttribute "ondragend"


dragEnter : Function -> Html.Attribute
dragEnter =
  functionAttribute "ondragenter"


dragLeave : Function -> Html.Attribute
dragLeave =
  functionAttribute "ondragleave"


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
