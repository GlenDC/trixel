module Trixel.Views.Context.Workspace (view) where

import Trixel.Models.Model as TrModel
import Trixel.Models.Work.Actions as TrWorkActions
import Trixel.Models.Work.Scratch as TrScratch

import Trixel.Types.State as TrState

import Trixel.Types.Layout as TrLayout
import Trixel.Types.Layout.Text as TrText
import Trixel.Types.Layout.UserActions as TrUserActions
import Trixel.Types.Layout.Input as TrLayoutInput

import Trixel.Articles as TrArticles
import Trixel.Constants as TrConstants

import Css.Position as Position
import Css.Dimension as Dimension
import Css.Flex as Flex

import Math.Vector2 as Vector

import Material.Icons.File as FileIcons


viewEditor : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewEditor model mode =
  TrLayout.empty


updateOpenDocTitle : TrModel.Model -> (String -> TrWorkActions.Action)
updateOpenDocTitle model =
  let newDocScratch = model.work.scratch.newDoc
  in
    (\title ->
      TrWorkActions.SetNewDocScratch
        (TrScratch.newTitle newDocScratch title)
    )


updateOpenDocDimension : TrModel.Model -> (TrScratch.DocumentForm -> String -> TrScratch.DocumentForm) -> (String -> TrWorkActions.Action)
updateOpenDocDimension model updateFunction =
  let newDocScratch = model.work.scratch.newDoc
  in
    (\valueString ->
      TrWorkActions.SetNewDocScratch
        (updateFunction newDocScratch valueString)
    )


viewNewDocInputFields : TrModel.Model -> TrLayout.Mode -> Float -> Float -> Float -> TrLayout.Generator
viewNewDocInputFields model mode width size padding =
  let labelSize = size * 0.78

      labelColor = model.colorScheme.secondary.accentMid
      inputColor = model.colorScheme.secondary.accentHigh
      fieldColors = model.colorScheme.secondary.main

      widthField =
        TrLayoutInput.field
          (TrLayoutInput.Number (1, 99999999))
          (updateOpenDocDimension model TrScratch.newWidth)
          "Width:"
          "Width of Document"
          (TrScratch.computeWidthString model.work.scratch)
           labelColor inputColor
           fieldColors.fill
           fieldColors.stroke
           labelSize
           size

      heightField =
        TrLayoutInput.field
          (TrLayoutInput.Number (1, 99999999))
          (updateOpenDocDimension model TrScratch.newHeight)
          "Height:"
          "Height of Document"
          (TrScratch.computeHeightString model.work.scratch)
           labelColor inputColor
           fieldColors.fill
           fieldColors.stroke
           labelSize
           size
  in
    TrLayout.autoGroup
      TrLayout.column
      TrLayout.noWrap
      ( TrLayout.padding padding []
        |> Dimension.width width
      )
      [ TrLayoutInput.field
          TrLayoutInput.Text
          (updateOpenDocTitle model)
          "Name:"
          "Name of Document"
          (TrScratch.computeOpenDocTitle model.work.scratch)
           labelColor inputColor
           fieldColors.fill
           fieldColors.stroke
           labelSize
           size
      , ( if width < TrConstants.maxReadableWidth
            then
              TrLayout.equalGroup
                TrLayout.column
                TrLayout.noWrap
                []
                [ widthField
                , heightField
                ]
            else
              TrLayout.equalGroup
                TrLayout.row
                TrLayout.noWrap
                []
                [ widthField
                  |> TrLayout.extend (TrLayout.alignSelf TrLayout.Left)
                  |> TrLayout.extend (TrLayout.marginRight padding)
                , heightField
                  |> TrLayout.extend (TrLayout.alignSelf TrLayout.Right)
                  |> TrLayout.extend (TrLayout.marginLeft padding)
                ]
          )
          |> TrLayout.extend (Dimension.width width)
      ]


viewNewDoc : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewNewDoc model mode =
  let selectionColor =
        model.colorScheme.selection.main.fill
      color =
        model.colorScheme.secondary.accentHigh

      (x, y) = Vector.toTuple model.work.dimensions
      size = (min (((((min x y ) * 3) + x + y) / 5) * 0.05) 50)
      padding = size * 0.25

      inputsize =
        max (size *  0.6) 14

      width =
        ( case mode of
            TrLayout.Landscape -> 0.89
            TrLayout.Portrait -> 0.98
        )
        |> (*) x
        |> min (TrConstants.maxReadableWidth * 1.2)
  in
    TrLayout.group
      TrLayout.column
      TrLayout.noWrap
      []
      [ (0, viewNewDocInputFields
               model
               mode
               width
               inputsize
               (inputsize * 0.25)
        )
      , (1, TrLayoutInput.svgResponsiveButton
              selectionColor
              FileIcons.folder_open
              color
              size padding
              True
            |> TrUserActions.viewLongLabel model TrUserActions.newDoc
            |> TrLayout.extend (TrLayout.background model.colorScheme.secondary.main.fill)
            |> TrLayout.extend (TrLayout.borderRadius (size * 0.15))
            |> TrLayout.extend (Dimension.width width)
            |> TrLayout.extend (TrLayout.marginTop (padding * 2))
            |> TrLayout.extend (Dimension.maxHeight (size + (padding * 2)))
        )
      ]
    |> TrLayout.extend (TrLayout.justifyContent TrLayout.Center)
    |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)


viewDragzoneChildren : TrModel.Model -> TrLayout.Mode -> Float -> Float -> TrLayout.Generator
viewDragzoneChildren model mode size padding =
  let textSize =
        size
        |> min 30
        |> max 12
  in
    TrLayout.group
      TrLayout.column
      TrLayout.noWrap
      (TrLayout.padding padding [])
      [ (3, TrText.text
              "Drag-and-drop your document in here or simply click this rectangle to open it via your file explorer."
              textSize
              TrText.center
              model.colorScheme.secondary.accentMid
              False
            |> TrText.centerVertically
        )
      , (5, TrText.text
              "no file selected"
              (textSize * 0.8)
              TrText.center
              model.colorScheme.secondary.accentLow
              False
            |> TrText.centerVertically
        )
      ]
    |> TrLayout.extend (TrLayout.justifyContent TrLayout.Center)
    |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)
    |> TrLayout.extend (Flex.grow 1)


viewOpenDoc : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewOpenDoc model mode =
  let selectionColor =
        model.colorScheme.selection.main.fill
      color =
        model.colorScheme.secondary.accentHigh

      (x, y) = Vector.toTuple model.work.dimensions
      size = (min (((((min x y ) * 3) + x + y) / 5) * 0.05) 50)
      padding = size * 0.25

      width =
        ( case mode of
            TrLayout.Landscape -> 0.89
            TrLayout.Portrait -> 0.98
        )
        |> (*) x
        |> min (TrConstants.maxReadableWidth * 1.2)
  in
    TrLayout.group
      TrLayout.column
      TrLayout.noWrap
      []
      [ (15, TrLayoutInput.dropzone
              (size * 0.08)
              (size * 0.2)
              color
              (viewDragzoneChildren model mode size padding)
            |> TrLayout.extend (TrLayout.marginBottom (size * 0.35))
            |> TrLayout.extend (Dimension.width width)
        )
      , (1, TrLayoutInput.svgResponsiveButton
              selectionColor
              FileIcons.folder_open
              color
              size padding
              True
            |> TrUserActions.viewLongLabel model TrUserActions.openDoc
            |> TrLayout.extend (TrLayout.background model.colorScheme.secondary.main.fill)
            |> TrLayout.extend (TrLayout.borderRadius (size * 0.15))
            |> TrLayout.extend (Dimension.width width)
            |> TrLayout.extend (Dimension.maxHeight (size + (padding * 2)))

        )
      ]
    |> TrLayout.extend (TrLayout.justifyContent TrLayout.Center)
    |> TrLayout.extend (TrLayout.crossAlign TrLayout.Center)


viewHelp : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewHelp model mode =
  viewMarkdown model TrArticles.help
  |> TrLayout.extend (Flex.alignItems Flex.AIStart)
  |> TrLayout.extend (Position.overflow Position.AutoOverflow)


viewAbout : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewAbout model mode =
  ( case mode of
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
  )
  |> TrLayout.extend (Flex.alignItems Flex.AIStart)
  |> TrLayout.extend (Position.overflow Position.AutoOverflow)


viewSettings : TrModel.Model -> TrLayout.Mode -> TrLayout.Generator
viewSettings model mode =
  viewMarkdown model
    """
No tweakable settings available for now.

If you have any request for new settings you would like to tweak, please raise an issue [on GitHub](https://github.com/GlenDC/trixel).
    """
  |> TrLayout.extend (Flex.alignItems Flex.AIStart)
  |> TrLayout.extend (Position.overflow Position.AutoOverflow)


viewMarkdown : TrModel.Model -> String -> TrLayout.Generator
viewMarkdown model content =
  TrText.markdown
    content
    (-1, TrConstants.maxReadableWidth)
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
          TrState.Open -> viewOpenDoc
          TrState.New -> viewNewDoc
          _ -> (\ a b -> TrLayout.empty)

      elementStyles =
        TrLayout.padding 5 []
  in
    TrLayout.equalGroup
      TrLayout.row
      TrLayout.wrap
      elementStyles
      [ viewFunction model mode ]
    |> TrLayout.extend (TrLayout.padding 5)
    |> TrLayout.extend (TrLayout.background model.colorScheme.document)
    |> TrLayout.extend (TrLayout.justifyContent TrLayout.Center)
    |> TrLayout.extend (Position.overflow Position.AutoOverflow)
