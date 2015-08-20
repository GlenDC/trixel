module Trixel.Views.Context.Home (view) where

{-import Trixel.Models.Model as TrModel
import Trixel.Types.Layout as TrLayout
import Trixel.Articles as TrArticles
import Trixel.Types.Color as TrColor
import Trixel.Graphics as TrGraphics
import Trixel.Types.State as TrState
import Trixel.Types.Keyboard as TrKeyboard
import Trixel.Models.Work as TrWork
import Trixel.Models.Work.Actions as TrWorkActions

import Graphics.Element as Element
import Math.Vector2 as Vector

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


viewNormal : Vector.Vec2 -> TrModel.Model -> Element.Element
viewNormal dimensions model =
  let (dimensionsX, dimensionsY) =
        Vector.toTuple dimensions

      padding =
        clamp 30 50 (dimensionsX * 0.025)

      leftWidth =
        clamp 330 580 (dimensionsX * 0.5)
      rightWidth = 
        clamp 230 400 (dimensionsX * 0.4)

      totalWidth =
        leftWidth + rightWidth + padding

      buttonDimensionsY =
        min 35 (dimensionsY * 0.2)

      buttonDimensions =
        Vector.vec2
          rightWidth
          buttonDimensionsY

      buttonPadding =
        buttonDimensionsY * 0.25
  in
    Html.div
      [ Attributes.style
          [ ("color", TrColor.toString model.colorScheme.secondary.accentHigh)
          , ( "width", (toString totalWidth) ++ "px" )
          , ( "height", (toString dimensionsY) ++ "px" )
          , ( "position", "absolute" )
          , ( "overflow", "auto" )
          ]
      , Attributes.class "tr-menu-article"
      ]
      [ Html.div
          [ Attributes.style
              [ ( "float", "left" )
              , ( "width", (toString leftWidth) ++ "px" )
              , ( "height", (toString dimensionsY) ++ "px" )
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
              , ( "height", (toString dimensionsY) ++ "px" )
              , ( "position", "relative" )
              ]
          ]
          [ Markdown.toHtml TrArticles.homeAction
          , Element.spacer
              (round rightWidth)
              (round (buttonDimensionsY * 0.25))
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
              (round (buttonDimensionsY * 0.25))
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
    |> Html.toElement (round totalWidth) (round dimensionsY)


viewThin : Vector.Vec2 -> TrModel.Model -> Element.Element
viewThin dimensions model =
  let (dimensionsX, dimensionsY) =
        Vector.toTuple dimensions

      width =
        dimensionsX * 0.9

      totalWidth =
        dimensionsX * 0.95

      buttonDimensionsY =
        min 35 (dimensionsY * 0.2)

      buttonDimensions =
        Vector.vec2
          width
          buttonDimensionsY

      buttonPadding =
        buttonDimensionsY * 0.25
  in
    Html.div
      [ Attributes.style
          [ ("color", TrColor.toString model.colorScheme.secondary.accentHigh)
          , ( "width", (toString totalWidth) ++ "px" )
          , ( "height", (toString dimensionsY) ++ "px" )
          , ( "overflow", "auto" )
          ]
      , Attributes.class "tr-menu-article"
      ]
      [ Markdown.toHtml (TrArticles.homeIntro ++ TrArticles.homeAction)
      , Element.spacer
          (round width)
          (round (buttonDimensionsY * 0.25))
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
          (round (buttonDimensionsY * 0.25))
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
    |> Html.toElement (round totalWidth) (round dimensionsY)


view : Vector.Vec2 -> TrModel.Model -> Element.Element
view dimensions model =
  let (dimensionsX, dimensionsY) =
        Vector.toTuple dimensions
  in
    ( if dimensionsX < 600
          then viewThin dimensions model
          else viewNormal dimensions model
    )
    |> Element.container
    (round dimensionsX)
    (round dimensionsY)
    Element.middle
-}

import Trixel.Models.Model as TrModel

import Trixel.Types.Layout as TrLayout


view : TrModel.Model -> TrLayout.Generator
view model =
  TrLayout.empty