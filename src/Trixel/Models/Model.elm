module Trixel.Models.Model where

import Trixel.Models.Dom as TrDom
import Trixel.Models.Work.Model as TrWorkModel
import Trixel.Types.ColorScheme as TrColorScheme


type alias ModelSignal = Signal Action


initialModel : Model
initialModel =
  { dom = TrDom.initialModel
  , work = TrWorkModel.initialModel
  , colorScheme = TrColorScheme.nightColorScheme
  }


type alias Model =
  { dom : TrDom.Model
  , work : TrWorkModel.Model
  , colorScheme : TrColorScheme.ColorScheme
  }


type Action
  = None
  | UpdateWork TrWorkModel.Model
  | UpdateColorScheme TrColorScheme.ColorScheme


mailbox : Signal.Mailbox Action
mailbox =
  Signal.mailbox None

address : Signal.Address Action
address =
  mailbox.address

signal : Signal Action
signal =
  mailbox.signal


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

    None ->
      model