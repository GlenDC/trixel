module Trixel.Models.Work.Input
  ( setKeyboardButtons
  , setMousePosition
  , setMouseWheel
  , setMouseButtons
  , initialModel
  , Model
  )
  where

import Trixel.Types.Input as TrInput
import Trixel.Math.Vector as TrVector

import Maybe exposing (..)


setKeyboardButtons : TrInput.Buttons -> Model -> Model
setKeyboardButtons buttons model =
  { model | keyboard <-
    constructButtonModel model.keyboard.down buttons }


setMouseButtons : TrInput.Buttons -> Model -> Model
setMouseButtons buttons model =
  let mouseModel = model.mouse
  in
    { model | mouse <-
      { mouseModel | buttons <-
        constructButtonModel mouseModel.buttons.down buttons }
    }


setMousePosition : TrVector.Vector -> Model -> Model
setMousePosition position model =
  let mouseModel = model.mouse
  in
    { model | mouse <-
      { mouseModel
          | position <- position
          , previousPosition <- mouseModel.position
      }
    }


setMouseWheel : TrVector.Vector -> Model -> Model
setMouseWheel wheel model =
  let mouseModel = model.mouse
  in
    { model | mouse <-
      { mouseModel | wheel <- wheel }
    }


initialModel : Model
initialModel =
  { mouse = initialMouseModel
  , keyboard = initialButtonModel
  }


type alias Model =
  { mouse : MouseModel
  , keyboard : ButtonModel
  }


initialMouseModel : MouseModel
initialMouseModel =
  { buttons = initialButtonModel
  , position = TrVector.zeroVector
  , previousPosition = TrVector.zeroVector
  , wheel = TrVector.zeroVector
  }


type alias MouseModel =
  { buttons : ButtonModel
  , position : TrVector.Vector
  , previousPosition : TrVector.Vector
  , wheel : TrVector.Vector
  }


constructButtonModel : TrInput.Buttons -> TrInput.Buttons -> ButtonModel
constructButtonModel previousDown newDown =
  { down = newDown
  , pressed =
      TrInput.computePressedButtonList
        previousDown
        newDown
  }


initialButtonModel : ButtonModel
initialButtonModel =
  { down = TrInput.initialButtonList
  , pressed = TrInput.initialButtonList
  }


type alias ButtonModel =
  { down : TrInput.Buttons
  , pressed : TrInput.Buttons
  }