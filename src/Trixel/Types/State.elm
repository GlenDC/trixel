module Trixel.Types.State where


initialState : State
initialState =
  Default


-- State defines the content of the toolbar and workspace
type State
  = Default
  | New
  | Open
  | Save
  | Help
  | About
  | Settings
  | Properties