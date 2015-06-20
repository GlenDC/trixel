module Trixel.Html where


import Trixel.Math exposing (..)


zeroBoxModel : ContentBox
zeroBoxModel =
  constructBoxModel 0 0 0 0 0 0 ContentBox


constructBoxModel : Float -> Float -> Float -> Float -> Float -> Float -> BoxSizing -> BoxModel
constructBoxModel width height paddingX paddingY marginX marginY sizing =
  { width = width
  , height = height
  , padding =
    { x = paddingX
    , y = paddingY
    }
  , margin =
    { x = marginX
    , y = marginY
    }
  , sizing = sizing
  }


floatToPixels : Float -> String
floatToPixels value =
  (toString value) ++ "px"


intToPixels : Int -> String
intToPixels value =
  (toString value) ++ "px"


floatVectorToPixels : FloatVector -> String
floatVectorToPixels vector =
  (fromFloatToPixels vector.y) ++ " " ++ (fromFloatToPixels vector.x)


intVectorToPixels : IntVector -> String
intVectorToPixels vector =
  (intToPixels vector.y) ++ " " ++ (intToPixels vector.x)


computeBoxModelCSS : BoxModel -> List (String, String)
computeBoxModelCSS boxModel =
  [ ("width", floatToPixels boxModel.width)
  , ("height", floatToPixels boxModel.height)
  , ("margin", floatVectorToPixels boxModel.margin)
  , ("padding", floatVectorToPixels boxModel.padding)
  , computeBoxSizingCSS boxModel.sizing
  ]


type alias BoxModel =
  { width : Float
  , height : Float
  , margin : FloatVec2D
  , padding : FloatVec2D
  , sizing: BoxSizing
  }


computeBoxSizingCSS : BoxSizing -> (String, String)
computeBoxSizingCSS boxSizing =
  ( "box-sizing"
  , case boxSizing of
      ContentBox
        -> "content-box"

      BorderBox
        -> "border-box"

      InitialBox
        -> "initial"

      InheritBox
        -> "inherit"
  )


-- The sizing behaviour for a `BoxModel`
type BoxSizing
  = ContentBox -- dimensions defined by content
  | BorderBox -- dimensions defined by content, padding and border
  | InitialBox -- sets property to its default value
  | InheritBox -- inherits the property from its parent element