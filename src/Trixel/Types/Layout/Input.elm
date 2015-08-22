module Trixel.Types.Layout.Input where

import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Text as TrText
import Trixel.Types.Layout.Graphics as TrGraphics
import Trixel.Types.Color as TrColor

import Trixel.Types.List as TrList
import Trixel.Types.Input as TrInput
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Native as TrNative

import Trixel.Models.Work as TrWork
import Trixel.Models.Work.Actions as TrWorkActions

import Html
import Html.Attributes as Attributes

import Css
import Css.Flex as Flex

import Graphics.Input as Input


showShortcut : TrInput.Buttons -> String
showShortcut buttons =
  let descriptions =
        TrKeyboard.getDescriptions buttons

      aux =
        TrList.head descriptions ""
  in
    List.foldr
      (\item result ->
        result ++ " + " ++ item)
      aux
      (TrList.tail descriptions)


button : TrWorkActions.Action -> TrColor.RgbaColor ->  String -> TrInput.Buttons -> Bool -> TrLayout.Generator -> TrLayout.Generator
button action hoverColor message buttons toggled generator =
  let shortcut =
        if List.isEmpty buttons
          then ""
          else "[ " ++ (showShortcut buttons) ++ " ]"
  in
    (\styles ->
      let element =
            Html.div
              [ Attributes.class "tr-hoverable"
              , Attributes.title message
              , TrNative.mouseEnter "trFooterShowHelp" [message, shortcut]
              , TrNative.mouseLeave "trFooterHideHelp" []
              ] [ generator [] ]
            |> TrNative.hoverBackground hoverColor
            |> Html.toElement -1 -1
            |> Input.clickable (Signal.message TrWork.address action)
            |> Html.fromElement

          buttonStyles =
            if toggled
              then TrLayout.background hoverColor styles
              else styles

      in Html.div
          [ Attributes.style buttonStyles
          , Attributes.class "tr-button-inherit"
          ]
          [ element ]
      )


nativeButton : (String, List String) -> TrColor.RgbaColor ->  String -> TrInput.Buttons -> Bool -> TrLayout.Generator -> TrLayout.Generator
nativeButton (func, args) hoverColor message buttons toggled generator =
  let shortcut =
    if List.isEmpty buttons
      then ""
      else "[ " ++ (showShortcut buttons) ++ " ]"
  in
  (\styles ->
    let element =
          Html.div
            [ Attributes.class "tr-hoverable"
            , Attributes.title message
            , TrNative.mouseEnter "trFooterShowHelp" [message, shortcut]
            , TrNative.mouseLeave "trFooterHideHelp" []
            ] [ generator [] ]
          |> TrNative.hoverBackground hoverColor

        buttonStyles =
          if toggled
            then TrLayout.background hoverColor styles
            else styles

    in Html.div
        [ Attributes.style buttonStyles
        , TrNative.mouseClick func args
        , Attributes.class "tr-button-inherit"
        ]
        [ element ]
    )


label : String -> TrColor.RgbaColor -> Float -> Float -> TrLayout.Generator -> TrLayout.Generator
label description color size padding generator =
  TrLayout.autoGroup
    TrLayout.row
    TrLayout.noWrap
    []
    [ generator
    , TrText.text description (size * 0.7) TrText.left color False
      |> TrLayout.extend (TrLayout.marginLeft padding)
    ]
  |> TrLayout.extend (TrLayout.padding padding)
  |> TrLayout.extend (Flex.justifyContent Flex.JCCenter)
  |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)


verticalLabel : String -> TrColor.RgbaColor -> Float -> Float -> TrLayout.Generator -> TrLayout.Generator
verticalLabel description color size padding generator =
  TrLayout.autoGroup
    TrLayout.column
    TrLayout.noWrap
    []
    [ generator
    , TrText.text description size TrText.left color False
    ]
  |> TrLayout.extend (TrLayout.padding padding)
  |> TrLayout.extend (Flex.justifyContent Flex.JCCenter)
  |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)



imgButton : TrWorkActions.Action -> TrColor.RgbaColor -> String -> String -> Float -> Float -> TrInput.Buttons -> Bool -> TrLayout.Generator
imgButton action hoverColor src message size padding buttons toggled =
  TrGraphics.image src message size padding
  |> button action hoverColor message buttons toggled


imgLabelButton : TrWorkActions.Action -> TrColor.RgbaColor -> TrColor.RgbaColor -> String -> String -> String -> Float -> Float -> TrInput.Buttons -> Bool -> TrLayout.Generator
imgLabelButton action hoverColor color src message labelText size padding buttons toggled =
  TrGraphics.image src message size 0
  |> label labelText color size padding
  |> button action hoverColor message buttons toggled


imgResponsiveButton : TrWorkActions.Action -> TrColor.RgbaColor -> TrColor.RgbaColor -> String -> String -> String -> Float -> Float -> TrInput.Buttons -> Bool ->  Bool -> TrLayout.Generator
imgResponsiveButton action hoverColor color src message labelText size padding buttons predicate toggled =
  if predicate
    then imgLabelButton action hoverColor color src message labelText size padding buttons toggled
    else imgButton action hoverColor src message size padding buttons toggled


svgButton : TrWorkActions.Action -> TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> String -> Float -> Float -> TrInput.Buttons -> Bool -> TrLayout.Generator
svgButton action hoverColor generator color message size padding buttons toggled =
  TrGraphics.svg generator color size padding
  |> button action hoverColor message buttons toggled


svgLabelButton : TrWorkActions.Action -> TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> String -> String -> Float -> Float -> TrInput.Buttons -> Bool -> TrLayout.Generator
svgLabelButton action hoverColor generator color message labelText size padding buttons toggled =
  TrGraphics.svg generator color size 0
  |> label labelText color size padding
  |> button action hoverColor message buttons toggled


svgResponsiveButton : TrWorkActions.Action -> TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> String -> String -> Float -> Float -> TrInput.Buttons -> Bool -> Bool -> TrLayout.Generator
svgResponsiveButton action hoverColor generator color message labelText size padding buttons predicate toggled =
  if predicate
    then svgLabelButton action hoverColor generator color message labelText size padding buttons toggled
    else svgButton action hoverColor generator color message size padding buttons toggled


nativeSvgButton : (String, List String) -> TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> String -> Float -> Float -> TrInput.Buttons -> Bool -> TrLayout.Generator
nativeSvgButton (func, args) hoverColor generator color message size padding buttons toggled =
  TrGraphics.svg generator color size padding
  |> nativeButton (func, args) hoverColor message buttons toggled


nativeSvgLabelButton : (String, List String) -> TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> String -> String -> Float -> Float -> TrInput.Buttons -> Bool -> TrLayout.Generator
nativeSvgLabelButton (func, args) hoverColor generator color message labelText size padding buttons toggled =
  TrGraphics.svg generator color size 0
  |> label labelText color size padding
  |> nativeButton (func, args) hoverColor message buttons toggled


nativeSvgResponsiveButton : (String, List String) -> TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> String -> String -> Float -> Float -> TrInput.Buttons -> Bool -> Bool -> TrLayout.Generator
nativeSvgResponsiveButton (func, args) hoverColor generator color message labelText size padding buttons predicate toggled =
  if predicate
    then nativeSvgLabelButton (func, args) hoverColor generator color message labelText size padding buttons toggled
    else nativeSvgButton (func, args) hoverColor generator color message size padding buttons toggled


verticalSvgButton : TrWorkActions.Action -> TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> String -> String -> Float -> Float -> Float -> TrInput.Buttons -> Bool -> TrLayout.Generator
verticalSvgButton action hoverColor generator color message labelText size fontSize padding buttons toggled =
  TrGraphics.svg generator color size 0
  |> verticalLabel labelText color fontSize padding
  |> button action hoverColor message buttons toggled
