module Trixel.Models.Model where

import Trixel.Models.Dom as TrDom
import Trixel.Models.Work as TrWork
import Trixel.Types.ColorScheme as TrColorScheme
import Trixel.Types.Color as TrColor


type alias ModelSignal = Signal Action


initialModel : Model
initialModel =
  { dom = TrDom.initialModel
  , work = TrWork.initialModel
  , colorScheme = TrColorScheme.nightColorScheme
  }


type alias Model =
  { dom : TrDom.Model
  , work : TrWork.Model
  , colorScheme : TrColorScheme.ColorScheme
  }


type Action
  = UpdateWork TrWork.Model
  | UpdateColorScheme TrColorScheme.ColorScheme


update : Action -> Model -> Model
update action model =
  case action of
    UpdateWork work ->
      { model
          | work <- work
          , dom <- TrDom.update work model.dom
      }

    UpdateColorScheme colorScheme ->
      { model | colorScheme <- colorScheme }