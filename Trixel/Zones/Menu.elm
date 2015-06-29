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
      trixelCount =
        getTrixelCount state
  in
    div
      [ constructMainStyle boxModel state
      , class "noselect"
      ]
      [ (constructButton "New" NewDocument boxModel state)

      , (constructButton "Reset View" ResetOffset boxModel state)

      , constructSimpleText "GridX:" "right" boxModel state
      , constructSimpleText (toString trixelCount.x) "center" boxModel state
      , constructArithmeticButton "-"
          (SetGridX (max 1 (trixelCount.x - 1))) boxModel state
      , constructArithmeticButton "+"
          (SetGridX (trixelCount.x + 1)) boxModel state

      , constructSimpleText "GridY:" "right" boxModel state
      , constructSimpleText (toString trixelCount.y) "center" boxModel state
      , constructArithmeticButton "-"
          (SetGridY (max 1 (trixelCount.y - 1))) boxModel state
      , constructArithmeticButton "+"
          (SetGridY (trixelCount.y + 1)) boxModel state

      , constructSimpleText "Scale:" "right" boxModel state
      , constructSimpleText ((toString (round (state.trixelInfo.scale * 100))) ++ "%") "center" boxModel state
      , constructArithmeticButton "-"
          (SetScale (max 0.05 (state.trixelInfo.scale - 0.05))) boxModel state
      , constructArithmeticButton "+"
          (SetScale (state.trixelInfo.scale + 0.05)) boxModel state

      , constructModeList boxModel state
      , constructColorList boxModel state
      ]


constructMainStyle : BoxModel -> State -> Attribute
constructMainStyle boxModel state  =
  style
    (computeBoxModelCSS boxModel)


constructButton : String -> TrixelAction -> BoxModel -> State -> Html
constructButton string action menuBoxModel state =
  let height =
        menuBoxModel.height - (menuBoxModel.padding.y * 2)

      boxModel =
        constructBoxModel 0 height 5 5 2 2 BorderBox

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
  let height =
        menuBoxModel.height - (menuBoxModel.padding.y * 2)

      boxModel =
        constructBoxModel 0 height 5 5 2 2 BorderBox
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
  let height =
        menuBoxModel.height - (menuBoxModel.padding.y * 2)

      boxModel =
        constructBoxModel 0 height 5 5 2 2 BorderBox

      inputStyle =
        style ((computeBoxModelCSS boxModel) ++
          [ ("background-color", state.colorScheme.selbg.html)
          , ("color", state.colorScheme.selfg.html)
          , ("font-size", (toPixels (boxModel.height / 1.75)))
          , ("float", "left")
          , computeDefaultBorderCSS state.colorScheme.fg.html
          ])

      trixelCount =
        getTrixelCount state

      (default, caption, fn) =
        case action of
          GridX
            -> (round trixelCount.x,
              "X", (\x -> SetGridX (stringToFloat x)))

          GridY
            -> (round trixelCount.y,
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
  let height =
        menuBoxModel.height - (menuBoxModel.padding.y * 2)

      boxModel =
        constructBoxModel 0 height 5 5 2 4 BorderBox

      selectStyle =
        style ((computeBoxModelCSS boxModel) ++
          [ ("background-color", state.colorScheme.selbg.html)
          , ("color", state.colorScheme.selfg.html)
          , ("font-size", boxModel.height / 2 |> toPixels)
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
            , ("font-size", boxModel.height / 2 |> toPixels)
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
  let height =
        menuBoxModel.height - (menuBoxModel.padding.y * 2)

      boxModel =
        constructBoxModel 0 height 5 5 2 2 BorderBox

      selectStyle =
        style ((computeBoxModelCSS boxModel) ++
          [ ("background-color", elmToHtmlColor state.trixelColor)
          , ("color", computeInverseColor state.trixelColor)
          , ("font-size", boxModel.height / 2 |> toPixels)
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
            , ("font-size", boxModel.height / 2 |> toPixels)
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


computeInverseColor : Color -> String
computeInverseColor color =
  let rgbaColor =
        toRgb color
  in
    elmToHtmlColor
      (rgba
          (255 - rgbaColor.red)
          (255 - rgbaColor.green)
          (255 - rgbaColor.blue)
          rgbaColor.alpha
      )