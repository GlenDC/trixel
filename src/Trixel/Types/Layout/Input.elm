module Trixel.Types.Layout.Input where

import Trixel.Types.Layout exposing (Generator, extend)
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


button : TrWorkActions.Action -> TrColor.RgbaColor ->  String -> TrInput.Buttons -> Generator -> Generator
button action hoverColor message buttons generator =
  let shortcut =
        if List.isEmpty buttons
          then ""
          else "[ " ++ (showShortcut buttons) ++ " ]"
  in
    (\styles ->
      Html.div
        [ Attributes.class "tr-hoverable"
        , Attributes.title message
        , TrNative.mouseEnter "trFooterShowHelp" [message, shortcut]
        , TrNative.mouseLeave "trFooterHideHelp" []
        ] [ generator styles ]
      |> TrNative.hoverBackground hoverColor
      |> Html.toElement -1 -1
      |> Input.clickable (Signal.message TrWork.address action)
      |> Html.fromElement
    )


imgButton : TrWorkActions.Action -> TrColor.RgbaColor -> String -> String -> Float -> Float -> TrInput.Buttons -> Generator
imgButton action hoverColor src message size padding buttons =
  TrGraphics.image src message size padding
  |> button action hoverColor message buttons


svgButton : TrWorkActions.Action -> TrColor.RgbaColor -> TrGraphics.SvgGenerator -> TrColor.RgbaColor -> String -> Float -> Float -> TrInput.Buttons -> Generator
svgButton action hoverColor generator color message size padding buttons =
  TrGraphics.svg generator color size padding
  |> button action hoverColor message buttons
