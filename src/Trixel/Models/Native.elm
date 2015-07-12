module Trixel.Models.Native
  ( initialModel
  , Model
  )
  where


initialModel : Model
initialModel =
  { identifiers =
      { workspace = "ws-canvas"
      , main = "uv-main"
      }
  }


type alias Model =
  { identifiers : Identifiers}


type alias Identifiers =
  { workspace : String
  , main : String
  }