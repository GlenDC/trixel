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

import Css.Flex as Flex

import Graphics.Input as Input


showShortcut : TrInput.Shortcut -> String
showShortcut shortcut =
  let descriptions =
        TrKeyboard.getDescriptions (shortcut.optionKeys ++ shortcut.otherKeys)

      aux =
        TrList.head descriptions ""
  in
    List.foldl
      (\item result ->
        result ++ " + " ++ item)
      aux
      (TrList.tail descriptions)


button : TrWorkActions.Action -> TrColor.RgbaColor ->  String -> TrInput.Shortcut -> Bool -> TrLayout.Generator -> TrLayout.Generator
button action hoverColor message buttons toggled generator =
  let shortcut =
        if List.isEmpty buttons.otherKeys
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


nativeButton : (String, List String) -> TrColor.RgbaColor ->  String -> TrInput.Shortcut -> Bool -> TrLayout.Generator -> TrLayout.Generator
nativeButton (func, args) hoverColor message buttons toggled generator =
  let shortcut =
    if List.isEmpty buttons.otherKeys
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



imgButton : TrColor.RgbaColor -> String -> Float -> Float -> TrWorkActions.Action -> TrInput.Shortcut -> String -> Bool -> TrLayout.Generator
imgButton hoverColor src size padding action buttons message toggled =
  TrGraphics.image src message size padding
  |> button action hoverColor message buttons toggled


imgLabelButton : TrColor.RgbaColor -> TrColor.RgbaColor -> String -> Float -> Float -> TrWorkActions.Action -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator
imgLabelButton hoverColor color src size padding action buttons message labelText toggled =
  TrGraphics.image src message size 0
  |> label labelText color size padding
  |> button action hoverColor message buttons toggled


imgResponsiveButton : TrColor.RgbaColor -> TrColor.RgbaColor -> String -> Float -> Float ->  Bool -> TrWorkActions.Action -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator
imgResponsiveButton hoverColor color src size padding predicate action buttons message labelText toggled =
  if predicate
    then imgLabelButton hoverColor color src size padding action buttons message labelText toggled
    else imgButton hoverColor src size padding action buttons message toggled


svgButton : TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> TrWorkActions.Action -> TrInput.Shortcut -> String -> Bool -> TrLayout.Generator
svgButton hoverColor generator color size padding action buttons message toggled =
  TrGraphics.svg generator color size padding
  |> button action hoverColor message buttons toggled


svgLabelButton : TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> TrWorkActions.Action -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator
svgLabelButton hoverColor generator color size padding action buttons message labelText toggled =
  TrGraphics.svg generator color size 0
  |> label labelText color size padding
  |> button action hoverColor message buttons toggled


svgResponsiveButton : TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> Bool -> TrWorkActions.Action -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator
svgResponsiveButton hoverColor generator color size padding predicate action buttons message labelText toggled =
  if predicate
    then svgLabelButton hoverColor generator color size padding action buttons message labelText toggled
    else svgButton hoverColor generator color size padding action buttons message toggled


nativeSvgButton : TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> (String, List String) -> TrInput.Shortcut -> String -> Bool -> TrLayout.Generator
nativeSvgButton hoverColor generator color size padding (func, args) buttons message toggled =
  TrGraphics.svg generator color size padding
  |> nativeButton (func, args) hoverColor message buttons toggled


nativeSvgLabelButton : TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> (String, List String) -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator
nativeSvgLabelButton hoverColor generator color size padding (func, args) buttons message labelText toggled =
  TrGraphics.svg generator color size 0
  |> label labelText color size padding
  |> nativeButton (func, args) hoverColor message buttons toggled


nativeSvgResponsiveButton : TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> Bool -> (String, List String) -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator
nativeSvgResponsiveButton hoverColor generator color size padding predicate (func, args) buttons message labelText toggled  =
  if predicate
    then nativeSvgLabelButton hoverColor generator color size padding (func, args) buttons message labelText toggled
    else nativeSvgButton hoverColor generator color size padding (func, args) buttons message toggled


verticalSvgButton : TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> Float -> TrWorkActions.Action -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator
verticalSvgButton hoverColor generator color size fontSize padding action buttons message labelText toggled =
  TrGraphics.svg generator color size 0
  |> verticalLabel labelText color fontSize padding
  |> button action hoverColor message buttons toggled
