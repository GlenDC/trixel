module Trixel.Types.Input where

import List


containsButton : Button -> Buttons -> Bool
containsButton button buttons =
  List.any
    ((==) button)
    buttons


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