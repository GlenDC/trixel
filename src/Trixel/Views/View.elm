module Trixel.Views.View (view) where

import Trixel.Models.Model as TrModel
import Trixel.Models.Lazy as TrLazy
import Trixel.Types.Layout as TrLayout

import Trixel.Views.Menu as TrMenuView
import Trixel.Views.Context as TrContext
import Trixel.Views.Footer as TrFooterView

import Css.Flex as Flex
import Css.Display as Display

import Html
import Html.Attributes as Attributes


lazyView : TrLazy.LayoutModel -> TrLazy.EditorModel -> Html.Html
lazyView layoutModel editorModel = 
  let menuHeight =
        clamp 30 (layoutModel.height * 0.03) 80
        |> round |> toFloat

      footerHeight =
        clamp 28 (layoutModel.height * 0.025) 70
        |> round |> toFloat

      style =
        Display.display Display.Flex []
        |> Flex.flow TrLayout.column TrLayout.noWrap
        |> TrLayout.background layoutModel.colorScheme.primary.main.fill
        |> (::) ("width", "100vw")
        |> (::) ("height", "100vh")
        |> Attributes.style
  in
    Html.div
      [ style ]
      [ TrMenuView.view menuHeight layoutModel (Flex.grow 0 [])
      , TrContext.view layoutModel editorModel (Flex.grow 1 [])
      , TrFooterView.view footerHeight layoutModel (Flex.grow 0 [])
      ]

view : TrModel.Model -> Html.Html
view model =
  let layoutModel = TrLazy.layoutModel model
      editorModel = TrLazy.editorModel model
  in
    lazyView
      layoutModel
      editorModel