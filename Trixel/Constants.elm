module Trixel.Constants where

import EditorKeyboard exposing (KeyCode)
import MouseExtra exposing (ButtonCode)

import Char


version : String
version =
  "0.1.11"


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


workspaceOffsetMouseMoveSpeed : Float
workspaceOffsetMouseMoveSpeed =
  1


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


shortcutEqual : KeyCode
shortcutEqual =
  187


shortcutMinus : KeyCode
shortcutMinus =
  189


keyCodeShift : KeyCode
keyCodeShift =
  16


keyCodeCtrl : KeyCode
keyCodeCtrl =
  17


keyCodeSpace : KeyCode
keyCodeSpace =
  32


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