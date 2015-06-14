module Trixel.Menu (view) where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Types exposing (..)

import Html exposing (Html, Attribute, div, input,
  button, text, label, select, option)
import Html.Events exposing (on, onClick, targetValue)
import Html.Attributes exposing (style, value, selected)
import Signal exposing (Address, forwardTo)
import Json.Decode
import String

---

view : Address TrixelAction -> DimensionContext -> State -> Html
view  address ctx state =
  div [ createMainStyle ctx state ] [
    (createButton "New" NewDoc ctx state address),
    {-(createButton "Open" OpenDoc ctx state address),
    (createButton "Save" SaveDoc ctx state address),
    (createButton "SaveAs" SaveDocAs ctx state address),-}

    (createInput GridX ctx state address),
    (createArithmeticButton "-" (SetGridX (max 1 (state.cx - 1))) ctx state address),
    (createArithmeticButton "+" (SetGridX (state.cx + 1)) ctx state address),

    (createInput GridY ctx state address),
    (createArithmeticButton "-" (SetGridY (max 1 (state.cy - 1))) ctx state address),
    (createArithmeticButton "+" (SetGridY (state.cy + 1)) ctx state address),

    (createInput Scale ctx state address),
    (createArithmeticButton "-" (SetScale (max 0.05 (state.scale - 0.05))) ctx state address),
    (createArithmeticButton "+" (SetScale (state.scale + 0.05)) ctx state address),

    (createModeList ctx state address)
  ]

---

createMainStyle: DimensionContext -> State -> Attribute
createMainStyle ctx state  =
  style ((dimensionToHtml ctx) ++ [
    ("background-color", state.colorScheme.bg.html),
    ("box-sizing", "inherit"),
    ("border-bottom", "1px solid " ++ state.colorScheme.fg.html)
  ])

---

toInt: String -> Int
toInt string =
  case (String.toInt string) of
    Ok value -> value
    Err error -> 0

---

createButton: String -> TrixelAction -> DimensionContext -> State -> Address TrixelAction -> Html
createButton string action ctx state address =
  let (px, py) = ctx.p
      (w, h) = ((clamp 50 80 (ctx.w * 0.075)), (ctx.h - (py * 2)))

      dimensions = dimensionContext w h (5, 5) (2, 2)

      buttonStyle = style ((dimensionToHtml dimensions) ++ [
        ("background-color", state.colorScheme.selbg.html),
        ("color", state.colorScheme.selfg.html),
        ("font-size", (toPx (dimensions.h / 1.75))),
        ("box-sizing", "border-box"),
        ("float", "left"),
        ("border", "1px solid " ++ state.colorScheme.fg.html)
      ])
  in
    button [
      onClick address action,
      buttonStyle
      ] [text string]

createArithmeticButton: String -> TrixelAction -> DimensionContext -> State -> Address TrixelAction -> Html
createArithmeticButton string action ctx state address =
  let (px, py) = ctx.p
      (w, h) = ((clamp 25 35 (ctx.w * 0.095)), (ctx.h - (py * 2)))

      dimensions = dimensionContext w h (5, 5) (2, 2)

      buttonStyle = style ((dimensionToHtml dimensions) ++ [
        ("background-color", state.colorScheme.selbg.html),
        ("color", state.colorScheme.selfg.html),
        ("font-size", (toPx (dimensions.h / 1.75))),
        ("box-sizing", "border-box"),
        ("float", "left"),
        ("border", "1px solid " ++ state.colorScheme.fg.html)
      ])
  in
    button [
      onClick address action,
      buttonStyle
      ] [text string]

---

createInput: TrixelAction -> DimensionContext -> State -> Address TrixelAction -> Html
createInput action ctx state address =
  let (px, py) = ctx.p
      (w, h) = ((clamp 25 60 (ctx.w * 0.05)), (ctx.h - (py * 2)))

      dimensions = dimensionContext w h (5, 5) (2, 2)

      inputStyle = style ((dimensionToHtml dimensions) ++ [
        ("background-color", state.colorScheme.selbg.html),
        ("color", state.colorScheme.selfg.html),
        ("font-size", (toPx (dimensions.h / 1.75))),
        ("box-sizing", "border-box"),
        ("float", "left"),
        ("border", "1px solid " ++ state.colorScheme.fg.html)
      ])

      (default, caption, fn) =
        case action of
          GridX -> (state.cx, "X", (\x -> SetGridX (toInt x)))
          GridY -> (state.cy, "Y", (\y -> SetGridY (toInt y)))
          Scale -> (round (state.scale * 100), "Scale (%)", (\s -> SetScale ((toFloat (toInt s)) / 100)))
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

---

createModeList: DimensionContext -> State -> Address TrixelAction -> Html
createModeList ctx state address =
  let (px, py) = ctx.p
      (w, h) = ((clamp 115 130 (ctx.w * 0.08)), (ctx.h - (py * 2)))

      dimensions = dimensionContext w h (5, 5) (2, 2)

      selectStyle = style ((dimensionToHtml dimensions) ++ [
        ("background-color", state.colorScheme.selbg.html),
        ("color", state.colorScheme.selfg.html),
        ("font-size", (toPx (dimensions.h / 1.85))),
        ("box-sizing", "border-box"),
        ("float", "left"),
        ("border", "1px solid " ++ state.colorScheme.fg.html)
      ])

      fn txt =
        SetMode (if txt == "hor" then Horizontal else Vertical)
  in
    div [] [
      label [style [
        ("float", "left"), ("padding", "6px 10px"),
        ("color", state.colorScheme.text.html)]] [text "Mode"],
      select [selectStyle, on "change" targetValue (Signal.message 
          (forwardTo address fn))] [
        option [selected (state.mode == Horizontal), value "hor"]
          [text "Horizontal"],
        option [selected (state.mode == Vertical), value "ver"]
          [text "Vertical"]
      ]
    ]