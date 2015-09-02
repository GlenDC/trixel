module Trixel.Models.Work.Update where

import Trixel.Types.State as TrState

import Trixel.Models.Work.Model as TrWorkModel
import Trixel.Models.Work.Scratch as TrScratch


newDocument : TrWorkModel.Model -> TrWorkModel.Model
newDocument model =
  let scratch = model.scratch
      document = scratch.openDoc

  in { model
        | document <- Just (TrScratch.newDocument scratch)
        , state <- TrState.Default
        , scratch <-
            { scratch | openDoc <- TrScratch.initialDocumentSpecs }
     }


openDocument : TrWorkModel.Model -> TrWorkModel.Model
openDocument model =
  model -- todo


saveDocument : TrWorkModel.Model -> TrWorkModel.Model
saveDocument model =
  model -- todo
