module Trixel.Types.Mouse where

import List


initialButtonList : Buttons
initialButtonList =
  []


leftButton : Button
leftButton =
  0 


middleButton : Button
middleButton =
  1


rightButton : Button
rightButton =
  2


type alias Button = Int

type alias Buttons = List Button