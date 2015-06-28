module Trixel.Constants where

import EditorKeyboard exposing (KeyCode)
import MouseExtra exposing (ButtonCode)

import Char


version : String
version =
  "0.1.7"


githubRepositoryURL : String
githubRepositoryURL =
  "https://github.com/GlenDC/trixel"


newsletterSubscribeURL : String
newsletterSubscribeURL =
  "http://eepurl.com/brwmSn"


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


shortcutG : KeyCode
shortcutG =
  Char.toCode 'G'


shortcutR : KeyCode
shortcutR =
  Char.toCode 'R'


shortcutY : KeyCode
shortcutY =
  Char.toCode 'Y'


shortcutZ : KeyCode
shortcutZ =
  Char.toCode 'Z'


keyCodeShift : KeyCode
keyCodeShift =
  16


keyCodeCtrl : KeyCode
keyCodeCtrl =
  17


keyCodeAlt : KeyCode
keyCodeAlt =
  18


buttonCodeLeft : ButtonCode
buttonCodeLeft =
  0


buttonCodeMiddle : ButtonCode
buttonCodeMiddle =
  1

buttonCodeRight : ButtonCode
buttonCodeRight =
  2