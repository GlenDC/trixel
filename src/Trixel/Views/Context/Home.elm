module Trixel.Views.Context.Home (view) where

import Trixel.Math.Vector as TrVector
import Trixel.Models.Model as TrModel
import Trixel.Types.Layout as TrLayout
import Trixel.Articles as TrArticles
import Trixel.Types.Color as TrColor
import Trixel.Graphics as TrGraphics
import Trixel.Types.State as TrState
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Models.Work as TrWork
import Trixel.Models.Work.Actions as TrWorkActions

import Graphics.Element as Element

import Markdown
import Html
import Html.Attributes as Attributes

import Material.Icons.Content as ContentIcons
import Material.Icons.File as FileIcons


viewButton render label help shortcuts selected dimensions model address action =
  TrGraphics.svgVerticalButton
    render
    label
    help
    shortcuts
    selected
    dimensions
    model.colorScheme.primary.accentHigh
    model.colorScheme.selection.accentHigh
    model.colorScheme.primary.main.stroke
    model.colorScheme.selection.main.fill
    address
    action
  |> Html.fromElement


viewNormal : TrVector.Vector -> TrModel.Model -> Element.Element
viewNormal dimensions model =
  let padding =
        clamp 30 50 (dimensions.x * 0.025)

      leftWidth =
        clamp 330 580 (dimensions.x * 0.5)
      rightWidth = 
        clamp 230 400 (dimensions.x * 0.4)

      totalWidth =
        leftWidth + rightWidth + padding

      buttonDimensions =
        TrVector.construct
          rightWidth
          (min 35 (dimensions.y * 0.2))

      buttonPadding =
        buttonDimensions.y * 0.25
  in
    Html.div
      [ Attributes.style
          [ ("color", TrColor.toString model.colorScheme.secondary.accentMid)
          , ( "width", (toString totalWidth) ++ "px" )
          , ( "height", (toString dimensions.y) ++ "px" )
          , ( "position", "absolute" )
          , ( "overflow", "auto" )
          ]
      , Attributes.class "tr-menu-article"
      ]
      [ Html.div
          [ Attributes.style
              [ ( "float", "left" )
              , ( "width", (toString leftWidth) ++ "px" )
              , ( "height", (toString dimensions.y) ++ "px" )
              , ( "position", "relative" )
              ]
          ]
          [ Markdown.toHtml (TrArticles.homeIntro ++ TrArticles.homeIntroExtra ++ TrArticles.homeUpdateTitle)
          , Html.div
              [ Attributes.style
                  [ ( "overflow", "auto" )
                  , ( "height", "30%")
                  ]
              ]
              [ Markdown.toHtml TrArticles.homeUpdateList
              ]
          ]
      , Html.div
          [ Attributes.style
              [ ( "float", "right" )
              , ( "width", (toString rightWidth) ++ "px" )
              , ( "height", (toString dimensions.y) ++ "px" )
              , ( "position", "relative" )
              ]
          ]
          [ Markdown.toHtml TrArticles.homeAction
          , Element.spacer
              (round rightWidth)
              (round (buttonDimensions.y * 0.25))
            |> Html.fromElement
          , viewButton
              ContentIcons.create
              "New Document"
              "Create a new Trixel Art Document."
              [ TrKeyboard.alt, TrKeyboard.n ]
              False
              buttonDimensions model TrWork.address
              (TrWorkActions.SetState TrState.New)
          , Element.spacer
              (round rightWidth)
              (round (buttonDimensions.y * 0.25))
            |> Html.fromElement
          , viewButton
              FileIcons.folder_open
              "Open Document"
              "Open an existing Trixel Art Document."
              [ TrKeyboard.alt, TrKeyboard.o ]
              False
              buttonDimensions model TrWork.address
              (TrWorkActions.SetState TrState.Open)
          ]
      ]
    |> Html.toElement (round totalWidth) (round dimensions.y)


viewThin : TrVector.Vector -> TrModel.Model -> Element.Element
viewThin dimensions model =
  let width =
        dimensions.x * 0.9

      totalWidth =
        dimensions.x * 0.95

      buttonDimensions =
        TrVector.construct
          width
          (min 35 (dimensions.y * 0.2))

      buttonPadding =
        buttonDimensions.y * 0.25
  in
    Html.div
      [ Attributes.style
          [ ("color", TrColor.toString model.colorScheme.secondary.accentMid)
          , ( "width", (toString totalWidth) ++ "px" )
          , ( "height", (toString dimensions.y) ++ "px" )
          , ( "overflow", "auto" )
          ]
      , Attributes.class "tr-menu-article"
      ]
      [ Markdown.toHtml (TrArticles.homeIntro ++ TrArticles.homeAction)
      , Element.spacer
          (round width)
          (round (buttonDimensions.y * 0.25))
        |> Html.fromElement
      , viewButton
          ContentIcons.create
          "New Document"
          "Create a new Trixel Art Document."
          [ TrKeyboard.alt, TrKeyboard.n ]
          False
          buttonDimensions model TrWork.address
          (TrWorkActions.SetState TrState.New)
      , Element.spacer
          (round width)
          (round (buttonDimensions.y * 0.25))
        |> Html.fromElement
      , viewButton
          FileIcons.folder_open
          "Open Document"
          "Open an existing Trixel Art Document."
          [ TrKeyboard.alt, TrKeyboard.o ]
          False
          buttonDimensions model TrWork.address
          (TrWorkActions.SetState TrState.Open)
      , Markdown.toHtml (TrArticles.homeUpdateTitle ++ TrArticles.homeUpdateList)
      ]
    |> Html.toElement (round totalWidth) (round dimensions.y)


view : TrVector.Vector -> TrModel.Model -> Element.Element
view dimensions model =
  ( if dimensions.x < 600
        then viewThin dimensions model
        else viewNormal dimensions model
  )
  |> Element.container
    (round dimensions.x)
    (round dimensions.y)
    Element.middle