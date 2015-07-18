module Trixel.Graphics where

import Trixel.Types.Color as TrColor
import Trixel.Math.Vector as TrVector

import Graphics.Collage as Collage
import Graphics.Element as Element
import Graphics.Input as Input
import Text

import Maybe exposing (..)
import Signal

import Html
import Html.Attributes as HtmlAttributes


hover : Signal.Mailbox Bool
hover =
  Signal.mailbox False
hoverAddress = hover.address


text : String -> Float -> TrColor.RgbaColor -> Bool -> Bool -> Maybe Text.Line -> Element.Element
text title size color bold italic line =
  Text.fromString title
  |> Text.style
      { typeface = ["Open Sans", "sans-serif"]
      , height = Just size
      , color = TrColor.toColor color
      , bold = bold
      , italic = italic
      , line = line
      }
  |> Element.centered


computeDimensions : Element.Element -> TrVector.Vector
computeDimensions element =
  let (x, y) = Element.sizeOf element
  in TrVector.construct (toFloat x) (toFloat y)


button : String -> Float -> Float -> TrColor.RgbaColor -> TrColor.RgbaColor -> Signal.Address a -> a -> Element.Element
button title size padding normal select address action =
  let up = text
        title size normal False False Nothing
      hover = text
        title size select False False (Just Text.Under)

      buttonElement =
        Input.customButton
          (Signal.message address action)
          up hover hover

      buttonDimensions =
        computeDimensions buttonElement

      htmlButton =
        Html.fromElement buttonElement
  in
    Html.div [ HtmlAttributes.class "tr-hoverable" ] [ htmlButton ]
    |> Html.toElement (round buttonDimensions.x) (round buttonDimensions.y)
    |> applyPadding
      buttonDimensions
      (TrVector.construct padding padding)
    |> Input.hoverable (Signal.message hoverAddress)


image : TrVector.Vector -> TrVector.Vector -> String -> Element.Element
image dimensions padding src =
  Element.image (round dimensions.x) (round dimensions.y) src
  |> applyPadding dimensions padding


applyPadding : TrVector.Vector -> TrVector.Vector -> Element.Element -> Element.Element
applyPadding dimensions padding element =
  Collage.toForm element
  |> toElement (TrVector.add dimensions (TrVector.scale padding 2))


toElement : TrVector.Vector -> Collage.Form -> Element.Element
toElement dimensions form =
  collage dimensions [form]


collage : TrVector.Vector -> List Collage.Form -> Element.Element
collage dimensions forms =
  Collage.collage
    (round dimensions.x)
    (round dimensions.y)
    forms


background : TrColor.RgbaColor -> TrVector.Vector -> Collage.Form
background color dimensions =
  Collage.rect dimensions.x dimensions.y
  |> Collage.filled (TrColor.toColor color)