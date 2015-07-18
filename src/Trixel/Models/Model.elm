module Trixel.Models.Model where

import Trixel.Models.Dom as TrDom
import Trixel.Models.Work.Model as TrWorkModel
import Trixel.Models.Footer as TrFooter
import Trixel.Types.ColorScheme as TrColorScheme
import Trixel.Types.Color as TrColor
import Trixel.Types.State as TrState


type alias ModelSignal = Signal Action


initialModel : Model
initialModel =
  { dom = TrDom.initialModel
  , work = TrWorkModel.initialModel
  , footer = TrFooter.initialModel
  , colorScheme = TrColorScheme.nightColorScheme
  }


type alias Model =
  { dom : TrDom.Model
  , work : TrWorkModel.Model
  , footer : TrFooter.Model
  , colorScheme : TrColorScheme.ColorScheme
  }


type Action
  = None
  | UpdateWork TrWorkModel.Model
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
      let work = model.work
      in 
        { model | work <- { work | state  <- state } }

    None ->
      model