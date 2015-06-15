module Trixel.Footer (view) where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Constants exposing (..)
import Trixel.Types exposing (..)

import Html exposing (Html, Attribute, div, a, text)
import Html.Attributes exposing (style, href)
import Signal exposing (Address)

---

view : Address TrixelAction -> HtmlDimensionContext -> State -> Html
view  address ctx state =
  div [ createMainStyle ctx state ] [
    div [ style [("text-align", "right"), ("float", "right")] ] [
      text ("Trixel v" ++ version)],
    div [style [("text-align", "left"), ("float", "left")]] [
      a [ href githubPage ] [text "Contribute and Star At Github"]],
    div [style [("text-align", "center"), ("float", "center")]] [
      a [ href ("mailto:" ++ email) ] [text "mail glendc for feedback and/or issues"]]
  ]

---

createMainStyle: HtmlDimensionContext -> State -> Attribute
createMainStyle ctx state  =
  style ((dimensionToHtml ctx) ++ [
    ("color", state.colorScheme.subText.html),
    ("position", "absolute"),
    ("font-size", (toPx (footerSize * 1.25))),
    ("bottom", "0"),
    ("box-sizing", "border-content")
  ])