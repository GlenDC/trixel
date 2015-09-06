module Trixel.Views.Context.Toolbar (view) where

import Trixel.Models.Lazy as TrLazy

import Trixel.Types.State as TrState
import Trixel.Types.Layout as TrLayout

import Trixel.Views.Context.Toolbar.Menu as TrMenu
import Trixel.Views.Context.Toolbar.Work as TrWork

import Css

import Html
import Html.Lazy


lazyView : TrLazy.LayoutModel -> TrLayout.Mode -> Css.Styles -> Html.Html
lazyView model =
  if model.state == TrState.Default
    then TrWork.view model
    else TrMenu.view model


view : TrLazy.LayoutModel -> TrLayout.Mode -> Css.Styles -> Html.Html
view =
  Html.Lazy.lazy3
    lazyView
