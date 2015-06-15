module Trixel.Footer (view) where

import Trixel.ColorScheme exposing (ColorScheme)
import Trixel.Constants exposing (..)
import Trixel.Types exposing (..)

import Html exposing (Html, Attribute, div, a, text)
import Html.Attributes exposing (style, href)
import Signal exposing (Address)

---

view : State -> Html
view state =
  div [ createMainStyle state ] [
    div [ style [("text-align", "right"), ("float", "right")] ] [
      text ("Trixel v" ++ version)],
    div [style [("text-align", "left"), ("float", "left")]] [
      a [ href githubPage ] [text "Contribute and Star At Github"]],
    div [style [("text-align", "center"), ("float", "center")]] [
      a [ href ("mailto:" ++ email) ] [text "mail glendc for feedback and/or issues"]]
  ]

---

createMainStyle: State -> Attribute
createMainStyle state  =
  style ((dimensionToHtml state.html.dimensions.footer) ++ [
    ("color", state.colorScheme.subText.html),
    ("position", "absolute"),
    ("font-size", (toPx (footerSize * 1.25))),
    ("bottom", (toPx footerSize)),
    ("box-sizing", "border-content")
  ])