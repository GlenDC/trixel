module Trixel.Types.Input where

import List


containsButton : Buttons -> Button -> Bool
containsButton buttons button =
  List.any
    ((==) button)
    buttons


shortcutPressed : Shortcut -> Buttons -> Buttons -> Bool
shortcutPressed shortcut optionButtons otherButtons =
  ( if List.isEmpty shortcut.otherKeys
      then False
      else List.all (containsButton otherButtons) shortcut.otherKeys
  ) &&
  ( if List.isEmpty shortcut.optionKeys
      then True
      else List.all (containsButton optionButtons) shortcut.optionKeys
  )



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


type alias Shortcut =
  { optionKeys : Buttons
  , otherKeys : Buttons
  }

type alias Shortcuts = List Shortcut


emptyShortcut : Shortcut
emptyShortcut =
  { optionKeys = []
  , otherKeys = []
  }


simpleShortcut : Buttons -> Shortcut
simpleShortcut buttons =
  { optionKeys = []
  , otherKeys = buttons
  }
