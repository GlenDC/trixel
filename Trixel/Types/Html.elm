module Trixel.Types.Html where

import Trixel.Types.Math exposing (..)

import Color exposing (toRgb, Color)


elmToHtmlColor : Color -> String
elmToHtmlColor color =
  let elmColor =
        toRgb color
  in
    "rgba("
      ++ (toString elmColor.red)
      ++ ","
      ++ (toString elmColor.green)
      ++ ","
      ++ (toString elmColor.blue)
      ++ ","
      ++ (toString elmColor.alpha)
      ++ ")"


zeroBoxModel : BoxModel
zeroBoxModel =
  constructBoxModel 0 0 0 0 0 0 ContentBox


constructBoxModel : Float -> Float -> Float -> Float -> Float -> Float -> BoxSizing -> BoxModel
constructBoxModel width height paddingX paddingY marginX marginY sizing =
  { width =
      width
  , height =
      height
  , padding =
      { x = paddingX
      , y = paddingY
      }
  , margin =
      { x = marginX
      , y = marginY
      }
  , sizing =
      sizing
  }


toPixels : Float -> String
toPixels value =
  (toString value) ++ "px"


vectorToPixels : Vector -> String
vectorToPixels vector =
  (toPixels vector.y) ++ " " ++ (toPixels vector.x)


computeBoxModelCSS : BoxModel -> List CSSProperty
computeBoxModelCSS boxModel =
  [ ("width", toPixels boxModel.width)
  , ("height", toPixels boxModel.height)
  , ("margin", vectorToPixels boxModel.margin)
  , ("padding", vectorToPixels boxModel.padding)
  , computeBoxSizingCSS boxModel.sizing
  ]


computeDimensionsFromBoxModel : BoxModel -> (Float, Float)
computeDimensionsFromBoxModel boxModel =
  case boxModel.sizing of
    BorderBox ->
      ( boxModel.width + boxModel.padding.x + boxModel.margin.x
      , boxModel.height + boxModel.padding.y + boxModel.margin.y
      )

    _ ->
      ( boxModel.width
      , boxModel.height
      )


type alias BoxModel =
  { width : Float
  , height : Float
  , margin : Vector
  , padding : Vector
  , sizing: BoxSizing
  }


computeBoxSizingCSS : BoxSizing -> CSSProperty
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


computeDefaultBorderCSS: String -> CSSProperty
computeDefaultBorderCSS color =
  computeBorderCSS 1 BorderAll SolidBorder color


computeBorderCSS : Float -> BorderPosition -> BorderStyle -> String -> CSSProperty
computeBorderCSS size borderPosition borderStyle color =
  ( computeBorderPositionCSSValue borderPosition
  , (toPixels size)
      ++ " "
      ++ (computeBorderStyleCSSValue borderStyle)
      ++ " "
      ++ color
  )


computeBorderStyleCSSValue : BorderStyle -> String
computeBorderStyleCSSValue borderStyle =
  case borderStyle of
    SolidBorder
      -> "solid"

    DashedBorder
      -> "dashed"

    DottedBorder
      -> "dotted"


computeBorderPositionCSSValue : BorderPosition -> String
computeBorderPositionCSSValue borderPosition =
  case borderPosition of
    BorderAll
      -> "border"

    BorderTop
      -> "border-top"

    BorderBottom
      -> "border-bottom"

    BorderLeft
      -> "border-left"

    BorderRight
      -> "border-right"


-- The sizing behaviour for a `BoxModel`
type BoxSizing
  = ContentBox -- dimensions defined by content
  | BorderBox -- dimensions defined by content, padding and border
  | InitialBox -- sets property to its default value
  | InheritBox -- inherits the property from its parent element


type BorderPosition
  = BorderAll
  | BorderTop
  | BorderBottom
  | BorderRight
  | BorderLeft


type BorderStyle
  = SolidBorder
  | DashedBorder
  | DottedBorder


type alias CSSProperty = (String, String)