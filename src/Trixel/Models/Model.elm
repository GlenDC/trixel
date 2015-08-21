module Trixel.Models.Model where

import Trixel.Models.Dom as TrDom
import Trixel.Models.Work.Model as TrWorkModel
import Trixel.Types.ColorScheme as TrColorScheme
import Trixel.Types.Color as TrColor
import Trixel.Types.State as TrState

import Random


type alias ModelSignal = Signal Action


initialModel : Model
initialModel =
  { dom = TrDom.initialModel
  , work = TrWorkModel.initialModel
  , colorScheme = TrColorScheme.nightColorScheme
  , seed = Random.initialSeed 0
  }


type alias Model =
  { dom : TrDom.Model
  , work : TrWorkModel.Model
  , colorScheme : TrColorScheme.ColorScheme
  , seed : Random.Seed
  }


type Action
  = None
  | UpdateWork TrWorkModel.Model
  | UpdateColorScheme TrColorScheme.ColorScheme


mailbox : Signal.Mailbox Action
mailbox =
  Signal.mailbox None

address =
  mailbox.address

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