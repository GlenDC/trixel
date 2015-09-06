module Trixel.Views.Context (view) where

import Trixel.Models.Lazy as TrLazy

import Trixel.Types.Layout as TrLayout
import Trixel.Types.State as TrState

import Trixel.Views.Context.Home as TrHome
import Trixel.Views.Context.Toolbar as TrToolbar
import Trixel.Views.Context.Editor as TrEditor
import Trixel.Views.Context.MenuPages as TrMenuPages

import Css
import Css.Flex as Flex
import Css.Display as Display

import Html
import Html.Attributes as Attributes


computeMode : TrLazy.LayoutModel -> TrLayout.Mode
computeMode model =
  if model.width <= 1080
    then TrLayout.Portrait
    else TrLayout.Landscape


isNotOnHomeScreen : TrLazy.LayoutModel -> Bool
isNotOnHomeScreen model =
  model.hasDocument || model.state /= TrState.Default


viewWorkContext : TrLazy.LayoutModel -> TrLazy.EditorModel -> Css.Styles -> Html.Html
viewWorkContext layoutModel editorModel styles =
  let mode = computeMode layoutModel

      flow =
        case mode of
          TrLayout.Portrait -> TrLayout.column
          TrLayout.Landscape -> TrLayout.row

      viewWorkspace =
        if layoutModel.state == TrState.Default
          then TrEditor.view editorModel
          else TrMenuPages.view layoutModel

      style =
        Display.display Display.Flex styles
        |> Flex.flow flow TrLayout.noWrap
        |> Attributes.style
  in
    Html.div
      [ style
      , Attributes.id layoutModel.tags.workspace
      ]
      [ TrToolbar.view layoutModel mode (Flex.grow 0 [])
      , viewWorkspace mode (Flex.grow 1 [])
      ]


view : TrLazy.LayoutModel -> TrLazy.EditorModel -> Css.Styles -> Html.Html
view layoutModel editorModel =
  if isNotOnHomeScreen layoutModel
    then viewWorkContext layoutModel editorModel
    else TrHome.view layoutModel
