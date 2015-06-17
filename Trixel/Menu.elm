module Trixel.Menu (view) where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Types exposing (..)

import Html exposing (Html, Attribute, div, input,
  button, text, label, select, option)
import Html.Events exposing (on, onClick, targetValue, onMouseEnter)
import Html.Attributes exposing (style, value, selected)
import Signal exposing (Address, forwardTo)
import Json.Decode
import String

---

view : Address TrixelAction -> State -> Html
view  address state =
  let ctx = state.html.dimensions.menu
  in
    div [ createMainStyle ctx state,
          onMouseEnter address (SetCondition CIdle) ] [
      (createButton "New" NewDoc ctx state address),
      {-(createButton "Open" OpenDoc ctx state address),
      (createButton "Save" SaveDoc ctx state address),
      (createButton "SaveAs" SaveDocAs ctx state address),-}

      (createInput GridX ctx state address),
      (createArithmeticButton "-"
        (SetGridX (max 1 (state.trixelInfo.count.x - 1))) ctx state address),
      (createArithmeticButton "+"
        (SetGridX (state.trixelInfo.count.x + 1)) ctx state address),

      (createInput GridY ctx state address),
      (createArithmeticButton "-"
        (SetGridY (max 1 (state.trixelInfo.count.y - 1))) ctx state address),
      (createArithmeticButton "+"
        (SetGridY (state.trixelInfo.count.y + 1)) ctx state address),

      (createInput Scale ctx state address),
      (createArithmeticButton "-"
        (SetScale (max 0.20 (state.trixelInfo.scale - 0.20))) ctx state address),
      (createArithmeticButton "+"
        (SetScale (state.trixelInfo.scale + 0.20)) ctx state address),

      (createModeList ctx state address)
    ]

---

createMainStyle: HtmlDimensionContext -> State -> Attribute
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

createButton: String -> TrixelAction -> HtmlDimensionContext -> State -> Address TrixelAction -> Html
createButton string action ctx state address =
  let (w, h) = ((clamp 50 80 (ctx.w * 0.075)), (ctx.h - (ctx.p.y * 2)))

      dimensions = dimensionContext w h 5 5 2 2

      buttonStyle = style ((dimensionToHtml dimensions) ++ [
        ("background-color", state.colorScheme.selbg.html),
        ("color", state.colorScheme.selfg.html),
        ("font-size", (pxFromFloat (dimensions.h / 1.75))),
        ("box-sizing", "border-box"),
        ("float", "left"),
        ("border", "1px solid " ++ state.colorScheme.fg.html)
      ])
  in
    button [
      onClick address action,
      buttonStyle
      ] [text string]

createArithmeticButton: String -> TrixelAction -> HtmlDimensionContext -> State -> Address TrixelAction -> Html
createArithmeticButton string action ctx state address =
  let (w, h) = ((clamp 25 35 (ctx.w * 0.095)), (ctx.h - (ctx.p.y * 2)))

      dimensions = dimensionContext w h 5 5 2 2

      buttonStyle = style ((dimensionToHtml dimensions) ++ [
        ("background-color", state.colorScheme.selbg.html),
        ("color", state.colorScheme.selfg.html),
        ("font-size", (pxFromFloat (dimensions.h / 1.75))),
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

createInput: TrixelAction -> HtmlDimensionContext -> State -> Address TrixelAction -> Html
createInput action ctx state address =
  let (w, h) = ((clamp 25 60 (ctx.w * 0.05)), (ctx.h - (ctx.p.y * 2)))

      dimensions = dimensionContext w h 5 5 2 2

      inputStyle = style ((dimensionToHtml dimensions) ++ [
        ("background-color", state.colorScheme.selbg.html),
        ("color", state.colorScheme.selfg.html),
        ("font-size", (pxFromFloat (dimensions.h / 1.75))),
        ("box-sizing", "border-box"),
        ("float", "left"),
        ("border", "1px solid " ++ state.colorScheme.fg.html)
      ])

      (default, caption, fn) =
        case action of
          GridX -> (state.trixelInfo.count.x,
            "X", (\x -> SetGridX (toInt x)))
          GridY -> (state.trixelInfo.count.y,
            "Y", (\y -> SetGridY (toInt y)))
          Scale -> (round (state.trixelInfo.scale * 100),
            "Scale (%)", (\s -> SetScale ((toFloat (toInt s)) / 100)))
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

createModeList: HtmlDimensionContext -> State -> Address TrixelAction -> Html
createModeList ctx state address =
  let (w, h) = ((clamp 115 130 (ctx.w * 0.08)), (ctx.h - (ctx.p.y * 2)))

      dimensions = dimensionContext w h 5 5 2 2

      selectStyle = style ((dimensionToHtml dimensions) ++ [
        ("background-color", state.colorScheme.selbg.html),
        ("color", state.colorScheme.selfg.html),
        ("font-size", (pxFromFloat (dimensions.h / 1.85))),
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
        option [selected (state.trixelInfo.mode == Horizontal), value "hor"]
          [text "Horizontal"],
        option [selected (state.trixelInfo.mode == Vertical), value "ver"]
          [text "Vertical"]
      ]
    ]