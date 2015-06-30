module Trixel.Types.JSGlue where


type alias GlueState =
  { cssInfo : CSSInfo
  }


emptyGlueState : GlueState
emptyGlueState =
  { cssInfo = emptyCSSInfo
  }


type alias CSSInfo =
  { colorPicker : String
  }

emptyCSSInfo : CSSInfo
emptyCSSInfo =
  { colorPicker = "ColorPicker"
  }