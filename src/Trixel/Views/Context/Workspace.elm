module Trixel.Views.Context.Workspace (view) where

import Trixel.Articles as TrArticles
import Trixel.Models.Model as TrModel
import Trixel.Types.Layout as TrLayout
import Trixel.Types.State as TrState
import Trixel.Types.Color as TrColor
import Trixel.Graphics as TrGraphics

import Graphics.Element as Element
import Math.Vector2 as Vector

import Markdown
import Html
import Html.Attributes as Attributes


viewEditor : Vector.Vec2 -> TrModel.Model -> Element.Element
viewEditor dimensions model =
  TrGraphics.background
    model.colorScheme.document
    dimensions
  |> TrGraphics.toElement dimensions


showMarkdown : Vector.Vec2 -> TrModel.Model -> Html.Html -> Element.Element
showMarkdown dimensions model markdown =
  let (dimensionsX, dimensionsY) =
        Vector.toTuple dimensions

      articleWidth =
        min 580 dimensionsX
  in
    Html.div
      [ Attributes.style
          [ ("color", TrColor.toString model.colorScheme.secondary.accentMid)
          ]
      , Attributes.class "tr-menu-article"
      ]
      [ Html.div
          [ Attributes.style
              [ ("height", (toString dimensionsY) ++ "px")
              , ("width", (toString articleWidth) ++ "px")
              , ("background-color", TrColor.toString model.colorScheme.document)
              , ("padding", "0 " ++ (toString (articleWidth * 0.05)) ++ "px")
              , ("overflow", "auto")
              ]
          ] [ markdown ]
      ]
    |> Html.toElement (round articleWidth) (round dimensionsY)
    |> Element.container
        (round dimensionsX)
        (round dimensionsY)
        Element.middle


showDualMarkdown : Vector.Vec2 -> TrModel.Model -> Html.Html -> Html.Html -> Element.Element
showDualMarkdown dimensions model markdownLeft markdownRight =
  let (dimensionsX, dimensionsY) =
        Vector.toTuple dimensions

      articleWidth =
        580

      totalWidth =
        1265
  in
    Html.div
      [ Attributes.style
          [ ("color", TrColor.toString model.colorScheme.secondary.accentMid)
          ]
      , Attributes.class "tr-menu-article"
      ]
      [ Html.div
          [ Attributes.style
              [ ("height", (toString dimensionsY) ++ "px")
              , ("width", (toString totalWidth) ++ "px")
              , ("background-color", TrColor.toString model.colorScheme.document)
              , ("padding", "0 " ++ (toString (articleWidth * 0.05)) ++ "px")
              , ("overflow", "auto")
              , ("position", "absolute")
              ]
          ]
          [ Html.div
              [ Attributes.style
                  [ ("float", "left")
                  , ("width", (toString articleWidth) ++ "px")
                  ]
              ] [ markdownLeft ]
          , Html.div
              [ Attributes.style
                  [ ("float", "right")
                  , ("width", (toString articleWidth) ++ "px")
                  ]
              ] [ markdownRight ]
          ]
      ]
    |> Html.toElement (round totalWidth) (round dimensionsY)
    |> Element.container
        (round dimensionsX)
        (round dimensionsY)
        Element.middle


viewHelp : Vector.Vec2 -> TrModel.Model -> Element.Element
viewHelp dimensions model =
  Markdown.toHtml TrArticles.help
  |> showMarkdown dimensions model


viewAbout : Vector.Vec2 -> TrModel.Model -> Element.Element
viewAbout dimensions model =
  if (Vector.getX dimensions) < 1280
    then
      Markdown.toHtml (TrArticles.about ++ TrArticles.license)
      |> showMarkdown dimensions model
    else
      showDualMarkdown
        dimensions
        model
        (Markdown.toHtml TrArticles.about)
        (Markdown.toHtml TrArticles.license)


view : Vector.Vec2 -> TrLayout.Type -> TrModel.Model -> Element.Element
view dimensions layout model =
  case model.work.state of
    TrState.Default ->
      viewEditor dimensions model

    TrState.Help ->
      viewHelp dimensions model

    TrState.About ->
      viewAbout dimensions model

    _ ->
      Element.empty