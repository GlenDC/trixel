module Trixel.Graphics where

import Trixel.Types.Color as TrColor
import Trixel.Math.Vector as TrVector

import Trixel.Models.Footer as TrFooterModel

import Graphics.Collage as Collage
import Graphics.Element as Element
import Graphics.Input as Input
import Text

import Maybe exposing (..)
import Signal

import Html
import Html.Attributes as HtmlAttributes


type TextAlignment
  = LeftAligned
  | RightAligned
  | CenterAligned

alignText : TextAlignment -> Text.Text -> Element.Element
alignText alignment text =
  case alignment of
    LeftAligned ->
      Element.leftAligned text

    RightAligned ->
      Element.rightAligned text

    CenterAligned ->
      Element.centered text


text : String -> Float -> TrColor.RgbaColor -> Bool -> Bool -> Maybe Text.Line -> TextAlignment -> Element.Element
text title size color bold italic line alignment =
  let textElement =
        Text.fromString title
          |> Text.style
              { typeface = ["Open Sans", "sans-serif"]
              , height = Just size
              , color = TrColor.toColor color
              , bold = bold
              , italic = italic
              , line = line
              }
          |> alignText alignment

      (width, height) = Element.sizeOf textElement
  in
    Element.size
      (width + (round (size * 0.5)))
      (height + (round (size * 0.5)))
      textElement


computeDimensions : Element.Element -> TrVector.Vector
computeDimensions element =
  let (x, y) = Element.sizeOf element
  in TrVector.construct (toFloat x) (toFloat y)


hoverable : String -> TrVector.Vector -> Element.Element -> Element.Element
hoverable message dimensions element =
  let htmlElement =
        Html.fromElement element
  in
    Html.div [ HtmlAttributes.class "tr-hoverable" ] [ htmlElement ]
    |> Html.toElement (round dimensions.x) (round dimensions.y)
    |> Input.hoverable (TrFooterModel.computeMessageFunction message)


button : String -> String -> Bool -> Float -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> Signal.Address a -> a -> Element.Element
button title help selected size padding' normal select address action =
  let up = text
        title size normal False False Nothing CenterAligned
      hover = text
        title size select False False (Just Text.Under) CenterAligned

      padding =
        TrVector.construct padding' padding'

      buttonElement =
        Input.customButton
          (Signal.message address action)
          (if selected then hover else up)
          hover hover

      buttonDimensions =
        computeDimensions buttonElement
  in
    hoverable help buttonDimensions buttonElement
    |> applyPadding buttonDimensions padding


image : TrVector.Vector -> TrVector.Vector -> String -> Element.Element
image dimensions padding src =
  Element.image (round dimensions.x) (round dimensions.y) src
  |> applyPadding dimensions padding


applyPadding : TrVector.Vector -> TrVector.Vector -> Element.Element -> Element.Element
applyPadding dimensions padding element =
  Collage.toForm element
  |> toElement (TrVector.add dimensions (TrVector.scale 2 padding))


toElement : TrVector.Vector -> Collage.Form -> Element.Element
toElement dimensions form =
  collage dimensions [form]


collage : TrVector.Vector -> List Collage.Form -> Element.Element
collage dimensions forms =
  Collage.collage
    (round dimensions.x)
    (round dimensions.y)
    forms


setDimensions : TrVector.Vector -> Element.Element -> Element.Element
setDimensions dimensions element =
  Element.size
    (round dimensions.x)
    (round dimensions.y)
    element


background : TrColor.RgbaColor -> TrVector.Vector -> Collage.Form
background color dimensions =
  Collage.rect dimensions.x dimensions.y
  |> Collage.filled (TrColor.toColor color)