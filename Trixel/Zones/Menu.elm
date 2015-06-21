module Trixel.Zones.Menu (view) where

import Trixel.Types.ColorScheme exposing (ColorScheme)
import Trixel.Types.Html exposing (..)
import Trixel.Types.Math exposing (..)
import Trixel.Types.General exposing (..)

import Html exposing (Html, Attribute, div, input,
  button, text, label, select, option)
import Html.Events exposing (on, onClick, targetValue, onMouseEnter)
import Html.Attributes exposing (style, value, selected)

import Signal exposing (forwardTo)
import Json.Decode
import String


view : ActionAddress -> State -> Html
view  address state =
  let boxModel =
        state.boxModels.menu
  in
    div
      [ constructMainStyle boxModel state
      , onMouseEnter address (SetCondition IdleCondition)
      ]
      [ (constructButton "New" NewDocument boxModel state address)

      , (constructTextInput GridX boxModel state address)
      , (constructArithmeticButton "-"
          (SetGridX (max 1 (state.trixelInfo.count.x - 1))) boxModel state address)
      , (constructArithmeticButton "+"
          (SetGridX (state.trixelInfo.count.x + 1)) boxModel state address)

      , (constructTextInput GridY boxModel state address)
      , (constructArithmeticButton "-"
          (SetGridY (max 1 (state.trixelInfo.count.y - 1))) boxModel state address)
      , (constructArithmeticButton "+"
          (SetGridY (state.trixelInfo.count.y + 1)) boxModel state address)

      , (constructTextInput Scale boxModel state address)
      , (constructArithmeticButton "-"
          (SetScale (max 0.20 (state.trixelInfo.scale - 0.20))) boxModel state address)
      , (constructArithmeticButton "+"
          (SetScale (state.trixelInfo.scale + 0.20)) boxModel state address)

      , (constructModeList boxModel state address)
      ]


constructMainStyle : BoxModel -> State -> Attribute
constructMainStyle boxModel state  =
  style (
    (computeBoxModelCSS boxModel) ++
    [ ("background-color", state.colorScheme.bg.html)
    , computeDefaultBorderCSS state.colorScheme.fg.html
    ])


constructButton : String -> TrixelAction -> BoxModel -> State -> ActionAddress -> Html
constructButton string action menuBoxModel state address =
  let width =
        clamp 50 80 (menuBoxModel.width * 0.075)
      height =
        menuBoxModel.height - (menuBoxModel.padding.y * 2)

      boxModel =
        constructBoxModel width height 5 5 2 2 BorderBox

      buttonStyle =
        style ((computeBoxModelCSS boxModel) ++
          [ ("background-color", state.colorScheme.selbg.html)
          , ("color", state.colorScheme.selfg.html)
          , ("font-size", (toPixels (boxModel.height / 1.75)))
          , ("float", "left")
          , computeDefaultBorderCSS state.colorScheme.fg.html
          ])
  in
    button
      [ onClick address action, buttonStyle ]
      [ text string ]


constructArithmeticButton : String -> TrixelAction -> BoxModel -> State -> ActionAddress -> Html
constructArithmeticButton string action menuBoxModel state address =
  let width =
        clamp 25 35 (menuBoxModel.width * 0.095)
      height =
        menuBoxModel.height - (menuBoxModel.padding.y * 2)

      boxModel =
        constructBoxModel width height 5 5 2 2 BorderBox

      buttonStyle =
        style ((computeBoxModelCSS boxModel) ++
          [ ("background-color", state.colorScheme.selbg.html)
          , ("color", state.colorScheme.selfg.html)
          , ("font-size", (toPixels (boxModel.height / 1.75)))
          , ("float", "left")
          , computeDefaultBorderCSS state.colorScheme.fg.html
          ])
  in
    button
      [ onClick address action, buttonStyle ]
      [ text string ]


constructTextInput : TrixelActionInput -> BoxModel -> State -> ActionAddress -> Html
constructTextInput action menuBoxModel state address =
  let width =
        clamp 25 60 (menuBoxModel.width * 0.05)
      height =
        menuBoxModel.height - (menuBoxModel.padding.y * 2)

      boxModel =
        constructBoxModel width height 5 5 2 2 BorderBox

      inputStyle =
        style ((computeBoxModelCSS boxModel) ++
          [ ("background-color", state.colorScheme.selbg.html)
          , ("color", state.colorScheme.selfg.html)
          , ("font-size", (toPixels (boxModel.height / 1.75)))
          , ("float", "left")
          , computeDefaultBorderCSS state.colorScheme.fg.html
          ])

      (default, caption, fn) =
        case action of
          GridX
            -> (round state.trixelInfo.count.x,
              "X", (\x -> SetGridX (stringToFloat x)))

          GridY
            -> (round state.trixelInfo.count.y,
              "Y", (\y -> SetGridY (stringToFloat y)))

          Scale
            -> (round (state.trixelInfo.scale * 100),
              "Scale (%)", (\s -> SetScale ((stringToFloat s) / 100)))
  in
    div []
      [ label
          [ style
              [ ("float", "left")
              , ("padding", vectorToPixels { x = 10, y = 6 })
              , ("color", state.colorScheme.text.html)
              ]
          ]
          [text caption]
      , input
          [ value (toString default)
          , on "blur" targetValue (Signal.message (forwardTo address fn))
          , inputStyle
          ]
          []
      ]


constructModeList : BoxModel -> State -> ActionAddress -> Html
constructModeList menuBoxModel state address =
  let width =
        clamp 115 130 (menuBoxModel.width * 0.08)
      height =
        menuBoxModel.height - (menuBoxModel.padding.y * 2)

      boxModel =
        constructBoxModel width height 5 5 2 2 BorderBox

      selectStyle =
        style ((computeBoxModelCSS boxModel) ++
          [ ("background-color", state.colorScheme.selbg.html)
          , ("color", state.colorScheme.selfg.html)
          , ("font-size", boxModel.height / 1.85 |> toPixels)
          , ("float", "left")
          , computeDefaultBorderCSS state.colorScheme.fg.html
          ])

      selectFunction value =
        SetMode (if (stringToInt value) == 0 then Horizontal else Vertical)
  in
    div []
      [ label
          [ style
            [ ("float", "left")
            , ("padding", vectorToPixels { x = 10, y = 6 })
            , ("color", state.colorScheme.text.html)
            ]
          ]
          [ text "Mode" ]
      , select
          [ selectStyle
          , on "change" targetValue (Signal.message (forwardTo address selectFunction))
          ]
          [ option
              [ selected (state.trixelInfo.mode == Horizontal)
              , value "0"
              ]
              [ text "Horizontal" ]
          , option
              [ selected (state.trixelInfo.mode == Vertical)
              , value "1"
              ]
              [ text "Vertical" ]
          ]
      ]