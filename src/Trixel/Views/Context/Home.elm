module Trixel.Views.Context.Home (view) where

import Trixel.Models.Lazy as TrLazy

import Trixel.Constants as TrConstants

import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.UserActions as TrUserActions
import Trixel.Types.Layout.Graphics as TrGraphics
import Trixel.Types.Layout.Input as TrLayoutInput
import Trixel.Types.Layout.Text as TrText

import Trixel.Glue.Random as TrRandom

import Material.Icons.Content as ContentIcons
import Material.Icons.Communication as CommunicationIcons
import Material.Icons.File as FileIcons

import Css.Display as Display
import Css.Flex as Flex
import Css

import Html.Attributes as Attributes
import Html.Lazy
import Html

import Array


button : TrUserActions.UserAction -> TrGraphics.SvgGenerator -> Float -> Float -> TrLazy.LayoutModel -> TrLayout.Generator
button userAction generator size padding model =
  TrLayoutInput.verticalSvgButton
    model.colorScheme.selection.main.fill
    generator
    model.colorScheme.secondary.accentHigh
    (size * 0.70)
    (size * 0.14)
    padding
  |> TrUserActions.viewLongLabel False userAction
  |> TrLayout.extend (TrLayout.background model.colorScheme.secondary.main.fill)
  |> TrLayout.extend (TrLayout.margin (padding * 0.5))
  |> TrLayout.extend (TrLayout.borderRadius (size * 0.05))


viewButtons : Float -> Float -> TrLazy.LayoutModel -> TrLayout.Generator
viewButtons size padding model =
  TrLayout.autoGroup
    TrLayout.row
    TrLayout.wrap
    []
    [ button
        TrUserActions.gotoNew
        ContentIcons.create
        size padding
        model
    , button
        TrUserActions.gotoOpen
        FileIcons.folder_open
        size padding
        model
    ]
  |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)
  |> TrLayout.extend (TrLayout.justifyContent TrLayout.Center)


computeRandomTip : TrLazy.LayoutModel -> String
computeRandomTip model =
  let defaultTip =
        "share your art on social media with the hashtag #trixelit"

      tips =
        [ defaultTip
        , "you can find the list of shortcuts on the help page"
        , "get to know trixel better on the about page"
        , "try updating your browser when experiencing issues :)"
        ] |> Array.fromList

      index = TrRandom.randomInt 0 ((Array.length tips) - 1)
  in
    case Array.get index tips of
      Maybe.Just tip -> tip
      Maybe.Nothing -> defaultTip


viewTip : Float -> Float -> TrLazy.LayoutModel -> TrLayout.Generator
viewTip size padding model =
  TrLayout.autoGroup
    TrLayout.row
    TrLayout.wrap
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


lazyView : TrLazy.LayoutModel -> Css.Styles -> Html.Html
lazyView model styles =
  let minSize = min model.width model.height 
      size = (((minSize * 3) + model.width + model.height) / 5) * 0.25
      padding = size * 0.2

      children =
         [ (5, TrLayout.autoGroup
                TrLayout.column
                TrLayout.noWrap
                []
                [ TrText.text
                    TrConstants.homeTitle
                    (size * 0.5)
                    TrText.center
                    model.colorScheme.logo.fill
                    True
                  |> TrLayout.extend (TrText.bold)
                , viewButtons size padding model
                ]
              |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)
              |> TrLayout.extend (TrLayout.justifyContent TrLayout.Center)
          )
        , (3, viewTip size padding model)
        ]

      elements =
        List.map
          (\(grow, generator) ->
            generator (Flex.grow grow [])
          )
        children

      style =
        Display.display Display.Flex styles
        |> Flex.flow TrLayout.column TrLayout.noWrap
        |> TrLayout.crossAlign TrLayout.Center
        |> TrLayout.justifyContent TrLayout.Center
        |> TrLayout.background model.colorScheme.document
        |> Attributes.style
  in
    Html.div [ style ] elements


view : TrLazy.LayoutModel -> Css.Styles -> Html.Html
view =
  Html.Lazy.lazy2 lazyView
