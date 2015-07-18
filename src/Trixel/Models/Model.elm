module Trixel.Models.Model where

import Trixel.Models.Dom as TrDom
import Trixel.Models.Work as TrWork
import Trixel.Models.Footer as TrFooter
import Trixel.Types.ColorScheme as TrColorScheme
import Trixel.Types.Color as TrColor
import Trixel.Types.State as TrState


type alias ModelSignal = Signal Action


initialModel : Model
initialModel =
  { dom = TrDom.initialModel
  , work = TrWork.initialModel
  , footer = TrFooter.initialModel
  , state = TrState.initialState
  , colorScheme = TrColorScheme.nightColorScheme
  }


type alias Model =
  { dom : TrDom.Model
  , work : TrWork.Model
  , footer : TrFooter.Model
  , state : TrState.State
  , colorScheme : TrColorScheme.ColorScheme
  }


type Action
  = None
  | UpdateWork TrWork.Model
  | UpdateColorScheme TrColorScheme.ColorScheme
  | UpdateFooter TrFooter.Model
  | UpdateState TrState.State


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

    UpdateFooter footer ->
      { model | footer <- footer }

    UpdateState state ->
      { model | state <- state }

    None ->
      model