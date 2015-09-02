module Trixel.Models.Work.Scratch where

import Trixel.Models.Work.Document as TrDocument

import Trixel.Types.Layout.Form as TrForm

import Math.Vector2 as Vector


initialModel : Model
initialModel =
  { newDoc = initialDocumentForm
  }


type alias Model =
  { newDoc : DocumentForm
  }


initialDocumentForm : DocumentForm
initialDocumentForm =
  { title = TrForm.textField Nothing False
  , width = TrForm.integerField (Just 10) 1 99999 True
  , height = TrForm.integerField (Just 10) 1 99999 True
  }


type alias DocumentForm =
  { title : TrForm.TextField
  , width : TrForm.IntegerField
  , height : TrForm.IntegerField
  }


computeOpenDocTitle : Model -> String
computeOpenDocTitle model =
  TrForm.getText model.newDoc.title


computeWidthString : Model -> String
computeWidthString model =
  TrForm.stringValue model.newDoc.width


computeHeightString : Model -> String
computeHeightString model =
  TrForm.stringValue model.newDoc.height


newDocument : Model -> TrDocument.Model
newDocument model =
  let x = TrForm.getInteger model.newDoc.width |> toFloat
      y = TrForm.getInteger model.newDoc.height |> toFloat
  in
    { title = model.newDoc.title.value
    , dimensions = Vector.vec2 x y
    }


newDocumentIsValid : Model -> Bool
newDocumentIsValid model =
  TrForm.isValid model.newDoc.title
  && TrForm.isValid model.newDoc.width
  && TrForm.isValid model.newDoc.height



newTitle : DocumentForm -> String -> DocumentForm
newTitle form title =
  { form | title <- TrForm.setText form.title title }


newWidth : DocumentForm -> String -> DocumentForm
newWidth form width =
  { form | width <- TrForm.setInteger form.width width }


newHeight : DocumentForm -> String -> DocumentForm
newHeight form height =
  { form | height <- TrForm.setInteger form.height height }
