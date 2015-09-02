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
import Html.Events as HtmlEvents
import Html.Attributes as Attributes

import Css.Display as Display
import Css.Flex as Flex
import Css.Text as Text
import Css.Border as Border
import Css.Border.Style as BorderStyle

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


clickable : Signal.Address a -> a -> Html.Html -> Html.Html
clickable address action element =
  Html.toElement -1 -1 element
  |> Input.clickable (Signal.message address action)
  |> Html.fromElement


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
              , TrNative.function "footerShowHelp" [message, shortcut]
                |> TrNative.mouseEnter
              , TrNative.function "footerHideHelp" []
                |> TrNative.mouseLeave
              ] [ generator [] ]
            |> TrNative.hoverBackground hoverColor
            |> clickable TrWork.address action

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


nativeButton : TrNative.Function -> TrColor.RgbaColor ->  String -> TrInput.Shortcut -> Bool -> TrLayout.Generator -> TrLayout.Generator
nativeButton function hoverColor message buttons toggled generator =
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
            , TrNative.function "footerShowHelp" [message, shortcut]
              |> TrNative.mouseEnter
            , TrNative.function "footerHideHelp" []
              |> TrNative.mouseLeave
            ] [ generator [] ]
          |> TrNative.hoverBackground hoverColor

        buttonStyles =
          if toggled
            then TrLayout.background hoverColor styles
            else styles

    in Html.div
        [ Attributes.style buttonStyles
        , TrNative.mouseClick function
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


nativeSvgButton : TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> TrNative.Function -> TrInput.Shortcut -> String -> Bool -> TrLayout.Generator
nativeSvgButton hoverColor generator color size padding function buttons message toggled =
  TrGraphics.svg generator color size padding
  |> nativeButton function hoverColor message buttons toggled


nativeSvgLabelButton : TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> TrNative.Function -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator
nativeSvgLabelButton hoverColor generator color size padding function buttons message labelText toggled =
  TrGraphics.svg generator color size 0
  |> label labelText color size padding
  |> nativeButton function hoverColor message buttons toggled


nativeSvgResponsiveButton : TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> Bool -> TrNative.Function -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator
nativeSvgResponsiveButton hoverColor generator color size padding predicate function buttons message labelText toggled  =
  if predicate
    then nativeSvgLabelButton hoverColor generator color size padding function buttons message labelText toggled
    else nativeSvgButton hoverColor generator color size padding function buttons message toggled


verticalSvgButton : TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> Float -> Float -> Float -> TrWorkActions.Action -> TrInput.Shortcut -> String -> String -> Bool -> TrLayout.Generator
verticalSvgButton hoverColor generator color size fontSize padding action buttons message labelText toggled =
  TrGraphics.svg generator color size 0
  |> verticalLabel labelText color fontSize padding
  |> button action hoverColor message buttons toggled


dropzone : number -> number -> TrColor.RgbaColor -> TrLayout.Generator -> TrLayout.Generator
dropzone width radius color child =
  (\styles ->
    let style =
          Border.width width width width width styles
          |> Border.radius radius radius radius radius
          |> Border.color (TrColor.toColor color)
          |> Border.style BorderStyle.Dashed
          |> Display.display Display.Flex
          |> Attributes.style
    in
      Html.div
        [ style
        , Attributes.class "tr-hoverable"
        ]
        [ child [] ]
    )


field : FieldType -> (String -> TrWorkActions.Action) -> String -> String -> String -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrColor.RgbaColor -> TrColor.RgbaColor -> Float -> Float -> TrLayout.Generator
field fieldType toAction label help value labelColor inputColor inputBackground inputBorder labelSize size =
  TrLayout.autoGroup
    TrLayout.column
    TrLayout.noWrap
    []
    [ TrText.text label labelSize TrText.left labelColor True
    , (\inputStyles ->
        let styles =
              TrText.size size inputStyles
              |> Border.color (TrColor.toColor inputBorder)
              |> TrLayout.background inputBackground
              |> Text.color (TrColor.toColor inputColor)

            attributes =
              [ Attributes.placeholder help
              , Attributes.value value
              , Attributes.style styles
              , HtmlEvents.on
                  "input"
                  HtmlEvents.targetValue
                  (\string ->
                    toAction string
                    |> Signal.message TrWork.address
                  )
              ]
            |> applyFieldType fieldType
        in Html.input attributes []
      )
    ]


type FieldType
  = Text
  | Password
  | Number (Int,Int)


applyFieldType: FieldType -> List Html.Attribute -> List Html.Attribute
applyFieldType fieldType attributes =
  let attributes' =
        (Attributes.type' (computeFieldTypeString fieldType))
        :: attributes
  in
    case fieldType of
      Number (min, max) ->
        (Attributes.min (toString min))
        :: (Attributes.max (toString max))
        :: attributes'

      _ ->
        attributes'


computeFieldTypeString : FieldType -> String
computeFieldTypeString fieldType =
  case fieldType of
    Text -> "text"
    Password -> "password"
    Number (_, _) -> "number"
