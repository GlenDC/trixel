module Trixel.Menu where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Types exposing (..)

import Html exposing (Html, Attribute, div, input, text, label)
import Html.Events exposing (on, targetValue)
import Html.Attributes exposing (style, value)
import Signal exposing (Address, forwardTo)
import Json.Decode
import String

---

view : Address TrixelAction -> DimensionContext -> State -> Html
view  address ctx state =
  div [ createMainStyle ctx state ] [
    (createInputStyle GridX ctx state address),
    (createInputStyle GridY ctx state address)
  ]

---

createMainStyle: DimensionContext -> State -> Attribute
createMainStyle ctx state  =
  style ((dimensionToHtml ctx) ++ [
    ("background-color", state.colorScheme.bg.html),
    ("box-sizing", "inherit"),
    ("border-bottom", "1px solid " ++ state.colorScheme.fg.html)
  ])

toInt: String -> Int
toInt string =
  case (String.toInt string) of
    Ok value -> value
    Err error -> 0

createInputStyle: TrixelAction -> DimensionContext -> State -> Address TrixelAction -> Html
createInputStyle action ctx state address =
  let (px, py) = ctx.p
      (w, h) = ((clamp 25 60 (ctx.w * 0.05)), (ctx.h - (py * 2)))

      dimensions = dimensionContext w h (5, 5) (2, 2)

      inputStyle = style ((dimensionToHtml dimensions) ++ [
        ("background-color", state.colorScheme.selbg.html),
        ("Color", state.colorScheme.selfg.html),
        ("font-size", (toPx (dimensions.h / 1.75))),
        ("box-sizing", "border-box"),
        ("float", "left"),
        ("border", "1px solid " ++ state.colorScheme.fg.html)
      ])

      (default, caption, fn) =
        case action of
          GridX -> (state.cx, "X", (\x -> SetGridX (toInt x)))
          GridY -> (state.cy, "y", (\y -> SetGridY (toInt y)))
  in
    div [] [
      label [style [
        ("float", "left"), ("padding", "6px 10px"),
        ("color", state.colorScheme.text.html)]] [text caption],
      input [
        value (toString default),
        on "blur" targetValue (Signal.message 
          (forwardTo address fn)),
        inputStyle
        ] []
    ]