module Trixel.Types.Input where

import List


initialButtonList : Buttons
initialButtonList =
  []


computePressedButtonList : Buttons -> Buttons -> Buttons
computePressedButtonList previousDown nowDown =
  List.filter
    (\oldButton ->
      List.foldl
        (\newButton result ->
          result && newButton /= oldButton)
        True
        nowDown)
    previousDown


type alias Button = Int

type alias Buttons = List Button