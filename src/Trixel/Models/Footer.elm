module Trixel.Models.Footer where

import Maybe exposing (..)


computeMessageFunction message =
  (\hover ->
    (if hover
      then ShowHelp message
      else HideHelp
    )
    |> Signal.message address
  )


initialModel : Model
initialModel =
  { help = Nothing
  }


type alias Model =
  { help : Maybe String
  }


type Action
  = None
  | ShowHelp String
  | HideHelp


mailbox : Signal.Mailbox Action
mailbox =
  Signal.mailbox None

address =
  mailbox.address

signal =
  Signal.foldp
    update
    initialModel
    mailbox.signal


update : Action -> Model -> Model
update action model =
  case action of
    ShowHelp message ->
      { model | help <- Just message }

    HideHelp ->
      { model | help <- Nothing }

    None ->
      model