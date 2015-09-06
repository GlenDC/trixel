module Trixel.Views.Context.Toolbar.Work (view) where

import Trixel.Models.Lazy as TrLazy

import Trixel.Types.Layout as TrLayout

import Html

import Css


view : TrLazy.LayoutModel -> TrLayout.Mode -> Css.Styles -> Html.Html
view model mode =
  TrLayout.empty
