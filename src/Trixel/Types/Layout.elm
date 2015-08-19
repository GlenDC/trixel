module Trixel.Types.Layout where

import Css
import Css.Flex as Flex
import Css.Background as Background

import Html
import Html.Attributes as Attributes

import Trixel.Types.Color as TrColor


type alias Direction = Flex.Direction
row = Flex.Row
column = Flex.Column
rowReverse = Flex.RowReverse
columnReverse = Flex.ColumnReverse


type alias Wrap = Flex.Wrap
noWrap = Flex.NoWrap
wrap = Flex.Wrap
wrapReverse = Flex.WrapReverse


type Align
  = Left
  | Center
  | Right


type alias Generator = Css.Styles -> Html.Html


dummy : TrColor.RgbaColor -> Generator
dummy color =
  (\styles ->
    let style =
          background color styles
          |> Attributes.style
    in Html.div [ style ] []
    )


root : Generator -> Html.Html
root generator =
  [ ("width", "100vw")
  , ("height", "100vh")
  , ("display", "flex")
  ] |> generator


equalGroup : Direction -> Wrap -> List Generator -> Generator
equalGroup direction wrap children =
  List.map (\child -> (1, child)) children
  |> group direction wrap


group : Direction -> Wrap -> List (Int, Generator) -> Generator
group direction wrap children =
  let elements =
        List.map
          (\(grow, generator) ->
            generator (Flex.grow grow [])
            )
          children
  in
    (\styles ->
      let style =
            (("display", "flex") :: styles)
            |> Flex.flow direction wrap
            |> Attributes.style
      in Html.div [ style ] elements
      )


extend : (Css.Styles -> Css.Styles) -> Generator -> Generator
extend style generator =
  generator << style


crossAlign : Align -> Css.Styles -> Css.Styles
crossAlign align' styles =
  let align =
        case align' of
          Left -> Flex.AIStart
          Right -> Flex.AIEnd
          Center -> Flex.AICenter
  in Flex.alignItems align styles


padding : number -> Css.Styles -> Css.Styles
padding px styles =
  ("padding", Css.px px) :: styles


paddingLeft : number -> Css.Styles -> Css.Styles
paddingLeft px styles =
  ("padding-left", Css.px px) :: styles


paddingRight : number -> Css.Styles -> Css.Styles
paddingRight px styles =
  ("padding-right", Css.px px) :: styles


background : TrColor.RgbaColor -> Css.Styles -> Css.Styles
background color styles =
  Background.color
    (TrColor.toColor color)
    styles
