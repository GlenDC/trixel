module Trixel.Views.Context.Home (view) where

import Trixel.Models.Model as TrModel
import Trixel.Models.Work.Actions as TrWorkActions

import Trixel.Types.Input as TrInput
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Types.State as TrState
import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Graphics as TrGraphics
import Trixel.Types.Layout.Input as TrLayoutInput
import Trixel.Types.Layout.Text as TrText

import Trixel.Glue.Random as TrRandom

import Material.Icons.Content as ContentIcons
import Material.Icons.Communication as CommunicationIcons
import Material.Icons.File as FileIcons

import Css.Dimension as Dimension

import Math.Vector2 as Vector

import Array


button : TrWorkActions.Action -> TrGraphics.SvgGenerator -> String -> String -> TrInput.Buttons -> Float -> Float -> TrModel.Model -> TrLayout.Generator
button action generator message labelText buttons size padding model =
  TrLayoutInput.verticalSvgButton
    action
    model.colorScheme.selection.main.fill
    generator
    model.colorScheme.secondary.accentHigh
    message
    labelText
    (size * 0.70)
    (size * 0.14)
    padding
    buttons
    False
  |> TrLayout.extend (TrLayout.background model.colorScheme.secondary.main.fill)
  |> TrLayout.extend (TrLayout.margin (padding * 0.5))


viewButtons : Float -> Float -> TrModel.Model -> TrLayout.Generator
viewButtons size padding model =
  TrLayout.autoGroup
    TrLayout.row
    TrLayout.noWrap
    []
    [ button
        (TrWorkActions.SetState TrState.New)
        ContentIcons.create
        "Create a new document."
        "New Document"
        [ TrKeyboard.alt, TrKeyboard.n ]
        size padding
        model
    , button
        (TrWorkActions.SetState TrState.Open)
        FileIcons.folder_open
        "Open an existing document."
        "Open Document"
        [ TrKeyboard.alt, TrKeyboard.o ]
        size padding
        model
    ]


computeRandomTip : TrModel.Model -> String
computeRandomTip model =
  let defaultTip =
        "share your art on social media with the hashtag #trixelit" 

      tips =
        [ defaultTip
        , "you can find the list of shortcuts on the help page"
        , "get to know trixel better on the about page"
        ] |> Array.fromList

      index = TrRandom.randomInt 0 ((Array.length tips) - 1)
  in
    case Array.get index tips of
      Maybe.Just tip -> tip
      Maybe.Nothing -> defaultTip


viewTip : Float -> Float -> TrModel.Model -> TrLayout.Generator
viewTip size padding model =
  TrLayout.autoGroup
    TrLayout.row
    TrLayout.noWrap
    []
    [ TrGraphics.svg
        CommunicationIcons.live_help
        model.colorScheme.secondary.accentMid
        (size * 0.15) (padding * 0.1)
    , TrText.text
        (computeRandomTip model)
        (size * 0.1)
        TrText.center
        model.colorScheme.secondary.accentMid
        True
      |> TrLayout.extend (TrLayout.padding (size * 0.01))
    ]
  |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)
  |> TrLayout.extend (TrLayout.justifyContent TrLayout.Center)


view : TrModel.Model -> TrLayout.Generator
view model =
  let y = Vector.getY model.work.dimensions
      size = min 240 (y * 0.35)
      padding = size * 0.2
  in
    TrLayout.autoGroup
      TrLayout.column
      TrLayout.noWrap
      []
      [ TrText.text
          "trixel it"
          (size * 0.5)
          TrText.center
          model.colorScheme.logo.fill
          True
        |> TrLayout.extend (TrText.bold)
      , viewButtons size padding model
      , viewTip size padding model
      ]
    |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)
    |> TrLayout.extend (TrLayout.justifyContent TrLayout.Center)
    |> TrLayout.extend (TrLayout.background model.colorScheme.document)
