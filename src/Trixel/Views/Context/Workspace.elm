module Trixel.Views.Context.Workspace (view) where

import Trixel.Models.Model as TrModel

import Trixel.Types.Color as TrColor
import Trixel.Types.State as TrState

import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Text as TrText

import Trixel.Articles as TrArticles

import Css.Position as Position

import Math.Vector2 as Vector


viewEditor : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewEditor model mode =
  TrLayout.empty


viewHelp : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewHelp model mode =
  viewMarkdown model TrArticles.help


viewAbout : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewAbout model mode =
  case mode of
    TrLayout.Portrait ->
      TrArticles.about ++ TrArticles.license
      |> viewMarkdown model

    TrLayout.Landscape ->
      TrLayout.autoGroup
        TrLayout.row
        TrLayout.noWrap
        (TrLayout.axisPadding 0 10 [])
        [ viewMarkdown model TrArticles.about
        , viewMarkdown model TrArticles.license
        ]
      |> TrLayout.extend (TrLayout.justifyContent TrLayout.Center)


viewSettings : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewSettings model mode =
  viewMarkdown model
    """
Here you'll be able to modify your language, shortcuts and editor preferences...

For now however, none of that is available yet.
    """


viewMarkdown : TrModel.Model -> String -> TrLayout.Generator
viewMarkdown model content =
  TrText.markdown
    content
    (-1, 560)
    (-1, -1)
    model.colorScheme.secondary.accentMid


view : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
view model mode =
  let viewFunction =
        case model.work.state of
          TrState.Default -> viewEditor
          TrState.Help -> viewHelp
          TrState.About -> viewAbout
          TrState.Settings -> viewSettings
          _ -> (\ a b -> TrLayout.empty)

      elementStyles =
        TrLayout.padding 5 []
        |> Position.overflow Position.AutoOverflow
  in
    TrLayout.equalGroup
      TrLayout.row
      TrLayout.wrap
      elementStyles
      [ viewFunction model mode ]
    |> TrLayout.extend (TrLayout.padding 5)
    |> TrLayout.extend (TrLayout.background model.colorScheme.document)
    |> TrLayout.extend (TrLayout.justifyContent TrLayout.Center)
