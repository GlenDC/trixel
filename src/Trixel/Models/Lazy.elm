module Trixel.Models.Lazy where

import Trixel.Models.Model as TrModel
import Trixel.Models.Work.Model as TrWorkModel

import Math.Vector2 as Vector

-- Layout
import Trixel.Types.ColorScheme exposing (ColorScheme, nightColorScheme)
import Trixel.Models.Dom exposing (Tags)
import Trixel.Types.State exposing (State, initialState)
import Trixel.Models.Work.Scratch as TrScratch


{-| A Small module that provide specialized modules,
based on the global state. Its goal is to descope
Layout code to the bare minimum.
-}


layoutModel : TrModel.Model -> LayoutModel
layoutModel model =
  let (width, height) = Vector.toTuple model.work.dimensions
  in
    { colorScheme = model.colorScheme
    , width = width
    , height = height
    , isFullscreen = model.work.isFullscreen
    , hasDocument = TrWorkModel.hasDocument model.work
    , state = model.work.state
    , tags = model.dom.tags
    , scratch = model.work.scratch
    }


type alias LayoutModel =
  { colorScheme : ColorScheme
  , width : Float
  , height : Float
  , isFullscreen : Bool
  , hasDocument : Bool
  , state : State
  , tags : Tags
  , scratch : TrScratch.Model
  }


editorModel : TrModel.Model -> EditorModel
editorModel model =
  { tags = model.dom.tags
  }


type alias EditorModel =
  { tags : Tags
  }