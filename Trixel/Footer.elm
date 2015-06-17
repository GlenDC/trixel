module Trixel.Footer (view) where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Constants exposing (..)
import Trixel.Types exposing (..)

import Html exposing (Html, Attribute, div, a, text)
import Html.Attributes exposing (style, href)
import Html.Events exposing (onMouseEnter)
import Signal exposing (Address)

---

view : Address TrixelAction -> State -> Html
view address state =
  div [ createMainStyle state,
        onMouseEnter address (SetCondition CIdle) ] [
    div [ style [("text-align", "right"), ("float", "right")] ] [
      text ("Trixel v" ++ version) ],
    div [style [("text-align", "left"), ("float", "left")]] [
      createConditionMessage state.condition |> text ]
    ]

---

createMainStyle: State -> Attribute
createMainStyle state  =
  style ((dimensionToHtml state.html.dimensions.footer) ++ [
    ("color", state.colorScheme.subText.html),
    ("position", "absolute"),
    ("font-size", (pxFromFloat (footerSize * 1.25))),
    ("bottom", "0px"),
    ("box-sizing", "border-content")
  ])