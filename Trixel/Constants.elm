module Trixel.Constants where

import Keyboard exposing (KeyCode)

import Char


version : String
version =
  "0.1.1"


githubPage : String
githubPage =
  "https://github.com/GlenDC/trixel"


email : String
email =
  "contact@glendc.com"


footerSize : Float
footerSize =
  10


workspaceOffsetMoveSpeed : Float
workspaceOffsetMoveSpeed =
  80


sqrt3 : Float
sqrt3 =
  sqrt 3


maxTrixelRowCount : Float
maxTrixelRowCount =
  150


shortcutToggleGridVisibility : KeyCode
shortcutToggleGridVisibility =
  Char.toCode 'G'