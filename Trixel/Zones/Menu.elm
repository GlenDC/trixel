module Trixel.Zones.Menu (view) where

import Trixel.Types.ColorScheme exposing (ColorScheme)
import Trixel.Types.Html exposing (..)
import Trixel.Types.Math exposing (..)
import Trixel.Types.General exposing (..)
import Trixel.PostOffice exposing (..)

import Html exposing (Html, Attribute, div, input, button, text, label, select, option)
import Html.Events exposing (on, onClick, targetValue, onBlur, onFocus)
import Html.Attributes exposing (style, value, selected, class)

import Color exposing (..)
import Signal exposing (forwardTo)
import Json.Decode
import String


view : State -> Html
view  state =
  let boxModel =
        state.boxModels.menu
  in
    div
      [ constructMainStyle boxModel state
      , class "noselect"
      ]
      [ (constructButton "New" NewDocument boxModel state)

      , constructSimpleText "GridX:" "right" boxModel state
      , constructSimpleText (toString state.trixelInfo.count.x) "center" boxModel state
      , constructArithmeticButton "-"
          (SetGridX (max 1 (state.trixelInfo.count.x - 1))) boxModel state
      , constructArithmeticButton "+"
          (SetGridX (state.trixelInfo.count.x + 1)) boxModel state

      , constructSimpleText "GridY:" "right" boxModel state
      , constructSimpleText (toString state.trixelInfo.count.y) "center" boxModel state
      , constructArithmeticButton "-"
          (SetGridY (max 1 (state.trixelInfo.count.y - 1))) boxModel state
      , constructArithmeticButton "+"
          (SetGridY (state.trixelInfo.count.y + 1)) boxModel state

      , constructSimpleText "Scale:" "right" boxModel state
      , constructSimpleText ((toString (round (state.trixelInfo.scale * 100))) ++ "%") "center" boxModel state
      , constructArithmeticButton "-"
          (SetScale (max 0.20 (state.trixelInfo.scale - 0.20))) boxModel state
      , constructArithmeticButton "+"
          (SetScale (state.trixelInfo.scale + 0.20)) boxModel state

      , constructModeList boxModel state
      , constructColorList boxModel state

      , constructColorPreview boxModel state
      ]


constructMainStyle : BoxModel -> State -> Attribute
constructMainStyle boxModel state  =
  style (
    (computeBoxModelCSS boxModel) ++
    [ ("background-color", state.colorScheme.bg.html)
    , computeDefaultBorderCSS state.colorScheme.fg.html
    ])


constructButton : String -> TrixelAction -> BoxModel -> State -> Html
constructButton string action menuBoxModel state =
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
      [ onClick actionQuery.address action, buttonStyle ]
      [ text string ]


constructColorPreview : BoxModel -> State -> Html
constructColorPreview menuBoxModel state =
   let height =
         menuBoxModel.height - (menuBoxModel.padding.y * 2)

       boxModel =
         constructBoxModel height height 5 5 2 2 BorderBox
  in
    div
      [ style ((computeBoxModelCSS boxModel) ++
          [ ("background-color", elmToHtmlColor state.trixelColor)
          , ("float", "left")
          ])
      ] []


constructArithmeticButton : String -> TrixelAction -> BoxModel -> State -> Html
constructArithmeticButton string action menuBoxModel state =
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
          , ("cursor", "pointer")
          , computeDefaultBorderCSS state.colorScheme.fg.html
          ])
  in
    button
      [ onClick actionQuery.address action, buttonStyle ]
      [ text string ]

constructSimpleText : String -> String -> BoxModel -> State -> Html
constructSimpleText string textAlign menuBoxModel state =
  let width =
        clamp 40 50 (menuBoxModel.width * 0.05)
      height =
        menuBoxModel.height - (menuBoxModel.padding.y * 2)

      boxModel =
        constructBoxModel width height 5 5 2 2 BorderBox
  in
    div
      [ style ((computeBoxModelCSS boxModel) ++
          [ ("color", "lightGrey")
          , ("text-align", textAlign)
          , ("font-size", (toPixels (boxModel.height / 1.75)))
          , ("float", "left")
          , ("cursor", "default")
          ])
      ]
      [ text string ]


constructTextInput : TrixelActionInput -> BoxModel -> State -> Html
constructTextInput action menuBoxModel state =
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
              , ("color", "lightGrey")
              ]
          ]
          [text caption]
      , input
          [ value (toString default)
          , on "blur" targetValue (Signal.message (forwardTo actionQuery.address fn))
          , onFocus postOfficeQuery.address EnteringHTMLInput
          , onBlur postOfficeQuery.address LeavingHTMLInput
          , inputStyle
          ]
          []
      ]


constructModeList : BoxModel -> State -> Html
constructModeList menuBoxModel state =
  let width =
        clamp 115 130 (menuBoxModel.width * 0.08)
      height =
        menuBoxModel.height - (menuBoxModel.padding.y * 2)

      boxModel =
        constructBoxModel width height 5 5 2 4 BorderBox

      selectStyle =
        style ((computeBoxModelCSS boxModel) ++
          [ ("background-color", state.colorScheme.selbg.html)
          , ("color", state.colorScheme.selfg.html)
          , ("font-size", boxModel.height / 1.85 |> toPixels)
          , ("float", "left")
          , ("cursor", "pointer")
          , computeDefaultBorderCSS state.colorScheme.fg.html
          ])

      selectFunction value =
        SetMode (if (stringToInt value) == 0 then IsometricMode else ClassicMode)
  in
    div []
      [ label
          [ style
            [ ("float", "left")
            , ("padding", vectorToPixels { x = 10, y = 6 })
            , ("color", "lightGrey")
            ]
          ]
          [ text "Mode" ]
      , select
          [ selectStyle
          , on "change" targetValue (Signal.message (forwardTo actionQuery.address selectFunction))
          , onFocus postOfficeQuery.address EnteringHTMLInput
          , onBlur postOfficeQuery.address LeavingHTMLInput
          ]
          [ option
              [ selected (state.trixelInfo.mode == IsometricMode)
              , value "0"
              ]
              [ text "Isometric" ]
          , option
              [ selected (state.trixelInfo.mode == ClassicMode)
              , value "1"
              ]
              [ text "Classic" ]
          ]
      ]

constructColorList : BoxModel -> State -> Html
constructColorList menuBoxModel state =
  let width =
        clamp 60 90 (menuBoxModel.width * 0.05)
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
          , ("cursor", "pointer")
          , computeDefaultBorderCSS state.colorScheme.fg.html
          ])

      selectFunction value =
        SetColor (
          case (stringToInt value) of
            1 -> orange
            2 -> yellow
            3 -> green
            4 -> blue
            5 -> purple
            6 -> brown
            7 -> white
            8 -> grey
            9 -> black
            _ -> red)
  in
    div []
      [ label
          [ style
            [ ("float", "left")
            , ("padding", vectorToPixels { x = 10, y = 6 })
            , ("color", "lightGrey")
            ]
          ]
          [ text "Color" ]
      , select
          [ selectStyle
          , on "change" targetValue (Signal.message (forwardTo actionQuery.address selectFunction))
          , onFocus postOfficeQuery.address EnteringHTMLInput
          , onBlur postOfficeQuery.address LeavingHTMLInput
          ]
          [ constructColorOption state red 0 "red"
          , constructColorOption state orange 1 "orange"
          , constructColorOption state yellow 2 "yellow"
          , constructColorOption state green 3 "green"
          , constructColorOption state blue 4 "blue"
          , constructColorOption state purple 5 "purple"
          , constructColorOption state brown 6 "brown"
          , constructColorOption state white 7 "white"
          , constructColorOption state grey 8 "grey"
          , constructColorOption state black 9 "black"
          ]
      ]


constructColorOption : State -> Color -> Int -> String -> Html
constructColorOption state color val description =
  option
    [ selected (state.trixelColor == color)
    , value (toString val)
    ]
    [ text description ]